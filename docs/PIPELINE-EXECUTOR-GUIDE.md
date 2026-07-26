# 🤖 Pipeline Executor - Guia Completo

> Execute o pipeline SDD **completamente automatizado** via API do Claude

---

## 🎯 O Que É?

Um **orquestrador automático** que:

✅ Executa os 9 agentes **sequencialmente**  
✅ Gerencia outputs (specs, tasks, reports)  
✅ Valida conformidade automaticamente  
✅ Redireciona em caso de falha  
✅ Gera relatório final completo  

**Reduz 3-4 horas manuais para ~20-30 minutos automáticos** ⚡

---

## 📦 Instalação

### 1. Instalar Python

```bash
python --version  # 3.8+
```

### 2. Instalar Dependências

```bash
pip install -r requirements.txt
```

Ou manualmente:
```bash
pip install anthropic python-dotenv click rich
```

### 3. Configurar API Key

#### Opção A: Variável de Ambiente

```bash
# Linux/Mac
export ANTHROPIC_API_KEY="sua-chave-aqui"

# Windows (PowerShell)
$env:ANTHROPIC_API_KEY = "sua-chave-aqui"

# Windows (CMD)
set ANTHROPIC_API_KEY=sua-chave-aqui
```

#### Opção B: Arquivo .env

```bash
# .env (na mesma pasta do script)
ANTHROPIC_API_KEY=sua-chave-aqui
```

#### Opção C: Parâmetro CLI

```bash
python sdd-pipeline-executor.py --spec SPEC.md --api-key sua-chave-aqui
```

---

## 🚀 Uso Rápido

### Passo 1: Prepare sua Especificação

Crie arquivo `SPEC.md`:

```markdown
# Sistema de Tarefas (Task Manager)

## Requisitos Funcionais
- REQ-001: Usuário pode criar tarefa
- REQ-002: Usuário pode listar tarefas
...

## Regras de Negócio
- BR-001: Título obrigatório
- BR-002: Máximo 200 caracteres
...
```

### Passo 2: Execute o Pipeline

```bash
python sdd-pipeline-executor.py --spec SPEC.md --output ./projeto-sdd
```

### Passo 3: Aguarde

O executor vai:
1. Ler sua especificação
2. Chamar cada agente sequencialmente
3. Gerenciar outputs
4. Validar conformidade
5. Gerar relatórios

**Tempo**: ~20-30 minutos (dependendo da complexidade)

### Passo 4: Verifique Resultados

```
projeto-sdd/
├── specs/
│   ├── TECHNICAL_SPECIFICATION.md
│   ├── TRACEABILITY_MATRIX.md
│   └── TECHNICAL_DECISIONS.md
├── reports/
│   ├── SDD_COMPLIANCE_REPORT.md
│   ├── TEST_COVERAGE_REPORT.md
│   ├── CODE_REVIEW_REPORT.md
│   └── BUILD_TEST_REPORT.md
└── code/
    └── implementation.ts
```

---

## 📋 Opções CLI

### Usar Modelo Mais Rápido

```bash
python sdd-pipeline-executor.py \
  --spec SPEC.md \
  --model claude-sonnet-4-5
```

### Pular Swagger Tester

```bash
python sdd-pipeline-executor.py \
  --spec SPEC.md \
  --skip-swagger
```

### Output Customizado

```bash
python sdd-pipeline-executor.py \
  --spec SPEC.md \
  --output /tmp/meu-projeto
```

### Todas as Opções

```bash
python sdd-pipeline-executor.py \
  --spec ./SPEC.md \
  --output ./projeto-sdd \
  --api-key sk-ant-... \
  --model claude-opus-4-5 \
  --skip-swagger
```

---

## 🔄 Fluxo Automático

```
📖 Especificação
    ↓ (você fornece)
🎯 Orchestrator (validação)
    ↓ (automático)
🏛️  Architect-SDD
    ↓ Gera: TECHNICAL_SPECIFICATION.md
    ↓ Gera: TRACEABILITY_MATRIX.md
    ↓ Gera: TECHNICAL_DECISIONS.md
    ↓
🔷 Specialist (.NET/React)
    ↓ Gera: código implementado
    ↓ Gera: 100% testes
    ↓
📋 Compliance Validator
    ↓ ✅ CONFORME? Continua
    ↓ ❌ NÃO CONFORME? Redireciona → Specialist
    ↓
🧪 Test Validator
    ↓ ✅ 100% COBERTURA? Continua
    ↓ ❌ INSUFICIENTE? Redireciona → Specialist
    ↓
🔍 Code Review
    ↓ ✅ APROVADO? Continua
    ↓ ❌ REJEITADO? Redireciona → Specialist
    ↓
🏗️  Build & Test
    ↓ ✅ BUILD PASSOU? Continua
    ↓ ❌ BUILD FALHOU? Redireciona → Specialist
    ↓
📝 Commit Message
    ↓ Gera: commits semânticos
    ↓ Gera: script.sh
    ↓
🧪 Swagger Tester (opcional)
    ↓ Gera: SWAGGER_TEST_WORKFLOW.md
    ↓
✅ PIPELINE COMPLETO!
```

