# My Skills

Repositório para compartilhar skills reutilizáveis para agentes e assistentes de desenvolvimento. O objetivo é centralizar padrões, documentação e convenções para que novas skills possam ser criadas, revisadas e reutilizadas com consistência.

> **Idiomas:** Este é o README em português. Para a versão padrão (inglês), veja [README.md](README.md).

## Objetivo

- Agrupar skills focadas em automação, planejamento e execução de tarefas.
- Padronizar a estrutura e a documentação das skills.
- Facilitar colaboração entre pessoas que desejam criar ou evoluir skills.
- Manter cada skill simples, reutilizável e fácil de entender.

## Estrutura do repositório

```text
my-skills/
├── README.md
├── README.pt.md
├── spec-kit/
│   ├── spec-kit/
│   │   ├── SKILL.md
│   │   └── templates/
│   │       ├── backlog.template.md
│   │       ├── plan.template.md
│   │       ├── spec.template.md
│   │       └── tasks.template.md
│   ├── spec-kit-0-architecture/
│   ├── spec-kit-1-specify/
│   ├── spec-kit-2-plan/
│   ├── spec-kit-3-tasks/
│   ├── spec-kit-4-backlog/
│   └── spec-kit-executor/
├── executor/
│   ├── task-executor/
│   ├── task-executor-m24h/
│   └── task-executor-architect/
├── git/
│   └── git-sync-develop/
├── migration/
│   └── migration-backlog-m24h/
│       ├── SKILL.md
│       └── templates/
│           ├── migration-architecture.template.md
│           └── migration-backlog.template.md
├── qa/
│   ├── qa-bug-analysis/
│   ├── qa-java-unit-tests/
│   └── qa-sonar-quality-gate/
├── thinking/
│   └── req-discovery-refinement/
├── presets/
│   ├── cursor/{task-executor,task-executor-m24h,task-executor-architect}/
│   ├── vscode/{task-executor,task-executor-m24h,task-executor-architect}/
│   ├── claude-code/{task-executor,task-executor-m24h,task-executor-architect}/
│   └── kiro/{task-executor,task-executor-m24h,task-executor-architect}/
└── ...outras-skills/
    └── SKILL.md
```

## Catálogo de skills

| Skill | Pasta | O que faz |
|---|---|---|
| `spec-kit` | `spec-kit/spec-kit` | Orquestra o planejamento de uma feature: resolve a pasta da feature e a referência de arquitetura e executa as sub-skills em ordem para gerar `spec.md`, `plan.md`, `tasks.md` e a entrada no backlog. |
| `spec-kit-0-architecture` | `spec-kit/spec-kit-0-architecture` | Documenta a arquitetura de um módulo (`docs/<módulo>-architecture.md`) a partir de evidências encontradas no código. |
| `spec-kit-1-specify` … `spec-kit-4-backlog` | `spec-kit/` | Sub-skills que escrevem `spec.md`, `plan.md`, `tasks.md` e mantêm `docs/backlog.md` (chamadas pelo `spec-kit`). |
| `spec-kit-executor` | `spec-kit/spec-kit-executor` | Executa uma tarefa registrada (ou item do plano de correção de um bug), atualiza o artefato da tarefa no próprio lugar e registra a conclusão no CHANGELOG. |
| `task-executor` | `executor/task-executor` | Executor genérico: implementa tarefas registradas e as atualiza no próprio lugar. |
| `task-executor-architect` | `executor/task-executor-architect` | Executor que primeiro seleciona e segue uma skill de arquitetura quando a tarefa envolve decisões arquiteturais. |
| `task-executor-m24h` | `executor/task-executor-m24h` | Executor com roteamento automático de especialistas (`skill-router`) para projetos Mvp24Hours. |
| `migration-backlog-m24h` | `migration/migration-backlog-m24h` | Planeja uma migração para .NET 10 com Mvp24Hours: documento de arquitetura e backlog com testes (somente planejamento). |
| `qa-bug-analysis` | `qa/qa-bug-analysis` | Investiga um bug sem alterar código e gera `docs/bugs/bug-NNN-*.md` com causa raiz, evidências e plano de correção. |
| `qa-java-unit-tests` | `qa/qa-java-unit-tests` | Cria ou revisa testes unitários Java (JUnit 5 + Mockito) com pelo menos 80% de cobertura por classe alterada. |
| `qa-sonar-quality-gate` | `qa/qa-sonar-quality-gate` | Corrige issues do SonarQube a partir do link do projeto até o Quality Gate passar. |
| `git-sync-develop` | `git/git-sync-develop` | Faz merge seguro da branch base (padrão `develop`) na branch atual, valida, publica e oferece um pull request. |
| `req-discovery-refinement` | `thinking/req-discovery-refinement` | Transforma um brainstorm em um documento de refinamento de requisitos baseado em evidências do projeto e referências verificadas. |

Fluxo típico: `req-discovery-refinement` → `spec-kit` → `spec-kit-executor` (ou uma variante de `task-executor`). Para bugs: `qa-bug-analysis` → `spec-kit-executor`.

> **Idioma:** as skills, templates e documentos gerados por elas estão em inglês. Apenas os arquivos `README.pt.md` estão em português.

## Bootstrap de projetos (Presets)

Para configurar um projeto consumidor de modo que o agente sempre use **spec-kit** no planejamento e uma variante de **task-executor** na execução, copie um preset de [`presets/`](presets/).

