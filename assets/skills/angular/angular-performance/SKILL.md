---
name: angular-performance
description: Use ao otimizar performance de projetos Angular (lazy loading, change detection, bundle size, listas grandes).
---

# Performance Angular

1. Use lazy loading de rotas (`loadComponent`/`loadChildren`) para features que não são acessadas no carregamento inicial — nunca tudo em um único bundle eager.
2. Prefira `ChangeDetectionStrategy.OnPush` em componentes de apresentação, combinado com imutabilidade de dados (nova referência em vez de mutação).
3. Use `trackBy` em todo `*ngFor` sobre listas que podem mudar, e `@for` com `track` no novo control flow syntax.
4. Para listas muito grandes, use virtual scrolling (`cdk-virtual-scroll-viewport`) em vez de renderizar tudo de uma vez.
5. Evite chamadas de função dentro do template (`{{ getValue() }}`) que rodam a cada ciclo de detecção — use pipe puro ou pré-calcule o valor.
6. Monitore o tamanho do bundle a cada PR (budgets no `angular.json`) — investigue aumento inesperado (dependência pesada importada sem tree-shaking).
