---
description: Cria um novo projeto .NET com estrutura SDD completa (commands/ + agents/ prontos) para rodar o pipeline de agentes depois
argument-hint: [nome-do-projeto]
---

# /criar-template-claude — Criar Novo Projeto SDD

Crie um novo projeto usando o script de scaffolding deste plugin.

## Fluxo de Confirmação (Apenas 2 Perguntas)

Faça **somente estas duas perguntas** ao usuário, uma de cada vez. Depois de respondidas, **execute tudo o resto automaticamente, sem pedir mais nenhuma confirmação**.

### Pergunta 1 — Pasta/nome do projeto

Se o usuário já informou o nome no argumento do comando, use-o diretamente e não pergunte de novo. Caso contrário, pergunte:

> "Qual o nome/pasta onde o projeto deve ser criado?"

### Pergunta 2 — Frontend

Pergunte qual frontend o usuário quer (isso muda de verdade quais agentes e arquivos são gerados):

> "Qual frontend você quer usar?
> 1. React
> 2. Angular
> 3. Vue
> 4. Nenhum (somente backend .NET)"

Mapeie a resposta para o parâmetro do script:

| Resposta do usuário | Parâmetro |
|---|---|
| React | `react` |
| Angular | `angular` |
| Vue | `vue` |
| Nenhum / só backend | `none` |

## A Partir Daqui — Tudo Automático

Depois das duas respostas, **não faça mais nenhuma pergunta**. Execute diretamente:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/criar-template-claude-sdd-plugin.sh" NOME_DO_PROJETO FRONTEND_ESCOLHIDO
```

Onde `FRONTEND_ESCOLHIDO` é um de: `react`, `angular`, `vue`, `none`.

E então:
1. Confirme que o projeto foi criado, mencionando a stack final (ex: ".NET 8 + React 18" ou ".NET 8 somente backend")
2. Explique os próximos passos, sem esperar resposta:
   - Entrar na pasta do projeto criado
   - Editar `docs/SPEC.md` com a especificação da aplicação
   - Rodar `/orchestrator` dentro do projeto para disparar os agentes automaticamente

## Resultado Esperado

O script cria a seguinte estrutura dentro de `NOME_DO_PROJETO/`:

```
NOME_DO_PROJETO/
├── commands/
│   ├── orchestrator.md    ← comando que o usuário vai chamar depois
│   └── README.md
├── agents/                 ← 9 agentes fixos + 1 de frontend (se escolhido)
├── docs/SPEC.md            ← template para o usuário preencher
├── output/
└── src/ (Domain, Application, Infrastructure, API, Tests)
```

O conteúdo de `commands/orchestrator.md`, `commands/README.md` e `docs/SPEC.md` já vem ajustado automaticamente para refletir a stack escolhida — não é preciso editar nada manualmente depois.

## Observação

Este comando apenas cria a estrutura do projeto. Ele **não** executa o pipeline SDD — isso é feito depois, de dentro do projeto criado, com `/orchestrator`. E o `/orchestrator`, por sua vez, também não deve parar para pedir confirmações extras no meio da cascata — só interrompe se um dos gates de qualidade (orchestrator-sdd, compliance-validator, code-review-sdd ou build-test-validator) reportar falha.


