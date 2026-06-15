#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/common.sh"
NAME=""; X=""; Y=""
while [[ $# -gt 0 ]]; do
  case "$1" in --name) NAME="$2"; shift 2 ;; --x) X="$2"; shift 2 ;; --y) Y="$2"; shift 2 ;; *) echo "Uso: click.sh --name NOME --x NUM --y NUM"; exit 1 ;; esac
done
[ -z "$NAME" ] || [ -z "$X" ] && { echo "❌ --name, --x, --y obrigatórios"; exit 1; }
NODE_ID=$(resolve_device "$NAME")
[ "$NODE_ID" = "NOT_FOUND" ] && { echo "❌ $NAME não encontrado"; exit 1; }
curl -s --connect-timeout 10 -X POST "$API_BASE/click" -H "Content-Type: application/json" \
  -d "{\"deviceId\":\"$NODE_ID\",\"x\":$X,\"y\":$Y}" | python3 -c "
import json,sys; d=json.load(sys.stdin); print('✅ Click!' if d.get('ok') else '❌ '+d.get('error','?'))" 2>&1
