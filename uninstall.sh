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
