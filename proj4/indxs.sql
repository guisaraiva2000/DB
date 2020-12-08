-- 1)
/*Esta query pode ser otimizada criando um indice hash
 sobre o num_cedula da consulta. Deste modo, a comparacao
 direta "num_doente = <um_valor>" torna-se mais eficiente.
 A utilizacao de indices hash é preferida pois apenas se
 trata de uma simples igualdade. */

create index num_cedula_index on consulta using hash(num_cedula);


-- 2)
/*Para este caso, em semelhança à alínea acima, é necessário criar um
  índice para organizar a coluna "especialidade" com uma Hash Table
  pois torna-se mais eficiente a comparação "especialidade = “Ei”".
 */

create index especialidade_index on medico using hash(especialidade);


-- 3)
/* Nesta alínea, uma vez que apenas temos duas linhas por bloco e os médicos estão uniformemente distribuidos por especialidade,
   isto é, o numero de medicos de cada especialidade é o mesmo, implica que se iriam fazer muitos acessos aos blocos do disco.
   Para evitar esta situação, ordenam-se os medicos por especialidade usando uma btree de modo a que medicos com a mesma especialidade fiquem juntos
   e reduzir assim assim os acessos aos blocos do disco. Para alem disto, a btree é mais eficiente para tabelas de grande dimensão e portanto,
   é a melhor escolha para este caso.
 */

create index especialidade_index2 on medico using btree(especialidade);


-- 4)
/* Neste caso, para tornar a comparacao "consulta.num_celula = medico.num_celula" mais eficiente,
   criam-se duas Hash Tables, uma na tabela Consulta e outra na tabela Medico. Para a condicao
   consulta.data BETWEEN ‘data_1’ AND ‘data_2’ deve-se organizar a coluna da data
   na tabela consulta e, por isso, utiliza-se uma btree pelo que é a mais eficiente
   para procura de ranges, neste caso, o BETWEEN.
 */

create index num_cedula_indexc on consulta using hash(num_cedula);
create index num_cedula_indexm on medico using hash(num_cedula);
create index num_ced_data_index on consulta using btree(data);
