#!/bin/bash
# Executa comando PowerShell no dispositivo remoto
# v2 — usa arquivo temporário para JSON, elimina problemas de quoting
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/common.sh"

NAME=""
CMD=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --name) NAME="$2"; shift 2 ;;
    --cmd) CMD="$2"; shift 2 ;;
    *) echo "Uso: run.sh --name \"NOME\" --cmd \"COMANDO\""; exit 1 ;;
  esac
done

if [ -z "$NAME" ] || [ -z "$CMD" ]; then
  echo "❌ --name e --cmd obrigatórios"
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

echo "⚡ Executando em $NAME..."

# Write JSON payload to temp file — safest way to handle arbitrary commands
TMPFILE=$(mktemp)
python3 -c "
import json, sys
payload = {'deviceId': sys.argv[1], 'command': sys.argv[2], 'powershell': True}
with open(sys.argv[3], 'w') as f:
    json.dump(payload, f)
" "$NODE_ID" "$CMD" "$TMPFILE"

curl -s --connect-timeout 30 -X POST "$API_BASE/run" \
  -H "Content-Type: application/json" \
  -d "@$TMPFILE" \
  | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    if data.get('ok'):
        out = data.get('output','(sem output)')
        if len(out) > 5000:
            out = out[:5000] + '\n... (truncado)'
        print(out)
    else:
        print('❌', data.get('error','Erro desconhecido'))
except Exception as e:
    print('❌ Erro:', str(e))
" 2>&1

rm -f "$TMPFILE"
