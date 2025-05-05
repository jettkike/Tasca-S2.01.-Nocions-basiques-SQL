# Tasca-S2.01.-Nocions-basiques-SQL

-- Nivel 1

-- Ejercicio 1
-- A partir dels documents adjunts (estructura_dades i dades_introduir), importa les dues taules.
-- Mostra les característiques principals de l'esquema creat i explica les diferents taules i variables que existeixen.
-- Assegura't d'incloure un diagrama que il·lustri la relació entre les diferents taules i variables. 

![](https://github.com/jettkike/Tasca-S2.01.-Nocions-basiques-SQL/blob/main/Captura%20de%20pantalla%202025-05-05%20180226.png)

Una vez importados los dos archivos en Workbench, se obtienen un schema llamado transactions, que a su vez contienen dos tablas:
- transaction: la cual muestra los registros de las transacciones de la empresa con otras compañias que compran sus productos, se puede observar columnas como el id de la transaccion, el id de la tarjeta de crédito, id de la compañia que compra, un identificador de esa compañia, las coordenadas como latitud y longitud, fecha de la transaccion, el monto de la transaccion y una columna si la venta finalmente se hizo o no se llegó a concretar.
- company: esta tabla muestra los datos de las compañias que compran, desde el nombre de la compañia, telefono, email, pais de origen, y pagina web.

La relacion es mediante los Primary Keys de cada tabla( en el grafico esta marcado como PK) y es una relacion de 1 a muchos ( desde company hacia transaction), es decir que una compañia puede tener muchas transacciones
