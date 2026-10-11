-- Testes da estrutura: rode DEPOIS do DDL e ANTES da carga de dados.
-- Cada comando abaixo deve resultar em ERRO. Se algum passar sem erro, a restrição não está funcionando.
USE omeu_troca_esse_disco;

-- T1 FK: música de um CD que não existe (esperado: erro 1452)
INSERT INTO musica VALUES (999, 1, 'Teste', 200, 'MPB', 1);

-- T2 NOT NULL: cantor sem nome (esperado: erro 1048)
INSERT INTO cantor (nome, genero_principal) VALUES (NULL, 'MPB');

-- T3 CHECK: conservação fora da lista (esperado: erro 3819)
INSERT INTO exemplar (id_cd, conservacao, status, preco_base, data_entrada)
VALUES (1, 'RUIM', 'DISPONIVEL', 10.00, '2025-01-01');

-- T4 CHECK: preço zerado (esperado: erro 3819)
INSERT INTO exemplar (id_cd, conservacao, status, preco_base, data_entrada)
VALUES (1, 'BOM', 'DISPONIVEL', 0, '2025-01-01');

-- T5 CHECK: duração zerada (esperado: erro 3819)
INSERT INTO musica VALUES (1, 1, 'Teste', 0, 'MPB', 1);

-- T6 CHECK: mesmo exemplar nos dois papéis da troca (esperado: erro 3819)
INSERT INTO troca (id_cliente, id_exemplar_entregue, id_exemplar_adquirido, desconto_percentual, data_troca)
VALUES (1, 1, 1, 10.00, '2025-01-01');

-- T7 CHECK: desconto acima de 100 (esperado: erro 3819)
INSERT INTO troca (id_cliente, id_exemplar_entregue, id_exemplar_adquirido, desconto_percentual, data_troca)
VALUES (1, 1, 2, 150.00, '2025-01-01');