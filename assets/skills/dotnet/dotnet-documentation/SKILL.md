---
name: dotnet-documentation
description: Use ao documentar APIs .NET (anotações OpenAPI/Swagger), ao criar ou atualizar o README do projeto (especificação, diagramas, exemplos de uso, funcionalidades implementadas, to-do), ou ao registrar decisões de arquitetura (ADRs). Disparar sempre que uma nova funcionalidade for implementada.
---

# Documentação .NET

1. Toda ação de endpoint pública deve ter anotação OpenAPI (`[ProducesResponseType]`, `.WithSummary()`/`.WithDescription()` em Minimal API) descrevendo request/response e códigos de status possíveis.
2. Mudanças que quebram compatibilidade da API (remover campo, mudar tipo, remover endpoint) exigem versionamento (`/v2/...`) e não sobrescrever o contrato anterior.
3. Decisões de arquitetura relevantes (escolha de padrão, troca de biblioteca, trade-off aceito) devem virar um ADR em `docs/adr/NNNN-titulo.md`, com contexto, decisão e consequências.
4. Mantenha o `CLAUDE.md` do projeto atualizado quando a convenção de código ou arquitetura mudar.

## README do projeto

Mantenha um `README.md` na raiz do projeto com, no mínimo, estas seções:

1. **Especificação/visão geral** — o que o projeto faz, principal domínio de negócio, tecnologias e versão do .NET usadas.
2. **Arquitetura** — diagrama (Mermaid) das camadas/componentes principais (ex: `graph TD` mostrando API → Application → Domain → Infrastructure, ou o fluxo entre serviços em caso de microsserviços).
3. **Como rodar localmente** — pré-requisitos, comandos de setup (`dotnet restore`, `dotnet run`, migrations, variáveis de ambiente necessárias).
4. **Exemplo de uso** — request/response real de um endpoint principal (ou snippet de código de uso da lib/serviço), não apenas descrição textual.
5. **Funcionalidades implementadas** — lista do que já existe no projeto, curta e objetiva.
6. **To-do** — checklist markdown (`- [ ]` pendente / `- [x]` concluído) do que falta ou está planejado.
7. Qualquer outra seção relevante ao domínio (variáveis de ambiente, decisões de arquitetura relevantes com link para o ADR correspondente, links úteis).

Regra de atualização: **toda vez que uma nova funcionalidade for implementada**, atualize o README no mesmo PR/commit — mova o item correspondente de "To-do" para "Funcionalidades implementadas" (ou marque o checkbox `[x]`), ajuste o exemplo de uso se o contrato mudou, e atualize o diagrama se a arquitetura foi afetada. Um README desatualizado é tratado como tarefa incompleta, não como débito técnico para depois.
