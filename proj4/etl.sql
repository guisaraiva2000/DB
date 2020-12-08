insert into d_tempo(dia, dia_da_semana, semana, mes, trimestre, ano)
    select extract(day from data_registo) as dia,
           extract(dow from data_registo) as dia_da_semana,
           extract(week from data_registo) as semana,
           extract(month from data_registo) as mes,
           (extract(month from data_registo) + 1) / 3 as trimestre,
           extract(year from data_registo) as ano
       from analise
    union
    select extract(day from data) as dia,
           extract(dow from data) as dia_da_semana,
           extract(week from data) as semana,
           extract(month from data) as mes,
           (extract(month from data) + 1) / 3 as trimestre,
           extract(year from data) as ano
       from prescricao_venda
    order by dia, dia_da_semana, semana, mes, trimestre, ano;


insert into d_instituicao(nome, tipo, num_regiao, num_concelho)
    select nome, tipo, num_regiao, num_concelho from instituicao;


insert into f_presc_venda(id_presc_venda, id_medico, num_doente, id_data_registo, id_inst, substancia, quant)
    select num_venda as id_presc_venda, pv.num_cedula as id_medico, pv.num_doente, id_tempo as id_data_registo,
           id_inst, pv.substancia, p.quant
    from prescricao_venda pv
        inner join medico m on pv.num_cedula = m.num_cedula
        inner join d_tempo dt on dt.dia = extract(day from pv.data)
                             and dt.mes = extract(month from pv.data)
                             and dt.ano = extract(year from pv.data)
        inner join prescricao p on pv.num_cedula = p.num_cedula
                                and pv.num_doente = p.num_doente
                                and pv.data = p.data
                                and pv.substancia = p.substancia
        inner join consulta c on p.num_cedula = c.num_cedula
                             and p.num_doente = c.num_doente
                             and p.data = c.data
        inner join instituicao i on c.nome_instituicao = i.nome
        inner join d_instituicao di on i.nome = di.nome
    group by num_venda, pv.num_cedula, pv.num_doente, id_tempo, id_inst, pv.substancia, p.quant;


insert into f_analise(id_analise, id_medico, num_doente, id_data_registo, id_inst, nome, quant)
    select num_analise as id_analise, a.num_cedula as id_medico, a.num_doente, id_tempo as id_data_registo, id_inst, a.nome, quant
    from analise a
        inner join consulta c on c.num_cedula = a.num_cedula and c.num_doente = a.num_doente and c.data = a.data
        inner join d_tempo dt on dt.dia = extract(day from a.data_registo)
                             and dt.mes = extract(month from a.data_registo)
                             and dt.ano = extract(year from a.data_registo)
        inner join instituicao i on i.nome = c.nome_instituicao
        inner join d_instituicao di on i.nome = di.nome
    group by a.num_analise, a.num_cedula, a.num_doente, id_tempo, id_inst, a.nome, quant;


