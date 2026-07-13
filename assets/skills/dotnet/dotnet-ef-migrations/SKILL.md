---
name: dotnet-ef-migrations
description: Use ao criar, revisar ou aplicar migrations do Entity Framework Core. Garante que a migration é segura para produção antes de ser aplicada.
---

# EF Core Migrations

Ao criar ou revisar uma migration:

1. Rode `dotnet ef migrations add <Nome>` a partir do projeto que contém o `DbContext`.
2. Leia o arquivo gerado em `Migrations/` e verifique:
   - Colunas novas `NOT NULL` em tabelas existentes precisam de `DEFAULT` ou backfill — nunca aplicar sem isso.
   - Operações que fazem lock longo em tabelas grandes (`AddColumn` com default calculado, `AlterColumn` mudando tipo, criação de índice sem `CONCURRENTLY` quando aplicável).
   - Renomear coluna/tabela quebra compatibilidade com a versão anterior do app rodando em paralelo (deploy blue-green) — prefira "adicionar novo + migrar dados + remover antigo" em etapas separadas.
3. Confirme que o método `Down()` reverte corretamente a migration (não deixe vazio sem necessidade).
4. Nunca edite uma migration já aplicada em outro ambiente — crie uma nova migration corretiva.
5. Antes de aplicar em produção, rode `dotnet ef migrations script` e revise o SQL gerado.
