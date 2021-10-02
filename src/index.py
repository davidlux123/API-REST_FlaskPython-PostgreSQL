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
    def cargaTemporal():

        cur.execute("copy temporal from '/home/david/Escritorio/BlockBusterData1.csv'USING delimiters ';' csv header encoding 'windows-1251'; ")
        con.commit()
        return "<h1 style='Carga masiva completada...</h1>"
    
    @app.route("/getTemporal")
    def getTemporal():
        cur.execute('select * from temporal;')
        rows = cur.fetchall()
        return jsonify({'salida': rows})
    






    if __name__ == "__main__":
     app.run( host='0.0.0.0')        

except:
    print('Error')