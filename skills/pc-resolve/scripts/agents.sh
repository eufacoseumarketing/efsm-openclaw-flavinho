#!/bin/bash
# Lista agentes do PC Resolve
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/common.sh"

curl -s --connect-timeout 5 "$API_BASE/agents" | python3 -c "
import json, sys
agents = json.load(sys.stdin)
print(f'=== {len(agents)} agentes no PC Resolve ===')
print()
for a in agents:
    status = '🟢 ONLINE' if a.get('online') else '🔴 offline'
    name = a.get('name','?')
    os = a.get('os','?')
    ip = a.get('ip','?')
    print(f'{status} | {name}')
    print(f'         OS: {os}')
    print(f'         IP: {ip}')
    print()
"
