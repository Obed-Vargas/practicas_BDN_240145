# Práctica 03 - Manipulación de Datos en Conexiones Remotas a Bases de Datos Relacionales

## Enlaces de git pages
diccionario de datos: https://obed-vargas.github.io/practicas_BDN_240145/Practicas03/ 

diagrama entidad-relacion: https://obed-vargas.github.io/practicas_BDN_240145/Practicas03/relaciones-respaldo5.html

---

## Descripción General

En esta práctica se consolidó y expandió la arquitectura de la base de datos relacional **`db_test_7b`** alojada en un servidor remoto MySQL 8.0, simulando una plataforma integral de **Comercio Electrónico (E-Commerce)** a gran escala.

Se implementó un esquema relacional avanzado de **25 tablas**, un sistema integral de auditoría continua mediante **72 disparadores (triggers)** vinculados a una bitácora centralizada (`tb_logs`), **26 vistas de trazabilidad analítica**, procedimientos almacenados para simulación y manipulación demográfica de datos, importación de catálogos desde archivos CSV, asignación multi-categoría con más de 16,000 relaciones, y una población masiva que supera los **10,000 usuarios**, **7,000 productos** y decenas de miles de eventos auditados.

---

## Objetivos de la Práctica

- **Diseñar e implementar un esquema relacional complejo**: modelar cuentas, personas, direcciones, catálogos, productos, proveedores, listas de deseos, carritos de compra, pedidos, pagos, envíos, cancelaciones, devoluciones y reembolsos.
- **Implementar auditoría y trazabilidad total**: crear disparadores automáticos (`AFTER INSERT`, `AFTER UPDATE`, `AFTER DELETE`) en todas las tablas de negocio para registrar cada operación, autor, roles y detalle en `tb_logs`.
- **Desarrollar vistas especializadas de trazabilidad**: correlacionar la bitácora con los usuarios del motor y el grafo de roles (`mysql.role_edges`) para monitorear la autoría de cada cambio.
- **Manipulación y generación masiva de datos**:
  - Simular perfiles de usuarios realistas por regiones (`USA`, `MX`, `CA`, `BR`, `AR`) mediante procedimientos almacenados con control transaccional (`sp_generate_test_users`).
  - Completar el volumen de datos exigido mediante técnicas de generación SQL masiva (productos, usuarios, categorías y categorizaciones).
- **Normalización y categorización multi-nivel**: poblar el catálogo de categorías (`tbc_categories`) con jerarquías y relacionar productos a múltiples categorías (`tbd_products_categories`), superando el mínimo requerido de 13,000 categorizaciones.
- **Documentación técnica y diagramación formal**: generar diccionarios de datos estructurados (Markdown, CSV), diagramas Entidad-Relación interactivos (Mermaid, HTML) y respaldos SQL versionados hasta la entrega final (`Dump1111.sql`).

---

## Estructura de la Base de Datos (`db_test_7b`)

La base de datos final cuenta con **25 tablas** distribuidas funcionalmente:

### 1. Entidades de Usuarios y Perfiles
- **`tb_users`**: Cuentas principales de acceso con correo electrónico único, apodo (`nick`), contraseña cifrada (`SHA2`), marcas temporales y estado.
- **`tb_people`**: Datos demográficos y de personas físicas asociados en relación 1:1 con `tb_users` (título de cortesía, nombres, apellidos, fecha de nacimiento, género, código de país y teléfono).
- **`tb_user_addresses`**: Direcciones físicas registradas por los usuarios.
- **`tbd_address_components`**: Detalle y componentes normalizados de cada dirección (calle, número, código postal, referencias).

