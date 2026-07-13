---
name: dotnet-scaffolding
description: Use ao gerar novos endpoints, controllers, DTOs ou handlers CQRS em projetos .NET, seguindo o padrão de arquitetura já estabelecido no projeto (Clean Architecture, DDD, Vertical Slice, etc). Na primeira execução em um projeto sem arquitetura definida, também decide e registra essa arquitetura antes de gerar qualquer código.
---

# Scaffolding de código .NET

## 0. Garantir que a arquitetura do backend está definida

Verifique se já existe `docs/arquitetura-backend.md` no projeto.

- **Se existir**: leia-o, use a arquitetura ali registrada e vá direto para "Antes de gerar código novo".
- **Se não existir** (primeira vez que esta skill roda neste projeto):
  1. Investigue pistas em `docs/` (specs de produto, requisitos não-funcionais, volume/escala esperada, tamanho da equipe) e no que já existe no projeto (`CLAUDE.md`, código já escrito) para embasar uma recomendação.
  2. Apresente ao usuário, via `AskUserQuestion`, as opções de arquitetura — Clean Architecture, DDD, Vertical Slice, Modular Monolith, Microservices, ou Outra (texto livre) — destacando qual você recomenda e por quê, com base no que investigou.
  3. Registre a decisão e a justificativa em `docs/arquitetura-backend.md` (crie o arquivo).
  4. Copie a sequência de bootstrap correspondente de `$HOME/.claude/templates/criar-template-claude/changes/<pasta>/` para `<projeto>/changes/`, numerando os arquivos a partir do maior `NNN` já existente em `changes/` + 1 (evita colidir com fases/features já criadas — relevante em projetos full-stack onde `angular-scaffolding` já pode ter rodado). Substitua `<nome do projeto>` pelo título do `CLAUDE.md` do projeto em cada arquivo copiado. Mapeamento:
     - Clean Architecture ou DDD → pasta `clean-architecture-dotnet/`
     - Vertical Slice → pasta `vertical-slice-dotnet/`
     - Modular Monolith ou Microservices → pasta `modular-monolith-microservices-dotnet/` (pergunte ao usuário os nomes reais dos módulos/serviços e renomeie `002-modulo-servico-a.md`, `003-modulo-servico-b.md`, `004-composicao-gateway.md` de acordo)
     - Outra → monte manualmente 4-8 arquivos `0NN-*.md` seguindo a mesma progressão (base → domínio/núcleo → integrações → interface → testes → CI/CD), adaptados à arquitetura descrita.
  5. Gere `changes/executar-todas.md` a partir de `$HOME/.claude/templates/criar-template-claude/executar-todas.md.template` com a lista real de fases — se o arquivo já existir (ex: `angular-scaffolding` rodou antes), acrescente as novas fases à lista existente em vez de sobrescrever.
  6. Avise o usuário que a sequência de bootstrap foi criada em `changes/` e pergunte se prefere rodá-la (`changes/executar-todas.md`) antes de continuar com o scaffolding pontual pedido, ou seguir direto para ele.

## Antes de gerar código novo

1. Peça ao usuário a especificação da funcionalidade (o que faz, entradas/saídas, regras de negócio, dependências externas). Não comece a gerar código sem isso.
2. Se o usuário não indicar qual design pattern usar, investigue qual é o mais adequado ao problema descrito, sempre respeitando Clean Code e Clean Architecture (baixo acoplamento, responsabilidade única, dependências apontando para dentro do domínio). Use a tabela de referência abaixo para identificar o padrão pelo tipo de problema — não force um padrão onde a solução mais simples já resolve.
3. Identifique o padrão de arquitetura do projeto (verifique `CLAUDE.md`, `docs/arquitetura-backend.md` e a estrutura de pastas existente: `Controllers/`, `Features/`, `Application/`, `Domain/`, `Infrastructure/`).
4. Siga a convenção já usada por features existentes similares — não introduza um padrão novo (ex: não misture MediatR com chamada direta a serviço na mesma camada).
5. Para Minimal API: agrupe endpoints relacionados em um único arquivo de extensão (`MapXEndpoints`).
6. Para Controllers: um controller por agregado/recurso, actions finas delegando para a camada de aplicação.
7. DTOs de entrada/saída não devem vazar entidades de domínio diretamente — sempre mapear.
8. Se o projeto usa CQRS/MediatR, todo novo caso de uso vira um `Command`/`Query` + `Handler`, nunca lógica direto no controller.

## Guia de seleção de design pattern

| Categoria | Padrão | Propósito (o que faz?) | Exemplo de uso prático |
|---|---|---|---|
| Criacional | Singleton | Instância única global. | Conexão com Banco de Dados / Log. |
| Criacional | Factory | Delega a criação de objetos. | Criar diferentes tipos de Notificações (SMS, Email). |
| Criacional | Builder | Construção passo a passo. | Gerar um Relatório complexo com vários filtros opcionais. |
| Estrutural | Adapter | Traduz interfaces incompatíveis. | Integrar um Gateway de Pagamento antigo ao sistema novo. |
| Estrutural | Facade | Interface simples para sistema complexo. | Um método `FinalizarCompra()` que chama Estoque, Pagamento e Frete. |
| Estrutural | Decorator | Adiciona funções sem herança. | Adicionar "Criptografia" em cima de um gravador de arquivos. |
| Estrutural | Proxy | Controle de acesso / Intermediário. | Fazer Cache de uma chamada de API pesada ou verificar Permissões. |
| Comportamental | Strategy | Troca de algoritmos no runtime. | Diferentes regras de cálculo de Desconto ou Frete. |
| Comportamental | Observer | Notifica vários interessados. | Avisar o Estoque e o Marketing quando um produto é vendido. |
| Comportamental | State | Comportamento varia conforme status. | Fluxo de um Pedido (Aguardando -> Pago -> Entregue). |
| Comportamental | Command | Transforma ação em objeto. | Implementar botão de "Desfazer" (Undo) ou fila de tarefas. |
| Comportamental | Template Method | Define o esqueleto de um processo. | Processar arquivos (Abre -> Lógica Específica -> Fecha). |

Ao escolher, priorize sempre o padrão mais simples que resolve o problema — só suba a complexidade (Strategy, State, Command) quando a regra de negócio realmente variar em runtime ou precisar de extensibilidade comprovada, não por antecipação.
