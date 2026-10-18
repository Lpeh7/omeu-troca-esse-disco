# CONSULTAS — Ô, Meu! Troca Esse Disco

> Este documento lista as **28 consultas (Q01–Q28)** do exercício de DQL.
> As questões estão agrupadas pela **issue** que as cobre, seguindo o Board de desenvolvimento:
>
> | Faixa | Issue | Conceito principal |
> |---|---|---|
> | Q01–Q10 | 07 — Consultas introdutórias | `SELECT`, `WHERE`, `ORDER BY`, `LIMIT`, `JOIN` |
> | Q11–Q18 | 08 — Agrupamento e relacionamento | `COUNT`, `SUM`, `AVG`, `GROUP BY`, `HAVING`, `UNION ALL` |
> | Q19–Q20 | 09 — Consultas financeiras | Desconto e valor final das trocas |
> | Q21–Q28 | 09 (bônus) — Auditorias | Consistência de dados e integridade |
>
> As respostas (SQL) ficam em `database/dql/consultas.sql` e as auditorias em `database/dql/validacoes.sql`.

---

## Issue 07 — Consultas introdutórias (Q01–Q10)

**Q01** — Listar o **nome** e o **gênero principal** de todos os cantores, em ordem alfabética pelo nome.
*Conceitos: `SELECT`, `ORDER BY`.*

**Q02** — Listar **nome**, **gravadora** e **data de lançamento** dos CDs lançados a partir de 2010, do mais recente para o mais antigo.
*Conceitos: `WHERE` (data), `ORDER BY ... DESC`.*

**Q03** — Mostrar apenas os **10 CDs mais recentes** (nome, gravadora e data de lançamento).
*Conceitos: `ORDER BY ... DESC`, `LIMIT`.*

**Q04** — Listar **nome** e **e-mail** dos clientes cujo nome começa com a letra "G", em ordem alfabética.
*Conceitos: `WHERE ... LIKE 'G%'`, `ORDER BY`.*

**Q05** — Listar o **título** e a **duração (em segundos)** das músicas com duração superior a 300 segundos, da mais longa para a mais curta.
*Conceitos: `WHERE` (numérico), `ORDER BY ... DESC`.*

**Q06** — Listar, para cada faixa, o **nome do CD**, o **número da faixa** e o **título da música**.
*Conceitos: `JOIN` entre `musica` e `cd`.*

**Q07** — Listar, para cada música, o **título** da faixa e o **nome do intérprete** (cantor).
*Conceitos: `JOIN` entre `musica` e `cantor`.*

**Q08** — Listar os **exemplares disponíveis** (`status = 'DISPONIVEL'`) com o **nome do CD**, a **conservação** e o **preço-base**, do mais caro para o mais barato.
*Conceitos: `JOIN` entre `exemplar` e `cd`, `WHERE`.*

**Q09** — Listar cada faixa com o **nome do CD**, o **número da faixa**, o **título** e o **intérprete** (junção das três tabelas do catálogo).
*Conceitos: `JOIN` encadeado entre `musica`, `cd` e `cantor`.*

**Q10** — Listar as **trocas** realizadas com o **nome do cliente** e a **data da troca**, em ordem cronológica.
*Conceitos: `JOIN` entre `troca` e `cliente`, `ORDER BY`.*

---

## Issue 08 — Consultas de agrupamento e relacionamento (Q11–Q18)

**Q11** — Contar **quantas músicas** tem cada CD, listando o nome do CD e a quantidade, do CD com mais faixas para o com menos.
*Conceitos: `COUNT`, `GROUP BY`, `ORDER BY`.*

**Q12** — Contar **quantos exemplares** estão com cada status (`DISPONIVEL` e `TROCADO`).
*Conceitos: `COUNT`, `GROUP BY`.*

**Q13** — Contar **quantas músicas** cada cantor tem no catálogo, listando o intérprete e a quantidade, do mais prolificista para o menos.
*Conceitos: `JOIN`, `COUNT`, `GROUP BY`, `ORDER BY`.*

**Q14** — Calcular a **duração média** das músicas por gênero, exibindo apenas os gêneros com média superior a 220 segundos.
*Conceitos: `AVG`, `GROUP BY`, `HAVING`.*

