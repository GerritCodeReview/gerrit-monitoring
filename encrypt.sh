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
    echo >&2 "Usage: $me [--email EMAIL] [--fingerprint FINGERPRINT] CONFIG"
    exit 1
}

while test $# -gt 0 ; do
  case "$1" in
  --email)
    shift
    EMAIL=$1
    shift
    ;;

  --fingerprint)
    shift
    FINGERPRINT=$1
    shift
    ;;

  *)
    break
  esac
done

CONFIG=$1
test -z "$CONFIG" && usage

if test -z $FINGERPRINT; then
  test -z $EMAIL && usage
  FINGERPRINT=$(gpg --fingerprint "$EMAIL" | \
    grep pub -A 1 | \
    grep -v pub | \
    sed s/\ //g)
fi

sops \
  --encrypt \
  --in-place \
  --encrypted-regex '(password|htpasswd|cert|key|apiUrl|caCert|secret|accessToken)$' \
  --pgp $FINGERPRINT \
  $CONFIG
