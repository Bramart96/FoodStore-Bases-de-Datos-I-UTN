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
- Consultas de negocio, rendimiento, seguridad y concurrencia pendientes.

## Ejecución

Ejecutar en orden `sql/01_esquema.sql`, `sql/02_catalogos.sql` y `sql/03_carga_masiva.sql` en MySQL Workbench. El primero crea las tablas; los siguientes contienen los datos de prueba y cinco comprobaciones de consistencia. Los dos scripts de carga fueron organizados para reproducir los datos iniciales y las cargas ejecutadas; esta secuencia completa todavía no se ha validado desde una base vacía.

El script utiliza `IF NOT EXISTS` para evitar volver a crear objetos existentes; no elimina datos previos. La estrategia de reconstrucción completa del esquema se definirá para la entrega final.
