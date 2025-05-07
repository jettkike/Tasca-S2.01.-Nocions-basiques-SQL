-- Exercici 2
-- Utilitzant JOIN realitzaràs les següents consultes:
-- 1) Llistat dels països que estan fent compres.
SELECT DISTINCT country
FROM transaction
JOIN company on  transaction.company_id = company.id
WHERE transaction.declined = 0
ORDER BY country ASC;

-- 2) Des de quants països es realitzen les compres.
SELECT COUNT( DISTINCT country) as num_country
FROM company
JOIN transaction on transaction.company_id = company.id
WHERE transaction.declined = 0;

--  3) Identifica la companyia amb la mitjana més gran de vendes.
SELECT company_name, ROUND(AVG(amount),2) as media
FROM company
JOIN transaction on transaction.company_id = company.id
WHERE transaction.declined = 0
GROUP BY company_name
ORDER BY AVG(amount) DESC
limit 1;

-- Exercici 3
-- Utilitzant només subconsultes (sense utilitzar JOIN):

-- 1) Mostra totes les transaccions realitzades per empreses d'Alemanya.
SELECT *
FROM transaction
where transaction.company_id = any (SELECT company.id
									FROM company
									WHERE country = 'Germany');


-- 2) Llista les empreses que han realitzat transaccions
-- per un amount superior a la mitjana de totes les transaccions.
SELECT company_name
FROM company
WHERE company.id = ANY (SELECT company_id
						from transaction
						WHERE amount >(SELECT AVG(amount) FROM transaction));



-- 3) Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.

SELECT company_name
FROM company
WHERE company.id IN (SELECT transaction.company_id from transaction WHERE amount IS NULL);


-- Nivell 2
-- Exercici 1
-- Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. 
-- Mostra la data de cada transacció juntament amb el total de les vendes.

SELECT DATE(timestamp) AS FECHA, SUM(amount) AS VENTAS_TOTAL 
FROM transaction
WHERE declined = 0
GROUP BY FECHA
ORDER BY VENTAS_TOTAL DESC
LIMIT 5;

-- Exercici 2
-- Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.
SELECT country, AVG(amount)
FROM transaction
JOIN company ON company.id = transaction.company_id
GROUP BY 1
ORDER BY 2 DESC;

-- Exercici 3
-- En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries per a fer competència a la companyia "Non Institute".
-- Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia.

-- Mostra el llistat aplicant JOIN i subconsultes.

SELECT *
FROM transaction
JOIN company ON company.id = transaction.company_id 
WHERE country = (SELECT DISTINCT country
					FROM company
					WHERE company_name = "Non Institute");


-- Mostra el llistat aplicant solament subconsultes.
SELECT *
FROM transaction
WHERE company_id = ANY (SELECT company.id
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
JOIN company ON company.id = transaction.company_id
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
JOIN company ON company.id = transaction.company_id
GROUP BY company_name
ORDER BY 2 DESC;


