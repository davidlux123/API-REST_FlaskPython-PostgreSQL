from flask import Flask, jsonify, request
from flask_cors import CORS
import psycopg2
import os


app = Flask(__name__)


#IMPLEMENTAR CORS PARA NO TENER ERRORES AL TRATAR ACCEDER AL SERVIDOR DESDE OTRO SERVER EN DIFERENTE LOCACIÓN
CORS(app)

DB_HOST = "localhost"
DB_NAME = "postgres"
DB_USER = "postgres"
DB_PASS = "123"
try:
    con = psycopg2.connect(
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASS,
        host=DB_HOST)
    
    cur = con.cursor()
    
    print(con.status)
    

    @app.route("/")
    def hello():
        return "<h1 style='color:Black'>MIA PRACITCA 1, DEIVID LUX 201549059, Bienvenido al API Flask-Postgres por favor ingrese un endPoint valido...</h1>"

    #obtengo todos los registros de mi tabla movies que cree en mi BD
    @app.route('/cargarTemporal', methods=['GET'])
    def cargarTemporal():

        cur.execute("copy temporal from '/home/david/Escritorio/BlockBusterData1.csv'USING delimiters ';' csv header encoding 'windows-1251'; ")
        con.commit()
        return "<h1 style='Carga temporal completada...</h1>"
    
    @app.route("/getTemporal")
    def getTemporal():
        
        cur.execute('select * from temporal;')
        rows = cur.fetchall()
        return jsonify({'temporal': rows})
    
    @app.route("/cargarModelo")
    def cargarModelo():
        
        cur.execute(''' 
        insert into pais (nombrePais)
        select distinct paisCliente from temporal 
        where paisCliente <> '-'
        union distinct 
        select distinct paisEmpleado from temporal
        where paisEmpleado <> '-'
        union distinct
        select distinct paisTienda from temporal
        where paisTienda <> '-';
        ''')
        con.commit()

        cur.execute('''
        insert into ciudad (nombreCiudad)
        select distinct ciudadCliente from temporal 
        where ciudadCliente <> '-'
        union distinct 
        select distinct ciudadEmpleado from temporal
        where ciudadEmpleado <> '-'
        union distinct
        select distinct ciudadTienda from temporal
        where ciudadTienda <> '-';
        ''')
        con.commit()

        cur.execute('''
        insert into direccion (Direccion, fk_idCiudad, fk_idPais)
        select t.direccionCliente, c.idCiudad, p.idPais
        from temporal as t 
        inner join ciudad as c on t.ciudadCliente = c.nombreCiudad 
        inner join pais as p on t.paisCliente = p.nombrePais
        where  t.direccionCLiente <> '-'
        group by t.direccioncliente, p.idPais, c.idCiudad
        union distinct

        select t.direccionEmpleado, c.idCiudad, p.idPais
        from temporal as t 
        inner join ciudad as c on t.ciudadEmpleado = c.nombreCiudad 
        inner join pais as p on t.paisEmpleado = p.nombrePais
        where  t.direccionEmpleado <> '-'
        group by t.direccionEmpleado, p.idPais, c.idCiudad
        union distinct

        select t.direccionTienda, c.idCiudad, p.idPais
        from temporal as t 
        inner join ciudad as c on t.ciudadTienda = c.nombreCiudad 
        inner join pais as p on t.paisTienda = p.nombrePais
        where  t.direccionTienda <> '-'
        group by t.direccionTienda, p.idPais, c.idCiudad;
        ''')
        con.commit()

        cur.execute('''
        insert into tienda (fk_idDireccion, nombreTienda)
        select d.idDireccion, t.nombreTienda 
        from temporal as t
        inner join direccion as d on t.direccionTienda = d.Direccion   
        where t.nombreTienda <> '-'
        group by d.idDireccion, t.nombreTienda;
        ''')
        con.commit()

        cur.execute('''
        insert into cliente (fk_idDireccion, fk_idTiendaFav, nombreCliente, apellidoCliente, emailCliente, clienteActivo, fechaReg, codPostalCliente)
        select d.idDireccion, ti.idTienda, t.nombreCliente, t.apellidoCliente, t.emailCliente, t.clienteActivo, to_date(t.fechaReg, 'DD/MM/YYYY'), to_number(t.codPostalCliente, '99G999D9S') 
        from temporal as t
        inner join direccion as d on t.direccionCliente = d.Direccion
        inner join tienda as ti on t.tiendaFav = ti.nombreTienda
        where t.nombreCliente <>  '-'
        group by d.idDireccion, ti.idTienda, t.nombreCliente, t.apellidoCliente, t.emailCliente, t.clienteActivo, t.fechaReg, t.codPostalCliente;
        ''')
        con.commit()

        cur.execute('''
        insert into empleado (fk_idDireccion, fk_idTienda, nombreEmpleado, apellidoEmpleado, emailEmpleado, empleadoActivo, usarioEmpleado, contraEmpleado)
        select d.idDireccion, ti.idTienda, t.nombreEmpleado, t.apellidoEmpleado, t.emailEmpleado, t.empleadoActivo, t.usarioEmpleado, t.contraEmpleado
        from temporal as t
        inner join direccion as d on t.direccionEmpleado = d.Direccion
        inner join tienda as ti on t.tiendaEmpleado = ti.nombreTienda
        where t.nombreEmpleado <>  '-'
        group by d.idDireccion, ti.idTienda, t.nombreEmpleado, t.apellidoEmpleado, t.emailEmpleado, t.empleadoActivo, t.usarioEmpleado, t.contraEmpleado;
        ''')
        con.commit()

        cur.execute('''
        insert into clasificacion (nombreClasificacion)
        select clasificacion 
        from temporal
        where clasificacion <>  '-'
        group by clasificacion;
        ''')
        con.commit()

        cur.execute('''
        insert into pelicula (fk_idClasificacion, nombrePelicula, descPelicula, anioLanzamiento, diasRenta, costoRenta, duracion, costoXDanio)
        select c.idClasificacion, t.nombrePelicula, t.descPelicula, to_number(t.anioLanzamiento, '99G999D9S'), to_number(t.diasRenta, '99G999D9S'),  to_number(t.costoRenta, '99G999D9S'), to_number(t.duracion, '99G999D9S'), to_number(t.costoXDanio, '99G999D9S')
        from temporal as t
        inner join clasificacion as c on c.nombreClasificacion = t.clasificacion
        where t.nombrePelicula <> '-'
        group by c.idClasificacion, t.nombrePelicula, t.descPelicula, t.anioLanzamiento, t.diasRenta, t.costoRenta, t.duracion, t.costoXDanio;
        ''')
        con.commit()

        cur.execute('''
        insert into lenguaje (nombreLenguaje) 
        select distinct lenguaje 
        from temporal
        where lenguaje <> '-';
        ''')
        con.commit()

        cur.execute('''
        insert into doblaje (fk_idLenguaje, fk_idPeli)
        select l.idLenguaje, p.idPeli
        from temporal as t
        inner join lenguaje as l on l.nombreLenguaje = t.lenguaje
        inner join pelicula as p on p.nombrePelicula = t.nombrePelicula
        where t.nombrePelicula <> '-'
        group by l.idLenguaje, p.idPeli;
        ''')
        con.commit()

        cur.execute('''
        insert into Actor (nombreActor, apellidoActor) 
        select nombreActor, actorApellido 
        from temporal
        where nombreActor <> '-' and actorApellido <> '-'
        group by nombreActor, actorApellido;
        ''')
        con.commit()
        
        cur.execute('''
        insert into actuacion (fk_idActor, fk_idPeli)
        select a.idActor, p.idPeli
        from temporal as t
        inner join Actor as a on a.nombreActor = t.nombreActor and a.apellidoActor = t.actorApellido
        inner join pelicula as p on p.nombrePelicula = t.nombrePelicula
        where t.nombrePelicula <> '-'
        group by a.idActor, p.idPeli;
        ''')
        con.commit()

        cur.execute('''
        insert into categoria (nombreCategoria)
        select categoria
        from temporal
        where categoria <> '-'
        group by categoria;
        ''')
        con.commit()

        cur.execute('''
        insert into categoPeli (fk_idCategoria, fk_idPeli)
        select c.idCategoria, p.idPeli
        from temporal as t
        inner join categoria as c on c.nombreCategoria = t.categoria   
        inner join pelicula as p on p.nombrePelicula = t.nombrePelicula
        where t.nombrePelicula <> '-'
        group by c.idCategoria, p.idPeli;
        ''')
        con.commit()

        cur.execute('''
        insert into inventario (fk_idTienda, fk_idPeli) 
        select ti.idTienda, p.idPeli
        from temporal as t
        inner join tienda as ti on ti.nombreTienda = t.tiendaPelicula
        inner join pelicula as p on p.nombrePelicula = t.nombrePelicula
        where t.nombrePelicula <> '-'
        group by ti.idTienda, p.idPeli; 
        ''')
        con.commit()

        cur.execute('''
        insert into renta (fk_idPeli, fk_idCliente, fk_idEmpleado, fechaRenta, fechaRetorno, fechaPago, montoPago)
        select  p.idPeli, c.idCliente, e.idEmpleado, to_timestamp(t.fechaRenta, 'DD/MM/YYYY HH24:MI'), t.fechaRetorno, to_timestamp(t.fechaPago, 'DD/MM/YYYY HH24:MI'), to_number(t.montoPagar, '99G999D9S')
        from temporal as t 
        inner join pelicula as p on p.nombrePelicula = t.nombrePelicula
        inner join cliente as c on c.emailCliente = t.emailCliente
        inner join empleado as e on e.emailEmpleado = t.emailEmpleado
        where t.nombrePelicula <> '-'
        group by p.idPeli, c.idCliente, e.idEmpleado, t.fechaRenta, t.fechaRetorno, t.fechaPago, t.montoPagar;
        ''')
        con.commit()

        return "<h1 style='Carga modelo completada...</h1>" 
    
    @app.route("/consulta1")
    def consulta1():

        cur.execute(''' 
        select count (p.nombrePelicula)
        from inventario as i
        inner join pelicula as p on p.idPeli = i.fk_idPeli
        where p.nombrePelicula = 'SUGAR WONKA';
        ''')
        rows = cur.fetchall()
        return jsonify({'consulta1': rows})
    
    @app.route("/consulta2")
    def consulta2():

        cur.execute(''' 
        select c.nombreCliente, c.apellidoCliente, sum(r.montoPago)
        from renta as r
        inner join cliente as c on c.idCliente = r.fk_idCliente
        group by c.nombreCliente, c.apellidoCliente
        having count (c.nombreCliente) >= 40;
        ''')
        rows = cur.fetchall()
        lista = []
        for a in rows:
            listaux = []
            for w in a:
                listaux.append(str(w))
            lista.append(listaux)
        return jsonify({'consulta2': lista})

    @app.route("/consulta3")
    def consulta3():

        cur.execute(''' 
        select CONCAT_WS(' ', nombreActor, apellidoActor) as NombreCompleto from Actor
        where apellidoActor like '%son%'
        order by nombreActor asc;
        ''')
        rows = cur.fetchall()
        return jsonify({'consulta3': rows})

    @app.route("/consulta4")
    def consulta4():

        cur.execute(''' 
        select ac.nombreActor, ac.apellidoActor, p.anioLanzamiento
        from actuacion as a
        inner join Actor as ac on ac.idActor = a.fk_idActor
        inner join pelicula as p on p.idPeli = a.fk_idPeli
        where p.descPelicula like '%Shark%' and p.descPelicula like '%Crocodile%'
        order by ac.apellidoActor asc;
        ''')
        rows = cur.fetchall()
        return jsonify({'consulta4': rows})

    @app.route("/consulta5")
    def consulta5():

        cur.execute(''' 
        SELECT MAX(alias.nombreCliente), alias.nombrePais, MAX(RENTAS) as rentas, MAX(PORCENTAJE) as "%" 
        FROM ( 
            select c.nombreCliente, p.nombrePais, 
            count(r.fk_idCliente) as RENTAS, 
            (count(r.fk_idCliente)*100)/(select count(re.fk_idCliente)
                                        from renta as re
                                        inner join cliente as cl on cl.idCliente = re.fk_idCliente
                                        inner join direccion as di on di.idDireccion = cl.fk_idDireccion
                                        inner join ciudad as ciu on ciu.idCiudad = di.fk_idCiudad
                                        inner join pais as pa on pa.idPais = di.fk_idPais
                                        where pa.nombrePais = p.nombrePais
                                        group by pa.nombrePais) as PORCENTAJE
            from renta as r
            inner join cliente as c on c.idCLiente = r.fk_idCliente
            inner join direccion as d on d.idDireccion = c.fk_idDireccion
            inner join ciudad as ci on ci.idCiudad = d.fk_idCiudad
            inner join pais as p on p.idPais = d.fk_idPais
            group by c.nombreCliente, c.apellidoCliente, p.nombrePais
        ) as alias
        GROUP BY alias.nombrePais;
        ''')
        rows = cur.fetchall()
        return jsonify({'consulta5': rows})
    
    @app.route("/consulta6")
    def consulta6():

        cur.execute(''' 
        select p.nombrePais, ci.nombreCiudad,
        count(c.idCLiente),
        (count(c.idCLiente)*100)/ (select count(ciu.idCiudad)
                                from direccion as di 
                                inner join ciudad as ciu on ciu.idCiudad = di.fk_idCiudad
                                inner join pais as pa on pa.idPais = di.fk_idPais
                                where pa.nombrepais = p.nombrePais
                                group by pa.idPais) as "%"
        from cliente as c
        inner join direccion as d on d.idDireccion = c.fk_idDireccion
        inner join ciudad as ci on ci.idCiudad = d.fk_idCiudad
        inner join pais as p on p.idPais = d.fk_idPais
        group by ci.idCiudad, p.nombrePais;
        ''')
        rows = cur.fetchall()
        return jsonify({'consulta6': rows})

    @app.route("/consulta7")
    def consulta7():

        cur.execute(''' 
        select p.nombrePais, ci.nombreCiudad,
        count(r.noRenta),
        count(r.noRenta) / (select count (ciu.nombreCiudad)
                            from direccion as di 
                            inner join ciudad as ciu on ciu.idCiudad = di.fk_idCiudad
                            inner join pais as pa on pa.idPais = di.fk_idPais
                            where pa.nombrePais = p.nombrePais 
                            group by pa.idPais) as "promedio"
        from renta as r
        inner join cliente as c on c.idCliente = r.fk_idCliente
        inner join direccion as d on d.idDireccion = c.fk_idDireccion
        inner join ciudad as ci on ci.idCiudad = d.fk_idCiudad
        inner join pais as p on p.idPais = d.fk_idPais
        group by p.nombrePais, ci.nombreCiudad;
        ''')
        rows = cur.fetchall()
        return jsonify({'consulta7': rows})

    @app.route("/consulta8")
    def consulta8():

        cur.execute(''' 
        select p.nombrePais, 
        count(r.fk_idCliente) as RENTAS, 
        (count(r.fk_idCliente)*100)/(select count(re.fk_idCliente)
                                    from renta as re
                                    inner join cliente as cl on cl.idCliente = re.fk_idCliente
                                    inner join direccion as di on di.idDireccion = cl.fk_idDireccion
                                    inner join ciudad as ciu on ciu.idCiudad = di.fk_idCiudad
                                    inner join pais as pa on pa.idPais = di.fk_idPais
                                    where pa.nombrePais = p.nombrePais
                                    group by pa.nombrePais) as PORCENTAJE
        from renta as r
        inner join cliente as c on c.idCLiente = r.fk_idCliente
        inner join direccion as d on d.idDireccion = c.fk_idDireccion
        inner join ciudad as ci on ci.idCiudad = d.fk_idCiudad
        inner join pais as p on p.idPais = d.fk_idPais

        inner join pelicula as peli on peli.idPeli = r.fk_idPeli
        inner join categoPeli as catPel on catPel.fk_idPeli = peli.idPeli
        inner join categoria as cate on cate.idCategoria = catPel.fk_idCategoria
        where cate.nombreCategoria = 'Sports'
        group by p.nombrePais;
        ''')
        rows = cur.fetchall()
        return jsonify({'consulta8': rows})

    @app.route("/eliminarTemporal")
    def eliminarTemporal():
        
        cur.execute("truncate table temporal;")
        con.commit()
        return "<h1 style='color:Black'>se ah completado el eliminado de los datos de la tabla temporal</h1>"

    @app.route("/eliminarModelo")
    def eliminarModelo():
        cur.execute('''
        drop table renta;
        drop table inventario;
        drop table categoPeli;
        drop table categoria;
        drop table actuacion;
        drop table actor;
        drop table doblaje;
        drop table lenguaje;
        drop table pelicula;
        drop table clasificacion;
        drop table empleado;
        drop table cliente;
        drop table tienda;
        drop table direccion;
        drop table ciudad; 
        drop table pais;
        drop table temporal;
        ''')
        con.commit()
        return "<h1 style='color:Black'>se ah completado el eliminado de las tablas del modelo</h1>"


    if __name__ == "__main__":
     app.run( host='0.0.0.0')        

except:
    print('Error')