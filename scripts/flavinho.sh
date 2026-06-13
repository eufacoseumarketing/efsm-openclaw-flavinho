#!/bin/bash
# Flavinho PC Resolve Helper — source this file
# Uso: source scripts/flavinho.sh
# ATUALIZADO 31/05/2026 — Plugin PC Resolve v1.2.2

PC_API="https://agent.pcresolve.com.br/pcresolve/api"
PC_KEY="pc-resolve-secret-key-change-me"
AUTH="-H x-api-key:$PC_KEY"

# Monta um JSON válido a partir de pares chave=valor via python3 (escaping correto
# de aspas, backtick, barra, acento, quebra de linha). Substitui a interpolação
# manual de string, que quebrava o payload quando o comando tinha aspas/backtick.
# Uso: _pc_json k1 v1 k2 v2 ...  → imprime {"k1":"v1","k2":"v2"} (bool/num auto)
_pc_json() {
  python3 -c '
import json, sys
a = sys.argv[1:]
d = {}
for i in range(0, len(a) - 1, 2):
    k, v = a[i], a[i + 1]
    if v in ("true", "false"):
        d[k] = (v == "true")
    else:
        try:
            d[k] = int(v)
        except ValueError:
            d[k] = v
print(json.dumps(d))
' "$@"
}

# Listar PCs online
pc_list() { curl -sk $AUTH "$PC_API/agents" | python3 -m json.tool; }

# Info de um PC (use nodeid ou nome: "DESKTOP-PDSLIJO")
pc_info() { curl -sk $AUTH "$PC_API/agents/$1" | python3 -m json.tool; }

# Executar comando CMD
pc_run() { curl -sk -X POST "$PC_API/run" $AUTH -H "Content-Type: application/json" -d "$(_pc_json deviceId "$1" command "$2")" | python3 -m json.tool; }

# Executar PowerShell
pc_ps() { curl -sk -X POST "$PC_API/run" $AUTH -H "Content-Type: application/json" -d "$(_pc_json deviceId "$1" command "$2" powershell true)" | python3 -m json.tool; }

# Screenshot — retorna a tela DESCRITA EM TEXTO (visão Gemini no plugin).
# text_only=true: o plugin descreve e NÃO devolve a imagem, então o Flavinho
# raciocina sobre texto e nunca manda imagem pro DeepSeek (text-only), que
# rejeitava o payload multimodal e derrubava a sessão. Sem precisar da tool 'image'.
# Fallback automático: se o plugin não tiver visão (sem 'tela'), salva o JPEG e
# aponta pra tool 'image', preservando o comportamento antigo.
pc_screenshot() {
  local dev="$1"
  local outfile="/data/.openclaw/workspace/workspace-flavinho/screenshot.jpg"
  local resp=$(curl -sk -X POST "$PC_API/screenshot" $AUTH -H "Content-Type: application/json" -d "$(_pc_json deviceId "$dev" text_only true)")
  local ok=$(echo "$resp" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('ok',False))" 2>/dev/null)
  if [ "$ok" != "True" ]; then
    echo "$resp" | python3 -m json.tool
    return 1
  fi
  local tela=$(echo "$resp" | python3 -c "import json,sys; print(json.load(sys.stdin).get('tela','') or '')" 2>/dev/null)
  if [ -n "$tela" ]; then
    echo "🖥️ Tela de $dev:"
    echo "$tela"
    return 0
  fi
  # Sem descrição (visão indisponível) → pedir imagem e usar a tool 'image'
  local resp2=$(curl -sk -X POST "$PC_API/screenshot" $AUTH -H "Content-Type: application/json" -d "$(_pc_json deviceId "$dev")")
  echo "$resp2" | python3 -c "
import json, sys, base64
d = json.load(sys.stdin)
data = d.get('data', '')
if data:
    img = base64.b64decode(data)
    open('$outfile', 'wb').write(img)
    print(json.dumps({'ok': True, 'file': '$outfile', 'size': len(img), 'method': d.get('method','unknown')}))
else:
    print(json.dumps({'ok': False, 'error': 'no image data in response'}))
"
  echo ""
  echo "📸 Screenshot salvo. Use a ferramenta 'image' para analisar: image file=$outfile"
}

# Clicar (x, y, button=left)
pc_click() {
  local btn="${4:-left}"
  curl -sk -X POST "$PC_API/click" $AUTH -H "Content-Type: application/json" -d "$(_pc_json deviceId "$1" x "$2" y "$3" button "$btn")" | python3 -m json.tool
}

# Digitar texto
pc_type() { curl -sk -X POST "$PC_API/type" $AUTH -H "Content-Type: application/json" -d "$(_pc_json deviceId "$1" text "$2")" | python3 -m json.tool; }

# Pressionar tecla
pc_key() { curl -sk -X POST "$PC_API/key" $AUTH -H "Content-Type: application/json" -d "$(_pc_json deviceId "$1" key "$2")" | python3 -m json.tool; }

# Abrir URL
pc_open() { curl -sk -X POST "$PC_API/open-url" $AUTH -H "Content-Type: application/json" -d "$(_pc_json deviceId "$1" url "$2")" | python3 -m json.tool; }

# Power
pc_power() { curl -sk -X POST "$PC_API/power" $AUTH -H "Content-Type: application/json" -d "$(_pc_json deviceId "$1" action "$2")" | python3 -m json.tool; }

echo "🔧 Flavinho PC Resolve tools loaded (v1.2.2)"
echo "   pc_list | pc_info <id> | pc_run <id> <cmd> | pc_ps <id> <cmd>"
echo "   pc_screenshot <id> | pc_click <id> <x> <y> [button]"
echo "   pc_type <id> <text> | pc_key <id> <key> | pc_open <id> <url>"
echo "   pc_power <id> <action>"
