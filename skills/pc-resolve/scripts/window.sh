#!/bin/bash
# Maximiza/minimiza/restaura janela no dispositivo remoto via KVM
# v1 — usa endpoint /api/window (KVM, nao usa slot de comandos)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/common.sh"

NAME=""
ACTION="maximize"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --name) NAME="$2"; shift 2 ;;
    --action) ACTION="$2"; shift 2 ;;
    *) echo "Uso: window.sh --name NOME [--action maximize|minimize|restore]"; exit 1 ;;
  esac
done

[ -z "$NAME" ] && { echo "❌ --name obrigatório"; exit 1; }

NODE_ID=$(resolve_device "$NAME")
[ "$NODE_ID" = "NOT_FOUND" ] && { echo "❌ $NAME não encontrado"; exit 1; }

# Safe JSON via temp file
TMPFILE=$(mktemp)
python3 -c "
import json, sys
payload = {'deviceId': sys.argv[1], 'action': sys.argv[2]}
with open(sys.argv[3], 'w') as f:
    json.dump(payload, f)
" "$NODE_ID" "$ACTION" "$TMPFILE"

curl -s --connect-timeout 10 -X POST "$API_BASE/window" \
  -H "Content-Type: application/json" \
  -d "@$TMPFILE" \
  | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    print('✅ Janela maximizada!' if data.get('ok') else '❌ ' + data.get('error','?'))
except Exception as e:
    print('❌ Erro:', str(e))
" 2>&1

rm -f "$TMPFILE"
