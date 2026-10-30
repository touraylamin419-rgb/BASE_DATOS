


-----Momodou Lamin Toura 
----Bateria 2 

-- 1. Artículos con precio superior a 100€ y su fabricante
SELECT articulos.nombre AS articulo, fabricantes.nombre AS fabricante
FROM articulos
JOIN fabricantes ON articulos.id_fabricante = fabricantes.id
WHERE articulos.precio > 100.00;

-- 2. Todos los fabricantes y sus artículos (incluyendo fabricantes sin artículos)
SELECT fabricantes.nombre AS fabricante, articulos.nombre AS articulo
FROM fabricantes
LEFT JOIN articulos ON fabricantes.id = articulos.id_fabricante;

-- 3. Fabricantes con una media de precios superior a 150€
SELECT fabricantes.nombre AS fabricante, AVG(articulos.precio) AS media_precio
FROM fabricantes
JOIN articulos ON fabricantes.id = articulos.id_fabricante
GROUP BY fabricantes.nombre
HAVING AVG(articulos.precio) > 150.00;

-- 4. Averías, coste y técnico (ordenado de mayor a menor coste)
SELECT reparaciones.descripcion, reparaciones.coste, tecnicos.nombre AS tecnico
FROM reparaciones
JOIN tecnicos ON reparaciones.id_tecnico = tecnicos.id
ORDER BY reparaciones.coste DESC;

-- 5. Técnicos sin reparaciones (usando cruce externo LEFT JOIN)
SELECT tecnicos.nombre
FROM tecnicos
LEFT JOIN reparaciones ON tecnicos.id = reparaciones.id_tecnico
WHERE reparaciones.id IS NULL;

-- 6. Recaudación total por técnico superior a 100€
SELECT tecnicos.nombre AS tecnico, SUM(reparaciones.coste) AS total_recaudado
FROM tecnicos
JOIN reparaciones ON tecnicos.id = reparaciones.id_tecnico
GROUP BY tecnicos.nombre
HAVING SUM(reparaciones.coste) > 100.00;

-- 7. Artículos de fabricantes de 'Estados Unidos' o 'Taiwán'
SELECT articulos.nombre AS articulo, fabricantes.nombre AS fabricante
FROM articulos
JOIN fabricantes ON articulos.id_fabricante = fabricantes.id
WHERE fabricantes.pais IN ('Estados Unidos', 'Taiwán');

-- 8. Todos los técnicos y su número total de reparaciones
SELECT tecnicos.nombre AS tecnico, COUNT(reparaciones.id) AS total_reparaciones
FROM tecnicos
LEFT JOIN reparaciones ON tecnicos.id = reparaciones.id_tecnico
GROUP BY tecnicos.nombre;

-- 9. Fabricantes con 2 o más artículos
SELECT fabricantes.nombre AS fabricante, COUNT(articulos.id) AS total_articulos
FROM fabricantes
JOIN articulos ON fabricantes.id = articulos.id_fabricante
GROUP BY fabricantes.nombre
HAVING COUNT(articulos.id) >= 2;

-- 10. Técnico, especialidad y la reparación más costosa realizada por cada uno
SELECT tecnicos.nombre, tecnicos.especialidad, reparaciones.descripcion, reparaciones.coste
FROM tecnicos
JOIN reparaciones ON tecnicos.id = reparaciones.id_tecnico
WHERE reparaciones.coste = (
    SELECT MAX(r.coste)
    FROM reparaciones r
    WHERE r.id_tecnico = tecnicos.id
);