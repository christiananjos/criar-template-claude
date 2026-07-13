# 003 - Infraestrutura (Backend)

## Objetivo
Implementar persistência e integrações externas do backend de `<nome do projeto>`.

## Escopo
- Entra: `DbContext`, repositórios, migrations, resiliência em integrações externas.
- Não entra: regra de negócio, código Angular.

## Entregáveis esperados
- Repositórios implementados.
- Primeira migration criada e revisada.

## Critérios de aceite
- [ ] Migration revisada, com script validado.
- [ ] Repositórios testados via teste de integração (banco real ou fallback documentado).
- [ ] Chamadas externas com timeout/retry configurados.

## Skills relevantes
- `dotnet-ef-migrations`
- `dotnet-integration-testing`
- `dotnet-resilience`
- `dotnet-secrets`
