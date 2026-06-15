#!/bin/bash
# Tira screenshot de um dispositivo
# v2 — corrige campo da API (data, não image_base64)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/common.sh"

NAME=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --name) NAME="$2"; shift 2 ;;
    *) echo "Uso: screenshot.sh --name \"NOME_DO_PC\""; exit 1 ;;
  esac
done

if [ -z "$NAME" ]; then
  echo "❌ Especifique --name"
  exit 1
fi

NODE_ID=$(resolve_device "$NAME")
if [ "$NODE_ID" = "NOT_FOUND" ] || [ -z "$NODE_ID" ]; then
  echo "❌ Dispositivo \"$NAME\" não encontrado"
  exit 1
fi

ONLINE=$(device_online "$NAME")
if [ "$ONLINE" != "true" ]; then
  echo "❌ $NAME está offline"
  exit 1
fi

echo "📸 Tirando screenshot de $NAME..."

# Safe JSON via temp file
TMPFILE=$(mktemp)
python3 -c "
import json, sys
payload = {'deviceId': sys.argv[1]}
with open(sys.argv[2], 'w') as f:
    json.dump(payload, f)
" "$NODE_ID" "$TMPFILE"

RESP=$(curl -s --connect-timeout 15 -X POST "$API_BASE/screenshot" \
  -H "Content-Type: application/json" \
  -d "@$TMPFILE" 2>&1)

rm -f "$TMPFILE"

echo "$RESP" | python3 -c "
import json, sys, base64
try:
    data = json.load(sys.stdin)
    if data.get('ok'):
        # API returns image in 'data' field, not 'image_base64'
        img = data.get('image_base64') or data.get('data', '')
        if img:
            with open('screenshot.jpg','wb') as f:
                f.write(base64.b64decode(img))
            print('✅ Screenshot salvo em screenshot.jpg')
        else:
            print('❌ Screenshot retornou mas sem imagem')
            print('DEBUG keys:', list(data.keys()))
    else:
        print('❌', data.get('error','Erro desconhecido'))
except Exception as e:
    print('❌ Erro ao decodificar resposta:', str(e)[:200])
" 2>&1
