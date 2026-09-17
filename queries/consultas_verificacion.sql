USE db_test_7b;

/*1. Cuantas tablas existen en la base de datos db_test_7b?*/
SHOW TABLES;
/*2. Cuantos triggers existen en la base de datos db_test_7b?*/
SHOW TRIGGERS FROM db_test_7b;

/*3. Cuantos registros existen en la tabla users?*/
SELECT COUNT(*) AS total_registros FROM tb_users;

/*4. Cuantos registros existen en la tabla bitacora?*/
SELECT COUNT(*) AS total_registros FROM tb_logs;

/*5. Consultar todas las operaciones realizadas en la base de datos*/
SELECT * FROM tb_logs;

/*6. Verificar que los usuarios remotoss hayan sido creados*/
SELECT user, host from mysql.user where host='%' AND account_locked = 'N';

/*7. Verificar los roles que fueron creados*/
SELECT user, host from mysql.user where host='%' AND account_locked = 'Y';

/* 8. Verificar que usuarios tienen que roles */
SELECT TO_USER AS usuario, TO_HOST AS host, FROM_USER AS rol, FROM_HOST AS rol_host
FROM mysql.role_edges ORDER BY TO_USER, FROM_USER;

--9. verificar el total de los procedimientos almacenados que esten en la base de datos db_test_7b
SHOW PROCEDURE STATUS WHERE Db = 'db_test_7b';

