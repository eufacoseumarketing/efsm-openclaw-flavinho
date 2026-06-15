#!/bin/bash
# Abre uma URL no navegador do dispositivo remoto
# v2 — usa arquivo temporário para JSON seguro
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/common.sh"

NAME=""; URL=""
while [[ $# -gt 0 ]]; do
  case "$1" in --name) NAME="$2"; shift 2 ;; --url) URL="$2"; shift 2 ;; *) echo "Uso: open-url.sh --name NOME --url URL"; exit 1 ;; esac
done

[ -z "$NAME" ] && { echo "❌ --name e --url obrigatórios"; exit 1; }
[ -z "$URL" ] && { echo "❌ --url obrigatório"; exit 1; }

NODE_ID=$(resolve_device "$NAME")
[ "$NODE_ID" = "NOT_FOUND" ] && { echo "❌ $NAME não encontrado"; exit 1; }

# Safe JSON via temp file
TMPFILE=$(mktemp)
python3 -c "
import json, sys
payload = {'deviceId': sys.argv[1], 'url': sys.argv[2]}
with open(sys.argv[3], 'w') as f:
    json.dump(payload, f)
" "$NODE_ID" "$URL" "$TMPFILE"

curl -s --connect-timeout 10 -X POST "$API_BASE/open-url" \
  -H "Content-Type: application/json" \
  -d "@$TMPFILE" \
  | python3 -c "
import json, sys
try:
    d = json.load(sys.stdin)
    print('✅ URL aberta!' if d.get('ok') else '❌ ' + d.get('error','?'))
except Exception as e:
    print('❌ Erro:', str(e))
" 2>&1

rm -f "$TMPFILE"
