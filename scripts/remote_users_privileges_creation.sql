/* Creasion de usuarios remotos */
CREATE USER IF NOT EXISTS 'marco.ramirez'@'%' IDENTIFIED BY 'qwerty123';
CREATE USER IF NOT EXISTS 'obed.vargas'@'%' IDENTIFIED BY '240145';
CREATE USER IF NOT EXISTS 'osmar.ortega'@'%' IDENTIFIED BY '240036';
CREATE USER IF NOT EXISTS 'yaneth.garrido'@'%' IDENTIFIED BY '240629';

/* Asignar los privilegios de super usuario */
GRANT ALL PRIVILEGES ON *.* TO 'obed.vargas'@'%';

/* Asignar los privilegios de SELECCION, INCERSION, ACTUALIZACION Y ELIMINACION */
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
GRANT SELECT, INSERT, UPDATE 
ON db_test_7b.tb_users
TO 'support';

GRANT SELECT, INSERT, UPDATE 
ON db_test_7b.tb_products
TO 'support';

/*seller*/
GRANT SELECT, INSERT, UPDATE, DELETE 
ON db_test_7b.tb_products 
TO 'seller';

/* ASIGNAR ROLES A LOS USUARIOS CREADOS */

/*este soy yo*/
grant 'superadmin' TO 'obed.vargas'@'%';
/*este es el profe marco*/
GRANT 'admin' TO 'marco.ramirez'@'%';
/*este es el de la izquierda*/
GRANT 'support' TO 'yaneth.garrido'@'%';
/*este es el de la derecha*/
GRANT 'seller' TO 'osmar.ortega'@'%';


/* Aplicar cambios */
FLUSH PRIVILEGES;