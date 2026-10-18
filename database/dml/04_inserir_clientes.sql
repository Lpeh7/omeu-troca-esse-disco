-- =====================================================================
-- Carga 04 — tabela cliente (48 linhas)
-- Projeto: Ô, Meu! Troca Esse Disco
-- DADOS 100% FICTÍCIOS, gerados para este projeto (qualquer semelhança com
-- pessoas, bandas, gravadoras ou e-mails reais é mera coincidência).
-- Ordem de carga: 01 cantores -> 02 cds -> 03 musicas -> 04 clientes
--                 -> 05 exemplares -> 06 trocas   (rodar UMA vez, após o DDL)
-- =====================================================================
USE omeu_troca_esse_disco;
SET NAMES utf8mb4;

INSERT INTO cliente (id_cliente, nome, email) VALUES
  (1, 'Victor Xavier', 'victor.xavier@mail-teste.example'),
  (2, 'Eduarda Siqueira', 'eduarda.siqueira@exemplo-sp.example'),
  (3, 'Daniel Siqueira', 'daniel.siqueira31@correio-ficticio.example'),
  (4, 'Eduarda Prado', 'eduarda.prado@mail-teste.example'),
  (5, 'Victor Ferraz', 'victor.ferraz@correio-ficticio.example'),
  (6, 'Thiago Dantas', 'thiago.dantas@exemplo-sp.example'),
  (7, 'Gabriela Uchoa', 'gabriela.uchoa@correio-ficticio.example'),
  (8, 'Gabriela Ribeiro', 'gabriela.ribeiro@correio-ficticio.example'),
  (9, 'Henrique Ferraz', 'henrique.ferraz@exemplo-sp.example'),
  (10, 'Bruno Holanda', 'bruno.holanda16@mail-teste.example'),
  (11, 'Camila Monteiro', 'camila.monteiro@correio-ficticio.example'),
  (12, 'Gabriela Nascimento', 'gabriela.nascimento@exemplo-sp.example'),
  (13, 'João Esteves', 'joao.esteves1@mail-teste.example'),
  (14, 'Sabrina Uchoa', 'sabrina.uchoa33@exemplo-sp.example'),
  (15, 'Rodrigo Cardoso', 'rodrigo.cardoso@mail-teste.example'),
  (16, 'Felipe Andrade', 'felipe.andrade@correio-ficticio.example'),
  (17, 'Daniel Lacerda', 'daniel.lacerda@exemplo-sp.example'),
  (18, 'Sabrina Lacerda', 'sabrina.lacerda60@mail-teste.example'),
  (19, 'Rodrigo Ornelas', 'rodrigo.ornelas34@correio-ficticio.example'),
  (20, 'Rodrigo Teixeira', 'rodrigo.teixeira@mail-teste.example'),
  (21, 'Karina Gouveia', 'karina.gouveia@exemplo-sp.example'),
  (22, 'Lucas Zanetti', 'lucas.zanetti90@correio-ficticio.example'),
  (23, 'Daniel Holanda', 'daniel.holanda63@correio-ficticio.example'),
  (24, 'Isabela Prado', 'isabela.prado@mail-teste.example'),
  (25, 'Daniel Uchoa', 'daniel.uchoa56@exemplo-sp.example'),
  (26, 'Quésia Dantas', 'quesia.dantas@mail-teste.example'),
  (27, 'Isabela Gouveia', 'isabela.gouveia@exemplo-sp.example'),
  (28, 'Olívia Andrade', 'olivia.andrade65@correio-ficticio.example'),
  (29, 'Isabela Ferraz', 'isabela.ferraz@mail-teste.example'),
  (30, 'Isabela Vasconcelos', 'isabela.vasconcelos@mail-teste.example'),
  (31, 'Karina Klein', 'karina.klein@correio-ficticio.example'),
  (32, 'Felipe Monteiro', 'felipe.monteiro@exemplo-sp.example'),
  (33, 'Gabriela Siqueira', 'gabriela.siqueira61@exemplo-sp.example'),
  (34, 'Karina Queiroz', 'karina.queiroz@exemplo-sp.example'),
  (35, 'Mariana Uchoa', 'mariana.uchoa71@mail-teste.example'),
  (36, 'Pedro Junqueira', 'pedro.junqueira@correio-ficticio.example'),
  (37, 'Karina Siqueira', 'karina.siqueira@correio-ficticio.example'),
  (38, 'Henrique Xavier', 'henrique.xavier94@mail-teste.example'),
  (39, 'Úrsula Holanda', 'ursula.holanda@exemplo-sp.example'),
  (40, 'Karina Vasconcelos', 'karina.vasconcelos27@mail-teste.example'),
  (41, 'João Queiroz', 'joao.queiroz@mail-teste.example'),
  (42, 'Gabriela Monteiro', 'gabriela.monteiro@exemplo-sp.example'),
  (43, 'Nicolas Esteves', 'nicolas.esteves@exemplo-sp.example'),
  (44, 'Mariana Siqueira', 'mariana.siqueira54@mail-teste.example'),
  (45, 'Camila Prado', 'camila.prado67@mail-teste.example'),
  (46, 'Nicolas Ribeiro', 'nicolas.ribeiro25@exemplo-sp.example'),
  (47, 'Yasmin Prado', 'yasmin.prado@exemplo-sp.example'),
  (48, 'Ana Andrade', 'ana.andrade@exemplo-sp.example');

