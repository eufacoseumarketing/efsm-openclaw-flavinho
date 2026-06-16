#!/bin/bash
# screenshot.sh v5 — captura base64 + Gemini via API direta
# O agente OpenClaw (Flavinho) decide modelo e prompt
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/common.sh"
ENV_FILE="$SCRIPT_DIR/../../.env"
[ -f "$ENV_FILE" ] && source "$ENV_FILE"

DEVICE_NAME="${1:-${DEVICE_NAME:-}}"
SCALE="${2:-75}"
QUALITY="${3:-60}"
MODEL="${4:-gemini-2.5-flash}"

if [ -z "${DEVICE_NAME:-}" ]; then
    echo '{"error":"DEVICE_NAME required"}' >&2
    exit 1
fi

API_BASE="${API_BASE:-http://127.0.0.1:8080}"
TMP_SS="/tmp/pc-resolve-ss-$$.json"

# === Capturar screenshot ===
log "📸 Screenshot de $DEVICE_NAME (scale=$SCALE, q=$QUALITY)"
curl -s --max-time 55 -X POST "$API_BASE/api/screenshot" \
    -H "Content-Type: application/json" \
    -d "{\"deviceId\":\"$DEVICE_NAME\",\"scale\":$SCALE,\"quality\":$QUALITY}" > "$TMP_SS"

# Delegar todo processamento pro Python (evita escaping de base64 no shell)
python3 "$SCRIPT_DIR/screenshot_process.py" "$TMP_SS" "$MODEL" "${GEMINI_API_KEY:-}" "$NATIVE_W" "$NATIVE_H"
rm -f "$TMP_SS"
