/* Creacion de usuarios remotos */
CREATE USER IF NOT EXISTS 'marco.ramirez'@'%' IDENTIFIED BY '1234';
CREATE USER IF NOT EXISTS 'obed.vargas'@'%' IDENTIFIED BY '240145';
CREATE USER IF NOT EXISTS 'osmar.ortega'@'%' IDENTIFIED BY '240036';
CREATE USER IF NOT EXISTS 'yaneth.garrido'@'%' IDENTIFIED BY '240629';

/* Permitir la carga de archivos locales desde el servidor */
SET GLOBAL local_infile = 1;

/* Permisos globales FILE (necesarios para LOAD DATA INFILE) */
GRANT FILE ON *.* TO 'marco.ramirez'@'%';
GRANT FILE ON *.* TO 'osmar.ortega'@'%';
GRANT FILE ON *.* TO 'yaneth.garrido'@'%';

/* Asignar privilegios directos */
GRANT ALL PRIVILEGES ON *.* TO 'obed.vargas'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON db_test_7b.* TO 'yaneth.garrido'@'%';

/* CREACION DE ROLES PARA EL SISTEMA DE ECOMMERCE */
CREATE ROLE IF NOT EXISTS 'superadmin';
CREATE ROLE IF NOT EXISTS 'admin';
CREATE ROLE IF NOT EXISTS 'seller';
CREATE ROLE IF NOT EXISTS 'buyer';
CREATE ROLE IF NOT EXISTS 'support';
CREATE ROLE IF NOT EXISTS 'common';
CREATE ROLE IF NOT EXISTS 'user_not_registered';

/* ASIGNAR PRIVILEGIOS A LOS ROLES CREADOS */
GRANT ALL PRIVILEGES ON *.* TO 'superadmin';
GRANT ALL PRIVILEGES ON db_test_7b.* TO 'admin';

-- SUPPORT
GRANT SELECT, INSERT, UPDATE ON db_test_7b.tb_users TO 'support';
GRANT SELECT, INSERT, UPDATE ON db_test_7b.tb_products TO 'support';

-- SELLER
GRANT SELECT, INSERT, UPDATE, DELETE ON db_test_7b.tb_products TO 'seller';

/* ASIGNAR ROLES A LOS USUARIOS CREADOS */
GRANT 'superadmin' TO 'obed.vargas'@'%';

/* Marco Ramirez recibe rol de seller y admin */
GRANT 'seller' TO 'marco.ramirez'@'%';
GRANT 'admin' TO 'marco.ramirez'@'%';

GRANT 'support' TO 'yaneth.garrido'@'%';
GRANT 'seller' TO 'osmar.ortega'@'%';

/* ESTABLECER ROLES POR DEFECTO (USAR 'ALL' PARA QUE SE ACTIVEN TODOS LOS ROLES DEL USUARIO) */
SET DEFAULT ROLE ALL TO 'obed.vargas'@'%';
SET DEFAULT ROLE ALL TO 'marco.ramirez'@'%';
SET DEFAULT ROLE ALL TO 'yaneth.garrido'@'%';
SET DEFAULT ROLE ALL TO 'osmar.ortega'@'%';

/* Aplicar cambios */
FLUSH PRIVILEGES;

SELECT "Usuarios remotos y roles creados correctamente" AS mensaje;