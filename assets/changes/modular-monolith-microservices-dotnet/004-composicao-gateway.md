# 004 - Composição / API Gateway

## Objetivo
Compor os módulos num único host (Modular Monolith) ou expor os serviços via um API Gateway único (Microservices) para `<nome do projeto>`.

## Escopo
- Entra (Modular Monolith): host único que registra os módulos A e B via DI, roteamento único.
- Entra (Microservices): API Gateway roteando para os serviços A e B, autenticação centralizada no gateway.
- Não entra: lógica de negócio nova.

## Entregáveis esperados
- Host/gateway funcional, expondo os endpoints dos módulos/serviços A e B.
- Autenticação/autorização configurada no ponto de entrada único (mesmo que esqueleto de exemplo, documentado como tal).
- Documentação OpenAPI consolidada.

## Critérios de aceite
- [ ] Host/gateway builda e roteia corretamente para A e B.
- [ ] Autenticação aplicada no ponto de entrada, testada.
- [ ] Documentação OpenAPI consolidada acessível.

## Skills relevantes
- `dotnet-scaffolding`
- `dotnet-security-audit`
- `dotnet-documentation`
