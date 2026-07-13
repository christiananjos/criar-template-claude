# 004 - Testes

## Objetivo
Consolidar a cobertura de testes das slices existentes em `<nome do projeto>` antes de seguir para CI/CD.

## Escopo
- Entra: revisão de cobertura das slices já implementadas, testes faltantes, gate de cobertura mínima.
- Não entra: novas slices/features.

## Entregáveis esperados
- Cobertura mínima de 80% nas slices implementadas.
- Testes de integração isolados e estáveis (sem dependência de ordem de execução).
- Gate de cobertura documentado.

## Critérios de aceite
- [ ] Cobertura medida e registrada (número real, não estimado) >= 80% nas slices existentes.
- [ ] Suite de testes roda de forma estável em execuções repetidas.
- [ ] Gate de cobertura implementado.

## Skills relevantes
- `dotnet-unit-testing`
- `dotnet-integration-testing`
- `dotnet-code-review`
