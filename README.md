# Criar Template Claude — Pipeline SDD

Plugin para Claude Code que monta a estrutura de projeto de **uma stack só** (.NET, Angular, React ou Vue — nunca backend e frontend misturados no mesmo projeto), seguindo as convenções oficiais de projeto do Claude Code, com um pipeline de agentes que especifica, implementa, testa e revisa código automaticamente — tudo dentro do Claude Code, sem serviços externos.

## Como funciona

1. `/comecar` gera a estrutura do projeto (`.claude/commands/`, `.claude/agents/`, `CLAUDE.md`, `.mcp.json`, `docs/raw/`, `docs/SPEC.md`, `knowledge/`, `output/`, `src/`)
2. (Opcional) Você joga documentação bruta — Word, PDF, planilhas, imagens, atas de reunião — em `docs/raw/`
3. Você descreve a aplicação em `docs/SPEC.md`
4. Dentro do projeto, `/orchestrator` dispara o pipeline: se `docs/raw/` tiver arquivos, primeiro consolida tudo numa Base de Conhecimento em `knowledge/` (compatível com Obsidian); depois valida a spec, define arquitetura, implementa a stack escolhida, gera testes, revisa qualidade, valida build, roda um scan de segurança estática (Semgrep), gera commits e (só no `.NET`) testa a API — parando automaticamente se algum gate de qualidade reprovar
5. Resultado em `output/`, incluindo `token-report.md` com o custo em tokens de cada rodada; `knowledge/` persiste entre rodadas como base de conhecimento viva do projeto

## Instalação

```
/plugin marketplace add christiananjos/criar-template-claude
/plugin install sdd@christian-criar-template-claude
```

Os comandos ficam disponíveis como `/sdd:comecar` e `/sdd:atualizar-versao` — o prefixo `sdd:` vem do nome
do plugin (`christiananjos/criar-template-claude` é só o repositório/marketplace; o plugin em si se chama
`sdd`).

## Comandos do plugin

| Comando | O que faz |
|---|---|
| `/sdd:comecar` | Gera a estrutura SDD num projeto novo, ou acopla o pipeline a um projeto já existente sem sobrescrever código — ver seções "Uso" e "Acoplar num projeto já existente". |
| `/sdd:atualizar-versao` | Sincroniza o marketplace e atualiza este plugin instalado para a versão mais recente numa tacada só — ver seção "Mantendo o plugin atualizado". |

## Mantendo o plugin atualizado

Marketplaces de terceiros (como este) vêm com auto-update **desligado por padrão** no Claude Code — só os
marketplaces oficiais da Anthropic atualizam sozinhos. Isso não é algo que o `marketplace.json` deste repo
controle; é uma escolha de quem instala.

**Mais simples: use o comando que o próprio plugin traz:**
```
/sdd:atualizar-versao
```
Sincroniza o marketplace e atualiza o plugin para a versão mais recente numa tacada só (equivale aos passos
manuais abaixo). Pede restart da sessão do Claude Code pra aplicar, se atualizar alguma coisa.

**Manual, passo a passo:**
```
/plugin marketplace update
/plugin install sdd@christian-criar-template-claude
```
O `/plugin install` já faz o refresh do marketplace automaticamente (a menos que ele tenha sido atualizado
há menos de 30s), então normalmente o primeiro comando nem é necessário.

**Automático, uma vez só:**
1. Rode `/plugin`
2. Vá na aba **Marketplaces**
3. Selecione `christiananjos/criar-template-claude`
4. Ative **Enable auto-update**

Isso equivale a setar no seu `settings.json`:
```json
{
  "extraKnownMarketplaces": {
    "christiananjos/criar-template-claude": {
      "source": { "source": "github", "repo": "christiananjos/criar-template-claude" },
      "autoUpdate": true
    }
  }
}
```

**Para checar a versão instalada**, rode `claude plugin list --json` e veja o campo `version` da entrada
`sdd@christian-criar-template-claude`; compare com o `version` em
[`.claude-plugin/marketplace.json`](.claude-plugin/marketplace.json) deste repo — não há um aviso automático
de "nova versão disponível" na interface hoje.

