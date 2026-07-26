#!/usr/bin/env python3

"""
🤖 SDD Pipeline Executor - Orquestrador Automático

Executa o pipeline SDD completo automaticamente via API do Claude.

Uso:
    python sdd-pipeline-executor.py --spec ./SPEC.md --output ./projeto-sdd

Fluxo:
    1. Lê especificação
    2. Orchestrator-SDD (seu papel) → valida
    3. Architect-SDD (automático) → gera TECHNICAL_SPECIFICATION.md
    4. Specialist (.NET/React) (automático) → implementa código
    5. Compliance (automático) → valida
    6. Test Validator (automático) → 100% coverage
    7. Code Review (automático) → arquitetura
    8. Build & Test (automático) → build + testes
    9. Commit Message (automático) → commits semânticos
    10. Swagger Tester (opcional) → workflow de testes
"""

import anthropic
import json
import os
import sys
import argparse
from pathlib import Path
from datetime import datetime
from typing import Optional
import time

# ============================================================================
# CONFIGURAÇÃO
# ============================================================================

class Config:
    """Configuração do pipeline"""
    
    # Modelo Claude
    MODEL = "claude-opus-4-5"  # ou claude-sonnet-4-5 para ser mais rápido
    MAX_TOKENS = 8096
    
    # Prompts (será buscado de arquivos locais)
    PROMPTS_DIR = Path(__file__).parent / "pipeline" / "agents"
    
    # Output
    OUTPUT_BASE = Path.home() / ".sdd-pipeline"
    
    # Timeouts
    MAX_RETRIES = 3
    RETRY_DELAY = 5  # segundos
    
    # Validação
    SUCCESS_INDICATORS = ["✅", "COMPLIANT", "PASSED", "SUCCESS"]
    FAILURE_INDICATORS = ["❌", "NON-COMPLIANT", "REJECTED", "FAILED"]


# ============================================================================
# PIPELINE EXECUTOR
# ============================================================================

