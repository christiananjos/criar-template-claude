---
description: Monta a estrutura SDD (monorepo backend/ + frontend/ pronto, com a linguagem de cada frente em aberto até o /definir-stack) seguindo as convenções oficiais do Claude Code (.claude/commands/ + .claude/agents/ prontos), num projeto novo ou já existente
argument-hint: [nome-do-projeto]
---

# /comecar — Montar Estrutura SDD

Monte a estrutura do projeto (agentes, comandos, knowledge/) usando o script de scaffolding deste plugin,
seguindo as convenções oficiais de projeto do Claude Code.

**Projeto novo nasce vazio.** Monorepo com `backend/` e `frontend/` só com a casca. O `/comecar` pergunta a stack
de cada frente, mas "ainda não sei / não vai ter" é sempre uma opção (o cliente costuma não saber o que quer no
começo) e frente sem stack não ganha agente nem skill de stack. A decisão pode vir depois, com `/definir-stack` (o que costuma vir depois de
`/amostra-arquitetura`, `/identidade-visual` e `/amostra-telas`).

## Fluxo de Confirmação

Faça as perguntas abaixo, uma de cada vez, na ordem. A primeira pergunta muda o resto do fluxo. Depois de
todas respondidas, **execute tudo o resto automaticamente, sem pedir mais nenhuma confirmação**.

### Pergunta 1 — Projeto novo ou existente

> "Você quer criar um projeto novo do zero, ou acoplar este pipeline SDD a um projeto que já existe (que já
> tem código/casca escrita)?
> 1. Novo projeto (do zero)
> 2. Projeto existente (só acrescenta o pipeline, sem sobrescrever o código)"

Guarde a resposta como `MODO`: `novo` ou `existente`.

### Pergunta 2 — Caminho

- Se `MODO = novo`: "Qual o caminho (pasta) onde o projeto deve ser criado?" Se o usuário não especificar, assuma o diretório atual (`.`).
- Se `MODO = existente`: "Qual o caminho da pasta raiz do projeto já existente?" Essa pasta **precisa já existir** — se não existir, avise e não prossiga com essa resposta.

### Pergunta 3 — Nome do projeto

- Se `MODO = novo`: se o usuário já informou o nome no argumento do comando, use-o direto e não pergunte de novo; caso contrário, pergunte "Qual o nome do projeto?"
- Se `MODO = existente`: **não pergunte** — use o nome da pasta existente (`basename` do caminho da Pergunta 2) como identificador.

### Pergunta 4 — Frente(s) e stack (SÓ no modo existente)

- Se `MODO = novo`: o template nasce **vazio** (`backend/` e `frontend/` só com a casca) e nenhuma stack é
  instalada sem o usuário escolher. Pergunte uma frente de cada vez, backend primeiro:

  > "Qual stack de backend?
  > 1. .NET (Clean Architecture)
  > 2. Ainda não sei / não vai ter backend (a pasta fica vazia)"

  > "Qual stack de frontend?
  > 1. Angular
  > 2. React
  > 3. Vue
  > 4. Ainda não sei / não vai ter frontend (a pasta fica vazia)"

  Mapeie: `.NET` → `dotnet`; `Angular` → `angular`; `React` → `react`; `Vue` → `vue`; a última opção de cada
  pergunta → `backend-pendente` / `frontend-pendente`. Frente pendente **não ganha** specialist nem skills de
  stack; se a decisão vier depois, `/definir-stack` instala. Monte `STACKS_ESCOLHIDAS` (backend primeiro, ex.:
  `dotnet frontend-pendente`) e siga para "A Partir Daqui".
- Se `MODO = existente`: o código já existe e tem uma stack conhecida, então pergunte. Primeiro as frentes, como
  uma única escolha:

  > "Quais frentes o projeto tem?
  > 1. Só backend
  > 2. Só frontend
  > 3. Backend + frontend (monorepo: um único `.claude/` e `knowledge/` na raiz, código em `backend/` e `frontend/`)"

  Depois a stack de cada frente escolhida, uma de cada vez (cada opção ativa só os agentes relevantes — sem gastar
  token com o que não vai ser usado):

  - Backend: `.NET` (Clean Architecture) — é a única stack de backend hoje.
  - Frontend: `Angular`, `React` ou `Vue`.

  Deixe claro que essas são as stacks do código já existente — no monorepo existente, o código do back precisa
  estar em `backend/` e o do front em `frontend/` (se estiver em outro lugar, avise o usuário e não prossiga).
  No monorepo existente, se o usuário disser que **ainda não definiu** a linguagem de uma frente, use
  `backend-pendente` ou `frontend-pendente` no lugar da stack dela.

  Mapeie as respostas para os parâmetros do script:

  | Resposta do usuário | Parâmetro |
  |---|---|
  | .NET | `dotnet` |
  | Angular | `angular` |
  | React | `react` |
  | Vue | `vue` |
  | Ainda não definida (backend / frontend) | `backend-pendente` / `frontend-pendente` |

  Monte `STACKS_ESCOLHIDAS`: uma palavra (só backend ou só frontend) ou duas separadas por espaço, backend primeiro
  (ex.: `dotnet react`). Duas frentes = monorepo; uma = projeto de uma frente só, com `src/` na raiz.

