# 002 - Módulo/Serviço A

## Objetivo
Implementar o primeiro módulo (Modular Monolith) ou serviço (Microservices) de `<nome do projeto>` de ponta a ponta, servindo de referência para os próximos.

## Escopo
- Entra: domínio, aplicação, infraestrutura e API/handler do primeiro módulo/serviço, usando o `SharedKernel` da etapa 001.
- Não entra: lógica de outros módulos/serviços (isso é a etapa 003).

## Entregáveis esperados
- Módulo/serviço completo, isolado dos demais (sem referência direta a outro módulo/serviço fora do `SharedKernel`).
- Testes unitários e de integração cobrindo o fluxo principal.

## Critérios de aceite
- [ ] Módulo/serviço builda e roda isoladamente.
- [ ] Nenhuma referência direta a outro módulo/serviço além do `SharedKernel`.
- [ ] Cobertura de teste >= 80% no domínio/aplicação deste módulo/serviço.

## Skills relevantes
- `dotnet-scaffolding`
- `dotnet-ef-migrations` (se usar persistência própria)
- `dotnet-unit-testing`
- `dotnet-integration-testing`
