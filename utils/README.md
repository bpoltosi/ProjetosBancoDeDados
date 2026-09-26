# Utils — Referências de Banco de Dados

Esta pasta reúne materiais de consulta rápida para estudo e desenvolvimento com bancos de dados.

## Arquivos

| Arquivo | Conteúdo |
|---|---|
| [SQLutils.md](./SQLutils.md) | SQL geral e fundamentos de bancos relacionais |
| [T-SQLutils.md](./T-SQLutils.md) | T-SQL e recursos específicos do Microsoft SQL Server |
| [NoSQLutils.md](./NoSQLutils.md) | Conceitos e operações de bancos NoSQL |

## Como utilizar

A ideia destes arquivos é servir como **cheat sheets de estudo e consulta**, não substituir a documentação oficial de cada SGBD.

### SQL
Use para revisar fundamentos que aparecem em diferentes bancos relacionais, como DDL, DML, DQL, DCL e TCL, SELECT e filtros, JOINs, agregações, subconsultas, CTEs, Window Functions, views, índices, constraints e transações.

### T-SQL
Use quando estiver trabalhando especificamente com **Microsoft SQL Server**. O material inclui variáveis e controle de fluxo, stored procedures, functions, triggers, CTEs, Window Functions, temp tables, table variables, JSON, XML, SQL dinâmico, metadados, transações, tratamento de erros, backup, restore e diagnóstico.

### NoSQL
Use para revisar diferentes modelos de bancos não relacionais, com exemplos principalmente de MongoDB, Redis / Valkey, Cassandra e Neo4j / Cypher. Também aborda modelagem, índices, agregações, embedding vs. referencing, replicação, particionamento, consistência e CAP.

## Organização

    utils/
    ├── README.md
    ├── SQLutils.md
    ├── T-SQLutils.md
    └── NoSQLutils.md

> Os arquivos podem ser ampliados conforme novos projetos, disciplinas e tecnologias forem adicionados ao repositório.
