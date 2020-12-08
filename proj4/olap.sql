-- query 1
select especialidade, ano, mes, count(*) as ttl_anls_glic
from f_analise fa inner join d_tempo dt on dt.id_tempo = fa.id_data_registo
                   inner join medico m on fa.id_medico = m.num_cedula
where fa.nome = 'Analise Glicemica' and ano between 2017 and 2020
group by cube (especialidade, ano, mes) order by (especialidade, ano, mes);

-- query 2
select distinct t_total.num_concelho, t_total.mes, t_total.dia_da_semana, t_total.substancia, quant_total,
                cast(total_presc_day as float) / cast(4 as float) as media_dia_da_semana
from (
        select dt.mes, dt.dia_da_semana, fpv.substancia, count(*) as total_presc_day
        from f_presc_venda fpv inner join d_instituicao di on di.id_inst = fpv.id_inst
            inner join d_tempo dt on dt.id_tempo = fpv.id_data_registo
        where di.num_regiao = 3 and dt.trimestre = 1 and dt.ano = 2020
        group by rollup (dt.mes, dt.dia_da_semana), fpv.substancia order by (mes, dia_da_semana)
    ) as t_media
    inner join (
        select di.num_concelho, dt.mes, dt.dia_da_semana, fpv.substancia, sum(fpv.quant) as quant_total
        from f_presc_venda fpv inner join d_instituicao di on di.id_inst = fpv.id_inst
            inner join d_tempo dt on dt.id_tempo = fpv.id_data_registo
        where di.num_regiao = 3 and dt.trimestre = 1 and dt.ano = 2020
        group by rollup (di.num_concelho, dt.mes, dt.dia_da_semana), fpv.substancia order by (mes, dia_da_semana)
    ) as t_total on t_media.mes = t_total.mes and t_total.dia_da_semana = t_media.dia_da_semana and t_total.substancia = t_media.substancia
group by rollup (t_total.num_concelho, t_total.mes, t_total.dia_da_semana), t_total.substancia, quant_total, total_presc_day;
