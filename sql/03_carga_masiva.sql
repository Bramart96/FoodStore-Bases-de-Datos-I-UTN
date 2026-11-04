-- Food Store - Carga masiva de productos
-- Requiere haber ejecutado 01_esquema.sql y 02_catalogos.sql.
USE foodstore_bdi;

-- Producto inicial utilizado en las pruebas (se conserva si ya existe).
INSERT INTO producto (nombre, precio, descripcion, stock, categoria_id)
SELECT 'Agua mineral 500 ml', 1200.00, 'Botella de agua sin gas', 20, c.id
FROM categoria c
WHERE c.nombre = 'Bebidas'
  AND c.eliminado = 0
  AND NOT EXISTS (
      SELECT 1 FROM producto p
      WHERE p.nombre = 'Agua mineral 500 ml'
  );

-- 9.899 productos ficticios, repartidos entre las 100 categorías.
-- Se evita insertar un nombre de prueba que ya exista.
INSERT INTO producto (
    nombre,
    precio,
    descripcion,
    stock,
    categoria_id
)
WITH
digitos AS (
    SELECT 0 AS n UNION ALL SELECT 1 UNION ALL
    SELECT 2 UNION ALL SELECT 3 UNION ALL
    SELECT 4 UNION ALL SELECT 5 UNION ALL
    SELECT 6 UNION ALL SELECT 7 UNION ALL
    SELECT 8 UNION ALL SELECT 9
),
numeros AS (
    SELECT
        a.n * 1000 + b.n * 100 +
        c.n * 10 + d.n + 1 AS n
    FROM digitos a
    CROSS JOIN digitos b
    CROSS JOIN digitos c
    CROSS JOIN digitos d
),
categorias_ordenadas AS (
    SELECT
        id,
        ROW_NUMBER() OVER (ORDER BY id) AS posicion
    FROM categoria
)
SELECT
    CONCAT('Producto TFI ', LPAD(n.n, 5, '0')),
    500 + MOD(n.n * 37, 10000),
    'Producto ficticio para carga masiva',
    1 + MOD(n.n * 13, 100),
    cat.id
FROM numeros n
JOIN categorias_ordenadas cat
    ON cat.posicion = MOD(n.n - 1, 100) + 1
WHERE n.n BETWEEN 1 AND 9899
AND NOT EXISTS (
    SELECT 1
    FROM producto p
    WHERE p.nombre =
        CONCAT('Producto TFI ', LPAD(n.n, 5, '0'))
);

-- Cinco verificaciones de consistencia:
-- 1. Cantidad de registros
SELECT
    (SELECT COUNT(*) FROM categoria) AS categorias,
    (SELECT COUNT(*) FROM producto) AS productos,
    (SELECT COUNT(*) FROM categoria) +
    (SELECT COUNT(*) FROM producto) AS total_registros;

-- 2. Productos sin categoría existente
SELECT COUNT(*) AS productos_sin_categoria
FROM producto p
LEFT JOIN categoria c ON p.categoria_id = c.id
WHERE c.id IS NULL;

-- 3. Precio, stock y estados válidos
SELECT COUNT(*) AS registros_invalidos
FROM producto
WHERE precio < 0
   OR stock < 0
   OR disponible NOT IN (0, 1)
   OR eliminado NOT IN (0, 1);

-- 4. Categorías referenciadas
SELECT COUNT(DISTINCT categoria_id) AS categorias_con_productos
FROM producto;

-- 5. Nombres duplicados entre los productos generados
SELECT nombre, COUNT(*) AS cantidad
FROM producto
WHERE nombre LIKE 'Producto TFI %'
GROUP BY nombre
HAVING COUNT(*) > 1;
