# 004 - Apresentação / API

## Objetivo
Expor os casos de uso da camada de aplicação de `<nome do projeto>` via API HTTP (Controllers ou Minimal API), incluindo autenticação, autorização e documentação OpenAPI.

## Escopo
- Entra: endpoints HTTP, autenticação/autorização, mapeamento de erros para códigos HTTP, documentação OpenAPI.
- Não entra: lógica de negócio (delega para Application).

## Entregáveis esperados
- Endpoints finos, delegando para handlers da camada de aplicação.
- Anotações OpenAPI em todos os endpoints públicos.
- Autenticação/autorização configurada e aplicada nos endpoints que precisam (se for um esqueleto de exemplo em vez de autenticação real, documentar isso explicitamente — não fingir que está pronto para produção).

## Critérios de aceite
- [ ] Todo endpoint público tem anotação OpenAPI (request/response/status codes).
- [ ] Endpoints que não deveriam ser públicos têm `[Authorize]`/`.RequireAuthorization()` explícito.
- [ ] Testes de integração cobrindo os principais fluxos HTTP (`WebApplicationFactory`).

## Skills relevantes
- `dotnet-scaffolding` — endpoints/controllers.
- `dotnet-documentation` — OpenAPI + atualização do README.
- `dotnet-security-audit` — autenticação/autorização, CORS.
