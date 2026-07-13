# 005 - Testes

## Objetivo
Consolidar a cobertura de testes dos módulos/serviços de `<nome do projeto>` antes de seguir para CI/CD, incluindo testes de comunicação entre eles.

## Escopo
- Entra: revisão de cobertura de A, B e do host/gateway; testes de contrato entre módulos/serviços.
- Não entra: novos módulos/serviços.

## Entregáveis esperados
- Cobertura mínima de 80% no domínio/aplicação de cada módulo/serviço.
- Teste de contrato garantindo que a comunicação entre A e B não quebra silenciosamente.
- Gate de cobertura documentado.

## Critérios de aceite
- [ ] Cobertura medida e registrada (número real) >= 80% em cada módulo/serviço.
- [ ] Teste de contrato entre A e B implementado e passando.
- [ ] Gate de cobertura implementado.

## Skills relevantes
- `dotnet-unit-testing`
- `dotnet-integration-testing`
- `dotnet-code-review`
