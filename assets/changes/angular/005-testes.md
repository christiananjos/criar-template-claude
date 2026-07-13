# 005 - Testes

## Objetivo
Consolidar a cobertura de testes unitários e end-to-end de `<nome do projeto>` antes de seguir para CI/CD.

## Escopo
- Entra: revisão de cobertura unitária, testes E2E dos fluxos críticos (Cypress/Playwright), gate de cobertura mínima.
- Não entra: novas features.

## Entregáveis esperados
- Cobertura mínima de 80% nos componentes/serviços implementados.
- Testes E2E cobrindo o(s) fluxo(s) crítico(s) do usuário.
- Gate de cobertura documentado.

## Critérios de aceite
- [ ] `ng test --code-coverage` reporta >= 80% (número real, não estimado).
- [ ] Testes E2E cobrindo pelo menos o fluxo principal, rodando de forma estável.
- [ ] Gate de cobertura implementado.

## Skills relevantes
- `angular-unit-testing`
- `angular-e2e-testing`
- `angular-code-review`
