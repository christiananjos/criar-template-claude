---
name: angular-secrets
description: Use ao configurar environment files ou variáveis de build em projetos Angular, e antes de commitar/dar push para checar vazamento de segredo no bundle.
---

# Configuração e segredos Angular

1. **Tudo que vai para `environment.ts`/`environment.prod.ts` é público** — o bundle roda no browser do usuário e pode ser inspecionado. Nunca coloque chave de API secreta, connection string ou credencial ali.
2. Chaves que precisam ficar privadas (ex: chave de API de terceiro com custo por uso) devem passar por um proxy no backend — o frontend nunca chama o serviço terceiro diretamente com a chave.
3. Configuração pública (URL de API, feature flags não sensíveis) pode ir em `environment.*.ts` normalmente.
4. Para configuração que muda por ambiente de deploy sem rebuild, prefira injeção via `index.html`/arquivo `config.json` carregado em runtime, não hardcoded no bundle.
5. Antes de qualquer commit/push, verificar se algum arquivo alterado contém string que parece segredo — mesmo em `environment.ts` aparentemente inofensivo.