**Q15** — Contar **quantos CDs** cada gravadora publicou, exibindo somente as gravadoras com mais de 10 CDs.
*Conceitos: `COUNT`, `GROUP BY`, `HAVING`.*

**Q16** — Somar o **preço-base** dos exemplares **disponíveis** por conservação (`REGULAR`, `BOM`, `OTIMO`, `NOVO`).
*Conceitos: `SUM`, `GROUP BY`, `WHERE`.*

**Q17** — Contar **quantas trocas** cada cliente realizou, listando apenas os clientes que fizeram **duas ou mais** trocas.
*Conceitos: `JOIN`, `COUNT`, `GROUP BY`, `HAVING`.*

**Q18** — Usar `UNION ALL` para mostrar, em uma única resposta, **(a)** o total de **CDs distintos** que possuem ao menos um exemplar e **(b)** o **total de faixas** cadastradas — evidenciando a diferença entre contar CDs distintos e contar faixas.
*Conceitos: `COUNT(DISTINCT ...)`, `COUNT(*)`, `UNION ALL`.*

---

## Issue 09 — Consultas financeiras e validação

### Q19 e Q20 (obrigatórias)

**Q19** — Detalhar **cada troca**: identificar o **cliente**, o **CD adquirido** (nome do exemplar adquirido), a **conservação do CD entregue**, o **percentual de desconto** e o **valor final**, aplicando
`valor_final = ROUND(preco_base_adquirido * (1 - desconto_percentual / 100), 2)`.
*Conceitos: `JOIN`s entre `troca`, `cliente` e `exemplar` (entregue e adquirido), fórmula com `ROUND`.*
*Descontos: REGULAR 5%, BOM 10%, OTIMO 15%, NOVO 20%.*

**Q20** — Listar as trocas com **valor final superior a R$ 40,00**, exibindo cliente, CD adquirido e valor final, ordenadas **do maior valor para o menor**.
*Conceitos: cálculo de valor final + `WHERE` + `ORDER BY ... DESC`.*

### Bônus (Q21–Q28)

**Q21** — Auditoria de desconto: listar as trocas em que o **percentual aplicado não corresponde** à conservação do CD entregue (ex.: entregue `BOM`, mas desconto diferente de 10%).
*Conceitos: `JOIN`, `CASE`/comparação de domínio.*

**Q22** — Auditoria de status (RN09): listar exemplares com **status incoerente** — por exemplo, um exemplar marcado como `TROCADO` que nunca aparece em nenhuma troca, ou um `DISPONIVEL` que participou de uma troca.
*Conceitos: `JOIN`, `NOT EXISTS`/`LEFT JOIN ... IS NULL`.*

**Q23** — Auditoria de integridade: verificar se existem **referências inválidas** (trocas apontando para cliente ou exemplares inexistentes). *Esperado: nenhum resultado, pois as FKs impedem isso.*
*Conceitos: `LEFT JOIN ... IS NULL`.*

**Q24** — Calcular o **valor final médio** das trocas agrupado pela **conservação do CD entregue**.
*Conceitos: `AVG`, `GROUP BY`.*

**Q25** — Ranking dos **CDs com maior valor total em estoque disponível** (soma dos `preco_base` dos exemplares `DISPONIVEL`), dos 10 maiores para os menores.
*Conceitos: `SUM`, `GROUP BY`, `LIMIT`.*

**Q26** — Listar os clientes que **nunca realizaram nenhuma troca**.
*Conceitos: `LEFT JOIN ... IS NULL` / `NOT EXISTS`.*

**Q27** — Listar os CDs que **não possuem nenhum exemplar disponível** no estoque.
*Conceitos: `LEFT JOIN ... IS NULL` / `NOT EXISTS`.*

**Q28** — Calcular o **total de desconto concedido** pela loja (soma de `preco_base_adquirido − valor_final`) em todas as trocas.
*Conceitos: `SUM`, cálculo com `ROUND`.*

---

> **Observação sobre RN07 e RN09:** o `CHECK` do MySQL só valida valores da própria linha, por isso a coerência do desconto (RN07) e a coerência de status (RN09) são verificadas **por consulta de auditoria** (`database/dql/validacoes.sql`) e não bloqueadas na inserção.
