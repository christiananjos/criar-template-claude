# 005 - Testes

## Objetivo
Consolidar e completar a cobertura de testes (unitários + integração) de `<nome do projeto>` antes de seguir para CI/CD e observabilidade.

## Escopo
- Entra: testes unitários das camadas Domain/Application, testes de integração da camada de Infraestrutura/API, revisão de cobertura.
- Não entra: novas funcionalidades (esta etapa é de consolidação).

## Entregáveis esperados
- Cobertura mínima de 80% no código de domínio e aplicação.
- Testes de integração cobrindo os principais fluxos ponta a ponta (HTTP → handler → banco).
- Um gate de cobertura mínima documentado (script/target que falha se a cobertura cair abaixo do limite).

## Critérios de aceite
- [ ] `dotnet test --collect:"XPlat Code Coverage"` reporta >= 80% em Domain/Application (medir e registrar o número real, não estimar).
- [ ] Testes de integração rodando contra banco real, sem depender de mocks. Rodar a suite duas vezes seguidas e confirmar resultado estável (sem dependência de ordem).
- [ ] Gate de cobertura implementado e testado (caminho de sucesso e de falha).

## Skills relevantes
- `dotnet-unit-testing`
- `dotnet-integration-testing`
- `dotnet-code-review`
