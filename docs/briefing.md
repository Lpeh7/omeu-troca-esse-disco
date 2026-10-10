# Briefing — Ô, Meu! Troca Esse Disco

## Cenário
A **Ô, Meu! Troca Esse Disco** é um sebo fictício de CDs usados, localizado na região da Praça da Sé, em São Paulo.
Slogan: *"Na Sé, até disco parado vira desconto."*

A loja recebe CDs usados, controla os exemplares físicos de cada álbum e permite que clientes entreguem um CD para comprar outro com desconto.

## Objetivo do projeto
Modelar e implementar um banco de dados relacional em MySQL para controlar:
- o **catálogo** de CDs, músicas e artistas;
- o **estoque físico** (exemplares);
- as **trocas** com desconto realizadas pelos clientes.

## Como funciona uma troca
1. O cliente leva à loja um CD usado (o **exemplar entregue**).
2. A loja avalia o estado de conservação desse CD: REGULAR, BOM, OTIMO ou NOVO.
3. O cliente escolhe outro CD do estoque (o **exemplar adquirido**).
4. O desconto depende da conservação do CD entregue e incide **somente sobre o preço-base do CD adquirido**.
5. O CD entregue passa a fazer parte do estoque da loja.

## CD x EXEMPLAR (diferença importante)
- **CD** representa o **título do álbum** (ex.: o álbum em si, com gravadora e data de lançamento).
- **EXEMPLAR** representa a **unidade física** desse álbum (com conservação, preço e status).

Um mesmo CD pode ter vários exemplares físicos e também pode existir sem nenhum exemplar em estoque.

## Escopo (o que será desenvolvido)
- Banco de dados MySQL com seis tabelas: `cantor`, `cd`, `musica`, `cliente`, `exemplar` e `troca`.
- Scripts SQL de criação (DDL), carga de dados (DML) e consultas (DQL).
- Documentação: MER, DER, dicionário de dados e evidências.

## Fora do escopo (o que NÃO será desenvolvido)
- Aplicação web ou qualquer interface gráfica.
- Sistema de caixa e pagamentos.
- Vinis, livros e outros itens: o catálogo é **exclusivamente de CDs**.
- Dados reais: todos os dados do projeto são fictícios.