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


-- =====================================================================
-- Issue 08 — Agrupamentos e relacionamentos (Q11–Q18)
-- =====================================================================

-- ---------------------------------------------------------------------
-- Q11 — Quantas músicas tem cada CD, do CD com mais faixas para o com menos.
-- Conceitos: COUNT, GROUP BY, ORDER BY (LEFT JOIN mantém CDs sem músicas, com 0)
-- ---------------------------------------------------------------------
SELECT c.nome AS cd,
       COUNT(m.numero_musica) AS quantidade_musicas
FROM cd c
LEFT JOIN musica m ON m.id_cd = c.id_cd
GROUP BY c.id_cd, c.nome
ORDER BY quantidade_musicas DESC, c.nome;

-- ---------------------------------------------------------------------
-- Q12 — Quantos exemplares há em cada status.
-- Conceitos: COUNT, GROUP BY
-- ---------------------------------------------------------------------
SELECT status,
       COUNT(*) AS quantidade
FROM exemplar
GROUP BY status
ORDER BY quantidade DESC;

-- ---------------------------------------------------------------------
-- Q13 — Quantas músicas cada cantor tem no catálogo, do mais prolífico ao menos.
-- Conceitos: LEFT JOIN, COUNT, GROUP BY, ORDER BY (inclui cantores com 0 músicas)
-- ---------------------------------------------------------------------
SELECT a.nome AS interprete,
       COUNT(m.numero_musica) AS quantidade_musicas
FROM cantor a
LEFT JOIN musica m ON m.id_cantor = a.id_cantor
GROUP BY a.id_cantor, a.nome
ORDER BY quantidade_musicas DESC, a.nome;

-- ---------------------------------------------------------------------
-- Q14 — Duração média das músicas por gênero, só gêneros com média > 235 s.
-- Conceitos: AVG, GROUP BY, HAVING
-- ---------------------------------------------------------------------
SELECT genero,
       ROUND(AVG(tempo_segundos), 1) AS media_segundos
FROM musica
GROUP BY genero
HAVING AVG(tempo_segundos) > 235
ORDER BY media_segundos DESC;

-- ---------------------------------------------------------------------
-- Q15 — Quantos CDs cada gravadora publicou, só gravadoras com mais de 40 CDs.
-- Conceitos: COUNT, GROUP BY, HAVING
-- ---------------------------------------------------------------------
SELECT gravadora,
       COUNT(*) AS quantidade_cds
FROM cd
GROUP BY gravadora
HAVING COUNT(*) > 40
ORDER BY quantidade_cds DESC, gravadora;

-- ---------------------------------------------------------------------
-- Q16 — Soma do preço-base dos exemplares DISPONÍVEIS por conservação.
-- Conceitos: SUM, GROUP BY, WHERE
-- ---------------------------------------------------------------------
SELECT conservacao,
       COUNT(*) AS exemplares,
       SUM(preco_base) AS valor_total
FROM exemplar
WHERE status = 'DISPONIVEL'
GROUP BY conservacao
ORDER BY FIELD(conservacao, 'REGULAR', 'BOM', 'OTIMO', 'NOVO');

-- ---------------------------------------------------------------------
-- Q17 — Quantas trocas cada cliente fez, só clientes com 2 ou mais trocas.
-- Conceitos: JOIN, COUNT, GROUP BY, HAVING
-- ---------------------------------------------------------------------
SELECT cl.nome AS cliente,
       COUNT(*) AS quantidade_trocas
FROM troca t
JOIN cliente cl ON cl.id_cliente = t.id_cliente
GROUP BY cl.id_cliente, cl.nome
HAVING COUNT(*) >= 2
ORDER BY quantidade_trocas DESC, cl.nome;

-- ---------------------------------------------------------------------
-- Q18 — Em uma única resposta: (a) CDs DISTINTOS com pelo menos um exemplar
--       e (b) total de faixas cadastradas.
-- Conceitos: COUNT(DISTINCT ...), COUNT(*), UNION ALL
-- ---------------------------------------------------------------------
SELECT 'CDs distintos com ao menos um exemplar' AS indicador,
       COUNT(DISTINCT id_cd) AS total
FROM exemplar
UNION ALL
SELECT 'Total de faixas cadastradas',
       COUNT(*)
FROM musica;


-- =====================================================================
-- Issue 09 — Consultas financeiras (Q19–Q20)
-- =====================================================================

