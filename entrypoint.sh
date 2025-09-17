#!/usr/bin/env bash
set -euo pipefail

mkdir -p /run/1c

: "${IB_SERVER}"
: "${IB_NAME}"

TEMPLATE=/var/www/base/default.vrd.tpl
OUT=/run/1c/default.vrd

if [ -f "$TEMPLATE" ]; then
  envsubst '${IB_SERVER} ${IB_NAME}' < "$TEMPLATE" > "$OUT"
else
  echo "VRD template not found: $TEMPLATE" >&2
  exit 1
fi

exec /usr/sbin/apache2ctl -D FOREGROUND


