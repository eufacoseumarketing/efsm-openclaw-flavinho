#!/bin/bash
# Auto-detect secrets path (funciona em qq ambiente)
if [ -d "/data/.openclaw/workspace/.secrets" ]; then
  SECRETS_DIR="/data/.openclaw/workspace/.secrets"
elif [ -d "$HOME/.openclaw/workspace/workspace-ananias/.secrets" ]; then
  SECRETS_DIR="$HOME/.openclaw/workspace/workspace-ananias/.secrets"
elif [ -d "/home/node/.openclaw/workspace/workspace-ananias/.secrets" ]; then
  SECRETS_DIR="/home/node/.openclaw/workspace/workspace-ananias/.secrets"
else
  SECRETS_DIR="$(dirname "$(readlink -f "$0")")/../.secrets"
fi
export SECRETS_DIR
