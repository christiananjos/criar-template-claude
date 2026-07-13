# 004 - API (Backend)

## Objetivo
Expor os casos de uso via API HTTP, pronta para ser consumida pelo frontend Angular de `<nome do projeto>`.

## Escopo
- Entra: endpoints HTTP, autenticação/autorização, CORS liberado para a origem do frontend, OpenAPI.
- Não entra: código Angular (isso começa na etapa 005).

## Entregáveis esperados
- Endpoints finos documentados via OpenAPI.
- CORS configurado especificamente para a origem do frontend (nunca `AllowAnyOrigin` com credenciais).
- Autenticação configurada (mesmo que esqueleto de exemplo, documentado como tal).

## Critérios de aceite
- [ ] Todo endpoint público tem anotação OpenAPI.
- [ ] CORS restrito à origem real do frontend.
- [ ] Testes de integração cobrindo os fluxos HTTP principais.

## Skills relevantes
- `dotnet-scaffolding`
- `dotnet-documentation`
- `dotnet-security-audit`
