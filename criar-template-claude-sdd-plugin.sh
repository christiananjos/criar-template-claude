#!/bin/bash

# ============================================================================
# 🚀 Criar Template Claude SDD - Plugin v2.0
# ============================================================================
# Integração completa do pipeline SDD com 9 agentes
# 
# Uso:
#   bash criar-template-claude-sdd-plugin.sh meu-projeto
#   ou
#   /plugin install criar-template-claude@sdd-v2
#   criar-template-claude-sdd my-project
#
# Stack: Next.js + .NET | React + Clean Architecture | SDD
# ============================================================================

set -e

PROJECT_NAME="${1:-projeto-sdd}"
PROJECT_PATH="./$PROJECT_NAME"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}🚀 Criar Template Claude SDD v2.0${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "📁 Projeto: ${YELLOW}$PROJECT_PATH${NC}"
echo -e "🔄 Pipeline: ${YELLOW}9 Agentes SDD${NC}"
echo -e "⚙️  Stack: ${YELLOW}Next.js + .NET/React + Clean Architecture${NC}"
echo ""

# ============================================================================
# 1. CRIAR ESTRUTURA DE PASTAS
# ============================================================================
echo -e "${BLUE}[1/9]${NC} Criando estrutura de pastas..."

mkdir -p "$PROJECT_PATH"/{.claude,archive,memory,shared,templates}
mkdir -p "$PROJECT_PATH"/{src/{Domain,Application,Infrastructure,API,Tests}}
mkdir -p "$PROJECT_PATH"/pipeline/{agents,specs,reports,tasks}
mkdir -p "$PROJECT_PATH"/docs/{architecture,guides,decisions,adr}

# Criar subpastas para cada agente
mkdir -p "$PROJECT_PATH"/pipeline/agents/{1-orchestrator,2-architect,3-dotnet-specialist,3-react-specialist,4-compliance,5-tests,6-review,7-build,8-commit,9-swagger}

echo -e "${GREEN}✅ Pastas criadas${NC}"

# ============================================================================
# 2. ARQUIVOS RAIZ
# ============================================================================
echo -e "${BLUE}[2/9]${NC} Criando arquivos raiz..."

cat > "$PROJECT_PATH/README.md" << 'EOF'
# 🚀 Seu Projeto SDD

> Desenvolvimento Orientado por Especificação (Spec-Driven Development)  
> Pipeline Multi-Agente com Clean Architecture

## 📊 Pipeline SDD

```
[1] 🎯 Orchestrator-SDD
    ↓ (recebe spec bruta)
[2] 🏛️ Arquiteto SDD
    ↓ (gera TECHNICAL_SPECIFICATION.md)
[3] 🔷 .NET Specialist / ⚛️ React Specialist
    ↓ (implementa código)
[4] 📋 SDD Compliance
    ↓ (valida conformidade)
[5] 🧪 Test Validator
    ↓ (100% cobertura)
[6] 🔍 Code Review
    ↓ (valida arquitetura)
[7] 🏗️ Build & Test
    ↓ (build + testes)
[8] 📝 Commit Message
    ↓ (commits semânticos)
[9] 🧪 Swagger Tester (opcional)
```

## 🎯 Quick Start

```bash
# 1. Instale dependências
npm install

# 2. Configure ambiente
cp .env.example .env.local

# 3. Leia o guia completo
cat COMECE-AQUI.md

# 4. Inicie o pipeline com o Orchestrator-SDD
# (veja pipeline/agents/1-orchestrator/README.md)
```

## 📁 Estrutura

### Clean Architecture
```
src/
├── Domain/              # Lógica de negócio pura
├── Application/         # Use cases, DTOs, Handlers
├── Infrastructure/      # Banco, APIs externas
├── API/                 # Controladores, Rotas
└── Tests/              # Testes unitários/integração
```

### Pipeline SDD
```
pipeline/
├── agents/             # Prompts dos 9 agentes
├── specs/              # Especificações técnicas
├── reports/            # Relatórios (compliance, coverage, review)
└── tasks/              # Subtarefas decompostas
```

## 📚 Documentação

- **[COMECE-AQUI.md](./COMECE-AQUI.md)** - Guia inicial rápido
- **[PIPELINE-SDD.md](./PIPELINE-SDD.md)** - Explicação completa do pipeline
- **[pipeline/agents/](./pipeline/agents/)** - Prompts dos agentes
- **[docs/guides/](./docs/guides/)** - Guias de desenvolvimento

## 🏗️ Arquitetura

Baseado em **Clean Architecture** (Robert C. Martin)

- **Independência de Frameworks**: A lógica central não depende de Next.js, .NET, etc.
- **Testável**: Testes sem conhecer detalhes de implementação
- **Flexível**: Fácil trocar banco, API, UI
- **Escalável**: Adicionar features sem quebrar o existente

## 🔄 Fluxo de Desenvolvimento

1. **Spec** → Escreva a especificação de requisitos
2. **Arquitetura** → Architect-SDD decompõe em tarefas
3. **Implementação** → Specialist implementa baseado em tarefas
4. **Validação** → 5 camadas de validação (compliance, testes, review, build)
5. **Deploy** → Commits semânticos prontos para produção

## ✨ Destaques

✅ **100% Spec-Driven** - Código segue a especificação  
✅ **Multi-Agente** - 9 agentes especializados  
✅ **Clean Architecture** - Código escalável e testável  
✅ **100% Test Coverage** - Application Layer completamente testada  
✅ **Padrões SOLID** - Código profissional desde o início  
✅ **Tipo-Safe** - TypeScript + .NET Strong Typing  

## 📖 Stack Recomendado

### Frontend
- Next.js 14+
- React 18+
- TypeScript
- Tailwind CSS
- Vitest / Playwright

### Backend (.NET)
- .NET 8+
- Clean Architecture
- Entity Framework Core
- xUnit / NSubstitute
- FluentValidation

### Banco de Dados
- PostgreSQL (recomendado)
- MongoDB (alternativa)

---

**Desenvolvido com** ❤️ **usando Spec-Driven Development**
EOF

cat > "$PROJECT_PATH/COMECE-AQUI.md" << 'EOF'
# 🚀 Comece Aqui

Bem-vindo ao projeto SDD! Este guia vai te colocar em funcionamento em 5 minutos.

## ✅ Pré-requisitos

```bash
node --version    # v18+
npm --version     # v9+
git --version     # 2.30+
```

## 📋 5 Passos Essenciais

### 1️⃣ Instale Dependências

```bash
npm install
```

Se for usar .NET também:
```bash
dotnet new sln -n SeuProjeto
dotnet new classlib -n SeuProjeto.Domain -o src/Domain
# (continuar conforme necessário)
```

### 2️⃣ Configure Variáveis de Ambiente

```bash
cp .env.example .env.local
# Edite .env.local com seus valores (banco, JWT, etc)
```

### 3️⃣ Leia a Documentação

**Na ordem:**
1. Este arquivo (COMECE-AQUI.md) ← Você está aqui
2. [PIPELINE-SDD.md](./PIPELINE-SDD.md) - Pipeline completo
3. [pipeline/agents/1-orchestrator/README.md](./pipeline/agents/1-orchestrator/README.md)

### 4️⃣ Prepare sua Especificação

Crie um documento com:
- ✅ Requisitos funcionais (ao menos 5)
- ✅ Regras de negócio (3-5 BR-XXX)
- ✅ Entidades de domínio
- ✅ Casos de uso principais
- ✅ Integrações externas (se houver)

**Exemplo mínimo:**
```markdown
# Sistema de Cadastro de Usuários

## Requisitos Funcionais
- REQ-001: Usuário pode se registrar com email/senha
- REQ-002: Usuário recebe email de confirmação
- REQ-003: Usuário pode fazer login
- REQ-004: Admin pode listar usuários
- REQ-005: Admin pode desativar usuário

## Regras de Negócio
- BR-001: Senha deve ter mínimo 8 caracteres
- BR-002: Email deve ser único
- BR-003: Usuário desativado não pode fazer login

## Entidades
- User (id, email, password, status, createdAt)
```

### 5️⃣ Execute o Pipeline

**Etapa 1: Orchestrator-SDD**

```bash
# 1. Copie o prompt do Orchestrator
cat pipeline/agents/1-orchestrator/SYSTEM_PROMPT.md

# 2. Cole no seu Custom GPT de Orchestrator-SDD
# (ou use Claude, ChatGPT, Gemini - qualquer modelo)

# 3. Passe sua especificação completa

# 4. O agente vai rotear para o Architect-SDD
# Siga as instruções que ele der
```

## 🎯 O Que Vai Acontecer

Após executar o pipeline completo:

```
Sua Spec
    ↓
[Architect-SDD]
    ↓ Gera: TECHNICAL_SPECIFICATION.md
         TRACEABILITY_MATRIX.md
         TECHNICAL_DECISIONS.md
         TASK_REGISTRY.md + TASK-001/, TASK-002/, etc
    ↓
[Specialist]
    ↓ Implementa: src/Domain/, src/Application/, etc.
    ↓ Com 100% de testes
    ↓
[Validação - 5 etapas]
    ↓ Compliance, Testes, Review, Build, Commit
    ↓
[Commits Semânticos]
    ↓
✅ Pronto para deploy!
```

**Tempo esperado**: 2-4 horas (complexidade média)

## 📁 Estrutura Rápida

```
seu-projeto/
├── README.md                      # Você está aqui
├── COMECE-AQUI.md                 # (guia inicial)
├── PIPELINE-SDD.md                # (guia pipeline)
├── .env.example                   # (variáveis)
│
├── src/                           # Clean Architecture
│   ├── Domain/                    # Regras de negócio
│   ├── Application/               # Casos de uso
│   ├── Infrastructure/            # Banco, APIs
│   ├── API/                       # Controllers
│   └── Tests/                     # Testes
│
├── pipeline/                      # SDD Pipeline
│   ├── agents/1-9/                # Prompts dos agentes
│   ├── specs/                     # Especificações geradas
│   ├── tasks/TASK-NNN/            # Tarefas decompostas
│   └── reports/                   # Relatórios
│
└── docs/
    ├── guides/                    # Guias de dev
    ├── architecture/              # Diagramas
    └── adr/                       # Decisões arquiteturais
```

## 🔗 Links Importantes

| Link | O que é | Quando usar |
|------|---------|------------|
| [PIPELINE-SDD.md](./PIPELINE-SDD.md) | Explicação completa | Antes de começar |
| [pipeline/agents/1-orchestrator/](./pipeline/agents/1-orchestrator/) | Agente 1 | Quando tem spec pronta |
| [pipeline/agents/2-architect/](./pipeline/agents/2-architect/) | Agente 2 | Após Orchestrator rotear |
| [docs/guides/](./docs/guides/) | Guias de desenvolvimento | Durante dev |
| [docs/architecture/](./docs/architecture/) | Arquitetura do projeto | Para entender design |

## ❓ Dúvidas Comuns

### "Por onde começo?"
→ Leia PIPELINE-SDD.md depois volte aqui

### "Como uso o Orchestrator-SDD?"
→ Ver pipeline/agents/1-orchestrator/README.md

### "Qual é a estrutura de pastas?"
→ Ver README.md acima ou `tree` no terminal

### "Preciso de .NET e React?"
→ Não, escolha um (ou customize)

### "Quanto tempo vai levar?"
→ Spec completa → Código pronto: 2-4 horas (média)

## ✨ Pro Tips

1. **Seja específico na spec** - Quanto mais detalhe, melhor o código gerado
2. **Use a TRACEABILITY_MATRIX** - Mapeia requisitos → código
3. **Revise TECHNICAL_DECISIONS.md** - Entenda as escolhas arquiteturais
4. **Siga a ordem de TASK_REGISTRY.md** - Respeita dependências
5. **Não pule validações** - Compliance + Tests + Review são importantes

## 🚀 Próximo Passo

```bash
# 1. Feche este arquivo
# 2. Leia PIPELINE-SDD.md
# 3. Prepare sua especificação
# 4. Execute o Orchestrator-SDD (agente 1)
```

---

**Status**: 🟢 Pronto para começar!

**Tempo estimado**: 5 min de leitura + 2-4 horas de desenvolvimento

Boa sorte! 🎉
EOF

cat > "$PROJECT_PATH/PIPELINE-SDD.md" << 'EOF'
# 🔄 Pipeline SDD - Guia Completo

## O que é SDD?

**Spec-Driven Development (Desenvolvimento Orientado por Especificação)**

Ao invés de:
```
Ideia → Código → Testes → Bug → Refatora
```

Você faz:
```
Especificação → Arquitetura → Código → Validação → Deploy
```

## 9 Agentes do Pipeline

### 1️⃣ Orchestrator-SDD
**Entrada**: Seu requisito/especificação bruta  
**Saída**: Confirmação + roteamento  
**Tempo**: ~5 min  

Ponto de entrada. Recebe sua spec e roteia para o Architect.

```bash
# Copie o prompt
cat pipeline/agents/1-orchestrator/SYSTEM_PROMPT.md
# Cole em um Custom GPT ou use Claude/ChatGPT
# Passe sua especificação bruta
```

---

### 2️⃣ Arquiteto SDD
**Entrada**: Especificação bruta  
**Saída**: 
- TECHNICAL_SPECIFICATION.md
- TRACEABILITY_MATRIX.md
- TECHNICAL_DECISIONS.md
- TASK_REGISTRY.md
- tasks/TASK-001/SUBTASK_SPEC.md, etc

**Tempo**: ~30-45 min (depende da complexidade)

Analisa sua spec completamente e gera documentos técnicos.

```bash
cat pipeline/agents/2-architect/SYSTEM_PROMPT.md
# Cole no seu agente Architect-SDD
# Passe a especificação bruta completa (copy-paste tudo)
```

---

### 3️⃣ Specialist (.NET ou React)
**Entrada**: TECHNICAL_SPECIFICATION.md + TASK_REGISTRY.md  
**Saída**: Código implementado (Domain, Application, Infrastructure, API, Tests)  
**Tempo**: ~1-2 horas por especialidade

Implementa o código baseado nas tarefas decompostas.

```bash
# Para backend .NET
cat pipeline/agents/3-dotnet-specialist/SYSTEM_PROMPT.md

# Para frontend React
cat pipeline/agents/3-react-specialist/SYSTEM_PROMPT.md
```

---

### 4️⃣ SDD Compliance Validator
**Entrada**: Código + TECHNICAL_SPECIFICATION.md  
**Saída**: SDD_COMPLIANCE_REPORT.md (em pipeline/reports/)  
**Tempo**: ~15 min

Valida se o código segue a especificação.

---

### 5️⃣ Test Validator
**Entrada**: Código + compliance report  
**Saída**: TEST_COVERAGE_REPORT.md  
**Tempo**: ~20 min  
**Requisito**: 100% cobertura Application Layer

Garante que testes cobrem 100% da Application Layer.

---

### 6️⃣ Code Review
**Entrada**: Código + todos os docs  
**Saída**: CODE_REVIEW_REPORT.md  
**Tempo**: ~25 min

Valida:
- ✅ SOLID Principles
- ✅ Clean Architecture
- ✅ Clean Code
- ✅ Performance
- ✅ Security

---

### 7️⃣ Build & Test
**Entrada**: Código + review report  
**Saída**: BUILD_TEST_REPORT.md  
**Tempo**: ~10-15 min

Executa:
- `npm run build` / `dotnet build`
- `npm run test` / `dotnet test`
- Validação de warnings

---

### 8️⃣ Commit Message
**Entrada**: Código + BUILD_TEST_REPORT.md  
**Saída**: Script de commits semânticos + PR description  
**Tempo**: ~10 min

Gera commits seguindo Conventional Commits:
```
feat(domain): adicionar entity User
fix(app): corrigir validação de email
test(api): adicionar testes de login
docs(arch): atualizar diagrama
refactor(infra): melhorar repository
```

---

### 9️⃣ Swagger Tester (Opcional)
**Entrada**: Código + TECHNICAL_SPECIFICATION.md  
**Saída**: SWAGGER_TEST_WORKFLOW.md  
**Tempo**: ~15 min

Gera workflow de testes manuais no Swagger UI.

---

## 📋 Arquivos Gerados

| Arquivo | Agente | Local |
|---------|--------|-------|
| TECHNICAL_SPECIFICATION.md | Architect | `pipeline/specs/` |
| TRACEABILITY_MATRIX.md | Architect | `pipeline/specs/` |
| TECHNICAL_DECISIONS.md | Architect | `pipeline/specs/` |
| TASK_REGISTRY.md | Architect | `pipeline/tasks/` |
| TASK-NNN/SUBTASK_SPEC.md | Architect | `pipeline/tasks/` |
| SDD_COMPLIANCE_REPORT.md | Compliance | `pipeline/reports/` |
| TEST_COVERAGE_REPORT.md | Test Validator | `pipeline/reports/` |
| CODE_REVIEW_REPORT.md | Code Review | `pipeline/reports/` |
| BUILD_TEST_REPORT.md | Build & Test | `pipeline/reports/` |
| SWAGGER_TEST_WORKFLOW.md | Swagger Tester | `pipeline/reports/` |

## 🎯 Status dos Relatórios

```
✅ = Passou, avança para próxima etapa
⚠️  = Com ressalvas, pode avançar
❌ = Falhou, volta para etapa anterior
```

## 🔄 Fluxo Completo

```
1. Você cria SPEC
          ↓
2. Orchestrator-SDD (seu papel)
          ↓
3. Architect-SDD (automático via agente)
          ↓
4. Specialist .NET/React (automático via agente)
          ↓
5. Compliance (automático)
          ↓
6. Test Validator (automático)
          ↓
7. Code Review (automático)
          ↓
8. Build & Test (automático)
          ↓
9. Commit Message (automático)
          ↓
10. Swagger Tester (opcional)
          ↓
✅ PRONTO PARA DEPLOY
```

## ⏱️ Tempo Total

| Etapa | Tempo | Automático? |
|-------|-------|------------|
| Orquestrador | 5 min | Você |
| Architect | 30-45 min | Agente |
| Specialist | 60-120 min | Agente |
| Validação (4-8) | 60-90 min | Agentes |
| Commit | 10 min | Agente |
| **TOTAL** | **2.5 - 4.5 horas** | 85% automático |

## 🚀 Como Começar

### Pré-requisitos

✅ Tem uma especificação preparada?  
✅ Acesso a um Custom GPT ou Claude/ChatGPT?  
✅ Ambiente de desenvolvimento pronto?

### Passo 1: Leia a Documentação

```bash
cat COMECE-AQUI.md          # Guia rápido (5 min)
cat PIPELINE-SDD.md         # Este arquivo (10 min)
cat pipeline/agents/1-orchestrator/README.md  # Próxima etapa
```

### Passo 2: Prepare sua Especificação

```markdown
# Sistema de [Seu Sistema]

## Requisitos Funcionais
- REQ-001: ...
- REQ-002: ...

## Regras de Negócio
- BR-001: ...
- BR-002: ...

## Entidades de Domínio
- User
- Project

## Casos de Uso
- Criar usuário
- Listar projetos
```

### Passo 3: Execute o Orchestrator-SDD

```bash
# 1. Copie o prompt
cat pipeline/agents/1-orchestrator/SYSTEM_PROMPT.md

# 2. Crie um Custom GPT com este prompt
# (ou use Claude, ChatGPT, Gemini)

# 3. Passe sua especificação completa

# 4. Siga as instruções que o agente der
```

### Passo 4: Siga o Pipeline

Cada agente vai instruir você qual é o próximo. Siga na ordem!

## 💡 Pro Tips

1. **Especificação é crucial** - Quanto mais detalhe, melhor código
2. **Nomes descritivos** - Use REQ-001, BR-001, não "requirement 1"
3. **Respeite dependências** - As tarefas têm ordem
4. **Revise decisões** - Leia TECHNICAL_DECISIONS.md
5. **Não pule validações** - Compliance + Tests são importantes

## ❓ FAQ

**P: Preciso de todos os 9 agentes?**  
R: Os 8 primeiros sim. O Swagger Tester (9º) é opcional.

**P: Quanto tempo demora?**  
R: 2.5-4.5 horas depende da complexidade da spec.

**P: Posso usar meu próprio modelo de IA?**  
R: Sim, qualquer modelo que suporte system prompts.

**P: E se a spec mudar no meio?**  
R: Volte para o Architect e comece de novo (leva 30 min).

**P: Código pode ter bugs?**  
R: Sim, mas 100% testado. Bugs estão em edge cases.

## 📚 Próximos Passos

1. Leia [COMECE-AQUI.md](./COMECE-AQUI.md) novamente
2. Prepare sua especificação
3. Abra [pipeline/agents/1-orchestrator/README.md](./pipeline/agents/1-orchestrator/README.md)
4. Execute o Orchestrator-SDD

---

**Status**: 🟢 Pronto para começar!

**Próxima etapa**: Execute o Orchestrator-SDD
EOF

cat > "$PROJECT_PATH/.env.example" << 'EOF'
# ============================================================================
# AMBIENTE / GENERAL
# ============================================================================
NODE_ENV=development
NEXT_PUBLIC_APP_URL=http://localhost:3000

# ============================================================================
# BANCO DE DADOS
# ============================================================================
DATABASE_URL=postgresql://usuario:senha@localhost:5432/projeto_sdd
DATABASE_TEST_URL=postgresql://usuario:senha@localhost:5432/projeto_test

# ============================================================================
# AUTENTICAÇÃO
# ============================================================================
JWT_SECRET=sua-secret-muito-longo-aqui-mude-em-producao-pls-32-chars-min
JWT_EXPIRATION=24

# ============================================================================
# API / BACKEND
# ============================================================================
API_PORT=3001
API_TIMEOUT=5000

# ============================================================================
# EMAILS
# ============================================================================
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=seu-email@gmail.com
SMTP_PASS=sua-senha-app-google
SMTP_FROM=noreply@seu-projeto.com

# ============================================================================
# INTEGRAÇÕES EXTERNAS
# ============================================================================
# Stripe (se usar pagamentos)
NEXT_PUBLIC_STRIPE_KEY=pk_test_seu-key
STRIPE_SECRET_KEY=sk_test_seu-secret

# ============================================================================
# PIPELINE SDD (para integração com agentes)
# ============================================================================
# Deixar em branco - será preenchido durante o pipeline
AGENT_ORCHESTRATOR_URL=
AGENT_ARCHITECT_URL=
AGENT_SPECIALIST_URL=
EOF

cat > "$PROJECT_PATH/.gitignore" << 'EOF'
# Dependencies
node_modules/
package-lock.json
yarn.lock
.pnp

# Build
dist/
build/
.next/
out/

# Environment
.env
.env.local
.env.*.local

# IDE
.vscode/
.idea/
*.swp
*.swo
*.sublime-project
*.sublime-workspace

# OS
.DS_Store
Thumbs.db

# Logs
*.log
logs/
npm-debug.log*

# Coverage
coverage/
.nyc_output/

# Tests
.test-results/
.vitest/

# Temporary
tmp/
temp/
*.tmp
EOF

echo -e "${GREEN}✅ Arquivos raiz criados${NC}"

# ============================================================================
# 3. CRIAR AGENTES SDD
# ============================================================================
echo -e "${BLUE}[3/9]${NC} Criando agentes SDD..."

# Orchestrator
mkdir -p "$PROJECT_PATH/pipeline/agents/1-orchestrator"
cat > "$PROJECT_PATH/pipeline/agents/1-orchestrator/README.md" << 'EOF'
# 🎯 Orchestrator-SDD

Agente de entrada do pipeline. Recebe a especificação bruta e roteia para Architect-SDD.

## Como Usar

1. Copie o conteúdo de `SYSTEM_PROMPT.md`
2. Crie um Custom GPT no ChatGPT (ou use Claude, Gemini)
3. Cole o prompt nas "System Instructions"
4. Envie sua especificação completa

## Saída Esperada

- ✅ Confirmação de recebimento
- ✅ Resumo do que o pipeline irá fazer
- ✅ Instrução para usar Architect-SDD (próxima etapa)

## Tempo

~5 minutos

## Próxima Etapa

Architect-SDD (agente 2)
EOF

cat > "$PROJECT_PATH/pipeline/agents/1-orchestrator/SYSTEM_PROMPT.md" << 'EOF'
# System Prompt - Orchestrator-SDD

Você é o Agente Orquestrador, o ponto de entrada do harness multi-agente de desenvolvimento orientado a especificação (SDD). Sua única responsabilidade é receber a especificação do usuário e rotear para o Arquiteto SDD - sem realizar nenhuma análise, geração de código ou produção de documentos técnicos.

## Responsabilidade Exclusiva

Você NÃO faz:
- Análise de requisitos ou regras de negócio
- Geração de documentos técnicos
- Geração de código ou pseudocódigo
- Avaliação de arquitetura ou tecnologia
- Decomposição de tarefas
- Gerenciamento de cada etapa do pipeline

Você FAZ:
- Recebe a especificação bruta do usuário
- Informa ao usuário que o próximo passo é o Arquiteto SDD
- Apresenta um resumo do que o pipeline irá fazer

## Regras de Ouro

1. "NUNCA analise, NUNCA gere código, NUNCA produza documentos"
2. "Repasse a especificação bruta ao Arquiteto SDD sem modificações"
3. "O pipeline é auto-gerenciado após o roteamento"

## WORKFLOW

ETAPA 1: Confirmar recebimento
═══════════════════════════════════════════════════════════
✅ ESPECIFICAÇÃO RECEBIDA

Formato detectado: [Markdown / Texto / OpenAPI / etc.]
Tamanho: [N] linhas

Próximo passo:
  → Roteando para: Arquiteto SDD
  → O Arquiteto SDD irá:
      1. Analisar a especificação completa
      2. Gerar TECHNICAL_SPECIFICATION.md
      3. Decompor em subtarefas técnicas
      4. Gerar TASK_REGISTRY.md

⚠️ O pipeline é auto-gerenciado após o roteamento.

═══════════════════════════════════════════════════════════

ETAPA 2: Instrua o usuário sobre o próximo agente

Mensagem padrão:
"Agora use o agente **Arquiteto SDD** com a sua especificação completa (copie-cole tudo que você enviou aqui)."

REGRAS ABSOLUTAS:
SEMPRE:
  - Repassar a especificação bruta SEM modificações
  - Informar que o pipeline é auto-gerenciado

NUNCA:
  - Analisar a especificação recebida
  - Gerar documentos ou código
EOF

# Architect
mkdir -p "$PROJECT_PATH/pipeline/agents/2-architect"
cat > "$PROJECT_PATH/pipeline/agents/2-architect/README.md" << 'EOF'
# 🏛️ Arquiteto SDD

Analisa a especificação bruta e gera documentos técnicos SDD.

## Saídas Principais

1. **TECHNICAL_SPECIFICATION.md** - Especificação técnica completa
2. **TRACEABILITY_MATRIX.md** - Matriz de rastreabilidade
3. **TECHNICAL_DECISIONS.md** - Decisões arquiteturais
4. **TASK_REGISTRY.md** - Inventário de tarefas
5. **tasks/TASK-NNN-*/** - Subtarefas individuais

## Tempo

30-45 minutos (depende da complexidade)

## Como Usar

Copie o prompt de `SYSTEM_PROMPT.md` e passe a especificação **COMPLETA** (copy-paste tudo).

## Próxima Etapa

.NET Specialist ou React Specialist (agente 3)
EOF

# Specialist .NET
mkdir -p "$PROJECT_PATH/pipeline/agents/3-dotnet-specialist"
cat > "$PROJECT_PATH/pipeline/agents/3-dotnet-specialist/README.md" << 'EOF'
# 🔷 .NET Specialist

Implementa o backend em Clean Architecture com .NET.

## Implementa

- `src/Domain/` - Entidades, Agregados, Value Objects
- `src/Application/` - Use Cases, DTOs, Handlers
- `src/Infrastructure/` - Repositórios, EF Core
- `src/API/` - Controllers, Middleware
- `src/Tests/` - Testes unitários e integração

## Entrada

- TECHNICAL_SPECIFICATION.md
- TASK_REGISTRY.md
- tasks/TASK-NNN-*/SUBTASK_SPEC.md

## Tempo

60-120 minutos

## Próxima Etapa

SDD Compliance Validator (agente 4)
EOF

# Specialist React
mkdir -p "$PROJECT_PATH/pipeline/agents/3-react-specialist"
cat > "$PROJECT_PATH/pipeline/agents/3-react-specialist/README.md" << 'EOF'
# ⚛️ React Specialist

Implementa o frontend em Clean Architecture com React/Next.js.

## Implementa

- `src/Domain/` - Tipos, interfaces
- `src/Application/` - Hooks, estado
- `src/Infrastructure/` - APIs, services
- `src/API/` - Rotas, páginas
- `src/Tests/` - Testes de componentes

## Entrada

- TECHNICAL_SPECIFICATION.md
- TASK_REGISTRY.md

## Tempo

60-120 minutos

## Próxima Etapa

SDD Compliance Validator (agente 4)
EOF

# Compliance, Tests, Review, Build, Commit
for i in 4 5 6 7 8 9; do
  case $i in
    4) AGENT="SDD Compliance Validator"; DIR="4-compliance";;
    5) AGENT="Test Validator"; DIR="5-tests";;
    6) AGENT="Code Review"; DIR="6-review";;
    7) AGENT="Build & Test"; DIR="7-build";;
    8) AGENT="Commit Message"; DIR="8-commit";;
    9) AGENT="Swagger Tester"; DIR="9-swagger";;
  esac
  
  mkdir -p "$PROJECT_PATH/pipeline/agents/$DIR"
  cat > "$PROJECT_PATH/pipeline/agents/$DIR/README.md" << EOF
