---
name: angular-documentation
description: Use ao documentar componentes Angular (Compodoc/Storybook) ou ao criar/atualizar o README do projeto (especificação, diagramas, exemplos de uso, funcionalidades implementadas, to-do). Disparar sempre que uma nova funcionalidade for implementada.
---

# Documentação Angular

1. Documente componentes reutilizáveis com Storybook (stories mostrando variações de props/estado) ou comentários JSDoc compatíveis com Compodoc.
2. Mantenha o `README.md` na raiz com, no mínimo:
   - **Especificação/visão geral** — o que o projeto faz, principais tecnologias (versão do Angular, state management usado).
   - **Arquitetura** — diagrama (Mermaid) da estrutura de módulos/features principais.
   - **Como rodar localmente** — `npm install`, `ng serve`, variáveis de ambiente necessárias.
   - **Exemplo de uso** — descrição/screenshot do fluxo principal, ou snippet de uso de um componente compartilhado.
   - **Funcionalidades implementadas** — lista objetiva.
   - **To-do** — checklist markdown (`- [ ]` pendente / `- [x]` concluído).
3. Regra de atualização: toda vez que uma nova funcionalidade for implementada, atualize o README no mesmo PR/commit — mova o item de "To-do" para "Funcionalidades implementadas" e ajuste exemplo/diagrama se necessário.
