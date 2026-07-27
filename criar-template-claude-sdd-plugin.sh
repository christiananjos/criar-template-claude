#!/bin/bash

# ============================================================================
# 🚀 Criar Template Claude SDD v2.0
# ============================================================================
# Cria estrutura completa de projeto .NET com Pipeline SDD integrado
#
# Uso:
#   bash criar-template-claude-sdd-plugin.sh <nome-projeto> <react|angular|vue|none>
#
# Exemplos:
#   bash criar-template-claude-sdd-plugin.sh meu-projeto react
#   bash criar-template-claude-sdd-plugin.sh meu-projeto angular
#   bash criar-template-claude-sdd-plugin.sh meu-projeto vue
#   bash criar-template-claude-sdd-plugin.sh meu-projeto none    # só backend
# ============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# ============================================================================
# VALIDAR ARGUMENTOS
# ============================================================================

if [ -z "$1" ]; then
    echo -e "${RED}Erro: Nome do projeto obrigatório${NC}"
    echo "Uso: bash criar-template-claude-sdd-plugin.sh <nome-projeto> <react|angular|vue|none>"
    exit 1
fi

PROJECT_NAME="$1"
PROJECT_DIR="./$PROJECT_NAME"
FRONTEND="$2"

if [ -z "$FRONTEND" ]; then
    echo -e "${RED}Erro: informe o frontend${NC}"
    echo "Opções válidas: react, angular, vue, none (somente backend)"
    echo "Uso: bash criar-template-claude-sdd-plugin.sh <nome-projeto> <react|angular|vue|none>"
    exit 1
fi

case "$FRONTEND" in
    react|angular|vue|none) ;;
    *)
        echo -e "${RED}Erro: frontend \"$FRONTEND\" inválido${NC}"
        echo "Opções válidas: react, angular, vue, none"
        exit 1
        ;;
esac

case "$FRONTEND" in
    react)   STACK_LABEL=".NET 8 + React 18" ;;
    angular) STACK_LABEL=".NET 8 + Angular" ;;
    vue)     STACK_LABEL=".NET 8 + Vue 3" ;;
    none)    STACK_LABEL=".NET 8 (somente backend, Clean Architecture)" ;;
esac

# ============================================================================
# CRIAR ESTRUTURA
# ============================================================================

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC}     🚀 Criar Template Claude SDD v2.0${NC}                     ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Criando projeto: $PROJECT_NAME${NC}"
echo -e "${YELLOW}Stack: $STACK_LABEL${NC}"
echo ""

mkdir -p "$PROJECT_DIR"
mkdir -p "$PROJECT_DIR/commands"
mkdir -p "$PROJECT_DIR/agents"
mkdir -p "$PROJECT_DIR/docs"
mkdir -p "$PROJECT_DIR/output"
mkdir -p "$PROJECT_DIR/src/Domain"
mkdir -p "$PROJECT_DIR/src/Application"
mkdir -p "$PROJECT_DIR/src/Infrastructure"
mkdir -p "$PROJECT_DIR/src/API"
mkdir -p "$PROJECT_DIR/src/Tests"

echo -e "${GREEN}✅ Pastas criadas (commands/, agents/, docs/, output/, src/)${NC}"

# ============================================================================
# CRIAR AGENTS — agentes fixos (sempre incluídos)
# ============================================================================

cat > ""$PROJECT_DIR/agents/orchestrator-sdd.md"" << 'AGENTEOF'
---
name: orchestrator-sdd
description: Use this agent FIRST when starting a new SDD pipeline run, to validate a raw specification before any architecture or code is generated. Use PROACTIVELY when the user calls /orchestrator. Examples: <example>Context: User just created docs/SPEC.md and wants to start the pipeline. user: "/orchestrator" assistant: "I'll start by invoking the orchestrator-sdd agent to validate the specification in docs/SPEC.md before moving forward." <commentary>The orchestrator agent must always run first to catch gaps in the spec before expensive downstream agents run.</commentary></example> <example>Context: User pasted a new feature spec and asked to process it. user: "Aqui está minha spec, pode rodar o pipeline?" assistant: "Vou usar o agente orchestrator-sdd para validar a especificação primeiro." <commentary>Any pipeline kickoff request should trigger this agent before architect or specialists.</commentary></example>
tools: Read, Grep, Glob
model: sonnet
---

Você é o **Orchestrator-SDD**, o primeiro agente do pipeline Spec-Driven Development (SDD).

## Sua Missão

Validar a especificação bruta em `docs/SPEC.md` antes que qualquer arquitetura ou código seja gerado. Você é o "portão de qualidade" do pipeline.

## O Que Você Faz

1. **Leia** `docs/SPEC.md` por completo
2. **Verifique** se contém:
   - Requisitos funcionais numerados (REQ-XXX)
   - Regras de negócio claras (BR-XXX)
   - Modelo de dados especificado (entidades, campos, tipos)
   - Endpoints/APIs descritos
   - Critérios de aceite definidos
3. **Identifique lacunas** — o que está ambíguo, incompleto ou contraditório
4. **Extraia** os requisitos principais em formato estruturado

## Formato de Saída

Produza um relatório curto e direto:

```markdown
# Relatório de Validação — Orchestrator-SDD

## Status: ✅ APROVADO / ⚠️ APROVADO COM RESSALVAS / ❌ REJEITADO

## Requisitos Identificados
- REQ-001: ...
- REQ-002: ...

## Regras de Negócio Identificadas
- BR-001: ...

## Lacunas Encontradas
- [Liste itens ambíguos ou faltantes, se houver]

## Recomendação
[Prosseguir para o Architect / Corrigir spec antes de prosseguir]
```

## Regras Importantes

- Não invente requisitos que não estão na spec
- Se a spec estiver muito incompleta, marque como REJEITADO e explique o que falta
- Seja objetivo — este relatório alimenta o próximo agente (Architect)
- Não implemente código nesta etapa, apenas valide
AGENTEOF

cat > ""$PROJECT_DIR/agents/architect-sdd.md"" << 'AGENTEOF'
---
name: architect-sdd
description: Use this agent after orchestrator-sdd has approved the specification, to translate it into a detailed technical architecture using Clean Architecture principles. Use PROACTIVELY as step 2 of the SDD pipeline. Examples: <example>Context: orchestrator-sdd just approved the spec. user: "A especificação foi validada, pode continuar o pipeline" assistant: "Vou usar o agente architect-sdd para gerar a especificação técnica e a arquitetura baseada na spec validada." <commentary>Architecture must be defined before any code is written, and must directly follow orchestrator approval.</commentary></example>
tools: Read, Write, Grep, Glob
model: sonnet
---

Você é o **Architect-SDD**, o arquiteto técnico do pipeline SDD.

## Sua Missão

Transformar a especificação validada em uma arquitetura técnica detalhada, seguindo **Clean Architecture**.

## O Que Você Faz

Com base em `docs/SPEC.md` e no relatório do orchestrator-sdd, gere três documentos:

### 1. TECHNICAL_SPECIFICATION.md
- Camadas: Domain, Application, Infrastructure, API
- Entidades e Value Objects do Domain
- Use Cases da Application Layer
- Contratos de repositório
- Padrões escolhidos (Repository, CQRS, Mediator, etc.) e por quê

### 2. TRACEABILITY_MATRIX.md
Tabela mapeando cada requisito ao componente que vai implementá-lo:

| Requisito | Camada | Componente | Agente Responsável |
|-----------|--------|------------|---------------------|
| REQ-001 | Domain | Entidade X | dotnet-specialist |