# Agente $i - $AGENT

Ver SYSTEM_PROMPT.md para usar.

Tempo estimado: 15-30 minutos

Para entender mais: Ver [PIPELINE-SDD.md](../../PIPELINE-SDD.md)
EOF
done

echo -e "${GREEN}✅ Agentes criados${NC}"

# ============================================================================
# 4. CRIAR ESTRUTURA DE SPECS
# ============================================================================
echo -e "${BLUE}[4/9]${NC} Criando estrutura de specs..."

cat > "$PROJECT_PATH/pipeline/specs/README.md" << 'EOF'
# 📋 Especificações SDD

Documentos gerados pelo Arquiteto SDD.

## Arquivos

- **TECHNICAL_SPECIFICATION.md** - Especificação técnica completa
- **TRACEABILITY_MATRIX.md** - Matriz de rastreabilidade
- **TECHNICAL_DECISIONS.md** - Decisões arquiteturais

Estes serão preenchidos após executar o agente Architect-SDD (etapa 2).
EOF

echo -e "${GREEN}✅ Estrutura de specs criada${NC}"

# ============================================================================
# 5. CRIAR ESTRUTURA DE TASKS
# ============================================================================
echo -e "${BLUE}[5/9]${NC} Criando estrutura de tasks..."

cat > "$PROJECT_PATH/pipeline/tasks/README.md" << 'EOF'
# 📦 Tarefas SDD

