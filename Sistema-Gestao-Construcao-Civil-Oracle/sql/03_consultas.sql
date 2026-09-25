-- ============================================================
-- SISTEMA DE GESTAO DE CONSTRUCAO CIVIL E OBRAS
-- Oracle SQL - DQL
-- ============================================================

SELECT
    c.nome_construtora,
    o.nome_obra,
    o.status,
    COUNT(t.id_trabalhador) AS total_trabalhadores,
    SUM(t.salario) AS custo_folha_mensal
FROM Construtora c
JOIN Obra o
    ON c.id_construtora = o.id_construtora
LEFT JOIN Trabalhador t
    ON o.id_obra = t.id_obra
WHERE o.status = 'Em Andamento'
GROUP BY
    c.nome_construtora,
    o.nome_obra,
    o.status;

SELECT
    o.id_obra,
    o.nome_obra,
    c.nome_construtora,
    o.status,
    o.orcamento
FROM Obra o
JOIN Construtora c
    ON o.id_construtora = c.id_construtora;

SELECT
    t.nome AS trabalhador,
    t.cargo,
    o.nome_obra
FROM Trabalhador t
JOIN Obra o
    ON t.id_obra = o.id_obra;

SELECT
    o.nome_obra,
    SUM(e.valor_diaria) AS custo_diario_equipamentos
FROM Obra o
JOIN Equipamento e
    ON o.id_obra = e.id_obra
GROUP BY o.nome_obra;
