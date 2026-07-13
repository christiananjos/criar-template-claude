# 005 - CI/CD e Observabilidade

## Objetivo
Configurar o pipeline de build/test/publish e a observabilidade básica para `<nome do projeto>` rodar de forma confiável em produção.

## Escopo
- Entra: pipeline de CI/CD, Dockerfile, health checks, auditoria de segurança inicial.
- Não entra: novas funcionalidades de negócio.

## Entregáveis esperados
- Pipeline com restore → build → test (com gate de cobertura) → análise estática → publish/Docker.
- Health checks expostos (`/health`, `/health/ready`).
- Primeira auditoria de segurança rodada.

## Critérios de aceite
- [ ] Pipeline cobrindo todas as etapas acima (anotar se rodou de fato em um runner real ou só localmente).
- [ ] Health checks respondendo corretamente (testado manualmente).
- [ ] `dotnet list package --vulnerable --include-transitive` sem achados críticos não tratados.
- [ ] README atualizado refletindo o estado real do projeto, incluindo dívida técnica assumida.

## Skills relevantes
- `dotnet-cicd`
- `dotnet-observability`
- `dotnet-security-audit`
- `dotnet-documentation`
