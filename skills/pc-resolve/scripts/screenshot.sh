#!/bin/bash
# screenshot.sh v5.1 — captura base64 + Gemini via API direta
# O agente OpenClaw (Flavinho) decide modelo e prompt
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Carregar .env (GEMINI_API_KEY, etc)
ENV_FILE="$SCRIPT_DIR/../../../.env"
[ -f "$ENV_FILE" ] && source "$ENV_FILE"

# Função de log simples
log() { echo "[screenshot] $*" >&2; }

# Argumentos
DEVICE_NAME="${1:-}"
SCALE="${2:-75}"
QUALITY="${3:-60}"
MODEL="${4:-gemini-2.5-flash}"

if [ -z "$DEVICE_NAME" ]; then
    echo "Uso: screenshot.sh <NOME_DO_PC> [scale] [quality] [model]"
    echo "  scale: 1-100 (default 75)"
    echo "  quality: 1-100 (default 60)"
    echo "  model: gemini-2.5-flash | gemini-2.5-pro (default flash)"
    exit 1
fi

# Resolver nome → nodeId
NODE_ID=$(resolve_device "$DEVICE_NAME")
if [ "$NODE_ID" = "NOT_FOUND" ] || [ -z "$NODE_ID" ]; then
    log "❌ Dispositivo \"$DEVICE_NAME\" não encontrado"
    echo "❌ Dispositivo \"$DEVICE_NAME\" não encontrado"
    exit 1
fi

# Verificar online
ONLINE=$(device_online "$DEVICE_NAME")
if [ "$ONLINE" != "true" ]; then
    log "❌ $DEVICE_NAME está offline"
    echo "❌ $DEVICE_NAME está offline"
    exit 1
fi

TMP_SS="/tmp/pc-resolve-ss-$$.json"

# === Capturar screenshot ===
log "📸 Screenshot de $DEVICE_NAME (scale=$SCALE, q=$QUALITY)"
curl -s --max-time 55 -X POST "$API_BASE/screenshot" \
    -H "Content-Type: application/json" \
    -d "{\"deviceId\":\"$NODE_ID\",\"scale\":$SCALE,\"quality\":$QUALITY}" > "$TMP_SS"

# Delegar todo processamento pro Python (variáveis opcionais com defaults)
python3 "$SCRIPT_DIR/screenshot_process.py" "$TMP_SS" "$MODEL" "${GEMINI_API_KEY:-}" "${NATIVE_W:-0}" "${NATIVE_H:-0}"
rm -f "$TMP_SS"
