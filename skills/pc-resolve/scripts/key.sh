#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/common.sh"
NAME=""; KEY=""
while [[ $# -gt 0 ]]; do
  case "$1" in --name) NAME="$2"; shift 2 ;; --key) KEY="$2"; shift 2 ;; *) echo "Uso: key.sh --name NOME --key TECLA"; exit 1 ;; esac
done
[ -z "$NAME" ] && { echo "❌ --name e --key obrigatórios"; exit 1; }
NODE_ID=$(resolve_device "$NAME")
[ "$NODE_ID" = "NOT_FOUND" ] && { echo "❌ $NAME não encontrado"; exit 1; }
curl -s --connect-timeout 10 -X POST "$API_BASE/key" -H "Content-Type: application/json" \
  -d "{\"deviceId\":\"$NODE_ID\",\"key\":\"$KEY\"}" | python3 -c "
import json,sys; d=json.load(sys.stdin); print('✅ Tecla enviada!' if d.get('ok') else '❌ '+d.get('error','?'))" 2>&1
