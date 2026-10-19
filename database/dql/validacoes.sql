-- =====================================================================
-- Auditorias de integridade e de regras de negócio — Ô, Meu! Troca Esse Disco
-- Rode depois da carga. Todas as consultas abaixo devem retornar ZERO linhas.
-- Nenhuma consulta deste arquivo altera a base.
-- =====================================================================
USE omeu_troca_esse_disco;

-- ---------------------------------------------------------------------
-- Q21 — Desconto aplicado diferente do esperado para a conservação do entregue (RN07).
-- ---------------------------------------------------------------------
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

-- ---------------------------------------------------------------------
-- Q22 — Status incoerente (RN09).
-- Regra: um exemplar é TROCADO se, e somente se, foi ADQUIRIDO em alguma troca.
-- (Exemplares apenas ENTREGUES continuam DISPONIVEL: entram no estoque da loja.)
-- ---------------------------------------------------------------------
SELECT e.id_exemplar,
       e.status,
       'TROCADO sem ter sido adquirido em nenhuma troca' AS problema
FROM exemplar e
WHERE e.status = 'TROCADO'
  AND NOT EXISTS (SELECT 1 FROM troca t WHERE t.id_exemplar_adquirido = e.id_exemplar)
UNION ALL
SELECT e.id_exemplar,
       e.status,
       'DISPONIVEL mas ja foi adquirido em uma troca'
FROM exemplar e
WHERE e.status = 'DISPONIVEL'
  AND EXISTS (SELECT 1 FROM troca t WHERE t.id_exemplar_adquirido = e.id_exemplar);

-- ---------------------------------------------------------------------
-- Q23 — Referências inválidas (as FKs impedem isso; a auditoria confirma).
-- ---------------------------------------------------------------------
SELECT 'troca -> cliente inexistente' AS problema, t.id_troca AS registro
FROM troca t
LEFT JOIN cliente cl ON cl.id_cliente = t.id_cliente
WHERE cl.id_cliente IS NULL
UNION ALL
SELECT 'troca -> exemplar entregue inexistente', t.id_troca
FROM troca t
LEFT JOIN exemplar e ON e.id_exemplar = t.id_exemplar_entregue
WHERE e.id_exemplar IS NULL
UNION ALL
SELECT 'troca -> exemplar adquirido inexistente', t.id_troca
FROM troca t
LEFT JOIN exemplar e ON e.id_exemplar = t.id_exemplar_adquirido
WHERE e.id_exemplar IS NULL
UNION ALL
SELECT 'exemplar -> cd inexistente', e.id_exemplar
FROM exemplar e
LEFT JOIN cd c ON c.id_cd = e.id_cd
WHERE c.id_cd IS NULL
UNION ALL
SELECT 'musica -> cd inexistente', m.id_cd
FROM musica m
LEFT JOIN cd c ON c.id_cd = m.id_cd
WHERE c.id_cd IS NULL
UNION ALL
SELECT 'musica -> cantor inexistente', m.id_cd
FROM musica m
LEFT JOIN cantor a ON a.id_cantor = m.id_cantor
WHERE a.id_cantor IS NULL;

-- ---------------------------------------------------------------------
-- Extra (RN06) — Exemplares repetidos nas trocas.
-- ---------------------------------------------------------------------
SELECT 'mesmo exemplar nos dois papeis da troca' AS problema, id_troca AS registro
FROM troca
WHERE id_exemplar_entregue = id_exemplar_adquirido
UNION ALL
SELECT 'exemplar entregue em mais de uma troca', MIN(id_troca)
FROM troca
GROUP BY id_exemplar_entregue
HAVING COUNT(*) > 1
UNION ALL
SELECT 'exemplar adquirido em mais de uma troca', MIN(id_troca)
FROM troca
GROUP BY id_exemplar_adquirido
HAVING COUNT(*) > 1;