# Food Store — Bases de Datos I

Trabajo Final Integrador de Bases de Datos I de la Tecnicatura Universitaria en Programación (UTN).

## Descripción

Diseño e implementación de una base de datos relacional para Food Store, un sistema de gestión de pedidos de comida. Este proyecto utiliza el mismo dominio de negocio que el TFI de Programación II, pero se desarrolla y entrega de forma independiente.

## Tecnologías

- MySQL Server 8.0.46
- MySQL Workbench
- SQL

## Modelo inicial

El esquema `foodstore_bdi` parte de dos entidades:

- **categoria:** clasificación de productos y baja lógica.
- **producto:** artículos, precios, existencias, disponibilidad y categoría asociada.

La relación es de una categoría a muchos productos. Las decisiones sobre restricciones y reglas de negocio se detallan en `docs/informe_tecnico.md`.

## Contenido

```text
sql/
  01_esquema.sql
  02_catalogos.sql
  03_carga_masiva.sql
  04_indices.sql
  05_consultas.sql
  05_explain.sql
  06_vistas.sql
docs/
  informe_tecnico.md
README.md
.gitignore
```

Los scripts y demás archivos se incorporan a medida que se implementan y prueban las etapas del trabajo.

## Avance

- Base de datos `foodstore_bdi` creada y verificada.
- Tablas `categoria` y `producto` creadas; PK, FK, UNIQUE y CHECK verificadas en Workbench.
- Pruebas de integridad de ambas tablas realizadas, con registro de resultados en el informe.
- DER generado y guardado localmente; incorporación de los archivos exportados al repositorio pendiente.
- Carga masiva realizada: 100 categorías y 9.900 productos; 5 controles de consistencia comprobados.
- Etapa 3 comprobada: cuatro consultas, una vista, cuatro índices y tres comparaciones de rendimiento con tres mediciones por condición.
- Seguridad y concurrencia pendientes.

## Ejecución

Ejecutar en orden `sql/01_esquema.sql`, `sql/02_catalogos.sql` y `sql/03_carga_masiva.sql` en MySQL Workbench. Luego, para reproducir el experimento de rendimiento, ejecutar `sql/05_explain.sql` tres veces, crear los índices mediante `sql/04_indices.sql` una sola vez y repetir las mediciones. `sql/05_consultas.sql` y `sql/06_vistas.sql` reúnen las consultas y la vista verificadas. 

El esquema conserva datos existentes; los indices se crean una sola vez. La reconstrucción integral e idempotente se preparará para el ZIP final y todavía no está validada desde una base vacía.