---

## 📊 Validação Automática

O executor valida automaticamente:

### Compliance
```
- Requisitos funcionais foram atendidos?
- Regras de negócio foram implementadas?
- Entidades de domínio estão corretas?
```

### Testes
```
- 100% Application Layer coverage?
- Todos os casos de teste cobertos?
- Sem testes falhando?
```

### Code Review
```
- SOLID Principles aplicados?
- Clean Architecture seguida?
- Clean Code praticado?
- Performance aceitável?
- Segurança validada?
```

### Build
```
- Compila sem erros?
- Sem warnings críticos?
- Testes passam?
```

**Se qualquer validação falhar** → redireciona para Specialist novamente

---

## 🎯 Exemplo Real

### 1. Criar SPEC.md

```markdown
# Sistema de Gestão de Tarefas

## Requisitos Funcionais
- REQ-001: Usuário pode se registrar
- REQ-002: Usuário pode fazer login
- REQ-003: Criar tarefa
- REQ-004: Listar tarefas
- REQ-005: Completar tarefa

## Regras de Negócio
- BR-001: Senha mínimo 8 caracteres
- BR-002: Email único
- BR-003: Tarefas concluídas não podem ser editadas

## Entidades
- User (id, email, password, createdAt)
- Task (id, userId, title, status, createdAt)
```

### 2. Executar Pipeline

```bash
python sdd-pipeline-executor.py --spec SPEC.md --output task-manager-sdd
```

### 3. Acompanhar Execução

```
🚀 Iniciando Pipeline SDD Automático
================================================================================
📖 [0/9] Carregando especificação...
✅ Especificação carregada: 450 caracteres

🎯 [1/9] Orchestrator-SDD (você fornece spec)
   → Especificação carregada com sucesso

🏛️  [2/9] Executando Arquiteto SDD...
   → Chamando Claude API...
   ✅ Sucesso
   📄 Salvo: specs/TECHNICAL_SPECIFICATION.md
   📄 Salvo: specs/TRACEABILITY_MATRIX.md
   📄 Salvo: specs/TECHNICAL_DECISIONS.md

🔷 [3/9] Executando Specialist (Backend/Frontend)...
   → Chamando Claude API...
   ✅ Sucesso
   📄 Salvo: code/implementation.ts

📋 [4/9] Validando Conformidade SDD...
   → Chamando Claude API...
   ✅ Sucesso

🧪 [5/9] Validando Cobertura de Testes...
   → Chamando Claude API...
   ✅ Sucesso

🔍 [6/9] Executando Code Review...
   → Chamando Claude API...
   ✅ Sucesso

🏗️  [7/9] Executando Build & Tests...
   → Chamando Claude API...
   ✅ Sucesso

📝 [8/9] Gerando Commits Semânticos...
   → Chamando Claude API...
   ✅ Sucesso
   📄 Salvo: commits.sh

🧪 [9/9] Gerando Workflow de Testes Swagger...
   → Chamando Claude API...
   ✅ Sucesso
   📄 Salvo: reports/SWAGGER_TEST_WORKFLOW.md

================================================================================
✅ PIPELINE CONCLUÍDO COM SUCESSO!
================================================================================

📁 Arquivos salvos em: /home/user/task-manager-sdd

Documentos gerados:
  • /home/user/task-manager-sdd/specs/TECHNICAL_SPECIFICATION.md
  • /home/user/task-manager-sdd/specs/TRACEABILITY_MATRIX.md
  • /home/user/task-manager-sdd/specs/TECHNICAL_DECISIONS.md
  • /home/user/task-manager-sdd/reports/SDD_COMPLIANCE_REPORT.md
  • /home/user/task-manager-sdd/reports/TEST_COVERAGE_REPORT.md
  • /home/user/task-manager-sdd/reports/CODE_REVIEW_REPORT.md
  • /home/user/task-manager-sdd/reports/BUILD_TEST_REPORT.md
  • /home/user/task-manager-sdd/code/

📊 Relatório de execução:
  ✅ [2024-01-15T10:30:00] Orchestrator: Especificação recebida
  ✅ [2024-01-15T10:35:45] Architect: Execução bem-sucedida
  ✅ [2024-01-15T10:42:30] Specialist: Execução bem-sucedida
  ✅ [2024-01-15T10:48:15] Compliance: Execução bem-sucedida
  ✅ [2024-01-15T10:55:00] TestValidator: Execução bem-sucedida
  ✅ [2024-01-15T11:02:45] CodeReview: Execução bem-sucedida
  ✅ [2024-01-15T11:08:30] BuildTest: Execução bem-sucedida
  ✅ [2024-01-15T11:14:15] CommitMessage: Execução bem-sucedida
  ✅ [2024-01-15T11:20:00] SwaggerTester: Execução bem-sucedida
```

