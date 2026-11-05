-- Food Store - Catalogos y categorias de prueba
-- Ejecutar después de 01_esquema.sql.
USE foodstore_bdi;

-- Datos iniciales utilizados en las pruebas de integridad.
INSERT INTO categoria (nombre, descripcion)
SELECT s.nombre, s.descripcion
FROM (
    SELECT 'Bebidas' AS nombre, 'Bebidas y refrescos' AS descripcion
    UNION ALL
    SELECT 'Postres', 'Productos dulces'
) s
WHERE NOT EXISTS (
    SELECT 1
    FROM categoria c
    WHERE c.nombre = s.nombre AND c.eliminado = 0
);

-- Generación de 98 categorías ficticias (consulta ya probada en Workbench).
INSERT INTO categoria (nombre, descripcion)
WITH RECURSIVE numeros AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM numeros
    WHERE n < 98
)
SELECT
    CONCAT('Categoria TFI ', LPAD(n, 3, '0')),
    'Categoria ficticia para pruebas'
FROM numeros
WHERE NOT EXISTS (
    SELECT 1
    FROM categoria c
    WHERE c.nombre = CONCAT('Categoria TFI ', LPAD(n, 3, '0'))
);

SELECT COUNT(*) AS total_categorias
FROM categoria;
