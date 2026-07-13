# 006 - CI/CD e Observabilidade

## Objetivo
Configurar o pipeline de build/test/publish e a observabilidade (logging, health checks, tracing entre módulos/serviços) para `<nome do projeto>`.

## Escopo
- Entra: pipeline de CI/CD (build/test/publish de cada módulo/serviço), Dockerfile(s), logging estruturado com correlação entre módulos/serviços, health checks, auditoria de segurança.
- Não entra: novas funcionalidades de negócio.

## Entregáveis esperados
- Pipeline cobrindo build/test/publish de todos os módulos/serviços.
- Logging estruturado com `trace-id`/correlação propagada entre módulo/serviço A, B e o gateway.
- Health checks em cada módulo/serviço e no host/gateway.
- Auditoria de segurança rodada (dependências vulneráveis em todos os projetos).

## Critérios de aceite
- [ ] Pipeline cobrindo todos os módulos/serviços (anotar se rodou em runner real ou só localmente).
- [ ] Correlação de log rastreável entre A, B e o gateway, testada manualmente.
- [ ] Health checks respondendo corretamente em todos os módulos/serviços.
- [ ] README atualizado refletindo o estado real do sistema (incluindo dívida técnica).

## Skills relevantes
- `dotnet-cicd`
- `dotnet-observability`
- `dotnet-security-audit`
- `dotnet-documentation`
