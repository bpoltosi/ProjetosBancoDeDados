# T-SQL — Comandos e Referência Rápida

> Guia de consulta rápida para **T-SQL (Transact-SQL)**, linguagem usada principalmente no Microsoft SQL Server.
>
> **Observação:** esta é uma referência ampla dos comandos, cláusulas, funções e recursos mais usados de T-SQL. "Todos" os comandos existentes é um alvo muito grande porque o SQL Server possui centenas de instruções, opções, objetos e recursos específicos por versão/edição. O objetivo aqui é reunir os principais recursos de uso prático em um único arquivo.

---

## 1. Estrutura básica

### Comentários

```sql
-- Comentário de uma linha

/*
   Comentário
   de várias linhas
*/
```

### Executar um lote

```sql
GO
```

`GO` não é um comando T-SQL propriamente dito; é um separador de lotes reconhecido por ferramentas como SSMS e sqlcmd.

---

# 2. DDL — Data Definition Language

DDL define e altera a estrutura do banco de dados.

## CREATE DATABASE

Cria um banco de dados.

```sql
CREATE DATABASE MeuBanco;
```

## ALTER DATABASE

Altera configurações do banco.

```sql
ALTER DATABASE MeuBanco SET RECOVERY SIMPLE;
```

## DROP DATABASE

Remove o banco de dados.

```sql
DROP DATABASE MeuBanco;
```

> **Cuidado:** operação destrutiva.

---

# 3. Schemas

## CREATE SCHEMA

Cria um schema.

```sql
CREATE SCHEMA vendas;
```

## ALTER SCHEMA

Move um objeto para outro schema.

```sql
ALTER SCHEMA vendas TRANSFER dbo.Pedido;
```

## DROP SCHEMA

Remove um schema vazio.

```sql
DROP SCHEMA vendas;
```

---

# 4. CREATE TABLE

Cria uma tabela.

```sql
CREATE TABLE Clientes (
    ClienteID INT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Email VARCHAR(150) UNIQUE,
    DataCadastro DATE DEFAULT GETDATE()
);
```

## Principais tipos de dados

### Números

```sql
BIT
TINYINT
SMALLINT
INT
BIGINT
DECIMAL(p,s)
NUMERIC(p,s)
MONEY
SMALLMONEY
FLOAT
REAL
```

### Texto

```sql
CHAR(n)
VARCHAR(n)
VARCHAR(MAX)
NCHAR(n)
NVARCHAR(n)
NVARCHAR(MAX)
TEXT        -- legado
NTEXT       -- legado
```

### Data e hora

```sql
DATE
TIME
DATETIME
DATETIME2
SMALLDATETIME
DATETIMEOFFSET
```

### Binários

```sql
BINARY(n)
VARBINARY(n)
VARBINARY(MAX)
IMAGE       -- legado
```

### Outros

```sql
UNIQUEIDENTIFIER
XML
JSON        -- armazenado normalmente em VARCHAR/NVARCHAR
SQL_VARIANT
GEOGRAPHY
GEOMETRY
HIERARCHYID
```

---

# 5. Restrições — CONSTRAINTS

## PRIMARY KEY

Identifica exclusivamente cada registro.

```sql
CONSTRAINT PK_Clientes PRIMARY KEY (ClienteID)
```

## FOREIGN KEY

Cria relacionamento entre tabelas.

```sql
CONSTRAINT FK_Pedidos_Clientes
    FOREIGN KEY (ClienteID)
    REFERENCES Clientes(ClienteID)
```

## UNIQUE

Impede valores duplicados.

```sql
CONSTRAINT UQ_Clientes_Email UNIQUE (Email)
```

## NOT NULL

Exige valor.

```sql
Nome VARCHAR(100) NOT NULL
```

## CHECK

Impõe uma condição.

```sql
CONSTRAINT CK_Produto_Preco CHECK (Preco >= 0)
```

## DEFAULT

Define valor padrão.

```sql
DataCadastro DATETIME2 DEFAULT SYSDATETIME()
```

---

# 6. ALTER TABLE

Adiciona uma coluna:

```sql
ALTER TABLE Clientes
ADD Telefone VARCHAR(20);
```

Altera uma coluna:

```sql
ALTER TABLE Clientes
ALTER COLUMN Telefone VARCHAR(30);
```

Remove uma coluna:

```sql
ALTER TABLE Clientes
DROP COLUMN Telefone;
```

Adiciona constraint:

```sql
ALTER TABLE Clientes
ADD CONSTRAINT UQ_Clientes_Email UNIQUE (Email);
```

Remove constraint:

```sql
ALTER TABLE Clientes
DROP CONSTRAINT UQ_Clientes_Email;
```

---

# 7. DROP e TRUNCATE

## DROP TABLE

Exclui tabela e sua estrutura.

```sql
DROP TABLE Clientes;
```

## TRUNCATE TABLE

Remove todos os registros e mantém a estrutura.

```sql
TRUNCATE TABLE Clientes;
```

### Diferença rápida

| Comando | Estrutura | Dados | WHERE |
|---|---|---|---|
| DELETE | Mantém | Remove selecionados | Sim |
| TRUNCATE | Mantém | Remove todos | Não |
| DROP | Remove | Remove | Não |

---

# 8. DML — Data Manipulation Language

DML manipula os dados.

Principais comandos:

- `INSERT`
- `UPDATE`
- `DELETE`
- `MERGE`

---

# 9. INSERT

Insere uma linha:

```sql
INSERT INTO Clientes (ClienteID, Nome, Email)
VALUES (1, 'Bruno', 'bruno@email.com');
```

Várias linhas:

```sql
INSERT INTO Clientes (ClienteID, Nome)
VALUES
    (2, 'Ana'),
    (3, 'Carlos'),
    (4, 'Maria');
```

Inserir resultado de uma consulta:

```sql
INSERT INTO ClientesBackup (ClienteID, Nome)
SELECT ClienteID, Nome
FROM Clientes;
```

---

# 10. SELECT

Consulta dados.

```sql
SELECT *
FROM Clientes;
```

Selecionar colunas:

```sql
SELECT ClienteID, Nome, Email
FROM Clientes;
```

Alias:

```sql
SELECT
    Nome AS NomeCliente,
    Email AS EmailCliente
FROM Clientes;
```

---

# 11. DISTINCT

Remove duplicidades no resultado.

```sql
SELECT DISTINCT Cidade
FROM Clientes;
```

---

# 12. WHERE

Filtra registros.

```sql
SELECT *
FROM Clientes
WHERE ClienteID = 1;
```

Operadores:

```sql
=
<>
!=
>
<
>=
<=
```

---

# 13. Operadores lógicos

## AND

Todas as condições precisam ser verdadeiras.

```sql
WHERE Idade >= 18
  AND Cidade = 'Santa Maria'
```

## OR

Pelo menos uma condição deve ser verdadeira.

```sql
WHERE Cidade = 'Santa Maria'
   OR Cidade = 'Porto Alegre'
```

## NOT

Inverte a condição.

```sql
WHERE NOT Cidade = 'Porto Alegre'
```

---

# 14. BETWEEN

Testa intervalo.

