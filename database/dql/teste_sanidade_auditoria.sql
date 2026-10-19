-- Prova que a auditoria Q21 detecta erro: altera um desconto DENTRO de uma
-- transação, roda a auditoria e desfaz tudo com ROLLBACK.
USE omeu_troca_esse_disco;

START TRANSACTION;

UPDATE troca SET desconto_percentual = 50 WHERE id_troca = 1;

SELECT t.id_troca,
       ent.conservacao AS conservacao_entregue,
       t.desconto_percentual AS desconto_aplicado,
       CASE ent.conservacao
            WHEN 'REGULAR' THEN 5
            WHEN 'BOM'     THEN 10
            WHEN 'OTIMO'   THEN 15
            WHEN 'NOVO'    THEN 20
       END AS desconto_esperado
FROM troca t
JOIN exemplar ent ON ent.id_exemplar = t.id_exemplar_entregue
WHERE t.desconto_percentual <> CASE ent.conservacao
            WHEN 'REGULAR' THEN 5
            WHEN 'BOM'     THEN 10
            WHEN 'OTIMO'   THEN 15
            WHEN 'NOVO'    THEN 20
       END;

ROLLBACK;

-- Conferir que o desconto voltou ao valor original (10.00)
SELECT id_troca, desconto_percentual FROM troca WHERE id_troca = 1;