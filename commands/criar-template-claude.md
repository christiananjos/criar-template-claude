---
description: Gera a estrutura de projeto padrão para usar Claude Code (.claude/agents, commands, skills, hooks, CLAUDE.md, git, hook de segurança, etc.). A arquitetura não é escolhida aqui — é decidida depois, na primeira execução da skill de scaffolding correspondente (dotnet-scaffolding / angular-scaffolding).
---

Objetivo: criar a estrutura de pastas essencial para um projeto usar o Claude Code, escolhendo apenas a stack (tipo de projeto). A decisão de arquitetura fica para depois: quando o usuário acionar `dotnet-scaffolding` e/ou `angular-scaffolding` pela primeira vez, a própria skill investiga `docs/` e, se não achar nada definido, pergunta ao usuário e registra a escolha — só então gera a sequência de bootstrap em `changes/`.

Todo o conteúdo estático (skills, CLAUDE.md, .gitignore, settings.json, hook, especificações de `changes/`) vive em `${CLAUDE_PLUGIN_ROOT}/assets/` — este comando apenas faz perguntas, copia e adapta esses arquivos para o destino. Isso é a fonte única de verdade: para mudar o conteúdo de uma skill ou de uma fase de bootstrap, edite o arquivo em `${CLAUDE_PLUGIN_ROOT}/assets/` (ou, no repositório-fonte deste plugin, em `assets/`), nunca copie o conteúdo para dentro deste comando.

Passos:

1. Pergunte ao usuário o nome do projeto (via AskUserQuestion, texto livre). Usado no `CLAUDE.md` e como sugestão de nome de pasta.

2. Pergunte ao usuário (via AskUserQuestion) o **tipo de projeto**: `.NET`, `Angular`, `Full-stack (.NET + Angular)` ou `Outro` (texto livre). Não pergunte arquitetura aqui — isso fica para a skill de scaffolding correspondente, mais tarde. Guarde a resposta — define quais skills serão copiadas no passo 8.

3. Se `$ARGUMENTS` já contiver um caminho de pasta, use-o como destino e pule para o passo 5.

4. Caso contrário, pergunte ao usuário (via AskUserQuestion) se deseja criar a estrutura na pasta atual de trabalho ou em outra (nesse caso, pergunte o caminho completo, sugerindo como padrão uma pasta com o nome do passo 1).

5. Verifique se o destino já existe e já contém arquivos. Se contiver arquivos que seriam sobrescritos (ex: `CLAUDE.md`, `.claude/settings.json`), avise o usuário e confirme antes de sobrescrever.

6. Inicialize o git no destino:
   - Se `<destino>/.git` não existir, rode `git init` ali.
   - Se `<destino>/.git` já existir com histórico prévio (`git -C <destino> log -1` não vazio), **não assuma que pode commitar** — pergunte ao usuário (via AskUserQuestion) se deve mesmo assim incluir o scaffold num commit, para não misturar isso num histórico existente sem avisar.

7. Copie os arquivos estáticos de `${CLAUDE_PLUGIN_ROOT}/assets/` para `<destino>/`, adaptando os placeholders `<nome do projeto>` e `<tipo de projeto>` com as respostas dos passos 1-2:
   - `CLAUDE.md.template` → `<destino>/CLAUDE.md`.
   - `gitignore.template` → `<destino>/.gitignore` — remova a seção `.NET` se o tipo escolhido não incluir .NET, e a seção `Angular` se não incluir Angular.
   - `settings.json.template` → `<destino>/.claude/settings.json`.
   - `hooks/check-secrets-before-commit.sh` → `<destino>/.claude/hooks/check-secrets-before-commit.sh` (mantenha executável: `chmod +x`).
   - `agents/example-agent.md` → `<destino>/.claude/agents/example-agent.md`.
   - `commands/example-command.md` → `<destino>/.claude/commands/example-command.md`.
   - Crie `<destino>/src/.gitkeep` e `<destino>/docs/.gitkeep` vazios.

8. Copie as skills relevantes ao tipo de projeto escolhido no passo 2, de `${CLAUDE_PLUGIN_ROOT}/assets/skills/` para `<destino>/.claude/skills/`:
   - Sempre copie `skills/common/example-skill/`.
   - `.NET` → copie todas as pastas em `skills/dotnet/`.
   - `Angular` → copie todas as pastas em `skills/angular/`.
   - `Full-stack (.NET + Angular)` → copie `skills/dotnet/` e `skills/angular/` inteiros.
   - `Outro` → não copie `dotnet/` nem `angular/` por padrão; pergunte ao usuário se algum dos dois conjuntos é próximo o suficiente da stack real antes de copiar.

9. Copie apenas `changes/_template-nova-feature/` de `${CLAUDE_PLUGIN_ROOT}/assets/changes/` para `<destino>/changes/` (é sempre o mesmo, independente do tipo escolhido). Não copie nenhuma sequência de bootstrap de arquitetura aqui — isso é responsabilidade da skill de scaffolding correspondente (`dotnet-scaffolding` e/ou `angular-scaffolding`), que a cria na primeira vez que for acionada, já com a arquitetura decidida.

10. Se o passo 6 determinou que pode commitar (repo novo, ou usuário confirmou), rode `git add -A && git commit -m "chore: scaffold inicial via /criar-template-claude:criar-template-claude"` no destino.

11. Após criar tudo, liste a árvore de arquivos criada para o usuário e explique brevemente:
    - O propósito de cada pasta (`agents`, `commands`, `skills`, `hooks`, `changes`, `docs`) em 1 linha cada.
    - Para cada skill copiada, quando ela deve disparar (ex: `dotnet-ef-migrations` → antes de aplicar migrations em produção).
    - Que o hook `.claude/hooks/check-secrets-before-commit.sh` bloqueia `git commit` se o diff staged parecer conter segredo (heurística, não substitui revisão manual).
    - Que a arquitetura ainda não foi escolhida: na primeira vez que `dotnet-scaffolding` e/ou `angular-scaffolding` forem acionados, a skill vai olhar `docs/` em busca de uma decisão já registrada e, se não achar, vai investigar o contexto do projeto e perguntar ao usuário — só então cria `changes/00N-*.md` e `changes/executar-todas.md` com a sequência de bootstrap daquela arquitetura.
    - Que `changes/executar-todas.md` (quando existir) constrói o projeto do zero rodando cada fase em um subagente isolado, pula fases já concluídas se re-executado, e para a sequência se uma fase revelar problema numa fase anterior.
    - Que, **depois** do bootstrap, novas features continuam a mesma numeração de 3 dígitos em `changes/NNN-nome-da-feature/` (copiando `changes/_template-nova-feature/`), uma de cada vez, sem precisar do lote de `executar-todas.md`.
