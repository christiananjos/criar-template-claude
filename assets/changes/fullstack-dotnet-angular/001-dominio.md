# 001 - Domínio (Backend)

## Objetivo
Modelar o núcleo de domínio do backend .NET de `<nome do projeto>`: entidades, value objects e regras de negócio centrais.

## Escopo
- Entra: entidades, value objects, interfaces de repositório, regras de invariante.
- Não entra: infraestrutura, API, ou qualquer código do frontend Angular.

## Entregáveis esperados
- Projeto de domínio isolado, sem dependência de infraestrutura.
- Entidades com invariantes garantidas no construtor.

## Critérios de aceite
- [ ] Domínio compila isoladamente.
- [ ] Regras de negócio centrais têm teste unitário (sucesso e violação de invariante).
- [ ] Nenhuma entidade exposta com referência mutável para fora da camada.

## Skills relevantes
- `dotnet-scaffolding`
- `dotnet-unit-testing`
- `dotnet-code-quality`
