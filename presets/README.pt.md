# Presets

Templates de configuração de agente prontos para copiar, que conectam um projeto consumidor às skills **spec-kit** (planejamento) e **task-executor** (execução) deste repositório.

Estes arquivos **não** são skills. São instruções específicas de cada ferramenta que você copia para o projeto alvo, para o agente sempre rotear:

- **Planejamento** → `spec-kit` (e `spec-kit-architecture` quando necessário)
- **Execução** → uma das três variantes de executor

> **Idiomas:** Este é o README em português. Para a versão padrão (inglês), veja [README.md](README.md).

## Escolher o executor

| Pasta do preset | Quando usar |
|-----------------|-------------|
| `task-executor` | Projetos genéricos — sem roteamento automático de especialistas |
| `task-executor-m24h` | Projetos Mvp24Hours — invoca `skill-router` antes de implementar |
| `task-executor-architect` | Projetos que precisam selecionar skills de arquitetura automaticamente |

## Matriz ferramenta × executor

| Ferramenta | Caminho dentro do preset | Destino no projeto |
|------------|--------------------------|--------------------|
| Cursor | `.cursor/rules/spec-driven-workflow.mdc` | `<projeto>/.cursor/rules/` |
| VS Code (Copilot) | `.github/copilot-instructions.md` | `<projeto>/.github/` |
| Claude Code | `CLAUDE.md` | `<projeto>/CLAUDE.md` |
| Kiro | `.kiro/steering/spec-driven-workflow.md` | `<projeto>/.kiro/steering/` |

Layout completo:

```text
presets/
├── cursor/{task-executor,task-executor-m24h,task-executor-architect}/
├── vscode/{task-executor,task-executor-m24h,task-executor-architect}/
├── claude-code/{task-executor,task-executor-m24h,task-executor-architect}/
└── kiro/{task-executor,task-executor-m24h,task-executor-architect}/
```

## Como instalar

1. Escolha a **ferramenta** (`cursor`, `vscode`, `claude-code` ou `kiro`).
2. Escolha a variante de **executor** (tabela acima).
3. Copie o **conteúdo** de `presets/<ferramenta>/<executor>/` para a raiz do projeto alvo (mescle pastas; não aninhe uma pasta `presets` extra).

Exemplos (a partir da raiz do `my-skills`):

```bash
# Cursor + executor genérico
cp -r presets/cursor/task-executor/.cursor /caminho/do/seu-projeto/

# VS Code + executor Mvp24Hours
cp -r presets/vscode/task-executor-m24h/.github /caminho/do/seu-projeto/

# Claude Code + executor architect
cp presets/claude-code/task-executor-architect/CLAUDE.md /caminho/do/seu-projeto/

# Kiro + executor genérico
cp -r presets/kiro/task-executor/.kiro /caminho/do/seu-projeto/
```

No Windows (PowerShell):

```powershell
Copy-Item -Recurse presets\cursor\task-executor\.cursor C:\caminho\do\seu-projeto\
Copy-Item -Recurse presets\vscode\task-executor-m24h\.github C:\caminho\do\seu-projeto\
Copy-Item presets\claude-code\task-executor-architect\CLAUDE.md C:\caminho\do\seu-projeto\
Copy-Item -Recurse presets\kiro\task-executor\.kiro C:\caminho\do\seu-projeto\
```

4. Instale as skills correspondentes deste repositório para o agente poder lê-las:
   - Sempre: família `spec-kit` em [`../spec-kit/`](../spec-kit/)
   - Mais o executor escolhido em [`../executor/`](../executor/)
   - A forma de instalar skills depende da ferramenta (pasta de skills do Cursor, `.claude/skills/` no Claude, resources `skill://` no Kiro, etc.)

## O que o agente fará

```text
Pedido do usuário
    │
    ├─ Planejamento (feature / /spec / decompor)
    │     → spec-kit-architecture (se não houver docs/architecture.md)
    │     → spec-kit → docs/specs/feature-{NNN}/ + docs/backlog.md
    │
    └─ Execução (implementar tarefa / marcar feito)
          → task-executor | task-executor-m24h | task-executor-architect
          → atualizar tasks no lugar; sincronizar plan/backlog quando aplicável
```

Os presets **roteiam** para as skills; não duplicam os procedimentos delas.

## Pré-requisitos no projeto alvo

- Após o primeiro `spec-kit`: `docs/specs/feature-{NNN}/` com `spec.md`, `plan.md`, `tasks.md`
- Lista macro: `docs/backlog.md`
- Recomendado: `docs/architecture.md` (via `spec-kit-architecture`)

Não é necessário criar essas pastas manualmente antes de copiar um preset — o `spec-kit` as cria quando o planejamento começa.
