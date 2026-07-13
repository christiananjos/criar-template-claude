# 006 - CI/CD e Observabilidade

## Objetivo
Configurar o pipeline de build/test/publish e a observabilidade básica (logging, health checks) para `<nome do projeto>` rodar de forma confiável em produção.

## Escopo
- Entra: pipeline de CI/CD, Dockerfile, logging estruturado, health checks, auditoria de segurança inicial.
- Não entra: novas funcionalidades de negócio.

## Entregáveis esperados
- Pipeline com restore → build → test (incluindo o gate de cobertura da etapa 005) → análise estática → publish/Docker.
- Logging estruturado (Serilog ou `ILogger<T>` estruturado) configurado.
- Health checks expostos (`/health`, `/health/ready`).
- Primeira auditoria de segurança rodada (dependências vulneráveis, checklist OWASP básico).

## Critérios de aceite
- [ ] Pipeline de CI verde, cobrindo todas as etapas acima (anotar se ele já rodou de fato em um runner real ou só foi validado localmente — não afirmar "verde" sem ter rodado em algum lugar).
- [ ] Health checks respondendo corretamente em ambiente local/staging (testado manualmente).
- [ ] `dotnet list package --vulnerable --include-transitive` sem achados críticos não tratados.
- [ ] README atualizado refletindo tudo o que foi implementado nas etapas 001-006, incluindo qualquer simplificação/dívida técnica assumida (autenticação de exemplo, fallback de Testcontainers, etc.) — sem esconder o que ficou pendente.

## Skills relevantes
- `dotnet-cicd`
- `dotnet-observability`
- `dotnet-security-audit`
- `dotnet-documentation` — atualização final do README.
