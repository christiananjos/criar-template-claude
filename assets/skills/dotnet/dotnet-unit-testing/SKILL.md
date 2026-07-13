---
name: dotnet-unit-testing
description: Use ao escrever ou revisar testes unitários em projetos .NET (xUnit, padrão AAA, mocks, cobertura de regras de negócio isoladas). Exige cobertura mínima de 80% no código novo.
---

# Testes unitários .NET

1. Um teste unitário testa uma unidade isolada (método/classe), sem tocar banco, rede, sistema de arquivos ou outras dependências externas — use dublês (mock/stub/fake) para isolar.
2. Siga o padrão AAA (Arrange, Act, Assert) e nomeie o teste descrevendo cenário e resultado esperado (ex: `MetodoX_QuandoY_DeveZ` ou `Should_Z_When_Y`).
3. Um teste, uma responsabilidade: evite múltiplos `Assert` não relacionados cobrindo comportamentos distintos no mesmo teste.
4. Use `xUnit` com `[Theory]`/`[InlineData]` para casos parametrizados em vez de duplicar testes quase idênticos.
5. Para mocks, use `NSubstitute` ou `Moq` — mocke apenas interfaces/dependências externas à unidade testada, nunca o próprio objeto sob teste.
6. Não teste detalhes de implementação privados — teste o comportamento público observável.
7. Não duplique aqui o que já é responsabilidade de `dotnet-integration-testing`: regra de negócio isolada é unitário; integração entre camadas (HTTP → handler → banco) é integração.
8. Rode `dotnet test --collect:"XPlat Code Coverage"` e verifique o relatório (ex: via `reportgenerator`) antes de considerar a tarefa concluída.
9. Cobertura mínima obrigatória: **80%** de linhas/branches no código novo ou alterado. Se ficar abaixo disso:
   - Identifique os métodos/branches não cobertos (condicionais, tratamento de erro, casos de borda) e escreva os testes que faltam.
   - Não infle a métrica com testes triviais (ex: testar getter/setter sem lógica) só para bater o número — cobertura é meio, não fim; o objetivo é cobrir comportamento relevante.
   - Se um trecho for genuinamente impraticável de testar (ex: código gerado, wrapper fino sobre API externa), documente o motivo em vez de forçar um teste artificial.
10. Trate código novo abaixo de 80% de cobertura como bloqueante para o PR, não como débito técnico para depois.
