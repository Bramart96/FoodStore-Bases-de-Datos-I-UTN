# Informe técnico — Food Store

**Trabajo Final Integrador — Bases de Datos I**  
**Tecnicatura Universitaria en Programación — UTN**  
**Alumno:** Braian Martinez · **Comisión:** C1

## 1. Descripción del sistema

Food Store es un sistema de gestión de pedidos de comida. El modelo de referencia contempla categorías, productos, usuarios y pedidos. Para el esquema relacional inicial de Bases de Datos I se utilizan las entidades **categoria** y **producto**, vinculadas mediante una relación **uno a muchos**.

Este trabajo comparte el dominio de negocio con Programación II, pero mantiene un repositorio y una implementación de base de datos independientes.

## 2. Reglas de negocio

- Las categorías deben tener un nombre.
- No puede haber dos categorías activas con el mismo nombre.
- Los productos deben tener precio y stock no negativos.
- Cada producto pertenece a una categoría existente y activa.
- Las bajas son lógicas, mediante el campo `eliminado`.
- No se puede dar de baja una categoría con productos activos asociados.
- Los productos dados de baja no pueden agregarse a nuevos pedidos.
- La confirmación de pedidos debe descontar stock dentro de una transacción; ante fallos se debe revertir.

Las reglas relacionadas con pedidos provienen del sistema de referencia y todavía no se han implementado en esta base.

## 3. Entorno y esquema

Se utiliza **MySQL Workbench** conectado a **MySQL Server 8.0.46**, versión comprobada mediante `SELECT VERSION()`. Se creó la base independiente `foodstore_bdi` y se verificó su definición con `SHOW CREATE DATABASE foodstore_bdi`:

- Juego de caracteres: `utf8mb4`.
- Cotejamiento: `utf8mb4_0900_ai_ci`.
- Cifrado predeterminado indicado por el servidor: `N`.

La presencia de la base y el resultado de la consulta fueron comprobados. Las dos tablas fueron creadas en MySQL Workbench y se verificaron sus restricciones y la relación mediante clave foránea.

## 4. Diseño relacional inicial

### categoria

| Atributo | Tipo | Restricción |
| --- | --- | --- |
| id | INT UNSIGNED | PRIMARY KEY, AUTO_INCREMENT |
| nombre | VARCHAR(100) | NOT NULL, CHECK para evitar nombres vacíos |
| descripcion | VARCHAR(255) | NULL |
| eliminado | BOOLEAN | NOT NULL, DEFAULT FALSE, CHECK 0/1 |
| created_at | DATETIME | NOT NULL, DEFAULT CURRENT_TIMESTAMP |
| nombre_activo | VARCHAR(100) | Columna generada almacenada, UNIQUE |

**Decisión:** para la unicidad de nombres de categorías activas se utiliza una columna generada: conserva el nombre cuando `eliminado = 0` y toma `NULL` cuando la categoría se elimina lógicamente. La restricción `UNIQUE` sobre esa columna impide duplicados activos y permite conservar registros históricos. Se eligió esta alternativa frente a `UNIQUE(nombre)`, que también impediría reutilizar nombres de categorías dadas de baja.

**Estado:** tabla `categoria` creada y comprobada en Workbench. Se verificaron sus restricciones PRIMARY KEY, UNIQUE y dos CHECK; las pruebas de inserción están documentadas en el apartado 5.

### producto

| Atributo | Tipo | Restricción |
| --- | --- | --- |
| id | INT UNSIGNED | PRIMARY KEY, AUTO_INCREMENT |
| nombre | VARCHAR(120) | NOT NULL, CHECK nombre no vacío |
| precio | DECIMAL(10,2) | NOT NULL, CHECK precio >= 0 |
| descripcion | VARCHAR(255) | NULL |
| stock | INT | NOT NULL, DEFAULT 0, CHECK stock >= 0 |
| imagen | VARCHAR(255) | NULL |
| disponible | BOOLEAN | NOT NULL, DEFAULT TRUE, CHECK 0/1 |
| eliminado | BOOLEAN | NOT NULL, DEFAULT FALSE, CHECK 0/1 |
| created_at | DATETIME | NOT NULL, DEFAULT CURRENT_TIMESTAMP |
| categoria_id | INT UNSIGNED | NOT NULL, FOREIGN KEY a categoria(id) |

**Relación implementada:** una categoría puede tener varios productos; cada producto referencia una única categoría existente. La clave `fk_producto_categoria` utiliza `ON DELETE RESTRICT` y `ON UPDATE RESTRICT`. Se verificaron una inserción válida, un rechazo por FK y dos rechazos por CHECK.

