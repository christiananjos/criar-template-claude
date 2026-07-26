# 🎯 Exemplo Prático - Usando o Plugin SDD v2.0

> Demonstração passo-a-passo de como criar um projeto real usando o pipeline SDD

---

## 📋 Cenário

Você quer criar um **Sistema de Gestão de Tarefas** (Task Manager).

Requisitos básicos:
- Usuários podem se registrar e fazer login
- Criar, editar, deletar tarefas
- Marcar tarefas como concluídas
- Listar tarefas com filtros
- Admin pode gerenciar usuários

**Tempo que levaria sem SDD**: 1-2 semanas  
**Tempo com SDD v2.0**: 3-4 horas  

---

## 🚀 Passo 1: Criar o Template

### Execute o script

```bash
# Criar projeto
bash criar-template-claude-sdd-plugin.sh task-manager-sdd

# Entrar na pasta
cd task-manager-sdd

# Verificar estrutura
ls -la
tree -L 2
```

### Resultado

```
task-manager-sdd/
├── COMECE-AQUI.md              ✅ Leia primeiro!
├── PIPELINE-SDD.md             ✅ Entenda o pipeline
├── README.md
├── .env.example
├── pipeline/
│   ├── agents/1-9/             ✅ Prompts dos agentes
│   ├── specs/                  (vazio agora)
│   ├── tasks/                  (vazio agora)
│   └── reports/                (vazio agora)
├── src/                        ✅ Clean Architecture
│   ├── Domain/
│   ├── Application/
│   ├── Infrastructure/
│   ├── API/
│   └── Tests/
└── docs/
    ├── guides/
    ├── architecture/
    └── adr/
```

---

## 📚 Passo 2: Ler a Documentação

```bash
# Ler guia rápido (5 min)
cat COMECE-AQUI.md

# Entender o pipeline (10 min)
cat PIPELINE-SDD.md

# Entender cada agente (5 min)
cat pipeline/agents/1-orchestrator/README.md
```

**Tempo**: 20 minutos

---

## 📝 Passo 3: Preparar a Especificação

Criar arquivo `SPEC.md`:

