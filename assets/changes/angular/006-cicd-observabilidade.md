# 006 - CI/CD e Observabilidade

## Objetivo
Configurar o pipeline de build/test/deploy e a observabilidade (error tracking, Core Web Vitals) para `<nome do projeto>`.

## Escopo
- Entra: pipeline (lint → test → e2e → build → budget de bundle → deploy), rastreamento de erros (Sentry ou equivalente), Lighthouse CI.
- Não entra: novas funcionalidades de negócio.

## Entregáveis esperados
- Pipeline cobrindo lint, testes, build com budget de bundle.
- Error tracking configurado, sem dados sensíveis nos relatórios.
- Auditoria de segurança inicial (`npm audit`).

## Critérios de aceite
- [ ] Pipeline cobrindo todas as etapas acima (anotar se rodou em runner real ou só localmente).
- [ ] Error tracking testado manualmente (erro forçado aparece no serviço de tracking, sem dado sensível).
- [ ] `npm audit` sem achados críticos não tratados.
- [ ] README atualizado refletindo o estado real do projeto, incluindo dívida técnica.

## Skills relevantes
- `angular-cicd`
- `angular-observability`
- `angular-security-audit`
- `angular-documentation`
