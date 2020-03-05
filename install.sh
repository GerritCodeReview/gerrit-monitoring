#!/bin/bash -e

# Copyright (C) 2020 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

usage() {
    me=`basename "$0"`
    echo >&2 "Usage: $me [--output OUTPUT] [--dryrun] CONFIG"
    exit 1
}

while test $# -gt 0 ; do
  case "$1" in
  --output)
    shift
    OUTPUT=$1
    shift
    ;;

  --dryrun)
    DRYRUN="true"
    shift
    ;;

  *)
    break
  esac
done

test -z "$OUTPUT" && OUTPUT="$(dirname $0)/dist"

CONFIG=$1
test -z "$CONFIG" && usage

NAMESPACE=$(yq r $CONFIG namespace)
TMP_CONFIG=$OUTPUT/$(basename $CONFIG)

function updateOrInstall() {
  if test -n "$(helm ls -n $NAMESPACE --short | grep $1)"; then
    echo "upgrade"
  else
    echo "install"
  fi
}

function addHtpasswdEntryUnencrypted() {
  local COMPONENT=$1

  local HTPASSWD=$(htpasswd -nb \
    $(yq r $TMP_CONFIG $COMPONENT.username) \
    $(yq r $TMP_CONFIG $COMPONENT.password))

  yq w -i $TMP_CONFIG $COMPONENT.htpasswd $HTPASSWD
}

function addHtpasswdEntryEncrypted() {
  local COMPONENT=$1

  local HTPASSWD=$(htpasswd -nb \
    $(sops -d --extract "$COMPONENT['username']" $TMP_CONFIG) \
    $(sops -d --extract "$COMPONENT['password']" $TMP_CONFIG))

  sops --set "$COMPONENT['htpasswd'] \"$HTPASSWD\"" $TMP_CONFIG
}

function runYtt() {
  ytt \
    -f charts/namespace.yaml \
    -f charts/prometheus/ \
    -f charts/loki/ \
    -f charts/grafana/ \
    -f promtail/ \
    --output-directory $OUTPUT \
    --ignore-unknown-comments \
    -f $1
}

mkdir -p $OUTPUT/promtail
cp $CONFIG $TMP_CONFIG

# Fill in templates
if test -z "$(grep -o '^sops:$' $TMP_CONFIG)"; then
  addHtpasswdEntryUnencrypted loki
  addHtpasswdEntryUnencrypted prometheus.server
  echo -e "#@data/values\n---\n$(cat $TMP_CONFIG)" | runYtt -
  if [[ "$(yq r $CONFIG tls.skipVerify)" == "false" ]]; then
    echo "$(yq --tojson r $CONFIG tls.caCert | jq -r .)" > $OUTPUT/promtail/promtail.ca.crt
  fi
else
  addHtpasswdEntryEncrypted "['loki']" $TMP_CONFIG
  addHtpasswdEntryEncrypted "['prometheus']['server']" $TMP_CONFIG
  echo -e "#@data/values\n---\n$(sops -d $TMP_CONFIG)" | runYtt -
  if [[ "$(sops -d --extract "['tls']['skipVerify']" $CONFIG)" == "false" ]]; then
    echo "$(sops -d --extract "['tls']['caCert']" $CONFIG)" > $OUTPUT/promtail/promtail.ca.crt
  fi
fi

# split promtail files into file per host
csplit $OUTPUT/promtail.yaml \
  --prefix="$OUTPUT/promtail/promtail-" \
  --suffix-format='%02d.yaml' \
  --elide-empty-files \
  --suppress-matched \
  --silent \
  /---/ {*}
rm $OUTPUT/promtail.yaml

for file in $OUTPUT/promtail/*.yaml; do
  mv $file "$OUTPUT/promtail/promtail-$(yq r $file scrape_configs.[0].static_configs.[0].labels.host).yaml"
done

# Create configmap with dashboards
kubectl create configmap grafana-dashboards \
  --from-file=./dashboards \
  --dry-run=true \
  --namespace=$NAMESPACE \
  -o yaml > $OUTPUT/configuration/dashboards.cm.yaml

test -n "$DRYRUN" && exit 0

# download promtail
curl -L "https://github.com/grafana/loki/releases/download/v$(cat ./promtail/VERSION)/promtail-linux-amd64.zip" \
  -o $OUTPUT/promtail/promtail-linux-amd64.zip
unzip $OUTPUT/promtail/promtail-linux-amd64.zip -d $OUTPUT/promtail/
chmod a+x $OUTPUT/promtail/promtail-linux-amd64
rm $OUTPUT/promtail/promtail-linux-amd64.zip

# Install loose components
kubectl apply -f $OUTPUT/namespace.yaml
kubectl apply -f $OUTPUT/configuration
kubectl apply -f $OUTPUT/storage

# Add Loki helm repository
helm repo add loki https://grafana.github.io/loki/charts
helm repo update

# Install Prometheus
PROMETHEUS_CHART_NAME=prometheus-$NAMESPACE
helm $(updateOrInstall $PROMETHEUS_CHART_NAME) $PROMETHEUS_CHART_NAME \
  stable/prometheus \
  --version $(cat ./charts/prometheus/VERSION) \
  --values $OUTPUT/prometheus.yaml \
  --namespace $NAMESPACE

# Install Loki
LOKI_CHART_NAME=loki-$NAMESPACE
helm $(updateOrInstall $LOKI_CHART_NAME) $LOKI_CHART_NAME \
  loki/loki \
  --version $(cat ./charts/loki/VERSION) \
  --values $OUTPUT/loki.yaml \
  --namespace $NAMESPACE

# Install Grafana
GRAFANA_CHART_NAME=grafana-$NAMESPACE
helm $(updateOrInstall $GRAFANA_CHART_NAME) $GRAFANA_CHART_NAME \
  stable/grafana \
  --version $(cat ./charts/grafana/VERSION) \
  --values $OUTPUT/grafana.yaml \
  --namespace $NAMESPACE
