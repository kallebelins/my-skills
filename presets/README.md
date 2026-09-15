# Presets

Copy-ready agent configuration templates that wire a target project to the **spec-kit** (planning) and **task-executor** (execution) skills from this repository.

These are **not** skills. They are tool-specific instruction files you copy into a consumer project so the agent always routes:

- **Planning** → `spec-kit` (and `spec-kit-architecture` when needed)
- **Execution** → one of the three executor variants

> **Languages:** This is the default (English) README. For Portuguese, see [README.pt.md](README.pt.md).

## Choose an executor

| Preset folder | When to use |
|---------------|-------------|
| `task-executor` | Generic projects — no automatic specialist routing |
| `task-executor-m24h` | Mvp24Hours projects — invokes `skill-router` before implementation |
| `task-executor-architect` | Projects that need automatic architect-skill selection |

## Tool × executor matrix

| Tool | Path inside preset | Install target in project |
|------|--------------------|---------------------------|
| Cursor | `.cursor/rules/spec-driven-workflow.mdc` | `<project>/.cursor/rules/` |
| VS Code (Copilot) | `.github/copilot-instructions.md` | `<project>/.github/` |
| Claude Code | `CLAUDE.md` | `<project>/CLAUDE.md` |
| Kiro | `.kiro/steering/spec-driven-workflow.md` | `<project>/.kiro/steering/` |

Full layout:

```text
presets/
├── cursor/{task-executor,task-executor-m24h,task-executor-architect}/
├── vscode/{task-executor,task-executor-m24h,task-executor-architect}/
├── claude-code/{task-executor,task-executor-m24h,task-executor-architect}/
└── kiro/{task-executor,task-executor-m24h,task-executor-architect}/
```

## How to install

1. Pick your **tool** (`cursor`, `vscode`, `claude-code`, or `kiro`).
2. Pick your **executor** variant (table above).
3. Copy the **contents** of `presets/<tool>/<executor>/` into the root of the target project (merge folders; do not nest an extra `presets` folder).

Examples (from the `my-skills` repo root):

```bash
# Cursor + generic executor
cp -r presets/cursor/task-executor/.cursor /path/to/your-project/

# VS Code + Mvp24Hours executor
cp -r presets/vscode/task-executor-m24h/.github /path/to/your-project/

# Claude Code + architect executor
cp presets/claude-code/task-executor-architect/CLAUDE.md /path/to/your-project/

# Kiro + generic executor
cp -r presets/kiro/task-executor/.kiro /path/to/your-project/
```

On Windows (PowerShell):

```powershell
Copy-Item -Recurse presets\cursor\task-executor\.cursor C:\path\to\your-project\
Copy-Item -Recurse presets\vscode\task-executor-m24h\.github C:\path\to\your-project\
Copy-Item presets\claude-code\task-executor-architect\CLAUDE.md C:\path\to\your-project\
Copy-Item -Recurse presets\kiro\task-executor\.kiro C:\path\to\your-project\
```

4. Install the matching skills from this repository so the agent can read them:
   - Always: `spec-kit` family under [`../spec-kit/`](../spec-kit/)
   - Plus the chosen executor under [`../executor/`](../executor/)
   - How you install skills depends on the tool (Cursor skills folder, Claude `.claude/skills/`, Kiro `skill://` resources, etc.)

## What the agent will do

```text
User request
    │
    ├─ Planning (feature / /spec / decompose)
    │     → spec-kit-architecture (if no docs/architecture.md)
    │     → spec-kit → docs/specs/feature-{NNN}/ + docs/backlog.md
    │
    └─ Execution (implement task / mark done)
          → task-executor | task-executor-m24h | task-executor-architect
          → update tasks in place; sync plan/backlog when applicable
```

Presets **route** to skills; they do not duplicate skill procedures.

## Prerequisites in the target project

- After the first `spec-kit` run: `docs/specs/feature-{NNN}/` with `spec.md`, `plan.md`, `tasks.md`
- Macro list: `docs/backlog.md`
- Recommended: `docs/architecture.md` (via `spec-kit-architecture`)

No need to create these folders manually before copying a preset — `spec-kit` creates them when planning starts.
