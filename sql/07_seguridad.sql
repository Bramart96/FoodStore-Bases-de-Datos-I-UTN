-- Food Store | Etapa 4 - Seguridad y procedimiento parametrizado
-- Ejecución: conexión administradora MySQL Local.
-- No se almacenan contraseñas en el repositorio.
-- Requisito previo: crear manualmente 'fs_catalogo'@'localhost'
-- desde MySQL Workbench > Administration > Users and Privileges,
-- asignando una contraseña robusta que se guarda de forma segura.
-- Primero ejecutar 06_vistas.sql para disponer de la vista pública.
USE foodstore_bdi;

-- Principio de mínimo privilegio: el lector únicamente puede consultar
-- la vista pública. NO conceder SELECT sobre producto ni inventario.
GRANT SELECT ON foodstore_bdi.vista_catalogo_publico
TO 'fs_catalogo'@'localhost';

SHOW GRANTS FOR 'fs_catalogo'@'localhost';

DROP PROCEDURE IF EXISTS sp_buscar_producto_seguro;

DELIMITER $$

CREATE PROCEDURE sp_buscar_producto_seguro(
    IN p_nombre VARCHAR(120)
)
SQL SECURITY DEFINER
BEGIN
    SELECT p.id, p.nombre, p.precio
    FROM producto p
    WHERE p.nombre = p_nombre
      AND p.eliminado = 0;
END$$

DELIMITER ;

-- Ejecutadas con conexión administradora:
CALL sp_buscar_producto_seguro('Agua mineral 500 ml');
CALL sp_buscar_producto_seguro(''' OR ''1'' = ''1');

-- Conexión del lector, ejecutar por separado para obtener evidencias:
-- SELECT * FROM foodstore_bdi.vista_catalogo_publico LIMIT 5;
-- SELECT * FROM foodstore_bdi.producto LIMIT 5;              -- error 1142
-- SELECT * FROM foodstore_bdi.vista_inventario_interno LIMIT 5; -- error 1142

-- Pruebas adicionales: ejecutar cada INSERT por separado en
-- conexión administradora. Deben fallar; no incluirlas en el
-- flujo automático del script, para no interrumpirlo.
-- INSERT INTO producto (nombre,precio,stock,categoria_id)
-- VALUES ('Prueba FK invalida',100,1,999999);      -- error 1452
-- INSERT INTO producto (nombre,precio,stock,categoria_id)
-- VALUES ('Prueba precio invalido',-100,1,1);      -- error 3819
-- SELECT COUNT(*) AS total_productos FROM producto; -- 9900
