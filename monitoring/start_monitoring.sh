#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if docker info >/dev/null 2>&1; then
  docker compose up -d
else
  echo "Current user has no Docker permission, trying sudo..."
  sudo docker compose up -d
fi

echo "Monitoring stack started."
echo "Grafana: http://127.0.0.1:3000 (admin/admin123)"
echo "Prometheus: http://127.0.0.1:9090"
