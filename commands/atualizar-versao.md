---
description: Atualiza este plugin (sdd) para a versão mais recente disponível no marketplace
argument-hint: (nenhum argumento)
allowed-tools: Bash(claude plugin marketplace update:*), Bash(claude plugin update:*), Bash(claude plugin list:*)
---

# /atualizar-versao — Atualizar o plugin para a versão mais recente

## O que fazer

1. Rode `claude plugin list --json` e localize o objeto com `"id": "sdd@christian-criar-template-claude"`.
   Guarde o `version` atual. Se o plugin não aparecer na lista, avise que ele não está instalado nesta
   máquina/escopo (rode `/plugin install sdd@christian-criar-template-claude`
   primeiro) e pare.

2. Sincronize o marketplace com o repositório remoto:
   ```
   claude plugin marketplace update christian-criar-template-claude
   ```

3. Atualize o plugin para o que acabou de ser sincronizado:
   ```
   claude plugin update sdd@christian-criar-template-claude -y
   ```
   A própria saída já diz se atualizou (e de qual versão para qual) ou se já estava na mais recente — não
   precisa rodar `claude plugin list` de novo pra confirmar, a menos que o texto da saída fique ambíguo.

4. Reporte o resultado ao usuário:
   - Se atualizou: **"Atualizado de X para Y. Reinicie a sessão do Claude Code (feche e abra de novo) para
     os comandos e agentes novos entrarem em vigor"** — o próprio `claude plugin update` exige restart pra
     aplicar, não é algo que dê pra contornar de dentro da sessão atual.
   - Se já estava na mais recente: diga a versão e que não havia nada para atualizar.

## Observação

Isso atualiza só este plugin — não mexe em outros marketplaces ou plugins instalados.