**Para desinstalar e reinstalar do zero:**
```
/plugin uninstall sdd@christian-criar-template-claude
/plugin marketplace remove christiananjos/criar-template-claude
/plugin marketplace add christiananjos/criar-template-claude
/plugin install sdd@christian-criar-template-claude
```

## Uso

```
/sdd:comecar meu-projeto
cd meu-projeto
nano docs/SPEC.md
/orchestrator
```

Na criação, o plugin pergunta três coisas, uma de cada vez: caminho, nome do projeto e a stack, como uma única
escolha (`.NET`, `Angular`, `React` ou `Vue`) — cada projeto sai com **uma stack só**, sem backend e frontend
misturados. Isso muda o que é gerado — o `orchestrator.md`, `.claude/commands/README.md`, `CLAUDE.md`, `docs/SPEC.md`, os agentes e
a pasta `src/` já saem ajustados para a stack escolhida. Se um frontend precisar consumir uma API, ela é
externa (outro projeto/time) — o template não gera backend e frontend juntos.

O `/orchestrator` leva ~15-30 minutos e tem **uma única pausa manual**: assim que `01-orchestrator-sdd` valida a especificação, o pipeline mostra o relatório completo (status, requisitos, regras de negócio, lacunas) e pergunta se você aprova seguir — mesmo se o status já for ✅ APROVADO. Aprovando, o resto roda 100% automático até o fim, sem pedir mais nenhuma confirmação; só interrompe de novo se `04-compliance-validator`, `06-code-review-sdd`, `07-build-test-validator` ou `08-security-scan-sdd` reportar falha. Se você não aprovar na pausa inicial, o pipeline para ali, sem gerar arquitetura nem código.

## Acoplar num projeto já existente

Além de criar um projeto do zero, o `/comecar` também acopla o pipeline a um projeto que **já
tem código** (uma casca inicial, um projeto em andamento etc.). A primeira pergunta do comando é justamente
essa: "novo" ou "existente". Escolhendo "existente" e informando o caminho do projeto já existente:

- **Nada do código é tocado** — `src/` não recebe a estrutura de pastas do template, só o que o script sempre cria (`.claude/commands/`, `.claude/agents/`, `.claude/rules/`, `knowledge/`).
- **Nenhum arquivo do usuário é sobrescrito** — `README.md`, `COMECE-AQUI.md`, `CLAUDE.md`, `.mcp.json` e `docs/SPEC.md` só são criados se ainda não existirem.
- **`.gitignore`** existente é mantido; só as regras específicas do pipeline (`output/`, `knowledge/embeddings/chunks/`, `.claude/`) são acrescentadas, sem duplicar em reexecuções.
- **`.claude/settings.json`** existente sofre *merge* (hook de token-report + `permissions` + ponytail somados ao que já estava configurado), nunca substituição.
- **`02-architect-sdd` e os `03-*-specialist`** são instruídos a ler a estrutura/convenções já existentes em `src/` antes de propor arquitetura ou gerar código — estendendo o que já existe em vez de reimplementar do zero.

Daí em diante o fluxo é o mesmo: editar `docs/SPEC.md` (aqui, descrevendo o que falta implementar) e rodar `/orchestrator`.

## Agentes

Todo projeto sai com 9 agentes sempre presentes (`00-knowledge-bootstrap` como Fase 0 dedicada + os 8 do
pipeline principal) e o specialist da stack escolhida — mais `10-swagger-tester`, só no `.NET`. No total: 11
agentes num projeto `.NET`, 10 num projeto de frontend.
Os arquivos em `.claude/agents/` saem numerados por ordem de execução do pipeline (`00-knowledge-bootstrap.md`,
`01-orchestrator-sdd.md`, `02-architect-sdd.md`, `03-<stack>-specialist.md`, ... até `09-commit-message-generator.md`
no frontend ou `10-swagger-tester.md` no `.NET`), e o `name:` no frontmatter de cada agente (usado para
invocação) leva o mesmo prefixo — o nome do arquivo e o nome usado pra chamar o agente são sempre idênticos.
Ao reacoplar o pipeline (`MODO = existente`) a um projeto gerado por uma versão anterior do template, o script
remove os nomes antigos sem prefixo antes de recriar os numerados, evitando arquivo duplicado.

