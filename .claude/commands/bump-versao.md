---
description: Sincroniza a versão do plugin em todos os arquivos (plugin.json, marketplace.json, banners do script) antes de lançar uma mudança
argument-hint: [nova-versão, ex: 2.4.0]
allowed-tools: Bash(grep -rn:*), Bash(bash -n:*), Read, Edit
---

Argumento opcional passado pelo usuário: $ARGUMENTS

## O que fazer

1. Leia o campo `version` em `.claude-plugin/plugin.json` e em `.claude-plugin/marketplace.json`
   (dentro de `plugins[0]`). Confirme que os dois batem — se não baterem, avise antes de continuar (indica
   que uma versão anterior ficou dessincronizada).

2. Determine a nova versão:
   - Se `$ARGUMENTS` tiver um valor no formato `X.Y.Z`, use-o.
   - Caso contrário, pergunte ao usuário qual versão usar, sugerindo como padrão o próximo `minor`
     (`X.(Y+1).0`) — reserve `patch` pra correções pequenas e só suba `major` se o usuário indicar quebra
     de compatibilidade (ex: renomear um comando, como aconteceu na 2.3.0).

3. Atualize o campo `version` (via Edit, não sed) nestes 5 lugares:
   - `.claude-plugin/plugin.json`
   - `.claude-plugin/marketplace.json` (dentro de `plugins[0]`)
   - `criar-template-claude-sdd-plugin.sh`, comentário de topo (`# 🚀 Criar Template Claude SDD vX.Y.Z`)
   - `criar-template-claude-sdd-plugin.sh`, `echo` do banner de abertura (mesmo texto, dentro do `echo -e`
     logo no início da execução do script)
   - `criar-template-claude-sdd-plugin.sh`, rodapé do README gerado dentro de cada projeto
     (`**Projeto criado com Claude SDD vX.Y.Z**`)

   **Não toque** em nenhuma linha que cite uma versão como marco histórico — por exemplo o comentário do
   bloco de limpeza de agentes legados, que diz algo como "execuções deste script anteriores à vX.Y.Z". Essa
   é uma referência fixa a quando um comportamento foi introduzido, não a versão atual do plugin.

4. Rode `grep -rn "v<VERSÃO ANTIGA>"` (com a versão antiga, ex: `v2.2.0`) na raiz do repositório e confirme
   que só sobrou (se sobrar) a linha histórica do passo 3. Se sobrar mais alguma referência à versão antiga,
   corrija também.

5. Rode `bash -n criar-template-claude-sdd-plugin.sh` para confirmar que o script continua sintaticamente
   válido depois das edições.

6. Reporte um resumo (versão antiga → nova, lista de arquivos tocados) e pergunte se o usuário quer
   commitar agora. **Não commite sozinho** — isso é responsabilidade do `/commit`.
