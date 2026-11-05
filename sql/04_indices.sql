-- Food Store | Etapa 3 - Indices (ejecutado y comprobado en Workbench)
-- Crear una sola vez, después de la carga masiva.
-- Pendiente preparar reejecución idempotente para el ZIP final.
USE foodstore_bdi;

CREATE INDEX idx_producto_nombre ON producto(nombre);
CREATE INDEX idx_producto_precio ON producto(precio);
CREATE INDEX idx_producto_categoria_precio ON producto(categoria_id, precio);
CREATE INDEX idx_categoria_nombre ON categoria(nombre);

SHOW INDEX FROM producto;
SHOW INDEX FROM categoria;
