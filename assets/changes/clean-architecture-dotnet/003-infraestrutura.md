# 003 - Infraestrutura

## Objetivo
Implementar os detalhes técnicos de `<nome do projeto>`: persistência (EF Core), integrações externas, e as implementações concretas das interfaces definidas em Domain/Application.

## Escopo
- Entra: `DbContext`, configurações de mapeamento (Fluent API), implementação dos repositórios, clientes HTTP para serviços externos, migrations.
- Não entra: regra de negócio (deve estar só no domínio).

## Entregáveis esperados
- Implementação dos repositórios definidos no domínio.
- Primeira migration do EF Core criada e revisada.
- Configuração de resiliência (retry/timeout) nas integrações externas.

## Critérios de aceite
- [ ] Migration inicial criada, revisada e com script de aplicação em produção validado (`dotnet ef migrations script`).
- [ ] Repositórios implementados e testados via teste de integração (banco real via Testcontainers; se Docker não estiver disponível no ambiente, documentar o fallback usado — ex: SQLite real — e o motivo).
- [ ] Chamadas a serviços externos com timeout e retry configurados.

## Skills relevantes
- `dotnet-ef-migrations` — criação e revisão segura de migrations.
- `dotnet-integration-testing` — testes contra banco real.
- `dotnet-resilience` — retry/circuit breaker/timeout.
- `dotnet-secrets` — connection string e credenciais.