```sql
WHERE Preco BETWEEN 100 AND 500
```

---

# 15. IN

Testa uma lista de valores.

```sql
WHERE Cidade IN ('Santa Maria', 'Porto Alegre', 'Canoas')
```

---

# 16. LIKE

Pesquisa padrões de texto.

```sql
WHERE Nome LIKE 'Bru%'
```

Curingas:

| Padrão | Significado |
|---|---|
| `%` | Qualquer quantidade de caracteres |
| `_` | Exatamente um caractere |
| `[abc]` | Um dos caracteres |
| `[a-z]` | Intervalo de caracteres |
| `[^abc]` | Qualquer caractere exceto os listados |

Exemplo:

```sql
WHERE Nome LIKE '%Silva%'
```

---

# 17. NULL

NULL representa ausência/desconhecimento de valor.

Correto:

```sql
WHERE Email IS NULL;
```

```sql
WHERE Email IS NOT NULL;
```

Não use:

```sql
WHERE Email = NULL;
```

---

# 18. ORDER BY

Ordena o resultado.

```sql
SELECT *
FROM Produtos
ORDER BY Preco ASC;
```

Descendente:

```sql
ORDER BY Preco DESC;
```

Múltiplas colunas:

```sql
ORDER BY Categoria ASC, Preco DESC;
```

---

# 19. TOP

Limita a quantidade de linhas.

```sql
SELECT TOP 10 *
FROM Produtos;
```

Percentual:

```sql
SELECT TOP 10 PERCENT *
FROM Produtos;
```

Com ordenação:

```sql
SELECT TOP 10 *
FROM Produtos
ORDER BY Preco DESC;
```

---

# 20. OFFSET / FETCH

Paginação.

```sql
SELECT *
FROM Produtos
ORDER BY ProdutoID
OFFSET 20 ROWS
FETCH NEXT 10 ROWS ONLY;
```

---

# 21. UPDATE

Atualiza registros.

```sql
UPDATE Clientes
SET Nome = 'Bruno Saldanha'
WHERE ClienteID = 1;
```

Múltiplas colunas:

```sql
UPDATE Clientes
SET Nome = 'Bruno',
    Email = 'novo@email.com'
WHERE ClienteID = 1;
```

> Sempre avalie o `WHERE` antes de executar um UPDATE.

---

# 22. DELETE

Remove registros.

```sql
DELETE FROM Clientes
WHERE ClienteID = 1;
```

Todos:

```sql
DELETE FROM Clientes;
```

> Sem `WHERE`, todos os registros podem ser removidos.

---

# 23. MERGE

Sincroniza dados entre origem e destino.

```sql
MERGE INTO Clientes AS destino
USING ClientesOrigem AS origem
ON destino.ClienteID = origem.ClienteID

WHEN MATCHED THEN
    UPDATE SET destino.Nome = origem.Nome

WHEN NOT MATCHED BY TARGET THEN
    INSERT (ClienteID, Nome)
    VALUES (origem.ClienteID, origem.Nome);
```

> Recurso poderoso, mas exige cuidado. Em cenários críticos, alternativas com `INSERT`/`UPDATE` explícitos podem ser mais simples de controlar.

---

# 24. JOINs

Relacionam tabelas.

## INNER JOIN

Retorna apenas correspondências.

```sql
SELECT c.Nome, p.PedidoID
FROM Clientes c
INNER JOIN Pedidos p
    ON p.ClienteID = c.ClienteID;
```

## LEFT JOIN

Retorna todos da tabela esquerda e correspondências da direita.

```sql
SELECT c.Nome, p.PedidoID
FROM Clientes c
LEFT JOIN Pedidos p
    ON p.ClienteID = c.ClienteID;
```

## RIGHT JOIN

Retorna todos da tabela direita.

```sql
SELECT c.Nome, p.PedidoID
FROM Clientes c
RIGHT JOIN Pedidos p
    ON p.ClienteID = c.ClienteID;
```

## FULL OUTER JOIN

Retorna correspondências e não correspondências dos dois lados.

```sql
SELECT c.Nome, p.PedidoID
FROM Clientes c
FULL OUTER JOIN Pedidos p
    ON p.ClienteID = c.ClienteID;
```

## CROSS JOIN

Produto cartesiano.

```sql
SELECT *
FROM Cores
CROSS JOIN Tamanhos;
```

## SELF JOIN

Tabela relacionada consigo mesma.

```sql
SELECT
    f.Nome AS Funcionario,
    g.Nome AS Gerente
FROM Funcionarios f
LEFT JOIN Funcionarios g
    ON f.GerenteID = g.FuncionarioID;
```

---

# 25. GROUP BY

Agrupa registros.

```sql
SELECT Cidade, COUNT(*) AS Quantidade
FROM Clientes
GROUP BY Cidade;
```

---

# 26. HAVING

Filtra grupos depois do `GROUP BY`.

```sql
SELECT Cidade, COUNT(*) AS Quantidade
FROM Clientes
GROUP BY Cidade
HAVING COUNT(*) > 10;
```

### WHERE x HAVING

- `WHERE` filtra linhas antes da agregação.
- `HAVING` filtra grupos depois da agregação.

---

# 27. Funções de agregação

## COUNT

Conta registros.

```sql
SELECT COUNT(*) FROM Clientes;
```

## COUNT DISTINCT

Conta valores diferentes.

```sql
SELECT COUNT(DISTINCT Cidade)
FROM Clientes;
```

## SUM

Soma valores.

```sql
SELECT SUM(Preco)
FROM Produtos;
```

## AVG

Calcula média.

```sql
SELECT AVG(Preco)
FROM Produtos;
```

## MIN

Menor valor.

```sql
SELECT MIN(Preco)
FROM Produtos;
```

## MAX

Maior valor.

```sql
SELECT MAX(Preco)
FROM Produtos;
```

---

# 28. Funções de texto

## LEN

Quantidade de caracteres, ignorando espaços finais.

```sql
SELECT LEN(Nome)
FROM Clientes;
```

## DATALENGTH

Quantidade de bytes.

```sql
SELECT DATALENGTH(Nome)
FROM Clientes;
```

## LOWER

Converte para minúsculas.

```sql
SELECT LOWER(Nome)
FROM Clientes;
```

## UPPER

Converte para maiúsculas.

```sql
SELECT UPPER(Nome)
FROM Clientes;
```

## LTRIM / RTRIM

Remove espaços à esquerda/direita.

```sql
SELECT LTRIM(Nome)
SELECT RTRIM(Nome)
```

## TRIM

Remove espaços nas extremidades.

```sql
SELECT TRIM(Nome)
FROM Clientes;
```

## CONCAT

Concatena valores.

```sql
SELECT CONCAT(Nome, ' - ', Cidade)
FROM Clientes;
```

## CONCAT_WS

Concatena usando separador.

```sql
SELECT CONCAT_WS(' - ', Nome, Cidade, Estado)
FROM Clientes;
```

## LEFT / RIGHT

Obtém caracteres de uma extremidade.

```sql
SELECT LEFT(Nome, 3)
SELECT RIGHT(Nome, 3)
```

## SUBSTRING

Extrai trecho.

