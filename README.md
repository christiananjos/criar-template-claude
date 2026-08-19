# Criar Template Claude — Pipeline SDD

Plugin para Claude Code que cria projetos de **uma stack só** (.NET, Angular, React ou Vue — nunca backend e frontend misturados no mesmo projeto) com um pipeline de agentes que especifica, implementa, testa e revisa código automaticamente — tudo dentro do Claude Code, sem serviços externos.

## Como funciona

1. `/criar-template-claude` gera a estrutura do projeto (`.claude/commands/`, `.claude/agents/`, `CLAUDE.md`, `.mcp.json`, `docs/raw/`, `docs/SPEC.md`, `knowledge/`, `output/`, `src/`)
2. (Opcional) Você joga documentação bruta — Word, PDF, planilhas, imagens, atas de reunião — em `docs/raw/`
3. Você descreve a aplicação em `docs/SPEC.md`
4. Dentro do projeto, `/orchestrator` dispara o pipeline: se `docs/raw/` tiver arquivos, primeiro consolida tudo numa Base de Conhecimento em `knowledge/` (compatível com Obsidian); depois valida a spec, define arquitetura, implementa a stack escolhida, gera testes, revisa qualidade, valida build, gera commits e (só no `.NET`) testa a API — parando automaticamente se algum gate de qualidade reprovar
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
misturados. Isso muda o que é gerado — o `orchestrator.md`, `.claude/commands/README.md`, `CLAUDE.md`, `docs/SPEC.md`, os agentes e
a pasta `src/` já saem ajustados para a stack escolhida. Se um frontend precisar consumir uma API, ela é
externa (outro projeto/time) — o template não gera backend e frontend juntos.

O `/orchestrator` leva ~15-30 minutos e tem **uma única pausa manual**: assim que `orchestrator-sdd` valida a especificação, o pipeline mostra o relatório completo (status, requisitos, regras de negócio, lacunas) e pergunta se você aprova seguir — mesmo se o status já for ✅ APROVADO. Aprovando, o resto roda 100% automático até o fim, sem pedir mais nenhuma confirmação; só interrompe de novo se `compliance-validator`, `code-review-sdd` ou `build-test-validator` reportar falha. Se você não aprovar na pausa inicial, o pipeline para ali, sem gerar arquitetura nem código.

## Acoplar num projeto já existente

Além de criar um projeto do zero, o `/criar-template-claude` também acopla o pipeline a um projeto que **já
tem código** (uma casca inicial, um projeto em andamento etc.). A primeira pergunta do comando é justamente
essa: "novo" ou "existente". Escolhendo "existente" e informando o caminho do projeto já existente:

- **Nada do código é tocado** — `src/` não recebe a estrutura de pastas do template, só o que o script sempre cria (`.claude/commands/`, `.claude/agents/`, `.claude/rules/`, `knowledge/`).
- **Nenhum arquivo do usuário é sobrescrito** — `README.md`, `COMECE-AQUI.md`, `CLAUDE.md`, `.mcp.json` e `docs/SPEC.md` só são criados se ainda não existirem.
- **`.gitignore`** existente é mantido; só as regras específicas do pipeline (`output/`, `knowledge/embeddings/chunks/`, estado do hook, `.claude/worktrees/`) são acrescentadas, sem duplicar em reexecuções.
- **`.claude/settings.json`** existente sofre *merge* (hook de token-report + `permissions` + ponytail somados ao que já estava configurado), nunca substituição.
- **`architect-sdd` e os `*-specialist`** são instruídos a ler a estrutura/convenções já existentes em `src/` antes de propor arquitetura ou gerar código — estendendo o que já existe em vez de reimplementar do zero.

Daí em diante o fluxo é o mesmo: editar `docs/SPEC.md` (aqui, descrevendo o que falta implementar) e rodar `/orchestrator`.

## Agentes

Todo projeto sai com 9 agentes fixos (mais `knowledge-bootstrap`, Fase 0) e o specialist da stack escolhida:

