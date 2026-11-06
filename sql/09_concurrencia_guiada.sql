-- TFI BD I - Etapa 5. Guion SQL de dos sesiones, ejecutado en Workbench.
-- Cada grupo se ejecuta manualmente en su sesion; NO ejecutar el
-- archivo completo de una sola vez.
-- Stocks de referencia: producto 1 = 20 y producto 903 = 14.
USE foodstore_bdi;
-- Ejecutar en CADA conexion antes de iniciar las transacciones:
-- SET @id_agua = (SELECT id FROM producto WHERE nombre = 'Agua mineral 500 ml' LIMIT 1);
-- SET @id_tfi = (SELECT id FROM producto WHERE nombre = 'Producto TFI 00001' LIMIT 1);
-- SELECT @id_agua, @id_tfi; -- si alguno es NULL, detener la prueba.
-- DEADLOCK REAL (04/11/2026)
-- A (id 42): START TRANSACTION;
-- A: UPDATE producto SET stock = stock + 1 WHERE id = @id_agua;
-- B (id 44): START TRANSACTION;
-- B: UPDATE producto SET stock = stock + 1 WHERE id = @id_tfi;
-- A: UPDATE producto SET stock = stock + 1 WHERE id = @id_tfi; -- queda esperando
-- B: UPDATE producto SET stock = stock + 1 WHERE id = @id_agua; -- ERROR 1213
-- En A se observo ERROR 2013 (conexion perdida), no 1213.
-- Ejecutar ROLLBACK en ambas sesiones, comprobando los stocks originales.

-- REPEATABLE READ (05/11/2026)
-- A (id 49): SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- A: START TRANSACTION;
-- A: SELECT stock FROM producto WHERE id = @id_agua; -- 20
-- B (id 51): START TRANSACTION;
-- B: UPDATE producto SET stock = stock + 1 WHERE id = @id_agua;
-- B: COMMIT;
-- A: SELECT stock FROM producto WHERE id = @id_agua; -- sigue 20
-- A: ROLLBACK;

-- READ COMMITTED (05/11/2026)
-- A: SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- A: START TRANSACTION;
-- A: SELECT stock FROM producto WHERE id = @id_agua; -- 21
-- B: START TRANSACTION;
-- B: UPDATE producto SET stock = stock + 1 WHERE id = @id_agua;
-- B: COMMIT;
-- A: SELECT stock FROM producto WHERE id = @id_agua; -- 22
-- A: ROLLBACK;
-- B: START TRANSACTION;
-- B: UPDATE producto SET stock = 20 WHERE id = @id_agua AND stock = 22;
-- B: COMMIT;

-- Control sin alteracion de datos:
SELECT id, nombre, stock FROM producto
WHERE id IN (1,903) ORDER BY id;
-- Resultado final observado: 1 -> 20, 903 -> 14.

-- Las actualizaciones por id aprovechan la clave primaria.
-- No se midio la contencion con indices desactivados en Etapa 5.
