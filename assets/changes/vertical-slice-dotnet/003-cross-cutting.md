# 003 - Cross-Cutting

## Objetivo
Implementar as preocupações compartilhadas entre todas as slices de `<nome do projeto>`: tratamento de erro, autenticação e logging.

## Escopo
- Entra: middleware/handler de exceção global, autenticação básica (mesmo que esqueleto de exemplo, documentado como tal), logging estruturado.
- Não entra: lógica de negócio de slice específica.

## Entregáveis esperados
- Tratamento de erro padronizado (erro de domínio → 400, não encontrado → 404, não tratado → 500 sem vazar stack trace).
- Autenticação configurada e aplicada a pelo menos uma rota de exemplo.
- Logging estruturado configurado, sem dados sensíveis nos logs.

## Critérios de aceite
- [ ] Erro não tratado não vaza stack trace ao cliente.
- [ ] Pelo menos uma rota protegida por autenticação/autorização, testada (200 com credencial válida, 401/403 sem).
- [ ] Logging estruturado configurado (propriedades nomeadas, não concatenação de string).

## Skills relevantes
- `dotnet-security-audit`
- `dotnet-observability`
- `dotnet-secrets`