| Agente | Responsabilidade | Quando existe |
|---|---|---|
| `knowledge-bootstrap` | Fase 0 — consolida `docs/raw/` numa Base de Conhecimento em `knowledge/` (só roda se `docs/raw/` tiver arquivos) | sempre |
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
em `docs/raw/` antes de chamar `/orchestrator`. A Fase 0 (`knowledge-bootstrap`) lê e consolida todo esse material
em `knowledge/vault/` — uma base de conhecimento em Markdown, compatível com Obsidian (pastas por domínio,
links `[[internos]]`, glossário e índice), além de um grafo de relacionamentos (`knowledge/graph/`), chunks
prontos para busca semântica (`knowledge/embeddings/`) e um resumo por área (`knowledge/cache/`) para os
demais agentes consultarem em vez de reler tudo. Se `docs/raw/` estiver vazia, essa fase é pulada e o pipeline
segue normalmente a partir de `docs/SPEC.md`, como sempre funcionou.

`knowledge/graph/` e `knowledge/embeddings/` são reconstruídos deterministicamente por
`.claude/scripts/knowledge-engine-build.cjs` (sem dependências) a partir dos wikilinks do vault — não são
escritos à mão pelo agente. Vetores de embedding "de verdade" não são calculados aqui (exigiria uma API/modelo
de embeddings); os chunks já ficam prontos para quem quiser plugar esse passo depois.

## Relatório de tokens

Todo projeto gerado já sai com um hook `Stop` (`.claude/settings.json` + `.claude/hooks/generate-token-report.cjs`) que, ao final de cada rodada do `/orchestrator`, atualiza `output/token-report.md` com o total de tokens gastos e o detalhamento por agente — lido direto dos transcripts da sessão, sem estimativa do modelo.

## Plugin ponytail (redução de tokens)

Todo projeto gerado também já sai com o plugin [ponytail](https://github.com/DietrichGebert/ponytail) habilitado — o `.claude/settings.json` do projeto já vem com `extraKnownMarketplaces` e `enabledPlugins` apontando pra ele, então não é preciso instalar nada manualmente: ao abrir o projeto criado no Claude Code, o ponytail já carrega junto e passa a atuar reduzindo o consumo de tokens da sessão. Para conferir se está ativo dentro do projeto gerado, rode `/plugin` e veja `ponytail@ponytail` habilitado. (Este repositório-template, por ser só o gerador de estrutura, não precisa do ponytail — a habilitação é escrita apenas no projeto gerado.)

## Estrutura de projeto oficial do Claude Code

Todo projeto gerado já sai alinhado à estrutura de projeto recomendada pela documentação oficial do Claude Code, não só com os arquivos específicos do pipeline SDD:

- **`.claude/commands/`** e **`.claude/agents/`** — comandos (`/orchestrator`) e subagentes do pipeline, nos caminhos que o Claude Code descobre automaticamente numa sessão normal.
- **`CLAUDE.md`** — memória do projeto, lida em toda sessão (comandos de build/test da stack, onde as coisas vivem, como rodar o pipeline).
- **`.mcp.json`** — servidores MCP do projeto: `context7` (documentação atualizada de bibliotecas, pronto pra uso) e um exemplo de `github` (só falta preencher o token).
- **`.claude/rules/`** — convenções por caminho de arquivo (Clean Architecture no `.NET`, separação componente/estado no frontend, convenções do Knowledge Vault), que só entram no contexto quando o Claude mexe num arquivo que bate o padrão.
- **`.claude/settings.json`** — já sai com um bloco `permissions` liberando leitura e as ações que o próprio pipeline precisa (escrita em `output/`, `docs/`, `knowledge/`, build/test da stack), além do hook de tokens e do plugin ponytail.
- **Worktrees** — para tocar duas frentes em paralelo sem os agentes esbarrarem nos mesmos arquivos, use `claude --worktree nome-da-frente` dentro do projeto gerado.

## Estrutura do plugin

```
criar-template-claude/
├── .claude-plugin/
│   ├── plugin.json
│   └── marketplace.json
├── commands/criar-template-claude.md     # comando do plugin instalado
└── criar-template-claude-sdd-plugin.sh   # script de scaffolding
```

Cada projeto **gerado** recebe sua própria estrutura `.claude/commands/` + `.claude/agents/` + `.claude/rules/` — ver seções acima.

## Contribuindo

Sugestões, issues e PRs são bem-vindos no repositório do projeto.

## Licença

MIT — Christian Anjos