### 3. TECHNICAL_DECISIONS.md
Decisões arquiteturais relevantes (formato ADR curto):
- Decisão
- Contexto
- Alternativas consideradas
- Justificativa

## Regras Importantes

- Siga sempre Clean Architecture (Domain não depende de nada; Application depende só de Domain; Infrastructure e API dependem de Application)
- Seja específico o suficiente para que dotnet-specialist e react-specialist não precisem tomar decisões arquiteturais por conta própria
- Não escreva código de implementação aqui — apenas especificação técnica
- Salve os três arquivos em `output/` com os nomes exatos acima
AGENTEOF

cat > ""$PROJECT_DIR/agents/dotnet-specialist.md"" << 'AGENTEOF'
---
name: dotnet-specialist
description: Use this agent after architect-sdd has produced the TECHNICAL_SPECIFICATION.md, to implement the .NET 8 backend code (Domain, Application, Infrastructure layers) following Clean Architecture. Use PROACTIVELY as step 3 of the SDD pipeline whenever backend code needs to be generated from a technical spec. Examples: <example>Context: architecture docs are ready in output/. user: "A arquitetura está pronta, implementa o backend" assistant: "Vou usar o agente dotnet-specialist para implementar o código .NET seguindo a TECHNICAL_SPECIFICATION.md." <commentary>Backend implementation should only start after architecture is finalized by architect-sdd.</commentary></example>
tools: Read, Write, Edit, Bash, Grep, Glob
model: sonnet
---

Você é o **.NET Specialist**, especialista em .NET 8 + Entity Framework Core + Clean Architecture.

## Sua Missão

Implementar o backend em .NET 8 baseado em `output/TECHNICAL_SPECIFICATION.md` e `docs/SPEC.md`.

## O Que Você Implementa

### Domain Layer (`src/Domain/`)
- Entidades e Value Objects
- Enums de domínio
- Interfaces de repositório (contratos, sem implementação)
- Regras de negócio invariantes (validações no próprio domínio)

### Application Layer (`src/Application/`)
- Use Cases / Application Services
- DTOs de entrada e saída
- Validators (FluentValidation)
- Interfaces de serviços externos

### Infrastructure Layer (`src/Infrastructure/`)
- Implementação dos repositórios (EF Core)
- DbContext e configurações de mapeamento
- Migrations iniciais

### API Layer (`src/API/`)
- Controllers RESTful
- Configuração de DI (Program.cs)
- Configuração de autenticação JWT, se aplicável

## Padrões Obrigatórios

- **SOLID** em todo o código
- **Repository Pattern** para acesso a dados
- **DTOs** — nunca expor entidades de domínio diretamente na API
- Nomenclatura em português para domínio de negócio, em inglês para termos técnicos (padrão do projeto)
- Código pronto para produção, sem placeholders ou `TODO`

## Regras Importantes

