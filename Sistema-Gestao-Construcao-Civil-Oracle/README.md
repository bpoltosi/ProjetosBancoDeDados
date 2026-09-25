# Sistema de Gestão de Construção Civil e Obras — Oracle SQL

Projeto acadêmico de banco de dados desenvolvido para praticar **modelagem relacional, SQL e integridade referencial**, utilizando **brModelo** e **Oracle Live SQL**.

## Objetivo

Modelar e implementar um sistema capaz de gerenciar:

- construtoras responsáveis por empreendimentos;
- obras e seus dados operacionais;
- trabalhadores alocados em cada obra;
- equipamentos utilizados nas obras.

## Tecnologias

| Tecnologia | Utilização |
|---|---|
| Oracle Database / Oracle Live SQL | SGBD e execução dos scripts |
| Oracle SQL / PL-SQL | Implementação e consultas |
| brModelo | Modelagem conceitual e lógica |
| SQL | DDL, DML e DQL |

## Modelagem

O modelo possui quatro entidades principais:

- **CONSTRUTORA** — empresa responsável pela obra.
- **OBRA** — empreendimento administrado por uma construtora.
- **TRABALHADOR** — profissional alocado em uma obra.
- **EQUIPAMENTO** — equipamento utilizado em uma obra.

### Relacionamentos

- Uma **CONSTRUTORA** pode possuir várias **OBRAS**.
- Uma **OBRA** pertence a uma **CONSTRUTORA**.
- Uma **OBRA** pode possuir vários **TRABALHADORES**.
- Uma **OBRA** pode possuir vários **EQUIPAMENTOS**.

O modelo utiliza chaves primárias, chaves estrangeiras, restrições de unicidade, campos obrigatórios e regras de validação.

## Estrutura

```text
Sistema-Gestao-Construcao-Civil-Oracle/
├── README.md
└── sql/
    ├── 01_ddl.sql
    ├── 02_dml.sql
    └── 03_consultas.sql
```

## Scripts

### 01 — DDL

Criação das tabelas e respectivas restrições de integridade.

A ordem de criação respeita as dependências:

```text
CONSTRUTORA
    ↓
OBRA
    ├── TRABALHADOR
    └── EQUIPAMENTO
```

### 02 — DML

Carga inicial de dados e exemplos de operações de manipulação:

- INSERT
- UPDATE
- DELETE

### 03 — Consultas

Consultas utilizando relacionamentos, agregações e agrupamentos para geração de informações sobre as obras.

## Conceitos demonstrados

- Modelagem entidade-relacionamento;
- Modelo lógico relacional;
- Chaves primárias e estrangeiras;
- Integridade referencial;
- Restrições `UNIQUE`, `NOT NULL` e `CHECK`;
- DDL;
- DML;
- DQL;
- `JOIN` e `LEFT JOIN`;
- `COUNT`, `SUM` e `GROUP BY`;
- Consultas para relatórios;
- Tipos de dados específicos do Oracle.

## Execução

Os scripts foram estruturados para execução no **Oracle Live SQL**.

Execute na seguinte ordem:

1. `sql/01_ddl.sql`
2. `sql/02_dml.sql`
3. `sql/03_consultas.sql`

Para datas, o projeto utiliza literais `DATE 'YYYY-MM-DD'`, compatíveis com Oracle SQL.

## Modelagem brModelo

A modelagem conceitual e lógica foi desenvolvida no **brModelo**.

As imagens/arquivos originais da modelagem podem ser adicionados posteriormente à pasta `modelagem/`, caso estejam disponíveis.

## Status

**Concluído — projeto acadêmico.**

O repositório pode ser expandido futuramente com novas consultas, views, procedures, funções, triggers e melhorias de normalização.
