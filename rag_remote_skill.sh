#!/usr/bin/env bash
set -euo pipefail

MODE=""
SERVER_HOST=""
SERVER_PORT=""
SERVER_USER=""
PC_HOST=""
PC_PORT=""
PC_USER=""
NAS_MOUNT_PATH=""
LMSTUDIO_BASE_URL="http://127.0.0.1:1234/v1"
QDRANT_URL="http://127.0.0.1:6333"
RAG_ROOT="~/rag"

usage() {
  cat <<'EOF'
Usage:
  ./rag_remote_skill.sh --mode <check|bootstrap> \
    --server-host <host> --server-port <port> --server-user <user> \
    --pc-host <host> --pc-port <port> --pc-user <user> \
    --nas-mount <path> [--lmstudio-base-url <url>] [--qdrant-url <url>] [--rag-root <path>]
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode) MODE="$2"; shift 2 ;;
    --server-host) SERVER_HOST="$2"; shift 2 ;;
    --server-port) SERVER_PORT="$2"; shift 2 ;;
    --server-user) SERVER_USER="$2"; shift 2 ;;
    --pc-host) PC_HOST="$2"; shift 2 ;;
    --pc-port) PC_PORT="$2"; shift 2 ;;
    --pc-user) PC_USER="$2"; shift 2 ;;
    --nas-mount) NAS_MOUNT_PATH="$2"; shift 2 ;;
    --lmstudio-base-url) LMSTUDIO_BASE_URL="$2"; shift 2 ;;
    --qdrant-url) QDRANT_URL="$2"; shift 2 ;;
    --rag-root) RAG_ROOT="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1"; usage; exit 1 ;;
  esac
done

if [[ -z "$MODE" || -z "$SERVER_HOST" || -z "$SERVER_PORT" || -z "$SERVER_USER" || -z "$PC_HOST" || -z "$PC_PORT" || -z "$PC_USER" || -z "$NAS_MOUNT_PATH" ]]; then
  usage
  exit 1
fi

if [[ "$MODE" != "check" && "$MODE" != "bootstrap" ]]; then
  echo "Invalid mode: $MODE"
  exit 1
fi

ssh_run() {
  local host="$1"
  local port="$2"
  local user="$3"
  local cmd="$4"
  ssh -o BatchMode=yes -o ConnectTimeout=8 -p "$port" "$user@$host" "$cmd"
}

echo "[Phase A] Connectivity checks"
ssh_run "$SERVER_HOST" "$SERVER_PORT" "$SERVER_USER" "hostname; lms --version; lms ls"
ssh_run "$PC_HOST" "$PC_PORT" "$PC_USER" "hostname; python3 --version; mkdir -p $RAG_ROOT"

echo "[Phase B] Model service checks"
ssh_run "$SERVER_HOST" "$SERVER_PORT" "$SERVER_USER" "lms ls"
ssh_run "$SERVER_HOST" "$SERVER_PORT" "$SERVER_USER" "curl -sS http://127.0.0.1:1234/v1/models | head"

if [[ "$MODE" == "bootstrap" ]]; then
  echo "[Phase C] Bootstrap workspace on PC"
  ssh_run "$PC_HOST" "$PC_PORT" "$PC_USER" "mkdir -p $RAG_ROOT/{config,logs,data,cache,scripts}"

  # Write runtime.env atomically to avoid partial updates.
  ssh_run "$PC_HOST" "$PC_PORT" "$PC_USER" "cat > $RAG_ROOT/config/runtime.env.tmp <<'EOF'
LMSTUDIO_BASE_URL=$LMSTUDIO_BASE_URL
QDRANT_URL=$QDRANT_URL
NAS_MOUNT_PATH=$NAS_MOUNT_PATH
RAG_ROOT=$RAG_ROOT
EOF
mv $RAG_ROOT/config/runtime.env.tmp $RAG_ROOT/config/runtime.env"

  echo "[Phase D] NAS checks and targets"
  ssh_run "$PC_HOST" "$PC_PORT" "$PC_USER" "test -d $NAS_MOUNT_PATH && ls -la $NAS_MOUNT_PATH | head"
  ssh_run "$PC_HOST" "$PC_PORT" "$PC_USER" "mkdir -p $RAG_ROOT/data/{source,parsed,index}"
fi

echo "[Phase E] Acceptance checks"
ssh_run "$SERVER_HOST" "$SERVER_PORT" "$SERVER_USER" "curl -sS http://127.0.0.1:1234/v1/models | wc -c"
ssh_run "$PC_HOST" "$PC_PORT" "$PC_USER" "test -f $RAG_ROOT/config/runtime.env && echo runtime.env:OK || echo runtime.env:MISSING"

echo "Skill run completed."
