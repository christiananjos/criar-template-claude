---
name: dotnet-cicd
description: Use ao criar ou atualizar pipelines de CI/CD para projetos .NET (build, testes, análise estática, publish, Docker).
---

# CI/CD para .NET

Um pipeline completo deve ter, nesta ordem:

1. `dotnet restore` → `dotnet build` (falha rápido em erro de compilação).
2. `dotnet test` com relatório de cobertura (`--collect:"XPlat Code Coverage"`).
3. Análise estática (Sonar/analyzers) — gate de qualidade antes de prosseguir.
4. `dotnet publish` gerando artefato ou imagem Docker (multi-stage build, usuário non-root, imagem `-alpine`/`-noble-chiseled` quando possível).
5. Versionamento semântico automático (baseado em commits ou tag) e changelog gerado a partir do histórico de commits.
6. Nunca commitar segredo em variável de pipeline em texto puro — usar secrets manager da plataforma (GitHub Secrets, Azure Key Vault).
