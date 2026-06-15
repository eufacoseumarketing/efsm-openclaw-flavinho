#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/common.sh"
NAME=""; TEXT=""
while [[ $# -gt 0 ]]; do
  case "$1" in --name) NAME="$2"; shift 2 ;; --text) TEXT="$2"; shift 2 ;; *) echo "Uso: type.sh --name NOME --text TEXTO"; exit 1 ;; esac
done
[ -z "$NAME" ] && { echo "❌ --name e --text obrigatórios"; exit 1; }
NODE_ID=$(resolve_device "$NAME")
[ "$NODE_ID" = "NOT_FOUND" ] && { echo "❌ $NAME não encontrado"; exit 1; }
# JSON seguro via temp file — texto arbitrário (aspas, acentos, símbolos) não quebra o payload
TMPFILE=$(mktemp)
python3 -c "
import json, sys
with open(sys.argv[3], 'w') as f:
    json.dump({'deviceId': sys.argv[1], 'text': sys.argv[2]}, f)
" "$NODE_ID" "$TEXT" "$TMPFILE"
curl -s --connect-timeout 10 -X POST "$API_BASE/type" -H "Content-Type: application/json" \
  -d "@$TMPFILE" | python3 -c "
import json,sys; d=json.load(sys.stdin); print('✅ Digitado!' if d.get('ok') else '❌ '+d.get('error','?'))" 2>&1
rm -f "$TMPFILE"
