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
- Carga masiva, reportes, seguridad y concurrencia pendientes.

## Ejecución

Abrir `sql/01_esquema.sql` en MySQL Workbench y ejecutarlo sobre la conexión local. El script contiene el esquema y las definiciones de `categoria` y `producto`. Revisar el resultado con `SHOW CREATE TABLE` antes de continuar.

El script utiliza `IF NOT EXISTS` para evitar volver a crear objetos existentes; no elimina datos previos. La estrategia de reconstrucción completa del esquema se definirá para la entrega final.
