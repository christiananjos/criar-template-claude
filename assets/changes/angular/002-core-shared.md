# 002 - Core / Shared

## Objetivo
Implementar os serviços e componentes compartilhados entre todas as features de `<nome do projeto>`: interceptors HTTP, tratamento de erro, componentes de UI reutilizáveis.

## Escopo
- Entra: `HttpInterceptor` (auth/retry/erro), serviço de autenticação (mesmo que esqueleto de exemplo, documentado como tal), componentes de UI compartilhados (botão, input, layout).
- Não entra: lógica de feature específica.

## Entregáveis esperados
- Interceptor de erro HTTP centralizado.
- Componentes de UI compartilhados documentados (Storybook ou comentário JSDoc).
- Serviço de autenticação básico, com estado exposto via `Signal`/`BehaviorSubject`.

## Critérios de aceite
- [ ] Interceptor de erro tratando falhas de rede/HTTP de forma centralizada.
- [ ] Componentes compartilhados testados (unitário) e documentados.
- [ ] Nenhum dado sensível logado no console/tracking (ver skill `angular-observability`).

## Skills relevantes
- `angular-scaffolding`
- `angular-unit-testing`
- `angular-observability`
