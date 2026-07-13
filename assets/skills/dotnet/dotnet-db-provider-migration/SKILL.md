---
name: dotnet-db-provider-migration
description: Use ao trocar o motor/provedor de banco de dados de um projeto .NET (ex: Postgres para SQL Server, Supabase para Azure SQL) — não confundir com dotnet-ef-migrations, que é sobre evoluir schema no mesmo motor. Cobre conversão de tipos, extração de dados de um dump e cutover.
---

# Troca de motor/provedor de banco de dados

Isto é sobre trocar o **motor** de banco (ex: Postgres → SQL Server) ou só a **hospedagem** (mesmo motor, outro provedor). São escopos bem diferentes — descubra qual é o caso antes de planejar.

## Antes de codar
1. Liste todo tipo/sintaxe específico do motor de origem que não existe no destino antes de escrever qualquer config de ORM. Exemplos reais já encontrados migrando Postgres→SQL Server: `jsonb` → `nvarchar(max)`; `timezone('utc', now())` → `SYSUTCDATETIME()`; métodos específicos de provider do EF Core (ex.: `UseIdentityAlwaysColumn()`/`UseSerialColumn()` do Npgsql) não têm equivalente 1:1 no provider novo — o build falha neles, o que é uma forma rápida de achar todos; `character varying` sem tamanho precisa de tamanho explícito no destino.
2. Cuidado com nomes de schema reservados no destino: `public` não pode ser usado como nome de schema no SQL Server (colide com a role interna `PUBLIC`) — use `dbo` ou outro nome.
3. Não assuma que toda relação declarada no código (ex.: `HasOne/WithMany` do EF Core) existe de fato como constraint no banco de origem. Confira o schema real (`pg_dump --schema-only` ou equivalente) antes de recriar constraints no destino — uma FK "fantasma" pode rejeitar linhas que já eram órfãs de propósito no sistema original (snapshot pattern, referência que sobrevive à exclusão do registro referenciado).

## Extraindo dados de um backup/dump
4. Pra inspecionar ou extrair dados de um dump, restaure num container Docker descartável do motor de origem — não crie infraestrutura paga só pra isso. Restaure com `--no-owner --no-privileges` pra ignorar roles que não existem fora do ambiente original (erros de policy/RLS/role ausente durante o restore geralmente são inofensivos pro objetivo de extrair dados).
5. Para poucos registros (ordem de centenas), gerar `INSERT`s explícitos a partir do banco de origem (`quote_literal`/`format` no Postgres, por exemplo) é mais controlável e auditável do que `bcp`/CSV — evita bugs de delimitador em campos de texto livre ou JSON que contenham vírgula/quebra de linha/aspas.
6. Ao gerar `INSERT`s com texto não-ASCII (acentos) pra SQL Server, sempre prefixar literais de string com `N` e rodar `sqlcmd` com `-f 65001` (UTF-8) — sem isso os acentos corrompem silenciosamente, sem erro.
7. No Windows, cuidado com o PowerShell interpretando `$` dentro de strings passadas via `-Q`/`-Query` (comum em hashes bcrypt e algumas connection strings) — isso trunca/corrompe o valor silenciosamente. Escreva o SQL num arquivo `.sql` e rode com `-i` em vez de `-Q`.

## Código e testes
8. Trocar o provider do ORM (ex.: `UseNpgsql` → `UseSqlServer`) é só metade do trabalho — releia toda `IEntityTypeConfiguration`/mapeamento de entidade procurando tipos e métodos específicos do provider antigo.
9. Se os testes de integração usam Testcontainers com a imagem do motor antigo, troque pra imagem do motor novo (ex.: `Testcontainers.PostgreSql` → `Testcontainers.MsSql`) e ajuste o seed de acordo — os testes devem validar contra o motor real de destino, não contra um dublê.

## Cutover
10. Prefira o menor blast radius possível: se for só trocar hospedagem (motor igual), dá pra trocar somente o *valor* da connection string existente sem deploy de código — rollback é instantâneo. Se o motor mudou (exige deploy de código de qualquer forma), valide localmente contra o banco de destino real antes do deploy, e não tem como fazer cutover "sem código" nesse caso.
11. Depois de migrar os dados, compare contagem de linhas por tabela entre origem e destino antes de considerar a migração validada.
