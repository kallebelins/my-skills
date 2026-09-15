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
│   ├── spec-kit-backlog/
│   │   └── SKILL.md
│   ├── spec-kit-plan/
│   │   └── SKILL.md
│   ├── spec-kit-spec/
│   │   └── SKILL.md
│   └── spec-kit-tasks/
│       └── SKILL.md
├── executor/
│   ├── task-executor/
│   │   └── SKILL.md
│   ├── task-executor-m24h/
│   │   └── SKILL.md
│   └── task-executor-architect/
│       └── SKILL.md
└── ...outras-skills/
    └── SKILL.md
```

## Padrão de colaboração

Toda skill deve seguir uma estrutura simples e previsível. Isso facilita leitura, manutenção e uso em diferentes contextos.

### 1. Nome da pasta

Use um nome curto, descritivo e em minúsculas, preferencialmente com hífen quando necessário.

Exemplos:

- spec-kit
- spec-kit-plan
- azure-deploy
- python-appservice-deploy

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

Cada `SKILL.md` deve ter, no mínimo:

- `## Purpose` ou `## Objetivo`
- `## When to Use` ou `## Quando usar`
- `## Procedure` ou `## Procedimento`
- `## Output` ou `## Saída`
- `## Verification` ou `## Verificação`

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

## Convenções de documentação

- Tome cuidado com nomenclatura consistente.
- Use exemplos práticos no `argument-hint` e no texto de uso.
- Quando a skill orquestra outras skills, deixe explícita a ordem de execução.
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
