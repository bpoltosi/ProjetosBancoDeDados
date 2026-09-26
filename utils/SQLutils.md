# SQL — Guia de Referência

> Referência prática de SQL padrão e recursos comuns em bancos relacionais. A sintaxe pode variar entre PostgreSQL, MySQL, SQL Server, Oracle e SQLite.

## 1. Conceitos
- **DDL** — estrutura: CREATE, ALTER, DROP, TRUNCATE
- **DML** — dados: INSERT, UPDATE, DELETE, MERGE
- **DQL** — consulta: SELECT
- **DCL** — permissões: GRANT, REVOKE
- **TCL** — transações: COMMIT, ROLLBACK, SAVEPOINT

## 2. Bancos e tabelas
```sql
CREATE DATABASE nome_db;
DROP DATABASE nome_db;

CREATE TABLE clientes (
    id INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    idade INT CHECK (idade >= 0),
    cidade VARCHAR(80) DEFAULT 'Não informado'
);

ALTER TABLE clientes ADD telefone VARCHAR(20);
ALTER TABLE clientes ALTER COLUMN nome TYPE VARCHAR(150);
ALTER TABLE clientes DROP COLUMN telefone;
DROP TABLE clientes;
TRUNCATE TABLE clientes;
```

## 3. INSERT / UPDATE / DELETE
```sql
INSERT INTO clientes (id, nome, email)
VALUES (1, 'Bruno', 'bruno@email.com');

INSERT INTO clientes (id, nome)
VALUES (2, 'Ana'), (3, 'Carlos');

UPDATE clientes SET cidade = 'Santa Maria' WHERE id = 1;
DELETE FROM clientes WHERE id = 3;
```

## 4. SELECT
```sql
SELECT * FROM clientes;
SELECT nome, cidade FROM clientes;
SELECT DISTINCT cidade FROM clientes;
SELECT nome FROM clientes WHERE idade >= 18;
SELECT nome FROM clientes ORDER BY nome ASC;
SELECT nome FROM clientes ORDER BY idade DESC LIMIT 10;
```

## 5. Operadores e filtros
```sql
WHERE idade BETWEEN 18 AND 30
WHERE cidade IN ('Santa Maria', 'Porto Alegre')
WHERE nome LIKE 'Br%'
WHERE email IS NULL
WHERE idade >= 18 AND cidade = 'Santa Maria'
WHERE NOT cidade = 'Porto Alegre'
```

## 6. Agregações
```sql
SELECT COUNT(*) FROM clientes;
SELECT AVG(idade) FROM clientes;
SELECT MIN(idade), MAX(idade) FROM clientes;
SELECT SUM(valor) FROM pedidos;

SELECT cidade, COUNT(*)
FROM clientes
GROUP BY cidade
HAVING COUNT(*) > 1;
```

## 7. JOINs
```sql
SELECT *
FROM clientes c
INNER JOIN pedidos p ON p.cliente_id = c.id;

SELECT *
FROM clientes c
LEFT JOIN pedidos p ON p.cliente_id = c.id;

SELECT *
FROM clientes c
RIGHT JOIN pedidos p ON p.cliente_id = c.id;

SELECT *
FROM clientes c
FULL OUTER JOIN pedidos p ON p.cliente_id = c.id;

SELECT *
FROM clientes c
CROSS JOIN categorias cat;
```

## 8. Subconsultas
```sql
SELECT nome
FROM clientes
WHERE id IN (SELECT cliente_id FROM pedidos);

SELECT *
FROM produtos p
WHERE EXISTS (
    SELECT 1 FROM pedidos_itens pi
    WHERE pi.produto_id = p.id
);
```

## 9. UNION / INTERSECT / EXCEPT
```sql
SELECT cidade FROM clientes
UNION
SELECT cidade FROM fornecedores;

SELECT cidade FROM clientes
INTERSECT
SELECT cidade FROM fornecedores;

SELECT cidade FROM clientes
EXCEPT
SELECT cidade FROM fornecedores;
```

## 10. CASE, COALESCE e NULLIF
```sql
SELECT nome,
       CASE
           WHEN idade < 18 THEN 'Menor'
           WHEN idade < 60 THEN 'Adulto'
           ELSE 'Idoso'
       END AS faixa
FROM clientes;

SELECT COALESCE(telefone, 'Sem telefone') FROM clientes;
SELECT NULLIF(status, 'N/A') FROM clientes;
```

## 11. CTE
```sql
WITH clientes_ativos AS (
    SELECT * FROM clientes WHERE ativo = TRUE
)
SELECT * FROM clientes_ativos;
```

## 12. Window Functions
```sql
SELECT nome, salario,
       ROW_NUMBER() OVER (ORDER BY salario DESC) AS posicao,
       RANK() OVER (ORDER BY salario DESC) AS ranking,
       SUM(salario) OVER (PARTITION BY departamento) AS total_departamento
FROM funcionarios;
```

## 13. Views
```sql
CREATE VIEW clientes_ativos AS
SELECT * FROM clientes WHERE ativo = TRUE;

CREATE OR REPLACE VIEW clientes_ativos AS
SELECT id, nome FROM clientes WHERE ativo = TRUE;

DROP VIEW clientes_ativos;
```

## 14. Índices
```sql
CREATE INDEX idx_clientes_email ON clientes(email);
CREATE UNIQUE INDEX idx_clientes_email_unico ON clientes(email);
DROP INDEX idx_clientes_email;
```

## 15. Constraints
```sql
PRIMARY KEY
FOREIGN KEY
UNIQUE
NOT NULL
CHECK
DEFAULT

ALTER TABLE pedidos
ADD CONSTRAINT fk_pedido_cliente
FOREIGN KEY (cliente_id) REFERENCES clientes(id);
```

## 16. Transações
```sql
BEGIN;

UPDATE contas SET saldo = saldo - 100 WHERE id = 1;
UPDATE contas SET saldo = saldo + 100 WHERE id = 2;

COMMIT;
-- ou
ROLLBACK;
```

> Em SQL Server, use `BEGIN TRANSACTION`, `COMMIT TRANSACTION` e `ROLLBACK TRANSACTION`.

## 17. Procedimentos e funções
A sintaxe é específica de cada SGBD. Conceitos comuns:
- Stored Procedures
- User-Defined Functions
- Triggers
- Sequences / Identity / Auto Increment

## 18. Boas práticas
- Use chaves primárias e estrangeiras.
- Defina constraints para proteger a integridade.
- Evite `SELECT *` em código de produção.
- Use parâmetros/prepared statements contra SQL Injection.
- Crie índices com base no padrão real de consultas.
- Use transações em operações que precisam ser atômicas.
- Faça backup e teste restauração.
- Documente o modelo e os relacionamentos.

## 19. SGBDs comuns
- PostgreSQL
- MySQL / MariaDB
- SQL Server
- Oracle Database
- SQLite

**Observação:** este arquivo é uma referência geral. Para comandos específicos de SQL Server, consulte `T-SQLutils.md`.