```sql
SELECT SUBSTRING(Nome, 1, 5)
FROM Clientes;
```

## CHARINDEX

Localiza posição de texto.

```sql
SELECT CHARINDEX('@', Email)
FROM Clientes;
```

## PATINDEX

Pesquisa padrões.

```sql
SELECT PATINDEX('%SQL%', Descricao)
FROM Cursos;
```

## REPLACE

Substitui texto.

```sql
SELECT REPLACE(Nome, 'Silva', 'Santos')
FROM Clientes;
```

## STUFF

Remove e insere texto em determinada posição.

```sql
SELECT STUFF('ABCDE', 2, 2, 'XX');
-- AXXDE
```

## REVERSE

Inverte texto.

```sql
SELECT REVERSE(Nome)
FROM Clientes;
```

## REPLICATE

Repete texto.

```sql
SELECT REPLICATE('0', 5);
```

## SPACE

Cria espaços.

```sql
SELECT 'A' + SPACE(5) + 'B';
```

---

# 29. Funções numéricas

## ABS

Valor absoluto.

```sql
SELECT ABS(-10);
```

## CEILING

Arredonda para cima.

```sql
SELECT CEILING(10.2);
```

## FLOOR

Arredonda para baixo.

```sql
SELECT FLOOR(10.8);
```

## ROUND

Arredonda.

```sql
SELECT ROUND(10.567, 2);
```

## POWER

Potência.

```sql
SELECT POWER(2, 3);
```

## SQRT

Raiz quadrada.

```sql
SELECT SQRT(25);
```

## RAND

Número pseudoaleatório.

```sql
SELECT RAND();
```

## SIGN

Retorna sinal do número.

```sql
SELECT SIGN(-10);
```

---

# 30. Funções de data e hora

## GETDATE

Data/hora atual do servidor.

```sql
SELECT GETDATE();
```

## SYSDATETIME

Data/hora atual com maior precisão.

```sql
SELECT SYSDATETIME();
```

## GETUTCDATE

Data/hora UTC.

```sql
SELECT GETUTCDATE();
```

## SYSUTCDATETIME

UTC com maior precisão.

```sql
SELECT SYSUTCDATETIME();
```

## DATEPART

Extrai uma parte da data.

```sql
SELECT DATEPART(YEAR, GETDATE());
SELECT DATEPART(MONTH, GETDATE());
SELECT DATEPART(DAY, GETDATE());
```

## DATENAME

Retorna o nome da parte da data.

```sql
SELECT DATENAME(MONTH, GETDATE());
```

## YEAR / MONTH / DAY

```sql
SELECT YEAR(DataCadastro);
SELECT MONTH(DataCadastro);
SELECT DAY(DataCadastro);
```

## DATEADD

Adiciona tempo.

```sql
SELECT DATEADD(DAY, 30, GETDATE());
```

## DATEDIFF

Calcula diferença entre datas.

```sql
SELECT DATEDIFF(DAY, DataInicio, DataFim);
```

## EOMONTH

Último dia do mês.

```sql
SELECT EOMONTH(GETDATE());
```

## DATEFROMPARTS

Cria uma data a partir de partes.

```sql
SELECT DATEFROMPARTS(2026, 9, 26);
```

## DATETIMEFROMPARTS

Monta um DATETIME a partir de partes.

```sql
SELECT DATETIMEFROMPARTS(2026, 9, 26, 20, 0, 0, 0);
```

---

# 31. Conversão de tipos

## CAST

Conversão explícita.

```sql
SELECT CAST(123.45 AS INT);
```

## CONVERT

Conversão com suporte a estilos.

```sql
SELECT CONVERT(VARCHAR(10), GETDATE(), 103);
```

## TRY_CAST

Tenta converter e retorna NULL se falhar.

```sql
SELECT TRY_CAST('123' AS INT);
```

## TRY_CONVERT

Versão segura do CONVERT.

```sql
SELECT TRY_CONVERT(INT, 'abc');
```

## PARSE

Converte usando regras de cultura .NET.

```sql
SELECT PARSE('26/09/2026' AS DATE USING 'pt-BR');
```

## TRY_PARSE

Versão que retorna NULL em caso de erro.

---

# 32. NULL — funções úteis

## ISNULL

Substitui NULL.

```sql
SELECT ISNULL(Telefone, 'Não informado')
FROM Clientes;
```

## COALESCE

Retorna o primeiro valor não nulo.

```sql
SELECT COALESCE(Telefone, Email, 'Sem contato')
FROM Clientes;
```

## NULLIF

Retorna NULL quando duas expressões são iguais.

```sql
SELECT NULLIF(Quantidade, 0);
```

---

# 33. CASE

Cria lógica condicional.

```sql
SELECT
    Nome,
    CASE
        WHEN Idade < 18 THEN 'Menor'
        WHEN Idade >= 18 THEN 'Maior'
        ELSE 'Não informado'
    END AS FaixaEtaria
FROM Clientes;
```

Forma simples:

```sql
SELECT
    CASE Status
        WHEN 1 THEN 'Ativo'
        WHEN 0 THEN 'Inativo'
        ELSE 'Desconhecido'
    END
FROM Clientes;
```

---

# 34. Subqueries

Consulta dentro de outra consulta.

```sql
SELECT *
FROM Produtos
WHERE Preco > (
    SELECT AVG(Preco)
    FROM Produtos
);
```

---

# 35. EXISTS

Verifica se existe pelo menos um registro.

```sql
SELECT c.*
FROM Clientes c
WHERE EXISTS (
    SELECT 1
    FROM Pedidos p
    WHERE p.ClienteID = c.ClienteID
);
```

## NOT EXISTS

Verifica ausência de registros relacionados.

---

# 36. ANY / SOME / ALL

Comparam com resultados de uma subconsulta.

```sql
SELECT *
FROM Produtos
WHERE Preco > ANY (
    SELECT Preco
    FROM Produtos
    WHERE CategoriaID = 1
);
```

``ALL`` exige que a comparação seja verdadeira para todos os valores.

---

# 37. UNION

Combina resultados e remove duplicados.

```sql
SELECT Nome FROM Clientes
UNION
SELECT Nome FROM Fornecedores;
```

## UNION ALL

Combina mantendo duplicados.

```sql
SELECT Nome FROM Clientes
UNION ALL
SELECT Nome FROM Fornecedores;
```

## INTERSECT

Retorna valores presentes nos dois resultados.

```sql
SELECT Cidade FROM Clientes
INTERSECT
SELECT Cidade FROM Fornecedores;
```

## EXCEPT

Retorna valores do primeiro resultado que não estão no segundo.

```sql
SELECT Cidade FROM Clientes
EXCEPT
SELECT Cidade FROM Fornecedores;
```

---

# 38. CTE — Common Table Expression

Cria uma consulta temporária nomeada durante a execução da instrução.

```sql
WITH ClientesAtivos AS (
    SELECT *
    FROM Clientes
    WHERE Ativo = 1
)
SELECT *
FROM ClientesAtivos;
```

## CTE recursiva

Útil para hierarquias.

