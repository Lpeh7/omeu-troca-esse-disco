-- =====================================================================
-- Consultas DQL — Ô, Meu! Troca Esse Disco
-- SGBD: MySQL 8.0.16 ou superior
-- Execute antes: o DDL (database/ddl) e a carga DML (database/dml/01 a 06).
-- Cada consulta é numerada conforme docs/consultas.md.
-- =====================================================================
USE omeu_troca_esse_disco;

-- ---------------------------------------------------------------------
-- Q01 — Nome e gênero de todos os cantores, em ordem alfabética.
-- Conceitos: SELECT, ORDER BY
-- ---------------------------------------------------------------------
SELECT nome AS cantor,
       genero_principal AS genero
FROM cantor
ORDER BY nome;

-- ---------------------------------------------------------------------
-- Q02 — CDs lançados a partir de 2010, do mais recente para o mais antigo.
-- Conceitos: WHERE (data), ORDER BY ... DESC
-- ---------------------------------------------------------------------
SELECT nome AS cd,
       gravadora,
       data_lancamento
FROM cd
WHERE data_lancamento >= '2010-01-01'
ORDER BY data_lancamento DESC;

-- ---------------------------------------------------------------------
-- Q03 — Os 10 CDs mais recentes.
-- Conceitos: ORDER BY ... DESC, LIMIT
-- ---------------------------------------------------------------------
SELECT nome AS cd,
       gravadora,
       data_lancamento
FROM cd
ORDER BY data_lancamento DESC
LIMIT 10;

-- ---------------------------------------------------------------------
-- Q04 — Clientes cujo nome começa com "G", em ordem alfabética.
-- Conceitos: WHERE ... LIKE 'G%', ORDER BY
-- ---------------------------------------------------------------------
SELECT nome AS cliente,
       email
FROM cliente
WHERE nome LIKE 'G%'
ORDER BY nome;

-- ---------------------------------------------------------------------
-- Q05 — Músicas com duração acima de 300 segundos, da mais longa p/ a mais curta.
-- Conceitos: WHERE (numérico), ORDER BY ... DESC
-- ---------------------------------------------------------------------
SELECT titulo AS musica,
       tempo_segundos AS duracao_segundos
FROM musica
WHERE tempo_segundos > 300
ORDER BY tempo_segundos DESC;

