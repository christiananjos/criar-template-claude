# criar-template-claude

Plugin do Claude Code que gera a estrutura de projeto padrão (`.claude/agents`, `commands`, `skills`, `hooks`, `CLAUDE.md`, `.gitignore`, hook de segurança contra commit de segredos, etc.) para projetos `.NET`, `Angular` ou Full-stack (`.NET` + `Angular`).

A arquitetura (Clean Architecture, Vertical Slice, Modular Monolith, ...) não é escolhida no scaffold inicial — fica para a primeira execução das skills `dotnet-scaffolding` / `angular-scaffolding`, que investigam o projeto e perguntam ao usuário antes de gerar a sequência de bootstrap em `changes/`.

## Instalação

```
/plugin marketplace add christiananjos/criar-template-claude
/plugin install criar-template-claude@criar-template-claude
```

(Substitua `christiananjos` pelo owner/repo reais depois de publicar no GitHub.)

## Uso

```
/criar-template-claude:criar-template-claude
```

O comando pergunta o nome e o tipo do projeto, cria a estrutura no destino escolhido e copia apenas as skills relevantes à stack selecionada.

## Estrutura deste repositório

- `.claude-plugin/plugin.json` — manifest do plugin.
- `.claude-plugin/marketplace.json` — catálogo do marketplace (este mesmo repo).
- `commands/criar-template-claude.md` — o comando que o usuário aciona.
- `assets/` — todo o conteúdo estático copiado/adaptado para o projeto destino (templates, skills de `.NET`/`Angular`, agent e command de exemplo, hook de segurança, sequências de bootstrap em `changes/`). Para mudar o conteúdo gerado, edite os arquivos aqui — nunca duplique conteúdo dentro de `commands/criar-template-claude.md`.

## Desenvolvimento local

```
claude --plugin-dir /caminho/para/este/repo
/criar-template-claude:criar-template-claude
```

Ou, para testar via marketplace local:

```
/plugin marketplace add ./caminho/para/este/repo
/plugin install criar-template-claude@criar-template-claude
```
