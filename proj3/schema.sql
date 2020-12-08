drop table regiao cascade;
drop table concelho cascade;
drop table instituicao cascade;
drop table medico cascade;
drop table consulta cascade;
drop table prescricao cascade;
drop table analise cascade;
drop table venda_farmacia cascade;
drop table prescricao_venda cascade;

create table regiao(
    num_regiao serial not null unique,
    nome varchar(50) not null,
    num_habitante int not null,
    check ( nome in ('Norte', 'Centro', 'Lisboa', 'Alentejo', 'Algarve') ),
    primary key(num_regiao)
);

create table concelho(
    num_concelho serial not null unique ,
    num_regiao serial not null ,
    nome varchar(50) not null ,
    num_habitantes int not null ,
    check ( nome in ('Amarante', 'Arcos de Valdevez', 'Azurara', 'Barcelos', 'Braga', 'Cabeceiras de Basto', 'Caldas das Taipas and Caldelas',
                     'Caminha', 'Carrazedo', 'Chaves', 'Espinho', 'Esposende', 'Fao', 'Freixo de Espada a Cinta', 'Gondomar', 'Guimaraes', 'Lamego',
                     'Marco de Canaveses', 'Melgaco', 'Mesao Frio', 'Minho', 'Miranda do Douro', 'Mirandela', 'Moncao', 'Montalegre', 'Murca',
                     'Pacos de Ferreira', 'Penafiel', 'Peso da Regua', 'Ponte da Barca', 'Ponte de Lima', 'Porto', 'Povoa de Varzim', 'Ribeira de Pena',
                     'Santa Maria de Bouro', 'Santo Tirso', 'S. Joao de Tarouca', 'Sernancelhe', 'Tras-os-Montes', 'Valenca', 'Viana do Castelo', 'Vieira do Minho',
                     'Vila do Conde', 'Vila Flor', 'Vila Nova de Cerveira', 'Vila Nova de Gaia', 'Vila Nova de Foz Coa', 'Vila Real', 'Vilar de Frades', 'Vizela',
                     'Agueda', 'Aguiar da Beira', 'Anadia', 'Almeida', 'Arganil', 'Arouca', 'Aveiro', 'Belmonte', 'Bucaco', 'Caramulo', 'Castelo Branco',
                     'Celorico da Beira', 'Coimbra', 'Conimbriga', 'Covilha', 'Curia', 'Figueira da Foz', 'Figueira de Castelo Rodrigo', 'Fundao', 'Gouuveia',
                     'Guarda', 'Idanha-a-Nova', 'Idanha-a-Velha', 'Ilhavo', 'Linhares da Beira', 'Lorvao', 'Lourinha', 'Mangualde', 'Marialva', 'Mealhada', 'Minde',
                     'Mira', 'Monsanto', 'Monte Real', 'Montemor-o-Velho', 'Oliveira do Hospital', 'Penamacor', 'Piodao', 'Pombal', 'Porto de Mos', 'Proenca-a-Velha',
                     'S. Pedro do Sul', 'Seia', 'Serra da Estrela', 'Sortelha', 'Trancoso', 'Viseu', 'Vouzela', 'Abrantes', 'Almeirim', 'Azenhas do Mar', 'Batalha', 'Berlengas',
                     'Caldas da Rainha', 'Cartaxo', 'Cascais', 'Chamusca', 'Colares', 'Constancia', 'Ericeira', 'Estoril', 'Fatima', 'Leiria', 'Lisboa',
                     'Macao', 'Mafra', 'Minde', 'Obidos', 'Palmela', 'Peniche', 'Porto de Mos', 'Queluz', 'Salvaterra de Magos', 'Santarem', 'Sardoal', 'Seixal', 'Serra da Arrabida',
                     'Sesimbra', 'Setubal', 'Sintra', 'Tomar', 'Torres Novas', 'Torres Vedras', 'Vila Nova da Barquinha', 'Vila de Rei', 'Vimeiro', 'Alandroal', 'Arraiolos', 'Borba',
                     'Castelo de Vide', 'Elvas', 'Estremoz', 'Evora', 'Marvao', 'Monsaraz', 'Montemor-o-Novo', 'Mourao', 'Portalegre', 'Portel', 'Redondo', 'Reguengos de Monsaraz',
                     'Sousel', 'Vendas Novas', 'Viana do Alentejo', 'Vila Vicosa', 'Albufeira', 'Alcoutim', 'Aljezur', 'Almansil', 'Alte', 'Cacela', 'Carvoeiro', 'Castro Marim',
                     'Estombar', 'Faro', 'Lagoa', 'Lagos', 'Loule', 'Moncarapacho', 'Monchique', 'Monte Gordo', 'Olhao', 'Ponta da Piedade', 'Porches', 'Portimao', 'Sao Bras de Alportel',
                     'Sao Bartolomeu de Messines', 'Sagres', 'Silves', 'Vila do Bispo', 'Vilamoura', 'Vila Real de Santo Antonio', 'Tavira') ),
    foreign key(num_regiao) references regiao(num_regiao) on delete cascade,
    primary key (num_concelho, num_regiao)
);

