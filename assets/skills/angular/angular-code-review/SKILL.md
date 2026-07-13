---
name: angular-code-review
description: Use ao revisar pull requests de projetos Angular, focando em convenções específicas do framework (subscription leak, OnPush, trackBy, mutação de estado).
---

# Revisão de PR Angular

Ao revisar um PR Angular, verifique especificamente:

1. `subscribe()` sem unsubscribe (memory leak) — prefira `async` pipe no template ou `takeUntilDestroyed()` no componente.
2. Uso de `ChangeDetectionStrategy.OnPush` sem tratar mutação de objeto/array (mutar em vez de criar nova referência quebra a detecção de mudança).
3. `*ngFor`/`@for` sem `trackBy`/`track` em listas que re-renderizam.
4. Lógica de negócio dentro do componente que deveria estar em um serviço.
5. Chamada HTTP direta no componente em vez de via serviço injetado.
6. Uso de `any` para "resolver rápido" um erro de tipo.
7. Segredos ou URLs internas hardcoded no código/`environment.ts`.
