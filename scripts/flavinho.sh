#!/bin/bash
# Flavinho PC Resolve Helper — source this file
# Uso: source scripts/flavinho.sh

PC_API="https://agent.pcresolve.com.br/api"

# Listar PCs
pc_list() { curl -sk "$PC_API/agents" | python3 -m json.tool; }

# Info de um PC
pc_info() { curl -sk "$PC_API/agents/$1" | python3 -m json.tool; }

# Executar comando CMD
pc_run() { curl -sk -X POST "$PC_API/run" -H "Content-Type: application/json" -d "{\"deviceId\":\"$1\",\"command\":\"$2\"}" | python3 -m json.tool; }

# Executar PowerShell
pc_ps() { curl -sk -X POST "$PC_API/powershell" -H "Content-Type: application/json" -d "{\"deviceId\":\"$1\",\"command\":\"$2\"}" | python3 -m json.tool; }

# Screenshot
pc_screenshot() { curl -sk -X POST "$PC_API/screenshot" -H "Content-Type: application/json" -d "{\"deviceId\":\"$1\"}" | python3 -m json.tool; }

# Clicar (x, y, button=left)
pc_click() {
  local btn="${4:-left}"
  curl -sk -X POST "$PC_API/click" -H "Content-Type: application/json" -d "{\"deviceId\":\"$1\",\"x\":$2,\"y\":$3,\"button\":\"$btn\"}" | python3 -m json.tool
}

# Digitar texto
pc_type() { curl -sk -X POST "$PC_API/type" -H "Content-Type: application/json" -d "{\"deviceId\":\"$1\",\"text\":\"$2\"}" | python3 -m json.tool; }

# Pressionar tecla
pc_key() { curl -sk -X POST "$PC_API/key" -H "Content-Type: application/json" -d "{\"deviceId\":\"$1\",\"key\":\"$2\"}" | python3 -m json.tool; }

# Power
pc_power() { curl -sk -X POST "$PC_API/power" -H "Content-Type: application/json" -d "{\"deviceId\":\"$1\",\"action\":\"$2\"}" | python3 -m json.tool; }

echo "🔧 Flavinho PC Resolve tools loaded"
echo "   pc_list | pc_info <id> | pc_run <id> <cmd> | pc_ps <id> <cmd>"
echo "   pc_screenshot <id> | pc_click <id> <x> <y> [button]"
echo "   pc_type <id> <text> | pc_key <id> <key> | pc_power <id> <action>"
