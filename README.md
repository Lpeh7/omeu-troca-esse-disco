# Ô, Meu! Troca Esse Disco — Do MER ao MySQL

> *"Na Sé, até disco parado vira desconto."*

Projeto prático individual de banco de dados (MySQL) da disciplina PI II.

## Sobre o projeto
Banco de dados relacional para o sebo fictício **Ô, Meu! Troca Esse Disco** (Praça da Sé, São Paulo). A loja recebe CDs usados, controla os exemplares físicos de cada álbum e permite que clientes entreguem um CD para levar outro com desconto por conservação. O banco cobre **catálogo**, **estoque físico (exemplares)** e **trocas**.

Detalhes do cenário em [`docs/briefing.md`](docs/briefing.md).

## Autoria
- **Aluno:** Luis Felipe Almeida Silva
- **Disciplina:** PI II
- **Página do projeto:** https://deluxe-blue-bc1.notion.site/Learning-project-Meu-Troca-Esse-Disco-Do-MER-ao-MySQL-3e5dfca74d8d81db9527d7aeffb09188
- **Créditos página do projeto:** Eduardo Inocencio

## Ferramentas e requisitos
- **SGBD:** MySQL **8.0.16 ou superior** (motor InnoDB, `utf8mb4`). O uso de `CHECK` exige 8.0.16+.
- **Clientes testados:** MySQL Workbench, phpMyAdmin (XAMPP) ou terminal `mysql`.
- **Requisitos e regras de negócio:** [`docs/regras-de-negocio.md`](docs/regras-de-negocio.md).
- Dados **100% fictícios**; nenhuma credencial ou banco local é versionado.

## Estrutura do repositório
- [`README.md`](README.md) — este guia.
- [`docs/`](docs) — documentação do modelo e evidências.
  - [`docs/briefing.md`](docs/briefing.md) — cenário e escopo.
  - [`docs/regras-de-negocio.md`](docs/regras-de-negocio.md) — requisitos (RF/RNF) e regras (RN).
  - [`docs/mer.md`](docs/mer.md) — modelo conceitual.
  - [`docs/der.md`](docs/der.md) — modelo lógico.
  - [`docs/dicionario-de-dados.md`](docs/dicionario-de-dados.md) — tabelas, colunas, tipos e restrições.
  - [`docs/consultas.md`](docs/consultas.md) — enunciado das 28 consultas (Q01–Q28).
  - [`docs/diagramas/`](docs/diagramas) — imagens MER e DER.
  - [`docs/evidencias/`](docs/evidencias) — prints e relatórios de execução.
- [`database/ddl/`](database/ddl) — criação da estrutura.
- [`database/dml/`](database/dml) — carga de dados e testes de manipulação.
- [`database/dql/`](database/dql) — consultas e auditorias.

## Diagramas, documentação e resultados
| Item | Link |
|---|---|
| MER (conceitual) | [`docs/mer.md`](docs/mer.md) |
| DER (lógico) | [`docs/der.md`](docs/der.md) |
| Dicionário de dados | [`docs/dicionario-de-dados.md`](docs/dicionario-de-dados.md) |
| Regras de negócio | [`docs/regras-de-negocio.md`](docs/regras-de-negocio.md) |
| Enunciado das consultas | [`docs/consultas.md`](docs/consultas.md) |
| Resultados Q01–Q10 | [`docs/evidencias/dql-iniciais/resultados.md`](docs/evidencias/dql-iniciais/resultados.md) |
| Resultados Q11–Q18 | [`docs/evidencias/dql-agrupamentos/resultados.md`](docs/evidencias/dql-agrupamentos/resultados.md) |
| Resultados financeiros e auditorias | [`docs/evidencias/trocas-e-descontos.md`](docs/evidencias/trocas-e-descontos.md) |
| Carga e testes de DML | [`docs/evidencias/carga-e-testes-dml.md`](docs/evidencias/carga-e-testes-dml.md) |
| Execução completa em banco limpo | [`docs/evidencias/banco-limpo.png`](docs/evidencias/banco-limpo.png) |

## Como executar (em banco limpo)
Siga a ordem **DDL → DML → DQL**. O script de DDL já executa `DROP DATABASE IF EXISTS`, recriando tudo do zero.

**1. Estrutura (DDL)**
1. `database/ddl/01_criar_estrutura.sql` — cria o banco `omeu_troca_esse_disco` e as 6 tabelas.
2. `database/ddl/02_testes_estrutura.sql` *(opcional)* — testa as restrições; os comandos **devem gerar erro**.

**2. Carga de dados (DML) — nesta ordem:**
1. `database/dml/01_inserir_cantores.sql`
2. `database/dml/02_inserir_cds.sql`
3. `database/dml/03_inserir_musicas.sql`
4. `database/dml/04_inserir_clientes.sql`
5. `database/dml/05_inserir_exemplares.sql`
6. `database/dml/06_inserir_trocas.sql`
7. `database/dml/07_testes_dml.sql` *(opcional)* — testes de INSERT/UPDATE/DELETE em transação com `ROLLBACK`.
8. `database/dml/08_conferir_contagens.sql` — confere as contagens: cantor 64, cd 520, musica 3.640, cliente 48, exemplar 680, troca 40.

**3. Consultas (DQL)**
1. `database/dql/consultas.sql` — responde às 28 consultas (Q01–Q28).
2. `database/dql/validacoes.sql` — auditorias de RN07 e RN09; devem retornar **0 linhas**.
3. `database/dql/teste_sanidade_auditoria.sql` *(opcional)* — prova que a auditoria detecta erros.

Evidência da execução do zero (banco recriado pelo DDL, carga aplicada e conferida): [`docs/evidencias/banco-limpo.png`](docs/evidencias/banco-limpo.png).

## Observações sobre o catálogo e as trocas
1. **CD x EXEMPLAR:** `cd` é o *título do álbum* (nome, gravadora, lançamento); `exemplar` é a *unidade física* (conservação, status, preço, data de entrada). Um CD pode ter vários exemplares ou nenhum.
2. **Chave de `musica`:** a PK é composta `(id_cd, numero_musica)`, porque a numeração das faixas reinicia em cada CD — a faixa 1 do CD 10 é diferente da faixa 1 do CD 11.
3. **Intérprete principal:** cada música tem exatamente um cantor (`id_cantor` obrigatório); um cantor pode ter zero ou muitas músicas.
4. **Dois exemplares por troca:** toda troca liga um exemplar **entregue** e um **adquirido**, distintos entre si. Cada coluna é `UNIQUE`, então o mesmo exemplar não repete o mesmo papel em outra troca.
5. **Desconto pelo entregue, sobre o adquirido:** o percentual depende da conservação do CD **entregue** (REGULAR 5%, BOM 10%, OTIMO 15%, NOVO 20%) e incide sobre o preço-base do **adquirido**; não é cumulativo e o entregue não gera crédito em dinheiro.
6. **`valor_final` é derivado:** não existe como coluna; é calculado nas consultas por `ROUND(preco_base_adquirido * (1 - desconto_percentual/100), 2)`.
7. **Status na carga (RN09):** o exemplar adquirido em uma troca fica `TROCADO`; o entregue volta ao estoque como `DISPONIVEL`.

## Status
Entrega final. Documentação, DDL, DML, DQL e evidências concluídos. Detalhes das decisões em [`docs/mer.md`](docs/mer.md), [`docs/der.md`](docs/der.md) e [`docs/regras-de-negocio.md`](docs/regras-de-negocio.md).