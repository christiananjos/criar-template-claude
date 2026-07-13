---
name: angular-observability
description: Use ao configurar rastreamento de erros, métricas de performance (Core Web Vitals) ou logging client-side em projetos Angular.
---

# Observabilidade Angular

1. Configure um `ErrorHandler` global (Sentry ou equivalente) capturando erros não tratados de componentes/serviços, com contexto (rota, usuário anonimizado).
2. Nunca logue dados sensíveis no console ou no serviço de tracking (senha, token, PII).
3. Monitore Core Web Vitals (LCP, INP, CLS) — configure Lighthouse CI no pipeline para detectar regressão de performance antes do merge.
4. Instrumente chamadas HTTP críticas com correlação de `trace-id` vindo do backend, se aplicável, para depuração ponta a ponta.
5. Diferencie logging de desenvolvimento (verbose, `console.log` permitido só atrás de flag) de produção (silencioso, só tracking de erro).
