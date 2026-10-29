
-- Momodou Lamin Touray
-- Ejercicio 1: Muestra el nombre y el precio de aquellos artículos que sean, exactamente,  el artículo más caro de su respectivo fabricante.
SELECT a1.nombre, a1.precio
FROM Articulo a1
WHERE a1.precio = (
    SELECT MAX(a2.precio)
    FROM Articulo a2
    WHERE a2.fabricante_id = a1.fabricante_id
);


-- Ejercicio 2:  Muestra el nombre de los fabricantes que no tienen ningún artículo con un precio inferior o igual a la media general de precios de toda la tienda.
SELECT nombre
FROM Fabricante
WHERE id NOT IN (
    SELECT DISTINCT fabricante_id
    FROM Articulo
    WHERE precio <= (SELECT AVG(precio) FROM Articulo)
);


-- Ejercicio 3:  Muestra la descripción y el coste de aquellas reparaciones cuyo coste sea estrictamente superior a la media de las reparaciones realizadas por su propio técnico.
SELECT r1.descripcion, r1.coste
FROM Reparacion r1
WHERE r1.coste > (
    SELECT AVG(r2.coste)
    FROM Reparacion r2
    WHERE r2.tecnico_id = r1.tecnico_id
);


-- Ejercicio 4: Muestra el identificador y la especialidad de los técnicos cuya suma total del coste  de las reparaciones que han realizado supere el doble de su propio salario.
SELECT id, especialidad
FROM Tecnico t
WHERE (
    SELECT SUM(r.coste)
    FROM Reparacion r
    WHERE r.tecnico_id = t.id
) > (2 * t.salario);


-- Ejercicio 5:  Muestra el nombre del fabricante (o fabricantes) que posee el mayor número de artículos registrados en la base de datos.
SELECT nombre
FROM Fabricante
WHERE id IN (
    SELECT fabricante_id
    FROM Articulo
    GROUP BY fabricante_id
    HAVING COUNT(*) >= ALL (
        SELECT COUNT(*)
        FROM Articulo
        GROUP BY fabricante_id
    )
);


-- Ejercicio 6: Muestra el nombre de los técnicos que han realizado alguna reparación, pero que nunca han realizado ninguna reparación cuyo coste haya superado los 100.00 euros.
SELECT nombre
FROM Tecnico
WHERE id IN (SELECT tecnico_id FROM Reparacion)
  AND id NOT IN (
      SELECT tecnico_id
      FROM Reparacion
      WHERE coste > 100.00
  );


-- Ejercicio 7: Muestra el nombre y el salario de los técnicos cuyo salario sea inferior a la media  salarial de su propia especialidad.
SELECT t1.nombre, t1.salario
FROM Tecnico t1
WHERE t1.salario < (
    SELECT AVG(t2.salario)
    FROM Tecnico t2
    WHERE t2.especialidad = t1.especialidad
);


-- Ejercicio 8:  Muestra el nombre de los fabricantes cuyo país coincide con el país del fabricante que produce el artículo más caro de toda la tienda.
SELECT nombre
FROM Fabricante
WHERE pais = (
    SELECT pais
    FROM Fabricante
    WHERE id = (
        SELECT fabricante_id
        FROM Articulo
        ORDER BY precio DESC
        LIMIT 1
    )
);


-- Ejercicio 9: Muestra el nombre y el precio del artículo más barato de entre todos los fabricantes que son originarios de 'Estados Unidos'.
SELECT nombre, precio
FROM Articulo
WHERE fabricante_id IN (
    SELECT id
    FROM Fabricante
    WHERE pais = 'Estados Unidos'
)
ORDER BY precio ASC
LIMIT 1;


-- Ejercicio 10:  Muestra el identificador del técnico (tecnico_id) que ha acumulado el mayor  coste total en reparaciones.
SELECT tecnico_id
FROM Reparacion
GROUP BY tecnico_id
ORDER BY SUM(coste) DESC
LIMIT 1;