```markdown
# Sistema de Gestão de Tarefas (Task Manager)

## 1. REQUISITOS FUNCIONAIS

### Usuários
- REQ-001: Usuário pode se registrar com email/senha
- REQ-002: Usuário recebe email de confirmação
- REQ-003: Usuário pode fazer login
- REQ-004: Usuário pode fazer logout
- REQ-005: Usuário pode recuperar senha

### Tarefas
- REQ-006: Usuário autenticado pode criar tarefa
- REQ-007: Usuário pode editar sua própria tarefa
- REQ-008: Usuário pode deletar sua própria tarefa
- REQ-009: Usuário pode marcar tarefa como concluída
- REQ-010: Usuário pode listar suas tarefas

### Filtros e Busca
- REQ-011: Usuário pode filtrar tarefas por status (pendente/concluída)
- REQ-012: Usuário pode filtrar por prioridade (baixa/média/alta)
- REQ-013: Usuário pode buscar tarefas por título

### Admin
- REQ-014: Admin pode listar todos os usuários
- REQ-015: Admin pode deletar usuário
- REQ-016: Admin pode desativar usuário
- REQ-017: Admin pode ver relatório de tarefas

## 2. REGRAS DE NEGÓCIO

- BR-001: Senha deve ter mínimo 8 caracteres
- BR-002: Email deve ser único no sistema
- BR-003: Tarefas concluídas não podem ser editadas
- BR-004: Apenas o dono pode editar sua tarefa
- BR-005: Usuário desativado não pode fazer login
- BR-006: Título da tarefa é obrigatório (máximo 200 caracteres)
- BR-007: Descrição é opcional (máximo 2000 caracteres)
- BR-008: Prioridade padrão é "média"
- BR-009: Data de conclusão é opcional
- BR-010: Admin é designado manualmente

## 3. ENTIDADES DE DOMÍNIO

### User
- id: UUID
- email: string (unique)
- passwordHash: string
- firstName: string
- lastName: string
- role: enum (User, Admin)
- isActive: boolean
- createdAt: datetime
- updatedAt: datetime

### Task
- id: UUID
- userId: UUID (FK)
- title: string (max 200)
- description: string (max 2000)
- status: enum (Pending, Completed)
- priority: enum (Low, Medium, High)
- dueDate: datetime (optional)
- completedAt: datetime (optional)
- createdAt: datetime
- updatedAt: datetime

### Role
- Admin
- User

## 4. INTEGRAÇÕES

### Email
- Serviço: SendGrid
- Uso:
  - Confirmação de registro
  - Recuperação de senha
  - Notificação de tarefa pendente

## 5. CASOS DE USO PRINCIPAIS

### Fluxo de Registro
1. Usuário clica em "Registrar"
2. Preenche email, senha, nome
3. Sistema valida dados
4. Cria usuário inativo
5. Envia email de confirmação
6. Usuário clica no link
7. Ativa conta e redireciona para login

### Fluxo de Criar Tarefa
1. Usuário autenticado clica em "Nova Tarefa"
2. Preenche título (obrigatório) e descrição
3. Seleciona prioridade (padrão: média)
4. Sistema salva tarefa
5. Redireciona para lista

### Fluxo de Completar Tarefa
1. Usuário vê lista de tarefas
2. Clica no checkbox de uma tarefa
3. Marca como concluída (set completedAt)
4. Tarefa sai de "pendentes" → "concluídas"

## 6. STACK TECNOLÓGICO

### Frontend
- Next.js 14
- React 18
- TypeScript
- Tailwind CSS
- Vitest + React Testing Library

### Backend
- .NET 8
- Clean Architecture
- Entity Framework Core
- xUnit + NSubstitute

### Banco de Dados
- PostgreSQL

### Autenticação
- JWT (Bearer tokens)

## 7. SEGURANÇA

- Senhas hasheadas com bcrypt
- JWT para autenticação
- CORS configurado
- Rate limiting em login
- Validação de entrada (XSS)
- SQL Injection prevenido (ORM)
- HTTPS em produção

## 8. PERFORMANCE

- Índices no banco (email, userId)
- Paginação de tarefas (20 por página)
- Cache de usuário
- Lazy loading de tarefas

## 9. TESTES

### Cobertura Mínima
- 100% Application Layer
- 90%+ Infrastructure Layer
- 80%+ API Layer

### Testes de Cenários

#### Criar Tarefa
- ✅ Happy path: tarefa criada com sucesso
- ✅ Erro: usuário não autenticado
- ✅ Erro: título vazio
- ✅ Erro: título com mais de 200 caracteres

#### Listar Tarefas
- ✅ Happy path: lista retornada com paginação
- ✅ Erro: usuário não autenticado
- ✅ Filter por status
- ✅ Filter por prioridade
- ✅ Busca por título

#### Login
- ✅ Happy path: credentials corretos
- ✅ Erro: email não existe
- ✅ Erro: senha incorreta
- ✅ Erro: usuário inativo

## 10. TIMELINE ESPERADA (Sem SDD)

- Database Design: 2 horas
- Backend Development: 5 horas
- Frontend Development: 4 horas
- Testing: 2 horas
- Debugging: 1-2 horas
- **Total: 14-15 horas**

## Com SDD v2.0: 3-4 horas
```

**Arquivo**: `SPEC.md` no root do projeto  
**Tempo**: 30 minutos para preparar

---

## 🎯 Passo 4: Executar o Orchestrator-SDD

### Copiar o prompt

```bash
cat pipeline/agents/1-orchestrator/SYSTEM_PROMPT.md
# Copiar tudo (Ctrl+C)
```

### Usar o agente

1. Abra seu **Custom GPT** (ou ChatGPT, Claude, Gemini)
2. Cole o prompt nas **System Instructions**
3. Salve o Custom GPT
4. Envie sua especificação:

```
Cole aqui o conteúdo de SPEC.md
```

### Resposta esperada

