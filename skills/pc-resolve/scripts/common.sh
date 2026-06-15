#!/bin/bash
# PC Resolve Common — resolve nome do dispositivo e faz chamadas à API
API_BASE="https://agent.pcresolve.com.br/api"

# Resolve device name → nodeId
resolve_device() {
  local name="$1"
  curl -s --connect-timeout 5 "$API_BASE/agents" | python3 -c "
import json, sys
agents = json.load(sys.stdin)
for a in agents:
    if a.get('name','').lower() == '$name'.lower():
        print(a['id'])
        sys.exit(0)
# Fallback: partial match
for a in agents:
    if '$name'.lower() in a.get('name','').lower():
        print(a['id'])
        sys.exit(0)
print('NOT_FOUND')
sys.exit(1)
" 2>/dev/null
}

# Check if device is online
device_online() {
  local name="$1"
  curl -s --connect-timeout 5 "$API_BASE/agents" | python3 -c "
import json, sys
agents = json.load(sys.stdin)
for a in agents:
    if a.get('name','').lower() == '$name'.lower():
        print('true' if a.get('online') else 'false')
        sys.exit(0)
print('false')
" 2>/dev/null
}
