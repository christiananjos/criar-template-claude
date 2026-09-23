---
description: Atualiza este plugin (sdd) para a versão mais recente do marketplace e ressincroniza a estrutura SDD do projeto atual, preservando docs/raw/ e knowledge/
argument-hint: (nenhum argumento)
allowed-tools: Bash(claude plugin marketplace update:*), Bash(claude plugin update:*), Bash(claude plugin list:*), Bash(ls:*), Bash(cp:*), Bash(mkdir:*), Bash(date:*), Bash(basename:*), Bash(bash:*), Bash(git check-ignore:*), Bash(git status:*), Read, Edit
---

# /atualizar-versao — Atualizar o plugin e ressincronizar o projeto

Este comando tem **duas partes**, sempre nesta ordem:

1. Atualiza o plugin `sdd` para a versão mais recente do marketplace.
2. Reaplica a estrutura do template (comandos, agentes, rules, hooks) no projeto da pasta atual,
   **sem tocar em `docs/raw/` nem em `knowledge/`**.

A parte 2 existe porque atualizar o plugin **não** atualiza sozinho os projetos já gerados: os arquivos em
`.claude/commands/` e `.claude/agents/` são cópias gravadas no projeto na hora em que ele foi criado. Sem
reaplicar o template, o projeto continua com os comandos e agentes da versão antiga.

## Parte 1 — Atualizar o plugin

1. Rode `claude plugin list --json` e localize o objeto com `"id": "sdd@christian-criar-template-claude"`.
   Guarde o `version` atual. Se o plugin não aparecer na lista, avise que ele não está instalado nesta
   máquina/escopo (rode `/plugin install sdd@christian-criar-template-claude` primeiro) e pare.

2. Sincronize o marketplace com o repositório remoto:
   ```
   claude plugin marketplace update christian-criar-template-claude
   ```

3. Atualize o plugin para o que acabou de ser sincronizado:
   ```
   claude plugin update sdd@christian-criar-template-claude -y
   ```
   A própria saída já diz se atualizou (e de qual versão para qual) ou se já estava na mais recente.

