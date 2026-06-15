#!/bin/bash
# Tira screenshot de um dispositivo — modo texto (text_only=true)
# v3 — text_only: plugin chama Gemini server-side, retorna descrição textual
#      Sem imagem = sem risco de crash no DeepSeek, menos tokens
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

echo "📸 Analisando tela de $NAME..."

# Safe JSON via temp file — text_only=true: plugin descreve via Gemini, sem base64
TMPFILE=$(mktemp)
python3 -c "
import json, sys
payload = {'deviceId': sys.argv[1], 'text_only': True}
with open(sys.argv[2], 'w') as f:
    json.dump(payload, f)
" "$NODE_ID" "$TMPFILE"

RESP=$(curl -s --connect-timeout 25 -X POST "$API_BASE/screenshot" \
  -H "Content-Type: application/json" \
  -d "@$TMPFILE" 2>&1)

rm -f "$TMPFILE"

echo "$RESP" | python3 -c "
import json, sys, base64

try:
    data = json.load(sys.stdin)
    
    # text_only mode: plugin retorna a descrição no campo 'tela'
    # (description/text mantidos como alternativas por robustez)
    desc = data.get('tela') or data.get('description') or data.get('text')
    if desc:
        print('🖥️ ' + desc)
    elif data.get('ok') and data.get('data'):
        # Fallback: plugin não suporta text_only, salvamos JPEG
        img = data.get('data', '')
        with open('screenshot.jpg','wb') as f:
            f.write(base64.b64decode(img))
        print('✅ Screenshot salvo em screenshot.jpg (modo imagem)')
    elif data.get('error') == 'no-display':
        print('❌ Máquina sem monitor detectado (display desligado ou sessão bloqueada)')
    elif data.get('error'):
        print('❌ ' + data.get('error'))
    else:
        print('❌ Resposta inesperada do plugin')
        print('DEBUG keys:', list(data.keys()))
except Exception as e:
    print('❌ Erro ao processar resposta:', str(e)[:300])
" 2>&1