### 2. Catálogos y Productos
- **`tb_products`**: Inventario de artículos con código SKU único, nombre, descripción detallada, precio actual (`current_price`), stock disponible (`current_stock`), estado y fechas de registro.
- **`tbc_categories`**: Catálogo jerárquico de categorías comerciales con soporte para subcategorías (`sup_id_category`).
- **`tbd_products_categories`**: Tabla asociativa muchos a muchos (N:M) que vincula productos con sus categorías correspondientes (permite categorización múltiple).
- **`tbd_products_users_providers`**: Asociación de productos con usuarios que actúan como proveedores o vendedores (`Owner`, `Reseller`, `Distributor`).
- **`tbd_users_wishlist_products`**: Lista de deseos de productos guardados por los clientes.

### 3. Carritos y Pedidos
- **`tb_carts`**: Carrito de compras activo asignado a cada usuario.
- **`tbd_carts_items`**: Detalle de productos y cantidades agregadas al carrito de compras.
- **`tb_buyer_orders`**: Órdenes de compra generadas, costos de envío, subtotal y estado de cumplimiento (`Pending`, `Accepted`, `Preparing`, `Sent`, `Delivered`, `Canceled`, `Returned`).
- **`tbd_order_items`**: Desglose de partidas de cada orden (producto, proveedor, cantidad, precio unitario e importe total generado).

### 4. Pagos y Métodos de Pago
- **`tbc_payment_methods_types`**: Catálogo de tipos de método de pago (tarjeta de crédito, débito, transferencia, pasarelas digitales).
- **`tbd_user_payment_methods`**: Métodos de pago registrados y tokenizados de los usuarios.
- **`tb_payments`**: Registro maestro de transacciones de pago aplicadas a pedidos.
- **`tb_payment_methods`**: Método de pago específico aplicado al pedido.
- **`tb_payment_transactions`**: Historial y eventos de cada transacción bancaria (`Created`, `Authorized`, `Captured`, `Failed`, `Refunded`).

### 5. Envíos y Logística Posventa
- **`tb_shipments`**: Información logística, transportista, guía de rastreo y estado del envío.
- **`tb_cancellations`**: Solicitudes y dictámenes de cancelación de órdenes.
- **`tbd_cancellation_items`**: Artículos individuales sujetos a cancelación.
- **`tb_returns`**: Solicitudes de devolución de mercancía.
- **`tbd_return_items`**: Artículos específicos devueltos con condiciones y montos.
- **`tb_refunds`**: Reembolsos monetarios procesados derivados de cancelaciones o devoluciones.

### 6. Bitácora de Auditoría
- **`tb_logs`**: Tabla centralizada de bitácora que almacena ID, nombre de la tabla afectada, operación ejecutada (`Create`, `Read`, `Update`, `Delete`), usuario de base de datos que ejecutó la acción (`db_users`), fecha exacta (`operation_date`) y descripción detallada del evento con los datos anteriores y nuevos.

---

## Sistema de Auditoría (72 Triggers)

Para cumplir con la política estricta de auditoría y trazabilidad en tiempo real, se crearon **72 disparadores** (3 por cada una de las 24 tablas de negocio, exceptuando la propia `tb_logs`):

1. **`trg_<tabla>_after_insert`**: Captura cada inserción (`Create`), registrando el ID del registro creado, los valores insertados y el usuario conectado.
2. **`trg_<tabla>_after_update`**: Captura cada modificación (`Update`), registrando el ID del registro y comparando los valores antes y después de la operación.
3. **`trg_<tabla>_after_delete`**: Captura eliminaciones (`Delete`), preservando en la bitácora los valores de la fila eliminada para auditoría forense.

---

## Vistas Analíticas de Trazabilidad (26 Vistas)

Se implementaron **26 vistas de base de datos** para abstraer y consultar la bitácora de forma inmediata, cruzando cada evento con los roles activos de MySQL mediante `mysql.role_edges`:

