---
name: angular-unit-testing
description: Use ao escrever ou revisar testes unitários em projetos Angular (Jasmine/Karma ou Jest, TestBed, spies). Exige cobertura mínima de 80% no código novo.
---

# Testes unitários Angular

1. Teste componentes e serviços isoladamente — mocke dependências (`HttpClient`, serviços injetados) com spies (`jasmine.createSpyObj` ou `jest.fn()`), nunca bata em API real.
2. Siga o padrão AAA e nomeie o teste descrevendo cenário e resultado esperado (`should emit X when Y`).
3. Para componentes, prefira testar via `TestBed` + `fixture.detectChanges()`, validando o output renderizado/eventos emitidos — não o estado interno privado.
4. Para serviços com RxJS, use `TestScheduler`/marble testing ou `firstValueFrom` para asserts assíncronos determinísticos — nunca `setTimeout` arbitrário no teste.
5. Não duplique aqui o que é papel do `angular-e2e-testing`: unitário isola uma unidade; e2e valida o fluxo real no browser.
6. Rode `ng test --code-coverage` e verifique o relatório antes de considerar a tarefa concluída.
7. Cobertura mínima obrigatória: **80%** de linhas/branches no código novo ou alterado. Abaixo disso:
   - Identifique branches não cobertos (condicionais, tratamento de erro, estados de loading/erro em componentes) e escreva os testes que faltam.
   - Não infle a métrica com testes triviais de getter/setter sem lógica.
8. Trate código novo abaixo de 80% de cobertura como bloqueante para o PR, não como débito técnico para depois.
