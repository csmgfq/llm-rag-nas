# Skill: RAG Direct Ops over Tailscale

## 1. Purpose
Operate and iterate the RAG stack with this primary topology:
- Server/Container services are exposed over container Tailscale IP.
- FNOS is reached directly from server/container over Tailscale.
- Personal PC relay is fallback only.

## 2. When to use
- Topology validation after network or port updates.
- OpenAPI mapping management.
- Milestone release checks.
- Backup execution for major changes.

## 3. Operational policy
1. Network policy
- Prefer direct Tailscale routing.
- Do not introduce proxy/relay unless direct path fails.

2. Backup policy
- Small changes: skip backup.
- Major changes: run backup skill.

3. Safety policy
- Prefer idempotent operations.
- Do not run destructive commands unless explicitly approved.

## 4. Standard workflow
### Phase A: Reachability check
- Verify container Tailscale IP is reachable.
- Verify core service ports respond.

### Phase B: Mapping control
- Use OpenAPI `/status` to inspect mappings.
- Update mappings in `proxies.json` via API and call `/apply`.

### Phase C: Runtime check
- Verify LM Studio model endpoint and Qdrant health.
- Verify monitoring endpoints.

### Phase D: Decision gate
- If change is minor: commit and push only.
- If change is major: run backup workflow, then commit/push.

## 5. Fast commands
- OpenAPI docs: `http://<container_ts_ip>:18080/docs`
- Mapping status: `GET /status`
- Apply mappings: `POST /apply`
- Backup (major change only): use `backup-fnos-workflow` skill

## 6. Key memory
- Primary topology: Docker/host -> Tailscale -> FNOS direct.
- PC relay is emergency fallback.
- Plan and skills must stay synchronized across repos.
