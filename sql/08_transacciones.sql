-- TFI BD I - Etapa 5. Procedimiento definitivo ejecutado y verificado.
-- Ejecutar en MySQL 8.0 despues de cargar las tablas.
-- Logging de errores visible en el resultado SELECT, no persistente.
USE foodstore_bdi;
DROP PROCEDURE IF EXISTS sp_descontar_stock_retry;
DELIMITER $$
CREATE PROCEDURE sp_descontar_stock_retry(
    IN p_producto_id INT UNSIGNED,
    IN p_cantidad INT
)
BEGIN
    DECLARE v_intento INT DEFAULT 0;
    DECLARE v_exito BOOLEAN DEFAULT FALSE;
    DECLARE v_codigo INT DEFAULT 0;
    DECLARE v_estado CHAR(5) DEFAULT '00000';
    DECLARE v_mensaje TEXT DEFAULT '';

    reintentos: LOOP
        SET v_intento = v_intento + 1;
        SET v_exito = FALSE;
        SET v_codigo = 0;
        SET v_estado = '00000';
        SET v_mensaje = '';
        BEGIN
            DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                GET STACKED DIAGNOSTICS CONDITION 1
                    v_codigo = MYSQL_ERRNO,
                    v_estado = RETURNED_SQLSTATE,
                    v_mensaje = MESSAGE_TEXT;
                ROLLBACK;
            END;
            START TRANSACTION;
            IF p_cantidad IS NULL OR p_cantidad <= 0 THEN
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Cantidad invalida';
            END IF;
            UPDATE producto
            SET stock = stock - p_cantidad
            WHERE id = p_producto_id
              AND eliminado = 0
              AND disponible = 1
              AND stock >= p_cantidad;
            IF ROW_COUNT() <> 1 THEN
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT =
                        'Producto inexistente o stock insuficiente';
            END IF;
            COMMIT;
            SET v_exito = TRUE;
        END;
        IF v_exito THEN
            SELECT 'COMMIT' AS resultado, v_intento AS intento;
            LEAVE reintentos;
        END IF;
        SELECT 'ROLLBACK' AS resultado,
               v_intento AS intento,
               v_codigo AS codigo_error,
               v_estado AS sqlstate_error,
               v_mensaje AS detalle;
        IF (v_codigo = 1213 OR v_estado = '40001')
           AND v_intento < 3 THEN
            DO SLEEP(0.2 * v_intento);
        ELSE
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Transaccion fallida';
        END IF;
    END LOOP;
END$$
DELIMITER ;
SHOW PROCEDURE STATUS
WHERE Db = 'foodstore_bdi' AND Name = 'sp_descontar_stock_retry';

-- Pruebas realizadas desde Workbench (no se ejecutan aqui):
-- CALL sp_descontar_stock_retry(903, 1);    -- COMMIT, 14 -> 13
-- CALL sp_descontar_stock_retry(903, 9999); -- ROLLBACK, error 1644
-- Se restauro el stock a 14. En variante temporal se simulo
-- 1213/40001 en intento 1; reintento 2 -> COMMIT.
-- La simulacion fue eliminada de esta definicion definitiva.