**Alcance de esta implementación:** la FK impide categorías inexistentes, pero no verifica si `categoria.eliminado = 0`. Tampoco impide por sí sola la baja lógica de una categoría con productos activos. Estas reglas del negocio siguen pendientes de resolución; no se las presenta como implementadas.

### Representación gráfica y modelo relacional

El estudiante generó el diagrama EER mediante ingeniería inversa en MySQL Workbench, con `categoria` y `producto`, sus claves y la relación **1:N no identificadora**. Confirmó haber guardado `FoodStore_BDI.mwb` y exportado `DER_FoodStore.png` en su equipo. La captura del diagrama fue revisada; los archivos exportados aún no se han incorporado al repositorio.

```text
categoria(id PK, nombre, descripcion, eliminado, created_at,
          nombre_activo UNIQUE [generado])

producto(id PK, nombre, precio, descripcion, stock, imagen,
         disponible, eliminado, created_at, categoria_id FK)

FK: producto.categoria_id -> categoria.id
```

## 5. Pruebas y evidencias

Las comprobaciones se realizaron en MySQL Workbench. Se conserva el resultado real de cada prueba; en el PDF final se seleccionarán únicamente las capturas necesarias y se presentará un resumen técnico en texto.

| Prueba | Resultado comprobado |
| --- | --- |
| Versión del servidor | `SELECT VERSION()` devolvió `8.0.46` |
| Esquema `foodstore_bdi` | Creado e inspeccionado: `utf8mb4 / utf8mb4_0900_ai_ci` |
| `categoria`: creación y definición | `SHOW CREATE TABLE` devolvió el DDL |
| `categoria`: restricciones | 1 PRIMARY KEY, 1 UNIQUE y 2 CHECK |
| `categoria`: insertar `Bebidas` y `Postres` | 2 inserciones válidas |
| `categoria`: nombre activo duplicado | Error `1062`, `uq_categoria_nombre_activo` |
| `categoria`: nombre solo espacios | Error `3819`, `chk_categoria_nombre` |
| `categoria`: recuento final | 2 registros |
| `producto`: creación y definición | `SHOW CREATE TABLE` devolvió el DDL |
| `producto`: restricciones | 1 PRIMARY KEY, 1 FOREIGN KEY y 5 CHECK |
| `producto`: insertar `Agua mineral 500 ml` | Inserción válida (precio 1200.00, stock 20, categoria_id 1) |
| `producto`: categoría 999999 inexistente | Error `1452`, restricción FK |
| `producto`: precio -500.00 | Error `3819`, `chk_producto_precio` |
| `producto`: stock -10 | Error `3819`, `chk_producto_stock` |
| `producto`: recuento final | 1 registro, informado por el estudiante |
| Diagrama EER | Generado y revisado; archivos guardados localmente |

**Conclusión de integridad:** las pruebas realizadas muestran que el modelo acepta inserciones válidas y rechaza registros que violan las restricciones verificadas. El resultado final informado fue de dos categorías y un producto. La Etapa 1 dispone de las entidades, la relación y las pruebas mínimas; se revisará la presentación del DER exportado y la adecuación de las reglas de negocio pendientes antes de declararla cerrada.

**Referencia al código:** `sql/01_esquema.sql`. Las inserciones de prueba y sus errores se ejecutaron en Workbench; se preparará una versión ordenada y reproducible de las evidencias para la entrega.

## 6. Carga masiva y verificaciones — Etapa 2

**Objetivo:** disponer de al menos 10.000 registros ficticios en dos tablas, generados mediante SQL puro, sin romper las restricciones establecidas en el modelo.

**Mecanismo utilizado:** se conservaron inicialmente dos categorías de prueba y un producto válido. Para llegar a 100 categorías se generaron 98 adicionales mediante una expresión de tabla común recursiva (CTE), que produce números del 1 al 98 y forma nombres consecutivos. Para los productos se utilizó una CTE de dígitos combinados con CROSS JOIN, capaz de producir números del 1 al 10.000; se seleccionaron los primeros 9.899. La numeración permite construir nombres, precios y cantidades de stock ficticios mediante CONCAT, LPAD y MOD. Para asignar categorías se numeraron los identificadores existentes con ROW_NUMBER y se repartieron los productos en 100 posiciones mediante MOD. Las inserciones emplean NOT EXISTS para evitar repetir los nombres de prueba al volver a ejecutarlas.

La estructura respeta la FK de producto a categoria; las comprobaciones del servidor confirmaron que no quedaron productos huérfanos. Todas las filas generadas tienen precios y stock no negativos, y los indicadores de estado utilizan sus valores predeterminados válidos. Las verificaciones contemplan cantidad de registros, integridad referencial, dominios, categorías utilizadas y duplicación de nombres generados. Los valores de precios y existencias son ficticios y no representan operaciones de venta reales.

