---
name: angular-cicd
description: Use ao criar ou atualizar pipelines de CI/CD para projetos Angular (lint, testes, build, budget de bundle, deploy).
---

# CI/CD para Angular

Um pipeline completo deve ter, nesta ordem:

1. `npm ci` (nunca `npm install` em CI, para respeitar o lockfile).
2. `ng lint` → falha rápido em erro de estilo/tipo.
3. `ng test --code-coverage --watch=false` com gate de cobertura mínima.
4. `ng e2e` (ou Cypress/Playwright) para os fluxos críticos.
5. `ng build --configuration production` com checagem de budget de bundle (`angular.json` → `budgets`).
6. Deploy do artefato estático (CDN/hosting) com versionamento e possibilidade de rollback.
7. Nunca commitar segredo em variável de pipeline em texto puro — usar secrets manager da plataforma.
