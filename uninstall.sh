#!/bin/bash -e

usage() {
    me=`basename "$0"`
    echo >&2 "Usage: $me CONFIG"
    exit 1
}

test -z "$1" && usage
CONFIG=$1

NAMESPACE=$(yq r $CONFIG namespace)

function removeHelmDeployment() {
  read -p "This will remove the deployment $1-$NAMESPACE. Continue (y/n)? " response
  if [[ "$response" == "y" ]]; then
    helm uninstall $1-$NAMESPACE -n $NAMESPACE || true
  fi
}

removeHelmDeployment grafana
removeHelmDeployment loki
removeHelmDeployment prometheus

read -p "This will remove the namespace $NAMESPACE. Continue (y/n)? " response
if [[ "$response" == "y" ]]; then
  kubectl delete ns $NAMESPACE
fi