**Resultado informado y confirmado por el estudiante después de ejecutar ambos bloques en Workbench:**

| Control | Resultado |
| --- | --- |
| Categorías | 100 |
| Productos | 9.900 |
| Total de registros | 10.000 |
| Productos sin categoría | 0 |
| Registros con precio/stock/estado inválido | 0 |
| Categorías utilizadas por productos | 100 |
| Nombres duplicados de prueba | 0 filas |

**Referencias cruzadas:** sql/02_catalogos.sql y sql/03_carga_masiva.sql. Estos archivos reúnen las consultas probadas y las inserciones iniciales para permitir una futura reconstrucción. **Pendiente:** ejecutar desde cero la secuencia completa de scripts en un entorno de prueba antes de declarar garantizada su reproducibilidad integral.

**Conclusión:** se alcanzó el mínimo de 10.000 registros y las cinco verificaciones devolvieron los resultados previstos. No se realizó ninguna medición de rendimiento en esta etapa; se aborda por separado en la Etapa 3.

## 7. Consultas, vista y rendimiento — Etapa 3

Se ejecutaron y comprobaron cuatro consultas: JOIN para listar productos de Bebidas, JOIN con filtro por rango de precios, GROUP BY/HAVING para categorías con al menos 80 productos y una subconsulta para encontrar productos por encima del precio promedio. La subconsulta original dio un error 1064; se probó una versión con alias explícitos que devolvió 15 filas. También se creó y consultó con éxito `vista_resumen_categorias`, que muestra la cantidad de productos, el stock total y el precio promedio de cada categoría activa.

Se realizaron tres mediciones por consulta y condición mediante `EXPLAIN ANALYZE`. Se tomaron los tiempos `actual time` del operador raíz del plan, en milisegundos; no los tiempos del panel Action Output de Workbench. Antes de agregar índices, las búsquedas por nombre y precio realizaron un escaneo completo de la tabla producto. Tras crear los índices, la búsqueda exacta pasó a utilizar `idx_producto_nombre`, y la búsqueda por rango utilizó `idx_producto_precio`. En el JOIN se observó un acceso por índice a categoría a través de `idx_categoria_nombre`; el detalle completo del acceso a producto no se conservó en los textos compartidos por el estudiante.

**Índices creados y comprobados:** `idx_producto_nombre`, `idx_producto_precio`, `idx_producto_categoria_precio`, `idx_categoria_nombre`. Se verificaron con SHOW INDEX sobre ambas tablas.

| Consulta | Antes: 3 ejecuciones (ms) | Mediana antes (ms) | Después: 3 ejecuciones (ms) | Mediana después (ms) |
| --- | --- | ---: | --- | ---: |
| Igualdad por nombre | 10.20, 9.35, 12.70 | 10.20 | 0.122, 0.0344, 0.0644 | 0.0644 |
| Rango de precios | 9.51, 7.69, 8.17 | 8.17 | 4.45, 4.14, 6.03 | 4.45 |
| JOIN con filtros | 0.293, 0.495, 0.439 | 0.439 | 0.128, 0.186, 0.138 | 0.138 |

**Interpretación:** las tres medianas disminuyeron en esta prueba concreta: igualdad aproximadamente 158,4 veces, rango 1,84 veces y JOIN 3,18 veces. No se extrapolan estos resultados a otros tamaños de tabla. Los cuatro índices se crearon con éxito y los registros de EXPLAIN ANALYZE fueron compartidos por el estudiante. La comparación refleja la presencia o ausencia de índices secundarios adicionales; las claves primarias y el índice asociado a la FK existían previamente.

**Archivos:** sql/04_indices.sql, sql/05_consultas.sql, sql/05_explain.sql y sql/06_vistas.sql. Los archivos organizan las consultas ya ejecutadas; falta realizar la prueba integral de reconstrucción del ZIP.

## 8. Seguridad, permisos y consulta parametrizada — Etapa 4

Se crearon dos vistas diferenciadas: `vista_catalogo_publico`, que expone id, nombre, precio y categoría sin stock; y `vista_inventario_interno`, que expone id, nombre, stock y categoría sin precios. Se verificaron ambas mediante SELECT con LIMIT 10. La vista resumen de la Etapa 3 permanece independiente.

Se creó mediante Workbench el usuario `fs_catalogo` con host `localhost`, y se le concedió únicamente SELECT sobre `vista_catalogo_publico`. Los permisos se inspeccionaron con SHOW GRANTS y se conectó un segundo cliente con este usuario. Pruebas: consulta de vista pública → 5 filas; consulta directa a `producto` → error 1142; consulta a `vista_inventario_interno` → error 1142. Posteriormente se cambió la contraseña de la cuenta para que la anterior no siguiera siendo válida; se comprobó una nueva conexión y una consulta exitosa de cinco filas. No se almacena ninguna contraseña en el repositorio.

