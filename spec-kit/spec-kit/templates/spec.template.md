---
doc: spec
feature: {{feature name}}
status: draft
architecture_ref: {{docs/architecture.md ou padrão combinado com o usuário}}
generated_by: spec-kit
---

# Spec — {{Feature Name}}

## Fontes
- {{descrição fornecida na conversa e/ou caminho do arquivo de contexto lido}}

## Scope Summary
<!-- Enumerate the capability groups this spec covers. plan.md phases MUST map 1:1 to this list. -->
1. {{capability group 1}}
2. {{capability group 2}}

## Out of Scope
- {{explicitly excluded items — plan.md will copy these verbatim}}

## Regras de Negócio
<!-- Consolidar o máximo possível a partir das fontes acima. Não resumir a ponto de perder regras. -->
- {{...}}

<!-- Somente quando aplicável: endpoints, componentes, integrações -->
## Contratos
### {{Nome do endpoint/componente}}
- {{método/rota ou selector}}
- Request/Props: {{...}}
- Response/Emits: {{...}}

<!-- Somente quando aplicável -->
## Modelos de Dados
| Campo | Tipo | Validação | Origem |
|---|---|---|---|
| {{...}} | {{...}} | {{...}} | {{...}} |

## Casos de Borda / Edge Cases
- {{...}}

## Tratamento de Erros
- {{...}}

## Critérios de Aceitação (mensuráveis)
- {{cada critério deve ser referenciável individualmente por uma tarefa em tasks.md}}

## Perguntas em Aberto
<!-- Gaps que bloqueiam um critério mensurável — perguntar ao usuário em vez de inventar. Remover a seção se vazia. -->
- {{...}}
