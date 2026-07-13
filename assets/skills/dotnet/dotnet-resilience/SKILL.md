---
name: dotnet-resilience
description: Use ao implementar chamadas a serviços externos (HTTP, banco, fila) em projetos .NET, para aplicar padrões de resiliência (retry, circuit breaker, timeout).
---

# Resiliência .NET

1. Toda chamada de saída a serviço externo (HTTP, banco remoto, fila) deve ter timeout explícito — nunca depender do timeout padrão do cliente.
2. Use Polly (via `Microsoft.Extensions.Http.Resilience` ou `AddResilienceHandler`) para retry com backoff exponencial + jitter em falhas transitórias.
3. Adicione circuit breaker em dependências críticas para evitar cascata de falhas quando o serviço externo está indisponível.
4. Nunca faça retry automático em operações não idempotentes sem proteção (ex: chave de idempotência) — pode duplicar efeito colateral (cobrança, envio de email).
5. `HttpClient` deve ser criado via `IHttpClientFactory` (nunca `new HttpClient()` disperso) para evitar exaustão de sockets.
