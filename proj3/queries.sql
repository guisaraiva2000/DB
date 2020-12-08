/* Query 1 */ -- testar com '2020-11-19'
select i.num_concelho
from instituicao i inner join venda_farmacia vf on i.nome = vf.inst
where vf.data_registo = current_date
group by i.num_concelho
having sum(vf.preco) >= all( select sum(vf1.preco)
                             from instituicao i1 inner join venda_farmacia vf1 on i1.nome = vf1.inst
                             where vf1.data_registo = current_date
                             group by i1.num_concelho );

/* Query 2 */
select t1.num_regiao, t1.num_cedula, t1.total_perscricoes
from (  select i.num_regiao, m.num_cedula, count(m.num_cedula) as total_perscricoes
        from medico m inner join prescricao p on m.num_cedula = p.num_cedula
                        inner join consulta c on p.num_cedula = c.num_cedula and
                                                 p.num_doente = c.num_doente and
                                                 p.data = c.data
                        inner join instituicao i on c.nome_instituicao = i.nome
        where extract(year from p.data) = 2019 and extract(month from p.data) <= 6
        group by i.num_regiao, m.num_cedula )
    as t1
inner join ( select t3.num_regiao, max(t3.total_perscricoes) as max_perscricoes
             from (  select i.num_regiao, m.num_cedula, count(m.num_cedula) as total_perscricoes
                     from medico m inner join prescricao p on m.num_cedula = p.num_cedula
                                   inner join consulta c on p.num_cedula = c.num_cedula and
                                                             p.num_doente = c.num_doente and
                                                             p.data = c.data
                                   inner join instituicao i on c.nome_instituicao = i.nome
                    where extract(year from p.data) = 2019 and extract(month from p.data) <= 6
                    group by i.num_regiao, m.num_cedula ) as t3
             group by t3.num_regiao)
    as t2 on t1.num_regiao = t2.num_regiao and t1.total_perscricoes = t2.max_perscricoes
group by t1.num_regiao, t1.num_cedula, t1.total_perscricoes ;


/* Query 3 */
select m.num_cedula
from medico m inner join prescricao_venda pv on m.num_cedula = pv.num_cedula
              inner join venda_farmacia vf on pv.num_venda = vf.num_venda
              inner join instituicao i on vf.inst = i.nome
where vf.substancia = 'aspirina'
  and extract(year from pv.data) = extract(year from current_date)
  and i.num_concelho = 56 and i.tipo = 'farmacia'
group by m.num_cedula
having count(distinct(vf.inst)) = ( select count(*)
                                    from instituicao
                                    where num_concelho = 56 and tipo = 'farmacia' );

/* Query 4 */
select distinct a.num_doente
from analise a
where extract(month from a.data) = extract(month from current_date)
  and a.num_doente not in( select num_doente
                           from prescricao_venda pv
                           where extract(month from pv.data) = extract(month from current_date)
                           group by num_doente );




select t2.num_concelho, max_glic, max_doente, min_glic, min_doente
from (select t1.num_concelho, a2.quant as max_glic, a2.num_doente as max_doente
      from (select i.num_concelho, max(a.quant) as max_glic
            from analise a inner join instituicao i
            on a.inst = i.nome inner join concelho c on i.num_concelho = c.num_concelho
            where a.nome = 'Analise Glicemica'
            group by i.num_concelho
          ) as t1
      inner join instituicao i2 on t1.num_concelho = i2.num_concelho inner join analise a2 on i2.nome = a2.inst
      where a2.quant = t1.max_glic and a2.nome = 'Analise Glicemica'
      group by t1.num_concelho, a2.quant, a2.num_doente
     ) as t2
inner join (  select t3.num_concelho, a2.quant as min_glic, a2.num_doente as min_doente
              from (select i.num_concelho, min(a.quant) as min_glic
                    from analise a inner join instituicao i
                    on a.inst = i.nome inner join concelho c on i.num_concelho = c.num_concelho
                    where a.nome = 'Analise Glicemica'
                    group by i.num_concelho
                  ) as t3
              inner join instituicao i2 on t3.num_concelho = i2.num_concelho inner join analise a2 on i2.nome = a2.inst
              where a2.quant = t3.min_glic and a2.nome = 'Analise Glicemica'
              group by t3.num_concelho, a2.quant, a2.num_doente
         ) as t4 on t2.num_concelho = t4.num_concelho
group by t2.num_concelho, t2.max_glic, t2.max_doente, t4.min_glic, t4.min_doente