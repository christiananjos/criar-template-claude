# Criar Template Claude — Pipeline SDD

Plugin para Claude Code que monta a estrutura de projeto de **uma stack só** (.NET, Angular, React ou Vue — nunca backend e frontend misturados no mesmo projeto), seguindo as convenções oficiais de projeto do Claude Code, com um pipeline de agentes que especifica, implementa, testa e revisa código automaticamente — tudo dentro do Claude Code, sem serviços externos.

## Como funciona

1. `/comecar` gera a estrutura do projeto (`.claude/` com `commands/`, `agents/`, `skills/`, `rules/`, `hooks/` e `scripts/`, mais `CLAUDE.md`, `.mcp.json`, `README.md`, `docs/raw/`, `docs/SPEC.md`, `knowledge/`, `output/`, `src/`)
2. (Opcional) Você joga documentação bruta — Word, PDF, planilhas, imagens, atas de reunião — em `docs/raw/`
3. Você descreve a aplicação em `docs/SPEC.md`
4. Dentro do projeto, `/orchestrator` dispara o pipeline: se `docs/raw/` tiver arquivos, primeiro consolida tudo numa Base de Conhecimento em `knowledge/` (compatível com Obsidian); depois valida a spec, define arquitetura, implementa a stack escolhida, gera testes, revisa qualidade, valida build, audita segurança (cinco categorias de falha, com relatório em PDF), gera commits e monta o roteiro de testes de ponta a ponta (workflow de API no `.NET`, fluxos E2E no frontend) — parando automaticamente se algum gate de qualidade reprovar
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
| `/sdd:atualizar-versao` | Sincroniza o marketplace, atualiza este plugin instalado e **reaplica o template no projeto da pasta atual**, preservando `docs/raw/` e `knowledge/` — ver seção "Mantendo o plugin atualizado". |

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

Além disso, se você rodar esse comando **de dentro de um projeto gerado pelo template**, ele reaplica a
estrutura da versão nova nesse projeto — atualizar o plugin sozinho não atualiza projetos já criados, porque
`.claude/commands/` e `.claude/agents/` são cópias gravadas no projeto na hora em que ele foi gerado. O que
é reescrito: `.claude/commands/`, `.claude/agents/`, `.claude/rules/`, `.claude/skills/`, hooks e scripts.
O que **nunca** é tocado: `docs/raw/` e `knowledge/` (a documentação bruta e o vault já injetados),
além de `src/`, `docs/SPEC.md`, `CLAUDE.md`, `README.md` e `.mcp.json`; o
`.claude/settings.json` sofre merge em vez de sobrescrita. Antes de reescrever, o comando salva um backup
da `.claude/` anterior em `output/.claude-backup-<timestamp>/`.

O único arquivo que a atualização **remove** é o `COMECE-AQUI.md` de projetos gerados antes da v3.17.0 —
ele foi absorvido pelo `README.md` e sobraria como guia duplicado e desatualizado. O antigo vai para
`output/COMECE-AQUI.removido-<timestamp>.md` (fora do Git) antes de sair da raiz.

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

O plugin pergunta uma coisa de cada vez: projeto novo ou existente, caminho, nome do projeto (só no modo novo — no
existente usa o nome da pasta) e a stack, como uma única escolha (`.NET`, `Angular`, `React` ou `Vue`) — cada
projeto sai com **uma stack só**, sem backend e frontend misturados. Isso muda o que é gerado — o `orchestrator.md`, `.claude/commands/README.md`, `CLAUDE.md`, `docs/SPEC.md`, os agentes e
a pasta `src/` já saem ajustados para a stack escolhida. Se um frontend precisar consumir uma API, ela é
externa (outro projeto/time) — o template não gera backend e frontend juntos.

