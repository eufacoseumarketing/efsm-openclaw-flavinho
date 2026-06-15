#!/bin/bash
# Lê ou escreve na área de transferência do dispositivo remoto
# v1 — usa endpoints /api/clipboard-get e /api/clipboard-set
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/common.sh"

NAME=""
ACTION=""
TEXT=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --name) NAME="$2"; shift 2 ;;
    --action) ACTION="$2"; shift 2 ;;
    --text) TEXT="$2"; shift 2 ;;
    *) echo "Uso: clipboard.sh --name NOME --action get|set [--text TEXTO]"; exit 1 ;;
  esac
done

[ -z "$NAME" ] && { echo "❌ --name obrigatório"; exit 1; }
[ -z "$ACTION" ] && { echo "❌ --action obrigatório (get ou set)"; exit 1; }

NODE_ID=$(resolve_device "$NAME")
[ "$NODE_ID" = "NOT_FOUND" ] && { echo "❌ $NAME não encontrado"; exit 1; }

ONLINE=$(device_online "$NAME")
[ "$ONLINE" != "true" ] && { echo "❌ $NAME está offline"; exit 1; }

if [ "$ACTION" = "get" ]; then
  # Safe JSON via temp file
  TMPFILE=$(mktemp)
  python3 -c "
import json, sys
payload = {'deviceId': sys.argv[1]}
with open(sys.argv[2], 'w') as f:
    json.dump(payload, f)
" "$NODE_ID" "$TMPFILE"

  curl -s --connect-timeout 10 -X POST "$API_BASE/clipboard-get" \
    -H "Content-Type: application/json" \
    -d "@$TMPFILE" \
    | python3 -c "
import json, sys, base64
try:
    data = json.load(sys.stdin)
    if data.get('ok'):
        text = data.get('text','')
        # Se veio em base64, decodifica
        if data.get('encoding') == 'base64' and text:
            text = base64.b64decode(text).decode('utf-8', errors='replace')
        if text:
            if len(text) > 3000:
                text = text[:3000] + '\n... (truncado)'
            print(text)
        else:
            print('(clipboard vazio)')
    else:
        print('❌', data.get('error','Erro desconhecido'))
except Exception as e:
    print('❌ Erro:', str(e))
" 2>&1

  rm -f "$TMPFILE"

elif [ "$ACTION" = "set" ]; then
  [ -z "$TEXT" ] && { echo "❌ --text obrigatório para --action set"; exit 1; }

  TMPFILE=$(mktemp)
  python3 -c "
import json, sys, base64
payload = {
    'deviceId': sys.argv[1],
    'text': sys.argv[2],
    'encoding': 'base64'
}
with open(sys.argv[3], 'w') as f:
    json.dump(payload, f)
" "$NODE_ID" "$TEXT" "$TMPFILE"

  curl -s --connect-timeout 10 -X POST "$API_BASE/clipboard-set" \
    -H "Content-Type: application/json" \
    -d "@$TMPFILE" \
    | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    print('✅ Clipboard atualizado!' if data.get('ok') else '❌ ' + data.get('error','?'))
except Exception as e:
    print('❌ Erro:', str(e))
" 2>&1

  rm -f "$TMPFILE"

else
  echo "❌ --action deve ser 'get' ou 'set'"
  exit 1
fi
