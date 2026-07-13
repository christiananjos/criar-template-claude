# 001 - Estrutura Base

## Objetivo
Configurar o esqueleto de `<nome do projeto>` em Vertical Slice: solução, projeto web, convenção de organização por feature e wiring básico de DI.

## Escopo
- Entra: criação da solução, projeto web, convenção de pasta `Features/<NomeDaFeature>/`, configuração base de DI, health check inicial de smoke-test.
- Não entra: qualquer lógica de negócio de feature específica (isso é a etapa 002).

## Entregáveis esperados
- Solução e projeto web criados, rodando localmente.
- Convenção de organização por feature documentada no README (cada slice é autocontida: request, handler, validação e acesso a dado vivem juntos na mesma pasta).
- Endpoint de smoke-test (`/health` ou equivalente) respondendo.

## Critérios de aceite
- [ ] Projeto builda e roda sem erro.
- [ ] Convenção de pastas por feature documentada no README.
- [ ] Endpoint de smoke-test responde 200.

## Skills relevantes
- `dotnet-scaffolding` — convenção de organização e escolha de padrão para o wiring inicial.
- `dotnet-cicd` — preparar o terreno para o pipeline da etapa 005.
