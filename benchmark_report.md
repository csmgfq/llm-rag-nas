# LM Studio 大上下文压测报告

- base_url: http://127.0.0.1:1234/v1
- timestamp: 1776718633
- long_context_target_chars: 3000

## google/gemma-4-e4b
- warmup: {'ok': True, 'latency_s': 1.154, 'prompt_tokens': 32, 'completion_tokens': 64, 'error': None}
- 短上下文基线: {"scenario": "短上下文基线", "concurrency": 1, "total": 3, "ok": 3, "fail": 0, "success_rate_pct": 100.0, "wall_time_s": 9.077, "requests_per_second": 0.33, "errors": [], "prompt_chars_avg": 64, "latency_avg_s": 3.025, "latency_p95_s": 3.038, "latency_max_s": 3.038, "prompt_tokens_avg": 60, "prompt_tokens_total": 180, "completion_tokens_avg": 192, "completion_tokens_total": 576, "total_tokens_avg": 252, "total_tokens_total": 756, "output_tokens_per_second_avg": 63.466, "output_tokens_per_second_cluster": 63.455}
- 长上下文压测: {"scenario": "长上下文压测", "concurrency": 1, "total": 3, "ok": 3, "fail": 0, "success_rate_pct": 100.0, "wall_time_s": 19.198, "requests_per_second": 0.156, "errors": [], "prompt_chars_avg": 3139, "latency_avg_s": 6.399, "latency_p95_s": 6.747, "latency_max_s": 6.747, "prompt_tokens_avg": 1835, "prompt_tokens_total": 5505, "completion_tokens_avg": 192, "completion_tokens_total": 576, "total_tokens_avg": 2027, "total_tokens_total": 6081, "output_tokens_per_second_avg": 30.048, "output_tokens_per_second_cluster": 30.003}

## google/gemma-4-31b
- warmup: {'ok': True, 'latency_s': 2.34, 'prompt_tokens': 32, 'completion_tokens': 64, 'error': None}
- 短上下文基线: {"scenario": "短上下文基线", "concurrency": 1, "total": 3, "ok": 3, "fail": 0, "success_rate_pct": 100.0, "wall_time_s": 18.813, "requests_per_second": 0.159, "errors": [], "prompt_chars_avg": 64, "latency_avg_s": 6.271, "latency_p95_s": 6.308, "latency_max_s": 6.308, "prompt_tokens_avg": 60, "prompt_tokens_total": 180, "completion_tokens_avg": 192, "completion_tokens_total": 576, "total_tokens_avg": 252, "total_tokens_total": 756, "output_tokens_per_second_avg": 30.62, "output_tokens_per_second_cluster": 30.617}
- 长上下文压测: {"scenario": "长上下文压测", "concurrency": 1, "total": 3, "ok": 3, "fail": 0, "success_rate_pct": 100.0, "wall_time_s": 22.061, "requests_per_second": 0.136, "errors": [], "prompt_chars_avg": 3139, "latency_avg_s": 7.353, "latency_p95_s": 9.224, "latency_max_s": 9.224, "prompt_tokens_avg": 1835, "prompt_tokens_total": 5505, "completion_tokens_avg": 192, "completion_tokens_total": 576, "total_tokens_avg": 2027, "total_tokens_total": 6081, "output_tokens_per_second_avg": 26.883, "output_tokens_per_second_cluster": 26.11}
