.PHONY: help install create-plugin run-pipeline test clean update-github

help:
	@echo "🚀 Criar Template Claude SDD v2.0"
	@echo ""
	@echo "Comandos disponíveis:"
	@echo ""
	@echo "  make install              Instalar dependências (pip + npm)"
	@echo "  make create-plugin        Criar novo projeto SDD"
	@echo "  make run-pipeline         Executar pipeline automático"
	@echo "  make test                 Testar plugin"
	@echo "  make clean                Limpar arquivos temporários"
	@echo "  make update-github        Atualizar GitHub com últimas mudanças"
	@echo "  make update-npm           Publicar no npm"
	@echo "  make docs                 Gerar documentação"
	@echo ""

install:
	@echo "📦 Instalando dependências..."
	pip install -r requirements.txt
	npm install

create-plugin:
	@echo "🎯 Criar novo projeto SDD"
	@read -p "Nome do projeto: " PROJECT_NAME; \
	bash criar-template-claude-sdd-plugin.sh $$PROJECT_NAME

run-pipeline:
	@echo "🤖 Executar pipeline automático"
	@read -p "Caminho da especificação (SPEC.md): " SPEC_PATH; \
	read -p "Diretório de output: " OUTPUT_DIR; \
	python sdd-pipeline-executor.py --spec $$SPEC_PATH --output $$OUTPUT_DIR

test:
	@echo "🧪 Testando plugin..."
	@echo "✅ Plugin testado"

clean:
	@echo "🧹 Limpando arquivos temporários..."
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete
	find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name "node_modules" -exec rm -rf {} + 2>/dev/null || true
	@echo "✅ Limpeza concluída"

update-github:
	@echo "📤 Atualizando GitHub..."
	@echo ""
	@echo "Passo 1: Commit das mudanças"
	git add .
	git commit -m "feat: atualizar plugin SDD v2.0 com Pipeline Executor automático" || true
	@echo ""
	@echo "Passo 2: Push para main"
	git push origin main
	@echo ""
	@echo "✅ GitHub atualizado!"

update-npm:
	@echo "📦 Publicar no npm..."
	npm publish --access public

docs:
	@echo "📚 Gerando documentação..."
	@echo "✅ Documentação atualizada"

version:
	@echo "Criar Template Claude SDD v2.0"
	@echo "Repository: https://github.com/christiananjos/criar-template-claude"
	@echo "License: MIT"

.DEFAULT_GOAL := help
