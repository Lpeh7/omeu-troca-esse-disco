# Dicionário de Dados

- **Banco:** `omeu_troca_esse_disco`
- **SGBD:** MySQL 8.0.16 ou superior (motor InnoDB)
- **Codificação:** utf8mb4
- Todos os dados de exemplo são **fictícios**.

## Tabela `cantor`
Artistas (intérpretes) das músicas. Um cantor pode interpretar zero ou muitas músicas.

| Coluna | Significado | Tipo | Aceita NULL | Chave / restrição | Domínio | Exemplo |
|---|---|---|---|---|---|---|
| id_cantor | Identificador do artista | INT AUTO_INCREMENT | Não | PK | Inteiro positivo | 1 |
| nome | Nome do artista | VARCHAR(100) | Não | — | Texto | Marina Solaris |
| biografia | Texto biográfico | TEXT | Sim | — | Texto livre | Cantora paulistana que começou em casas de show do centro. |
| genero_principal | Gênero musical principal | VARCHAR(50) | Não | — | Texto | MPB |

## Tabela `cd`
Título de álbum (não a unidade física). Um CD pode ter vários exemplares ou nenhum.

| Coluna | Significado | Tipo | Aceita NULL | Chave / restrição | Domínio | Exemplo |
|---|---|---|---|---|---|---|
| id_cd | Identificador do álbum | INT AUTO_INCREMENT | Não | PK | Inteiro positivo | 10 |
| nome | Título do álbum | VARCHAR(150) | Não | — | Texto | Noites da Sé |
| gravadora | Gravadora responsável | VARCHAR(100) | Não | — | Texto | Discos Paulista |
| data_lancamento | Data de lançamento | DATE | Não | — | Data válida | 2004-05-17 |

## Tabela `musica`
Faixas de um CD. A numeração das faixas reinicia em cada CD, por isso a chave primária é composta.

| Coluna | Significado | Tipo | Aceita NULL | Chave / restrição | Domínio | Exemplo |
|---|---|---|---|---|---|---|
| id_cd | CD ao qual a faixa pertence | INT | Não | PK (composta) e FK → cd.id_cd | Id existente em `cd` | 10 |
| numero_musica | Posição da faixa no CD | TINYINT UNSIGNED | Não | PK (composta); CHECK ≥ 1 | Inteiro de 1 a 255 | 3 |
| titulo | Título da faixa | VARCHAR(150) | Não | — | Texto | Praça ao Entardecer |
| tempo_segundos | Duração da faixa, em segundos | SMALLINT UNSIGNED | Não | CHECK > 0 | Inteiro positivo | 215 |
| genero | Gênero da faixa | VARCHAR(50) | Não | — | Texto | MPB |
| id_cantor | Intérprete principal | INT | Não | FK → cantor.id_cantor | Id existente em `cantor` | 1 |

## Tabela `cliente`
Pessoas que realizam trocas.

| Coluna | Significado | Tipo | Aceita NULL | Chave / restrição | Domínio | Exemplo |
|---|---|---|---|---|---|---|
| id_cliente | Identificador do cliente | INT AUTO_INCREMENT | Não | PK | Inteiro positivo | 7 |
| nome | Nome do cliente | VARCHAR(100) | Não | — | Texto | Carlos Almeida |
| email | E-mail do cliente | VARCHAR(150) | Não | UNIQUE | E-mail, sem repetição | carlos.almeida@exemplo.com |

## Tabela `exemplar`
Unidade física de um CD.

| Coluna | Significado | Tipo | Aceita NULL | Chave / restrição | Domínio | Exemplo |
|---|---|---|---|---|---|---|
| id_exemplar | Identificador da unidade física | INT AUTO_INCREMENT | Não | PK | Inteiro positivo | 101 |
| id_cd | Álbum a que o exemplar pertence | INT | Não | FK → cd.id_cd | Id existente em `cd` | 10 |
| conservacao | Estado de conservação | VARCHAR(10) | Não | CHECK (lista) | REGULAR, BOM, OTIMO, NOVO | BOM |
| status | Situação do exemplar no estoque | VARCHAR(15) | Não | CHECK (lista) | DISPONIVEL, TROCADO | DISPONIVEL |
| preco_base | Preço-base do exemplar (R$) | DECIMAL(10,2) | Não | CHECK > 0 | Valor positivo, 2 casas | 35.90 |
| data_entrada | Data em que entrou na loja | DATE | Não | — | Data válida | 2025-03-12 |

