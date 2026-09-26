# NoSQL — Guia de Referência

> NoSQL não é uma única linguagem ou banco. Este arquivo reúne operações e conceitos comuns, usando principalmente MongoDB como referência prática para bancos orientados a documentos.

## 1. Principais modelos
- **Documentos:** MongoDB, CouchDB
- **Chave-valor:** Redis, Valkey
- **Colunar:** Cassandra, ScyllaDB
- **Grafos:** Neo4j
- **Busca/documentos:** Elasticsearch / OpenSearch

## 2. Quando considerar NoSQL
- Dados sem esquema rígido ou com estrutura variável.
- Grande volume e/ou necessidade de escala horizontal.
- Aplicações que trabalham naturalmente com documentos ou pares chave-valor.
- Baixa necessidade de JOINs relacionais complexos.

> NoSQL não significa “sem estrutura”: o modelo e as regras de consistência continuam importantes.

## 3. MongoDB — conexão e banco
```javascript
use minha_app
db.createCollection("usuarios")
show dbs
show collections
db.dropDatabase()
```

## 4. Inserção
```javascript
db.usuarios.insertOne({
  nome: "Bruno",
  idade: 20,
  ativo: true
})

db.usuarios.insertMany([
  { nome: "Ana", idade: 21 },
  { nome: "Carlos", idade: 25 }
])
```

## 5. Consulta
```javascript
db.usuarios.find()
db.usuarios.findOne({ nome: "Bruno" })

db.usuarios.find({ idade: { $gte: 18 } })
db.usuarios.find({ ativo: true })
db.usuarios.find({ cidade: { $in: ["Santa Maria", "Porto Alegre"] } })

db.usuarios.find(
  { idade: { $gte: 18 } },
  { nome: 1, idade: 1, _id: 0 }
)
```

## 6. Operadores
### Comparação
`$eq`, `$ne`, `$gt`, `$gte`, `$lt`, `$lte`, `$in`, `$nin`

### Lógicos
`$and`, `$or`, `$nor`, `$not`

### Elementos
`$exists`, `$type`

### Arrays
`$all`, `$elemMatch`, `$size`

## 7. Atualização
```javascript
db.usuarios.updateOne(
  { nome: "Bruno" },
  { $set: { ativo: false } }
)

db.usuarios.updateMany(
  { idade: { $lt: 18 } },
  { $set: { categoria: "menor" } }
)

db.usuarios.updateOne(
  { nome: "Bruno" },
  { $inc: { idade: 1 } }
)
```

Operadores frequentes: `$set`, `$unset`, `$inc`, `$mul`, `$min`, `$max`, `$rename`, `$push`, `$addToSet`, `$pop`, `$pull`.

## 8. Remoção
```javascript
db.usuarios.deleteOne({ nome: "Bruno" })
db.usuarios.deleteMany({ ativo: false })
```

## 9. Ordenação, paginação e contagem
```javascript
db.usuarios.find().sort({ idade: -1 })
db.usuarios.find().skip(20).limit(10)
db.usuarios.countDocuments({ ativo: true })
```

## 10. Agregação
```javascript
db.usuarios.aggregate([
  { $match: { ativo: true } },
  { $group: {
      _id: "$cidade",
      total: { $sum: 1 },
      idadeMedia: { $avg: "$idade" }
  }},
  { $sort: { total: -1 } }
])
```

Operadores/pipelines comuns:
`$match`, `$project`, `$group`, `$sort`, `$limit`, `$skip`, `$unwind`, `$lookup`, `$set`, `$unset`, `$count`, `$facet`.

## 11. Índices
```javascript
db.usuarios.createIndex({ email: 1 })
db.usuarios.createIndex({ email: 1 }, { unique: true })
db.usuarios.getIndexes()
db.usuarios.dropIndex({ email: 1 })
```

Tipos comuns:
- Single-field
- Compound
- Unique
- Multikey
- Text
- TTL
- Geospatial

## 12. Validação de documentos
MongoDB permite configurar JSON Schema validation para impor regras de estrutura e tipos.

## 13. Relacionamentos
Há duas estratégias principais:
- **Embedding:** dados relacionados dentro do mesmo documento.
- **Referencing:** armazenar IDs/referências entre documentos.

A escolha depende de acesso, tamanho, frequência de atualização e consistência.

## 14. Transações
MongoDB suporta transações para operações que precisam de atomicidade em cenários compatíveis. Use-as quando a consistência transacional for realmente necessária.

## 15. Redis / Valkey — comandos essenciais
```text
SET usuario:1 "Bruno"
GET usuario:1
DEL usuario:1
EXISTS usuario:1
EXPIRE usuario:1 3600
TTL usuario:1

HSET usuario:1 nome "Bruno" idade 20
HGET usuario:1 nome
HGETALL usuario:1

LPUSH fila tarefa1
RPOP fila

SADD cursos SQL
SMEMBERS cursos
SISMEMBER cursos SQL

KEYS *
SCAN 0
```

> Em produção, prefira `SCAN` a `KEYS *` em bases grandes.

## 16. Cassandra — conceitos/comandos básicos
```sql
CREATE KEYSPACE app
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

CREATE TABLE app.usuarios (
    id UUID PRIMARY KEY,
    nome TEXT,
    idade INT
);

INSERT INTO app.usuarios (id, nome, idade)
VALUES (uuid(), 'Bruno', 20);

SELECT * FROM app.usuarios;
```

Cassandra usa CQL, uma linguagem parecida com SQL, mas com modelo e limitações próprios.

## 17. Neo4j — Cypher básico
```cypher
CREATE (u:Usuario {nome: "Bruno", idade: 20});

MATCH (u:Usuario)
WHERE u.idade >= 18
RETURN u;

MATCH (a:Usuario {nome: "Bruno"}), (b:Usuario {nome: "Ana"})
CREATE (a)-[:CONHECE]->(b);

MATCH (a:Usuario)-[:CONHECE]->(b)
RETURN a, b;
```

## 18. Conceitos que você precisa dominar
- Schema flexibility
- Document model
- Embedding vs referencing
- Indexação
- Particionamento/sharding
- Replicação
- Consistência e disponibilidade
- Eventual consistency
- CAP theorem
- Idempotência
- TTL
- Cache
- Escala horizontal
- Modelagem orientada aos padrões de acesso

## 19. SQL × NoSQL
| SQL | NoSQL |
|---|---|
| Tabelas | Documentos/chaves/grafos/colunas |
| Schema mais rígido | Estrutura frequentemente flexível |
| JOINs | Embedding/referências ou mecanismos específicos |
| Transações relacionais | Consistência depende do banco/modelo |
| Escala vertical + horizontal | Frequentemente orientado à escala horizontal |
| Excelente para relações complexas | Excelente para modelos e acessos específicos |

**Boa prática:** escolha o banco pelo modelo de dados, consultas, consistência, escala e requisitos da aplicação — não apenas pela popularidade.
