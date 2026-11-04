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

-- Las dos vistas de minimo privilegio requeridas en Etapa 4
-- se incorporaran cuando sean implementadas y verificadas.
