---
description: Cria um novo projeto .NET com estrutura SDD completa (commands/ + agents/ prontos) para rodar o pipeline de agentes depois
argument-hint: [nome-do-projeto]
---

# /criar-template-claude — Criar Novo Projeto SDD

Crie um novo projeto usando o script de scaffolding deste plugin.

## Fluxo de Confirmação (Apenas 2 Perguntas)

Faça **somente estas duas perguntas** ao usuário, uma de cada vez. Depois de respondidas, **execute tudo o resto automaticamente, sem pedir mais nenhuma confirmação**.

### Pergunta 1 — Pasta/nome do projeto

Se o usuário já informou o nome no argumento do comando, use-o diretamente e não pergunte de novo. Caso contrário, pergunte:

> "Qual o nome/pasta onde o projeto deve ser criado?"

### Pergunta 2 — Frontend

Pergunte qual frontend o usuário quer (isso muda de verdade quais agentes e arquivos são gerados):

> "Qual frontend você quer usar?
> 1. React
> 2. Angular
> 3. Vue
> 4. Nenhum (somente backend .NET)"

Mapeie a resposta para o parâmetro do script:

| Resposta do usuário | Parâmetro |
|---|---|
| React | `react` |
| Angular | `angular` |
| Vue | `vue` |
| Nenhum / só backend | `none` |

## A Partir Daqui — Tudo Automático

Depois das duas respostas, **não faça mais nenhuma pergunta**. Execute diretamente:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/criar-template-claude-sdd-plugin.sh" NOME_DO_PROJETO FRONTEND_ESCOLHIDO
```

Onde `FRONTEND_ESCOLHIDO` é um de: `react`, `angular`, `vue`, `none`.

E então:
1. Confirme que o projeto foi criado, mencionando a stack final (ex: ".NET 10 + React 18" ou ".NET 10 somente backend")
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
├── agents/                 ← knowledge-bootstrap (Fase 0) + 9 agentes fixos + 1 de frontend (se escolhido)
├── .docs/                  ← opcional: documentação bruta de entrada (README.md explica o uso)
├── docs/SPEC.md            ← template para o usuário preencher
├── knowledge/
│   └── templates/          ← templates Obsidian prontos (Feature, API, ADR, Bug, TestCase);
│                              o resto (vault/, graph/, embeddings/, cache/, index.json) é gerado
│                              pelo agente knowledge-bootstrap na primeira vez que .docs/ tiver arquivos
├── .claude/
│   ├── settings.json       ← registra o hook Stop de relatório de tokens
│   ├── hooks/generate-token-report.cjs
│   └── scripts/knowledge-engine-build.cjs  ← reconstrói grafo/embeddings a partir de knowledge/vault/
├── output/                 ← ao final de cada rodada do /orchestrator, ganha output/token-report.md
└── src/ (Domain, Application, Infrastructure, API, Tests)
```

O conteúdo de `commands/orchestrator.md`, `commands/README.md` e `docs/SPEC.md` já vem ajustado automaticamente para refletir a stack escolhida — não é preciso editar nada manualmente depois.

Se o usuário colocar arquivos em `.docs/`, a primeira etapa do `/orchestrator` (Fase 0 — `knowledge-bootstrap`)
transforma tudo numa Base de Conhecimento estruturada em `knowledge/vault/`, compatível com Obsidian, que
os demais agentes passam a consultar como fonte única de verdade. Se `.docs/` ficar vazia, essa fase é pulada
automaticamente e o pipeline segue como antes, só a partir de `docs/SPEC.md`.

Todo projeto criado já sai com um hook `Stop` configurado (`.claude/settings.json` + `.claude/hooks/generate-token-report.cjs`): ao final de cada rodada completa do `/orchestrator`, ele gera/atualiza `output/token-report.md` com o total de tokens gastos e o detalhamento por agente, sem precisar de nenhuma ação manual.

## Observação

Este comando apenas cria a estrutura do projeto. Ele **não** executa o pipeline SDD — isso é feito depois, de dentro do projeto criado, com `/orchestrator`. E o `/orchestrator`, por sua vez, também não deve parar para pedir confirmações extras no meio da cascata — só interrompe se um dos gates de qualidade (orchestrator-sdd, compliance-validator, code-review-sdd ou build-test-validator) reportar falha.


