---
description: Cria um novo projeto .NET com estrutura SDD completa (commands/ + agents/ prontos) para rodar o pipeline de 9 agentes depois
argument-hint: [nome-do-projeto]
---

# /criar-template-claude — Criar Novo Projeto SDD

Crie um novo projeto usando o script de scaffolding deste plugin.

## O Que Fazer

1. Se o usuário não informou um nome de projeto no argumento, pergunte qual nome usar.
2. Execute o script de criação:
   ```bash
   bash "${CLAUDE_PLUGIN_ROOT}/criar-template-claude-sdd-plugin.sh" NOME_DO_PROJETO
   ```
3. Confirme para o usuário que o projeto foi criado e explique os próximos passos:
   - Entrar na pasta do projeto criado
   - Editar `docs/SPEC.md` com a especificação da aplicação
   - Rodar `/orchestrator` dentro do projeto para disparar os 9 agentes automaticamente

## Resultado Esperado

O script cria a seguinte estrutura dentro de `NOME_DO_PROJETO/`:

```
NOME_DO_PROJETO/
├── commands/
│   ├── orchestrator.md    ← comando que o usuário vai chamar depois
│   └── README.md
├── agents/                 ← 9 subagentes especializados, prontos
├── docs/SPEC.md            ← template para o usuário preencher
├── output/
└── src/ (Domain, Application, Infrastructure, API, Tests)
```

## Observação

Este comando apenas cria a estrutura do projeto. Ele **não** executa o pipeline SDD — isso é feito depois, de dentro do projeto criado, com `/orchestrator`.
