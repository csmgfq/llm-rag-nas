#!/usr/bin/env bash
set -euo pipefail
LOCAL_GRAFANA_PORT="${LOCAL_GRAFANA_PORT:-13000}"
REMOTE_MAC_PORT="${REMOTE_MAC_PORT:-11300}"
SSH_PORT="${SSH_PORT:-22}"
MAC_SSH_TARGETS="${MAC_SSH_TARGETS:-user@example-host}"
ROOT="$(cd "$(dirname "$0")" && pwd)"
LOG_DIR="${LOG_DIR:-$ROOT/logs}"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/reverse_grafana_tunnel.log"
while true; do
  for target in $MAC_SSH_TARGETS; do
    echo "[$(date '+%F %T')] trying target=$target" | tee -a "$LOG_FILE"
    ssh -o ExitOnForwardFailure=yes -o ServerAliveInterval=30 -o ServerAliveCountMax=3 -o StrictHostKeyChecking=accept-new -N -R "${REMOTE_MAC_PORT}:127.0.0.1:${LOCAL_GRAFANA_PORT}" "$target" -p "$SSH_PORT" || true
    echo "[$(date '+%F %T')] target=$target exited" | tee -a "$LOG_FILE"
    sleep 2
  done
  sleep 3
done
