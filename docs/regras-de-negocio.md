# Requisitos e Regras de Negócio

## Requisitos funcionais (o que o sistema faz)
- **RF01** — Cadastrar e consultar artistas com código, nome, biografia e gênero principal.
- **RF02** — Cadastrar e consultar CDs com título, gravadora e data de lançamento.
- **RF03** — Registrar faixas numeradas por CD, com título, duração, gênero e intérprete principal.
- **RF04** — Cadastrar clientes com nome e e-mail único.
- **RF05** — Controlar unidades físicas dos CDs, com conservação, status, preço-base e data de entrada.
- **RF06** — Registrar trocas associando cliente, CD entregue e CD adquirido por seus exemplares físicos.
- **RF07** — Calcular o percentual de desconto aplicável e o valor final de cada troca.
- **RF08** — Consultar catálogo, estoque, intérpretes, trocas e valores utilizando SQL.
- **RF09** — Permitir carga inicial dos dados didáticos fornecidos por scripts SQL.

## Requisitos não funcionais (como o sistema deve ser feito)
- **RNF01** — Utilizar MySQL 8.0.16 ou superior (Workbench, phpMyAdmin/XAMPP ou terminal).
- **RNF02** — Utilizar chaves primárias e estrangeiras, integridade referencial, campos obrigatórios, tipos apropriados e restrições relevantes.
- **RNF03** — Usar DECIMAL para valores financeiros, DATE para datas e utf8mb4 para suportar acentos.
- **RNF04** — Separar scripts DDL, DML e DQL, com ordem de execução documentada e resultado reproduzível em banco vazio.
- **RNF05** — Versionar a solução no GitHub, com README, diagramas, dicionário, evidências e commits incrementais.
- **RNF06** — Usar somente dados fictícios; não publicar credenciais nem bancos locais no repositório.

## Regras de negócio
- **RN01** — CD representa um título de álbum. Um título pode ter vários exemplares físicos e pode existir sem estoque disponível.
- **RN02** — Cada música pertence a um CD e é identificada pelo par `(id_cd, numero_musica)`. A numeração das faixas reinicia em cada CD.
- **RN03** — Uma música tem exatamente um intérprete principal. Cada artista pode interpretar zero ou muitas músicas.
- **RN04** — Um exemplar físico pertence a um CD. Sua conservação é REGULAR, BOM, OTIMO ou NOVO. Seu status é DISPONIVEL ou TROCADO.
- **RN05** — O e-mail do cliente é único. Um cliente pode realizar nenhuma ou várias trocas.
- **RN06** — Cada troca envolve um cliente, um exemplar entregue e um exemplar adquirido. Os exemplares devem ser distintos, e o mesmo exemplar não pode ocupar duas vezes o mesmo papel em trocas diferentes.
- **RN07** — O desconto depende da conservação do CD entregue e **não é cumulativo**.
- **RN08** — `valor_final = ROUND(preco_base_do_adquirido * (1 - desconto_percentual / 100), 2)`. O CD entregue não gera crédito em dinheiro adicional.
- **RN09** — Na carga inicial, os itens adquiridos em troca têm status TROCADO, e os recebidos pela loja integram o estoque com status DISPONIVEL.
- **RN10** — A atividade cobre apenas trocas concluídas, sem caixa, pagamentos ou interface web.

## Tabela de descontos
| Conservação do CD entregue | Desconto |
|---|---|
| REGULAR | 5% |
| BOM | 10% |
| OTIMO | 15% |
| NOVO | 20% |

O desconto incide **sobre o preço-base do exemplar adquirido**, e não sobre o entregue.

## Exemplo de cálculo
O cliente entrega um CD em conservação **OTIMO** (15%) e leva um exemplar cujo preço-base é **R$ 50,00**:

`valor_final = ROUND(50,00 * (1 - 15 / 100), 2) = R$ 42,50`