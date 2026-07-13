# 004 - State Management

## Objetivo
Definir e implementar a estratégia de estado global de `<nome do projeto>` (se necessário), evitando complexidade desnecessária.

## Escopo
- Entra: avaliação de necessidade real de estado global (RxJS puro vs Signals vs NgRx), implementação da escolha para o estado que precisa ser compartilhado entre features.
- Não entra: estado local de componente (isso fica na feature específica).

## Entregáveis esperados
- Decisão de state management documentada no README (com justificativa — não adotar NgRx só por padrão, se RxJS/Signals resolvem).
- Estado global implementado para o(s) caso(s) que realmente precisam.

## Critérios de aceite
- [ ] Decisão de arquitetura documentada com justificativa.
- [ ] Estado global testado (unitário), sem subscription leak (`takeUntilDestroyed`/`async` pipe).
- [ ] Nenhuma mutação direta de estado em componentes `OnPush` (nova referência sempre).

## Skills relevantes
- `angular-scaffolding`
- `angular-code-review`
- `angular-unit-testing`
