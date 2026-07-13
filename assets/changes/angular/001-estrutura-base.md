# 001 - Estrutura Base

## Objetivo
Configurar o esqueleto do projeto Angular `<nome do projeto>`: setup inicial, roteamento e shell da aplicação.

## Escopo
- Entra: `ng new` (standalone components), roteamento base (`app.routes.ts`), shell da aplicação (layout, navegação), configuração de ambiente (`environment.ts`).
- Não entra: features de negócio específicas.

## Entregáveis esperados
- Projeto Angular rodando localmente (`ng serve`).
- Roteamento base configurado (lazy loading já preparado para as próximas features).
- Shell da aplicação (header/navegação/layout) implementado.

## Critérios de aceite
- [ ] Projeto builda e roda sem erro (`ng build`, `ng serve`).
- [ ] Roteamento base configurado com lazy loading pronto para novas features.
- [ ] Nenhum segredo real em `environment.ts` (ver skill `angular-secrets`).

## Skills relevantes
- `angular-scaffolding`
- `angular-secrets`
- `angular-performance` — lazy loading desde o início.
