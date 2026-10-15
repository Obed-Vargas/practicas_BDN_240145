/* ============================================================
   CREACIÓN DE USUARIOS REMOTOS
   ============================================================ */

CREATE USER IF NOT EXISTS 'marco.ramirez'@'%'
IDENTIFIED BY 'qwerty123';

CREATE USER IF NOT EXISTS 'obed.vargas'@'%' 
IDENTIFIED BY '240145';

CREATE USER IF NOT EXISTS 'osmar.ortega'@'%'
IDENTIFIED BY '240036';

CREATE USER IF NOT EXISTS 'yaneth.garrido'@'%'
IDENTIFIED BY '240629';

CREATE USER IF NOT EXISTS 'jorge.eloy'@'%'
IDENTIFIED BY '240456';


/* ============================================================
   CONFIGURACIÓN GLOBAL Y PRIVILEGIOS DIRECTOS
   ============================================================ */

/* Permitir la carga de archivos locales desde el servidor */
SET GLOBAL local_infile = 1;

/* Asignación de privilegio administrador directo */
GRANT ALL PRIVILEGES ON *.*
TO 'obed.vargas'@'%';

/* Asignar privilegios directos a la base de datos completa */
GRANT SELECT, INSERT, UPDATE, DELETE
ON db_test_7b.*
TO 'yaneth.garrido'@'%';

/* Asignar privilegios a un usuario sin rol, esto no es una buena práctica,
pero es bueno saber que se puede realizar y no está obligatoriamente ligado con el rol */
GRANT SELECT, INSERT, UPDATE, DELETE
ON db_test_7b.tb_users
TO 'jorge.eloy'@'%';

/* Permisos globales FILE (necesarios para LOAD DATA INFILE) */
GRANT FILE ON *.* TO 'marco.ramirez'@'%';
GRANT FILE ON *.* TO 'osmar.ortega'@'%';
GRANT FILE ON *.* TO 'yaneth.garrido'@'%';
GRANT FILE ON *.* TO 'jorge.eloy'@'%';


/* ============================================================
   CREACIÓN DE ROLES PARA EL SISTEMA E-COMMERCE
   ============================================================ */

CREATE ROLE IF NOT EXISTS 'superadmin';
CREATE ROLE IF NOT EXISTS 'admin';
CREATE ROLE IF NOT EXISTS 'seller';
CREATE ROLE IF NOT EXISTS 'buyer';
CREATE ROLE IF NOT EXISTS 'support';
CREATE ROLE IF NOT EXISTS 'common';
CREATE ROLE IF NOT EXISTS 'user_not_registered';


/* ============================================================
   ASIGNACIÓN DE PRIVILEGIOS A LOS ROLES
   ============================================================ */

/* SUPERADMIN */
GRANT ALL PRIVILEGES
ON *.*
TO 'superadmin';

/* ADMIN */
GRANT ALL PRIVILEGES
ON db_test_7b.*
TO 'admin';

/* SUPPORT */
GRANT SELECT, INSERT, UPDATE
ON db_test_7b.tb_users
TO 'support';

GRANT SELECT, UPDATE
ON db_test_7b.tb_products
TO 'support';

GRANT SELECT, INSERT, UPDATE
ON db_test_7b.tbc_categories
TO 'support';

/* SELLER */
GRANT SELECT, INSERT, UPDATE, DELETE
ON db_test_7b.tb_products
TO 'seller';


/* ============================================================
   ASIGNACIÓN DE ROLES A LOS USUARIOS
   ============================================================ */

GRANT 'superadmin'
TO 'obed.vargas'@'%';

GRANT 'seller'
TO 'marco.ramirez'@'%';

GRANT 'admin'
TO 'marco.ramirez'@'%';

GRANT 'support'
TO 'yaneth.garrido'@'%';

GRANT 'seller'
TO 'osmar.ortega'@'%';


/* ============================================================
   ESTABLECER ROLES PREDETERMINADOS
   ============================================================ */

/*
Se usa ALL para que todos los roles asignados al usuario 
se activen automáticamente al iniciar sesión.
*/

SET DEFAULT ROLE ALL TO 'obed.vargas'@'%';
SET DEFAULT ROLE ALL TO 'marco.ramirez'@'%';
SET DEFAULT ROLE ALL TO 'yaneth.garrido'@'%';
SET DEFAULT ROLE ALL TO 'osmar.ortega'@'%';


/* ============================================================
   VERIFICACIÓN Y APLICACIÓN DE CAMBIOS
   ============================================================ */

FLUSH PRIVILEGES;

SELECT "Usuarios remotos y roles creados correctamente" AS mensaje;