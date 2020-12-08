#!/usr/bin/python3

from wsgiref.handlers import CGIHandler

from flask import Flask
from flask import render_template, request

## Libs postgres
import psycopg2
import psycopg2.extras

import cgitb; cgitb.enable()

app=Flask(__name__)

## SGBD configs
DB_HOST="db.tecnico.ulisboa.pt"
DB_USER="ist193717"
DB_DATABASE=DB_USER
DB_PASSWORD="sfbg9789"
DB_CONNECTION_STRING="host=%s dbname=%s user=%s password=%s" % (DB_HOST, DB_DATABASE, DB_USER, DB_PASSWORD)


## Runs the function once the root page is requested.
## The request comes with the folder structure setting ~/web as the root
@app.route('/')
def list_all():
  dbConn=None
  cursor1=None
  cursor2=None
  cursor3=None
  cursor4=None

  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor1 = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    cursor2 = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    cursor3 = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    cursor4 = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

    cursor1.execute("select * from instituicao order by nome;")
    cursor2.execute("select * from medico order by num_cedula;")
    cursor3.execute("select * from prescricao order by num_cedula, num_doente, data, substancia;")
    cursor4.execute("select * from analise order by num_analise;")

    return render_template("index.html", cursor1=cursor1, cursor2=cursor2, cursor3=cursor3, cursor4=cursor4)
  except Exception as e:
    return str(e)  #Renders a page with the error.
  finally:
    cursor1.close()
    cursor2.close()
    cursor3.close()
    cursor4.close()

    dbConn.close()


#--------------------------------------------- Instituicao ------------------------------------------

@app.route('/insert_instituicao')
def insert_instituicao():
  template = "insert_instituicao.html"
  return execute_render_template(template, request.args)


@app.route('/alter_instituicao')
def alter_instituicao():
  template = "alter_instituicao.html"
  return execute_render_template(template, request.args)


@app.route('/remove_instituicao', methods=["POST"])
def remove_instituicao():
  remove_query = "delete from instituicao where nome = %s;"
  data = (request.form["nome"],)
  return execute_query(remove_query, data)


@app.route('/new_instituicao', methods=["POST"])
def new_instituicao():
  insert_query = "insert into instituicao values(%s, %s, %s, %s);"
  data = (request.form["nome"], request.form["tipo"], request.form["num_regiao"], request.form["num_concelho"])
  return execute_query(insert_query, data)


@app.route('/update_instituicao', methods=["POST"])
def update_instituicao():
  queries = []
  data = []

  if request.form["tipo"]:
    queries.append("update instituicao set tipo = %s where nome = %s;")
    data.append((request.form["tipo"], request.form["nome"]))
  if request.form["num_regiao"]:
    queries.append("update instituicao set num_regiao = %s where nome = %s;")
    data.append((request.form["num_regiao"], request.form["nome"]))
  if request.form["num_concelho"]:
    queries.append("update instituicao set num_concelho = %s where nome = %s;")
    data.append((request.form["num_concelho"], request.form["nome"]))

  return on_update(queries, data)


#--------------------------------------------- Medico ------------------------------------------

@app.route('/insert_medico')
def insert_medico():
  template = "insert_medico.html"
  return execute_render_template(template, request.args)


@app.route('/alter_medico')
def alter_medico():
  template = "alter_medico.html"
  return execute_render_template(template, request.args)


@app.route('/remove_medico', methods=["POST"])
def remove_medico():
  remove_query = "delete from medico where num_cedula = %s;"
  data = (request.form["num_cedula"],)
  return execute_query(remove_query, data)


@app.route('/new_medico', methods=["POST"])
def new_medico():
  insert_query = "insert into medico values(%s, %s, %s);"
  data = (request.form["num_cedula"], request.form["nome"], request.form["especialidade"])
  return execute_query(insert_query, data)


@app.route('/update_medico', methods=["POST"])
def update_medico():
  queries = []
  data = []

  if request.form["nome"]:
    queries.append("update medico set nome = %s where num_cedula = %s;")
    data.append((request.form["nome"], request.form["num_cedula"]))
  if request.form["especialidade"]:
    queries.append("update medico set especialidade = %s where num_cedula = %s;")
    data.append((request.form["especialidade"], request.form["num_cedula"]))

  return on_update(queries, data)


