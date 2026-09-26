---
description: Monta a estrutura SDD (.NET, Angular, React ou Vue — uma stack por vez) seguindo as convenções oficiais do Claude Code (.claude/commands/ + .claude/agents/ prontos), num projeto novo ou já existente
argument-hint: [nome-do-projeto]
---

# /comecar — Montar Estrutura SDD

Monte a estrutura do projeto (agentes, comandos, knowledge/) usando o script de scaffolding deste plugin,
seguindo as convenções oficiais de projeto do Claude Code para a stack escolhida.

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

### Pergunta 4 — Stack

Pergunte qual stack o usuário quer, como **uma única escolha**. Este template cria/acopla **UMA stack por projeto** — nunca backend e frontend juntos no mesmo projeto. Cada opção ativa só os agentes relevantes a ela (sem misturar contexto/agentes à toa e sem gastar token com o que não vai ser usado):

> "Qual stack você quer usar?
> 1. .NET (backend, Clean Architecture)
> 2. Angular
> 3. React
> 4. Vue"

Se `MODO = existente`, deixe claro que essa é a stack do código já existente na pasta (não uma nova stack a ser criada do zero).

Mapeie a resposta para o parâmetro do script:

| Resposta do usuário | Parâmetro |
|---|---|
| .NET | `dotnet` |
| Angular | `angular` |
| React | `react` |
| Vue | `vue` |

Se o usuário pedir depois para integrar esse frontend com um backend (ou vice-versa), explique que, por enquanto,
cada projeto gerado por este template é uma stack isolada — a comunicação entre um frontend e um backend
criados como projetos separados é algo que o usuário decide e implementa por fora do template.

## A Partir Daqui — Tudo Automático

Depois das respostas, **não faça mais nenhuma pergunta**. Rode o script passando o modo como terceiro argumento:

**Se `MODO = novo`** (cria `./NOME_DO_PROJETO` a partir do caminho informado):
```bash
mkdir -p "CAMINHO_INFORMADO" && cd "CAMINHO_INFORMADO" && bash "${CLAUDE_PLUGIN_ROOT}/criar-template-claude-sdd-plugin.sh" NOME_DO_PROJETO STACK_ESCOLHIDA novo
```
Se o caminho informado for o diretório atual (`.`), pule o `mkdir`/`cd` e rode o script direto.

**Se `MODO = existente`** (entra na pasta já existente e acopla o pipeline nela, sem criar subpasta nova):
```bash
cd "CAMINHO_DO_PROJETO_EXISTENTE" && bash "${CLAUDE_PLUGIN_ROOT}/criar-template-claude-sdd-plugin.sh" "$(basename "$PWD")" STACK_ESCOLHIDA existente
```

Onde `STACK_ESCOLHIDA` é um de: `dotnet`, `angular`, `react`, `vue`.

No modo `existente`, o script:
- **Não sobrescreve** código em `src/`, nem `README.md`, `CLAUDE.md`, `.mcp.json`, `docs/SPEC.md` ou `.gitignore` que já existam (só cria o que estiver faltando; se `.gitignore` já existir, só acrescenta as regras do próprio pipeline — entre elas a negação `!knowledge/`, para a memória do projeto ir versionada).
- Se `.claude/settings.json` já existir, faz **merge** (hook de token-report + `permissions` + plugin ponytail) em vez de sobrescrever, preservando o que já estava configurado.
- Sempre (re)cria `.claude/commands/`, `.claude/agents/`, `.claude/rules/`, `knowledge/` (vazia) e o hook de tokens — isso é a "máquina" do pipeline, não código do usuário.
- Os agentes de arquitetura e implementação (`02-architect-sdd`, `03-*-specialist`) são instruídos a **ler a estrutura de código já existente antes de propor ou gerar qualquer coisa**, seguindo as convenções já em uso em vez de reinventar do zero.

E então:
1. Confirme o resultado, mencionando a stack (ex: "React 18 + TypeScript (somente frontend)" ou ".NET 10 (Clean Architecture, somente backend)") e o modo usado (novo projeto vs. pipeline acoplado a um projeto existente).
2. Explique os próximos passos, sem esperar resposta:
   - (Se `novo`) Entrar na pasta do projeto criado
   - (Opcional) Colocar documentação bruta (Word, PDF, planilhas, imagens...) em `docs/raw/`
   - Editar `docs/SPEC.md` com a especificação (no modo `existente`, descrevendo o que falta implementar/mudar)
   - Rodar `/inicia-orquestracao` dentro do projeto para disparar os agentes automaticamente

## Resultado Esperado

No modo `novo`, o script cria a seguinte estrutura dentro de `NOME_DO_PROJETO/`, já alinhada à estrutura de
projeto recomendada pela documentação oficial do Claude Code. No modo `existente`, ele acrescenta as mesmas
pastas/arquivos do pipeline (`.claude/commands/`, `.claude/agents/`, `.claude/rules/`, `knowledge/`) dentro da
pasta já existente, pulando `src/` e qualquer arquivo de usuário que já exista:

```
NOME_DO_PROJETO/
├── CLAUDE.md                🧠 memória do projeto, lida pelo Claude em toda sessão
├── .mcp.json                 🔌 servidores MCP (context7 pronto; github com placeholder de token)
├── .claude/
│   ├── commands/
│   │   ├── inicia-orquestracao.md    ← comando que o usuário vai chamar depois
│   │   └── README.md
│   ├── agents/                 ← 6 agentes: analyst, architect, specialist da stack
│   │                              (dotnet/react/angular/vue), reviewer, test-engineer e security-scan
│   ├── rules/                   ← convenções por caminho de arquivo (Clean Architecture no dotnet,
│   │                              componente/estado no frontend, convenções do Knowledge Vault)
│   ├── settings.json           ← permissions (libera o que o pipeline precisa) + hook Stop de
│   │                              relatório de tokens + plugin ponytail habilitado
│   ├── hooks/generate-token-report.cjs
│   └── scripts/knowledge-engine-build.cjs  ← reconstrói grafo/embeddings a partir de knowledge/vault/
├── docs/SPEC.md              ← template para o usuário preencher
├── docs/raw/                    ← opcional: documentação bruta de entrada (README.md explica o uso)
├── knowledge/                 ← vazia na criação; tudo dentro dela (templates/, vault/, graph/,
│                                embeddings/, cache/, index.json) é gerado pelo agente 01-analyst-sdd
│                                na primeira vez que docs/raw/ tiver arquivos
├── output/                   ← ao final de cada rodada do /inicia-orquestracao, ganha output/token-report.md
└── src/                      ← dotnet: Domain, Application, Infrastructure, API, Tests
                                  frontend: pasta única, organizada pelo specialist da stack
```

O conteúdo de `.claude/commands/inicia-orquestracao.md`, `.claude/commands/README.md`, `CLAUDE.md` e `docs/SPEC.md`
já vem ajustado automaticamente para refletir a stack escolhida — não é preciso editar nada manualmente
depois. `CLAUDE.md` e `.mcp.json` só são criados se ainda não existirem (mesma regra de não sobrescrita de
`README.md`/`docs/SPEC.md`), e `claude --worktree nome-da-frente` deixa rodar duas frentes do
pipeline em paralelo sem os agentes esbarrarem nos mesmos arquivos.

Se o usuário colocar arquivos em `docs/raw/`, a primeira etapa do `/inicia-orquestracao` (`01-analyst-sdd`)
transforma tudo numa Base de Conhecimento estruturada em `knowledge/vault/`, compatível com Obsidian, que
os demais agentes passam a consultar como fonte única de verdade. Se `docs/raw/` ficar vazia, essa fase é pulada
automaticamente e o Analyst só valida `docs/SPEC.md`.

Todo projeto criado já sai com um hook `Stop` configurado (`.claude/settings.json` + `.claude/hooks/generate-token-report.cjs`): ao final de cada rodada completa do `/inicia-orquestracao`, ele gera/atualiza `output/token-report.md` com o total de tokens gastos e o detalhamento por agente, sem precisar de nenhuma ação manual.

O mesmo `.claude/settings.json` já sai com o plugin [ponytail](https://github.com/DietrichGebert/ponytail) pré-configurado (`extraKnownMarketplaces` + `enabledPlugins`), que ajuda a reduzir o consumo de tokens da sessão. Isso registra o marketplace e a intenção de habilitá-lo, mas não instala o plugin sozinho — a partir do Claude Code v2.1.195, um plugin de fonte externa só carrega depois de instalado pelo menos uma vez. Na primeira abertura do projeto, é preciso rodar `claude plugin install ponytail@ponytail` (ou aceitar quando o Claude Code avisar que ele não está instalado); dali em diante fica habilitado automaticamente.

## Observação

Este comando apenas cria a estrutura do projeto. Ele **não** executa o pipeline SDD — isso é feito depois, de dentro do projeto criado, com `/inicia-orquestracao`. O `/inicia-orquestracao`, por sua vez, tem **uma única pausa manual**, logo após `01-analyst-sdd` validar a especificação: ele mostra o relatório completo (status, requisitos, regras de negócio, lacunas) e pergunta se o usuário aprova seguir — mesmo se o status já for ✅ APROVADO. Só depois dessa aprovação explícita o `02-architect-sdd` e o resto da cascata rodam, de forma 100% automática, sem pedir mais nenhuma confirmação; a partir daí só interrompe de novo se um gate técnico (`04-reviewer-sdd`, `05-test-engineer` ou `06-security-scan-sdd`) reportar falha. O commit final roda na conversa principal, pelo fluxo do `/commit`, sem subagente. Se o usuário não aprovar na pausa inicial, o pipeline para ali mesmo.