create table instituicao(
    nome varchar(50) not null unique ,
    tipo varchar(50) not null,
    num_regiao serial not null,
    num_concelho serial not null ,
    check ( tipo in ('farmacia', 'laboratorio', 'clinica', 'hospital') ),
    foreign key (num_regiao, num_concelho) references concelho(num_regiao, num_concelho) on delete cascade,
    primary key (nome)
);

create table medico(
    num_cedula int not null unique,
    nome varchar(50) not null,
    especialidade varchar(50) not null,
    primary key (num_cedula)
);

create table consulta(
    num_cedula int not null ,
    num_doente int not null ,
    data date not null ,
    nome_instituicao varchar(50) not null ,
    unique(num_doente, data, nome_instituicao),
    check ( extract(isodow from data) not in (6,7) ),
    foreign key (num_cedula) references medico(num_cedula) on delete cascade ,
    foreign key (nome_instituicao) references instituicao(nome) on delete cascade ,
    primary key (num_cedula, num_doente, data)
);

create table prescricao(
    num_cedula int not null ,
    num_doente int not null ,
    data date not null ,
    substancia varchar(50) not null ,
    quant int not null ,
    foreign key (num_cedula, num_doente, data) references consulta(num_cedula, num_doente, data) on delete cascade ,
    primary key (num_cedula, num_doente, data, substancia)
);

create table analise(
    num_analise int not null unique ,
    especialidade varchar(50) not null ,
    num_cedula int ,
    num_doente int ,
    data date ,
    data_registo date not null ,
    nome varchar(50) not null,
    quant integer not null ,
    inst varchar(50) not null ,
    foreign key (inst) references instituicao(nome) on delete cascade ,
    foreign key (num_cedula, num_doente, data) references consulta(num_cedula, num_doente, data) on delete cascade ,
    primary key (num_analise)
);

create table venda_farmacia(
    num_venda serial not null unique ,
    data_registo date not null ,
    substancia varchar(50) not null ,
    quant int not null ,
    preco int not null ,
    inst varchar(50) not null ,
    foreign key (inst) references instituicao(nome) on delete cascade ,
    primary key (num_venda)
);

create table prescricao_venda(
    num_cedula serial not null ,
    num_doente int not null ,
    data date not null ,
    substancia varchar(50) not null ,
    num_venda serial not null unique ,
    foreign key (num_venda) references venda_farmacia(num_venda) on delete cascade ,
    foreign key (num_cedula, num_doente, data, substancia) references prescricao(num_cedula, num_doente, data, substancia) on delete cascade ,
    primary key (num_cedula, num_doente, data, substancia, num_venda)
)




