# Criar Template Claude — Pipeline SDD

Plugin para Claude Code que cria projetos de **uma stack só** (.NET, Angular, React ou Vue — nunca backend e frontend misturados no mesmo projeto) com um pipeline de agentes que especifica, implementa, testa e revisa código automaticamente — tudo dentro do Claude Code, sem serviços externos.

## Como funciona

1. `/criar-template-claude` gera a estrutura do projeto (`commands/`, `agents/`, `.docs/`, `docs/SPEC.md`, `knowledge/`, `output/`, `src/`)
2. (Opcional) Você joga documentação bruta — Word, PDF, planilhas, imagens, atas de reunião — em `.docs/`
3. Você descreve a aplicação em `docs/SPEC.md`
4. Dentro do projeto, `/orchestrator` dispara o pipeline: se `.docs/` tiver arquivos, primeiro consolida tudo numa Base de Conhecimento em `knowledge/` (compatível com Obsidian); depois valida a spec, define arquitetura, implementa a stack escolhida, gera testes, revisa qualidade, valida build, gera commits e (só no `.NET`) testa a API — parando automaticamente se algum gate de qualidade reprovar
5. Resultado em `output/`, incluindo `token-report.md` com o custo em tokens de cada rodada; `knowledge/` persiste entre rodadas como base de conhecimento viva do projeto

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

Na criação, o plugin pergunta três coisas, uma de cada vez: caminho, nome do projeto e a stack, como uma única
escolha (`.NET`, `Angular`, `React` ou `Vue`) — cada projeto sai com **uma stack só**, sem backend e frontend
misturados. Isso muda o que é gerado — o `orchestrator.md`, `commands/README.md`, `docs/SPEC.md`, os agentes e
a pasta `src/` já saem ajustados para a stack escolhida. Se um frontend precisar consumir uma API, ela é
externa (outro projeto/time) — o template não gera backend e frontend juntos.

O `/orchestrator` leva ~15-30 minutos e não pausa pra confirmação no meio — só interrompe se `orchestrator-sdd`, `compliance-validator`, `code-review-sdd` ou `build-test-validator` reportar falha.

## Agentes

Todo projeto sai com 9 agentes fixos (mais `knowledge-bootstrap`, Fase 0) e o specialist da stack escolhida:

| Agente | Responsabilidade | Quando existe |
|---|---|---|
| `knowledge-bootstrap` | Fase 0 — consolida `.docs/` numa Base de Conhecimento em `knowledge/` (só roda se `.docs/` tiver arquivos) | sempre |
| `orchestrator-sdd` | Valida a especificação | sempre |
| `architect-sdd` | Gera arquitetura técnica e rastreabilidade | sempre |
| `dotnet-specialist` | Implementa o backend .NET 10 | só stack `dotnet` |
| `react-specialist` / `angular-specialist` / `vue-specialist` | Implementa o frontend | só a stack correspondente |
| `compliance-validator` | Audita conformidade com a spec | sempre |
| `test-validator` | Gera testes automatizados | sempre |
| `code-review-sdd` | Revisa qualidade e SOLID | sempre |
| `build-test-validator` | Valida build e testes | sempre |
| `commit-message-generator` | Gera commits semânticos | sempre |
| `swagger-tester` | Gera workflow de testes de API | só stack `dotnet` (não há API num projeto 100% frontend) |

`commit-message-generator` e `swagger-tester` usam Haiku por serem etapas de baixo risco; os demais usam Sonnet.

## Base de Conhecimento (Knowledge Engine)

Se você tiver documentação já pronta do projeto (Word, PDF, planilhas, imagens, atas de reunião), coloque tudo
em `.docs/` antes de chamar `/orchestrator`. A Fase 0 (`knowledge-bootstrap`) lê e consolida todo esse material
em `knowledge/vault/` — uma base de conhecimento em Markdown, compatível com Obsidian (pastas por domínio,
links `[[internos]]`, glossário e índice), além de um grafo de relacionamentos (`knowledge/graph/`), chunks
prontos para busca semântica (`knowledge/embeddings/`) e um resumo por área (`knowledge/cache/`) para os
demais agentes consultarem em vez de reler tudo. Se `.docs/` estiver vazia, essa fase é pulada e o pipeline
segue normalmente a partir de `docs/SPEC.md`, como sempre funcionou.

`knowledge/graph/` e `knowledge/embeddings/` são reconstruídos deterministicamente por
`.claude/scripts/knowledge-engine-build.cjs` (sem dependências) a partir dos wikilinks do vault — não são
escritos à mão pelo agente. Vetores de embedding "de verdade" não são calculados aqui (exigiria uma API/modelo
de embeddings); os chunks já ficam prontos para quem quiser plugar esse passo depois.

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