```
✅ ESPECIFICAÇÃO RECEBIDA

Formato detectado: Markdown
Tamanho: 400+ linhas

Próximo passo:
  → Roteando para: Arquiteto SDD
  → O Arquiteto SDD irá:
      1. Analisar especificação completa
      2. Gerar TECHNICAL_SPECIFICATION.md
      3. Decompor em subtarefas técnicas
      4. Gerar TASK_REGISTRY.md

⚠️ O pipeline é auto-gerenciado após o roteamento.

Agora use o agente **Arquiteto SDD** com a sua especificação completa.
```

**Tempo**: 5 minutos

---

## 🏛️ Passo 5: Executar o Arquiteto SDD

### Copiar o prompt

```bash
cat pipeline/agents/2-architect/SYSTEM_PROMPT.md
```

### Usar o agente

1. Crie novo Custom GPT (ou use o existente)
2. Cole o prompt das System Instructions
3. Envie a MESMA especificação que enviou para Orchestrator

### Resultado esperado

Serão criados:

```
pipeline/specs/TECHNICAL_SPECIFICATION.md   # Spec técnica completa
pipeline/specs/TRACEABILITY_MATRIX.md        # Requisitos → Código
pipeline/specs/TECHNICAL_DECISIONS.md        # Decisões arquiteturais

pipeline/tasks/TASK_REGISTRY.md              # Inventário de tarefas
pipeline/tasks/TASK-001-criar-domain/...
pipeline/tasks/TASK-002-criar-application/...
... (mais tarefas)
```

**Tempo**: 30-45 minutos

---

## 💻 Passo 6: Executar o Specialist (.NET ou React)

### Para Backend (.NET)

```bash
cat pipeline/agents/3-dotnet-specialist/SYSTEM_PROMPT.md
```

Envie:
1. `pipeline/specs/TECHNICAL_SPECIFICATION.md`
2. `pipeline/tasks/TASK_REGISTRY.md`
3. Conteúdo de `pipeline/tasks/TASK-001/SUBTASK_SPEC.md`

### Para Frontend (React)

```bash
cat pipeline/agents/3-react-specialist/SYSTEM_PROMPT.md
```

Resultado esperado:

```
src/Domain/
  ├── Entities/
  │   ├── User.ts
  │   └── Task.ts
  ├── ValueObjects/
  │   └── Email.ts
  └── Services/
      └── UserDomainService.ts

src/Application/
  ├── UseCases/
  │   ├── CreateTaskUseCase.ts
  │   ├── ListTasksUseCase.ts
  │   └── ...
  ├── DTOs/
  │   ├── TaskDTO.ts
  │   ├── CreateTaskDTO.ts
  │   └── ...
  └── Validators/
      └── CreateTaskValidator.ts

src/Infrastructure/
  ├── Database/
  │   ├── TaskRepository.ts
  │   ├── UserRepository.ts
  │   └── DbContext.cs
  └── ExternalAPIs/
      └── SendGridService.ts

src/API/
  ├── Controllers/
  │   ├── TaskController.ts
  │   └── UserController.ts
  ├── Middleware/
  │   └── AuthMiddleware.ts
  └── Filters/
      └── GlobalExceptionFilter.ts

src/Tests/
  ├── Unit/
  │   ├── CreateTaskUseCaseTests.ts
  │   ├── TaskValidatorTests.ts
  │   └── ...
  └── Integration/
      └── TaskControllerTests.ts
```

**Tempo**: 60-120 minutos

---

## ✅ Passo 7: Validação (Automatizada)

### Agente 4: SDD Compliance

Valida se código segue a especificação.

**Resultado**: `pipeline/reports/SDD_COMPLIANCE_REPORT.md`

### Agente 5: Test Validator

Valida 100% cobertura Application Layer.

**Resultado**: `pipeline/reports/TEST_COVERAGE_REPORT.md`

### Agente 6: Code Review

Valida SOLID, Clean Code, Performance.

**Resultado**: `pipeline/reports/CODE_REVIEW_REPORT.md`