#--------------------------------------------- Prescricao ------------------------------------------

@app.route('/insert_prescricao')
def insert_prescricao():
  template = "insert_prescricao.html"
  return execute_render_template(template, request.args)


@app.route('/alter_prescricao')
def alter_prescricao():
  template = "alter_prescricao.html"
  return execute_render_template(template, request.args)


@app.route('/remove_prescricao', methods=["POST"])
def remove_prescricao():
  remove_query = "delete from prescricao where num_cedula = %s and num_doente = %s and data = %s and substancia = %s;"
  data = (request.form["num_cedula"], request.form["num_doente"], request.form["data"], request.form["substancia"])
  return execute_query(remove_query, data)


@app.route('/new_prescricao', methods=["POST"])
def new_prescricao():
  insert_query = "insert into prescricao values(%s, %s, %s, %s, %s);"
  data = (request.form["num_cedula"], request.form["num_doente"], request.form["data"], request.form["substancia"],
          request.form["quant"])
  return execute_query(insert_query, data)


@app.route('/update_prescricao', methods=["POST"])
def update_prescricao():
  query = "update prescricao set quant = %s where num_cedula = %s and num_doente = %s and data = %s and substancia = %s;"
  data = (request.form["quant"], request.form["num_cedula"], request.form["num_doente"], request.form["data"],
          request.form["substancia"])
  return execute_query(query, data)


#--------------------------------------------- Analise ------------------------------------------

@app.route('/insert_analise')
def insert_analise():
  template = "insert_analise.html"
  return execute_render_template(template, request.args)


@app.route('/alter_analise')
def alter_analise():
  template = "alter_analise.html"
  return execute_render_template(template, request.args)


@app.route('/remove_analise', methods=["POST"])
def remove_analise():
  remove_query = "delete from analise where num_analise = %s;"
  data = (request.form["num_analise"],)
  return execute_query(remove_query, data)


@app.route('/new_analise', methods=["POST"])
def new_analise():
  insert_query = "insert into analise values(%s, %s, %s, %s, %s, %s, %s, %s, %s); "
  data = (
    request.form["num_analise"], request.form["especialidade"], request.form["num_cedula"],
    request.form["num_doente"],
    request.form["data"], request.form["data_registo"], request.form["nome"], request.form["quant"],
    request.form["inst"]
  )
  return execute_query(insert_query, data)


@app.route('/update_analise', methods=["POST"])
def update_analise():
  queries = []
  data = []

  if request.form["especialidade"]:
    queries.append("update analise set especialidade = %s where num_analise = %s;")
    data.append((request.form["especialidade"], request.form["num_analise"]))
  if request.form["num_cedula"]:
    queries.append("update analise set num_cedula = %s where num_analise = %s;")
    data.append((request.form["num_cedula"], request.form["num_analise"]))
  if request.form["num_doente"]:
    queries.append("update analise set num_doente = %s where num_analise = %s;")
    data.append((request.form["num_doente"], request.form["num_analise"]))
  if request.form["data"]:
    queries.append("update analise set data = %s where num_analise = %s;")
    data.append((request.form["data"], request.form["num_analise"]))
  if request.form["data_registo"]:
    queries.append("update analise set data_registo = %s where num_analise = %s;")
    data.append((request.form["data_registo"], request.form["num_analise"]))
  if request.form["nome"]:
    queries.append("update analise set nome = %s where num_analise = %s;")
    data.append((request.form["nome"], request.form["num_analise"]))
  if request.form["quant"]:
    queries.append("update analise set quant = %s where num_analise = %s;")
    data.append((request.form["quant"], request.form["num_analise"]))
  if request.form["inst"]:
    queries.append("update analise set inst = %s where num_analise = %s;")
    data.append((request.form["inst"], request.form["num_analise"]))

  return on_update(queries, data)


#---------------------------------------- Vendas Farmacia ---------------------------------------

@app.route('/insert_venda')
def insert_venda():
  template = "insert_venda.html"
  return execute_render_template(template, request.args)


