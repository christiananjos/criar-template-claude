---
name: angular-code-quality
description: Use ao revisar estilo de código, tipagem estrita do TypeScript, ou ao configurar/rodar análise estática (ESLint, SonarQube) em projetos Angular. Também dispara ao integrar com a API do Sonar e priorizar quais issues resolver.
---

# Qualidade de código Angular

1. Garanta `"strict": true` no `tsconfig.json` e trate erro de tipo como bloqueante, não `any` disfarçado.
2. Rode `ng lint` (ESLint + Angular ESLint) e corrija antes de considerar a tarefa concluída — nunca desabilite regra via comentário sem justificativa.
3. Siga o Angular Style Guide oficial para nomenclatura (`kebab-case` de arquivo, sufixos `.component`/`.service`/`.pipe`).
4. Evite `any`; prefira tipos explícitos ou `unknown` com narrowing.
5. Monitore o tamanho do bundle (`ng build --stats-json` + `webpack-bundle-analyzer` ou budgets no `angular.json`) — alerte se um PR aumentar significativamente o bundle.

## Integração com SonarQube/SonarCloud

1. Verifique se o projeto já tem Sonar configurado (`sonar-project.properties`, referência em pipeline de CI) e se já existe análise anterior.
2. Se não houver, pergunte ao usuário (via AskUserQuestion) a URL do servidor Sonar e o token (`SONAR_TOKEN`) — nunca commitar o token, tratar como segredo (ver skill `angular-secrets`).
3. Rode a análise (`sonar-scanner` apontando pro relatório de cobertura do Karma/Jest) ou consulte issues existentes via API REST (`GET <url>/api/issues/search?componentKeys=<project-key>&resolved=false`).
4. Agrupe issues por tipo (Bug, Vulnerability, Code Smell, Security Hotspot) e severidade, apresente um plano de ação e pergunte ao usuário (via AskUserQuestion) quais tipos resolver agora — corrija só o escolhido.