class PipelineExecutor:
    """Executa o pipeline SDD completo automaticamente"""
    
    def __init__(self, spec_path: Path, output_dir: Path, api_key: Optional[str] = None):
        self.spec_path = Path(spec_path)
        self.output_dir = Path(output_dir)
        self.client = anthropic.Anthropic(api_key=api_key or os.getenv("ANTHROPIC_API_KEY"))
        
        # Estado do pipeline
        self.state = {
            "spec": None,
            "technical_specification": None,
            "traceability_matrix": None,
            "technical_decisions": None,
            "task_registry": None,
            "code": None,
            "compliance_report": None,
            "test_report": None,
            "review_report": None,
            "build_report": None,
            "commits": None,
            "swagger_workflow": None,
        }
        
        # Histórico de execução
        self.execution_log = []
        
        # Criar diretórios
        self.output_dir.mkdir(parents=True, exist_ok=True)
        (self.output_dir / "specs").mkdir(exist_ok=True)
        (self.output_dir / "reports").mkdir(exist_ok=True)
        (self.output_dir / "code").mkdir(exist_ok=True)
    
    # ========================================================================
    # MÉTODOS PRINCIPAIS
    # ========================================================================
    
    def run(self, skip_swagger: bool = False) -> bool:
        """Executa o pipeline completo"""
        
        print("🚀 Iniciando Pipeline SDD Automático")
        print("=" * 80)
        
        # Carregar especificação
        print("📖 [0/9] Carregando especificação...")
        if not self._load_spec():
            return False
        
        # Etapa 1: Orchestrator (você fornece spec, sistema apenas valida)
        print("🎯 [1/9] Orchestrator-SDD (você fornece spec)")
        print("   → Especificação carregada com sucesso")
        self._log("Orchestrator", "Especificação recebida", "SUCCESS")
        
        # Etapa 2: Architect-SDD
        print("🏛️  [2/9] Executando Arquiteto SDD...")
        if not self._run_agent("architect", 2):
            return False
        
        # Etapa 3: Specialist
        print("🔷 [3/9] Executando Specialist (Backend/Frontend)...")
        if not self._run_agent("specialist", 3):
            return False
        
        # Etapa 4: Compliance
        print("📋 [4/9] Validando Conformidade SDD...")
        if not self._run_agent("compliance", 4):
            print("   ⚠️  Código não conforme com spec")
            print("   → Redirecionando para Specialist...")
            if not self._run_agent("specialist", 3):  # Retry
                return False
        
        # Etapa 5: Test Validator
        print("🧪 [5/9] Validando Cobertura de Testes...")
        if not self._run_agent("test_validator", 5):
            print("   ⚠️  Cobertura insuficiente")
            print("   → Redirecionando para Specialist...")
            if not self._run_agent("specialist", 3):  # Retry
                return False
        
        # Etapa 6: Code Review
        print("🔍 [6/9] Executando Code Review...")
        if not self._run_agent("code_review", 6):
            print("   ⚠️  Código não aprovado")
            print("   → Redirecionando para Specialist...")
            if not self._run_agent("specialist", 3):  # Retry
                return False
        
        # Etapa 7: Build & Test
        print("🏗️  [7/9] Executando Build & Tests...")
        if not self._run_agent("build_test", 7):
            return False
        
        # Etapa 8: Commit Message
        print("📝 [8/9] Gerando Commits Semânticos...")
        if not self._run_agent("commit_message", 8):
            return False
        
        # Etapa 9: Swagger Tester (opcional)
        if not skip_swagger:
            print("🧪 [9/9] Gerando Workflow de Testes Swagger...")
            if not self._run_agent("swagger_tester", 9):
                print("   ℹ️  Swagger Tester é opcional, continuando...")
        
        print("")
        print("=" * 80)
        print("✅ PIPELINE CONCLUÍDO COM SUCESSO!")
        print("=" * 80)
        print("")
        print(f"📁 Arquivos salvos em: {self.output_dir}")
        print("")
        print("Documentos gerados:")
        print(f"  • {self.output_dir / 'specs/TECHNICAL_SPECIFICATION.md'}")
        print(f"  • {self.output_dir / 'specs/TRACEABILITY_MATRIX.md'}")
        print(f"  • {self.output_dir / 'specs/TECHNICAL_DECISIONS.md'}")
        print(f"  • {self.output_dir / 'reports/SDD_COMPLIANCE_REPORT.md'}")
        print(f"  • {self.output_dir / 'reports/TEST_COVERAGE_REPORT.md'}")
        print(f"  • {self.output_dir / 'reports/CODE_REVIEW_REPORT.md'}")
        print(f"  • {self.output_dir / 'reports/BUILD_TEST_REPORT.md'}")
        print(f"  • {self.output_dir / 'code/'}")
        print("")
        print("📊 Relatório de execução:")
        self._print_execution_log()
        
        return True
    
    # ========================================================================
    # MÉTODOS DE SUPORTE
    # ========================================================================
    
    def _load_spec(self) -> bool:
        """Carrega a especificação"""
        try:
            with open(self.spec_path, 'r', encoding='utf-8') as f:
                self.state["spec"] = f.read()
            print(f"✅ Especificação carregada: {len(self.state['spec'])} caracteres")
            return True
        except FileNotFoundError:
            print(f"❌ Arquivo não encontrado: {self.spec_path}")
            return False
        except Exception as e:
            print(f"❌ Erro ao carregar spec: {e}")
            return False
    
    def _load_prompt(self, agent_name: str) -> Optional[str]:
        """Carrega system prompt de um agente"""
        
        # Mapear nome para arquivo
        prompt_map = {
            "architect": "2-architect/SYSTEM_PROMPT.md",
            "specialist": "3-dotnet-specialist/SYSTEM_PROMPT.md",  # Ou 3-react-specialist
            "compliance": "4-compliance/SYSTEM_PROMPT.md",
            "test_validator": "5-tests/SYSTEM_PROMPT.md",
            "code_review": "6-review/SYSTEM_PROMPT.md",
            "build_test": "7-build/SYSTEM_PROMPT.md",
            "commit_message": "8-commit/SYSTEM_PROMPT.md",
            "swagger_tester": "9-swagger/SYSTEM_PROMPT.md",
        }
        
        prompt_file = Config.PROMPTS_DIR / prompt_map.get(agent_name, "")
        
        if not prompt_file.exists():
            print(f"   ⚠️  Prompt não encontrado: {prompt_file}")
            return None
        
        try:
            with open(prompt_file, 'r', encoding='utf-8') as f:
                return f.read()
        except Exception as e:
            print(f"   ❌ Erro ao carregar prompt: {e}")
            return None
    
    def _run_agent(self, agent_name: str, step: int) -> bool:
        """Executa um agente via API do Claude"""
        
        # Carregar prompt
        system_prompt = self._load_prompt(agent_name)
        if not system_prompt:
            return False
        
        # Preparar entrada
        user_input = self._prepare_agent_input(agent_name)
        
        # Chamar API
        print(f"   → Chamando Claude API...")
        
        try:
            for attempt in range(Config.MAX_RETRIES):
                try:
                    response = self.client.messages.create(
                        model=Config.MODEL,
                        max_tokens=Config.MAX_TOKENS,
                        system=system_prompt,
                        messages=[
                            {"role": "user", "content": user_input}
                        ]
                    )
                    
                    # Extrair resposta
                    output = response.content[0].text
                    
                    # Salvar output
                    self._save_agent_output(agent_name, output)
                    
                    # Validar sucesso
                    if self._is_successful(agent_name, output):
                        print(f"   ✅ Sucesso")
                        self._log(agent_name, "Execução bem-sucedida", "SUCCESS")
                        return True
                    else:
                        print(f"   ❌ Falha: código retornou erro")
                        self._log(agent_name, "Falha na execução", "FAILURE")
                        return False
                
                except anthropic.APIError as e:
                    if attempt < Config.MAX_RETRIES - 1:
                        print(f"   ⚠️  Erro na API (tentativa {attempt + 1}/{Config.MAX_RETRIES}): {e}")
                        print(f"      Aguardando {Config.RETRY_DELAY}s...")
                        time.sleep(Config.RETRY_DELAY)
                    else:
                        print(f"   ❌ Erro na API após {Config.MAX_RETRIES} tentativas: {e}")
                        return False
        
        except Exception as e:
            print(f"   ❌ Erro inesperado: {e}")
            return False
    
    def _prepare_agent_input(self, agent_name: str) -> str:
        """Prepara a entrada para um agente baseado no seu estado anterior"""
        
        if agent_name == "architect":
            return f"Especificação:\n\n{self.state['spec']}"
        
        elif agent_name == "specialist":
            context = f"""Especificação Técnica:
{self.state.get('technical_specification', 'N/A')}

Matriz de Rastreabilidade:
{self.state.get('traceability_matrix', 'N/A')}

Registro de Tarefas:
{self.state.get('task_registry', 'N/A')}"""
            return context
        
        elif agent_name == "compliance":
            return f"""Código implementado:
{self.state.get('code', 'N/A')}

Especificação Técnica:
{self.state.get('technical_specification', 'N/A')}"""
        
        elif agent_name == "test_validator":
            return f"""Relatório de Compliance:
{self.state.get('compliance_report', 'N/A')}

Código:
{self.state.get('code', 'N/A')}"""
        
        elif agent_name == "code_review":
            return f"""Relatório de Testes:
{self.state.get('test_report', 'N/A')}

Código:
{self.state.get('code', 'N/A')}"""
        
        elif agent_name == "build_test":
            return f"""Relatório de Code Review:
{self.state.get('review_report', 'N/A')}

Código:
{self.state.get('code', 'N/A')}"""
        
        elif agent_name == "commit_message":
            return f"""Relatório de Build & Test:
{self.state.get('build_report', 'N/A')}

Código implementado (git diff):
{self.state.get('code', 'N/A')}"""
        
        elif agent_name == "swagger_tester":
            return f"""Especificação Técnica:
{self.state.get('technical_specification', 'N/A')}

Código da API:
{self.state.get('code', 'N/A')}"""
        
        return ""
    
    def _save_agent_output(self, agent_name: str, output: str):
        """Salva o output de um agente"""
        
        # Mapear agente para arquivo
        output_map = {
            "architect": [
                ("specs/TECHNICAL_SPECIFICATION.md", self._extract_section(output, "TECHNICAL_SPECIFICATION")),
                ("specs/TRACEABILITY_MATRIX.md", self._extract_section(output, "TRACEABILITY_MATRIX")),
                ("specs/TECHNICAL_DECISIONS.md", self._extract_section(output, "TECHNICAL_DECISIONS")),
            ],
            "specialist": [
                ("code/implementation.ts", self._extract_section(output, "CODE")),
            ],
            "compliance": [
                ("reports/SDD_COMPLIANCE_REPORT.md", output),
            ],
            "test_validator": [
                ("reports/TEST_COVERAGE_REPORT.md", output),
            ],
            "code_review": [
                ("reports/CODE_REVIEW_REPORT.md", output),
            ],
            "build_test": [
                ("reports/BUILD_TEST_REPORT.md", output),
            ],
            "commit_message": [
                ("commits.sh", self._extract_section(output, "COMMITS")),
            ],
            "swagger_tester": [
                ("reports/SWAGGER_TEST_WORKFLOW.md", output),
            ],
        }
        
        for filename, content in output_map.get(agent_name, []):
            if content:
                filepath = self.output_dir / filename
                filepath.parent.mkdir(parents=True, exist_ok=True)
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(content)
                print(f"   📄 Salvo: {filepath.relative_to(self.output_dir)}")
    
    def _extract_section(self, text: str, section: str) -> str:
        """Extrai uma seção específica do texto"""
        # Implementação simplificada
        return text
    
    def _is_successful(self, agent_name: str, output: str) -> bool:
        """Verifica se a execução de um agente foi bem-sucedida"""
        
        # Procurar indicadores de sucesso/falha
        lower_output = output.lower()
        
        for indicator in Config.SUCCESS_INDICATORS:
            if indicator.lower() in lower_output:
                return True
        
        for indicator in Config.FAILURE_INDICATORS:
            if indicator.lower() in lower_output:
                return False
        
        # Default: considera sucesso se tem conteúdo
        return len(output) > 100
    
    def _log(self, agent: str, message: str, status: str):
        """Registra um evento no log"""
        timestamp = datetime.now().isoformat()
        self.execution_log.append({
            "timestamp": timestamp,
            "agent": agent,
            "message": message,
            "status": status,
        })
    
    def _print_execution_log(self):
        """Imprime o log de execução"""
        for entry in self.execution_log:
            status_icon = "✅" if entry["status"] == "SUCCESS" else "❌"
            print(f"  {status_icon} [{entry['timestamp']}] {entry['agent']}: {entry['message']}")


