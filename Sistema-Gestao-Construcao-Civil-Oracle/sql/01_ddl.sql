-- ============================================================
-- SISTEMA DE GESTAO DE CONSTRUCAO CIVIL E OBRAS
-- Oracle SQL - DDL
-- ============================================================

CREATE TABLE Construtora (
    id_construtora NUMBER PRIMARY KEY,
    nome_construtora VARCHAR2(100) NOT NULL,
    cnpj VARCHAR2(18) UNIQUE NOT NULL,
    telefone VARCHAR2(20),
    email VARCHAR2(100)
);

CREATE TABLE Obra (
    id_obra NUMBER PRIMARY KEY,
    id_construtora NUMBER NOT NULL,
    nome_obra VARCHAR2(100) NOT NULL,
    endereco VARCHAR2(150),
    data_inicio DATE NOT NULL,
    data_previsao_fim DATE,
    orcamento NUMBER(12, 2),
    status VARCHAR2(20) CHECK (
        status IN ('Planejamento', 'Em Andamento', 'Concluida', 'Pausada')
    ),
    CONSTRAINT fk_obra_construtora
        FOREIGN KEY (id_construtora)
        REFERENCES Construtora(id_construtora)
);

CREATE TABLE Trabalhador (
    id_trabalhador NUMBER PRIMARY KEY,
    id_obra NUMBER NOT NULL,
    cpf VARCHAR2(14) UNIQUE NOT NULL,
    nome VARCHAR2(100) NOT NULL,
    cargo VARCHAR2(50),
    salario NUMBER(8, 2),
    data_admissao DATE,
    CONSTRAINT fk_trabalhador_obra
        FOREIGN KEY (id_obra)
        REFERENCES Obra(id_obra)
);

CREATE TABLE Equipamento (
    id_equipamento NUMBER PRIMARY KEY,
    id_obra NUMBER NOT NULL,
    nome_equipamento VARCHAR2(100) NOT NULL,
    tipo VARCHAR2(50),
    valor_diaria NUMBER(8, 2),
    status_manutencao VARCHAR2(20) CHECK (
        status_manutencao IN ('Operacional', 'Em Manutencao', 'Inativo')
    ),
    CONSTRAINT fk_equipamento_obra
        FOREIGN KEY (id_obra)
        REFERENCES Obra(id_obra)
);
