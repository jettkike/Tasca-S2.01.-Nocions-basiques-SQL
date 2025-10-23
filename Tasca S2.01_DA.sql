
-- Exercici 2
-- Utilitzant JOIN realitzaràs les següents consultes:
-- 1) Llistat dels països que estan fent compres.
SELECT DISTINCT country
FROM transaction
JOIN company on company_id = company.id -- llamar a tablas solo las que pueden ser columnas ambiguas como company.id
WHERE declined = 0
ORDER BY country ASC;

-- 2) Des de quants països es realitzen les compres.
SELECT COUNT( DISTINCT country) as num_country
FROM company
JOIN transaction on company_id = company.id
WHERE declined = 0;

--  3) Identifica la companyia amb la mitjana més gran de vendes.
SELECT company_name, ROUND(AVG(amount),2) as media
FROM company
JOIN transaction on company_id = company.id
WHERE declined = 0
GROUP BY company_name
ORDER BY media DESC
limit 1;

-- Exercici 3: PRIMERO CON ANY, PERO DESPUES CON EXIST QUE ES MAS OPTIMIZADA Y RECOMENDADA
-- Utilitzant només subconsultes (sense utilitzar JOIN):

-- 1) Mostra totes les transaccions realitzades per empreses d'Alemanya.
SELECT *
FROM transaction
where company_id = any (SELECT id
						FROM company
						WHERE country = 'Germany');

-- FORMA MAS OPTIMA CON EXIST Exercici 3
SELECT *
FROM transaction
WHERE EXISTS (
    SELECT 1
    FROM company
    WHERE id = company_id
      AND country = 'Germany'
);

-- 2) Llista les empreses que han realitzat transaccions
-- per un amount superior a la mitjana de totes les transaccions.
SELECT company_name
FROM company
WHERE id = ANY (SELECT company_id -- usamos any por que es mas eficiente que like y este se usa en cadenas   
						from transaction
						WHERE amount >(SELECT AVG(amount) FROM transaction));

-- forma mas optima con exist
SELECT company_name
FROM company
WHERE EXISTS(SELECT 1
			FROM transaction
            WHERE company_id = company.id and amount >(SELECT AVG(amount) FROM transaction));


-- 3) Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.
-- No es correcto que la respuesta sea cero o null porque es una transaccion.
-- El ítem 3 del ejercicio 3 del nivel 1 no está bien, sigues consultando amount y esto no es correcto! 
-- Estás tomando en cuenta las transacciones que por una u otra razón amount es null, pero es una transacción.

-- SELECT company_name
-- FROM company
-- WHERE id IN (SELECT company_id from transaction WHERE amount IS NULL);

--  Respuesta correcta ya que resultado no debe ser cero o null porque significa que hay transaccion se usa NOT IN
SELECT company_name
FROM company
WHERE id NOT IN (SELECT company_id from transaction);

-- Nivell 2
-- Exercici 1
-- Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. 
-- Mostra la data de cada transacció juntament amb el total de les vendes.\
-- La variable declined se usa para las preguntas sobre analisis por ventas( para transaciones no se hace este filtro)

SELECT DATE(timestamp) AS FECHA, SUM(amount) AS VENTAS_TOTAL 
FROM transaction
WHERE declined = 0
GROUP BY FECHA
ORDER BY VENTAS_TOTAL DESC
LIMIT 5;

-- Exercici 2
-- Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.
SELECT country, round(AVG(amount),2) as monto_medio
FROM transaction
JOIN company ON company.id = company_id
GROUP BY 1
ORDER BY 2 DESC;

-- Exercici 3
-- En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries per a fer competència a la companyia "Non Institute".
-- Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia.

-- Mostra el llistat aplicant JOIN i subconsultes.

SELECT *
FROM transaction
JOIN company ON company.id = company_id 
WHERE country = (SELECT DISTINCT country
					FROM company
					WHERE company_name = "Non Institute");


-- Mostra el llistat aplicant solament subconsultes.
SELECT *
FROM transaction
WHERE company_id = ANY (SELECT id
						FROM company 
						WHERE country = (SELECT DISTINCT country
											FROM company
											WHERE company_name = "Non Institute"));
      

-- Nivel 3
-- Ejercicio 1
-- Presenta el nombre, teléfono, país, fecha y amount, de aquellas empresas que realizaron transacciones con un valor comprendido entre 100 y 200 euros y
-- en alguna de estas fechas: 29 de abril de 2021, 20 de julio de 2021 y 13 de marzo de 2022. Ordena los resultados de mayor a menor cantidad.

SELECT company_name, phone, country, DATE(timestamp) AS FECHA, amount
FROM transaction
JOIN company ON company.id = company_id
WHERE (amount BETWEEN 100 AND 200) AND (DATE(timestamp) IN ('2021-04-29', '2021-07-20', '2022-03-13'))
ORDER BY 4 DESC;

-- Ejercicio 2
-- Necesitamos optimizar la asignación de los recursos y dependerá de la capacidad operativa que se requiera, 
-- por lo que te piden la información sobre la cantidad de transacciones que realizan las empresas, 
-- pero el departamento de recursos humanos es exigente y quiere un listado de las empresas en las que especifiques si tienen más de 4 transacciones o menos.

SELECT company_name, COUNT(*), 
		CASE
			WHEN COUNT(*) < 4 THEN 'Poca actividad'
            ELSE 'Mucha actividad'
		END AS actividad
FROM  transaction
JOIN company ON company.id = company_id
GROUP BY company_name
ORDER BY 2 DESC;
