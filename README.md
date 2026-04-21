# LLM RAG Toolkit

一个面向本地 / 私有部署场景的轻量 RAG 实验与运维仓库，围绕 LM Studio、监控面板、基准测试和部署脚本展开。

## 包含内容

- `benchmark_lmstudio.py`
  - 对 LM Studio OpenAI 兼容接口做基准测试
  - 生成延迟、吞吐、token 使用等摘要

- `monitoring/`
  - Docker 版监控栈
  - 包含 Prometheus、Grafana、process-exporter、GPU exporter 的配置

- `monitoring/nosudo/`
  - 无 sudo、无 Docker 的用户态监控方案
  - 适合受限服务器环境
  - 包含安装、启动、停止、Grafana 面板和自定义 exporter

- `rag_plan.md`
  - RAG 系统实施路线、架构分层和阶段性计划

## 适用场景

- 用 LM Studio 在本地或服务器上提供模型推理能力
- 为 RAG 系统搭建基础压测与监控能力
- 对不同模型、并发和上下文规模做可复现测试
- 在权限受限环境中运行 Grafana + Prometheus 监控

## 快速开始

### 1. 基准测试

```bash
python3 benchmark_lmstudio.py
```

可通过环境变量覆盖默认值，例如：

```bash
LMSTUDIO_BASE_URL=http://127.0.0.1:1234/v1 \
LMSTUDIO_MODELS=google/gemma-4-e4b,google/gemma-4-31b \
python3 benchmark_lmstudio.py
```

### 2. Docker 版监控

```bash
cd monitoring
bash start_monitoring.sh
```

### 3. 无 sudo 监控

```bash
cd monitoring/nosudo
bash install_nosudo_monitoring.sh
bash start_nosudo_monitoring.sh
```

## 仓库约定

- 不提交日志、PID、数据库、Prometheus WAL、Grafana 本地数据等运行产物
- 不提交 benchmark 执行结果和本地 metrics 快照
- 不提交个人账号、密码、域名、内网地址、访问令牌等敏感信息
- 运行时需要的本地路径尽量通过相对路径或环境变量推导

## 说明

- 本仓库默认面向 Linux 环境
- Grafana 默认账号密码仅用于本地初始启动示例，实际使用请立即修改
- 如果要公开发布，请继续检查脚本中的部署细节是否符合你的安全要求
