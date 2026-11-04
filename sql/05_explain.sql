-- Food Store | Etapa 3 - Rendimiento y EXPLAIN ANALYZE
-- Ejecutar tres veces cada consulta antes y despues de crear los indices
-- de 04_indices.sql. No comparar el tiempo de Action Output de Workbench;
-- utilizar actual time de la raíz del plan, en milisegundos.
USE foodstore_bdi;

-- Igualdad
EXPLAIN ANALYZE
SELECT id, nombre, precio
FROM producto
WHERE nombre = 'Producto TFI 05000';

-- Rango
EXPLAIN ANALYZE
SELECT id, nombre, precio
FROM producto
WHERE precio BETWEEN 2000 AND 4000;

-- JOIN
EXPLAIN ANALYZE
SELECT p.id, p.nombre, p.precio, c.nombre
FROM producto p
INNER JOIN categoria c ON p.categoria_id = c.id
WHERE c.nombre = 'Bebidas'
  AND p.precio BETWEEN 2000 AND 4000;
