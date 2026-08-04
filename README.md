# Criar Template Claude — Pipeline SDD

Plugin para Claude Code que cria projetos **.NET (Clean Architecture)** com um pipeline de agentes que especifica, implementa, testa e revisa código automaticamente — tudo dentro do Claude Code, sem serviços externos.

## Como funciona

1. `/criar-template-claude` gera a estrutura do projeto (`commands/`, `agents/`, `docs/SPEC.md`, `output/`, `src/`)
2. Você descreve a aplicação em `docs/SPEC.md`
3. Dentro do projeto, `/orchestrator` dispara o pipeline: valida a spec, define arquitetura, implementa backend (e frontend, se escolhido), gera testes, revisa qualidade, valida build, gera commits e testa a API — parando automaticamente se algum gate de qualidade reprovar
4. Resultado em `output/`, incluindo `token-report.md` com o custo em tokens de cada rodada

## Instalação

```
/plugin marketplace add christiananjos/criar-template-claude
/plugin install christian-criar-template-claude@christian-criar-template-claude
```

## Uso

```
/christian-criar-template-claude:criar-template-claude meu-projeto
cd meu-projeto
nano docs/SPEC.md
/orchestrator
```

Na criação, o plugin pergunta só duas coisas: nome/pasta do projeto e frontend (React, Angular, Vue ou nenhum). Isso muda o que é gerado — o `orchestrator.md`, `commands/README.md`, `docs/SPEC.md` e o agente de frontend correto já saem ajustados para a stack escolhida.

O `/orchestrator` leva ~20-30 minutos e não pausa pra confirmação no meio — só interrompe se `orchestrator-sdd`, `compliance-validator`, `code-review-sdd` ou `build-test-validator` reportar falha.

## Agentes

| Agente | Responsabilidade |
|---|---|
| `orchestrator-sdd` | Valida a especificação |
| `architect-sdd` | Gera arquitetura técnica e rastreabilidade |
| `dotnet-specialist` | Implementa backend .NET 8 |
| `react-specialist` / `angular-specialist` / `vue-specialist` | Implementa frontend (conforme escolhido na criação) |
| `compliance-validator` | Audita conformidade com a spec |
| `test-validator` | Gera testes automatizados |
| `code-review-sdd` | Revisa qualidade e SOLID |
| `build-test-validator` | Valida build e testes |
| `commit-message-generator` | Gera commits semânticos |
| `swagger-tester` | Gera workflow de testes de API |

`.NET Specialist`/`frontend-specialist` rodam em paralelo (só dependem do `architect-sdd`), assim como `commit-message-generator`/`swagger-tester` (só dependem do `build-test-validator`). `commit-message-generator` e `swagger-tester` usam Haiku por serem etapas de baixo risco; os demais usam Sonnet.

## Relatório de tokens

Todo projeto gerado já sai com um hook `Stop` (`.claude/settings.json` + `.claude/hooks/generate-token-report.cjs`) que, ao final de cada rodada do `/orchestrator`, atualiza `output/token-report.md` com o total de tokens gastos e o detalhamento por agente — lido direto dos transcripts da sessão, sem estimativa do modelo.

## Estrutura do plugin

```
criar-template-claude/
├── .claude-plugin/
│   ├── plugin.json
│   └── marketplace.json
├── commands/criar-template-claude.md     # comando do plugin instalado
└── criar-template-claude-sdd-plugin.sh   # script de scaffolding
```

Cada projeto **gerado** recebe sua própria estrutura `commands/` + `agents/` + `.claude/` — ver seções acima.

## Licença

MIT — Christian Anjos
