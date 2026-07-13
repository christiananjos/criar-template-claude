---
name: dotnet-auth-migration
description: Use ao remover a dependência de um provedor de autenticação externo (Auth-as-a-Service, ex Supabase Auth/Firebase Auth) e passar a validar login contra uma tabela própria no banco da aplicação.
---

# Migrar autenticação de um provedor externo para uma tabela própria

## Antes de codar
1. Confirme, lendo o código de verdade (não a documentação nem o nome das variáveis), como o role/claim de autorização é decidido hoje. É comum um app só usar o provedor externo pra validar usuário/senha (um `bool`) e decidir o role por uma regra própria separada — que pode estar desatualizada ou até nunca ter funcionado corretamente em produção. Isso costuma ser a causa raiz de "ninguém tem role X" que só aparece durante a migração.
2. Levante quantos usuários existem de fato antes de estimar o esforço — um app interno pequeno pode ter só um punhado de contas, o que muda completamente a estratégia (migração manual direta vs. ferramenta/self-service).

## Migrando as credenciais
3. Senhas com hash bcrypt (`$2a$`/`$2b$`/`$2y$`) são portáveis entre plataformas — dá pra copiar o hash certo pra uma tabela própria e verificar com uma lib tipo `BCrypt.Net-Next`, sem obrigar reset de senha de ninguém.
4. **Cuidado**: se o hash veio de um backup/dump, ele é uma fotografia de um instante — se a senha foi trocada depois do backup, o hash não bate mais e o login falha silenciosamente (sem erro, só `Verify` retornando `false`). Sempre teste o hash extraído contra uma senha atual confirmada antes de dar como migração concluída; se não bater, gere um hash novo a partir de uma senha atual real (perguntando ao usuário, ou gerando uma nova senha temporária) em vez de insistir no hash antigo do backup.
5. Nunca deixe um script de seed com hashes de senha reais de usuários de produção versionado no git — rode a migração de dados manualmente contra o banco e não commite o script com os valores reais (mesmo hash sendo resistente a quebra, é um dado sensível desnecessário no histórico).

## Código
6. Ao desligar o provedor de auth externo, migre também o cálculo do role/claim de autorização pra vir do novo armazenamento — não deixe uma regra hardcoded (tipo comparar e-mail com um valor de config) sobrevivendo à migração; é exatamente esse tipo de regra que costuma estar quebrada (ver item 1).
7. Depois de migrar, teste manualmente um endpoint protegido por role (ex.: `[Authorize(Roles = "Admin")]`) com uma conta de cada role — confirma que quem deveria ter acesso passa, e quem não deveria recebe 403, não só que o login retorna 200.
