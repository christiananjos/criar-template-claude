---
name: dotnet-integration-testing
description: Use ao escrever ou revisar testes de integração ou de contrato de API em projetos .NET (WebApplicationFactory, Testcontainers, testes de contrato OpenAPI).
---

# Testes de integração .NET

1. Use `WebApplicationFactory<TEntryPoint>` para subir a aplicação em memória; não abra servidor real.
2. Para dependências de banco/fila, use Testcontainers em vez de mocks — testes de integração devem bater em infraestrutura real (containerizada), não em dublês.
3. Isole o estado entre testes: resete o banco (respawn/transaction rollback) a cada teste, não reutilize dados entre casos.
4. Para testes de contrato: valide que a resposta da API continua compatível com o schema OpenAPI publicado antes de mudar um endpoint existente.
5. Não duplique cobertura de teste unitário aqui — o objetivo é validar a integração entre camadas (HTTP → handler → banco), não regras de negócio isoladas.
