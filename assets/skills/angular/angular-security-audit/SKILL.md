---
name: angular-security-audit
description: Use ao realizar auditoria de segurança em projetos Angular (XSS, dependências vulneráveis, exposição de dados no bundle client-side).
---

# Auditoria de segurança Angular

1. Rode `npm audit` (ou `npm audit --production`) e trate vulnerabilidades de severidade alta/crítica como bloqueantes até mitigadas.
2. Nunca use `[innerHTML]` com conteúdo não sanitizado do usuário, nem `bypassSecurityTrustHtml`/`bypassSecurityTrustResourceUrl` sem justificativa forte e revisão — é a principal porta de XSS em Angular.
3. Confirme que o Angular está sanitizando bindings por padrão (não desabilite globalmente `DomSanitizer`).
4. Verifique CSP (Content-Security-Policy) configurada no servidor/hosting, restringindo origens de script.
5. Nenhum segredo, chave de API privada ou lógica sensível de autorização deve viver só no frontend — o backend precisa validar tudo de novo (o frontend só melhora UX, nunca é a única barreira de segurança).
6. Segredos e configuração seguem o skill `angular-secrets`.