## Tabela `troca`
Troca concluída: um cliente entrega um exemplar e leva outro.

| Coluna | Significado | Tipo | Aceita NULL | Chave / restrição | Domínio | Exemplo |
|---|---|---|---|---|---|---|
| id_troca | Identificador da troca | INT AUTO_INCREMENT | Não | PK | Inteiro positivo | 1 |
| id_cliente | Cliente que fez a troca | INT | Não | FK → cliente.id_cliente | Id existente em `cliente` | 7 |
| id_exemplar_entregue | Exemplar que o cliente entregou | INT | Não | FK → exemplar.id_exemplar; UNIQUE | Id existente em `exemplar` | 101 |
| id_exemplar_adquirido | Exemplar que o cliente levou | INT | Não | FK → exemplar.id_exemplar; UNIQUE | Id existente em `exemplar` | 205 |
| desconto_percentual | Percentual de desconto aplicado | DECIMAL(5,2) | Não | CHECK entre 0 e 100 | 0,00 a 100,00 | 10.00 |
| data_troca | Data da troca | DATE | Não | — | Data válida | 2025-04-02 |

O valor final da troca não é coluna: é calculado nas consultas (RN08).

## Justificativas de tipos e restrições

### Identificadores
Usei `INT` com `AUTO_INCREMENT` nas chaves primárias simples. A coluna `musica.id_cd` não é auto incrementada porque herda o valor do `cd` a que a faixa pertence. Os tipos das colunas FK são idênticos aos das PKs que elas referenciam, o que o MySQL exige.

### Texto
`VARCHAR` com tamanho estimado para nomes, títulos, gravadora e e-mail. A biografia usa `TEXT`, porque não há limite razoável de tamanho. Todo o banco usa utf8mb4 para aceitar acentos (RNF03).

### Valores financeiros e percentuais
`preco_base` e `desconto_percentual` usam `DECIMAL`, que guarda valores exatos. Tipos de ponto flutuante (`FLOAT`, `DOUBLE`) são aproximados e podem gerar erros de centavos nos cálculos de desconto (RN08). `DECIMAL(10,2)` comporta preços de até 99.999.999,99, e `DECIMAL(5,2)` comporta percentuais com duas casas.

### Datas
`DATE`, porque o negócio só precisa do dia (lançamento, entrada do exemplar e troca), sem hora.

### Duração das músicas
Inteiro em segundos (`SMALLINT UNSIGNED`, até 65.535 s). Facilita somas e médias, e a conversão para minutos:segundos é feita apenas na exibição, nas consultas.

### Valores permitidos (conservação, status e desconto)
- `conservacao` e `status` usam `VARCHAR` com `CHECK ... IN (...)`, que o MySQL só aplica a partir da 8.0.16 (RNF01). Os valores não levam acento (`OTIMO`) para coincidir com as regras RN04 e RN07.
- `desconto_percentual` só é limitado ao intervalo de 0 a 100. A coerência entre o desconto e a conservação do exemplar entregue (RN07) será verificada por consultas de auditoria (Issue 09), e não por restrição no banco.

### Nulabilidade
Todas as colunas são `NOT NULL`, porque o negócio exige essas informações. A exceção é `cantor.biografia`, que pode não existir para um artista.

### Regras da troca (RN06)
- As duas colunas de exemplar em `troca` são `UNIQUE`, para que o mesmo exemplar não ocupe duas vezes o mesmo papel.
- Os dois exemplares da mesma troca devem ser diferentes. Isso será garantido por um `CHECK (id_exemplar_entregue <> id_exemplar_adquirido)` no DDL.

### Integridade referencial
As chaves estrangeiras usam o comportamento padrão (`RESTRICT`): não é possível apagar um registro "pai" que tenha registros "filhos" ligados a ele.