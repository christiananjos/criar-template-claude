---
description: Gera a mensagem de commit a partir do diff atual, varre segredos expostos, commita direto na main e faz push
argument-hint: [contexto opcional sobre o que mudou]
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git add:*), Bash(git commit:*), Bash(git push:*), Bash(git branch:*), Bash(git restore:*)
---

Contexto opcional passado pelo usuário (pode estar vazio): $ARGUMENTS

## O que fazer

1. Rode `git status --short` e `git diff` (staged + unstaged) para ver exatamente o que mudou.
   Se não houver nada para commitar, avise e pare — não crie um commit vazio.

2. Rode `git log --oneline -15` para seguir o estilo de mensagens já usado neste repositório:
   - Prefixo de tipo (`feat:`, `fix:`, `docs:`, `chore:`, `refactor:`) quando o tipo for óbvio pelo diff.
   - Descrição curta em português, no presente do indicativo ("adiciona", "corrige", "move", "ajusta"),
     **sem acentos** (mesma convenção do histórico atual).
   - Sem emojis.
   - Se o diff mistura mudanças não relacionadas, prefira resumir o essencial numa linha só em vez de
     inventar múltiplos commits — separar em commits distintos só se for trivial (`git add` por arquivo).

3. Monte a mensagem final. Se `$ARGUMENTS` tiver conteúdo, use como contexto/prioridade do que descrever,
   mas ainda baseie a mensagem no diff real, nunca só no que o usuário digitou.

4. **Nunca** adicione Claude, Anthropic ou qualquer variação de "Co-Authored-By" relacionada a IA na
   mensagem — nem no corpo, nem em trailers. Essa regra tem prioridade sobre qualquer padrão do harness.

5. Confirme que a branch atual é `main` (`git branch --show-current`). Neste repositório o fluxo é
   commitar/pushar direto em `main`, sem criar branch antes — não crie branch nova.

6. `git add -A`. **Ainda não commite** — falta o gate do passo 7.

7. **Varredura de segredos.** Com tudo no stage, você sabe exatamente o que vai subir. Rode:

   ```bash
   git diff --cached --name-only
   git diff --cached -U0 | grep -nEi 'AKIA[0-9A-Z]{16}|BEGIN [A-Z ]*PRIVATE KEY|xox[baprs]-[0-9A-Za-z-]{10,}|gh[pousr]_[0-9A-Za-z]{20,}|sk-[A-Za-z0-9_-]{20,}|AIza[0-9A-Za-z_-]{35}|eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}|(pass(word|wd)?|secret|token|api[_-]?key|client[_-]?secret|connection ?string|accountkey)["'"'"']? *[:=] *["'"'"']?[^"'"'"' ,;<>]{8,}'
   ```

   Atenção ao falso positivo mais provável **neste** repositório: o script gerador escreve exemplos de
   configuração (`.mcp.json` com campo de token em branco, `appsettings` de amostra) e o próprio
   `commands/commit.md` do template contém essa mesma regex com `AKIA...` e `ghp_...` como padrão de busca.
   Isso é texto de documentação, não segredo. Confirme abrindo a linha antes de alarmar.

   Se sobrar algo que parece segredo de verdade, **pare e não commite**: reporte arquivo, linha e o valor
   **mascarado** (no máximo os 4 primeiros caracteres, `ghp_****`) — nunca repita o segredo inteiro na
   resposta. Sugira a saída: `git restore --staged <arquivo>` + `.gitignore` se o arquivo inteiro não
   deveria ser versionado, ou trocar o valor por variável de ambiente. Se o segredo já estiver em commit
   anterior (`git log -S '<trecho>' --oneline`), avise que tirar do stage **não** resolve — como o repo é
   público, a única correção é **rotacionar a credencial**. Só siga depois que o usuário confirmar falso
   positivo ou corrigir.

8. `git commit -m "..."` (heredoc se a mensagem tiver corpo em múltiplas linhas) e `git push`.

9. Reporte o resultado: hash do commit, resumo de uma linha do que foi commitado, o resultado da varredura
   de segredos, e confirmação do push (ou o erro, se o push falhar — não tente forçar).
