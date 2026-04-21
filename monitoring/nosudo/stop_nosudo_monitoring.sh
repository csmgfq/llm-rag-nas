#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
RUN_DIR="$ROOT/run"

for name in grafana prometheus lm_exporter; do
  pid_file="$RUN_DIR/${name}.pid"
  if [[ -f "$pid_file" ]]; then
    pid="$(cat "$pid_file")"
    if [[ -n "$pid" ]] && kill -0 "$pid" >/dev/null 2>&1; then
      kill "$pid" || true
      echo "Stopped $name (pid=$pid)"
    else
      echo "$name already stopped"
    fi
    rm -f "$pid_file"
  else
    echo "No pid file for $name"
  fi
done
