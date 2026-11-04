-- Food Store | Etapa 3 - Vista de reporte verificada
USE foodstore_bdi;

CREATE OR REPLACE VIEW vista_resumen_categorias AS
SELECT
    c.id AS categoria_id,
    c.nombre AS categoria,
    COUNT(p.id) AS total_productos,
    COALESCE(SUM(p.stock), 0) AS stock_total,
    ROUND(AVG(p.precio), 2) AS precio_promedio
FROM categoria c
LEFT JOIN producto p
    ON p.categoria_id = c.id
    AND p.eliminado = 0
WHERE c.eliminado = 0
GROUP BY c.id, c.nombre;

SELECT *
FROM vista_resumen_categorias
ORDER BY total_productos DESC
LIMIT 10;

-- Etapa 4: vistas para accesos limitados.
-- Ejecutadas y consultadas en MySQL Workbench.

-- El catálogo público no muestra stock.
CREATE OR REPLACE VIEW vista_catalogo_publico AS
SELECT
    p.id,
    p.nombre,
    p.precio,
    c.nombre AS categoria
FROM producto p
INNER JOIN categoria c ON p.categoria_id = c.id
WHERE p.eliminado = 0
  AND p.disponible = 1
  AND c.eliminado = 0;

-- El inventario interno no muestra precios.
CREATE OR REPLACE VIEW vista_inventario_interno AS
SELECT
    p.id,
    p.nombre,
    p.stock,
    c.nombre AS categoria
FROM producto p
INNER JOIN categoria c ON p.categoria_id = c.id
WHERE p.eliminado = 0
  AND c.eliminado = 0;

SELECT * FROM vista_catalogo_publico LIMIT 10;
SELECT * FROM vista_inventario_interno LIMIT 10;