## A Partir Daqui — Tudo Automático

Depois das respostas, **não faça mais nenhuma pergunta**. Rode o script passando o modo como último argumento:

**Se `MODO = novo`** (cria `./NOME_DO_PROJETO` a partir do caminho informado):
```bash
mkdir -p "CAMINHO_INFORMADO" && cd "CAMINHO_INFORMADO" && bash "${CLAUDE_PLUGIN_ROOT}/criar-template-claude-sdd-plugin.sh" NOME_DO_PROJETO STACKS_ESCOLHIDAS novo
```
Se o caminho informado for o diretório atual (`.`), pule o `mkdir`/`cd` e rode o script direto.

**Se `MODO = existente`** (entra na pasta já existente e acopla o pipeline nela, sem criar subpasta nova):
```bash
cd "CAMINHO_DO_PROJETO_EXISTENTE" && bash "${CLAUDE_PLUGIN_ROOT}/criar-template-claude-sdd-plugin.sh" "$(basename "$PWD")" STACKS_ESCOLHIDAS existente
```

Onde `STACKS_ESCOLHIDAS` é uma stack (`dotnet`, `angular`, `react` ou `vue`) ou duas — um backend e um frontend, por exemplo `dotnet react`, o que gera o monorepo (cada uma pode ser `backend-pendente` / `frontend-pendente`, só no monorepo).

No modo `existente`, o script:
- **Não sobrescreve** código em `src/`, nem `README.md`, `CLAUDE.md`, `.mcp.json`, `docs/SPEC.md` ou `.gitignore` que já existam (só cria o que estiver faltando; se `.gitignore` já existir, só acrescenta as regras do próprio pipeline — entre elas a negação `!knowledge/`, para a memória do projeto ir versionada).
- Se `.claude/settings.json` já existir, faz **merge** (hook de token-report + `permissions`) em vez de sobrescrever, preservando o que já estava configurado.
- Sempre (re)cria `.claude/commands/`, `.claude/agents/`, `.claude/rules/`, `knowledge/` (vazia) e o hook de tokens — isso é a "máquina" do pipeline, não código do usuário.
- Os agentes de arquitetura e implementação (`02-architect-sdd`, `03-*-specialist`) são instruídos a **ler a estrutura de código já existente antes de propor ou gerar qualquer coisa**, seguindo as convenções já em uso em vez de reinventar do zero.

E então:
1. Confirme o resultado, mencionando o modo usado (novo projeto vs. pipeline acoplado a um projeto existente) e a
   situação de cada frente (ex.: "monorepo com backend/ e frontend/ prontos, linguagem de cada frente em aberto" ou
   ".NET 10 (backend/) + React 18 + TypeScript (frontend/) — monorepo").
2. Explique os próximos passos, sem esperar resposta:
   - (Se `novo`) Entrar na pasta do projeto criado
   - (Opcional) Colocar documentação bruta (Word, PDF, planilhas, imagens...) em `docs/raw/`
   - Editar `docs/backend/SPEC.md` e/ou `docs/frontend/SPEC.md` com a especificação mínima (no modo `existente`, descrevendo o que falta implementar/mudar)
   - (Cliente ainda decidindo) Mostrar antes de codar: `/amostra-arquitetura` (PDF da arquitetura completa sugerida), `/identidade-visual` (identidade do cliente a partir do site/logo) e `/amostra-telas` (apresentação de design, sem projeto de código)
   - (Se alguma frente estiver pendente) Rodar `/definir-stack` — ele pergunta a linguagem e instala o specialist — e reabrir o Claude Code (`claude --continue`)
   - Rodar `/inicia-orquestracao backend` ou `/inicia-orquestracao frontend` (uma frente por rodada), dentro do projeto aberto pela raiz, com o Docker aberto: o pipeline sobe os ambientes locais e valida neles antes do push
   - Só quando quiser ir para o cliente: `/subir-no-cliente`, que gera um guia simples a partir do que foi validado

## Resultado Esperado

O script cria a seguinte estrutura dentro de `NOME_DO_PROJETO/`, já alinhada à estrutura de projeto recomendada
pela documentação oficial do Claude Code. No modo `existente`, ele acrescenta as mesmas pastas/arquivos do
pipeline (`.claude/commands/`, `.claude/agents/`, `.claude/rules/`, `knowledge/`) dentro da pasta já existente,
pulando `src/`/`backend/`/`frontend/` e qualquer arquivo de usuário que já exista.

### Projeto novo (monorepo, linguagem em aberto)