-- ---------------------------------------------------------------------
-- Q19 — Detalhe de cada troca: cliente, CD adquirido, conservação do entregue,
--       percentual de desconto e valor final.
-- Fórmula: valor_final = ROUND(preco_base_adquirido * (1 - desconto_percentual / 100), 2)
-- Conceitos: JOINs (a tabela exemplar é usada duas vezes), ROUND
-- ---------------------------------------------------------------------
SELECT t.id_troca,
       cl.nome AS cliente,
       cd_adq.nome AS cd_adquirido,
       ent.conservacao AS conservacao_entregue,
       t.desconto_percentual,
       adq.preco_base AS preco_base_adquirido,
       ROUND(adq.preco_base * (1 - t.desconto_percentual / 100), 2) AS valor_final
FROM troca t
JOIN cliente  cl     ON cl.id_cliente   = t.id_cliente
JOIN exemplar ent    ON ent.id_exemplar = t.id_exemplar_entregue
JOIN exemplar adq    ON adq.id_exemplar = t.id_exemplar_adquirido
JOIN cd       cd_adq ON cd_adq.id_cd    = adq.id_cd
ORDER BY t.id_troca;

-- ---------------------------------------------------------------------
-- Q20 — Trocas com valor final acima de R$ 40,00, do maior para o menor.
-- Conceitos: valor final calculado + WHERE + ORDER BY ... DESC
-- (o apelido valor_final não pode ser usado no WHERE, então a expressão é repetida)
-- ---------------------------------------------------------------------
SELECT t.id_troca,
       cl.nome AS cliente,
       cd_adq.nome AS cd_adquirido,
       ROUND(adq.preco_base * (1 - t.desconto_percentual / 100), 2) AS valor_final
FROM troca t
JOIN cliente  cl     ON cl.id_cliente   = t.id_cliente
JOIN exemplar adq    ON adq.id_exemplar = t.id_exemplar_adquirido
JOIN cd       cd_adq ON cd_adq.id_cd    = adq.id_cd
WHERE ROUND(adq.preco_base * (1 - t.desconto_percentual / 100), 2) > 40
ORDER BY valor_final DESC, t.id_troca;

-- =====================================================================
-- Issue 09 (bônus) — Q24 a Q28
-- (Q21 a Q23 são as auditorias e estão em database/dql/validacoes.sql)
-- =====================================================================

-- Q24 — Valor final médio das trocas por conservação do CD entregue.
SELECT ent.conservacao AS conservacao_entregue,
       COUNT(*) AS trocas,
       ROUND(AVG(ROUND(adq.preco_base * (1 - t.desconto_percentual / 100), 2)), 2) AS valor_final_medio
FROM troca t
JOIN exemplar ent ON ent.id_exemplar = t.id_exemplar_entregue
JOIN exemplar adq ON adq.id_exemplar = t.id_exemplar_adquirido
GROUP BY ent.conservacao
ORDER BY FIELD(ent.conservacao, 'REGULAR', 'BOM', 'OTIMO', 'NOVO');

-- Q25 — Os 10 CDs com maior valor total em estoque disponível.
SELECT c.nome AS cd,
       COUNT(*) AS exemplares_disponiveis,
       SUM(e.preco_base) AS valor_em_estoque
FROM exemplar e
JOIN cd c ON c.id_cd = e.id_cd
WHERE e.status = 'DISPONIVEL'
GROUP BY c.id_cd, c.nome
ORDER BY valor_em_estoque DESC, c.nome
LIMIT 10;

-- Q26 — Clientes que nunca realizaram troca.
SELECT cl.nome AS cliente, cl.email
FROM cliente cl
LEFT JOIN troca t ON t.id_cliente = cl.id_cliente
WHERE t.id_troca IS NULL
ORDER BY cl.nome;

-- Q27 — CDs sem nenhum exemplar disponível.
-- (a condição de status fica no ON, e não no WHERE, para não descartar os CDs sem exemplar)
SELECT c.nome AS cd
FROM cd c
LEFT JOIN exemplar e ON e.id_cd = c.id_cd AND e.status = 'DISPONIVEL'
WHERE e.id_exemplar IS NULL
ORDER BY c.nome;

-- Q28 — Total de desconto concedido pela loja em todas as trocas.
SELECT SUM(adq.preco_base - ROUND(adq.preco_base * (1 - t.desconto_percentual / 100), 2)) AS total_desconto
FROM troca t
JOIN exemplar adq ON adq.id_exemplar = t.id_exemplar_adquirido;