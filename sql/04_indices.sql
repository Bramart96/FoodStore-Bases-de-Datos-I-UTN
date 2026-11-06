-- Etapa 3: crea los cuatro indices solo si no existen.
USE foodstore_bdi;
DROP PROCEDURE IF EXISTS sp_instalar_indices;
DELIMITER $$
CREATE PROCEDURE sp_instalar_indices()
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.statistics
        WHERE table_schema = DATABASE() AND table_name = 'producto'
          AND index_name = 'idx_producto_nombre'
    ) THEN
        CREATE INDEX idx_producto_nombre ON producto(nombre);
    END IF;
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.statistics
        WHERE table_schema = DATABASE() AND table_name = 'producto'
          AND index_name = 'idx_producto_precio'
    ) THEN
        CREATE INDEX idx_producto_precio ON producto(precio);
    END IF;
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.statistics
        WHERE table_schema = DATABASE() AND table_name = 'producto'
          AND index_name = 'idx_producto_categoria_precio'
    ) THEN
        CREATE INDEX idx_producto_categoria_precio ON producto(categoria_id,precio);
    END IF;
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.statistics
        WHERE table_schema = DATABASE() AND table_name = 'categoria'
          AND index_name = 'idx_categoria_nombre'
    ) THEN
        CREATE INDEX idx_categoria_nombre ON categoria(nombre);
    END IF;
END$$
DELIMITER ;
CALL sp_instalar_indices();
DROP PROCEDURE IF EXISTS sp_instalar_indices;
SHOW INDEX FROM producto;
SHOW INDEX FROM categoria;