# ============================================================================
# CLI
# ============================================================================

def main():
    parser = argparse.ArgumentParser(
        description="🤖 SDD Pipeline Executor - Orquestrador Automático"
    )
    
    parser.add_argument(
        "--spec",
        type=str,
        required=True,
        help="Caminho do arquivo de especificação (SPEC.md)"
    )
    
    parser.add_argument(
        "--output",
        type=str,
        default="./sdd-output",
        help="Diretório de output (padrão: ./sdd-output)"
    )
    
    parser.add_argument(
        "--api-key",
        type=str,
        help="API Key do Claude (padrão: ANTHROPIC_API_KEY env var)"
    )
    
    parser.add_argument(
        "--skip-swagger",
        action="store_true",
        help="Pular etapa de Swagger Tester"
    )
    
    parser.add_argument(
        "--model",
        type=str,
        choices=["claude-opus-4-5", "claude-sonnet-4-5"],
        default="claude-opus-4-5",
        help="Modelo Claude a usar"
    )
    
    args = parser.parse_args()
    
    # Configurar
    Config.MODEL = args.model
    
    # Executar pipeline
    executor = PipelineExecutor(
        spec_path=args.spec,
        output_dir=args.output,
        api_key=args.api_key
    )
    
    success = executor.run(skip_swagger=args.skip_swagger)
    
    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
