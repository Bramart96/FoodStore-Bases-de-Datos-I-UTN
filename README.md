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
  07_seguridad.sql
  08_transacciones.sql
  09_concurrencia_guiada.sql
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
- Etapa 4 comprobada: dos vistas con columnas limitadas, procedimiento parametrizado, acceso mínimo y dos rechazos de integridad; contraseña del lector renovada y conexión verificada.
- Etapa 5 ejecutada: deadlock real 1213, comparacion de aislamiento, transacciones y reintentos ante error simulado; valores de stock restaurados.

## Ejecución

Ejecutar en orden `sql/01_esquema.sql`, `sql/02_catalogos.sql` y `sql/03_carga_masiva.sql` en MySQL Workbench. Luego, para reproducir el experimento de rendimiento, ejecutar `sql/05_explain.sql` tres veces, crear los índices mediante `sql/04_indices.sql` una sola vez y repetir las mediciones. `sql/05_consultas.sql` y `sql/06_vistas.sql` reúnen las consultas y las tres vistas verificadas. Para la Etapa 4, crear el usuario `fs_catalogo` desde Workbench con una contraseña propia y ejecutar `sql/07_seguridad.sql` desde la conexión administradora; los errores intencionales de permisos e integridad se prueban por separado. Nunca guardar la contraseña en scripts, capturas ni en GitHub. 

El esquema conserva datos existentes; los indices se crean una sola vez. La reconstrucción integral e idempotente se preparará para el ZIP final y todavía no está validada desde una base vacía.

## Concurrencia

`sql/08_transacciones.sql` instala el procedimiento definitivo y `sql/09_concurrencia_guiada.sql` presenta los pasos manuales de dos sesiones. Para completar la entrega faltan la prueba integral de reconstruccion, DER, PDF, anexo IA, ZIP y video. No se ha validado aun la ejecucion conjunta desde una base vacia.