```sql
WITH Hierarquia AS (
    SELECT FuncionarioID, Nome, GerenteID
    FROM Funcionarios
    WHERE GerenteID IS NULL

    UNION ALL

    SELECT f.FuncionarioID, f.Nome, f.GerenteID
    FROM Funcionarios f
    INNER JOIN Hierarquia h
        ON f.GerenteID = h.FuncionarioID
)
SELECT *
FROM Hierarquia;
```

---

# 39. Window Functions

Executam cálculos sobre um conjunto relacionado de linhas sem agrupá-las em uma única linha.

## OVER

Define a janela.

```sql
SELECT
    Nome,
    Salario,
    AVG(Salario) OVER () AS MediaGeral
FROM Funcionarios;
```

## PARTITION BY

Divide a janela em grupos.

```sql
SELECT
    Nome,
    DepartamentoID,
    Salario,
    AVG(Salario) OVER (
        PARTITION BY DepartamentoID
    ) AS MediaDepartamento
FROM Funcionarios;
```

## ROW_NUMBER

Numera linhas.

```sql
SELECT
    Nome,
    ROW_NUMBER() OVER (ORDER BY Salario DESC) AS Posicao
FROM Funcionarios;
```

## RANK

Classifica permitindo empates e pulando posições.

```sql
SELECT
    Nome,
    RANK() OVER (ORDER BY Salario DESC) AS Ranking
FROM Funcionarios;
```

## DENSE_RANK

Classifica permitindo empates sem pular posições.

```sql
SELECT
    Nome,
    DENSE_RANK() OVER (ORDER BY Salario DESC) AS Ranking
FROM Funcionarios;
```

## NTILE

Divide linhas em grupos.

```sql
SELECT
    Nome,
    NTILE(4) OVER (ORDER BY Salario DESC) AS Quartil
FROM Funcionarios;
```

## LAG

Acessa uma linha anterior.

```sql
SELECT
    DataVenda,
    Valor,
    LAG(Valor) OVER (ORDER BY DataVenda) AS ValorAnterior
FROM Vendas;
```

## LEAD

Acessa uma linha posterior.

```sql
SELECT
    DataVenda,
    Valor,
    LEAD(Valor) OVER (ORDER BY DataVenda) AS ProximoValor
FROM Vendas;
```

## FIRST_VALUE / LAST_VALUE

Obtêm o primeiro/último valor da janela.

---

# 40. PIVOT

Transforma linhas em colunas.

```sql
SELECT *
FROM (
    SELECT Ano, Mes, Valor
    FROM Vendas
) AS Fonte
PIVOT (
    SUM(Valor)
    FOR Mes IN ([1], [2], [3], [4])
) AS P;
```

# 41. UNPIVOT

Transforma colunas em linhas.

```sql
SELECT *
FROM MinhaTabela
UNPIVOT (
    Valor FOR Mes IN (Jan, Fev, Mar)
) AS U;
```

---

# 42. Views

Uma view é uma consulta armazenada que pode ser usada como tabela lógica.

## CREATE VIEW

```sql
CREATE VIEW dbo.vw_ClientesAtivos
AS
SELECT ClienteID, Nome, Email
FROM dbo.Clientes
WHERE Ativo = 1;
```

## Consultar

```sql
SELECT *
FROM dbo.vw_ClientesAtivos;
```

## ALTER VIEW

```sql
ALTER VIEW dbo.vw_ClientesAtivos
AS
SELECT ClienteID, Nome
FROM dbo.Clientes
WHERE Ativo = 1;
```

## DROP VIEW

```sql
DROP VIEW dbo.vw_ClientesAtivos;
```

---

# 43. Índices

Índices ajudam o SQL Server a localizar dados com eficiência.

## CREATE INDEX

```sql
CREATE INDEX IX_Clientes_Email
ON Clientes(Email);
```

## Índice UNIQUE

```sql
CREATE UNIQUE INDEX IX_Clientes_Email
ON Clientes(Email);
```

## Índice composto

```sql
CREATE INDEX IX_Pedidos_Cliente_Data
ON Pedidos(ClienteID, DataPedido);
```

## INCLUDE

Inclui colunas adicionais no índice.

```sql
CREATE INDEX IX_Pedidos_Cliente
ON Pedidos(ClienteID)
INCLUDE (DataPedido, Valor);
```

## DROP INDEX

```sql
DROP INDEX IX_Clientes_Email
ON Clientes;
```

---

# 44. Índice clustered

Define a organização física lógica das páginas da tabela em torno da chave do índice.

```sql
CREATE CLUSTERED INDEX IX_Clientes_ID
ON Clientes(ClienteID);
```

Uma tabela pode ter no máximo um índice clustered.

---

# 45. Índice nonclustered

Estrutura separada que aponta para os dados.

```sql
CREATE NONCLUSTERED INDEX IX_Clientes_Nome
ON Clientes(Nome);
```

Uma tabela pode possuir vários índices nonclustered.

---

# 46. Stored Procedures

Procedimentos armazenados executam lógica no servidor.

## CREATE PROCEDURE

```sql
CREATE PROCEDURE dbo.BuscarCliente
    @ClienteID INT
AS
BEGIN
    SELECT *
    FROM Clientes
    WHERE ClienteID = @ClienteID;
END;
```

Executar:

```sql
EXEC dbo.BuscarCliente @ClienteID = 1;
```

## ALTER PROCEDURE

```sql
ALTER PROCEDURE dbo.BuscarCliente
    @ClienteID INT
AS
BEGIN
    SELECT Nome, Email
    FROM Clientes
    WHERE ClienteID = @ClienteID;
END;
```

## DROP PROCEDURE

```sql
DROP PROCEDURE dbo.BuscarCliente;
```

---

# 47. Parâmetros OUTPUT

Permitem devolver valores através de parâmetros.

```sql
CREATE PROCEDURE dbo.ContarClientes
    @Quantidade INT OUTPUT
AS
BEGIN
    SELECT @Quantidade = COUNT(*)
    FROM Clientes;
END;
```

Execução:

```sql
DECLARE @Total INT;

EXEC dbo.ContarClientes
    @Quantidade = @Total OUTPUT;

SELECT @Total;
```

---

# 48. Variáveis

Declarar:

```sql
DECLARE @Nome VARCHAR(100);
DECLARE @Id INT = 10;
```

Atribuir:

```sql
SET @Nome = 'Bruno';
```

Ou:

```sql
SELECT @Nome = Nome
FROM Clientes
WHERE ClienteID = 1;
```

---

# 49. IF / ELSE

```sql
IF @Idade >= 18
BEGIN
    PRINT 'Maior de idade';
END
ELSE
BEGIN
    PRINT 'Menor de idade';
END;
```

---

# 50. WHILE

Loop.

```sql
DECLARE @Contador INT = 1;

WHILE @Contador <= 10
BEGIN
    PRINT @Contador;
    SET @Contador += 1;
END;
```

## BREAK

Interrompe o loop.

```sql
BREAK;
```

## CONTINUE

Pula para a próxima iteração.

```sql
CONTINUE;
```

---

# 51. PRINT

Exibe mensagem.

```sql
PRINT 'Processamento concluído';
```

Para mensagens e diagnóstico mais controláveis:

