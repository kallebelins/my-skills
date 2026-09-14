---
name: spec-kit-backlog
created by: Kallebe Lins
description: "Mantém docs/backlog.md — a lista macro, em nível de projeto, de todas as funcionalidades (existentes no código, especificadas via spec-kit, ou apenas brainstormed), com checkbox [ ]/[x] indicando execução. Chamada automaticamente pelo orquestrador spec-kit ao final de cada spec, ou individualmente pelo usuário em 4 modos: registrar spec existente, brainstorming, discovery de sistema existente, ou discovery + sugestão de novas funcionalidades."
argument-hint: "Modo desejado (registrar | brainstorming | discovery | discovery+sugestão) e, se aplicável, caminho da spec.md já escrita ou do sistema/domínio a analisar"
---

# Spec-Kit Backlog

## Purpose

Manter `docs/backlog.md` como o único documento, em nível macro, que lista todas as funcionalidades do projeto — as que já existem no código, as que foram especificadas via `spec-kit`, e as que são apenas ideias (brainstorming) — cada uma com um checkbox `[ ]`/`[x]` que indica se já foi executada/entregue. Este arquivo não substitui `spec.md`/`plan.md`/`tasks.md`: ele apenas referencia esses artefatos e resume o todo em uma única lista.

## Quando usar

- **Chamada pelo orquestrador** [`spec-kit`](../spec-kit/SKILL.md), como último passo, sempre que `spec.md`/`plan.md`/`tasks.md` de uma feature forem gerados (Modo A — Registrar).
- **Chamada individualmente pelo usuário** para:
  - Registrar no backlog uma funcionalidade cuja spec já foi escrita com `spec-kit`/`spec-kit-plan` (Modo A).
  - Fazer brainstorming de funcionalidades para um sistema novo (do zero) ou existente (Modo B).
  - Fazer discovery de um sistema existente para apenas inventariar o que já existe (Modo C).
  - Fazer discovery de um sistema existente e, além de inventariar, sugerir novas funcionalidades (Modo D).

## Precondition comum

- [ ] O caminho de `docs/backlog.md` no projeto-alvo é conhecido (raiz de `docs/`, não `docs/specs/`).

Se `docs/backlog.md` ainda não existir, crie-o a partir de `spec-kit/templates/backlog.template.md` antes de adicionar qualquer item.

## Template

Use `spec-kit/templates/backlog.template.md` para a estrutura/frontmatter do arquivo e para o formato de cada item:

```
- [ ] {{Nome da funcionalidade}}
  - Origem: {{spec-kit | discovery | brainstorming}}
  - Referência: {{docs/specs/feature-NNN/spec.md | caminho no código | (nenhuma)}}
  - Resumo: {{uma linha}}
```

## Modos

### Modo A — Registrar spec existente

Usado pelo orquestrador `spec-kit` (automático) ou quando o usuário pede para "adicionar ao backlog" uma feature já especificada.

1. Precondição: `docs/specs/feature-{NNN}/spec.md` existe (escrito por `spec-kit-spec`).
2. Ler o título e a seção "Scope Summary" de `spec.md` para montar um resumo de uma linha.
3. Verificar se já existe uma entrada em `docs/backlog.md` cuja Referência aponte para esse mesmo `spec.md` — se sim, não duplicar (idempotente); apenas atualizar o Resumo se estiver desatualizado.
4. Caso contrário, adicionar uma nova entrada `- [ ]` (não concluído — a spec foi escrita, mas a execução ainda não terminou), com:
   - Origem: `spec-kit`
   - Referência: `docs/specs/feature-{NNN}/spec.md`
   - Resumo: a linha extraída do Scope Summary/título.
5. Não gravar diretamente sem confirmação **não é necessário** neste modo — é uma operação automática/idempotente que apenas espelha um artefato já aprovado pelo usuário (a spec).

### Modo B — Brainstorming de funcionalidades

Usado para ajudar a identificar funcionalidades de um sistema novo (do zero) ou adicionar ideias a um sistema existente.

