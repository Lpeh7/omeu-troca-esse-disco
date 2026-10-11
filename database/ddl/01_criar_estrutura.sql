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