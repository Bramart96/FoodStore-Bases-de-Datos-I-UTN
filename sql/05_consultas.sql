-- Food Store | Etapa 3 - Consultas verificadas
USE foodstore_bdi;

-- 1. JOIN y filtro por categoria
SELECT p.nombre AS producto, p.precio, p.stock, c.nombre AS categoria
FROM producto p
INNER JOIN categoria c ON p.categoria_id = c.id
WHERE c.nombre = 'Bebidas'
ORDER BY p.id LIMIT 15;

-- 2. JOIN con rango de precios
SELECT p.nombre AS producto, p.precio, c.nombre AS categoria
FROM producto p
INNER JOIN categoria c ON p.categoria_id = c.id
WHERE p.precio BETWEEN 2000 AND 4000
ORDER BY p.precio DESC LIMIT 20;

-- 3. Agrupación y filtro de grupos
SELECT c.nombre AS categoria, COUNT(p.id) AS cantidad_productos,
       SUM(p.stock) AS stock_total
FROM categoria c
INNER JOIN producto p ON p.categoria_id = c.id
GROUP BY c.id, c.nombre
HAVING COUNT(p.id) >= 80
ORDER BY cantidad_productos DESC;

-- 4. Subconsulta de promedio (versión corregida y ejecutada)
SELECT p.nombre, p.precio
FROM producto AS p
WHERE p.precio > (SELECT AVG(p2.precio) FROM producto AS p2)
ORDER BY p.precio DESC LIMIT 15;
