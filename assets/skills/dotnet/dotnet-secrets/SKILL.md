---
name: dotnet-secrets
description: Use ao configurar appsettings por ambiente, gerenciar segredos (User Secrets, Key Vault) em projetos .NET, ou antes de commitar/dar push para checar vazamento de segredo.
---

# Configuração e segredos .NET

1. Nunca commitar segredo real em `appsettings.json` — usar `appsettings.{Environment}.json` só para configuração não sensível.
2. Em desenvolvimento local, usar `dotnet user-secrets` para credenciais — nunca `appsettings.Development.json` com senha real.
3. Em produção, usar um secrets manager (Azure Key Vault, AWS Secrets Manager) injetado via variável de ambiente ou provider de configuração.
4. Antes de qualquer commit/push, verificar se algum arquivo alterado contém string que parece segredo (connection string com senha, API key, token) mesmo em arquivos de configuração aparentemente inofensivos.
5. Garantir que `.gitignore` cobre `appsettings.*.local.json`, `secrets.json` e afins.