@app.route('/new_venda', methods=["POST"])
def new_venda():
  to_return = []

  query_venda = "insert into venda_farmacia values(%s, current_date, %s, %s, %s, %s);"
  data_venda = (
    request.form["num_venda"], request.form["substancia"], request.form["quant"],
    request.form["preco"], request.form["inst"]
  )

  try:
    eq = execute_query(query_venda, data_venda)
    to_return.append(eq)
  except Exception as e:
    return str(e)

  query_presc = "insert into prescricao_venda values(%s, %s, %s, %s, %s);"
  data_presc = (
    request.form["num_cedula"], request.form["num_doente"], request.form["data"], request.form["substancia"],
    request.form["num_venda"]
  )

  try:
    eq = execute_query(query_presc, data_presc)
    to_return.append(eq)
  except Exception as e:
    print(e)

  return str(to_return)


#--------------------------------------- Listar Substancias -------------------------------------
@app.route('/list_subst')
def list_subst():
  template = "list_subst.html"
  return execute_render_template(template, request.args)


@app.route('/print_subst', methods=["POST"])
def print_subst():
  dbConn = None
  cursor = None

  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

    query = "select distinct p.substancia " \
            "from prescricao p inner join medico m on p.num_cedula = m.num_cedula " \
            "where extract(month from p.data) = %s " \
            "and m.num_cedula = %s " \
            "and extract(year from p.data) = extract(year from current_date)"

    data = (request.form["mes"], request.form["num_cedula"])

    cursor.execute(query, data)

    return render_template("print_subst.html", cursor=cursor, mes=data[0], num_cedula=data[1])
  except Exception as e:
    return str(e)  #Renders a page with the error.
  finally:
    cursor.close()
    dbConn.close()


#--------------------------------------- Listar Concelhos -------------------------------------

@app.route('/print_glic')
def print_glic():
  dbConn=None
  cursor=None

  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

    query = "select t2.num_concelho, max_glic, max_doente, min_glic, min_doente " \
            "from (select t1.num_concelho, a2.quant as max_glic, a2.num_doente as max_doente " \
            "from (select i.num_concelho, max(a.quant) as max_glic " \
            "from analise a inner join instituicao i " \
            "on a.inst = i.nome inner join concelho c on i.num_concelho = c.num_concelho " \
            "where a.nome = 'Analise Glicemica' " \
            "group by i.num_concelho " \
            ") as t1 " \
            "inner join instituicao i2 on t1.num_concelho = i2.num_concelho inner join analise a2 on i2.nome = a2.inst " \
            "where a2.quant = t1.max_glic and a2.nome = 'Analise Glicemica' " \
            "group by t1.num_concelho, a2.quant, a2.num_doente " \
            ") as t2 " \
            "inner join (  select t3.num_concelho, a2.quant as min_glic, a2.num_doente as min_doente " \
            "from (select i.num_concelho, min(a.quant) as min_glic " \
            "from analise a inner join instituicao i " \
            "on a.inst = i.nome inner join concelho c on i.num_concelho = c.num_concelho " \
            "where a.nome = 'Analise Glicemica' " \
            "group by i.num_concelho " \
            ") as t3 " \
            "inner join instituicao i2 on t3.num_concelho = i2.num_concelho inner join analise a2 on i2.nome = a2.inst " \
            "where a2.quant = t3.min_glic and a2.nome = 'Analise Glicemica' " \
            "group by t3.num_concelho, a2.quant, a2.num_doente " \
            ") as t4 on t2.num_concelho = t4.num_concelho " \
            "group by t2.num_concelho, t2.max_glic, t2.max_doente, t4.min_glic, t4.min_doente"

    cursor.execute(query)

    return render_template("print_glic.html", cursor=cursor)
  except Exception as e:
    return str(e)  #Renders a page with the error.
  finally:
    cursor.close()
    dbConn.close()


#-------------------------------------------- Aux -----------------------------------------------

def on_update(queries, data):
  to_return = []

  for i in range(len(queries)):
    try:
      eq = execute_query(queries[i], data[i])
      to_return.append(eq)
    except Exception as e:
      return str(e)

  return str(to_return)


def execute_query(query, data):
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    cursor.execute(query, data)
    return query % data
  except Exception as e:
    return str(e)  #Renders a page with the error.
  finally:
    dbConn.commit()
    cursor.close()
    dbConn.close()


def execute_render_template(template, args):
  try:
    return render_template(template, params=args)
  except Exception as e:
    return str(e)  #Renders a page with the error.


CGIHandler().run(app)

