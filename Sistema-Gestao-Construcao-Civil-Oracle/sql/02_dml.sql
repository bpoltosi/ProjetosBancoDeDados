-- ============================================================
-- SISTEMA DE GESTAO DE CONSTRUCAO CIVIL E OBRAS
-- Oracle SQL - DML
-- ============================================================

INSERT INTO Construtora (
    id_construtora, nome_construtora, cnpj, telefone, email
) VALUES (
    1, 'Engenharia & Cia', '12.345.678/0001-90',
    '(51) 99999-1111', 'contato@engcia.com'
);

INSERT INTO Obra (
    id_obra, id_construtora, nome_obra, endereco,
    data_inicio, data_previsao_fim, orcamento, status
) VALUES (
    101, 1, 'Edificio Horizonte',
    'Av. Ipiranga, 1000 - Porto Alegre',
    DATE '2026-01-15', DATE '2027-12-20',
    2500000.00, 'Em Andamento'
);

INSERT INTO Trabalhador (
    id_trabalhador, id_obra, cpf, nome, cargo, salario, data_admissao
) VALUES (
    1001, 101, '123.456.789-00', 'Carlos Silva',
    'Engenheiro Civil', 8500.00, DATE '2026-01-20'
);

INSERT INTO Equipamento (
    id_equipamento, id_obra, nome_equipamento, tipo,
    valor_diaria, status_manutencao
) VALUES (
    5001, 101, 'Escavadeira Hidraulica Cat 320',
    'Maquinario Pesado', 450.00, 'Operacional'
);

-- Exemplo de UPDATE
UPDATE Obra
SET status = 'Em Andamento'
WHERE id_obra = 101;

-- Exemplo de DELETE
-- DELETE FROM Obra WHERE id_obra = 101;

COMMIT;
