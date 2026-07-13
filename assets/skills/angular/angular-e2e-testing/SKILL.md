---
name: angular-e2e-testing
description: Use ao escrever ou revisar testes end-to-end em projetos Angular (Cypress ou Playwright), validando fluxos reais de usuário no browser.
---

# Testes E2E Angular

1. Use Cypress ou Playwright (conforme já configurado no projeto — verifique `cypress.config.ts`/`playwright.config.ts`) para simular fluxo real do usuário.
2. Prefira seletores estáveis (`data-testid`) em vez de classes CSS ou texto que muda com frequência.
3. Use Page Object / Page Component pattern para encapsular seletores e ações de cada tela, evitando duplicação entre testes.
4. Isole dados de teste: use fixtures ou mocks de API (`cy.intercept`/`page.route`) para não depender de estado real de backend sempre que possível; rode contra ambiente real apenas nos fluxos críticos (smoke tests).
5. Não teste aqui regra de negócio isolada (isso é `angular-unit-testing`) — o objetivo é validar que o usuário consegue completar a jornada (login, checkout, etc).
6. Rode os testes E2E críticos no pipeline de CI antes de merge em `main`.