```sql
RAISERROR('Mensagem', 10, 1);
```

---

# 52. THROW

Lança uma exceção.

```sql
THROW 50000, 'Erro personalizado', 1;
```

Dentro de tratamento de erros:

```sql
BEGIN CATCH
    THROW;
END CATCH;
```

---

# 53. TRY / CATCH

Tratamento de erros.

```sql
BEGIN TRY
    -- código que pode falhar
    INSERT INTO Clientes (ClienteID, Nome)
    VALUES (1, 'Bruno');
END TRY
BEGIN CATCH
    SELECT
        ERROR_NUMBER() AS Numero,
        ERROR_MESSAGE() AS Mensagem,
        ERROR_LINE() AS Linha,
        ERROR_PROCEDURE() AS Procedimento;
END CATCH;
```

---

# 54. Transações

Permitem agrupar operações em uma unidade lógica.

## BEGIN TRANSACTION

Inicia.

```sql
BEGIN TRANSACTION;
```

## COMMIT

Confirma.

```sql
COMMIT TRANSACTION;
```

## ROLLBACK

Desfaz.

```sql
ROLLBACK TRANSACTION;
```

Exemplo:

```sql
BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE Conta
    SET Saldo = Saldo - 100
    WHERE ContaID = 1;

    UPDATE Conta
    SET Saldo = Saldo + 100
    WHERE ContaID = 2;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
```

---

# 55. SAVE TRANSACTION

Cria um ponto de salvamento dentro da transação.

```sql
SAVE TRANSACTION Ponto1;
```

Voltar ao savepoint:

```sql
ROLLBACK TRANSACTION Ponto1;
```

---

# 56. Níveis de isolamento

Principais opções:

```sql
READ UNCOMMITTED
READ COMMITTED
REPEATABLE READ
SERIALIZABLE
SNAPSHOT
```

Exemplo:

```sql
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
```

### NOLOCK

```sql
SELECT *
FROM Clientes WITH (NOLOCK);
```

Permite leituras sem bloqueio compartilhado, mas pode produzir leituras inconsistentes. Não deve ser tratado simplesmente como uma otimização gratuita.

---

# 57. Table Hints

Sintaxe:

```sql
SELECT *
FROM Clientes WITH (INDEX(IX_Clientes_Nome));
```

Outros hints comuns:

```sql
NOLOCK
UPDLOCK
HOLDLOCK
ROWLOCK
TABLOCK
TABLOCKX
INDEX(...)
FORCESEEK
FORCESCAN
```

Use hints somente quando houver uma razão técnica clara.

---

# 58. Temp Tables

## Tabela temporária local

```sql
CREATE TABLE #ClientesTemp (
    ClienteID INT,
    Nome VARCHAR(100)
);
```

Existe durante a sessão/escopo aplicável.

## Tabela temporária global

```sql
CREATE TABLE ##ClientesTemp (
    ClienteID INT,
    Nome VARCHAR(100)
);
```

Pode ser acessada por outras sessões enquanto existir.

---

# 59. SELECT INTO

Cria uma nova tabela com o resultado da consulta.

```sql
SELECT ClienteID, Nome
INTO ClientesBackup
FROM Clientes;
```

Também pode criar tabela temporária:

```sql
SELECT *
INTO #ClientesTemp
FROM Clientes;
```

---

# 60. Table Variables

Variável que armazena conjunto de dados.

```sql
DECLARE @Clientes TABLE (
    ClienteID INT,
    Nome VARCHAR(100)
);

INSERT INTO @Clientes
VALUES (1, 'Bruno');

SELECT *
FROM @Clientes;
```

---

# 61. Cursors

Permitem processamento linha a linha.

```sql
DECLARE ClienteCursor CURSOR FOR
SELECT ClienteID
FROM Clientes;

OPEN ClienteCursor;

FETCH NEXT FROM ClienteCursor INTO @ClienteID;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- processamento
    FETCH NEXT FROM ClienteCursor INTO @ClienteID;
END;

CLOSE ClienteCursor;
DEALLOCATE ClienteCursor;
```

> Cursors podem ser úteis em situações específicas, mas operações orientadas a conjuntos normalmente são preferíveis quando possível.

---

# 62. Sequences

Gera valores numéricos sequenciais.

## CREATE SEQUENCE

```sql
CREATE SEQUENCE dbo.SeqPedido
    AS INT
    START WITH 1
    INCREMENT BY 1;
```

Usar:

```sql
SELECT NEXT VALUE FOR dbo.SeqPedido;
```

---

# 63. IDENTITY

Gera valores automaticamente em uma coluna.

```sql
CREATE TABLE Clientes (
    ClienteID INT IDENTITY(1,1) PRIMARY KEY,
    Nome VARCHAR(100)
);
```

`IDENTITY(1,1)` significa início 1 e incremento 1.

---

# 64. SCOPE_IDENTITY

Recupera o último valor de IDENTITY gerado no mesmo escopo.

```sql
INSERT INTO Clientes (Nome)
VALUES ('Bruno');

SELECT SCOPE_IDENTITY();
```

---

# 65. @@IDENTITY e IDENT_CURRENT

`@@IDENTITY` retorna o último identity gerado na sessão, inclusive em alguns cenários envolvendo triggers.

`IDENT_CURRENT('Tabela')` retorna o último valor gerado para determinada tabela, independentemente da sessão.

Para obter o identity recém-inserido no próprio escopo, `SCOPE_IDENTITY()` costuma ser a opção mais apropriada.

---

# 66. OUTPUT

Permite retornar valores afetados por INSERT, UPDATE ou DELETE.

## INSERT

```sql
INSERT INTO Clientes (Nome)
OUTPUT inserted.ClienteID, inserted.Nome
VALUES ('Bruno');
```

## UPDATE

```sql
UPDATE Clientes
SET Nome = 'Bruno Saldanha'
OUTPUT deleted.Nome AS NomeAnterior,
       inserted.Nome AS NomeAtual
WHERE ClienteID = 1;
```

## DELETE

```sql
DELETE FROM Clientes
OUTPUT deleted.ClienteID, deleted.Nome
WHERE ClienteID = 1;
```

---

# 67. Triggers

Executam automaticamente em resposta a eventos.

## AFTER TRIGGER

```sql
CREATE TRIGGER trg_Clientes_Update
ON Clientes
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- lógica
END;
```

## INSTEAD OF TRIGGER

Executa a lógica do trigger no lugar da operação original.

```sql
CREATE TRIGGER trg_Clientes_Delete
ON Clientes
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- lógica
END;
```

> Triggers devem ser projetadas com cuidado porque podem adicionar lógica implícita às operações.

---

# 68. Funções

## Scalar Function

Retorna um valor.

```sql
CREATE FUNCTION dbo.CalcularDesconto
(
    @Preco DECIMAL(10,2),
    @Percentual DECIMAL(5,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @Preco - (@Preco * @Percentual / 100);
END;
```

Uso:

```sql
SELECT dbo.CalcularDesconto(100, 10);
```

## Inline Table-Valued Function

Retorna uma tabela.

```sql
CREATE FUNCTION dbo.ClientesPorCidade
(
    @Cidade VARCHAR(100)
)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM Clientes
    WHERE Cidade = @Cidade
);
```

