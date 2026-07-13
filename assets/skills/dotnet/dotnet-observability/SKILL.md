---
name: dotnet-observability
description: Use ao configurar logging estruturado, health checks ou tracing/metrics em projetos .NET (Serilog, OpenTelemetry, health checks).
---

# Observabilidade .NET

1. Logging: use Serilog (ou `ILogger<T>` nativo) com logging estruturado — nunca concatene strings no log, use propriedades nomeadas (`_logger.LogInformation("Pedido {OrderId} criado", orderId)`).
2. Nunca logue dados sensíveis (senha, token, PII) — se precisar correlacionar, use um ID mascarado.
3. Exponha health checks em `/health` (liveness) e `/health/ready` (readiness, incluindo dependências como banco/fila).
4. Para microsserviços ou sistemas distribuídos, instrumente com OpenTelemetry (tracing + metrics) e propague o `trace-id` entre chamadas.
5. Configure níveis de log por ambiente (`appsettings.Development.json` mais verboso que produção).
