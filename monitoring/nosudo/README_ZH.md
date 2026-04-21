# 无 sudo 监控平台（美观版）

这套方案不依赖 Docker、不需要 sudo，直接在用户目录启动：
- Grafana（127.0.0.1:13000）
- Prometheus（127.0.0.1:19090）
- 自定义 exporter（127.0.0.1:9401）

可视化重点：
- LM Studio API 在线状态
- llmster/lms 进程状态
- 6 张 GPU 的利用率、显存、温度、功耗
- 主机内存占用

## 1. 一键安装
```bash
cd /home/jiangzhiming/workspace/llm/rag/monitoring/nosudo
bash install_nosudo_monitoring.sh
```

## 2. 启动
```bash
cd /home/jiangzhiming/workspace/llm/rag/monitoring/nosudo
bash start_nosudo_monitoring.sh
```

如果你希望让外网域名直接访问 exporter，可以这样启动：
```bash
cd /home/jiangzhiming/workspace/llm/rag/monitoring/nosudo
export LM_EXPORTER_HOST=0.0.0.0
export LM_EXPORTER_TOKEN="YOUR_SECRET_TOKEN"
bash start_nosudo_monitoring.sh
```

如果域名 `3090-6.grifcc.top` 已经指向当前机器并开放端口，可以直接访问：
- Exporter: http://3090-6.grifcc.top:9401/metrics?token=YOUR_SECRET_TOKEN
- Grafana: http://3090-6.grifcc.top:13000

默认账号：
- user: admin
- pass: admin123

默认本地地址：
- Grafana: http://127.0.0.1:13000
- Prometheus: http://127.0.0.1:19090
- Exporter: http://127.0.0.1:9401?token=YOUR_SECRET_TOKEN

如果你要让 Grafana 也对外访问，可加：
```bash
export GRAFANA_HOST=0.0.0.0
export GRAFANA_PORT=13000
bash start_nosudo_monitoring.sh
```

## 3. 停止
```bash
cd /home/jiangzhiming/workspace/llm/rag/monitoring/nosudo
bash stop_nosudo_monitoring.sh
```

## 4. SSH 端口转发（推荐）
在你的本地电脑执行：
```bash
ssh -N \
  -L 13000:127.0.0.1:13000 \
  -L 19090:127.0.0.1:19090 \
  -L 9401:127.0.0.1:9401 \
  <你的用户>@<你的服务器IP> -p <你的SSH端口>
```

然后本地浏览器打开：
- http://127.0.0.1:13000

## 5. 常见问题
1. Grafana 打不开：
- 看日志 [workspace/llm/rag/monitoring/nosudo/logs/grafana.log](workspace/llm/rag/monitoring/nosudo/logs/grafana.log)

2. 没有 GPU 曲线：
- 检查 `nvidia-smi` 是否可执行
- 查看 [workspace/llm/rag/monitoring/nosudo/logs/lm_exporter.log](workspace/llm/rag/monitoring/nosudo/logs/lm_exporter.log)

3. LM Studio 状态为 DOWN：
- 检查 `lms server start --port 1234` 是否运行

## 6. 关键文件
- [workspace/llm/rag/monitoring/nosudo/lm_exporter.py](workspace/llm/rag/monitoring/nosudo/lm_exporter.py)
- [workspace/llm/rag/monitoring/nosudo/prometheus.yml](workspace/llm/rag/monitoring/nosudo/prometheus.yml)
- [workspace/llm/rag/monitoring/nosudo/grafana.ini](workspace/llm/rag/monitoring/nosudo/grafana.ini)
- [workspace/llm/rag/monitoring/nosudo/grafana/dashboards/rag-overview-nosudo.json](workspace/llm/rag/monitoring/nosudo/grafana/dashboards/rag-overview-nosudo.json)
