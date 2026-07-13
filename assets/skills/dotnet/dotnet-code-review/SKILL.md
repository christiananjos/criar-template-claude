---
name: dotnet-code-review
description: Use ao revisar pull requests de projetos .NET, focando em convenções específicas da linguagem/runtime (async void, chamadas bloqueantes, disposal, uso de LINQ).
---

# Revisão de PR .NET

Ao revisar um PR .NET, verifique especificamente:

1. `async void` fora de handler de evento.
2. `.Result`, `.Wait()` ou `GetAwaiter().GetResult()` bloqueando código assíncrono.
3. `IDisposable`/`IAsyncDisposable` não descartado (`using`/`await using` ausente), especialmente `HttpClient`, `DbContext`, streams.
4. LINQ dentro de loop causando N+1 (ex: consultas repetidas em vez de materializar uma vez).
5. Exceções genéricas (`catch (Exception)`) engolindo erro sem log ou rethrow.
6. Migrations incluídas no PR sem revisão de segurança (ver skill `dotnet-ef-migrations`).
7. Segredos ou strings de conexão com credencial exposta no diff.