```
NOME_DO_PROJETO/
├── CLAUDE.md            memória única: as duas frentes, os comandos de build de cada uma e as regras do monorepo
├── README.md            visão geral (tabela de pastas); o "como rodar" fica no README de cada pasta
├── .mcp.json  .gitignore    um só (o .gitignore tem as regras das duas stacks)
├── .claude/             agentes, comandos, rules, skills, hooks, scripts, settings — UM, compartilhado
│   ├── stack.json         a linguagem de cada frente ("pendente" até o /definir-stack)
│   ├── commands/          inicia-orquestracao, definir-stack, amostra-arquitetura, identidade-visual,
│   │                      amostra-telas, ambiente-local, subir-no-cliente, commit, raio-x-*, video-lancamento,
│   │                      documentacao-tecnica
│   ├── agents/            01, 02, 04, 05 e 06 (o 03, specialist da stack, entra no /definir-stack)
│   └── rules/             princípios de implementação, ambiente local primeiro, padrão de documentos, paralelismo, vault, frontend-*
├── knowledge/           UM vault para as duas frentes (vazio até o 01-analyst-sdd rodar)
├── docs/
│   ├── backend/SPEC.md, docs/frontend/SPEC.md    uma spec por frente
│   ├── raw/                 documentação bruta opcional, compartilhada
│   ├── modelo-documento/    modelo único dos PDFs (tokens.css é a única fonte de cores e fontes)
│   ├── entregaveis/         PDFs e HTMLs gerados para o cliente
│   └── design/              identidade visual do cliente (identidade.md)
├── output/              um só (só o token-report.md é versionado; o vídeo .mp4 do /video-lancamento fica aqui)
├── backend/             casca pronta, com CLAUDE.md curto (aviso de monorepo) e README.md
└── frontend/            casca pronta, com CLAUDE.md curto (aviso de monorepo) e README.md
```

Depois do `/definir-stack`, a pasta da frente ganha o esqueleto da stack (`backend/src/Domain|Application|
Infrastructure|API|Tests` no .NET; `frontend/src/` no front) e o specialist, as skills e as rules daquela stack
entram em `.claude/`.

O pipeline roda por frente ou nas duas ao mesmo tempo: `/inicia-orquestracao backend`, `frontend` ou `ambas` (sem
argumento, ele decide pela spec; frente com stack pendente é bloqueada até o `/definir-stack`). Em `ambas`, o
contrato da API fecha primeiro e depois backend e frontend são implementados juntos, cada um no próprio ritmo.

### Projeto de uma frente só (somente modo existente)

Com uma stack só, a estrutura é a de sempre: `src/` na raiz, `docs/SPEC.md` e um único specialist. Nesse formato
não há `/definir-stack` nem os comandos de amostra (que são do monorepo).

O conteúdo de `.claude/commands/inicia-orquestracao.md`, `.claude/commands/README.md`, `CLAUDE.md` e a spec já vem
ajustado automaticamente para refletir a situação das stacks — não é preciso editar nada manualmente depois.
`CLAUDE.md` e `.mcp.json` só são criados se ainda não existirem (mesma regra de não sobrescrita de
`README.md` e das specs); no monorepo com stack pendente, o `CLAUDE.md`, o `README.md` e os de `backend/` e
`frontend/` levam uma marca e são regravados quando a stack é definida.

Se o usuário colocar arquivos em `docs/raw/`, a primeira etapa do `/inicia-orquestracao` (`01-analyst-sdd`)
transforma tudo numa Base de Conhecimento estruturada em `knowledge/vault/`, compatível com Obsidian, que
os demais agentes passam a consultar como fonte única de verdade. Se `docs/raw/` ficar vazia, essa fase é pulada
automaticamente e o Analyst só valida a spec da frente.

Todo projeto criado já sai com um hook `Stop` configurado (`.claude/settings.json` + `.claude/hooks/generate-token-report.cjs`): ao final de cada rodada completa do `/inicia-orquestracao`, ele gera/atualiza `output/token-report.md` com o total de tokens gastos e o detalhamento por agente, sem precisar de nenhuma ação manual.


## Observação

Este comando apenas cria a estrutura do projeto. Ele **não** executa o pipeline SDD — isso é feito depois, de dentro do projeto criado, com `/inicia-orquestracao`. O `/inicia-orquestracao`, por sua vez, tem **uma única pausa manual**, logo após `01-analyst-sdd` validar a especificação: ele mostra o relatório completo (status, requisitos, regras de negócio, lacunas) e pergunta se o usuário aprova seguir — mesmo se o status já for ✅ APROVADO. Só depois dessa aprovação explícita o `02-architect-sdd` e o resto da cascata rodam, de forma 100% automática, sem pedir mais nenhuma confirmação; a partir daí só interrompe de novo se um gate técnico (`04-reviewer-sdd`, `05-test-engineer` ou `06-security-scan-sdd`) reportar falha ou se o ambiente local falhar. O ambiente local sobe entre o `02` e o `03` e a validação local roda depois do `06`; Docker parado ou validação reprovada também interrompem. Cada etapa aprovada vira um commit local, feito na conversa principal pelo fluxo do `/commit` (sem subagente), e o push acontece uma vez só, no fim. Se o usuário não aprovar na pausa inicial, o pipeline para ali mesmo.
