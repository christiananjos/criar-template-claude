# 005 - Estrutura Frontend (Angular)

## Objetivo
Configurar o esqueleto do frontend Angular de `<nome do projeto>`, já apontando para a API real criada na etapa 004.

## Escopo
- Entra: `ng new`, roteamento base, shell da aplicação, `HttpClient` configurado com a URL da API (via `environment.ts`, sem segredo real), interceptor de erro.
- Não entra: features de negócio específicas (isso é a etapa 006).

## Entregáveis esperados
- Projeto Angular rodando localmente, consumindo pelo menos um endpoint real da API do backend.
- Roteamento e shell configurados.

## Critérios de aceite
- [ ] Frontend builda e roda, consumindo a API real (não mock) para pelo menos uma chamada de smoke-test.
- [ ] `environment.ts` sem segredo real (só URL pública da API).
- [ ] Interceptor de erro HTTP configurado.

## Skills relevantes
- `angular-scaffolding`
- `angular-secrets`
