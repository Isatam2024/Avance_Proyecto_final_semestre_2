import mysql.connector #Nos conectamos a una base de datos mysql
from tabulate import tabulate #Permite formatear y mostrar resultado en tablas

class DatabaseConnector:   #Esta clase permite conectar a una base y manipular sus datos
    def __init__(self, host, user, password, database):  #este es un metodo constructor que define parametros iniciales
        self.host = host
        self.user = user
        self.password = password
        self.database = database
        self.connection = None
        self.cursor = None

    def connect(self):  #Este metodo establece la conexion con una base de datos mysql
        try:
            self.connection = mysql.connector.connect(
                host=self.host,
                user=self.user,
                password=self.password,
                database=self.database
            )
            self.cursor = self.connection.cursor()
            print("Conexión establecida a la base de datos")
        except mysql.connector.Error as e:
            print(f"Error al conectar a la base de datos: {e}")

    def disconnect(self):  #este metodo permite cerrar la conexión con la base de datos
        if self.connection:
            self.connection.close()
            print("Conexión cerrada")

    def execute_stored_procedure(self, procedure_name): # Este metodo permite Ejecutar un procedimiento almacenado que no requiere parámetros.
        try:
            self.cursor.callproc(procedure_name)  #llama proceso almacenado
            for result in self.cursor.stored_results():
                rows = result.fetchall()
                if rows:
                    headers = [i[0] for i in result.description]
                    print(tabulate(rows, headers=headers, tablefmt="pretty"))
                else:
                    print("No se encontraron resultados")
        except mysql.connector.Error as e:
            print(f"Error al ejecutar procedimiento almacenado: {e}")

    def execute_insert_procedure(self, procedure_name, *args): #Este metodo permite Insertar datos utilizando un procedimiento almacenado que requiere parámetros.
        try:
            self.cursor.callproc(procedure_name, args)
            self.connection.commit()
            print("Datos insertados correctamente")
        except mysql.connector.Error as e:
            self.connection.rollback()
            print(f"Error al insertar datos: {e}")

    def execute_delete_procedure(self, procedure_name, *args):
        try:
            self.cursor.callproc(procedure_name, args)
            self.connection.commit()
            print("Fuente de emision borrado correctamente")
        except mysql.connector.Error as e:
            self.connection.rollback()
            print(f"Error al borrar fuente de emision: {e}")



user = 'root'
password = ''
host = 'localhost'
database = "Huella_de_carbono_Universitaria"

db_connector = DatabaseConnector(host, user, password, database)
db_connector.connect()


#Permite Borrar datos(DELETE)
print("Borrando Fuente de emisión con ID = 1:")
db_connector.execute_delete_procedure('BorrarFuenteEmision', 1)

print("\nMostrando detalles de todos las fuentes de emision despues del borrado:")
db_connector.execute_stored_procedure('Detalles_Fuente_Emisiones')

db_connector.disconnect()