| Agente | Responsabilidade | Quando existe |
|---|---|---|
| `00-knowledge-bootstrap` | Fase 0 — consolida `docs/raw/` numa Base de Conhecimento em `knowledge/` (só roda se `docs/raw/` tiver arquivos) | sempre |
| `01-orchestrator-sdd` | Valida a especificação | sempre |
| `02-architect-sdd` | Gera arquitetura técnica e rastreabilidade | sempre |
| `03-dotnet-specialist` | Implementa o backend .NET 10 | só stack `dotnet` |
| `03-react-specialist` / `03-angular-specialist` / `03-vue-specialist` | Implementa o frontend | só a stack correspondente |
| `04-compliance-validator` | Audita conformidade com a spec | sempre |
| `05-test-validator` | Gera testes automatizados | sempre |
| `06-code-review-sdd` | Revisa qualidade e SOLID | sempre |
| `07-build-test-validator` | Valida build e testes | sempre |
| `08-security-scan-sdd` | Roda scan de segurança estática (Semgrep) e corrige achados Critical/High que não alterem comportamento observável | sempre |
| `09-commit-message-generator` | Gera commits semânticos | sempre |
| `10-swagger-tester` | Gera workflow de testes de API | só stack `dotnet` (não há API num projeto 100% frontend) |

`09-commit-message-generator` e `10-swagger-tester` usam Haiku por serem etapas de baixo risco; os demais usam Sonnet.

## Comandos avulsos (fora do `/orchestrator`)

Além do pipeline em si, todo projeto gerado sai com comandos soltos em `.claude/commands/`, para chamar a
qualquer momento, fora de uma rodada do `/orchestrator`:

| Comando | Stacks | O que faz |
|---|---|---|
| `/commit` | todas | Gera a mensagem de commit a partir do diff atual e faz push na branch atual, seguindo o estilo de commits já usado no repositório. |
| `/raio-x-projeto` | só `.NET` | Varredura técnica completa de um projeto legado sem documentação — arquitetura, banco de dados, interfaces, services e infraestrutura — gravada em `docs/raw/` (um arquivo por tema), pronta pra alimentar o `00-knowledge-bootstrap` na próxima rodada do `/orchestrator`. Útil ao acoplar o pipeline (modo "existente") a um código que já existe. |

