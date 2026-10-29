-- Food Store - TFI Bases de Datos I (UTN)
-- Esquema inicial para MySQL Server 8.0
-- Creación de categoria pendiente de validación práctica.
-- No elimina bases ni tablas existentes.

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

    -- Solo se controla el nombre cuando la categoria está activa.
    nombre_activo VARCHAR(100)
        GENERATED ALWAYS AS (
            CASE WHEN eliminado = 0 THEN nombre ELSE NULL END
        ) STORED,

    CONSTRAINT pk_categoria PRIMARY KEY (id),
    CONSTRAINT uq_categoria_nombre_activo UNIQUE (nombre_activo),
    CONSTRAINT chk_categoria_nombre CHECK (CHAR_LENGTH(TRIM(nombre)) > 0),
    CONSTRAINT chk_categoria_eliminado CHECK (eliminado IN (0, 1))
) ENGINE = InnoDB;

-- Revisar la estructura creada antes de insertar datos.
SHOW CREATE TABLE categoria;

-- La tabla producto y la FK se incorporarán tras aprobar su diseño.
