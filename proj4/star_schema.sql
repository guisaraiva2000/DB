drop table if exists d_tempo cascade ;
drop table if exists d_instituicao cascade ;
drop table if exists f_presc_venda cascade ;
drop table if exists f_analise cascade ;


create table d_tempo (
    id_tempo serial not null,
    dia int not null,
    dia_da_semana int not null,
    semana int not null,
    mes int not null,
    trimestre int not null,
    ano int not null,
    primary key (id_tempo)
);

create table d_instituicao (
    id_inst serial not null,
    nome varchar(50) not null,
    tipo varchar(50) not null,
    num_regiao int not null,
    num_concelho int not null,
    foreign key (nome) references instituicao(nome) on delete cascade on update cascade,
    foreign key (num_regiao) references regiao(num_regiao) on delete cascade on update cascade,
    foreign key (num_concelho) references concelho(num_concelho) on delete cascade on update cascade,
    primary key (id_inst)
);

create table f_presc_venda (
    id_presc_venda serial not null,
    id_medico int not null,
    num_doente int not null,
    id_data_registo int not null,
    id_inst int not null,
    substancia varchar(50) not null ,
    quant int not null,
    foreign key (id_presc_venda) references prescricao_venda(num_venda) on delete cascade on update cascade,
    foreign key (id_medico) references medico(num_cedula) on delete cascade on update cascade ,
    foreign key (id_data_registo) references d_tempo(id_tempo) on delete cascade on update cascade ,
    foreign key (id_inst) references d_instituicao(id_inst) on delete cascade on update cascade ,
    primary key (id_presc_venda, id_data_registo, id_inst)
);

create table f_analise (
    id_analise serial not null,
    id_medico int not null ,
    num_doente int not null ,
    id_data_registo int not null,
    id_inst int not null,
    nome varchar(50) not null ,
    quant int not null ,
    foreign key (id_analise) references analise(num_analise) on delete cascade on update cascade ,
    foreign key (id_medico) references medico(num_cedula) on delete cascade on update cascade ,
    foreign key (id_data_registo) references d_tempo(id_tempo) on delete cascade on update cascade ,
    foreign key (id_inst) references d_instituicao(id_inst) on delete cascade on update cascade ,
    primary key (id_analise, id_data_registo, id_inst)
);
