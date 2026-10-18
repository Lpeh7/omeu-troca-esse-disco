-- Conferência das contagens da carga. Resultado esperado:
-- cantor 64 | cd 520 | musica 3640 | cliente 48 | exemplar 680 | troca 40
USE omeu_troca_esse_disco;

SELECT 'cantor'   AS tabela, COUNT(*) AS linhas FROM cantor
UNION ALL SELECT 'cd',       COUNT(*) FROM cd
UNION ALL SELECT 'musica',   COUNT(*) FROM musica
UNION ALL SELECT 'cliente',  COUNT(*) FROM cliente
UNION ALL SELECT 'exemplar', COUNT(*) FROM exemplar
UNION ALL SELECT 'troca',    COUNT(*) FROM troca;