### Agente 7: Build & Test

Build + executa todos os testes.

**Resultado**: `pipeline/reports/BUILD_TEST_REPORT.md`

**Tempo**: 60-90 minutos (automático)

---

## 📝 Passo 8: Commits Semânticos

### Agente 8: Commit Message

Gera commits seguindo Conventional Commits.

**Resultado**: Script de commits

```bash
# Exemplo de commits gerados:
git commit -m "feat(domain): adicionar entity User com validações"
git commit -m "feat(app): criar CreateTaskUseCase com validação"
git commit -m "feat(infra): implementar TaskRepository com EF Core"
git commit -m "feat(api): adicionar TaskController com endpoints CRUD"
git commit -m "test(app): adicionar testes 100% para Application Layer"
git commit -m "docs(arch): atualizar diagrama de arquitetura"
```

**Tempo**: 10 minutos (automático)

---

## 🧪 Passo 9: Testes Manuais (Opcional)

### Agente 9: Swagger Tester

Gera workflow de testes manuais.

**Resultado**: `pipeline/reports/SWAGGER_TEST_WORKFLOW.md`

Contém passo-a-passo para testar cada endpoint no Swagger UI.

**Tempo**: 15 minutos (manual)

---

## 📊 Timeline Real

```
🕐 10:00 - Criar template com script          (5 min)
🕐 10:05 - Ler COMECE-AQUI.md                 (5 min)
🕐 10:10 - Ler PIPELINE-SDD.md                (10 min)
🕐 10:20 - Preparar especificação             (30 min)
🕐 10:50 - Executar Orchestrator-SDD          (5 min)
🕐 10:55 - Executar Arquiteto SDD             (45 min) 📈
🕐 11:40 - Executar .NET Specialist           (120 min) 💻
🕐 13:40 - Validação automática (4-7)         (90 min) ✅
🕐 15:10 - Commits + Swagger tester           (25 min) 📝
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🕐 15:35 - ✅ CÓDIGO PRONTO PARA PRODUÇÃO! 🎉
```

**Tempo Total: 3 horas 35 minutos**

---

## 🎯 Resultado Final

### Código Pronto

```bash
npm install
npm run dev
# Frontend rodando em http://localhost:3000

dotnet build
dotnet run
# Backend rodando em http://localhost:5000
```

### Testes Passando

```bash
npm run test:coverage
# Application Layer: 100% ✅

dotnet test
# Todos os testes passando ✅
```

### Documentação Completa

- ✅ TECHNICAL_SPECIFICATION.md
- ✅ TRACEABILITY_MATRIX.md
- ✅ TECHNICAL_DECISIONS.md
- ✅ Código comentado
- ✅ Diagramas de arquitetura

### Pronto para Deploy

```bash
git push origin main
# CI/CD automático
# Deploy em produção
```

---

## 📈 Comparativo

| Aspecto | Sem SDD | Com SDD v2.0 |
|---------|---------|------------|
| Tempo total | 14-15 horas | 3.5 horas |
| Cobertura de testes | 60-70% | 100% |
| Documentação | Básica | Completa |
| Bugs encontrados | Depois de deploy | 0 (validação automática) |
| Manutenibilidade | Média | Excelente |

---

## 🎓 Aprendizados

Usando SDD v2.0 você:

✅ Aprende Clean Architecture na prática  
✅ Vê como agentes de IA podem ajudar  
✅ Entende rastreabilidade de requisitos  
✅ Pratica TDD desde o início  
✅ Produz código profissional pronto para produção  

---

## 🚀 Próximos Passos

1. Fazer commit do código
2. Setup de CI/CD (GitHub Actions, etc)
3. Deploy em staging
4. Testes manuais finais
5. Deploy em produção!

---

**Resultado: Um projeto profissional, testado, documentado, pronto para produção em 3.5 horas!** 🎉

Tempo economizado: **10+ horas** ⏰  
Qualidade ganha: **Excelente** ⭐⭐⭐⭐⭐  
Stress reduzido: **Infinito** 😌
