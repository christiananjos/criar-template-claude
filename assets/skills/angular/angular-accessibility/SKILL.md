---
name: angular-accessibility
description: Use ao revisar ou implementar acessibilidade (a11y) em componentes Angular (ARIA, navegação por teclado, contraste, leitores de tela).
---

# Acessibilidade (a11y) Angular

1. Todo elemento interativo (botão, link, campo) deve ser alcançável e operável via teclado (`Tab`, `Enter`, `Space`) — nunca use `<div>`/`<span>` com `click` handler sem `role` e `tabindex` apropriados; prefira elementos nativos (`<button>`, `<a>`).
2. Use atributos ARIA (`aria-label`, `aria-describedby`, `aria-live`) quando o texto visível não for suficiente para leitores de tela, sem exagerar (ARIA incorreto é pior que ausência de ARIA).
3. Garanta contraste de cor mínimo (WCAG AA: 4.5:1 para texto normal) — não confie só em cor para transmitir estado (erro/sucesso), combine com ícone/texto.
4. Formulários: todo `<input>` precisa de `<label>` associado (ou `aria-label`), e erros de validação devem ser anunciados (`aria-live="polite"` ou similar).
5. Rode auditoria automatizada (axe-core/Lighthouse) no pipeline para pegar regressões óbvias — mas não trate como suficiente, revisão manual de navegação por teclado continua necessária.