Subtarefas decompostas pelo Arquiteto SDD.

## Estrutura

```
tasks/
├── TASK_REGISTRY.md              # Inventário completo
├── TASK-001-nome/
│   ├── SUBTASK_SPEC.md
│   └── SUBTASK_CONTEXT.md
├── TASK-002-nome/
│   ├── SUBTASK_SPEC.md
│   └── SUBTASK_CONTEXT.md
...
```

Estes serão preenchidos após executar o agente Architect-SDD (etapa 2).

## Importante

Respeite a ordem em TASK_REGISTRY.md - tem dependências!
EOF

echo -e "${GREEN}✅ Estrutura de tasks criada${NC}"

# ============================================================================
# 6. CRIAR ESTRUTURA DE REPORTS
# ============================================================================
echo -e "${BLUE}[6/9]${NC} Criando estrutura de reports..."

cat > "$PROJECT_PATH/pipeline/reports/README.md" << 'EOF'
# 📈 Relatórios SDD

Relatórios gerados durante o pipeline.

## Relatórios Esperados

1. **SDD_COMPLIANCE_REPORT.md** (etapa 4)
   - Validação de conformidade com spec

2. **TEST_COVERAGE_REPORT.md** (etapa 5)
   - Cobertura: 100% Application Layer

3. **CODE_REVIEW_REPORT.md** (etapa 6)
   - Validação: SOLID, Clean Architecture, Clean Code

