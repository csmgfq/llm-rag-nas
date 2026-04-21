# Grafana 监控平台使用教程（LM Studio + 服务器资源）

## 1. 已为你准备好的内容
目录：
- [workspace/llm/rag/monitoring/docker-compose.yml](workspace/llm/rag/monitoring/docker-compose.yml)
- [workspace/llm/rag/monitoring/prometheus.yml](workspace/llm/rag/monitoring/prometheus.yml)
- [workspace/llm/rag/monitoring/process-exporter.yml](workspace/llm/rag/monitoring/process-exporter.yml)
- [workspace/llm/rag/monitoring/grafana/provisioning/datasources/datasource.yml](workspace/llm/rag/monitoring/grafana/provisioning/datasources/datasource.yml)
- [workspace/llm/rag/monitoring/grafana/provisioning/dashboards/dashboards.yml](workspace/llm/rag/monitoring/grafana/provisioning/dashboards/dashboards.yml)
- [workspace/llm/rag/monitoring/grafana/dashboards/rag-overview.json](workspace/llm/rag/monitoring/grafana/dashboards/rag-overview.json)
- [workspace/llm/rag/monitoring/start_monitoring.sh](workspace/llm/rag/monitoring/start_monitoring.sh)

监控内容包含：
- 服务器 CPU / 内存 / 网络
- GPU 利用率 / 显存占用
- llmster 进程计数
- Docker 容器资源（cAdvisor）

## 2. 启动方式
你当前账号没有 Docker 权限（访问 /var/run/docker.sock 被拒绝），因此二选一：

1. 临时用 sudo 启动
```bash
cd <project-root>/monitoring
sudo docker compose up -d
```

2. 永久修复权限（推荐）
```bash
sudo usermod -aG docker $USER
newgrp docker
cd <project-root>/monitoring
docker compose up -d
```

也可以直接运行：
```bash
cd <project-root>/monitoring
bash start_monitoring.sh
```

## 3. 访问地址
- Grafana: http://127.0.0.1:3000
- Prometheus: http://127.0.0.1:9090

Grafana 默认账号：
- 用户名：admin
- 密码：admin123

登录后会自动加载仪表盘：
- RAG Monitoring / RAG Server Overview

## 4. 快速验收
```bash
curl -fsS http://127.0.0.1:9090/-/healthy
curl -fsS http://127.0.0.1:3000/api/health
curl -fsS http://127.0.0.1:9400/metrics | head
```

## 5. 常用运维命令
```bash
cd <project-root>/monitoring

# 查看状态
docker compose ps

# 查看日志
docker compose logs -f prometheus
docker compose logs -f grafana
docker compose logs -f dcgm-exporter

# 重启
docker compose restart

# 停止
docker compose down
```

## 6. 与 LM Studio 联动建议
- 压测时同时观察：
  - GPU Utilization %
  - GPU Memory Used
  - llmster Process Count
- 建议将压测结果文件和 Grafana 时间段对应保存，方便回溯模型参数变化对吞吐的影响。

## 7. 安全建议
- 首次登录后立刻修改 Grafana 管理员密码。
- 如果需要外网访问，建议加反向代理和访问控制，不直接暴露 3000/9090 端口。
