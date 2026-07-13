---
name: dotnet-security-audit
description: Use ao realizar auditoria de segurança em projetos .NET (checklist OWASP, dependências vulneráveis, autenticação/autorização).
---

# Auditoria de segurança .NET

1. Rode `dotnet list package --vulnerable --include-transitive` e trate qualquer achado como bloqueante até mitigado ou justificado.
2. Verifique autenticação/autorização: todo endpoint que não deveria ser público tem `[Authorize]` (ou equivalente em Minimal API) explícito — nunca confie em "esquecer" como padrão seguro.
3. Valide entrada de usuário em todos os limites (nunca confie em model binding sozinho para prevenir injeção/overposting) — use DTOs específicos, nunca bind direto em entidade de domínio.
4. Verifique proteção contra os itens do OWASP Top 10 relevantes a APIs: injeção (SQL via EF parametrizado, nunca `FromSqlRaw` com concatenação), controle de acesso quebrado, exposição de dados sensíveis em resposta de erro (nunca retornar stack trace em produção).
5. Confirme CORS restrito ao necessário (nunca `AllowAnyOrigin` em produção combinado com `AllowCredentials`).
6. Segredos e chaves seguem o skill `dotnet-secrets`.