4. **BUILD_TEST_REPORT.md** (etapa 7)
   - Build + testes passando

5. **SWAGGER_TEST_WORKFLOW.md** (etapa 9, opcional)
   - Workflow de testes manual

## Status

- ✅ = Passou
- ⚠️ = Com ressalvas  
- ❌ = Falhou (volta para etapa anterior)

Estes serão preenchidos conforme o pipeline avança (etapas 4-9).
EOF

echo -e "${GREEN}✅ Estrutura de reports criada${NC}"

# ============================================================================
# 7. CRIAR DOCUMENTAÇÃO
# ============================================================================
echo -e "${BLUE}[7/9]${NC} Criando documentação..."

cat > "$PROJECT_PATH/docs/guides/como-usar-agentes.md" << 'EOF'
# 📖 Como Usar os Agentes SDD

Guia passo-a-passo para usar cada agente do pipeline.

## Pré-requisitos

- Custom GPT, ChatGPT, Claude ou Gemini
- Especificação preparada (para agente 1)

## Agente 1: Orchestrator-SDD

**Duração**: 5 minutos

### Passo a Passo

1. Abra seu ChatGPT / Claude / Gemini
2. Cole o prompt de `pipeline/agents/1-orchestrator/SYSTEM_PROMPT.md`
3. Envie sua especificação bruta completa
4. Siga as instruções que o agente der

