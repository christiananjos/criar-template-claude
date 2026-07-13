# 002 - Aplicação

## Objetivo
Implementar os casos de uso de `<nome do projeto>` orquestrando o domínio: comandos, queries, DTOs de entrada/saída, e interfaces que a infraestrutura vai implementar.

## Escopo
- Entra: Commands/Queries (CQRS/MediatR se aplicável, ou CQRS leve manual), DTOs de request/response, validação de entrada, interfaces de serviços externos.
- Não entra: implementação concreta de repositórios, controllers HTTP, detalhes de banco de dados.

## Entregáveis esperados
- Um handler por caso de uso, dependendo apenas de interfaces do domínio/aplicação (nunca de classes concretas de infraestrutura).
- DTOs de entrada/saída que não vazam entidades de domínio diretamente.

## Critérios de aceite
- [ ] Cada caso de uso tem um handler dedicado, sem lógica de negócio duplicada do domínio.
- [ ] Testes unitários cobrindo os handlers principais (mockando interfaces de repositório).
- [ ] DTOs mapeados corretamente de/para entidades de domínio.

## Skills relevantes
- `dotnet-scaffolding` — handlers CQRS.
- `dotnet-unit-testing` — cobertura mínima de 80%.
- `dotnet-code-review` — evitar lógica de negócio direta no handler sem passar pelo domínio.
