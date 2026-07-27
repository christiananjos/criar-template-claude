# Criar Template Claude — Pipeline SDD v2.0

Plugin para Claude Code que cria projetos **.NET (Clean Architecture)** com um pipeline de **9 subagentes especializados** que implementam, testam e validam código automaticamente — direto dentro do Claude Code, sem dependências externas.

## ✨ O Que Este Plugin Faz

1. Cria a estrutura de um novo projeto .NET com `commands/` e `agents/` já prontos
2. Você descreve sua aplicação em `docs/SPEC.md`
3. Você chama `/orchestrator` dentro do projeto
4. 9 subagentes rodam em cascata: validam a spec, definem arquitetura, implementam backend/frontend, geram testes, revisam qualidade, validam build, geram commits e documentam a API

**Sem Python. Sem Node.js. Sem API key própria.** Os agentes rodam nativamente no Claude Code.

## 🚀 Instalação

```
/plugin marketplace add christiananjos/criar-template-claude
/plugin install christian-criar-template-claude@christian-criar-template-claude
```

## 📖 Como Usar

```bash
# 1. Criar um novo projeto
/christian-criar-template-claude:criar-template-claude meu-projeto
cd meu-projeto

# 2. Descrever a aplicação
nano docs/SPEC.md

# 3. Disparar o pipeline
/orchestrator
```

Aguarde 20-30 minutos. Resultados aparecem em `output/`.

## 🤖 Os 9 Agentes

| # | Agente | Responsabilidade |
|---|--------|-------------------|
| 1 | `orchestrator-sdd` | Valida a especificação |
| 2 | `architect-sdd` | Gera arquitetura técnica e rastreabilidade |
| 3 | `dotnet-specialist` | Implementa backend .NET 8 |
| 3 | `react-specialist` | Implementa frontend React 18 (opcional) |
| 4 | `compliance-validator` | Audita conformidade com a spec |
| 5 | `test-validator` | Gera testes automatizados |
| 6 | `code-review-sdd` | Revisa qualidade e SOLID |
| 7 | `build-test-validator` | Valida build e testes |
| 8 | `commit-message-generator` | Gera commits semânticos |
| 9 | `swagger-tester` | Gera workflow de testes de API |

## 📁 Estrutura do Plugin

```
criar-template-claude/
├── .claude-plugin/
│   ├── plugin.json
│   └── marketplace.json
├── commands/
│   └── criar-template-claude.md    # comando do plugin instalado
└── criar-template-claude-sdd-plugin.sh   # script de scaffolding
```

Cada projeto **gerado** por este plugin recebe sua própria estrutura `commands/` + `agents/` — ver seção acima.

## 📄 Licença

MIT — Christian Anjos
