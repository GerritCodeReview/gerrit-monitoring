#!/bin/bash -e

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
  --encrypted-regex '(password|htpasswd|cert|key|apiUrl|caCert)$' \
  --pgp $FINGERPRINT \
  $CONFIG
