# Skill: RAG Remote Bootstrap over SSH

## 1. Purpose
Build and maintain a personal RAG system with this topology:
- NAS stores source data and index persistence.
- Personal PC runs ingestion/query gateway.
- GPU server runs LM Studio models.

This skill is designed for repeatable remote execution via SSH on custom ports.

## 2. When to use
- First-time bootstrap.
- Reconfiguration after network/port changes.
- Periodic health checks.
- Hand-off execution to another agent (for example OpenClaw).

## 3. Inputs
Required:
- SERVER_HOST
- SERVER_PORT
- SERVER_USER
- PC_HOST
- PC_PORT
- PC_USER
- NAS_MOUNT_PATH (on PC)

Optional:
- LMSTUDIO_BASE_URL (default: http://127.0.0.1:1234/v1)
- QDRANT_URL (default: http://127.0.0.1:6333)
- RAG_ROOT (default: ~/rag)

## 4. Preconditions
- SSH key-based login is configured for both server and PC.
- `lms` is installed and logged in on server.
- `python3` is available on PC.
- NAS path can be mounted/accessed from PC.

## 5. Standard workflow
### Phase A: Connectivity checks
1. Check server
- `ssh -p $SERVER_PORT $SERVER_USER@$SERVER_HOST "hostname; lms --version; lms ls"`
2. Check PC
- `ssh -p $PC_PORT $PC_USER@$PC_HOST "hostname; python3 --version; mkdir -p $RAG_ROOT"`

Success criteria:
- Both hosts reachable.
- `lms` works on server.
- PC can create working directory.

### Phase B: Model service checks on server
1. Verify model inventory
- `ssh -p $SERVER_PORT $SERVER_USER@$SERVER_HOST "lms ls"`
2. Verify local API readiness
- `ssh -p $SERVER_PORT $SERVER_USER@$SERVER_HOST "curl -sS http://127.0.0.1:1234/v1/models | head"`

Success criteria:
- `google/gemma-4-31b` and `google/gemma-4-e4b` are listed.
- `/v1/models` returns JSON.

### Phase C: RAG workspace bootstrap on PC
1. Create directory layout
- `ssh -p $PC_PORT $PC_USER@$PC_HOST "mkdir -p $RAG_ROOT/{config,logs,data,cache,scripts}"`
2. Persist runtime config
- Write `config/runtime.env` with:
  - `LMSTUDIO_BASE_URL`
  - `QDRANT_URL`
  - `NAS_MOUNT_PATH`

Success criteria:
- Folder structure exists.
- Config file exists and contains non-empty values.

### Phase D: NAS data readiness
1. Validate source folders on NAS mount
- `ssh -p $PC_PORT $PC_USER@$PC_HOST "test -d $NAS_MOUNT_PATH && ls -la $NAS_MOUNT_PATH | head"`
2. Prepare sync targets
- `ssh -p $PC_PORT $PC_USER@$PC_HOST "mkdir -p $RAG_ROOT/data/{source,parsed,index}"`

Success criteria:
- NAS path is readable from PC.
- Local RAG staging directories are ready.

### Phase E: Acceptance checks
1. Server LLM API check
- `ssh -p $SERVER_PORT $SERVER_USER@$SERVER_HOST "curl -sS http://127.0.0.1:1234/v1/models | wc -c"`
2. PC environment check
- `ssh -p $PC_PORT $PC_USER@$PC_HOST "test -f $RAG_ROOT/config/runtime.env && echo OK"`

Success criteria:
- Non-zero API response size.
- Runtime env file confirmed.

## 6. Operational policy
- Always run with direct network (no proxy env vars) unless explicitly required.
- Prefer idempotent commands (`mkdir -p`, overwrite-safe config writes).
- Never run destructive commands (`rm -rf`, `mkfs`, force service reset) in this skill.

## 7. OpenClaw hand-off template
Use this exact instruction body when handing off:

"Execute Skill RAG Remote Bootstrap over SSH.
Inputs:
- SERVER_HOST=<value>
- SERVER_PORT=<value>
- SERVER_USER=<value>
- PC_HOST=<value>
- PC_PORT=<value>
- PC_USER=<value>
- NAS_MOUNT_PATH=<value>
Optional:
- LMSTUDIO_BASE_URL=http://127.0.0.1:1234/v1
- QDRANT_URL=http://127.0.0.1:6333
- RAG_ROOT=~/rag
Run phases A->E. Return per-phase outputs and final pass/fail checklist."

## 8. Fast run command
- Use script: `./rag_remote_skill.sh --mode check --server-host <h> --server-port <p> --server-user <u> --pc-host <h2> --pc-port <p2> --pc-user <u2> --nas-mount <path>`
- Bootstrap mode: replace `--mode check` with `--mode bootstrap`.

## 9. Compressed key memory (must keep)
- Python environment: always use conda env `llmstudio`, never use `base`.
- Network policy: direct network only; unset proxy variables unless explicitly requested.
- Current local models: `google/gemma-4-31b`, `google/gemma-4-e4b`, `text-embedding-nomic-embed-text-v1.5`.
- Topology: NAS stores data/index, PC handles ingestion/gateway, GPU server handles inference.
- Remote execution: prefer SSH non-interactive commands with explicit ports.
