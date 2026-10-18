-- =====================================================================
-- Testes de DML (INSERT, UPDATE, DELETE) sobre registros TEMPORÁRIOS
-- Tudo roda dentro de uma transação e termina em ROLLBACK, então a massa
-- original NÃO é alterada. Rode DEPOIS da carga (01 a 06).
-- =====================================================================
USE omeu_troca_esse_disco;

START TRANSACTION;

-- ---------------------------------------------------------------------
-- INSERT 1/3: um cantor temporário
-- ---------------------------------------------------------------------
INSERT INTO cantor (nome, biografia, genero_principal)
VALUES ('Artista Temporario Teste', 'Registro criado apenas para teste de DML.', 'Pop');

-- ---------------------------------------------------------------------
-- INSERT 2/3: um CD temporário
-- ---------------------------------------------------------------------
INSERT INTO cd (nome, gravadora, data_lancamento)
VALUES ('CD Temporario Teste', 'Selo Teste', '2026-01-15');

-- ---------------------------------------------------------------------
-- INSERT 3/3: uma música ligando o CD e o cantor temporários
-- (os ids são buscados pelo nome, porque o AUTO_INCREMENT os gerou)
-- ---------------------------------------------------------------------
INSERT INTO musica (id_cd, numero_musica, titulo, tempo_segundos, genero, id_cantor)
VALUES (
    (SELECT id_cd FROM cd WHERE nome = 'CD Temporario Teste'),
    1,
    'Faixa Temporaria Teste',
    200,
    'Pop',
    (SELECT id_cantor FROM cantor WHERE nome = 'Artista Temporario Teste')
);

-- Conferir o que foi inserido
SELECT m.id_cd, m.numero_musica, m.titulo, m.tempo_segundos, c.nome AS cd, a.nome AS cantor
FROM musica m
JOIN cd c     ON c.id_cd = m.id_cd
JOIN cantor a ON a.id_cantor = m.id_cantor
WHERE c.nome = 'CD Temporario Teste';

-- ---------------------------------------------------------------------
-- UPDATE: corrige a duração da faixa temporária (de 200 para 245 segundos)
-- O WHERE é obrigatório na prática: sem ele, TODAS as músicas seriam alteradas.
-- ---------------------------------------------------------------------
UPDATE musica
SET tempo_segundos = 245
WHERE id_cd = (SELECT id_cd FROM cd WHERE nome = 'CD Temporario Teste')
  AND numero_musica = 1;

-- Conferir o resultado do UPDATE (deve mostrar 245)
SELECT numero_musica, titulo, tempo_segundos
FROM musica
WHERE titulo = 'Faixa Temporaria Teste';

-- ---------------------------------------------------------------------
-- ERRO ESPERADO (evidência de integridade referencial, RESTRICT):
-- tentar apagar o CD enquanto ele ainda tem música é recusado (erro 1451).
-- Para gerar a evidência, remova os dois traços da linha abaixo, rode SÓ
-- essa linha, tire o print e coloque os traços de volta.
-- ---------------------------------------------------------------------
-- DELETE FROM cd WHERE nome = 'CD Temporario Teste';

-- ---------------------------------------------------------------------
-- DELETE (forma correta): apagar primeiro o "filho" (a música)
-- ---------------------------------------------------------------------
DELETE FROM musica
WHERE titulo = 'Faixa Temporaria Teste'
  AND id_cd = (SELECT id_cd FROM cd WHERE nome = 'CD Temporario Teste');

-- Conferir: a música temporária não existe mais (deve retornar 0)
SELECT COUNT(*) AS musicas_temporarias_restantes
FROM musica
WHERE titulo = 'Faixa Temporaria Teste';

-- ---------------------------------------------------------------------
-- ROLLBACK: desfaz TUDO o que foi feito desde o START TRANSACTION
-- ---------------------------------------------------------------------
ROLLBACK;

-- Conferir: os registros temporários também sumiram (os dois devem ser 0)
SELECT (SELECT COUNT(*) FROM cantor WHERE nome = 'Artista Temporario Teste') AS cantores_temporarios,
       (SELECT COUNT(*) FROM cd WHERE nome = 'CD Temporario Teste')          AS cds_temporarios;