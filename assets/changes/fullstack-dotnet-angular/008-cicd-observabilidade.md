# 008 - CI/CD e Observabilidade (Backend + Frontend)

## Objetivo
Configurar o pipeline de build/test/deploy cobrindo backend e frontend de `<nome do projeto>`, e a observabilidade das duas pontas.

## Escopo
- Entra: pipeline com jobs para backend (.NET) e frontend (Angular), Dockerfile(s) para cada um (ou `docker-compose` unindo os dois), logging estruturado no backend, error tracking no frontend, health checks.
- Não entra: novas funcionalidades de negócio.

## Entregáveis esperados
- Pipeline cobrindo build/test/publish do backend e do frontend, podendo rodar em paralelo (são independentes).
- `docker-compose.yml` (ou equivalente) subindo backend + frontend juntos localmente.
- Health checks no backend, error tracking no frontend.

## Critérios de aceite
- [ ] Pipeline cobrindo as duas pontas (anotar se rodou em runner real ou só localmente).
- [ ] `docker-compose up` (ou equivalente) sobe backend + frontend conseguindo se comunicar (testado manualmente, se Docker estiver disponível no ambiente).
- [ ] `dotnet list package --vulnerable` e `npm audit` sem achados críticos não tratados.
- [ ] README atualizado refletindo o estado real do sistema completo (backend + frontend), incluindo dívida técnica.

## Skills relevantes
- `dotnet-cicd`, `dotnet-observability`, `dotnet-security-audit`, `dotnet-documentation`
- `angular-cicd`, `angular-observability`, `angular-security-audit`, `angular-documentation`
