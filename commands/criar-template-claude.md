---
description: Cria um novo projeto (.NET, Angular, React ou Vue — uma stack por vez) com estrutura SDD completa (commands/ + agents/ prontos) para rodar o pipeline de agentes depois
argument-hint: [nome-do-projeto]
---

# /criar-template-claude — Criar Novo Projeto SDD

Crie um novo projeto usando o script de scaffolding deste plugin.

## Fluxo de Confirmação (Apenas 3 Perguntas)

Faça **somente estas três perguntas** ao usuário, uma de cada vez. Depois de respondidas, **execute tudo o resto automaticamente, sem pedir mais nenhuma confirmação**.

### Pergunta 1 — Caminho do projeto

Pergunte onde o projeto deve ser criado:

> "Qual o caminho (pasta) onde o projeto deve ser criado?"

Se o usuário não especificar, assuma o diretório atual (`.`).

### Pergunta 2 — Nome do projeto

Se o usuário já informou o nome no argumento do comando, use-o diretamente e não pergunte de novo. Caso contrário, pergunte:

> "Qual o nome do projeto?"

### Pergunta 3 — Stack

Pergunte qual stack o usuário quer, como **uma única escolha**. Este template cria **UMA stack por projeto** — nunca backend e frontend juntos no mesmo projeto. Cada opção gera um projeto 100% naquela stack, com só os agentes relevantes a ela (sem misturar contexto/agentes à toa e sem gastar token com o que não vai ser usado):

> "Qual stack você quer usar?
> 1. .NET (backend, Clean Architecture)
> 2. Angular
> 3. React
> 4. Vue"

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

Depois das três respostas, **não faça mais nenhuma pergunta**. O script só aceita o nome do projeto (cria `./NOME_DO_PROJETO` a partir do diretório atual), então primeiro entre no caminho informado e depois rode o script só com o nome:

```bash
mkdir -p "CAMINHO_INFORMADO" && cd "CAMINHO_INFORMADO" && bash "${CLAUDE_PLUGIN_ROOT}/criar-template-claude-sdd-plugin.sh" NOME_DO_PROJETO STACK_ESCOLHIDA
```

Onde `STACK_ESCOLHIDA` é um de: `dotnet`, `angular`, `react`, `vue`. Se o caminho informado for o diretório atual (`.`), pule o `mkdir`/`cd` e rode o script direto.

E então:
1. Confirme que o projeto foi criado, mencionando a stack final (ex: "React 18 + TypeScript (somente frontend)" ou ".NET 10 (Clean Architecture, somente backend)")
2. Explique os próximos passos, sem esperar resposta:
   - Entrar na pasta do projeto criado
   - (Opcional) Colocar documentação bruta (Word, PDF, planilhas, imagens...) em `.docs/`
   - Editar `docs/SPEC.md` com a especificação da aplicação
   - Rodar `/orchestrator` dentro do projeto para disparar os agentes automaticamente

## Resultado Esperado

O script cria a seguinte estrutura dentro de `NOME_DO_PROJETO/`:

```
NOME_DO_PROJETO/
├── commands/
│   ├── orchestrator.md    ← comando que o usuário vai chamar depois
│   └── README.md
├── agents/                 ← knowledge-bootstrap (Fase 0) + agentes da stack escolhida
│                              (dotnet: 10 agentes, incl. dotnet-specialist e swagger-tester;
│                               frontend: 9 agentes, com react/angular/vue-specialist no lugar deles)
├── .docs/                  ← opcional: documentação bruta de entrada (README.md explica o uso)
├── docs/SPEC.md            ← template para o usuário preencher
├── knowledge/
│   └── templates/          ← templates Obsidian prontos (Feature, API, ADR, Bug, TestCase);
│                              o resto (vault/, graph/, embeddings/, cache/, index.json) é gerado
│                              pelo agente knowledge-bootstrap na primeira vez que .docs/ tiver arquivos
├── .claude/
│   ├── settings.json       ← registra o hook Stop de relatório de tokens + habilita o plugin ponytail
│   ├── hooks/generate-token-report.cjs
│   └── scripts/knowledge-engine-build.cjs  ← reconstrói grafo/embeddings a partir de knowledge/vault/
├── output/                 ← ao final de cada rodada do /orchestrator, ganha output/token-report.md
└── src/                    ← dotnet: Domain, Application, Infrastructure, API, Tests
                                frontend: pasta única, organizada pelo specialist da stack
```

O conteúdo de `commands/orchestrator.md`, `commands/README.md` e `docs/SPEC.md` já vem ajustado automaticamente para refletir a stack escolhida — não é preciso editar nada manualmente depois.

Se o usuário colocar arquivos em `.docs/`, a primeira etapa do `/orchestrator` (Fase 0 — `knowledge-bootstrap`)
transforma tudo numa Base de Conhecimento estruturada em `knowledge/vault/`, compatível com Obsidian, que
os demais agentes passam a consultar como fonte única de verdade. Se `.docs/` ficar vazia, essa fase é pulada
automaticamente e o pipeline segue como antes, só a partir de `docs/SPEC.md`.

Todo projeto criado já sai com um hook `Stop` configurado (`.claude/settings.json` + `.claude/hooks/generate-token-report.cjs`): ao final de cada rodada completa do `/orchestrator`, ele gera/atualiza `output/token-report.md` com o total de tokens gastos e o detalhamento por agente, sem precisar de nenhuma ação manual.

O mesmo `.claude/settings.json` já sai com o plugin [ponytail](https://github.com/DietrichGebert/ponytail) habilitado (`extraKnownMarketplaces` + `enabledPlugins`), que ajuda a reduzir o consumo de tokens da sessão — carrega automaticamente ao abrir o projeto, sem instalação manual.

## Observação

Este comando apenas cria a estrutura do projeto. Ele **não** executa o pipeline SDD — isso é feito depois, de dentro do projeto criado, com `/orchestrator`. O `/orchestrator`, por sua vez, tem **uma única pausa manual**, logo após `orchestrator-sdd` validar a especificação: ele mostra o relatório completo (status, requisitos, regras de negócio, lacunas) e pergunta se o usuário aprova seguir — mesmo se o status já for ✅ APROVADO. Só depois dessa aprovação explícita o `architect-sdd` e o resto da cascata rodam, de forma 100% automática, sem pedir mais nenhuma confirmação; a partir daí só interrompe de novo se um gate técnico (`compliance-validator`, `code-review-sdd` ou `build-test-validator`) reportar falha. Se o usuário não aprovar na pausa inicial, o pipeline para ali mesmo.


