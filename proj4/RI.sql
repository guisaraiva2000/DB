create or replace function trigger_verifica_especialidade() returns trigger as $$
    begin

        if new.num_cedula is not null and new.num_doente is not null and new.data is not null then
            if ( select medico.especialidade
                 from medico
                 where medico.num_cedula = new.num_cedula ) = new.especialidade then
                return new;
            else
                raise exception 'A especialidade da analise nao corresponde a especialidade do medico.';
            end if;
        end if;

        return new;

    end;
$$ language plpgsql;

create trigger ana_esp_trg before update on analise for each row execute procedure trigger_verifica_especialidade();

create trigger ana_esp_trg_i before insert on analise for each row execute procedure trigger_verifica_especialidade();


create or replace function trigger_verifica_consultas_med() returns trigger as $$
    declare counter integer;
    begin

        select count(*) into counter
        from consulta c
        where c.num_cedula = new.num_cedula and c.nome_instituicao = new.nome_instituicao
          and extract(year from c.data) =  extract(year from new.data)
          and extract(week from c.data) = extract(week from new.data);

        if counter >= 100 then
            raise exception 'Um medico nao pode dar mais de 100 consultas por semana na mesma instituicao.';
        end if;

        return new;

    end;
$$ language plpgsql;

create trigger con_med_trg before update on consulta for each row execute procedure trigger_verifica_consultas_med();

create trigger con_med_trg_i before insert on consulta for each row execute procedure trigger_verifica_consultas_med();