1. Escolha a ferramenta: `cursor`, `vscode`, `claude-code` ou `kiro`.
2. Escolha o executor: `task-executor`, `task-executor-m24h` ou `task-executor-architect`.
3. Copie o conteúdo de `presets/<ferramenta>/<executor>/` para a raiz do projeto alvo.
4. Instale as skills correspondentes de `spec-kit/` e `executor/`.

Guia completo de instalação: [presets/README.pt.md](presets/README.pt.md).

## Padrão de colaboração

Toda skill deve seguir uma estrutura simples e previsível. Isso facilita leitura, manutenção e uso em diferentes contextos.

### 1. Nome da pasta

Use um nome curto, descritivo e em minúsculas, preferencialmente com hífen quando necessário.

Exemplos:

- spec-kit
- spec-kit-0-architecture
- spec-kit-2-plan
- qa-bug-analysis
- git-sync-develop

### 2. Arquivo principal

Cada skill deve conter um arquivo chamado `SKILL.md` na raiz da pasta.

O arquivo deve seguir esse padrão mínimo:

```yaml
---
name: nome-da-skill
created by: Seu Nome
description: "Descreva quando a skill deve ser usada e qual problema resolve."
argument-hint: "Exemplo de entrada para uso da skill"
---
```

### 3. Estrutura recomendada do conteúdo

Cada `SKILL.md` deve ter, no mínimo, as seções abaixo (em inglês):

- `## Purpose`
- `## When to Use`
- `## Procedure`
- `## Output`
- `## Verification` (ou `## Done Criteria`)

Esse padrão torna a skill fácil de entender por humanos e por agentes.

## Diretrizes de qualidade

Ao criar ou ajustar uma skill, siga estas regras:

- Mantenha a skill focada em um objetivo específico.
- Evite acoplamento com tecnologias específicas quando a solução puder ser genérica.
- Prefira instruções claras e observáveis.
- Escreva cenários reais de uso.
- Use linguagem direta e objetiva.
- Evite placeholders vagos ou instruções ambíguas.
- Documente dependências, saídas esperadas e critérios de validação.
- Garanta que a skill possa ser reutilizada em contextos diferentes.
- Escreva skills, templates e documentos gerados em inglês (apenas os arquivos `README.pt.md` ficam em português).
- Não referencie projetos, repositórios, nomes de skills internas, ambientes, pessoas ou caminhos absolutos/completos de pastas. Use placeholders genéricos (`<módulo>`, `<projeto>`) e caminhos relativos à raiz do repositório.
- Referencie outras skills apenas quando existirem neste repositório, ou descreva a capacidade de forma genérica (por exemplo, "o gerenciador de tarefas do projeto").

## Convenções de documentação

- Tome cuidado com nomenclatura consistente.
- Use exemplos práticos no `argument-hint` e no texto de uso.
- Quando a skill orquestra outras skills, deixe explícita a ordem de execução.
- No fluxo spec-kit, execute `spec-kit-0-architecture` primeiro para criar `docs/<módulo>-architecture.md` quando o projeto ainda não tiver referência arquitetural — depois use `spec-kit` para planejar features.
- Se houver arquivos gerados, diga exatamente qual pasta ou padrão de saída deve ser utilizado.
- Mantenha a documentação alinhada com o comportamento efetivo da skill.

## Fluxo de contribuição

1. Crie uma branch para sua alteração.
2. Crie ou edite a pasta da skill.
3. Atualize o `SKILL.md` com a estrutura padrão.
4. Documente quando usar, como usar e qual resultado esperar.
5. Valide se a skill está coerente com o restante do repositório.
6. Abra um pull request com uma descrição clara do objetivo e do impacto.

## Checklist antes de enviar uma contribuição

- [ ] A pasta da skill tem nome adequado.
- [ ] O arquivo `SKILL.md` existe e está no formato correto.
- [ ] O `description` explica bem o propósito da skill.
- [ ] O `argument-hint` mostra um exemplo útil.
- [ ] O conteúdo está organizado em seções claras.
- [ ] A skill não depende de suposições ocultas.
- [ ] A documentação está consistente com a intenção real da skill.

## Exemplo de skill bem estruturada

```md
---
name: exemplo-skill
created by: Seu Nome
description: "Use quando você precisa automatizar uma tarefa repetitiva de planejamento."
argument-hint: "Quero planejar uma funcionalidade de cadastro de usuários"
---

# Exemplo de Skill

## Purpose

Automatizar a criação de um plano inicial para uma funcionalidade.

## When to Use

- Quando o pedido envolve planejamento antes da implementação.
- Quando é preciso gerar um checklist de execução.

## Procedure

1. Entender o objetivo.
2. Identificar escopo.
3. Dividir em etapas.
4. Produzir uma proposta objetiva.

## Output

Um plano em formato de checklist com etapas sequenciais.

## Verification

- Verificar se o escopo foi compreendido.
- Confirmar que as etapas estão em ordem lógica.
```

## Boa prática final

Este repositório funciona melhor quando cada skill é:

- pequena e especializada;
- clara em seu propósito;
- fácil de revisar;
- reutilizável em múltiplos contextos;
- documentada sem ambiguidades.

Se a skill for bem escrita, ela se torna mais fácil de compartilhar, evoluir e aplicar em workflows reais.

## Contribuição

Contribuições são bem-vindas. O importante é manter o padrão de organização e clareza para que o repositório continue útil e consistente para toda a equipe.
