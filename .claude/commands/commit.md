---
description: Gera a mensagem de commit a partir do diff atual, commita direto na main e faz push
argument-hint: [contexto opcional sobre o que mudou]
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git add:*), Bash(git commit:*), Bash(git push:*), Bash(git branch:*)
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

4. A mensagem de commit deve terminar com esta linha (obrigatória, harness):
   ```
   Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
   ```

5. Confirme que a branch atual é `main` (`git branch --show-current`). Neste repositório o fluxo é
   commitar/pushar direto em `main`, sem criar branch antes — não crie branch nova.

6. `git add -A`, `git commit -m "..."` (heredoc se a mensagem tiver corpo em múltiplas linhas) e
   `git push`.

7. Reporte o resultado: hash do commit, resumo de uma linha do que foi commitado, e confirmação do push
   (ou o erro, se o push falhar — não tente forçar).
