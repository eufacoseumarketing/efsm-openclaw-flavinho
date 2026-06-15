#!/bin/bash
SECS=""
while [[ $# -gt 0 ]]; do
  case "$1" in --seconds) SECS="$2"; shift 2 ;; -*) shift ;; *) shift ;; esac
done
[ -z "$SECS" ] && { echo "Uso: sleep.sh --seconds NUM"; exit 1; }
echo "⏳ Aguardando ${SECS}s..."
sleep "$SECS"
echo "✅ Pronto!"
