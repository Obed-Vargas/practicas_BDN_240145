# Resumen ejecutivo — respaldo5.sql

El respaldo describe `db_test_7b` en MySQL 8.0.36/InnoDB. La organización incluye cuentas, productos y categorías, carritos y pedidos, métodos de pago y bitácora. Se encontraron **13 tablas con 92 columnas**, **17 claves foráneas**, **13 vistas**, **2 procedimientos** y **33 triggers**.

Usuarios se conectan con carritos, pedidos y métodos de pago; productos se vinculan con categorías y proveedores/usuarios; pedidos y carritos tienen tablas de detalle. Los triggers almacenan actividad en `tb_logs`. `sp_soft_delete_product` y `sp_restore_product` cambian el estado del producto sin borrar la fila.

Hay 10,036 filas insertadas directamente en tres tablas (`tb_logs`: 5,022; `tb_products`: 5,007; `tb_users`: 7). No se reproducen datos reales; los ejemplos del diccionario son ficticios.

**Límites relevantes:** no se documentan moneda ni varias reglas de negocio; el campo `password` no especifica cómo protege sus valores. Algunas FKs de los detalles apuntan separadamente a columnas no únicas de la asociación proveedor-producto y no validan el par conjunto. Las acciones de borrado/actualización no se especifican. Dos vistas dependen de `mysql.role_edges`, y objetos usan `DEFINER=root@localhost`, a verificar al restaurar.

- [Diccionario completo](./diccionario_datos_respaldo5.md)
- [Diccionario tabular CSV](./diccionario_datos_respaldo5.csv)
- [Diagrama Mermaid](./relaciones_respaldo5.mmd)
