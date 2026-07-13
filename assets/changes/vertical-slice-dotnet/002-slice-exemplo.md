# 002 - Slice de Exemplo

## Objetivo
Implementar uma slice completa de ponta a ponta em `<nome do projeto>`, servindo de referência replicável para todas as próximas features.

## Escopo
- Entra: request → validação → handler → acesso a dado → resposta, para UM caso de uso de exemplo (ex: se não houver domínio de negócio real definido, use algo simples e coerente).
- Não entra: infraestrutura completa de banco se ainda não decidida — use o mínimo necessário para provar o padrão (ex: EF Core simples ou repositório in-memory), documentando a escolha.

## Entregáveis esperados
- Uma slice completa (`Features/<Exemplo>/`) com request, handler, validação e acesso a dado.
- Teste unitário do handler e teste de integração do fluxo HTTP completo.
- Padrão de organização documentado no README como referência para a próxima feature.

## Critérios de aceite
- [ ] Slice builda e o fluxo funciona ponta a ponta (testado manualmente ou via teste de integração).
- [ ] Teste unitário cobrindo a lógica do handler.
- [ ] Teste de integração cobrindo o fluxo HTTP completo.

## Skills relevantes
- `dotnet-scaffolding`
- `dotnet-unit-testing`
- `dotnet-integration-testing`
