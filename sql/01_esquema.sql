-- Food Store | TFI de Bases de Datos I - UTN
-- Esquema relacional: categoria (1) -> (N) producto
-- Servidor de desarrollo: MySQL 8.0.46.
-- Estructuras y restricciones contrastadas con Workbench.
-- Este script conserva tablas existentes; no reconstruye datos.

CREATE DATABASE IF NOT EXISTS foodstore_bdi
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;

USE foodstore_bdi;

CREATE TABLE IF NOT EXISTS categoria (
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

CREATE TABLE IF NOT EXISTS producto (
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

-- Nota: IF NOT EXISTS evita volver a crear las tablas, pero no actualiza
-- una estructura distinta ya existente. Antes de la entrega se preparará
-- el orden de reconstrucción con DROP IF EXISTS según la consigna,
-- solo para un entorno de prueba y conservando copias necesarias.
-- La FK no controla si la categoría está activa: regla pendiente.