1. Se o domínio, os usuários-alvo ou o objetivo do sistema não estiverem claros na conversa, faça perguntas objetivas antes de propor a lista — não invente escopo de negócio.
2. Proponha uma lista de funcionalidades candidatas, cada uma com um nome curto e um resumo de uma linha.
3. **Apresente a lista completa ao usuário e aguarde confirmação (ou ajustes) antes de gravar em `docs/backlog.md`.**
4. Após confirmação, adicione uma entrada `- [ ]` por funcionalidade aceita:
   - Origem: `brainstorming`
   - Referência: `(nenhuma)`
   - Resumo: a linha proposta (ajustada conforme o usuário pedir).
5. Deixe claro para o usuário que essas são ideias ainda não especificadas — para formalizar qualquer uma delas, deve-se rodar `spec-kit` sobre o item, e o Modo A desta skill então atualizará a entrada (Origem passa a `spec-kit`, Referência passa a apontar para o `spec.md` gerado).

### Modo C — Discovery de sistema existente (somente inventariar)

Usado quando o usuário só quer saber quais funcionalidades já existem em um sistema, sem sugestões.

1. Leia o código-fonte do sistema (rotas/controllers, componentes de UI, casos de uso, endpoints expostos) para identificar funcionalidades já implementadas.
2. Para cada funcionalidade identificada, adicione uma entrada `- [x]` (já implementada/entregue):
   - Origem: `discovery`
   - Referência: caminho representativo no código (ex.: arquivo do controller/rota/componente principal).
   - Resumo: uma linha descrevendo o que a funcionalidade faz, com base no código lido.
3. Não invente funcionalidades que não estejam evidenciadas no código — se algo for incerto, pergunte ao usuário em vez de assumir.
4. Apresente a lista inventariada ao usuário antes de gravar em `docs/backlog.md`, para confirmação de que a leitura do sistema está correta.

### Modo D — Discovery + sugestão de novas funcionalidades

Combina os Modos C e B para um sistema existente: inventaria o que já existe e sugere lacunas/próximos passos.

1. Execute o Modo C (passos 1-2) para levantar as funcionalidades existentes (`- [x]`).
2. A partir do que foi encontrado, identifique lacunas ou extensões plausíveis e monte uma lista de sugestões (mesmo processo do Modo B, passo 2).
3. Apresente as duas listas ao usuário, claramente separadas (existentes vs. sugeridas), para confirmação antes de gravar.
4. Após confirmação, grave em `docs/backlog.md`:
   - Itens existentes: `- [x]`, Origem: `discovery`, Referência: caminho no código.
   - Itens sugeridos aceitos: `- [ ]`, Origem: `brainstorming`, Referência: `(nenhuma)`.

## Content Rules

- Nunca remover ou reordenar entradas já existentes em `docs/backlog.md` — apenas adicionar novas ou atualizar o checkbox/Resumo de uma entrada já existente quando o próprio item mudar de estado.
- Um item só é marcado `[x]` quando a funcionalidade está de fato entregue/executada (já existe em produção, ou todas as fases de `plan.md` referenciado foram concluídas) — nunca marque `[x]` apenas porque a spec foi escrita.
- Manter os 3 campos (Origem/Referência/Resumo) em todas as entradas, mesmo quando Referência for `(nenhuma)`.
- Atualizar o campo `last_updated` do frontmatter sempre que o arquivo for modificado.

## Output

Criar ou atualizar `docs/backlog.md` na raiz da pasta `docs/` do projeto-alvo.

## Self-Check antes de finalizar

- [ ] Frontmatter de `docs/backlog.md` corresponde ao template
- [ ] Nenhuma entrada duplicada (mesma Referência apontando para o mesmo `spec.md`/caminho)
- [ ] Todo item tem Origem, Referência e Resumo preenchidos
- [ ] Checkbox de cada item novo reflete o modo usado (A/B → `[ ]`; C → `[x]`; D → misto, conforme o item)
- [ ] Nos Modos B/C/D, a lista foi apresentada e confirmada pelo usuário antes da gravação
- [ ] Nenhuma entrada existente foi removida, reordenada ou teve seu significado alterado sem necessidade
- [ ] `docs/backlog.md` continua sendo o único arquivo de backlog do projeto (não criar um por feature)
