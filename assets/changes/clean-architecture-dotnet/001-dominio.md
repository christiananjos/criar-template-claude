# 001 - Domínio

## Objetivo
Modelar o núcleo de domínio de `<nome do projeto>`: entidades, value objects e regras de negócio centrais, sem dependência de infraestrutura, banco de dados ou frameworks externos.

## Escopo
- Entra: entidades, value objects, enums de domínio, interfaces de repositório (contratos, sem implementação), exceções de domínio, regras de invariante.
- Não entra: acesso a banco de dados, chamadas HTTP, lógica de apresentação, DTOs de API.

## Entregáveis esperados
- Projeto/pasta `Domain` isolado, sem referência a Infrastructure ou Presentation.
- Entidades com construtores que garantem invariantes (não é possível criar um objeto em estado inválido).
- Interfaces de repositório definidas no domínio, implementadas depois na infraestrutura.

## Critérios de aceite
- [ ] Projeto de domínio compila isoladamente, sem depender de EF Core, ASP.NET ou qualquer pacote de infraestrutura.
- [ ] Regras de negócio centrais têm teste unitário cobrindo casos de sucesso e violação de invariante.
- [ ] Nenhuma entidade de domínio é exposta diretamente para fora da camada (sem vazamento de referência mutável).

## Nota
Se não houver domínio de negócio real ainda definido, modele um domínio de exemplo simples e coerente (ex: Pedidos) que sirva de referência para as próximas etapas — deixe isso explícito na especificação passada ao subagente.

## Skills relevantes
- `dotnet-scaffolding` — pedir a especificação de cada entidade/agregado e escolher o design pattern adequado.
- `dotnet-unit-testing` — cobertura mínima de 80% nas regras de domínio.
- `dotnet-code-quality` — nullable reference types, análise estática.
