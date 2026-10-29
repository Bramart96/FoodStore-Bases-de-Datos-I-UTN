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

La presencia de la base y el resultado de la consulta fueron comprobados. Las tablas todavía no cuentan con pruebas de ejecución confirmadas.

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

**Estado:** SQL escrito en `sql/01_esquema.sql`, pendiente de ejecutar y verificar en Workbench.

### producto

Atributos de referencia: `id`, `nombre`, `precio`, `descripcion`, `stock`, `imagen`, `disponible`, `eliminado`, `created_at`, `categoria_id`.

Relación prevista: `producto.categoria_id` → `categoria.id` (1:N). La definición concreta de tipos, obligatoriedad, CHECK y comportamiento referencial está pendiente.

**Cuestiones a resolver:** la clave foránea valida la existencia de una categoría, pero no su estado activo. También falta decidir cómo impedir la baja lógica de categorías con productos activos.

## 5. Pruebas y evidencias

| Prueba | Resultado | Evidencia |
| --- | --- | --- |
| `SELECT VERSION()` | 8.0.46, comprobado | Captura del estudiante |
| Creación de `foodstore_bdi` | Esquema visible en Workbench | Captura del estudiante |
| `SHOW CREATE DATABASE foodstore_bdi` | utf8mb4 / utf8mb4_0900_ai_ci | Resultado textual aportado |
| `CREATE TABLE categoria` | Pendiente de ejecución | — |
| Validación de restricciones de `categoria` | Pendiente | — |

Las capturas y la portada proporcionada se incorporarán al PDF único de entrega. No se considerarán realizadas pruebas que no cuenten con resultados.

## 6. Próximas etapas

La consigna exige desarrollar además generación masiva con SQL puro; consultas JOIN, GROUP BY/HAVING y subconsultas; índices y mediciones con/sin índice; vistas y permisos; y pruebas de concurrencia, deadlock, aislamiento y transacciones.

Los scripts se incorporarán cuando el diseño y los resultados se comprueben en el entorno de trabajo.

## 7. Entrega

La entrega se organizará en un **PDF único**, un **ZIP con los scripts SQL ordenados e idempotentes** y un **video de 10 a 15 minutos**. La evidencia de uso de IA se recopilará como anexo textual completo por etapa, tal como solicita la consigna, fuera del código del repositorio.

**Fecha límite informada:** 09/11/2026.
