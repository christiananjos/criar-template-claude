# 002 - Aplicação (Backend)

## Objetivo
Implementar os casos de uso do backend de `<nome do projeto>` orquestrando o domínio.

## Escopo
- Entra: Commands/Queries, DTOs de request/response, validação de entrada.
- Não entra: implementação concreta de infraestrutura, controllers, código Angular.

## Entregáveis esperados
- Um handler por caso de uso, dependendo só de interfaces do domínio.
- DTOs que não vazam entidades de domínio.

## Critérios de aceite
- [ ] Cada caso de uso tem handler dedicado.
- [ ] Testes unitários cobrindo os handlers (mockando repositórios).
- [ ] DTOs mapeados corretamente.

## Skills relevantes
- `dotnet-scaffolding`
- `dotnet-unit-testing`
- `dotnet-code-review`
