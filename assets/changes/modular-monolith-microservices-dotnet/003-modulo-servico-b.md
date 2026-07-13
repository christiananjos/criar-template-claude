# 003 - Módulo/Serviço B

## Objetivo
Implementar o segundo módulo/serviço de `<nome do projeto>`, provando o isolamento e a comunicação real entre módulos/serviços definida no `SharedKernel`.

## Escopo
- Entra: domínio, aplicação, infraestrutura e API/handler do segundo módulo/serviço; a comunicação real com o módulo/serviço A (evento de integração ou chamada HTTP, conforme decidido na etapa 001).
- Não entra: alterar a lógica interna do módulo/serviço A além do necessário para expor o contrato já definido no `SharedKernel`.

## Entregáveis esperados
- Módulo/serviço B completo, comunicando-se com A apenas via `SharedKernel` (evento ou contrato HTTP), nunca por referência direta a classes internas de A.
- Teste (unitário ou de integração) comprovando que a comunicação entre A e B funciona conforme o contrato.

## Critérios de aceite
- [ ] Módulo/serviço builda e roda isoladamente.
- [ ] Comunicação com o módulo/serviço A comprovada por teste, usando apenas o contrato do `SharedKernel`.
- [ ] Cobertura de teste >= 80% no domínio/aplicação deste módulo/serviço.

## Skills relevantes
- `dotnet-scaffolding`
- `dotnet-resilience` (se a comunicação for síncrona via HTTP)
- `dotnet-unit-testing`
- `dotnet-integration-testing`
