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

-- ---------------------------------------------------------------------
-- Q06 — Para cada faixa: nome do CD, número da faixa e título da música.
-- Conceitos: JOIN (musica <-> cd)
-- ---------------------------------------------------------------------
SELECT c.nome AS cd,
       m.numero_musica AS faixa,
       m.titulo AS musica
FROM musica m
JOIN cd c ON c.id_cd = m.id_cd
ORDER BY c.nome, m.numero_musica;

-- ---------------------------------------------------------------------
-- Q07 — Para cada música: título e nome do intérprete (cantor).
-- Conceitos: JOIN (musica <-> cantor)
-- ---------------------------------------------------------------------
SELECT a.nome AS interprete,
       m.titulo AS musica
FROM musica m
JOIN cantor a ON a.id_cantor = m.id_cantor
ORDER BY a.nome, m.titulo;

-- ---------------------------------------------------------------------
-- Q08 — Exemplares DISPONÍVEIS com nome do CD, conservação e preço-base,
--       do mais caro para o mais barato.
-- Conceitos: JOIN (exemplar <-> cd), WHERE
-- ---------------------------------------------------------------------
SELECT c.nome AS cd,
       e.conservacao,
       e.preco_base,
       e.data_entrada
FROM exemplar e
JOIN cd c ON c.id_cd = e.id_cd
WHERE e.status = 'DISPONIVEL'
ORDER BY e.preco_base DESC;

-- ---------------------------------------------------------------------
-- Q09 — Cada faixa com nome do CD, número da faixa, título e intérprete.
-- Conceitos: JOIN encadeado (musica <-> cd <-> cantor)
-- ---------------------------------------------------------------------
SELECT c.nome AS cd,
       m.numero_musica AS faixa,
       m.titulo AS musica,
       a.nome AS interprete
FROM musica m
JOIN cd c    ON c.id_cd     = m.id_cd
JOIN cantor a ON a.id_cantor = m.id_cantor
ORDER BY c.nome, m.numero_musica;

-- ---------------------------------------------------------------------
-- Q10 — Trocas realizadas com nome do cliente e data, em ordem cronológica.
-- Conceitos: JOIN (troca <-> cliente), ORDER BY
-- ---------------------------------------------------------------------
SELECT t.id_troca,
       cl.nome AS cliente,
       t.data_troca,
       t.desconto_percentual
FROM troca t
JOIN cliente cl ON cl.id_cliente = t.id_cliente
ORDER BY t.data_troca;