`/raio-x-projeto` só é gerado em projetos `.NET` porque seu roteiro de investigação é específico da stack
(`.csproj`, `DbContext`/EF Core, MediatR, Clean Architecture em C#) — não aparece em projetos Angular, React
ou Vue.

## Skills — especialistas extras (só stack `.NET`)

Todo projeto `.NET` sai também com 6 skills em `.claude/skills/`, complementares aos agentes do pipeline —
não são chamadas automaticamente pelo `/orchestrator`, mas ficam disponíveis pro Claude consultar (e você
invocar manualmente) durante ou depois de uma rodada, para dúvidas que vão além do que os agentes fixos cobrem:

| Skill | Cobre |
|---|---|
| `dba-expert` | SQL Server, Azure SQL e PostgreSQL — modelagem de schema, indexação, otimização de query, migrations do EF Core, backup/replicação |
| `cicd-pipeline-expert` | Pipelines Azure DevOps e GitHub Actions — YAML, estratégias de deploy (blue-green/canary/rolling), políticas de branch |
| `tech-leader` | Decisões de arquitetura (ADRs), code review em nível lead, mentoria técnica, priorização de dívida técnica |
| `dotnet-security-expert` | Segurança de aplicações .NET — auth (JWT/Identity), OWASP Top 10, gestão de secrets, SAST com Semgrep |
| `qa-expert` | Estratégia e plano de testes, design de casos de teste, testes automatizados de backend .NET (xUnit, Testcontainers), testes de API, testes exploratórios, gestão de bugs |
| `aws-expert` | Arquitetura e operação AWS — EC2/ECS/Lambda, S3, RDS/DynamoDB, VPC/IAM, deploy de apps .NET (SDK, Lambda, CDK), otimização de custo |

Stacks de frontend (`Angular`/`React`/`Vue`) não recebem essas skills — o conteúdo é específico de backend
.NET (EF Core, ASP.NET Core, pipelines de API). Essas mesmas 6 skills também existem globalmente em
`~/.claude/skills/` nesta máquina, disponíveis em qualquer sessão do Claude Code, não só dentro de projetos
gerados pelo template.

Todas as 6 seguem a mesma regra de contexto: antes de vasculhar o projeto inteiro, cada skill consulta primeiro
`knowledge/` (a Base de Conhecimento gerada pela Fase 0, quando existir) — `knowledge/index.json` e a pasta
do `vault/` relevante ao assunto — e só cai pra busca ampla no código/projeto se a referência ali não for
suficiente. Isso evita reler o projeto inteiro a cada consulta e usa os tokens de forma mais eficiente.

## Base de Conhecimento (Knowledge Engine)

Se você tiver documentação já pronta do projeto (Word, PDF, planilhas, imagens, atas de reunião), coloque tudo
em `docs/raw/` antes de chamar `/orchestrator`. A Fase 0 (`00-knowledge-bootstrap`) lê e consolida todo esse material
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

- **`.claude/commands/`** e **`.claude/agents/`** — comandos (`/orchestrator`, `/commit` e, só no `.NET`, `/raio-x-projeto` — ver seção "Comandos avulsos" acima) e subagentes do pipeline, nos caminhos que o Claude Code descobre automaticamente numa sessão normal.
- **`.claude/skills/`** — só em projetos `.NET`: 6 skills de especialistas extras (`dba-expert`, `cicd-pipeline-expert`, `tech-leader`, `dotnet-security-expert`, `qa-expert`, `aws-expert`), ver seção "Skills" acima.
- **`CLAUDE.md`** — memória do projeto, lida em toda sessão (comandos de build/test da stack, onde as coisas vivem, como rodar o pipeline).
- **`.mcp.json`** — servidores MCP do projeto: `context7` (documentação atualizada de bibliotecas, pronto pra uso) e um exemplo de `github` (só falta preencher o token).
- **`.claude/rules/`** — convenções por caminho de arquivo (Clean Architecture no `.NET`, separação componente/estado no frontend, convenções do Knowledge Vault), que só entram no contexto quando o Claude mexe num arquivo que bate o padrão.
- **`.claude/settings.json`** — já sai com um bloco `permissions` liberando leitura e as ações que o próprio pipeline precisa (escrita em `output/`, `docs/`, `knowledge/`, `src/`, build/test da stack, scan do Semgrep), além do hook de tokens e do plugin ponytail.
- **Worktrees** — para tocar duas frentes em paralelo sem os agentes esbarrarem nos mesmos arquivos, use `claude --worktree nome-da-frente` dentro do projeto gerado.

## Estrutura do plugin

```
criar-template-claude/
├── .claude-plugin/
│   ├── plugin.json
│   └── marketplace.json
├── commands/
│   ├── comecar.md                        # /comecar — gera/acopla a estrutura SDD no projeto
│   └── atualizar-versao.md                # /atualizar-versao — atualiza este plugin instalado para a versão mais recente
├── .claude/commands/                     # só neste repo (dev) — não vai para quem instala o plugin
│   ├── bump-versao.md
│   └── commit.md
└── criar-template-claude-sdd-plugin.sh   # script de scaffolding
```

Cada projeto **gerado** recebe sua própria estrutura `.claude/commands/` + `.claude/agents/` + `.claude/rules/` — ver seções acima. Repare que o `.claude/commands/commit.md` deste repo (uso interno, pra manter o próprio template) é um arquivo diferente do `/commit` que o script grava dentro de cada projeto **gerado** — mesmo nome, conteúdo ajustado a cada contexto.

## Contribuindo

Sugestões, issues e PRs são bem-vindos no repositório do projeto.

## Licença

MIT — Christian Anjos