### Resultado

✅ Confirmação de recebimento  
✅ Próximo passo: Agente 2 (Architect)

---

## Agente 2: Architect-SDD

**Duração**: 30-45 minutos

Após o Orchestrator rotear, use o Architect com a MESMA especificação.

### Saídas

- `pipeline/specs/TECHNICAL_SPECIFICATION.md`
- `pipeline/specs/TRACEABILITY_MATRIX.md`
- `pipeline/specs/TECHNICAL_DECISIONS.md`
- `pipeline/tasks/TASK_REGISTRY.md`
- `pipeline/tasks/TASK-NNN-*/SUBTASK_SPEC.md`

---

## Agente 3: Specialist

**Duração**: 60-120 minutos

Escolha um:
- **3-dotnet-specialist/** - Para backend
- **3-react-specialist/** - Para frontend

### Saídas

- Código em `src/Domain/`
- Código em `src/Application/`
- Código em `src/Infrastructure/`
- Código em `src/API/`
- Testes em `src/Tests/`

---

## Agentes 4-9: Validação Automática

Cada agente lê o output do anterior e gera o seu relatório.

Tempo total: 60-90 minutos

---

## Próximas Etapas Após Pipeline

1. Copie o código para seu repositório
2. Execute `npm install` (frontend)
3. Execute `dotnet build` (backend)
4. Rode os testes
5. Faça commit (use as mensagens geradas)
6. Deploy!

Mais detalhes em: [PIPELINE-SDD.md](../../PIPELINE-SDD.md)
EOF

cat > "$PROJECT_PATH/docs/architecture/README.md" << 'EOF'
# 🏗️ Arquitetura

Documentação de arquitetura do projeto baseada em Clean Architecture.

## Clean Architecture Layers

### 1. Domain Layer
Lógica de negócio **sem dependências externas**.

```
Domain/
├── Entities/          # User, Project, etc
├── Aggregates/        # UserAggregate
├── ValueObjects/      # Email, Password
└── Services/          # DomainService
```

**Características**:
- ✅ Sem dependências externas
- ✅ 100% testável
- ✅ Lógica de negócio pura

### 2. Application Layer
Casos de uso e coordenação.

```
Application/
├── UseCases/          # CreateUserUseCase
├── DTOs/              # UserDTO
├── Handlers/          # CommandHandlers
└── Validators/        # FluentValidation
```

**Características**:
- ✅ Depende de Domain
- ✅ Não depende de Infrastructure
- ✅ Fácil testar com mocks

### 3. Infrastructure Layer
Implementações técnicas.

```
Infrastructure/
├── Database/          # DbContext, Migrations
├── Repositories/      # UserRepository
├── ExternalAPIs/      # IntegrationService
└── Cache/             # CacheProvider
```

**Características**:
- ✅ Depende de Application + Domain
- ✅ Fácil trocar banco/cache
- ✅ Implementações específicas

### 4. API Layer
Controllers e rotas.

```
API/
├── Controllers/       # UserController
├── Middleware/        # AuthMiddleware
├── Filters/           # GlobalExceptionFilter
└── Validators/        # FluentValidation setup
```

### 5. Tests Layer
Testes de todas as camadas.

```
Tests/
├── Unit/              # Domain, Application
├── Integration/       # API, Infrastructure
└── E2E/               # Fluxos completos
```

---

## Benefícios dessa Arquitetura

| Aspecto | Benefício |
|--------|-----------|
| Testabilidade | Domain sem dependências = fácil testar |
| Manutenibilidade | Camadas independentes = fácil mexer |
| Escalabilidade | Adicionar features sem quebrar existente |
| Reusabilidade | Domain logic em múltiplos contextos |
| Performance | Otimizar cada camada independentemente |

---

## Fluxo de uma Requisição

```
HTTP Request (API Layer)
        ↓
Controller (API Layer)
        ↓
UseCase / Handler (Application Layer)
        ↓
Domain Service (Domain Layer)
        ↓
Entity Logic (Domain Layer)
        ↓
Repository (Infrastructure Layer)
        ↓
Database
        ↓
Response
```

---

## Decisões Arquiteturais

Ver: [TECHNICAL_DECISIONS.md](../pipeline/specs/TECHNICAL_DECISIONS.md)

Contém:
- Escolhas de tecnologia
- Rationale (por quê)
- Trade-offs
- Premissas
- Mitigações de risco

---

## ADRs (Architecture Decision Records)

Ver: [adr/](./adr/)

Documentação de cada decisão importante tomada durante o projeto.

---

Próximo: Volte para [COMECE-AQUI.md](../../COMECE-AQUI.md)
EOF

mkdir -p "$PROJECT_PATH/docs/adr"
cat > "$PROJECT_PATH/docs/adr/0001-usar-clean-architecture.md" << 'EOF'
# ADR 0001 - Usar Clean Architecture

**Status**: Aceito

**Data**: $(date +%Y-%m-%d)

## Contexto

Precisamos de uma arquitetura escalável que permita:
- Código testável sem dependências externas
- Fácil mudança de tecnologia (banco, UI, etc)
- Separação clara de responsabilidades

## Decisão

Adotar Clean Architecture (Robert C. Martin) com 4 camadas:
1. Domain (sem dependências)
2. Application (depende de Domain)
3. Infrastructure (depende de Application)
4. API (depende de Application)

## Consequências

### Positivas
✅ Lógica de negócio protegida de mudanças tecnológicas  
✅ Testes unitários super rápidos (Domain)  
✅ Fácil entender o fluxo  
✅ Produtivo adicionar features  

### Negativas
❌ Código mais verbose (mais classes)  
❌ Curva de aprendizado  
❌ Pode ser overkill em projetos muito simples  

## Alternativas Consideradas

1. **N-Layered Architecture** - Mais simples, mas menos testável
2. **Hexagonal/Ports & Adapters** - Similar, mas mais complexo
3. **Modular Monolith** - Para futura escalabilidade

---

Desenvolvido durante o pipeline SDD - Agente 2 (Architect-SDD)
EOF

echo -e "${GREEN}✅ Documentação criada${NC}"

# ============================================================================
# 8. CRIAR CONFIGURAÇÕES
# ============================================================================
echo -e "${BLUE}[8/9]${NC} Criando configurações..."

cat > "$PROJECT_PATH/package.json.template" << 'EOF'
{
  "name": "projeto-sdd",
  "version": "0.1.0",
  "description": "Projeto desenvolvido com Spec-Driven Development",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "test": "vitest",
    "test:watch": "vitest --watch",
    "test:coverage": "vitest --coverage",
    "test:ui": "vitest --ui",
    "lint": "eslint . --ext ts,tsx",
    "lint:fix": "eslint . --ext ts,tsx --fix",
    "format": "prettier --write \"**/*.{ts,tsx,md}\"",
    "format:check": "prettier --check \"**/*.{ts,tsx,md}\"",
    "type-check": "tsc --noEmit",
    "pipeline:status": "echo 'Ver pipeline/reports/ para status'",
    "validate": "npm run type-check && npm run lint && npm run test"
  },
  "dependencies": {
    "react": "^18.3.0",
    "react-dom": "^18.3.0",
    "next": "^14.0.0",
    "zod": "^3.22.0"
  },
  "devDependencies": {
    "@testing-library/react": "^14.1.0",
    "@testing-library/user-event": "^14.5.1",
    "@types/node": "^20.10.0",
    "@types/react": "^18.2.37",
    "@typescript-eslint/eslint-plugin": "^6.13.0",
    "@typescript-eslint/parser": "^6.13.0",
    "@vitejs/plugin-react": "^4.2.0",
    "eslint": "^8.54.0",
    "prettier": "^3.11.0",
    "typescript": "^5.3.2",
    "vitest": "^1.0.0"
  }
}
EOF

