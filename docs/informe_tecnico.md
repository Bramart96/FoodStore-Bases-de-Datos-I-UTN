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

## 7. Próximas etapas


La consigna exige desarrollar además generación masiva con SQL puro; consultas JOIN, GROUP BY/HAVING y subconsultas; índices y mediciones con/sin índice; vistas y permisos; y pruebas de concurrencia, deadlock, aislamiento y transacciones.

Los scripts se incorporarán cuando el diseño y los resultados se comprueben en el entorno de trabajo.

## 8. Entrega

La entrega se organizará en un **PDF único**, un **ZIP con los scripts SQL ordenados e idempotentes** y un **video de 10 a 15 minutos**. La evidencia de uso de IA se recopilará como anexo textual completo por etapa, tal como solicita la consigna, fuera del código del repositorio.

**Fecha límite actualizada por el estudiante:** 07/11/2026.