Se implementó `sp_buscar_producto_seguro(IN p_nombre VARCHAR(120))`, que usa el parámetro directamente en una condición SQL estática, sin concatenación ni SQL dinámico. La búsqueda del agua mineral devolvió un registro; la cadena de prueba `' OR '1' = '1` devolvió cero filas y no alteró la condición de la consulta. La advertencia 1305 de DROP PROCEDURE IF EXISTS se debió a la inexistencia inicial del procedimiento.

Se efectuaron dos pruebas negativas de integridad sobre producto (en consultas separadas para no interrumpir el resto del script): categoría inexistente → error 1452 por FK; precio negativo → error 3819 por `chk_producto_precio`. Tras esos rechazos se verificó que había 9.900 productos, es decir, las inserciones inválidas no modificaron la carga.

**Archivos:** las vistas se incorporan a `sql/06_vistas.sql`; `sql/07_seguridad.sql` reúne el procedimiento, el permiso SELECT y las instrucciones para las pruebas manuales. La creación inicial del usuario requiere definir una contraseña privada en Workbench, fuera del código. La secuencia completa todavía no ha sido probada desde un servidor sin cuentas ni esquemas.

**Conclusión:** se verificaron controles de acceso según el principio de mínimo privilegio, exposición acotada de datos mediante vistas, consulta parametrizada y dos restricciones de integridad. No se afirma que esto constituya una auditoría integral de seguridad.

## 9. Concurrencia y transacciones — Etapa 5

Se utilizaron dos conexiones independientes de Workbench (IDs 42 y 44) para simular un deadlock real. A actualizó el producto 1 y B el 903 en transacciones separadas; al solicitar ambas los registros bloqueados por la otra se obtuvo **ERROR 1213** en B. En A se observó por separado **ERROR 2013**, pérdida de conexión durante la espera; no es el error de deadlock. Tras los ROLLBACK se comprobaron los stocks originales (ID 1 = 20, ID 903 = 14).

La comparación de aislamiento se realizó con las sesiones IDs 49 y 51. Bajo REPEATABLE READ, A observó stock 20 antes y después del COMMIT de B, que lo elevó a 21. En READ COMMITTED, A observó primero 21 y luego 22 tras un nuevo COMMIT de B. Después se restauró el producto 1 a 20.

Se creó sp_descontar_stock_retry: utiliza START TRANSACTION, COMMIT, un handler SQLEXCEPTION con GET STACKED DIAGNOSTICS, ROLLBACK y hasta dos reintentos con pausas de 0,2 y 0,4 segundos para 1213 o SQLSTATE 40001. Los errores se muestran como resultados SQL, sin guardar una bitácora persistente. Se probó un descuento válido en el producto 903 (stock 14 a 13), un descuento imposible de 9999 unidades (error final 1644, sin modificar el stock) y la restauración del stock a 14.

Se ensayó el reintento mediante una **simulación controlada** de error 1213/40001 en una variante temporal: intento 1 devolvió ROLLBACK y 1213/40001; intento 2 devolvió COMMIT. Se restauró el stock y se reinstaló la versión definitiva sin código de simulación. SHOW PROCEDURE STATUS confirmó su existencia.

**Conclusiones de concurrencia (8 líneas):**
1. Bloquear dos productos en orden opuesto generó un deadlock real.
2. El error 1213 permitió identificar el deadlock, a diferencia del error de conexión 2013.
3. ROLLBACK evitó conservar cambios transitorios de las operaciones de prueba.
4. REPEATABLE READ mantuvo la versión de los datos observada al comienzo de la lectura consistente.
5. READ COMMITTED reflejó un COMMIT posterior de la otra sesión.
6. El procedimiento descontó stock válido y rechazó una cantidad insuficiente.
7. La simulación de 1213 confirmó la lógica de retry en el segundo intento.
8. Las modificaciones por ID usan la PK; no se midió una comparación con índices desactivados en concurrencia.

**Scripts:** sql/08_transacciones.sql y sql/09_concurrencia_guiada.sql.

## 10. Pendientes de entrega

La entrega requiere una revisión integral de reproducibilidad, completar el script de creación del usuario de seguridad sin exponer contraseñas, incorporar el DER, PDF técnico, anexo de conversaciones reales, ZIP y video.

## 11. Entrega

La entrega se organizará en un **PDF único**, un **ZIP con los scripts SQL ordenados e idempotentes** y un **video de 10 a 15 minutos**. La evidencia de uso de IA se recopilará como anexo textual completo por etapa, tal como solicita la consigna, fuera del código del repositorio.

**Fecha límite actualizada por el estudiante:** 07/11/2026.
