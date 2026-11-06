

-- 0. CREACIÓN DE LA BASE DE DATOS Y TABLAS BASE
CREATE DATABASE IF NOT EXISTS tienda_informatica;
USE tienda_informatica;

-- Tabla para la Tarea 3 (vistas y enmascaramiento)
CREATE TABLE IF NOT EXISTS tecnicos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    especialidad VARCHAR(50),
    salario DECIMAL(10,2)
);

-- Tabla para la Tarea 4 (restricción de dominio)
CREATE TABLE IF NOT EXISTS articulos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    precio DECIMAL(10,2)
);


-- ============================================================================
-- TAREA 1: CREACIÓN DE USUARIOS Y POLÍTICAS DE CONEXIÓN Y CADUCIDAD
-- ============================================================================

-- 1. Creación de cuentas base
CREATE USER 'gestor_tienda'@'localhost' IDENTIFIED BY 'Gestor2026@Seguro';
CREATE USER 'auditor_externo'@'%' IDENTIFIED BY 'Auditor2026@Seguro';

-- 2. Directiva de caducidad de credenciales (Cada 30 días)
ALTER USER 'auditor_externo'@'%' PASSWORD EXPIRE INTERVAL 30 DAY;

-- 3. Directiva de control de sesión
ALTER USER 'gestor_tienda'@'localhost' WITH MAX_USER_CONNECTIONS 10;
SET GLOBAL wait_timeout = 3600;


-- ============================================================================
-- TAREA 2: CREACIÓN Y ASIGNACIÓN DE ROLES
-- ============================================================================

-- 1. Definición de rol operativo
CREATE ROLE 'rol_consultor';

-- 2. Concesión de privilegios de solo lectura sobre toda la base de datos
GRANT SELECT ON tienda_informatica.* TO 'rol_consultor';

-- 3. Asignación y rol por defecto para el auditor_externo
GRANT 'rol_consultor' TO 'auditor_externo'@'%';
SET DEFAULT ROLE 'rol_consultor' TO 'auditor_externo'@'%';


-- ============================================================================
-- TAREA 3: SEGURIDAD MEDIANTE VISTAS Y PRIVILEGIOS GRANULARES
-- ============================================================================

-- 1. Creación de la vista de enmascaramiento (Oculta salarios)
CREATE OR REPLACE VIEW v_tecnicos_activos AS
SELECT id, nombre, especialidad
FROM tecnicos;

-- 2. Privilegio granular (Acceso exclusivo a la vista)
GRANT SELECT ON tienda_informatica.v_tecnicos_activos TO 'gestor_tienda'@'localhost';

-- 3. Prueba de denegación (Genera Error 1142 si se ejecuta con gestor_tienda):
-- SELECT * FROM tienda_informatica.tecnicos;


-- ============================================================================
-- TAREA 4: CONSISTENCIA Y CONTROL CON WITH CHECK OPTION
-- ============================================================================

-- 1. Vista con restricción de dominio (Solo artículos <= 50.00 €)
CREATE OR REPLACE VIEW v_articulos_gama_baja AS
SELECT id, nombre, precio
FROM articulos
WHERE precio <= 50.00
WITH CHECK OPTION;

-- 2. Demostración técnica (Genera Error 1369 esperado):
INSERT INTO v_articulos_gama_baja (nombre, precio) 
VALUES ('Teclado Mecánico RGB', 75.00);