echo -e "${GREEN}✅ Configurações criadas${NC}"

# ============================================================================
# 9. RESUMO FINAL
# ============================================================================
echo -e "${BLUE}[9/9]${NC} Gerando resumo..."

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ TEMPLATE SDD CRIADO COM SUCESSO!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "📁 Localização: ${YELLOW}$PROJECT_PATH${NC}"
echo ""
echo -e "${BLUE}📊 Pipeline: 9 Agentes Especializados${NC}"
echo ""
echo -e "  1️⃣  Orchestrator-SDD        → Recebe spec bruta"
echo -e "  2️⃣  Arquiteto SDD           → Gera TECHNICAL_SPECIFICATION.md"
echo -e "  3️⃣  .NET / React Specialist → Implementa código"
echo -e "  4️⃣  SDD Compliance          → Valida conformidade"
echo -e "  5️⃣  Test Validator          → 100% cobertura"
echo -e "  6️⃣  Code Review             → Valida arquitetura"
echo -e "  7️⃣  Build & Test            → Build + testes"
echo -e "  8️⃣  Commit Message          → Commits semânticos"
echo -e "  9️⃣  Swagger Tester          → Testes manuais (opcional)"
echo ""
echo -e "${BLUE}📂 Estrutura Clean Architecture${NC}"
echo ""
echo -e "  src/"
echo -e "  ├── Domain/          (regras de negócio puras)"
echo -e "  ├── Application/     (casos de uso)"
echo -e "  ├── Infrastructure/  (banco, APIs)"
echo -e "  ├── API/            (controllers)"
echo -e "  └── Tests/          (cobertura 100%)"
echo ""
echo -e "${BLUE}📚 Documentação${NC}"
echo ""
echo -e "  Leia nesta ordem:"
echo -e "  1. ${YELLOW}COMECE-AQUI.md${NC}       (5 min)"
echo -e "  2. ${YELLOW}PIPELINE-SDD.md${NC}      (10 min)"
echo -e "  3. ${YELLOW}pipeline/agents/1-*${NC} (próxima etapa)"
echo ""
echo -e "${GREEN}🚀 Próximos Passos:${NC}"
echo ""
echo -e "  ${YELLOW}cd $PROJECT_NAME${NC}"
echo -e "  ${YELLOW}npm install${NC}"
echo -e "  ${YELLOW}cp .env.example .env.local${NC}"
echo -e "  ${YELLOW}cat COMECE-AQUI.md${NC}"
echo ""
echo -e "  Depois:"
echo -e "  ${YELLOW}cat PIPELINE-SDD.md${NC}"
echo -e "  ${YELLOW}cat pipeline/agents/1-orchestrator/README.md${NC}"
echo ""
echo -e "${GREEN}✨ Pronto para desenvolvimento SDD!${NC}"
echo ""
echo -e "${BLUE}⏱️  Tempo estimado completo: 2.5-4.5 horas${NC}"
echo ""
echo -e "Desenvolvido com ❤️ usando Spec-Driven Development"
echo ""
EOF

chmod +x /mnt/user-data/outputs/criar-template-claude-sdd-plugin.sh
