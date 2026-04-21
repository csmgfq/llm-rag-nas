# Agent memory (compressed)

- Use conda env llmstudio for all Python runs.
- Do not use base environment.
- Use direct network; unset proxy vars by default.
- Local model set ready: google/gemma-4-31b, google/gemma-4-e4b, text-embedding-nomic-embed-text-v1.5.
- Deployment split: NAS=data/index, PC=ingestion+gateway, server=LM Studio inference.
- Prefer non-interactive SSH with explicit host and port.
- Safety: avoid destructive commands.