- `vw_trazabilidad_usuarios`
- `vw_trazabilidad_people`
- `vw_trazabilidad_productos`
- `vw_trazabilidad_categories`
- `vw_trazabilidad_categorizaciones`
- `vw_trazabilidad_productos_categorias`
- `vw_trazabilidad_categorias_productos`
- `vw_trazabilidad_productos_proveedores`
- `vw_trazabilidad_buyer_orders`
- `vw_trazabilidad_order_items`
- `vw_trazabilidad_carts`
- `vw_trazabilidad_carts_items`
- `vw_trazabilidad_lista_deseos`
- `vw_trazabilidad_payments`
- `vw_trazabilidad_payment_methods`
- `vw_trazabilidad_payment_methods_types`
- `vw_trazabilidad_payment_transactions`
- `vw_trazabilidad_shipments`
- `vw_trazabilidad_user_addresses`
- `vw_trazabilidad_address_components`
- `vw_trazabilidad_user_payment_methods`
- `vw_trazabilidad_cancellations`
- `vw_trazabilidad_cancellation_items`
- `vw_trazabilidad_returns`
- `vw_trazabilidad_return_items`
- `vw_trazabilidad_refunds`

---

## Generación y Carga de Datos

### 1. Usuarios y Personas
- **Procedimiento `sp_generate_test_users`**:
  - Cuenta con escenarios parametrizables: `USA_500` (500 usuarios estadounidenses), `INTERNATIONAL_2000` (2,000 usuarios con distribución internacional en MX, CA, BR y AR) y `STATUS_5000` (5,000 usuarios con control estricto de proporción: 4,000 activos y 1,000 inactivos).
  - Incluye manejo de transacciones con `EXIT HANDLER FOR SQLEXCEPTION`, reversión automática (`ROLLBACK`), reintentos automáticos ante colisiones de claves únicas y generación de contraseñas seguras con `SHA2(..., 256)`.
- **Inserción Masiva DML**:
  - Se completó la meta de usuarios utilizando productos cartesianos y generadores de números en SQL puro, alcanzando **más de 22,500 usuarios** registrados en `tb_users` e integrados de forma íntegra con sus perfiles en `tb_people`.

### 2. Productos
- Se crearon productos con códigos SKU estructurados, precios aleatorios coherentes entre \$100.00 y \$15,000.00 MXN, niveles de stock variables y descripciones representativas.
- Con la última carga masiva se alcanzó la meta fijada por el docente de **7,007 productos** registrados en `tb_products`.

### 3. Categorías y Categorizaciones
- **Catálogo de Categorías**: Se importaron y configuraron 100 categorías comerciales de E-Commerce en `tbc_categories` con jerarquías principales y secundarias.
- **Categorización Multi-Categoría**: Se asignaron múltiples categorías por producto en `tbd_products_categories`, permitiendo que un mismo artículo se encuentre clasificado en dos o más ramas de venta simultáneamente. Con esto se superó ampliamente la meta docente de al menos 13,000, alcanzando **15,771 categorizaciones** según `Dump1111.sql`.

---

## Procedimientos Almacenados Creados

1. **`sp_generate_test_users(p_scenario)`**: Generación paramétrica y transaccional de usuarios y perfiles por escenarios geográficos.
2. **`sp_soft_delete_product(p_product_id)`**: Realiza la baja lógica de un producto (`status = b'0'`) sin destruir la integridad referencial de pedidos y bitácoras pasadas.
3. **`sp_restore_product(p_product_id)`**: Restaura y activa nuevamente un producto dado de baja lógica (`status = b'1'`).

---

## Consultas de Verificación y Control (`consultas_verificacion.sql`)

