# 001 - Shared Kernel

## Objetivo
Definir os contratos e modelos compartilhados entre módulos/serviços de `<nome do projeto>`: eventos de domínio, DTOs compartilhados, convenções de nomeação e comunicação.

## Escopo
- Entra: eventos de integração/domínio compartilhados, contratos (interfaces) usados por mais de um módulo/serviço, convenções de versionamento de contrato.
- Não entra: lógica de negócio de um módulo/serviço específico.

## Entregáveis esperados
- Projeto/pacote `SharedKernel` (ou `Contracts`) isolado, referenciado pelos módulos/serviços mas sem depender deles.
- Convenção documentada de como módulos/serviços se comunicam (eventos assíncronos, HTTP síncrono, ou ambos) e por quê.

## Critérios de aceite
- [ ] Projeto compartilhado compila isoladamente, sem depender de nenhum módulo/serviço específico.
- [ ] Convenção de comunicação entre módulos/serviços documentada no README, com justificativa.
- [ ] Nenhum contrato compartilhado vaza detalhe de implementação interna de um módulo específico.

## Skills relevantes
- `dotnet-scaffolding`
- `dotnet-documentation` — registrar a decisão de comunicação como ADR.
