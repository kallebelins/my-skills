---
doc: tasks
feature: {{feature name}}
status: draft
depends_on: [plan.md, spec.md]
generated_by: spec-kit
---

# Tasks — {{Feature Name}}

<!--
Formato obrigatório de tarefa (uma ação por tarefa):

- [ ] X.X - Nome da tarefa
Descrição: {{o que fazer}}
Arquitetura/Implementação: {{camada/padrão/convenção, com base na referência de arquitetura resolvida (docs/architecture.md ou padrão combinado com o usuário)}}
Entrada: {{referência a spec.md#..., se houver}}
Saída: {{artefato/arquivo a criar ou modificar}}
Cenários de teste: {{se houver}}
Critérios de aceitação: {{mensuráveis, rastreáveis a spec.md}}

X = número da Fase (mesma ordem de plan.md), X.X = sequência dentro da fase.

Protocolo de execução (spec-kit-tasks/SKILL.md): ao concluir uma tarefa, marque "- [x]", adicione
uma linha "Comentário:" com o que foi feito e, se houver pendência, crie sub-tarefa(s)
"- [ ] X.X.N - ..." aninhada(s) sob a tarefa-mãe. Quando todas as tarefas de uma fase estiverem
"[x]", marque também o checkbox da fase em plan.md.
-->

## Fase 1 — {{nome da fase, igual ao plan.md}}

- [ ] 1.1 - {{nome da tarefa}}
Descrição: {{...}}
Arquitetura/Implementação: {{...}}
Entrada: {{...}}
Saída: {{...}}
Cenários de teste: {{...}}
Critérios de aceitação: {{...}}

## Fase 2 — {{nome da fase, igual ao plan.md}}

- [ ] 2.1 - {{nome da tarefa}}
Descrição: {{...}}
Arquitetura/Implementação: {{...}}
Entrada: {{...}}
Saída: {{...}}
Cenários de teste: {{...}}
Critérios de aceitação: {{...}}