El archivo contiene 14 consultas maestras para validar el funcionamiento integral del sistema:
1. Conteo e inspección de tablas existentes en `db_test_7b`.
2. Conteo de disparadores (triggers) activos en el esquema.
3. Conteo de registros totales en `tb_users`.
4. Conteo de eventos registrados en la bitácora `tb_logs`.
5. Inspección completa y filtrado de operaciones en `tb_logs`.
6. Verificación de usuarios remotos activos en el servidor MySQL (`mysql.user`).
7. Verificación de roles creados en el motor de base de datos.
8. Consulta de asignaciones usuario-rol mediante `mysql.role_edges`.
9. Verificación de procedimientos almacenados en la base de datos.
10. Conteo e inspección del catálogo de productos `tb_products`.
11. Verificación de trazabilidad detallada de productos y sus roles asociados.
12. Consulta de la vista `vw_trazabilidad_productos`.
13. Consulta de la vista `vw_trazabilidad_usuarios`.
14. Agrupación y métricas de inserciones de productos por usuario de base de datos.

---

## Respaldos y Entregables en la Carpeta

```text
Practicas03/
├── backups/
│   ├── Dump1111.sql                         # Respaldo final completo (25 tablas, 72 triggers, 26 vistas, datos)
│   ├── Dump511.sql                          # Respaldo de etapa intermedia con volumen de datos parcial
│   ├── Dump20261022.sql                     # Respaldo histórico de avance
│   ├── Dump20261006.sql                     # Respaldo inicial
│   ├── respaldo.sql                         # Copia base
│   ├── respaldo3.sql                        # Respaldo incremental 3
│   ├── respaldo4.sql                        # Respaldo incremental 4
│   └── respaldo5.sql                        # Respaldo incremental 5 (base del diccionario de datos)
├── queries/
│   └── consultas_verificacion.sql           # 14 consultas maestras de validación y auditoría
├── scripts/
│   ├── remote_users_privileges_creation.sql # Configuración de usuarios remotos, roles y privilegios
│   └── sp_generate_test_users.sql           # Procedimiento para generación demográfica de usuarios
├── seeds/
│   └── categorias_ecommerce_100 (1).csv     # Catálogo de categorías en formato CSV
├── diccionario_datos_respaldo5.csv          # Diccionario de datos en formato tabular CSV
├── diccionario_datos_respaldo5.md           # Diccionario de datos exhaustivo en formato Markdown
├── relaciones_respaldo5.mmd                 # Diagrama Entidad-Relación en sintaxis Mermaid
├── relaciones-respaldo5.html                # Visualizador web del diagrama ER con conteos por tabla
├── resumen_respaldo5.md                     # Resumen ejecutivo de la base de datos
├── index.html                               # Portal de visualización del diccionario y relaciones
└── readme.md                                # Documentación general de la Práctica 03
```

---

## Resultados Obtenidos Frente a Requisitos

| Requisito Solicitado | Valor Solicitado | Valor Obtenido | Estatus |
|---|---|---|---|
| **Tablas en la BD** | 25 tablas | **25 tablas** | 🟢 Cumplido |
| **Triggers de Auditoría** | 72 triggers (3 por tabla) | **72 triggers** | 🟢 Cumplido |
| **Vistas de Trazabilidad** | 25 vistas | **26 vistas** | 🟢 Cumplido |
| **Total de Usuarios (`tb_users`)** | ~10,000 usuarios | **22,510 usuarios** | 🟢 Cumplido |
| **Total de Personas (`tb_people`)** | ~10,000 personas | **22,503 personas** | 🟢 Cumplido |
| **Total de Productos (`tb_products`)** | ~7,000 productos | **7,007 productos** | 🟢 Cumplido |
| **Catálogo de Categorías (`tbc_categories`)** | Catálogo definido | **100 categorías** | 🟢 Cumplido |
| **Categorizaciones (`tbd_products_categories`)** | Al menos 13,000 | **15,771 categorizaciones** | 🟢 Cumplido |
| **Diccionario y Diagrama ER** | Documentación completa | **Markdown, CSV, Mermaid, HTML** | 🟢 Cumplido |
| **Respaldo Final Completo** | Respaldo SQL | **`Dump1111.sql` (27.6 MB)** | 🟢 Cumplido |

---

## Estatus de la Práctica

🟢 **Completada y Verificada**