---

# 69. JSON

T-SQL possui funções para trabalhar com JSON.

## ISJSON

Verifica se texto possui JSON válido.

```sql
SELECT ISJSON(@Json);
```

## JSON_VALUE

Obtém um valor escalar.

```sql
SELECT JSON_VALUE(@Json, '$.nome');
```

## JSON_QUERY

Obtém objeto ou array JSON.

```sql
SELECT JSON_QUERY(@Json, '$.endereco');
```

## JSON_MODIFY

Altera JSON.

```sql
SELECT JSON_MODIFY(@Json, '$.nome', 'Bruno');
```

## OPENJSON

Transforma JSON em linhas/colunas.

```sql
SELECT *
FROM OPENJSON(@Json);
```

Com schema:

```sql
SELECT *
FROM OPENJSON(@Json)
WITH (
    Nome VARCHAR(100) '$.nome',
    Idade INT '$.idade'
);
```

---

# 70. XML

## FOR XML

Transforma resultado em XML.

```sql
SELECT ClienteID, Nome
FROM Clientes
FOR XML AUTO;
```

## XML datatype

```sql
DECLARE @Dados XML;
```

Métodos comuns:

```sql
.value()
.query()
.exist()
.nodes()
.modify()
```

Exemplo:

```sql
SELECT @Dados.value('(/cliente/nome/text())[1]', 'VARCHAR(100)');
```

---

# 71. STRING_AGG

Concatena valores de várias linhas.

```sql
SELECT STRING_AGG(Nome, ', ')
FROM Clientes;
```

Com agrupamento:

```sql
SELECT Cidade,
       STRING_AGG(Nome, ', ') AS Clientes
FROM Clientes
GROUP BY Cidade;
```

---

# 72. STRING_SPLIT

Divide uma string em linhas.

```sql
SELECT value
FROM STRING_SPLIT('Java,Python,C,SQL', ',');
```

---

# 73. CONCAT e FORMAT

```sql
SELECT CONCAT(Nome, ' - ', Cidade)
FROM Clientes;
```

`FORMAT` formata valores usando regras de cultura .NET.

```sql
SELECT FORMAT(1234.56, 'N2', 'pt-BR');
```

> Para grandes volumes, `FORMAT` pode ser mais pesado que alternativas nativas.

---

# 74. COLLATE

Controla regras de comparação/ordenação de texto.

```sql
SELECT *
FROM Clientes
WHERE Nome COLLATE Latin1_General_CI_AI = 'Jose';
```

- `CI`: case-insensitive
- `CS`: case-sensitive
- `AI`: accent-insensitive
- `AS`: accent-sensitive

---

# 75. EXEC

Executa procedures ou SQL dinâmico.

```sql
EXEC dbo.BuscarCliente @ClienteID = 1;
```

SQL dinâmico:

```sql
DECLARE @SQL NVARCHAR(MAX);

SET @SQL = N'SELECT * FROM Clientes';

EXEC(@SQL);
```

---

# 76. sp_executesql

Executa SQL dinâmico parametrizado.

```sql
DECLARE @SQL NVARCHAR(MAX);

SET @SQL = N'
    SELECT *
    FROM Clientes
    WHERE ClienteID = @Id;
';

EXEC sys.sp_executesql
    @SQL,
    N'@Id INT',
    @Id = 1;
```

É preferível a concatenar valores diretamente no SQL dinâmico quando parâmetros podem ser usados.

---

# 77. Metadados — INFORMATION_SCHEMA

Exemplo:

```sql
SELECT *
FROM INFORMATION_SCHEMA.TABLES;
```

Colunas:

```sql
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Clientes';
```

---

# 78. Catálogo do sistema — sys

## Tabelas

```sql
SELECT *
FROM sys.tables;
```

## Colunas

```sql
SELECT *
FROM sys.columns;
```

## Índices

```sql
SELECT *
FROM sys.indexes;
```

## Objetos

```sql
SELECT *
FROM sys.objects;
```

## Procedures

```sql
SELECT *
FROM sys.procedures;
```

## Views

```sql
SELECT *
FROM sys.views;
```

## Chaves estrangeiras

```sql
SELECT *
FROM sys.foreign_keys;
```

---

# 79. Verificar existência de objetos

```sql
IF OBJECT_ID('dbo.Clientes', 'U') IS NOT NULL
    PRINT 'Tabela existe';
```

Tipos comuns:

- `U` — tabela
- `V` — view
- `P` — stored procedure
- `FN` — função escalar
- `IF` — função inline
- `TF` — função table-valued

---

# 80. Criar objeto somente se não existir

Sintaxe moderna:

```sql
CREATE TABLE IF NOT EXISTS
```

> **Atenção:** essa sintaxe não é suportada dessa forma pelo SQL Server tradicional. No SQL Server, normalmente usa-se uma verificação:

```sql
IF OBJECT_ID('dbo.Clientes', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Clientes (
        ClienteID INT PRIMARY KEY,
        Nome VARCHAR(100)
    );
END;
```

---

# 81. ALTER TABLE — operações comuns

Adicionar coluna:

```sql
ALTER TABLE Clientes
ADD CPF CHAR(11);
```

Alterar tipo:

```sql
ALTER TABLE Clientes
ALTER COLUMN CPF VARCHAR(14);
```

Adicionar chave:

```sql
ALTER TABLE Clientes
ADD CONSTRAINT PK_Clientes
PRIMARY KEY (ClienteID);
```

---

# 82. Segurança — usuários e logins

> Estes comandos dependem de permissões administrativas e do contexto do SQL Server.

## CREATE LOGIN

Cria login no servidor.

```sql
CREATE LOGIN usuario
WITH PASSWORD = 'SenhaForteAqui';
```

## CREATE USER

Cria usuário dentro do banco.

```sql
CREATE USER usuario
FOR LOGIN usuario;
```

## CREATE ROLE

Cria função/grupo de permissões.

```sql
CREATE ROLE Leitura;
```

## GRANT

Concede permissão.

```sql
GRANT SELECT ON dbo.Clientes TO Leitura;
```

## DENY

Nega explicitamente permissão.

```sql
DENY DELETE ON dbo.Clientes TO Leitura;
```

## REVOKE

Remove uma permissão concedida/negada explicitamente.

```sql
REVOKE SELECT ON dbo.Clientes FROM Leitura;
```

## ALTER ROLE

Adiciona/remova membro de uma role.

```sql
ALTER ROLE db_datareader ADD MEMBER usuario;
```

---

# 83. BACKUP

Backup completo:

```sql
BACKUP DATABASE MeuBanco
TO DISK = 'C:\Backup\MeuBanco.bak';
```

Backup diferencial:

```sql
BACKUP DATABASE MeuBanco
TO DISK = 'C:\Backup\MeuBanco_diff.bak'
WITH DIFFERENTIAL;
```

Backup do log:

```sql
BACKUP LOG MeuBanco
TO DISK = 'C:\Backup\MeuBanco_log.trn';
```

> O caminho e as permissões precisam ser válidos para o servidor SQL Server.

---

# 84. RESTORE

Consultar backup:

```sql
RESTORE HEADERONLY
FROM DISK = 'C:\Backup\MeuBanco.bak';
```

Ver arquivos:

```sql
RESTORE FILELISTONLY
FROM DISK = 'C:\Backup\MeuBanco.bak';
```

Restaurar:

```sql
RESTORE DATABASE MeuBanco
FROM DISK = 'C:\Backup\MeuBanco.bak';
```

---

# 85. DBCC

Comandos de diagnóstico e manutenção.

Exemplo:

```sql
DBCC CHECKDB('MeuBanco');
```

Outros comandos conhecidos incluem:

```sql
DBCC CHECKTABLE
DBCC CHECKCONSTRAINTS
DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS
DBCC SHRINKDATABASE
DBCC SHRINKFILE
```

> Alguns comandos DBCC têm impacto significativo. Não devem ser executados indiscriminadamente em produção.

---

# 86. Estatísticas

## UPDATE STATISTICS

Atualiza estatísticas de uma tabela/índice.

```sql
UPDATE STATISTICS Clientes;
```

## CREATE STATISTICS

Cria estatística manual.

```sql
CREATE STATISTICS ST_Clientes_Nome
ON Clientes(Nome);
```

## DROP STATISTICS

Remove estatística.

```sql
DROP STATISTICS Clientes.ST_Clientes_Nome;
```

---

# 87. Plano de execução

No SQL Server Management Studio, o plano de execução ajuda a entender como a consulta foi executada.

Comandos úteis:

```sql
SET SHOWPLAN_TEXT ON;
SET SHOWPLAN_ALL ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
```

Desativar:

```sql
SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
```

> `SHOWPLAN` possui requisitos específicos e pode impedir a execução normal das consultas enquanto estiver ativo.

---

# 88. SET NOCOUNT

Evita mensagens de contagem de linhas afetadas em procedures/triggers.

```sql
SET NOCOUNT ON;
```

Muito comum em stored procedures.

---

# 89. SET IDENTITY_INSERT

Permite inserir manualmente valores em uma coluna IDENTITY.

```sql
SET IDENTITY_INSERT Clientes ON;

INSERT INTO Clientes (ClienteID, Nome)
VALUES (100, 'Bruno');

SET IDENTITY_INSERT Clientes OFF;
```

Somente uma tabela por sessão pode ter `IDENTITY_INSERT ON`.

---

# 90. SET XACT_ABORT

Faz a transação ser automaticamente revertida em determinados erros de execução.

```sql
SET XACT_ABORT ON;
```

Frequentemente combinado com TRY/CATCH e transações.

---

# 91. SET ANSI_NULLS

Controla comportamento de comparações com NULL em determinados contextos.

```sql
SET ANSI_NULLS ON;
```

Para código moderno, normalmente deve permanecer habilitado.

---

# 92. SET QUOTED_IDENTIFIER

Controla interpretação de aspas duplas.

```sql
SET QUOTED_IDENTIFIER ON;
```

---

# 93. Operadores de atribuição

```sql
SET @x = 10;

SET @x += 5;
SET @x -= 5;
SET @x *= 5;
SET @x /= 5;
SET @x %= 5;
```

---

# 94. Operadores bitwise

```sql
&
|
^
~
```

Exemplo:

```sql
SELECT 5 & 3;
```

---

# 95. Operadores matemáticos

```sql
+
-
*
/
%
```

---

# 96. Precedência de operações

Use parênteses para deixar a intenção explícita:

```sql
SELECT (10 + 5) * 2;
```

---

# 97. Alias de tabela

```sql
SELECT c.Nome
FROM Clientes AS c;
```

---

# 98. Alias de coluna

```sql
SELECT Nome AS NomeCliente
FROM Clientes;
```

---

# 99. DISTINCT em agregações

```sql
SELECT SUM(DISTINCT Valor)
FROM Vendas;
```

---

# 100. SELECT INTO para cópia rápida

```sql
SELECT *
INTO ClientesBackup
FROM Clientes;
```

> Cria uma nova tabela; não copia automaticamente todos os índices, constraints e objetos associados à tabela original.

---

# 101. INSERT ... EXEC

Insere resultado de uma procedure em uma tabela.

```sql
INSERT INTO #Resultado
EXEC dbo.MinhaProcedure;
```

---

# 102. Table-Valued Parameters

Permitem passar conjuntos de dados para procedures.

Primeiro cria-se um tipo:

```sql
CREATE TYPE dbo.ClienteTableType AS TABLE
(
    ClienteID INT,
    Nome VARCHAR(100)
);
```

Procedure:

```sql
CREATE PROCEDURE dbo.ProcessarClientes
    @Clientes dbo.ClienteTableType READONLY
AS
BEGIN
    SELECT *
    FROM @Clientes;
END;
```

> Parâmetros table-valued são somente leitura dentro da rotina.

---

# 103. ROWVERSION

Tipo usado para controlar alterações de versão de linhas.

```sql
CREATE TABLE Produtos (
    ProdutoID INT PRIMARY KEY,
    Nome VARCHAR(100),
    Versao ROWVERSION
);
```

> `rowversion` não representa data/hora.

---

# 104. UNIQUEIDENTIFIER

Identificador globalmente único.

```sql
DECLARE @Id UNIQUEIDENTIFIER = NEWID();

SELECT @Id;
```

## NEWSEQUENTIALID

Pode ser usado como default em uma coluna UNIQUEIDENTIFIER para gerar GUIDs sequenciais.

```sql
Id UNIQUEIDENTIFIER
    DEFAULT NEWSEQUENTIALID()
```

---

# 105. Funções de sistema úteis

```sql
@@VERSION
@@SERVERNAME
@@SPID
@@ROWCOUNT
@@ERROR
@@IDENTITY
@@TRANCOUNT
```

Exemplos:

```sql
SELECT @@VERSION;
SELECT @@SERVERNAME;
SELECT @@ROWCOUNT;
SELECT @@TRANCOUNT;
```

---

# 106. Funções de erro

Dentro de CATCH:

```sql
ERROR_NUMBER()
ERROR_SEVERITY()
ERROR_STATE()
ERROR_PROCEDURE()
ERROR_LINE()
ERROR_MESSAGE()
```

---

# 107. Funções de contexto

```sql
DB_NAME()
SCHEMA_NAME()
OBJECT_NAME()
SUSER_SNAME()
SYSTEM_USER
CURRENT_USER
USER_NAME()
HOST_NAME()
APP_NAME()
```

---

# 108. Hierarquias

O tipo `hierarchyid` representa posições em estruturas hierárquicas.

Métodos comuns:

```sql
GetAncestor()
GetDescendant()
GetLevel()
IsDescendantOf()
ToString()
Parse()
```

---

# 109. Geografia e geometria

SQL Server oferece tipos espaciais:

```sql
GEOGRAPHY
GEOMETRY
```

Exemplo:

```sql
DECLARE @Local GEOGRAPHY =
    geography::Point(-29.6868, -53.8069, 4326);
```

---

# 110. FULL-TEXT SEARCH

Recursos para pesquisa textual avançada.

Comandos/objetos comuns:

```sql
CONTAINS()
FREETEXT()
CONTAINSTABLE()
FREETEXTTABLE()
```

Exemplo:

```sql
SELECT *
FROM Documentos
WHERE CONTAINS(Conteudo, 'SQL');
```

---

# 111. Busca textual com wildcard

```sql
WHERE Nome LIKE '%SQL%'
```

Para pesquisa textual mais avançada, considere Full-Text Search.

---

# 112. CROSS APPLY

Aplica uma expressão/tabela relacionada a cada linha da origem.

```sql
SELECT c.ClienteID, p.PedidoID
FROM Clientes c
CROSS APPLY (
    SELECT TOP 1 *
    FROM Pedidos p
    WHERE p.ClienteID = c.ClienteID
    ORDER BY p.DataPedido DESC
) p;
```

---

# 113. OUTER APPLY

Semelhante ao CROSS APPLY, mas preserva linhas da esquerda mesmo quando não há resultado à direita.

```sql
SELECT c.ClienteID, p.PedidoID
FROM Clientes c
OUTER APPLY (
    SELECT TOP 1 *
    FROM Pedidos p
    WHERE p.ClienteID = c.ClienteID
    ORDER BY p.DataPedido DESC
) p;
```

---

# 114. WITH TIES

Inclui linhas empatadas com a última posição do TOP.

```sql
SELECT TOP 10 WITH TIES *
FROM Produtos
ORDER BY Preco DESC;
```

---

# 115. WITH (CTE + hints)

A palavra `WITH` possui diferentes usos em T-SQL.

CTE:

```sql
WITH Dados AS (
    SELECT *
    FROM Clientes
)
SELECT *
FROM Dados;
```

Table hint:

```sql
SELECT *
FROM Clientes WITH (NOLOCK);
```

---

# 116. Constraints nomeadas

Boa prática para facilitar manutenção:

```sql
CONSTRAINT PK_Clientes PRIMARY KEY (ClienteID),
CONSTRAINT CK_Clientes_Idade CHECK (Idade >= 0),
CONSTRAINT UQ_Clientes_Email UNIQUE (Email),
CONSTRAINT FK_Pedidos_Clientes
    FOREIGN KEY (ClienteID)
    REFERENCES Clientes(ClienteID)
```

---

# 117. Ordem lógica de processamento de SELECT

Embora a consulta seja escrita normalmente como:

```sql
SELECT
FROM
JOIN
WHERE
GROUP BY
HAVING
ORDER BY
```

a ordem lógica de processamento é aproximadamente:

1. FROM
2. JOIN / ON
3. WHERE
4. GROUP BY
5. HAVING
6. SELECT
7. DISTINCT
8. ORDER BY
9. TOP / OFFSET-FETCH

Isso ajuda a entender por que um alias criado no `SELECT` geralmente não pode ser usado diretamente no `WHERE`.

---

# 118. Modelo completo de consulta

```sql
SELECT
    c.ClienteID,
    c.Nome,
    COUNT(p.PedidoID) AS QuantidadePedidos,
    SUM(p.Valor) AS TotalGasto
FROM Clientes AS c
LEFT JOIN Pedidos AS p
    ON p.ClienteID = c.ClienteID
WHERE c.Ativo = 1
GROUP BY
    c.ClienteID,
    c.Nome
HAVING COUNT(p.PedidoID) > 0
ORDER BY TotalGasto DESC;
```

---

# 119. Modelo completo com transação e tratamento de erro

```sql
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE Contas
    SET Saldo = Saldo - 100
    WHERE ContaID = 1;

    UPDATE Contas
    SET Saldo = Saldo + 100
    WHERE ContaID = 2;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
```

---

# 120. Checklist rápido

## Consultas

- `SELECT`
- `FROM`
- `WHERE`
- `JOIN`
- `GROUP BY`
- `HAVING`
- `ORDER BY`
- `DISTINCT`
- `TOP`
- `OFFSET / FETCH`

## Manipulação

- `INSERT`
- `UPDATE`
- `DELETE`
- `MERGE`
- `OUTPUT`

## Estrutura

- `CREATE`
- `ALTER`
- `DROP`
- `TRUNCATE`

## Programação

- `DECLARE`
- `SET`
- `IF / ELSE`
- `WHILE`
- `BREAK`
- `CONTINUE`
- `TRY / CATCH`
- `THROW`
- `RAISERROR`
- `EXEC`

## Banco

- `CREATE DATABASE`
- `ALTER DATABASE`
- `BACKUP`
- `RESTORE`
- `DBCC`

## Objetos

- Tables
- Views
- Procedures
- Functions
- Triggers
- Indexes
- Sequences
- Schemas
- Roles

## Consultas avançadas

- CTE
- CTE recursiva
- Subquery
- EXISTS
- UNION
- INTERSECT
- EXCEPT
- APPLY
- PIVOT
- UNPIVOT
- Window Functions

## Dados modernos

- JSON
- XML
- STRING_AGG
- STRING_SPLIT
- Full-Text Search
- GEOGRAPHY
- GEOMETRY

---

# 121. Boas práticas rápidas

1. Evite `SELECT *` em código de produção quando você conhece as colunas necessárias.
2. Use aliases claros em consultas com várias tabelas.
3. Sempre revise o `WHERE` antes de executar `UPDATE` ou `DELETE`.
4. Prefira operações orientadas a conjuntos em vez de processamento linha a linha.
5. Use parâmetros em SQL dinâmico.
6. Evite concatenar entrada do usuário diretamente em SQL.
7. Crie índices de acordo com os padrões reais de consulta.
8. Não crie índices indiscriminadamente: eles também têm custo de manutenção.
9. Use transações quando várias alterações precisam ser confirmadas como uma unidade.
10. Trate erros explicitamente em rotinas importantes.
11. Não use `NOLOCK` apenas para tentar acelerar consultas sem entender suas consequências.
12. Analise planos de execução e estatísticas antes de fazer otimizações.
13. Escolha tipos de dados adequados ao domínio.
14. Nomeie constraints, índices e objetos de forma consistente.
15. Mantenha backup e restore testados; possuir um backup sem testar recuperação não garante uma estratégia de recuperação funcional.

---

# 122. Diferenças importantes: SQL x T-SQL

**SQL** é a linguagem padrão/conjunto de conceitos usado para trabalhar com bancos relacionais.

**T-SQL (Transact-SQL)** é a implementação/extensão da Microsoft usada pelo SQL Server.

T-SQL adiciona, entre outros:

- Variáveis
- `IF/ELSE`
- `WHILE`
- `TRY/CATCH`
- `THROW`
- Stored Procedures
- Functions
- Triggers
- CTEs
- Table Variables
- Temp Tables
- `TOP`
- `OUTPUT`
- Funções específicas do SQL Server
- Ferramentas administrativas e de diagnóstico

---

## Referência oficial

Para consultar sintaxe completa e recursos específicos da versão do SQL Server, consulte a documentação oficial da Microsoft sobre Transact-SQL.

> Este arquivo deve ser tratado como **cheat sheet de estudo**, não como substituto da documentação oficial. Alguns recursos dependem da versão do SQL Server e podem ter diferenças entre versões/edições.
