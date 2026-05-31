#!/bin/bash
# Flavinho PC Resolve Helper — source this file
# Uso: source scripts/flavinho.sh
# ATUALIZADO 31/05/2026 — Plugin PC Resolve v1.2.2

PC_API="https://agent.pcresolve.com.br/pcresolve/api"
PC_KEY="pc-resolve-secret-key-change-me"
AUTH="-H x-api-key:$PC_KEY"

# Listar PCs online
pc_list() { curl -sk $AUTH "$PC_API/agents" | python3 -m json.tool; }

# Info de um PC (use nodeid ou nome: "DESKTOP-PDSLIJO")
pc_info() { curl -sk $AUTH "$PC_API/agents/$1" | python3 -m json.tool; }

# Executar comando CMD
pc_run() { curl -sk -X POST "$PC_API/run" $AUTH -H "Content-Type: application/json" -d "{\"deviceId\":\"$1\",\"command\":\"$2\"}" | python3 -m json.tool; }

# Executar PowerShell
pc_ps() { curl -sk -X POST "$PC_API/run" $AUTH -H "Content-Type: application/json" -d "{\"deviceId\":\"$1\",\"command\":\"$2\",\"powershell\":true}" | python3 -m json.tool; }

# Screenshot
pc_screenshot() { curl -sk -X POST "$PC_API/screenshot" $AUTH -H "Content-Type: application/json" -d "{\"deviceId\":\"$1\"}" | python3 -m json.tool; }

# Clicar (x, y, button=left)
pc_click() {
  local btn="${4:-left}"
  curl -sk -X POST "$PC_API/click" $AUTH -H "Content-Type: application/json" -d "{\"deviceId\":\"$1\",\"x\":$2,\"y\":$3,\"button\":\"$btn\"}" | python3 -m json.tool
}

# Digitar texto
pc_type() { curl -sk -X POST "$PC_API/type" $AUTH -H "Content-Type: application/json" -d "{\"deviceId\":\"$1\",\"text\":\"$2\"}" | python3 -m json.tool; }

# Pressionar tecla
pc_key() { curl -sk -X POST "$PC_API/key" $AUTH -H "Content-Type: application/json" -d "{\"deviceId\":\"$1\",\"key\":\"$2\"}" | python3 -m json.tool; }

# Abrir URL
pc_open() { curl -sk -X POST "$PC_API/open-url" $AUTH -H "Content-Type: application/json" -d "{\"deviceId\":\"$1\",\"url\":\"$2\"}" | python3 -m json.tool; }

# Power
pc_power() { curl -sk -X POST "$PC_API/power" $AUTH -H "Content-Type: application/json" -d "{\"deviceId\":\"$1\",\"action\":\"$2\"}" | python3 -m json.tool; }

echo "🔧 Flavinho PC Resolve tools loaded (v1.2.2)"
echo "   pc_list | pc_info <id> | pc_run <id> <cmd> | pc_ps <id> <cmd>"
echo "   pc_screenshot <id> | pc_click <id> <x> <y> [button]"
echo "   pc_type <id> <text> | pc_key <id> <key> | pc_open <id> <url>"
echo "   pc_power <id> <action>"
