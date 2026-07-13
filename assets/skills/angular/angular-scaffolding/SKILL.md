---
name: angular-scaffolding
description: Use ao gerar novos componentes, serviços, diretivas ou módulos em projetos Angular, seguindo o padrão de arquitetura já estabelecido (standalone components, feature folders, smart/dumb components). Na primeira execução em um projeto sem arquitetura definida, também decide e registra essa arquitetura antes de gerar qualquer código.
---

# Scaffolding de código Angular

## 0. Garantir que a arquitetura do frontend está definida

Verifique se já existe `docs/arquitetura-frontend.md` no projeto.

- **Se existir**: leia-o, use a arquitetura ali registrada e vá direto para "Antes de gerar código novo".
- **Se não existir** (primeira vez que esta skill roda neste projeto):
  1. Investigue pistas em `docs/` (specs de produto, requisitos não-funcionais, tamanho esperado do app, tamanho da equipe) e no que já existe no projeto (`CLAUDE.md`, código já escrito) para embasar uma recomendação.
  2. Apresente ao usuário, via `AskUserQuestion`, as opções de arquitetura — Feature-based (Standalone Components), NgModules clássico, Nx Monorepo, ou Outra (texto livre) — destacando qual você recomenda e por quê, com base no que investigou.
  3. Registre a decisão e a justificativa em `docs/arquitetura-frontend.md` (crie o arquivo).
  4. Copie a sequência de bootstrap de `$HOME/.claude/templates/criar-template-claude/changes/angular/` para `<projeto>/changes/`, numerando os arquivos a partir do maior `NNN` já existente em `changes/` + 1 (evita colidir com fases/features já criadas — relevante em projetos full-stack onde `dotnet-scaffolding` já pode ter rodado). Substitua `<nome do projeto>` pelo título do `CLAUDE.md` do projeto em cada arquivo copiado. Se a arquitetura escolhida for "Outra", monte manualmente 4-6 arquivos `0NN-*.md` seguindo a mesma progressão (estrutura base → core/shared → feature de exemplo → state management → testes → CI/CD), adaptados à arquitetura descrita.
  5. Gere `changes/executar-todas.md` a partir de `$HOME/.claude/templates/criar-template-claude/executar-todas.md.template` com a lista real de fases — se o arquivo já existir (ex: `dotnet-scaffolding` rodou antes), acrescente as novas fases à lista existente em vez de sobrescrever.
  6. Avise o usuário que a sequência de bootstrap foi criada em `changes/` e pergunte se prefere rodá-la (`changes/executar-todas.md`) antes de continuar com o scaffolding pontual pedido, ou seguir direto para ele.

## Antes de gerar código novo

1. Peça ao usuário a especificação da funcionalidade (o que faz, inputs/outputs, estado envolvido, dependências externas). Não comece a gerar código sem isso.
2. Se o usuário não indicar qual design pattern usar, investigue qual é o mais adequado ao problema, sempre respeitando Clean Code e um design desacoplado. Use a tabela de referência abaixo.
3. Identifique o padrão de arquitetura do projeto (verifique `CLAUDE.md`, `docs/arquitetura-frontend.md` e componentes existentes: standalone components vs NgModules, estrutura de pastas por feature vs por tipo).
4. Prefira `standalone: true` em projetos novos (Angular 15+) — só use NgModules se o projeto já for baseado neles.
5. Separe componentes "smart" (containers, conectados a serviços/estado) de componentes "dumb" (apresentação pura, só `@Input`/`@Output`).
6. Use `ng generate` (`ng g c`, `ng g s`, `ng g d`) para manter convenção de nomes e estrutura de arquivos do CLI.
7. Serviços que fazem chamada HTTP nunca devem conter lógica de apresentação — devolvem dados/observables, o componente decide como exibir.

## Guia de seleção de design pattern (adaptado a Angular)

| Categoria | Padrão | Propósito | Exemplo de uso prático em Angular |
|---|---|---|---|
| Criacional | Factory | Delega criação de objetos/componentes | Factory de providers para diferentes ambientes (`APP_INITIALIZER`) |
| Criacional | Builder | Construção passo a passo | Construir `FormGroup` complexo com validações condicionais |
| Estrutural | Adapter | Traduz interface incompatível | Adaptar resposta de API legada para o modelo usado pelos componentes |
| Estrutural | Facade | Interface simples pra lógica complexa | Um `CheckoutFacade` que orquestra carrinho, pagamento e frete pros componentes |
| Estrutural | Decorator | Adiciona comportamento sem herança | `HttpInterceptor` adicionando header de auth/retry em todas as chamadas |
| Estrutural | Proxy | Controle de acesso/cache | Interceptor de cache de requisições HTTP repetidas |
| Comportamental | Strategy | Troca de algoritmo em runtime | Diferentes `ValidatorFn` de formulário conforme tipo de usuário |
| Comportamental | Observer | Notifica múltiplos interessados | RxJS `Subject`/`BehaviorSubject` compartilhado entre componentes |
| Comportamental | State | Comportamento varia por estado | Máquina de estados de um wizard multi-step (NgRx ou Signals) |
| Comportamental | Command | Transforma ação em objeto | Fila de ações offline sincronizadas quando volta conexão |

Ao escolher, priorize o padrão mais simples — RxJS puro resolve muita coisa antes de precisar de NgRx/state machine completa.