4. Rode `claude plugin list --json` de novo e guarde o `installPath` do `sdd`. **Esse caminho é o que vale
   para a parte 2** — não use `${CLAUDE_PLUGIN_ROOT}` aqui: dentro da sessão atual essa variável ainda
   aponta para a pasta da versão **antiga** até o Claude Code ser reiniciado, e reaplicar o template a
   partir dela regravaria exatamente os arquivos velhos que estamos tentando substituir.

   O `installPath` vem como caminho do Windows (`C:\Users\...`). Para usar no Bash, troque `\` por `/`
   (`C:/Users/...`) e mantenha tudo entre aspas.

## Parte 2 — Ressincronizar a estrutura do projeto atual

Rode esta parte **mesmo que o plugin já estivesse na versão mais recente** — o projeto pode estar atrasado
em relação ao plugin.

5. Verifique se a pasta atual é um projeto gerado por este template: precisa existir
   `.claude/commands/inicia-orquestracao.md`. Se não existir, **pule a parte 2 inteira**, reporte só o resultado da
   parte 1 e explique que a pasta atual não é um projeto SDD (para acoplar o pipeline a ela, o comando é
   `/comecar`, escolhendo "projeto existente").

6. Descubra a stack do projeto pelo nome do arquivo do specialist em `.claude/agents/`:

   | Arquivo encontrado | Stack |
   |---|---|
   | `03-dotnet-specialist.md` | `dotnet` |
   | `03-react-specialist.md` | `react` |
   | `03-angular-specialist.md` | `angular` |
   | `03-vue-specialist.md` | `vue` |

   Se nenhum aparecer (ou aparecer mais de um), **pergunte a stack ao usuário** antes de seguir — passar a
   stack errada reescreveria os agentes com os da stack errada.

7. Faça um backup da `.claude/` atual antes de reescrever, para o usuário não perder customizações que
   tenha feito à mão nos agentes/comandos:
   ```bash
   BACKUP="output/.claude-backup-$(date +%Y%m%d-%H%M%S)" && mkdir -p "$BACKUP" && cp -r .claude/. "$BACKUP/"
   ```
   `output/` já é ignorado pelo Git, então o backup não suja o repositório. Guarde o caminho para reportar.

8. Reaplique o template com o script da **versão nova**, no modo `existente`:
   ```bash
   bash "CAMINHO_DO_INSTALLPATH/criar-template-claude-sdd-plugin.sh" "$(basename "$PWD")" STACK_DETECTADA existente
   ```

9. **Confirme que a memória do projeto vai mesmo versionada** — este passo não é opcional, é o que pega o
   caso em que o projeto foi gerado por uma versão antiga e alguma regra continua engolindo `knowledge/`:
   ```bash
   git check-ignore -v knowledge/vault knowledge/index.json
   ```
   - **Sem saída** = está tudo certo, `knowledge/` não está sendo ignorada. Siga.
   - **Com saída** = o arquivo e a linha do `.gitignore` responsáveis aparecem ali. Acrescente ao final do
     `.gitignore` (a negação precisa vir **depois** da regra que ignora, e a linha dos chunks **depois** da
     negação, senão ela também é reabilitada):
     ```
     # knowledge/ é a memória do projeto e vai versionada
     !knowledge/
     !knowledge/**
     knowledge/embeddings/chunks/
     knowledge/embeddings/fontes/
     ```
     Se a regra culpada estiver num `.gitignore` de subpasta (o `git check-ignore -v` mostra o caminho do
     arquivo), corrija naquele arquivo. Rode o comando de novo até não sair nada.

   Se a pasta `knowledge/` estiver vazia, o `git check-ignore` não prova nada e o `git status` também não
   vai mostrar nada — **o Git não versiona diretório vazio**. Nesse caso diga ao usuário que ainda não há
   memória para versionar: ela passa a existir na primeira rodada do `/inicia-orquestracao` (ou assim que algum
   agente gravar no vault), e aí sim o `/commit` a leva junto.

10. Reporte o resultado (ver "O que reportar" abaixo).

## O que é reescrito e o que é preservado

O modo `existente` do script é o que garante isso — não invente flags nem apague nada à mão.

**Preservado (nunca é tocado):**

- `docs/raw/` — inclusive o `README.md` dela, se já existir. Toda a documentação bruta injetada pelo
  usuário continua exatamente onde está.
- `knowledge/` — o vault inteiro (`vault/`, `graph/`, `embeddings/`, `source/`, `index.json`, templates).
  O script só garante que a pasta exista; **nunca grava nada dentro dela**.
- `src/` e todo o código do projeto.
- `docs/SPEC.md`, `CLAUDE.md`, `README.md`, `.mcp.json` — mantidos se já existirem.
- `.gitignore` — se já existir, só ganha as regras do pipeline que faltarem, conferidas **uma a uma**
  (`output/`, `.claude/`, `!knowledge/`). Isso importa em projeto antigo: até a v3.17.0 o script olhava só
  para o comentário `# Pipeline SDD (criar-template-claude)` e, achando-o, pulava o bloco inteiro — então
  regra nova nunca chegava em projeto já existente. A negação `!knowledge/` é o que garante que a memória
  vá versionada mesmo num repositório que já ignorava a pasta.
- `.claude/settings.json` — sofre **merge** (hook de token-report, `permissions`, plugin ponytail),
  preservando o que o usuário já tinha configurado.
- `output/` — os artefatos de rodadas anteriores do pipeline continuam lá.

**Reescrito com a versão nova (é a "máquina" do pipeline, não conteúdo do usuário):**

- `.claude/commands/` — `inicia-orquestracao.md`, `commit.md`, `raio-x-projeto.md`, `README.md`
- `.claude/agents/` — os agentes `00` a `10` da stack detectada
- `.claude/rules/` — convenções por caminho de arquivo
- `.claude/skills/` — a skill da própria stack (`dotnet-expert`, `react-expert`, `angular-expert` ou
  `vue-expert`, conforme o projeto) mais as de apoio (`cicd-pipeline-expert`, `tech-leader-expert`, `qa-expert`, `aws-expert`, `architect-expert`, `github-expert`, `azure-expert`, `hostinger-expert`, `dba-expert`,
  `dotnet-security-expert`/`frontend-security-expert`). Todas terminam em `-expert`.
- `.claude/hooks/generate-token-report.cjs` e `.claude/scripts/knowledge-engine-build.cjs`

**Removido (único arquivo que o script apaga):**

- `COMECE-AQUI.md` — descontinuado na v3.17.0, o conteúdo dele virou a primeira metade do `README.md`.
  O script move o arquivo antigo para `output/COMECE-AQUI.removido-<timestamp>.md` (fora do Git) e apaga da
  raiz, para não sobrar um guia duplicado e desatualizado ao lado do README novo. Se ele estava versionado,
  a remoção entra no próximo commit. Não faça isso à mão — o script já cuida.

Fora esse caso, um arquivo que existia numa versão antiga do template e não existe mais na nova **não é
apagado** — ele fica no projeto sem ser sobrescrito. Se isso incomodar, o backup do passo 7 permite comparar
as duas versões da `.claude/` e remover o que sobrou à mão.

## O que reportar

- A versão do plugin: de X para Y, ou "já estava em Y".
- Se a parte 2 rodou: a stack detectada, a confirmação de que `docs/raw/` e `knowledge/` não foram
  alterados, e o caminho do backup da `.claude/` anterior.
- Se o projeto ainda tinha `COMECE-AQUI.md`: que ele foi removido (conteúdo já está no `README.md`) e onde
  ficou a cópia em `output/`, caso o usuário tivesse editado alguma coisa ali.
- O resultado do passo 9: `knowledge/` está versionada, ou (se estava sendo ignorada) qual regra de qual
  `.gitignore` foi corrigida — ou que o vault ainda está vazio e por isso não há nada a versionar ainda.
- Que o `/commit` do projeto passou a sincronizar o vault antes de commitar, levando memória e código no
  mesmo commit.
- Que é preciso **reiniciar a sessão do Claude Code** (fechar e abrir de novo) para os comandos e agentes
  novos entrarem em vigor — tanto os do plugin quanto os do projeto são carregados no início da sessão.
- Se a parte 2 foi pulada: o motivo (pasta atual não é um projeto SDD).

## Observação

Isso atualiza só este plugin e o projeto da pasta atual — não mexe em outros marketplaces, outros plugins
instalados, nem em outros projetos gerados pelo template. Para atualizar outro projeto, rode
`/atualizar-versao` de dentro dele.
