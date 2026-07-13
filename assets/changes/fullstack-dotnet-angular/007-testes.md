# 007 - Testes (Backend + Frontend)

## Objetivo
Consolidar a cobertura de testes de `<nome do projeto>` nas duas pontas (backend .NET e frontend Angular), incluindo um teste E2E que atravesse a stack inteira.

## Escopo
- Entra: revisão de cobertura backend (Domain/Application >= 80%) e frontend (>= 80%), teste E2E cobrindo o fluxo principal contra a API real.
- Não entra: novas funcionalidades.

## Entregáveis esperados
- Cobertura mínima de 80% em backend e frontend.
- Pelo menos um teste E2E (Cypress/Playwright) cobrindo o fluxo principal ponta a ponta (frontend → API → banco).
- Gates de cobertura documentados para ambas as pontas.

## Critérios de aceite
- [ ] Cobertura real medida e registrada em backend e frontend, ambas >= 80%.
- [ ] Teste E2E cobrindo o fluxo principal, rodando de forma estável.
- [ ] Gates de cobertura implementados nos dois lados.

## Skills relevantes
- `dotnet-unit-testing`, `dotnet-integration-testing`
- `angular-unit-testing`, `angular-e2e-testing`