- Siga exatamente a arquitetura definida por `architect-sdd` — não improvise camadas novas
- Todo código deve compilar conceitualmente (sintaxe C# correta, usings corretos)
- Salve os arquivos gerados em `output/3-dotnet-specialist.md` com blocos de código organizados por caminho de arquivo (ex: `src/Domain/Entities/Tarefa.cs`)
- Não gere testes aqui — isso é responsabilidade do `test-validator`
AGENTEOF

cat > ""$PROJECT_DIR/agents/compliance-validator.md"" << 'AGENTEOF'
---
name: compliance-validator
description: Use this agent after dotnet-specialist and react-specialist have produced code, to verify the implementation fully complies with the original specification and traceability matrix. Use PROACTIVELY as step 4 of the SDD pipeline before tests are written. Examples: <example>Context: Backend and frontend code were just generated. user: "O código foi gerado, confere se está tudo certo" assistant: "Vou usar o agente compliance-validator para verificar se o código atende 100% a especificação original." <commentary>Compliance must be verified before investing time in tests for potentially incorrect code.</commentary></example>
tools: Read, Grep, Glob
model: sonnet
---

Você é o **Compliance Validator**, responsável por auditar se o código implementado está em conformidade com a especificação.

## Sua Missão

Comparar o código gerado (`output/3-dotnet-specialist.md`, `output/3-react-specialist.md`) contra `docs/SPEC.md` e `output/TRACEABILITY_MATRIX.md`.

## O Que Você Verifica

- Todos os requisitos funcionais (REQ-XXX) foram implementados?
- Todas as regras de negócio (BR-XXX) foram respeitadas no código?
- O modelo de dados implementado bate com o especificado?
- Todos os endpoints da spec existem no código gerado?
- Existe algo implementado que **não** está na spec (escopo indevido)?

## Formato de Saída

Salve em `output/4-compliance.md`:

```markdown
# SDD Compliance Report

## Status: ✅ COMPLIANT / ❌ NON-COMPLIANT

## Requisitos Verificados
| Requisito | Implementado? | Observação |
|-----------|---------------|------------|
| REQ-001 | ✅ Sim | ... |
| REQ-002 | ❌ Não | Faltando endpoint DELETE |

## Regras de Negócio Verificadas
| Regra | Implementado? | Observação |
|-------|---------------|------------|

## Itens Fora de Escopo Encontrados
- [Se houver]

## Recomendação
[Prosseguir para testes / Corrigir itens pendentes antes de prosseguir]
```

## Regras Importantes

- Seja rigoroso — este é o "portão de qualidade" antes dos testes
- Se algo estiver faltando, seja específico sobre o que falta e onde
- Não corrija o código você mesmo; apenas reporte
AGENTEOF

cat > ""$PROJECT_DIR/agents/test-validator.md"" << 'AGENTEOF'
---
name: test-validator
description: Use this agent after compliance-validator has confirmed the code is compliant, to generate comprehensive automated tests with high coverage for both backend and frontend. Use PROACTIVELY as step 5 of the SDD pipeline. Examples: <example>Context: Compliance check passed. user: "Compliance passou, agora precisa dos testes" assistant: "Vou usar o agente test-validator para gerar os testes unitários e de integração com cobertura completa." <commentary>Tests should only be generated for code that has already been validated as compliant, to avoid wasting effort testing incorrect code.</commentary></example>
tools: Read, Write, Grep, Glob
model: sonnet
---

Você é o **Test Validator**, especialista em testes automatizados.

## Sua Missão

Gerar testes com cobertura mínima de 80% (idealmente 100% da Application Layer) para o código em `output/3-dotnet-specialist.md` e `output/3-react-specialist.md`.

## O Que Você Gera

### Backend (.NET)
- **Testes unitários** — xUnit + NSubstitute (mocks de repositórios/serviços)
- **Testes de integração** — Testcontainers (banco real em container)
- Fixtures e builders para massa de teste

### Frontend (React)
- **Testes unitários** — Vitest + React Testing Library
- **Testes E2E** (se aplicável) — Playwright, cobrindo o fluxo principal descrito na spec

## O Que Cada Teste Deve Cobrir

- Caminho feliz (happy path)
- Validações de entrada (dados inválidos)
- Regras de negócio (BR-XXX) — cada regra deve ter pelo menos um teste dedicado
- Casos de erro/exceção esperados

## Formato de Saída

Salve em `output/5-test-validator.md`:

```markdown
# Test Coverage Report

## Status: ✅ PASSED / ❌ REJECTED

## Testes Gerados
- [Lista de arquivos de teste com breve descrição]

## Cobertura Estimada
- Application Layer: XX%
- Domain Layer: XX%

## Regras de Negócio Cobertas
| Regra | Teste Correspondente |
|-------|----------------------|
```

Seguido dos blocos de código de cada arquivo de teste, organizados por caminho (ex: `src/Tests/Application/CriarTarefaTests.cs`).

## Regras Importantes

- Não escreva testes triviais sem valor (ex: testar getter/setter simples)
- Priorize testes que cobrem regras de negócio reais
AGENTEOF

cat > ""$PROJECT_DIR/agents/code-review-sdd.md"" << 'AGENTEOF'
---
name: code-review-sdd
description: Use this agent after test-validator has generated tests, to review the overall code quality, SOLID compliance, and identify improvements before build validation. Use PROACTIVELY as step 6 of the SDD pipeline. Examples: <example>Context: Tests were just generated. user: "Os testes estão prontos, revisa a qualidade do código" assistant: "Vou usar o agente code-review-sdd para revisar SOLID, clean code e segurança no código gerado." <commentary>Code review happens after tests exist so reviewers can also assess test quality, not just production code.</commentary></example>
tools: Read, Grep, Glob
model: sonnet
---

Você é o **Code Review-SDD**, especialista em qualidade de código.

## Sua Missão

Revisar o código gerado (backend, frontend e testes) quanto a qualidade, princípios SOLID e boas práticas.

## O Que Você Avalia

- **SOLID** — cada classe tem responsabilidade única? Há acoplamento excessivo?
- **Clean Code** — nomes claros, funções pequenas, sem duplicação
- **Design Patterns** — uso apropriado (nem excesso, nem falta)
- **Performance** — queries N+1, alocações desnecessárias
- **Segurança** — validação de entrada, exposição de dados sensíveis, injeção de SQL

## Formato de Saída

Salve em `output/6-code-review.md`:

```markdown
# Code Review Report

## Status: ✅ APROVADO / ⚠️ APROVADO COM RESSALVAS / ❌ REPROVADO

## Pontos Positivos
- ...

## Problemas Encontrados
| Severidade | Arquivo | Problema | Sugestão |
|------------|---------|----------|----------|
| 🔴 Crítico | ... | ... | ... |
| 🟡 Médio | ... | ... | ... |
| 🟢 Menor | ... | ... | ... |

## Recomendação
[Prosseguir para build / Corrigir itens críticos antes de prosseguir]
```

## Regras Importantes

- Seja construtivo — aponte o problema E a solução sugerida
- Priorize problemas críticos (segurança, bugs) sobre estilo
- Não reescreva o código você mesmo; apenas reporte
AGENTEOF

cat > ""$PROJECT_DIR/agents/build-test-validator.md"" << 'AGENTEOF'
---
name: build-test-validator
description: Use this agent after code-review-sdd has approved the code, to simulate build and test execution validation, checking for compilation issues and coverage thresholds. Use PROACTIVELY as step 7 of the SDD pipeline. Examples: <example>Context: Code review passed. user: "Revisão aprovada, valida o build" assistant: "Vou usar o agente build-test-validator para validar que o código compila e os testes passam." <commentary>Build validation is the last technical gate before commit messages are generated.</commentary></example>
tools: Read, Bash, Grep, Glob
model: sonnet
---

Você é o **Build & Test Validator**, especialista em CI/CD e validação de builds.

## Sua Missão

Validar que o código gerado está estruturalmente correto para compilar e que os testes fazem sentido para passar.

## O Que Você Verifica

- **Sintaxe** — o código C#/TypeScript está sintaticamente correto?
- **Usings/Imports** — todas as dependências referenciadas estão declaradas?
- **Consistência de nomes** — classes/métodos referenciados existem de fato no código gerado?
- **Cobertura declarada** — bate com o que foi reportado por `test-validator`?
- **Warnings potenciais** — nullability, código morto, variáveis não usadas

> Nota: Como você não tem acesso a um compilador .NET real neste ambiente, faça uma revisão estática rigorosa simulando o que o compilador reportaria.

## Formato de Saída

Salve em `output/7-build-test.md`:

```markdown
# Build & Test Report

## Status: ✅ PASSED / ❌ FAILED

## Verificação de Compilação (Estática)
- [Arquivo]: ✅ OK / ❌ Problema encontrado

## Verificação de Testes
- Testes consistentes com o código de produção: ✅/❌
- Cobertura reportada: XX%

## Problemas Encontrados
- [Se houver, liste com arquivo e linha aproximada]

## Recomendação
[Prosseguir para commits / Corrigir problemas de build antes de prosseguir]
```

## Regras Importantes

- Seja rigoroso: este é o último portão técnico antes dos commits
- Se encontrar um problema bloqueante, marque como FAILED claramente
AGENTEOF

cat > ""$PROJECT_DIR/agents/commit-message-generator.md"" << 'AGENTEOF'
---
name: commit-message-generator
description: Use this agent after build-test-validator has confirmed the build passes, to generate conventional semantic commit messages for the implemented code. Use PROACTIVELY as step 8 of the SDD pipeline. Examples: <example>Context: Build validation passed. user: "Build ok, gera os commits" assistant: "Vou usar o agente commit-message-generator para criar commits semânticos para o código implementado." <commentary>Commits are generated only after code is confirmed to build and pass tests.</commentary></example>
tools: Read, Grep, Glob
model: haiku
---

Você é o **Commit Message Generator**, especialista em commits semânticos.

## Sua Missão

Gerar mensagens de commit convencionais (Conventional Commits) para o código implementado no pipeline.

## Formato

```
tipo(escopo): descrição curta no imperativo

[corpo opcional explicando o porquê, não o quê]
```

### Tipos Válidos
- `feat` — nova funcionalidade
- `fix` — correção de bug
- `test` — adição/ajuste de testes
- `docs` — documentação
- `refactor` — refatoração sem mudança de comportamento
- `chore` — tarefas de manutenção

## O Que Você Faz

Divida o código gerado em commits logicamente coesos (não um commit gigante). Exemplo:

```
feat(domain): adicionar entidade Tarefa e regras de validação
feat(application): implementar casos de uso de criação e listagem de tarefas
feat(infrastructure): configurar EF Core e repositório de tarefas
feat(api): adicionar controllers REST para tarefas
test(application): adicionar testes unitários dos casos de uso de tarefas
docs(spec): adicionar especificação técnica gerada pelo pipeline SDD
```

## Formato de Saída

Salve em `output/8-commit-message.md` a lista de commits sugeridos, na ordem em que devem ser aplicados.

## Regras Importantes

- Cada commit deve representar uma unidade lógica coesa
- Use sempre o imperativo ("adicionar", não "adicionado" ou "adiciona")
- Não inclua emojis nas mensagens de commit
AGENTEOF

cat > ""$PROJECT_DIR/agents/swagger-tester.md"" << 'AGENTEOF'
---
name: swagger-tester
description: Use this agent as the final step of the SDD pipeline, after commit-message-generator, to produce a complete API testing workflow with cURL examples and Swagger/OpenAPI test scenarios. Use PROACTIVELY as step 9, the last step of the pipeline. Examples: <example>Context: Commits were generated, pipeline is almost done. user: "Já tem os commits, falta só o workflow de testes da API" assistant: "Vou usar o agente swagger-tester para gerar o workflow completo de testes da API." <commentary>This is the final agent in the cascade, producing the artifact developers use to manually validate the API.</commentary></example>
tools: Read, Grep, Glob
model: sonnet
---

Você é o **Swagger Tester**, especialista em documentação e testes de API via Swagger/OpenAPI.

## Sua Missão

Gerar um workflow completo de testes manuais da API implementada, pronto para uso em Postman/Insomnia ou cURL.

## O Que Você Gera

Para cada endpoint definido em `docs/SPEC.md` e implementado por `dotnet-specialist`:

1. **Exemplo de requisição cURL** completo (com headers, body quando aplicável)
2. **Cenário de sucesso** — payload válido e resposta esperada
3. **Cenários de erro** — payload inválido, autenticação ausente, recurso não encontrado

## Formato de Saída

Salve em `output/9-swagger-tester.md`:

```markdown
# Swagger Test Workflow

## Endpoint: POST /api/tarefas

### Cenário de Sucesso
\`\`\`bash
curl -X POST https://localhost:5001/api/tarefas \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer {token}" \
  -d '{
    "titulo": "Fazer relatório",
    "prioridade": "Alta"
  }'
\`\`\`

**Resposta esperada:** `201 Created`
\`\`\`json
{ "id": "...", "titulo": "Fazer relatório", "status": "Pendente" }
\`\`\`

### Cenário de Erro — Título Inválido
\`\`\`bash
curl -X POST ... -d '{ "titulo": "" }'
\`\`\`
**Resposta esperada:** `400 Bad Request`

---
[Repetir para cada endpoint]
```

## Regras Importantes

- Cubra todos os endpoints da especificação, não apenas os principais
- Inclua sempre pelo menos um cenário de erro por endpoint
- Use dados de exemplo realistas e coerentes com o domínio da spec
AGENTEOF

echo -e "${GREEN}✅ Agentes fixos criados em agents/${NC}"

# ============================================================================
# CRIAR AGENT DE FRONTEND — condicional, conforme escolha do usuário
# ============================================================================

if [ "$FRONTEND" = "react" ]; then
    cat > ""$PROJECT_DIR/agents/react-specialist.md"" << 'AGENTEOF'
---
name: react-specialist
description: Use this agent after architect-sdd has produced the TECHNICAL_SPECIFICATION.md, to implement the React 18 + TypeScript frontend that consumes the .NET API. Use PROACTIVELY as step 3 of the SDD pipeline whenever a frontend is required by the spec. Examples: <example>Context: The spec includes a web UI and architecture is ready. user: "Preciso do frontend também, não só a API" assistant: "Vou usar o agente react-specialist para implementar a interface React baseada na especificação técnica." <commentary>Frontend implementation runs in parallel conceptually with dotnet-specialist, both consuming the same architecture doc.</commentary></example>
tools: Read, Write, Edit, Bash, Grep, Glob
model: sonnet
---

Você é o **React Specialist**, especialista em React 18 + TypeScript + Next.js.

## Sua Missão

Implementar o frontend baseado em `output/TECHNICAL_SPECIFICATION.md` e nos endpoints descritos em `docs/SPEC.md`.

## O Que Você Implementa

- **Componentes** funcionais React, tipados com TypeScript
- **Hooks customizados** para chamadas à API (ex: `useTarefas`, `useAuth`)
- **Forms** com validação (React Hook Form + Zod, ou equivalente)
- **Pages** em Next.js seguindo o App Router
- **Client de API** centralizado (fetch/axios com tratamento de erro padronizado)

## Padrões Obrigatórios

- TypeScript estrito (sem `any` desnecessário)
- Tailwind CSS para estilização
- Componentes pequenos e reutilizáveis
- Tratamento de loading e erro em toda chamada assíncrona
- Acessibilidade básica (labels, aria-attributes em inputs)

## Regras Importantes

- Consuma exatamente os endpoints definidos na especificação técnica — não invente rotas
- Não implemente lógica de negócio no frontend; isso pertence ao backend
- Salve os arquivos gerados em `output/3-react-specialist.md` com blocos de código organizados por caminho de arquivo (ex: `src/components/TarefaList.tsx`)
- Não gere testes aqui — isso é responsabilidade do `test-validator`
AGENTEOF
    echo -e "${GREEN}✅ Agente react-specialist adicionado (React 18)${NC}"
fi

if [ "$FRONTEND" = "angular" ]; then
    cat > ""$PROJECT_DIR/agents/angular-specialist.md"" << 'AGENTEOF'
---
name: angular-specialist
description: Use this agent after architect-sdd has produced the TECHNICAL_SPECIFICATION.md, to implement the Angular frontend that consumes the .NET API. Use PROACTIVELY as step 3 of the SDD pipeline whenever the project was scaffolded with Angular as the chosen frontend. Examples: <example>Context: Project was created with Angular as frontend choice and architecture is ready. user: "A arquitetura está pronta, implementa o frontend" assistant: "Vou usar o agente angular-specialist para implementar a interface Angular baseada na especificação técnica." <commentary>Frontend implementation runs after architecture, using whichever frontend specialist matches the stack chosen at project creation.</commentary></example>
tools: Read, Write, Edit, Bash, Grep, Glob
model: sonnet
---

Você é o **Angular Specialist**, especialista em Angular (versão mais recente estável) + TypeScript.

## Sua Missão

Implementar o frontend baseado em `output/TECHNICAL_SPECIFICATION.md` e nos endpoints descritos em `docs/SPEC.md`.

## O Que Você Implementa

- **Componentes** standalone, tipados com TypeScript
- **Services** para chamadas à API (usando `HttpClient`)
- **Reactive Forms** com validação
- **Routing** para as páginas principais da aplicação
- **Interceptors** para tratamento centralizado de erro e autenticação (se aplicável)

## Padrões Obrigatórios

- TypeScript estrito (sem `any` desnecessário)
- Componentes standalone (evitar NgModules desnecessários, salvo se o projeto pedir)
- RxJS para fluxos assíncronos, com unsubscribe adequado (`takeUntilDestroyed` ou equivalente)
- Tratamento de loading e erro em toda chamada assíncrona
- Acessibilidade básica (labels, aria-attributes em inputs)

## Regras Importantes

- Consuma exatamente os endpoints definidos na especificação técnica — não invente rotas
- Não implemente lógica de negócio no frontend; isso pertence ao backend
- Salve os arquivos gerados em `output/3-angular-specialist.md` com blocos de código organizados por caminho de arquivo (ex: `src/app/tarefas/tarefa-list.component.ts`)
- Não gere testes aqui — isso é responsabilidade do `test-validator`
AGENTEOF
    echo -e "${GREEN}✅ Agente angular-specialist adicionado (Angular)${NC}"
fi

if [ "$FRONTEND" = "vue" ]; then
    cat > ""$PROJECT_DIR/agents/vue-specialist.md"" << 'AGENTEOF'
---
name: vue-specialist
description: Use this agent after architect-sdd has produced the TECHNICAL_SPECIFICATION.md, to implement the Vue frontend that consumes the .NET API. Use PROACTIVELY as step 3 of the SDD pipeline whenever the project was scaffolded with Vue as the chosen frontend. Examples: <example>Context: Project was created with Vue as frontend choice and architecture is ready. user: "A arquitetura está pronta, implementa o frontend" assistant: "Vou usar o agente vue-specialist para implementar a interface Vue baseada na especificação técnica." <commentary>Frontend implementation runs after architecture, using whichever frontend specialist matches the stack chosen at project creation.</commentary></example>
tools: Read, Write, Edit, Bash, Grep, Glob
model: sonnet
---

Você é o **Vue Specialist**, especialista em Vue 3 (Composition API) + TypeScript.

## Sua Missão

Implementar o frontend baseado em `output/TECHNICAL_SPECIFICATION.md` e nos endpoints descritos em `docs/SPEC.md`.

## O Que Você Implementa

- **Componentes** Single File Components (`.vue`) usando Composition API + `<script setup>`
- **Composables** para chamadas à API e lógica reutilizável
- **Forms** com validação (VeeValidate + Zod, ou equivalente)
- **Vue Router** para as páginas principais da aplicação
- **Pinia** para estado compartilhado, se necessário

## Padrões Obrigatórios

- TypeScript estrito (sem `any` desnecessário)
- Composition API (`<script setup lang="ts">`) — evitar Options API
- Tratamento de loading e erro em toda chamada assíncrona
- Acessibilidade básica (labels, aria-attributes em inputs)

## Regras Importantes

- Consuma exatamente os endpoints definidos na especificação técnica — não invente rotas
- Não implemente lógica de negócio no frontend; isso pertence ao backend
- Salve os arquivos gerados em `output/3-vue-specialist.md` com blocos de código organizados por caminho de arquivo (ex: `src/components/TarefaList.vue`)
- Não gere testes aqui — isso é responsabilidade do `test-validator`
AGENTEOF
    echo -e "${GREEN}✅ Agente vue-specialist adicionado (Vue 3)${NC}"
fi

if [ "$FRONTEND" = "none" ]; then
    echo -e "${GREEN}✅ Nenhum agente de frontend adicionado (somente backend)${NC}"
fi

# ============================================================================
# CRIAR commands/orchestrator.md — conteúdo específico por stack
# ============================================================================

if [ "$FRONTEND" = "react" ]; then
    cat > ""$PROJECT_DIR/commands/orchestrator.md"" << 'ORCHEOF'
# /orchestrator - Executar Pipeline SDD

> Execute os agentes automaticamente para gerar código baseado em sua especificação.

## 📋 Como Usar

1. **Prepare sua especificação**
   - Edite `docs/SPEC.md` com seus requisitos

2. **Chame o orchestrador**
   ```
   /orchestrator
   ```

3. **Aguarde ~20-30 minutos**
   - Os agentes executam em cascata
   - Resultados salvos em `output/`

## 🎯 O que Acontece

```
docs/SPEC.md
    ↓
🎯 Orchestrator     → Valida especificação
    ↓
🏛️ Architect        → Gera arquitetura
    ↓
🔷 .NET Specialist  → Implementa código .NET backend
    ⚛️ react-specialist     → Implementa código React 18
    ↓
📋 Compliance       → Valida conformidade
    ↓
🧪 Test Validator   → Gera testes
    ↓
🔍 Code Review      → Revisa qualidade
    ↓
🏗️ Build & Test     → Valida build
    ↓
📝 Commit Message   → Gera commits semânticos
    ↓
🧪 Swagger Tester   → Testa API
    ↓
✅ output/ Pronto!
```

## 📁 Resultados

Após execução, em `output/`:

```
1-orchestrator.md            (Validação)
2-architect.md                (Arquitetura)
3-dotnet-specialist.md        (Código .NET)
3-react-specialist.md          (Código React 18)
4-compliance.md               (Conformidade)
5-test-validator.md           (Testes)
6-code-review.md              (Code Review)
7-build-test.md                (Build & Test)
8-commit-message.md           (Commits)
9-swagger-tester.md           (Swagger)
state.json                    (Estado)
```

## ✅ Pré-requisitos

- ✅ `docs/SPEC.md` preenchida
- ✅ Conexão com internet

## 🚀 Comece Agora

```
/orchestrator
```
ORCHEOF

elif [ "$FRONTEND" = "angular" ]; then
    cat > ""$PROJECT_DIR/commands/orchestrator.md"" << 'ORCHEOF'
# /orchestrator - Executar Pipeline SDD

> Execute os agentes automaticamente para gerar código baseado em sua especificação.

## 📋 Como Usar

1. **Prepare sua especificação**
   - Edite `docs/SPEC.md` com seus requisitos

2. **Chame o orchestrador**
   ```
   /orchestrator
   ```

3. **Aguarde ~20-30 minutos**
   - Os agentes executam em cascata
   - Resultados salvos em `output/`

## 🎯 O que Acontece

```
docs/SPEC.md
    ↓
🎯 Orchestrator     → Valida especificação
    ↓
🏛️ Architect        → Gera arquitetura
    ↓
🔷 .NET Specialist  → Implementa código .NET backend
    🅰️ angular-specialist     → Implementa código Angular
    ↓
📋 Compliance       → Valida conformidade
    ↓
🧪 Test Validator   → Gera testes
    ↓
🔍 Code Review      → Revisa qualidade
    ↓
🏗️ Build & Test     → Valida build
    ↓
📝 Commit Message   → Gera commits semânticos
    ↓
🧪 Swagger Tester   → Testa API
    ↓
✅ output/ Pronto!
```

## 📁 Resultados

Após execução, em `output/`:

```
1-orchestrator.md            (Validação)
2-architect.md                (Arquitetura)
3-dotnet-specialist.md        (Código .NET)
3-angular-specialist.md          (Código Angular)
4-compliance.md               (Conformidade)
5-test-validator.md           (Testes)
6-code-review.md              (Code Review)
7-build-test.md                (Build & Test)
8-commit-message.md           (Commits)
9-swagger-tester.md           (Swagger)
state.json                    (Estado)
```

## ✅ Pré-requisitos

- ✅ `docs/SPEC.md` preenchida
- ✅ Conexão com internet

## 🚀 Comece Agora

```
/orchestrator
```
ORCHEOF

elif [ "$FRONTEND" = "vue" ]; then
    cat > ""$PROJECT_DIR/commands/orchestrator.md"" << 'ORCHEOF'
# /orchestrator - Executar Pipeline SDD

> Execute os agentes automaticamente para gerar código baseado em sua especificação.

## 📋 Como Usar

1. **Prepare sua especificação**
   - Edite `docs/SPEC.md` com seus requisitos

2. **Chame o orchestrador**
   ```
   /orchestrator
   ```

3. **Aguarde ~20-30 minutos**
   - Os agentes executam em cascata
   - Resultados salvos em `output/`

## 🎯 O que Acontece

```
docs/SPEC.md
    ↓
🎯 Orchestrator     → Valida especificação
    ↓
🏛️ Architect        → Gera arquitetura
    ↓
🔷 .NET Specialist  → Implementa código .NET backend
    💚 vue-specialist     → Implementa código Vue 3
    ↓
📋 Compliance       → Valida conformidade
    ↓
🧪 Test Validator   → Gera testes
    ↓
🔍 Code Review      → Revisa qualidade
    ↓
🏗️ Build & Test     → Valida build
    ↓
📝 Commit Message   → Gera commits semânticos
    ↓
🧪 Swagger Tester   → Testa API
    ↓
✅ output/ Pronto!
```

## 📁 Resultados

Após execução, em `output/`:

```
1-orchestrator.md            (Validação)
2-architect.md                (Arquitetura)
3-dotnet-specialist.md        (Código .NET)
3-vue-specialist.md          (Código Vue 3)
4-compliance.md               (Conformidade)
5-test-validator.md           (Testes)
6-code-review.md              (Code Review)
7-build-test.md                (Build & Test)
8-commit-message.md           (Commits)
9-swagger-tester.md           (Swagger)
state.json                    (Estado)
```

## ✅ Pré-requisitos

- ✅ `docs/SPEC.md` preenchida
- ✅ Conexão com internet

## 🚀 Comece Agora

```
/orchestrator
```
ORCHEOF

elif [ "$FRONTEND" = "none" ]; then
    cat > ""$PROJECT_DIR/commands/orchestrator.md"" << 'ORCHEOF'
# /orchestrator - Executar Pipeline SDD

> Execute os agentes automaticamente para gerar código baseado em sua especificação.

## 📋 Como Usar

1. **Prepare sua especificação**
   - Edite `docs/SPEC.md` com seus requisitos

2. **Chame o orchestrador**
   ```
   /orchestrator
   ```

3. **Aguarde ~20-30 minutos**
   - Os agentes executam em cascata
   - Resultados salvos em `output/`

## 🎯 O que Acontece

```
docs/SPEC.md
    ↓
🎯 Orchestrator     → Valida especificação
    ↓
🏛️ Architect        → Gera arquitetura
    ↓
🔷 .NET Specialist  → Implementa código .NET
    ↓
📋 Compliance       → Valida conformidade
    ↓
🧪 Test Validator   → Gera testes
    ↓
🔍 Code Review      → Revisa qualidade
    ↓
🏗️ Build & Test     → Valida build
    ↓
📝 Commit Message   → Gera commits semânticos
    ↓
🧪 Swagger Tester   → Testa API
    ↓
✅ output/ Pronto!
```

## 📁 Resultados

Após execução, em `output/`:

```
1-orchestrator.md            (Validação)
2-architect.md                (Arquitetura)
3-dotnet-specialist.md        (Código .NET)
4-compliance.md               (Conformidade)
5-test-validator.md           (Testes)
6-code-review.md              (Code Review)
7-build-test.md                (Build & Test)
8-commit-message.md           (Commits)
9-swagger-tester.md           (Swagger)
state.json                    (Estado)
```

## ✅ Pré-requisitos

- ✅ `docs/SPEC.md` preenchida
- ✅ Conexão com internet

## 🚀 Comece Agora

```
/orchestrator
```
ORCHEOF

fi
echo -e "${GREEN}✅ commands/orchestrator.md criado${NC}"

# ============================================================================
# CRIAR commands/README.md — conteúdo específico por stack
# ============================================================================

if [ "$FRONTEND" = "react" ]; then
    cat > ""$PROJECT_DIR/commands/README.md"" << 'CMDREADMEEOF'
# 📌 Comandos do Pipeline SDD

Stack deste projeto: **.NET 8 + React 18**

## 🎯 Fluxo Recomendado

1. **Edite sua especificação**
   ```
   nano docs/SPEC.md
   ```

2. **Execute o orchestrador**
   ```
   /orchestrator
   ```

3. **Pronto!** Os subagentes (pasta `agents/`) rodam automaticamente em cascata

## 📚 Estrutura

- **`commands/`** — Comandos que você chama diretamente (`/orchestrator`)
- **`agents/`** — Os subagentes especializados que o `/orchestrator` invoca automaticamente. Você não precisa chamá-los manualmente, mas ficam aqui documentados caso precise entender ou ajustar o comportamento de um deles no futuro.

## 🤖 Os Agentes (em `agents/`)

| # | Agente | Responsabilidade |
|---|--------|-------------------|
| 1 | `orchestrator-sdd` | Valida a especificação |
| 2 | `architect-sdd` | Gera arquitetura técnica |
| 3 | `dotnet-specialist` | Implementa backend .NET |
| 3 | `react-specialist` | Implementa frontend React 18 |
| 4 | `compliance-validator` | Valida conformidade com a spec |
| 5 | `test-validator` | Gera testes automatizados |
| 6 | `code-review-sdd` | Revisa qualidade do código |
| 7 | `build-test-validator` | Valida build e testes |
| 8 | `commit-message-generator` | Gera commits semânticos |
| 9 | `swagger-tester` | Gera workflow de testes de API |

## ⏱️ Tempo

- Pipeline completo (`/orchestrator`): 20-30 minutos

## 💡 Dicas

1. Use `/orchestrator` para rodar o pipeline completo
2. Revise resultados em `output/` a cada etapa
3. Se precisar reexecutar só uma etapa específica, você pode pedir ao Claude para usar aquele agente novamente pelo nome

---

**Comece aqui:** `/orchestrator`
CMDREADMEEOF

elif [ "$FRONTEND" = "angular" ]; then
    cat > ""$PROJECT_DIR/commands/README.md"" << 'CMDREADMEEOF'
# 📌 Comandos do Pipeline SDD

Stack deste projeto: **.NET 8 + Angular**

## 🎯 Fluxo Recomendado

1. **Edite sua especificação**
   ```
   nano docs/SPEC.md
   ```

2. **Execute o orchestrador**
   ```
   /orchestrator
   ```

3. **Pronto!** Os subagentes (pasta `agents/`) rodam automaticamente em cascata

## 📚 Estrutura

- **`commands/`** — Comandos que você chama diretamente (`/orchestrator`)
- **`agents/`** — Os subagentes especializados que o `/orchestrator` invoca automaticamente. Você não precisa chamá-los manualmente, mas ficam aqui documentados caso precise entender ou ajustar o comportamento de um deles no futuro.

## 🤖 Os Agentes (em `agents/`)

| # | Agente | Responsabilidade |
|---|--------|-------------------|
| 1 | `orchestrator-sdd` | Valida a especificação |
| 2 | `architect-sdd` | Gera arquitetura técnica |
| 3 | `dotnet-specialist` | Implementa backend .NET |
| 3 | `angular-specialist` | Implementa frontend Angular |
| 4 | `compliance-validator` | Valida conformidade com a spec |
| 5 | `test-validator` | Gera testes automatizados |
| 6 | `code-review-sdd` | Revisa qualidade do código |
| 7 | `build-test-validator` | Valida build e testes |
| 8 | `commit-message-generator` | Gera commits semânticos |
| 9 | `swagger-tester` | Gera workflow de testes de API |

## ⏱️ Tempo

- Pipeline completo (`/orchestrator`): 20-30 minutos

## 💡 Dicas

1. Use `/orchestrator` para rodar o pipeline completo
2. Revise resultados em `output/` a cada etapa
3. Se precisar reexecutar só uma etapa específica, você pode pedir ao Claude para usar aquele agente novamente pelo nome

---

**Comece aqui:** `/orchestrator`
CMDREADMEEOF

elif [ "$FRONTEND" = "vue" ]; then
    cat > ""$PROJECT_DIR/commands/README.md"" << 'CMDREADMEEOF'
# 📌 Comandos do Pipeline SDD

Stack deste projeto: **.NET 8 + Vue 3**

## 🎯 Fluxo Recomendado

1. **Edite sua especificação**
   ```
   nano docs/SPEC.md
   ```

2. **Execute o orchestrador**
   ```
   /orchestrator
   ```

3. **Pronto!** Os subagentes (pasta `agents/`) rodam automaticamente em cascata

## 📚 Estrutura

- **`commands/`** — Comandos que você chama diretamente (`/orchestrator`)
- **`agents/`** — Os subagentes especializados que o `/orchestrator` invoca automaticamente. Você não precisa chamá-los manualmente, mas ficam aqui documentados caso precise entender ou ajustar o comportamento de um deles no futuro.

## 🤖 Os Agentes (em `agents/`)

| # | Agente | Responsabilidade |
|---|--------|-------------------|
| 1 | `orchestrator-sdd` | Valida a especificação |
| 2 | `architect-sdd` | Gera arquitetura técnica |
| 3 | `dotnet-specialist` | Implementa backend .NET |
| 3 | `vue-specialist` | Implementa frontend Vue 3 |
| 4 | `compliance-validator` | Valida conformidade com a spec |
| 5 | `test-validator` | Gera testes automatizados |
| 6 | `code-review-sdd` | Revisa qualidade do código |
| 7 | `build-test-validator` | Valida build e testes |
| 8 | `commit-message-generator` | Gera commits semânticos |
| 9 | `swagger-tester` | Gera workflow de testes de API |

## ⏱️ Tempo

- Pipeline completo (`/orchestrator`): 20-30 minutos

## 💡 Dicas

1. Use `/orchestrator` para rodar o pipeline completo
2. Revise resultados em `output/` a cada etapa
3. Se precisar reexecutar só uma etapa específica, você pode pedir ao Claude para usar aquele agente novamente pelo nome

---

**Comece aqui:** `/orchestrator`
CMDREADMEEOF

elif [ "$FRONTEND" = "none" ]; then
    cat > ""$PROJECT_DIR/commands/README.md"" << 'CMDREADMEEOF'
# 📌 Comandos do Pipeline SDD

Stack deste projeto: **.NET 8 (somente backend)**

## 🎯 Fluxo Recomendado

1. **Edite sua especificação**
   ```
   nano docs/SPEC.md
   ```

2. **Execute o orchestrador**
   ```
   /orchestrator
   ```

3. **Pronto!** Os subagentes (pasta `agents/`) rodam automaticamente em cascata

## 📚 Estrutura

- **`commands/`** — Comandos que você chama diretamente (`/orchestrator`)
- **`agents/`** — Os subagentes especializados que o `/orchestrator` invoca automaticamente. Você não precisa chamá-los manualmente, mas ficam aqui documentados caso precise entender ou ajustar o comportamento de um deles no futuro.

## 🤖 Os Agentes (em `agents/`)

| # | Agente | Responsabilidade |
|---|--------|-------------------|
| 1 | `orchestrator-sdd` | Valida a especificação |
| 2 | `architect-sdd` | Gera arquitetura técnica |
| 3 | `dotnet-specialist` | Implementa backend .NET |
| 4 | `compliance-validator` | Valida conformidade com a spec |
| 5 | `test-validator` | Gera testes automatizados |
| 6 | `code-review-sdd` | Revisa qualidade do código |
| 7 | `build-test-validator` | Valida build e testes |
| 8 | `commit-message-generator` | Gera commits semânticos |
| 9 | `swagger-tester` | Gera workflow de testes de API |

## ⏱️ Tempo

- Pipeline completo (`/orchestrator`): 20-30 minutos

## 💡 Dicas

1. Use `/orchestrator` para rodar o pipeline completo
2. Revise resultados em `output/` a cada etapa
3. Se precisar reexecutar só uma etapa específica, você pode pedir ao Claude para usar aquele agente novamente pelo nome

---

**Comece aqui:** `/orchestrator`
CMDREADMEEOF

fi
echo -e "${GREEN}✅ commands/README.md criado${NC}"

# ============================================================================
# CRIAR docs/SPEC.md — stack sugerida reflete a escolha
# ============================================================================

if [ "$FRONTEND" = "react" ]; then
    cat > ""$PROJECT_DIR/docs/SPEC.md"" << 'SPECEOF'
# Sua Aplicação - Especificação

## 📋 Visão Geral

Descreva brevemente sua aplicação aqui.

**Stack:** .NET 8 + React 18

---

## 🎯 Requisitos Funcionais

### REQ-001: [Descrição do Requisito]
- Sub-requisito 1
- Sub-requisito 2
- Sub-requisito 3

### REQ-002: [Descrição do Requisito]
- Sub-requisito 1
- Sub-requisito 2

---

## 🏗️ Regras de Negócio

### BR-001: [Regra de Negócio]
Descrição detalhada da regra.

### BR-002: [Regra de Negócio]
Descrição detalhada da regra.

---

## 🗄️ Modelo de Dados

### Entidade 1
- Id (UUID)
- Nome (string, required)
- Descricao (string, nullable)
- DataCriacao (DateTime)
- Ativo (bool)

### Entidade 2
- Id (UUID)
- EntidadeId (FK)
- Status (enum: Ativo, Inativo)
- DataAtualizacao (DateTime)

---

## 📡 Endpoints Principais

### Listar
- `GET /api/recursos` - Listar com paginação

### Criar
- `POST /api/recursos` - Criar novo

### Detalhes
- `GET /api/recursos/{id}` - Obter um

### Atualizar
- `PUT /api/recursos/{id}` - Atualizar

### Deletar
- `DELETE /api/recursos/{id}` - Deletar

---

## 🧪 Testes

Cobertura mínima: 80% da Application Layer

- [ ] Testes unitários
- [ ] Testes de integração
- [ ] Testes E2E

---

## 🔒 Segurança

- [ ] Autenticação JWT
- [ ] Validação de entrada
- [ ] Rate limiting
- [ ] HTTPS em produção

---

## ✅ Critérios de Aceitar

- [ ] Todos os endpoints funcionando
- [ ] Validações funcionando
- [ ] Testes com 80%+ cobertura
- [ ] Código segue SOLID
- [ ] Sem vulnerabilidades críticas

---

**Pronto para orquestração!** 🚀

Edite este arquivo e chame:
```
/orchestrator
```
SPECEOF

elif [ "$FRONTEND" = "angular" ]; then
    cat > ""$PROJECT_DIR/docs/SPEC.md"" << 'SPECEOF'
# Sua Aplicação - Especificação

## 📋 Visão Geral

Descreva brevemente sua aplicação aqui.

**Stack:** .NET 8 + Angular

---

## 🎯 Requisitos Funcionais

### REQ-001: [Descrição do Requisito]
- Sub-requisito 1
- Sub-requisito 2
- Sub-requisito 3

### REQ-002: [Descrição do Requisito]
- Sub-requisito 1
- Sub-requisito 2

---

## 🏗️ Regras de Negócio

### BR-001: [Regra de Negócio]
Descrição detalhada da regra.

### BR-002: [Regra de Negócio]
Descrição detalhada da regra.

---

## 🗄️ Modelo de Dados

### Entidade 1
- Id (UUID)
- Nome (string, required)
- Descricao (string, nullable)
- DataCriacao (DateTime)
- Ativo (bool)

### Entidade 2
- Id (UUID)
- EntidadeId (FK)
- Status (enum: Ativo, Inativo)
- DataAtualizacao (DateTime)

---

## 📡 Endpoints Principais

### Listar
- `GET /api/recursos` - Listar com paginação

### Criar
- `POST /api/recursos` - Criar novo

### Detalhes
- `GET /api/recursos/{id}` - Obter um

### Atualizar
- `PUT /api/recursos/{id}` - Atualizar

### Deletar
- `DELETE /api/recursos/{id}` - Deletar

---

## 🧪 Testes

Cobertura mínima: 80% da Application Layer

- [ ] Testes unitários
- [ ] Testes de integração
- [ ] Testes E2E

---

## 🔒 Segurança

- [ ] Autenticação JWT
- [ ] Validação de entrada
- [ ] Rate limiting
- [ ] HTTPS em produção

---

## ✅ Critérios de Aceitar

- [ ] Todos os endpoints funcionando
- [ ] Validações funcionando
- [ ] Testes com 80%+ cobertura
- [ ] Código segue SOLID
- [ ] Sem vulnerabilidades críticas

---

**Pronto para orquestração!** 🚀

Edite este arquivo e chame:
```
/orchestrator
```
SPECEOF

elif [ "$FRONTEND" = "vue" ]; then
    cat > ""$PROJECT_DIR/docs/SPEC.md"" << 'SPECEOF'
# Sua Aplicação - Especificação

## 📋 Visão Geral

Descreva brevemente sua aplicação aqui.

**Stack:** .NET 8 + Vue 3

---

## 🎯 Requisitos Funcionais

### REQ-001: [Descrição do Requisito]
- Sub-requisito 1
- Sub-requisito 2
- Sub-requisito 3

### REQ-002: [Descrição do Requisito]
- Sub-requisito 1
- Sub-requisito 2

---

## 🏗️ Regras de Negócio

### BR-001: [Regra de Negócio]
Descrição detalhada da regra.

### BR-002: [Regra de Negócio]
Descrição detalhada da regra.

---

## 🗄️ Modelo de Dados

### Entidade 1
- Id (UUID)
- Nome (string, required)
- Descricao (string, nullable)
- DataCriacao (DateTime)
- Ativo (bool)

### Entidade 2
- Id (UUID)
- EntidadeId (FK)
- Status (enum: Ativo, Inativo)
- DataAtualizacao (DateTime)

---

## 📡 Endpoints Principais

### Listar
- `GET /api/recursos` - Listar com paginação

### Criar
- `POST /api/recursos` - Criar novo

### Detalhes
- `GET /api/recursos/{id}` - Obter um

### Atualizar
- `PUT /api/recursos/{id}` - Atualizar

### Deletar
- `DELETE /api/recursos/{id}` - Deletar

---

## 🧪 Testes

Cobertura mínima: 80% da Application Layer

- [ ] Testes unitários
- [ ] Testes de integração
- [ ] Testes E2E

---

## 🔒 Segurança

- [ ] Autenticação JWT
- [ ] Validação de entrada
- [ ] Rate limiting
- [ ] HTTPS em produção

---

## ✅ Critérios de Aceitar

- [ ] Todos os endpoints funcionando
- [ ] Validações funcionando
- [ ] Testes com 80%+ cobertura
- [ ] Código segue SOLID
- [ ] Sem vulnerabilidades críticas

---

**Pronto para orquestração!** 🚀

Edite este arquivo e chame:
```
/orchestrator
```
SPECEOF

elif [ "$FRONTEND" = "none" ]; then
    cat > ""$PROJECT_DIR/docs/SPEC.md"" << 'SPECEOF'
# Sua Aplicação - Especificação

## 📋 Visão Geral

Descreva brevemente sua aplicação aqui.

**Stack:** .NET 8 (somente backend)

---

## 🎯 Requisitos Funcionais

### REQ-001: [Descrição do Requisito]
- Sub-requisito 1
- Sub-requisito 2
- Sub-requisito 3

### REQ-002: [Descrição do Requisito]
- Sub-requisito 1
- Sub-requisito 2

---

## 🏗️ Regras de Negócio

### BR-001: [Regra de Negócio]
Descrição detalhada da regra.

### BR-002: [Regra de Negócio]
Descrição detalhada da regra.

---

## 🗄️ Modelo de Dados

### Entidade 1
- Id (UUID)
- Nome (string, required)
- Descricao (string, nullable)
- DataCriacao (DateTime)
- Ativo (bool)

### Entidade 2
- Id (UUID)
- EntidadeId (FK)
- Status (enum: Ativo, Inativo)
- DataAtualizacao (DateTime)

---

## 📡 Endpoints Principais

### Listar
- `GET /api/recursos` - Listar com paginação

### Criar
- `POST /api/recursos` - Criar novo

### Detalhes
- `GET /api/recursos/{id}` - Obter um

### Atualizar
- `PUT /api/recursos/{id}` - Atualizar

### Deletar
- `DELETE /api/recursos/{id}` - Deletar

---

## 🧪 Testes

Cobertura mínima: 80% da Application Layer

- [ ] Testes unitários
- [ ] Testes de integração
- [ ] Testes E2E

---

## 🔒 Segurança

- [ ] Autenticação JWT
- [ ] Validação de entrada
- [ ] Rate limiting
- [ ] HTTPS em produção

---

## ✅ Critérios de Aceitar

- [ ] Todos os endpoints funcionando
- [ ] Validações funcionando
- [ ] Testes com 80%+ cobertura
- [ ] Código segue SOLID
- [ ] Sem vulnerabilidades críticas

---

**Pronto para orquestração!** 🚀

Edite este arquivo e chame:
```
/orchestrator
```
SPECEOF

fi
echo -e "${GREEN}✅ docs/SPEC.md criado${NC}"

# ============================================================================
# CRIAR README.md e COMECE-AQUI.md
# ============================================================================

cat > "$PROJECT_DIR/README.md" << READMEEOF
# Seu Projeto SDD

Projeto criado com **Pipeline SDD** — Stack: $STACK_LABEL

## 🚀 Quick Start

### 1. Edite a Especificação
\`\`\`bash
nano docs/SPEC.md
\`\`\`

### 2. Execute o Orchestrador
\`\`\`
/orchestrator
\`\`\`

### 3. Pronto!
Código gerado em \`output/\` em ~20-30 minutos.

## 📁 Estrutura

\`\`\`
seu-projeto/
├── commands/          📌 COMANDOS DO PIPELINE
│   ├── orchestrator.md (comece por aqui!)
│   └── README.md
│
├── docs/
│   └── SPEC.md       (sua especificação)
│
├── output/           (resultados)
│
└── src/              (.NET Clean Architecture)
    ├── Domain/
    ├── Application/
    ├── Infrastructure/
    ├── API/
    └── Tests/
\`\`\`

## 🚀 Comece Agora

\`\`\`
/orchestrator
\`\`\`

---

**Projeto criado com Claude SDD v2.0**
READMEEOF

echo -e "${GREEN}✅ README.md criado${NC}"

cat > "$PROJECT_DIR/COMECE-AQUI.md" << COMECEEOF
# 🚀 Comece Aqui

Bem-vindo ao seu projeto SDD! Stack: $STACK_LABEL

## ⚡ 2 Passos Simples

### 1️⃣ Edite a Especificação

Abra \`docs/SPEC.md\` e descreva sua aplicação:
- Requisitos funcionais
- Regras de negócio
- Modelo de dados
- Endpoints

### 2️⃣ Execute o Orchestrador

No Claude Code, chame:

\`\`\`
/orchestrator
\`\`\`

Aguarde ~20-30 minutos enquanto os agentes trabalham em cascata.

## 📁 Depois de Executar

Você terá em \`output/\` a arquitetura, código, testes, code review,
relatório de build, commits sugeridos e workflow de testes de API.

---

**Pronto para começar?**

\`\`\`
/orchestrator
\`\`\`
COMECEEOF

echo -e "${GREEN}✅ COMECE-AQUI.md criado${NC}"

# ============================================================================
# CRIAR .gitignore
# ============================================================================

cat > "$PROJECT_DIR/.gitignore" << 'GITIGNOREEOF'
# .NET
bin/
obj/
*.dll
*.exe
.vs/
.vscode/
*.csproj.user
*.sln.user

# Frontend
node_modules/
dist/

# Output do Pipeline
output/

# IDE
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
*.log

# Ambiente
.env
.env.local
GITIGNOREEOF

echo -e "${GREEN}✅ .gitignore criado${NC}"

# ============================================================================
# RESUMO FINAL
# ============================================================================

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}✅ PROJETO CRIADO COM SUCESSO!${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📁 Pasta criada:${NC} $PROJECT_DIR"
echo -e "${BLUE}🧱 Stack:${NC} $STACK_LABEL"
echo ""
echo -e "${YELLOW}Próximos passos:${NC}"
echo ""
echo "  1️⃣  Entrar na pasta"
echo "     cd $PROJECT_NAME"
echo ""
echo "  2️⃣  Editar especificação"
echo "     nano docs/SPEC.md"
echo ""
echo "  3️⃣  Executar orchestrador (no Claude Code)"
echo "     /orchestrator"
echo ""
echo -e "${GREEN}Tudo pronto!${NC} 🚀"
echo ""
echo -e "${BLUE}Comandos disponíveis em:${NC} commands/"
echo -e "${BLUE}Subagentes disponíveis em:${NC} agents/"
echo ""
