-- =====================================================================
-- Ô, Meu! Troca Esse Disco — DDL (criação da estrutura)
-- SGBD: MySQL 8.0.46 (CHECK só é aplicado a partir da 8.0.16)
-- Ordem de execução: 1) este arquivo (DDL)  2) database/dml  3) database/dql
-- Atenção: o DROP DATABASE abaixo apaga o banco inteiro para recriá-lo do zero.
-- =====================================================================

DROP DATABASE IF EXISTS omeu_troca_esse_disco;

CREATE DATABASE omeu_troca_esse_disco
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE omeu_troca_esse_disco;

-- ---------------------------------------------------------------------
-- 1) CANTOR (não depende de nenhuma outra tabela)
-- ---------------------------------------------------------------------
CREATE TABLE cantor (
    id_cantor         INT          NOT NULL AUTO_INCREMENT,
    nome              VARCHAR(100) NOT NULL,
    biografia         TEXT         NULL,
    genero_principal  VARCHAR(50)  NOT NULL,
    CONSTRAINT pk_cantor PRIMARY KEY (id_cantor)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 2) CD (não depende de nenhuma outra tabela)
-- ---------------------------------------------------------------------
CREATE TABLE cd (
    id_cd            INT          NOT NULL AUTO_INCREMENT,
    nome             VARCHAR(150) NOT NULL,
    gravadora        VARCHAR(100) NOT NULL,
    data_lancamento  DATE         NOT NULL,
    CONSTRAINT pk_cd PRIMARY KEY (id_cd)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 3) CLIENTE (não depende de nenhuma outra tabela)
-- ---------------------------------------------------------------------
CREATE TABLE cliente (
    id_cliente  INT          NOT NULL AUTO_INCREMENT,
    nome        VARCHAR(100) NOT NULL,
    email       VARCHAR(150) NOT NULL,
    CONSTRAINT pk_cliente PRIMARY KEY (id_cliente),
    CONSTRAINT uq_cliente_email UNIQUE (email)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 4) MUSICA (depende de CD e CANTOR) — PK composta (id_cd, numero_musica)
-- ---------------------------------------------------------------------
CREATE TABLE musica (
    id_cd           INT               NOT NULL,
    numero_musica   TINYINT UNSIGNED  NOT NULL,
    titulo          VARCHAR(150)      NOT NULL,
    tempo_segundos  SMALLINT UNSIGNED NOT NULL,
    genero          VARCHAR(50)       NOT NULL,
    id_cantor       INT               NOT NULL,
    CONSTRAINT pk_musica PRIMARY KEY (id_cd, numero_musica),
    CONSTRAINT fk_musica_cd FOREIGN KEY (id_cd)
        REFERENCES cd (id_cd)
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_musica_cantor FOREIGN KEY (id_cantor)
        REFERENCES cantor (id_cantor)
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT ck_musica_numero CHECK (numero_musica >= 1),
    CONSTRAINT ck_musica_tempo  CHECK (tempo_segundos > 0)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 5) EXEMPLAR (depende de CD)
-- ---------------------------------------------------------------------
CREATE TABLE exemplar (
    id_exemplar   INT           NOT NULL AUTO_INCREMENT,
    id_cd         INT           NOT NULL,
    conservacao   VARCHAR(10)   NOT NULL,
    status        VARCHAR(15)   NOT NULL,
    preco_base    DECIMAL(10,2) NOT NULL,
    data_entrada  DATE          NOT NULL,
    CONSTRAINT pk_exemplar PRIMARY KEY (id_exemplar),
    CONSTRAINT fk_exemplar_cd FOREIGN KEY (id_cd)
        REFERENCES cd (id_cd)
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT ck_exemplar_conservacao
        CHECK (conservacao IN ('REGULAR', 'BOM', 'OTIMO', 'NOVO')),
    CONSTRAINT ck_exemplar_status
        CHECK (status IN ('DISPONIVEL', 'TROCADO')),
    CONSTRAINT ck_exemplar_preco CHECK (preco_base > 0)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 6) TROCA (depende de CLIENTE e de EXEMPLAR, duas vezes)
-- ---------------------------------------------------------------------
CREATE TABLE troca (
    id_troca               INT           NOT NULL AUTO_INCREMENT,
    id_cliente             INT           NOT NULL,
    id_exemplar_entregue   INT           NOT NULL,
    id_exemplar_adquirido  INT           NOT NULL,
    desconto_percentual    DECIMAL(5,2)  NOT NULL,
    data_troca             DATE          NOT NULL,
    CONSTRAINT pk_troca PRIMARY KEY (id_troca),
    CONSTRAINT uq_troca_entregue  UNIQUE (id_exemplar_entregue),
    CONSTRAINT uq_troca_adquirido UNIQUE (id_exemplar_adquirido),
    CONSTRAINT fk_troca_cliente FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente)
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_troca_exemplar_entregue FOREIGN KEY (id_exemplar_entregue)
        REFERENCES exemplar (id_exemplar)
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_troca_exemplar_adquirido FOREIGN KEY (id_exemplar_adquirido)
        REFERENCES exemplar (id_exemplar)
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT ck_troca_exemplares_distintos
        CHECK (id_exemplar_entregue <> id_exemplar_adquirido),
    CONSTRAINT ck_troca_desconto
        CHECK (desconto_percentual BETWEEN 0 AND 100)
) ENGINE = InnoDB;