**Tempo total**: 25 minutos ⚡

---

## 🔄 Tratamento de Erros

### Se Compliance Falhar

```
❌ Código não conforme com spec
   → Redirecionando para Specialist...
   🔷 Specialist (.NET) executado novamente
   → Compliance validado novamente
   ✅ Passou
```

### Se Testes Falharem

```
❌ Cobertura insuficiente
   → Redirecionando para Specialist...
   🔷 Specialist (.NET) executado novamente
   → Test Validator executado novamente
   ✅ 100% cobertura atingida
```

### Se Code Review Falhar

```
❌ Código não aprovado
   → Redirecionando para Specialist...
   🔷 Specialist (.NET) executado novamente
   → Code Review executado novamente
   ✅ Aprovado
```

**Máximo 3 tentativas** por validação (configurável)

---

## 📈 Métricas

Ao final, você recebe:

```json
{
  "total_agents_executed": 9,
  "total_retries": 0,
  "success_rate": "100%",
  "total_time": "25 minutes",
  "api_calls": 9,
  "documents_generated": 8,
  "code_lines": 1250,
  "test_coverage": "100%",
  "compliance_status": "COMPLIANT"
}
```

---

## 🆘 Troubleshooting

### "API Key inválida"

```bash
# Verificar que a variável está setada
echo $ANTHROPIC_API_KEY

# Se vazio, setar
export ANTHROPIC_API_KEY="sua-chave"
```

### "Arquivo SPEC.md não encontrado"

```bash
# Verificar que o arquivo existe
ls -la SPEC.md

# Se não existe, criar
cat > SPEC.md << 'EOF'
# Meu Projeto
...
EOF
```

### "Timeout na API"

O executor automaticamente faz retry até 3 vezes com delay de 5 segundos.

### "Modelo não disponível"

```bash
# Use modelo mais rápido
python sdd-pipeline-executor.py --spec SPEC.md --model claude-sonnet-4-5
```

---

## 🔐 Segurança

### Proteção de API Key

✅ **Não commite** `ANTHROPIC_API_KEY`  
✅ Use variáveis de ambiente  
✅ Use `.env` com `.gitignore`  

```bash
# .gitignore
.env
.env.local
```

### Proteção de Outputs

Os outputs são salvos **localmente**, não enviados para servidores externos (exceto API do Claude).

---

## 📚 Próximas Ações

### Após Pipeline Completar

```bash
cd task-manager-sdd

# 1. Revisar especificação técnica
cat specs/TECHNICAL_SPECIFICATION.md

# 2. Revisar código
cat code/implementation.ts

# 3. Executar commits
bash commits.sh

# 4. Deploy
npm install && npm run build
```

---

## 🎓 Aprendizado

Usando o Pipeline Executor você:

✅ Aprende como automatizar desenvolvimento com IA  
✅ Vê o poder da integração de agentes  
✅ Experimenta TDD automático  
✅ Obtém código profissional em minutos  

---

## 🚀 Performance

| Modelo | Velocidade | Qualidade | Recomendado para |
|--------|-----------|----------|-----------------|
| claude-opus-4-5 | Mais lento | Melhor | Projetos complexos |
| claude-sonnet-4-5 | Mais rápido | Boa | Protótipos rápidos |

---

**Pronto para executar seu pipeline automaticamente!** 🤖

Próxima ação: `python sdd-pipeline-executor.py --spec SPEC.md`