O `/orchestrator` leva ~15-30 minutos e tem **uma única pausa manual**: assim que `01-orchestrator-sdd` valida a especificação, o pipeline mostra o relatório completo (status, requisitos, regras de negócio, lacunas) e pergunta se você aprova seguir — mesmo se o status já for ✅ APROVADO. Aprovando, o resto roda 100% automático até o fim, sem pedir mais nenhuma confirmação; só interrompe de novo se `04-compliance-validator`, `06-code-review-sdd`, `07-build-test-validator` ou `08-security-scan-sdd` reportar falha. Se você não aprovar na pausa inicial, o pipeline para ali, sem gerar arquitetura nem código.

## Acoplar num projeto já existente

Além de criar um projeto do zero, o `/comecar` também acopla o pipeline a um projeto que **já
tem código** (uma casca inicial, um projeto em andamento etc.). A primeira pergunta do comando é justamente
essa: "novo" ou "existente". Escolhendo "existente" e informando o caminho do projeto já existente:

- **Nada do código é tocado** — `src/` não recebe a estrutura de pastas do template, só o que o script sempre cria (`.claude/commands/`, `.claude/agents/`, `.claude/rules/`, `knowledge/`).
- **Nenhum arquivo do usuário é sobrescrito** — `README.md`, `CLAUDE.md`, `.mcp.json` e `docs/SPEC.md` só são criados se ainda não existirem.
- **`.gitignore`** existente é mantido; só as regras específicas do pipeline (`output/`, `.claude/` ignorados; `!knowledge/` versionada, menos `knowledge/embeddings/chunks/`) são acrescentadas, sem duplicar em reexecuções.
- **`.claude/settings.json`** existente sofre *merge* (hook de token-report + `permissions` + ponytail somados ao que já estava configurado), nunca substituição.
- **`02-architect-sdd` e os `03-*-specialist`** são instruídos a ler a estrutura/convenções já existentes em `src/` antes de propor arquitetura ou gerar código — estendendo o que já existe em vez de reimplementar do zero.

Daí em diante o fluxo é o mesmo: editar `docs/SPEC.md` (aqui, descrevendo o que falta implementar) e rodar `/orchestrator`.

## Agentes

