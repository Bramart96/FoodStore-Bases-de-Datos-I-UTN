-- Food Store | TFI de Bases de Datos I - UTN
-- Esquema relacional: categoria (1) -> (N) producto
-- Servidor de desarrollo: MySQL 8.0.46.
-- Estructuras y restricciones contrastadas con Workbench.
-- Script de instalacion: recrea tablas; BORRA datos previos del esquema.
-- No ejecutar sobre la base en uso; probado en copia aislada.

CREATE DATABASE IF NOT EXISTS foodstore_bdi
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;

USE foodstore_bdi;

-- Retirar objetos dependientes antes de recrear el esquema.
DROP VIEW IF EXISTS vista_catalogo_publico;
DROP VIEW IF EXISTS vista_inventario_interno;
DROP VIEW IF EXISTS vista_resumen_categorias;
DROP PROCEDURE IF EXISTS sp_buscar_producto_seguro;
DROP PROCEDURE IF EXISTS sp_descontar_stock_retry;
DROP TABLE IF EXISTS producto;
DROP TABLE IF EXISTS categoria;

CREATE TABLE categoria (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255) NULL,
    eliminado BOOLEAN NOT NULL DEFAULT FALSE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    nombre_activo VARCHAR(100)
        GENERATED ALWAYS AS (
            CASE WHEN eliminado = 0 THEN nombre ELSE NULL END
        ) STORED,

    CONSTRAINT pk_categoria PRIMARY KEY (id),
    CONSTRAINT uq_categoria_nombre_activo UNIQUE (nombre_activo),
    CONSTRAINT chk_categoria_nombre
        CHECK (CHAR_LENGTH(TRIM(nombre)) > 0),
    CONSTRAINT chk_categoria_eliminado
        CHECK (eliminado IN (0, 1))
) ENGINE = InnoDB;

CREATE TABLE producto (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(120) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    descripcion VARCHAR(255) NULL,
    stock INT NOT NULL DEFAULT 0,
    imagen VARCHAR(255) NULL,
    disponible BOOLEAN NOT NULL DEFAULT TRUE,
    eliminado BOOLEAN NOT NULL DEFAULT FALSE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    categoria_id INT UNSIGNED NOT NULL,

    CONSTRAINT pk_producto PRIMARY KEY (id),
    CONSTRAINT fk_producto_categoria
        FOREIGN KEY (categoria_id)
        REFERENCES categoria(id)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT,

    CONSTRAINT chk_producto_nombre
        CHECK (CHAR_LENGTH(TRIM(nombre)) > 0),
    CONSTRAINT chk_producto_precio
        CHECK (precio >= 0),
    CONSTRAINT chk_producto_stock
        CHECK (stock >= 0),
    CONSTRAINT chk_producto_disponible
        CHECK (disponible IN (0, 1)),
    CONSTRAINT chk_producto_eliminado
        CHECK (eliminado IN (0, 1))
) ENGINE = InnoDB;

-- Verificación de definiciones (no altera los registros):
SHOW CREATE TABLE categoria;
SHOW CREATE TABLE producto;

-- El script permite reconstruir el modelo desde cero.
-- La FK no controla si la categoría está activa: regla pendiente.
