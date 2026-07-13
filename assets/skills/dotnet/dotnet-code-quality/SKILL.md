---
name: dotnet-code-quality
description: Use ao revisar estilo de código, nullable reference types, padrões async/await, ou ao configurar/rodar análise estática (SonarQube, analyzers) em projetos .NET. Também dispara ao integrar com a API do Sonar e priorizar quais issues resolver.
---

# Qualidade de código .NET

Ao revisar ou configurar qualidade estática:

1. Garanta `<Nullable>enable</Nullable>` no `.csproj` e trate warnings de nullability como erro em CI.
2. Nunca use `async void` fora de event handlers; métodos assíncronos retornam `Task`/`Task<T>`.
3. Nunca bloqueie chamadas assíncronas com `.Result` ou `.Wait()` — propague `async`/`await` até o topo.
4. Rode `dotnet format` e analisadores (`.editorconfig` com regras habilitadas) antes de considerar a tarefa concluída.
5. Rode `dotnet list package --vulnerable` e `dotnet list package --deprecated` periodicamente — reporte achados, não ignore.

## Integração com SonarQube/SonarCloud

1. Verifique se o projeto já tem Sonar configurado (`.sonar/`, `sonar-project.properties`, referência em pipeline de CI) e se já existe uma análise anterior rodada.
2. Se não houver configuração/execução prévia, pergunte ao usuário (via AskUserQuestion):
   - A URL do servidor Sonar (SonarQube on-premise ou SonarCloud).
   - O token de autenticação (`SONAR_TOKEN`) para chamar a API.
   Nunca commitar o token em arquivo algum — trate como segredo (ver skill `dotnet-secrets`), preferindo variável de ambiente local à cópia direta em arquivo de configuração.
3. Com URL e token em mãos, rode a análise:
   - Local/CI: `dotnet sonarscanner begin /k:"<project-key>" /d:sonar.host.url="<url>" /d:sonar.token="<token>"` → `dotnet build` → `dotnet sonarscanner end /d:sonar.token="<token>"`.
   - Para apenas consultar issues já existentes sem rodar nova análise, use a API REST do Sonar diretamente: `GET <url>/api/issues/search?componentKeys=<project-key>&resolved=false`.
4. Ao receber o resultado (nova análise ou consulta de issues existentes):
   - Agrupe as issues por tipo (Bug, Vulnerability, Code Smell, Security Hotspot) e severidade (Blocker, Critical, Major, Minor, Info).
   - Apresente um plano de ação resumido ao usuário com essa contagem e pergunte (via AskUserQuestion) quais tipos/severidades ele quer resolver agora.
   - Corrija apenas o que foi escolhido — não resolva tudo de uma vez sem alinhamento, para evitar um PR gigante misturando causas não relacionadas.