**Toda stack recebe os mesmos 11 agentes**, na mesma ordem: 9 sempre presentes (`00-knowledge-bootstrap` como
Fase 0 dedicada + os 8 do pipeline principal), o specialist da stack escolhida e o agente 10 de testes — que é
`10-swagger-tester` no `.NET` (testa a API) e `10-e2e-flow-tester` no frontend (testa os fluxos pela interface).
O que muda entre as stacks é o conteúdo de cada agente, nunca a existência dele.
Os arquivos em `.claude/agents/` saem numerados por ordem de execução do pipeline (`00-knowledge-bootstrap.md`,
`01-orchestrator-sdd.md`, `02-architect-sdd.md`, `03-<stack>-specialist.md`, ... até `10-e2e-flow-tester.md`
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
| `08-security-scan-sdd` | Audita cinco falhas de segurança (isolamento de inquilino, permissão só no navegador, IDOR, chaves expostas, XSS) **lendo o código, sem depender de scanner externo instalado**, corrige achados Critical/High que não alterem comportamento observável e gera relatório em PDF em `docs/security-audit/` com issues prontas para o GitHub | sempre |
| `09-commit-message-generator` | Gera commits semânticos | sempre |
| `10-swagger-tester` | Gera workflow de testes de API (cURL/Swagger) | só stack `dotnet` |
| `10-e2e-flow-tester` | Gera o roteiro de testes E2E dos fluxos (Playwright/Cypress), incluindo invalidação de sessão | só stacks de frontend |

`09-commit-message-generator` e o agente 10 (`10-swagger-tester` / `10-e2e-flow-tester`) usam Sonnet por serem etapas mais simples; os demais (00 a 08) usam Opus 5 (`claude-opus-5`, fixado na versão).

## Comandos avulsos (fora do `/orchestrator`)

Além do pipeline em si, todo projeto gerado sai com comandos soltos em `.claude/commands/`, para chamar a
qualquer momento, fora de uma rodada do `/orchestrator`:

| Comando | Stacks | O que faz |
|---|---|---|
| `/commit` | todas | Sincroniza `knowledge/` com o que mudou no código (incluindo o que ficou planejado em `14 - Planejamento/`), roda o rebuild do grafo, confere que o `.gitignore` não está engolindo a memória, **varre o que está no stage em busca de segredos expostos** (ver abaixo) e só então gera a mensagem a partir do diff e faz push na branch atual — memória e código no mesmo commit. Segue o estilo de commits já usado no repositório e nunca cita Claude, Anthropic ou qualquer outra IA na mensagem (sem `Co-Authored-By`, sem trailers e sem "gerado/testado por IA"). |
| `/raio-x-projeto` | todas | Varredura técnica completa de um projeto legado sem documentação, gravada em `docs/raw/` (um arquivo por tema), pronta pra alimentar o `00-knowledge-bootstrap` na próxima rodada do `/orchestrator`. Útil ao acoplar o pipeline (modo "existente") a um código que já existe. No `.NET` investiga arquitetura, banco, interfaces, services e infraestrutura; no frontend, stack e build, arquitetura e roteamento, estado, camada de API, componentes/UX e infraestrutura. |

O `/raio-x-projeto` é gerado em toda stack, com o roteiro de investigação adaptado — a versão `.NET` procura
`.csproj`, `DbContext`/EF Core e violação de camada; a de frontend procura `package.json`, mapa de rotas,
store, cliente HTTP e configuração de build. O contrato de saída é o mesmo nos dois casos: um arquivo por tema
em `docs/raw/`, que o `00-knowledge-bootstrap` consome na rodada seguinte.

## Agente (specialist) x Skill (expert) — a diferença

Os dois aparecem no projeto gerado com nomes parecidos (`03-react-specialist` e `react-expert`), mas são
mecanismos diferentes do Claude Code:

| | **Agente** — `.claude/agents/03-<stack>-specialist.md` | **Skill** — `.claude/skills/<stack>-expert/SKILL.md` |
|---|---|---|
| O que é | Um subagente: executa | Conhecimento: informa |
| Quem dispara | O `/orchestrator`, na ordem do pipeline | O próprio Claude, quando o assunto aparece na conversa |
| Contexto | Roda numa janela própria e devolve só o relatório | Entra no contexto da conversa atual |
| O que faz | Escreve código em `src/`, grava relatório em `output/`, atualiza o vault | Não executa nada — orienta quem está escrevendo |
| Quando age | Só durante uma rodada do pipeline | Em qualquer sessão, dentro ou fora do pipeline |

Na prática: o **specialist** é quem implementa a spec quando você roda `/orchestrator`. O **expert** é quem
responde quando você pergunta "esse `useEffect` está certo?" numa terça-feira qualquer, sem pipeline nenhum
rodando — e é carregado também pelo próprio specialist na hora de implementar, então a mesma régua vale nos
dois caminhos.

O sufixo segue essa divisão: **`-specialist` = agente (faz)**, **`-expert` = skill (sabe)**. Em português os
dois viram "especialista", que é justamente o que confunde — por isso os arquivos mantêm o termo em inglês.

## Skills — especialistas extras

Todo projeto sai também com skills em `.claude/skills/`, complementares aos agentes do pipeline — não são
chamadas automaticamente pelo `/orchestrator`, mas ficam disponíveis pro Claude consultar (e você invocar
manualmente) durante ou depois de uma rodada, para dúvidas que vão além do que os agentes fixos cobrem.

**Uma skill é da stack do projeto** — a contraparte consultável do agente `03-<stack>-specialist`, criada só
para a stack escolhida:

| Skill | Cobre |
|---|---|
| `dotnet-expert` | C# e ASP.NET Core idiomáticos — fronteiras da Clean Architecture, DI e tempo de vida (captive dependency), async/await e `CancellationToken`, EF Core no nível de aplicação (tracking, projeção, N+1, `IQueryable` vs `IEnumerable`), erro e validação, C# moderno |
| `react-expert` | React moderno — de onde vem o estado (servidor/URL/local/global), quando **não** usar `useEffect`, render e re-render em cascata, `key` e listas, formulários, hooks customizados |
| `angular-expert` | Angular moderno — standalone e signals, `OnPush` e change detection, RxJS sem vazar (`takeUntilDestroyed`, operadores de achatamento), Reactive Forms tipados, lazy loading e interceptors |
| `vue-expert` | Vue 3 — onde a reatividade se perde (`ref` vs `reactive`, destructuring), `computed` vs `watch`, props/eventos e `defineModel`, composables, Pinia, keys e render |

**Oito skills vão para todas as stacks**, com os trechos específicos (comandos de build, YAML de pipeline,
framework de teste, escopo de commit, deploy) adaptados à stack na hora da geração. Adaptados **por framework**,
não por família: React, Angular e Vue recebem blocos próprios, não um bloco "frontend" genérico — o projeto
Angular fala de `TestBed`, `HttpTestingController` e `--browsers=ChromeHeadless`, o de Vue fala de Vue Test
Utils, `nextTick` e `createTestingPinia`, e nenhum dos dois menciona as ferramentas do outro:

| Skill | Cobre |
|---|---|
| `cicd-pipeline-expert` | Pipelines Azure DevOps e GitHub Actions — YAML, estratégias de deploy (blue-green/canary/rolling), políticas de branch. O pipeline de exemplo sai em `dotnet` ou em `npm ci`/`npm run build`, conforme a stack |
| `tech-leader-expert` | Decisões de arquitetura (ADRs), code review em nível lead, mentoria técnica, priorização de dívida técnica |
| `qa-expert` | Estratégia e plano de testes, design de casos de teste, testes exploratórios, gestão de bugs — com a seção de automação escrita para a stack: xUnit/Testcontainers no .NET, Testing Library + MSW no React, TestBed + `HttpTestingController` no Angular, Vue Test Utils + `createTestingPinia` no Vue |
| `aws-expert` | Arquitetura e operação AWS — EC2/ECS/Lambda, S3, RDS/DynamoDB, VPC/IAM, otimização de custo — com a seção de deploy da aplicação .NET ou do SPA (S3+CloudFront, Amplify) |
| `architect-expert` | Arquitetura de software e sistemas agnóstica de tecnologia — backend, frontend, dados, mensageria, infraestrutura, cloud, CI/CD, observabilidade, segurança, auditoria, resiliência, custos e governança; ADRs, DDD, microsserviços vs modular monolith, evitar overengineering |
| `github-expert` | GitHub em qualquer stack — Actions (CI/CD), Pull Requests e code review, branch protection e CODEOWNERS, Packages, Dependabot/CodeQL/secret scanning, `gh` CLI, estratégia de branches e release |
| `azure-expert` | Microsoft Azure em qualquer stack — App Service, Functions, Static Web Apps, AKS/Container Apps, Cosmos DB/Azure SQL, Key Vault, Managed Identity, Bicep/Terraform, Azure DevOps, segurança e custo |
| `hostinger-expert` | Hospedagem Hostinger — hPanel, domínios e DNS, compartilhada vs VPS/Cloud, deploy via Git/FTP/SSH, MySQL, email profissional, SSL e troubleshooting |

**Duas são específicas de `.NET`**, porque não teriam o que fazer num projeto sem backend:

| Skill | Cobre |
|---|---|
| `dba-expert` | SQL Server, Azure SQL e PostgreSQL — modelagem de schema, indexação, otimização de query, migrations do EF Core, backup/replicação |
| `dotnet-security-expert` | Segurança de aplicações .NET — auth (JWT/Identity), OWASP Top 10, gestão de secrets, scanning de dependências pelo próprio SDK (`dotnet list package --vulnerable / --deprecated / --outdated`) |

**Uma é específica de frontend** (`React`/`Angular`/`Vue`), como equivalente da de segurança do `.NET`:

| Skill | Cobre |
|---|---|
| `frontend-security-expert` | Segurança no browser — XSS e sanitização, CSP e headers, onde guardar token de sessão, OAuth2/PKCE, segredos que vazam no bundle, dependências npm |

Ou seja: 11 skills num projeto `.NET` e 10 num projeto de frontend, com o mesmo núcleo em ambos.

Cada skill traz, quando faz sentido, um checklist em `references/` (revisão de código, plano de teste, arquitetura AWS, OWASP, segurança de frontend) carregado só quando o assunto pede.

Todas seguem a mesma regra de contexto: antes de vasculhar o projeto inteiro, cada skill consulta primeiro
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

### A memória vai versionada no Git

`knowledge/` é a memória do projeto e **entra no controle de versão junto com o código** — só
`knowledge/embeddings/chunks/` fica de fora, por ser derivado e regenerável. O `.gitignore` gerado diz isso
explicitamente, e no modo "existente" acrescenta uma negação (`!knowledge/`) caso o repositório já ignorasse a
pasta por alguma regra anterior.

O `/commit` do projeto gerado faz isso valer na prática: antes de montar a mensagem ele (1) confere no diff o
que mudou e atualiza as notas correspondentes do vault, (2) roda o rebuild do grafo, (3) checa com
`git check-ignore` que nada está engolindo `knowledge/` e corrige o `.gitignore` se estiver, e só então
commita — memória e código no **mesmo** commit, nunca em commits separados.

O caso que motivou isso é `knowledge/vault/14 - Planejamento/`: escopo adiado, próximo passo e pendência em
aberto moram ali. Os relatórios do pipeline ficam em `output/`, que é por rodada e **fora** do Git — plano
que morasse só lá morreria junto com a sessão. Os agentes `01-orchestrator-sdd`, `02-architect-sdd` e
`04-compliance-validator` são donos dessa pasta e a atualizam antes de encerrar; quando um item é
implementado, a nota sai (ou é marcada como concluída) no mesmo commit da implementação.

## Gate de segredos no commit

Antes de commitar, o `/commit` varre o que está no stage (`git diff --cached`) atrás de credencial
exposta: chaves de AWS/Google/OpenAI/Slack, tokens do GitHub, blocos de chave privada, JWT e atribuições do
tipo `password=`, `secret=`, `api_key=`, `connection string=` com valor real. Também olha os **nomes** dos
arquivos — `.env`, `*.pem`, `*.pfx`, `id_rsa`, `secrets.json` e afins quase nunca deveriam ser versionados.

O comando faz triagem antes de alarmar (placeholder como `your-api-key-here`, `*.example`, fixture de teste
e connection string de `localhost` não são segredo) e, se sobrar algo real, **para antes do commit** e
reporta arquivo, linha e o valor mascarado — nunca o segredo inteiro. A sugestão de correção depende do
caso: tirar o arquivo do stage e mandá-lo para o `.gitignore` com um `.example` no lugar, ou trocar o valor
por variável de ambiente / `dotnet user-secrets`. Se o segredo já estiver em commit anterior, o comando diz
com todas as letras que tirar do stage não resolve — a correção é **rotacionar a credencial**.

É uma rede rápida baseada em padrões, não uma auditoria: quem faz a auditoria completa (cinco categorias de
falha, com relatório em PDF) é o agente `08-security-scan-sdd` do `/orchestrator`. O `/commit` deste
repositório-template tem o mesmo gate, em versão condensada.

## Relatório de tokens

Todo projeto gerado já sai com um hook `Stop` (`.claude/settings.json` + `.claude/hooks/generate-token-report.cjs`) que, ao final de cada rodada do `/orchestrator`, atualiza `output/token-report.md` com o total de tokens gastos e o detalhamento por agente e por modelo — lido direto dos transcripts da sessão, sem estimativa do modelo.

O custo é calculado pelo modelo que realmente respondeu cada mensagem, então o relatório continua correto seja qual for o modelo de cada agente, inclusive se você trocar. A conta considera leitura e escrita de cache (com o multiplicador de cada modelo), fast mode, inferência restrita aos EUA e buscas na web (cobradas à parte, US$ 10 por 1.000). Modelo que ainda não estiver na tabela de preços entra pelo preço do modelo mais recente da mesma família, e o relatório avisa que aquele valor é aproximado — a tabela fica em `PRICING`, no topo de `.claude/hooks/generate-token-report.cjs`.

## Plugin ponytail (redução de tokens)

Todo projeto gerado também já sai com o plugin [ponytail](https://github.com/DietrichGebert/ponytail) pré-configurado — o `.claude/settings.json` do projeto já vem com `extraKnownMarketplaces` e `enabledPlugins` apontando pra ele. Isso registra o marketplace e a intenção de habilitá-lo, mas **não instala o plugin sozinho**: a partir do Claude Code v2.1.195, um plugin de fonte externa (como este, hospedado no GitHub) só carrega depois de instalado pelo menos uma vez. Na primeira vez que abrir o projeto gerado, rode `claude plugin install ponytail@ponytail` (ou aceite quando o Claude Code avisar que ele não está instalado) — dali em diante, `enabledPlugins` mantém ele habilitado automaticamente nas próximas sessões. Para conferir se está ativo, rode `/plugin` e veja `ponytail@ponytail` habilitado. (Este repositório-template, por ser só o gerador de estrutura, não precisa do ponytail — a configuração é escrita apenas no projeto gerado.)

## Estrutura de projeto oficial do Claude Code

Todo projeto gerado já sai alinhado à estrutura de projeto recomendada pela documentação oficial do Claude Code, não só com os arquivos específicos do pipeline SDD:

- **`.claude/commands/`** e **`.claude/agents/`** — comandos (`/orchestrator`, `/commit` e `/raio-x-projeto` — ver seção "Comandos avulsos" acima) e subagentes do pipeline, nos caminhos que o Claude Code descobre automaticamente numa sessão normal.
- **`.claude/skills/`** — skills de especialistas extras: a skill da própria stack (`dotnet-expert`, `react-expert`, `angular-expert` ou `vue-expert`), mais `cicd-pipeline-expert`, `tech-leader-expert`, `qa-expert`, `aws-expert`, `architect-expert`, `github-expert`, `azure-expert` e `hostinger-expert` em toda stack; mais `dba-expert` e `dotnet-security-expert` no `.NET`, ou `frontend-security-expert` no frontend. Ver seção "Skills" acima — e "Agente (specialist) x Skill (expert)" para a diferença entre as duas coisas.
- **`CLAUDE.md`** — memória do projeto, lida em toda sessão (comandos de build/test da stack, onde as coisas vivem, como rodar o pipeline).
- **`.mcp.json`** — servidores MCP do projeto: `context7` (documentação atualizada de bibliotecas, pronto pra uso) e um exemplo de `github` (só falta preencher o token).
- **`.claude/rules/`** — convenções por caminho de arquivo (Clean Architecture no `.NET`; separação componente/estado, segurança e direção de design no frontend; convenções do Knowledge Vault), que só entram no contexto quando o Claude mexe num arquivo que bate o padrão.
- **`.claude/hooks/`** e **`.claude/scripts/`** — o hook de relatório de tokens (`generate-token-report.cjs`) e o script que reconstrói o grafo e os chunks do Knowledge Engine (`knowledge-engine-build.cjs`).
- **`.claude/settings.json`** — já sai com um bloco `permissions` liberando leitura e as ações que o próprio pipeline precisa (escrita em `output/`, `docs/`, `knowledge/`, `src/`, build/test da stack, geração do relatório de auditoria em PDF num venv isolado), além do hook de tokens e do plugin ponytail.
- **Worktrees** — para tocar duas frentes em paralelo sem os agentes esbarrarem nos mesmos arquivos, use `claude --worktree nome-da-frente` dentro do projeto gerado.

## Estrutura do plugin

```
criar-template-claude/
├── .claude-plugin/
│   ├── plugin.json
│   └── marketplace.json
├── README.md
├── commands/
│   ├── comecar.md                        # /comecar — gera/acopla a estrutura SDD no projeto
│   └── atualizar-versao.md                # /atualizar-versao — atualiza o plugin e reaplica o template no projeto atual
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
