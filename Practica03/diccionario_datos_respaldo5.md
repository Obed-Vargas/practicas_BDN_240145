# Diccionario de datos — `respaldo5.sql`

> Fuente: [`backups/respaldo5.sql`](./backups/respaldo5.sql), 1,986 líneas y 2,826,026 bytes. Se leyó hasta el marcador de fin. No se modificó el SQL original. No se copian valores reales insertados; ejemplos ficticios.

## Resumen general

| Elemento | Total o valor |
|---|---:|
| Base de datos | `db_test_7b` |
| Motor | MySQL 8.0.36; InnoDB |
| Juego de caracteres / collation | utf8mb4 / utf8mb4_0900_ai_ci |
| Tablas / columnas | 13 / 92 |
| Claves primarias / foráneas | 13 / 17 |
| Índices (PK y UNIQUE incluidos) | 32 |
| UNIQUE / CHECK | 7 / 5 |
| Vistas / procedimientos / triggers | 13 / 2 / 33 |
| Funciones / eventos | 0 / 0 |
| INSERT de datos / filas cargadas | 5 / 10,036 |

El dump contiene estructura, datos y objetos programables. Las secciones iniciales de vistas son stubs de columnas emitidos por mysqldump; más adelante aparecen definiciones finales, que son las documentadas. No hay comentarios SQL en columnas físicas. El significado de varios campos se infiere por sus nombres y relaciones, no por comentarios funcionales.

### Índice de tablas

| Tabla | Columnas | Descripción (confirmada/inferida) |
|---|---:|---|
| `tb_buyer_orders` | 8 | Cabecera de pedido con usuario relacionado, importes, estado de preparación y fechas. El nombre dice buyer, pero seller_ID referencia tb_users; confirmar rol funcional. *(propósito inferido a partir del nombre/estructura)* |
| `tb_carts` | 5 | Carrito asociado a una cuenta; UNIQUE(user_ID) permite como máximo un carrito por usuario. *(propósito inferido a partir del nombre/estructura)* |
| `tb_logs` | 7 | Datos de operación, usuario SQL, fecha y descripción. Triggers registran aquí cambios de varias tablas. *(propósito inferido a partir del nombre/estructura)* |
| `tb_products` | 9 | Catálogo con SKU, nombre, descripción, precio, existencias, estado y fechas. *(propósito inferido a partir del nombre/estructura)* |
| `tb_users` | 8 | Correo, apodo, valor de contraseña almacenado, fechas y estado. No se documenta el algoritmo de protección de password. *(propósito inferido a partir del nombre/estructura)* |
| `tbc_categories` | 7 | Catálogo jerárquico; sup_id_category enlaza opcionalmente otra categoría. *(propósito inferido a partir del nombre/estructura)* |
| `tbc_payment_methods_types` | 6 | Catálogo con código único, descripción y estado. *(propósito inferido a partir del nombre/estructura)* |
| `tbd_carts_items` | 5 | Detalle asociado a carrito, proveedor y producto; PK compuesta por esos tres identificadores. *(propósito inferido a partir del nombre/estructura)* |
| `tbd_order_items` | 9 | Detalle de pedido con producto, proveedor, cantidad, precio y subtotal generado. *(propósito inferido a partir del nombre/estructura)* |
| `tbd_products_categories` | 5 | Asociación de productos con categorías, estado y fechas. *(propósito inferido a partir del nombre/estructura)* |
| `tbd_products_users_providers` | 7 | Asociación de usuarios y productos con tipo de participación, estado y fechas. *(propósito inferido a partir del nombre/estructura)* |
| `tbd_user_payment_methods` | 11 | Método de pago asociado a usuario y tipo, con una referencia externa; no define datos completos de tarjeta. *(propósito inferido a partir del nombre/estructura)* |
| `tbd_users_wishlist_products` | 5 | Asociación entre usuario y producto guardado, estado y fechas. *(propósito inferido a partir del nombre/estructura)* |

## Diccionario por tabla

En cada ficha, nulabilidad y obligatoriedad describen solo el DDL. Las notas funcionales no confirmadas se señalan como inferencias.

## Tabla `tb_buyer_orders`

**Descripción sencilla:** Cabecera de pedido con usuario relacionado, importes, estado de preparación y fechas. El nombre dice buyer, pero seller_ID referencia tb_users; confirmar rol funcional.
**Ejemplo cotidiano:** Pedidos de venta se puede imaginar como una sección de un archivador con fichas; las tablas de asociación son como etiquetas que conectan dos fichas.
**Qué representa una fila:** Pedido individual.
**Cantidad de columnas:** 8
**Identificador principal:** `ID`.
**Relaciones declaradas:** `seller_ID` → `tb_users.ID`
**Observaciones:** definición SQL en líneas 27–41.

### Resumen de columnas

| Campo técnico | Significado | Tipo SQL y composición | ¿Puede quedar vacío? | Ejemplo ficticio | Restricciones y relaciones |
|---|---|---|---|---|---|
| `ID` | Identificador técnico del pedido. | `int unsigned` — Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED). | No | `42` | PK; AUTO_INCREMENT |
| `seller_ID` | Usuario asociado al pedido; el rol de vendedor se infiere del nombre. | `int unsigned` — Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED). | No | `42` | FK `tb_buyer_orders_ibfk_1` → `tb_users.ID` |
| `subtotal` | Importe parcial del pedido; moneda y fórmula no especificadas. | `decimal(12,2)` — DECIMAL exacto con 12 dígitos totales (precisión) y 2 decimales (escala). | No | `125.50` | CHECK tb_buyer_orders_chk_1: (`subtotal` >= 0) |
| `shipping_cost` | Importe del envío; moneda no especificada. | `decimal(12,2)` — DECIMAL exacto con 12 dígitos totales (precisión) y 2 decimales (escala). | No | `125.50` | CHECK tb_buyer_orders_chk_2: (`shipping_cost` >= 0) |
| `fulfillment_status` | Etapa de preparación/entrega, limitada por ENUM. | `enum('Pending','Accepted','Preparing','Sent','Delivered','Canceled','Returned')` — Texto de una lista cerrada: Pending, Accepted, Preparing, Sent, Delivered, Canceled, Returned. | No | `Pending` | No especificado en el respaldo |
| `status` | Bandera de un bit; la semántica funcional no se define. | `bit(1)` — Un bit: b'0' o b'1'. | No | `b'1'` | No especificado en el respaldo |
| `creation_date` | Momento de creación de la cabecera. | `datetime` — Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS. | No | `2026-01-15 09:30:00` | No especificado en el respaldo |
| `last_update` | Momento de última modificación; MySQL lo actualiza automáticamente. | `datetime` — Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS. | Sí | `2026-01-15 09:30:00` | ON UPDATE CURRENT_TIMESTAMP |

### Fichas individuales

#### `ID` — Identificador

- **Nombre técnico:** `ID`
- **Nombre comprensible:** Identificador
- **Significado:** Identificador técnico del pedido.
- **Uso funcional:** Identificador técnico del pedido.
- **Tipo de dato SQL:** `int unsigned`; definición completa: `int unsigned NOT NULL AUTO_INCREMENT`.
- **Composición del tipo:** Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED).
- **Formato esperado:** Número entero no negativo.
- **Ejemplo ilustrativo ficticio:** `42`
- **Permite valores nulos:** No.
- **Es obligatorio:** Se genera automáticamente; no se proporciona como entrada.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** Sí.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** Parte de la PRIMARY KEY. AUTO_INCREMENT.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `seller_ID` — ID del usuario vendedor

- **Nombre técnico:** `seller_ID`
- **Nombre comprensible:** ID del usuario vendedor
- **Significado:** Usuario asociado al pedido; el rol de vendedor se infiere del nombre.
- **Uso funcional:** Usuario asociado al pedido; el rol de vendedor se infiere del nombre.
- **Tipo de dato SQL:** `int unsigned`; definición completa: `int unsigned NOT NULL`.
- **Composición del tipo:** Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED).
- **Formato esperado:** Número entero no negativo.
- **Ejemplo ilustrativo ficticio:** `42`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** No.
- **Clave foránea:** Sí: `tb_buyer_orders_ibfk_1` → `tb_users.ID`
- **Restricciones:** FK `tb_buyer_orders_ibfk_1` → `tb_users.ID`.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** `tb_buyer_orders_ibfk_1` → `tb_users.ID`
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `subtotal` — Subtotal

- **Nombre técnico:** `subtotal`
- **Nombre comprensible:** Subtotal
- **Significado:** Importe parcial del pedido; moneda y fórmula no especificadas.
- **Uso funcional:** Importe parcial del pedido; moneda y fórmula no especificadas.
- **Tipo de dato SQL:** `decimal(12,2)`; definición completa: `decimal(12,2) NOT NULL DEFAULT '0.00'`.
- **Composición del tipo:** DECIMAL exacto con 12 dígitos totales (precisión) y 2 decimales (escala).
- **Formato esperado:** Decimal con la precisión/escala definidas.
- **Ejemplo ilustrativo ficticio:** `125.50`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** `'0.00'`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** CHECK `tb_buyer_orders_chk_1`: `(`subtotal` >= 0)`.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `shipping_cost` — Shipping cost

- **Nombre técnico:** `shipping_cost`
- **Nombre comprensible:** Shipping cost
- **Significado:** Importe del envío; moneda no especificada.
- **Uso funcional:** Importe del envío; moneda no especificada.
- **Tipo de dato SQL:** `decimal(12,2)`; definición completa: `decimal(12,2) NOT NULL DEFAULT '0.00'`.
- **Composición del tipo:** DECIMAL exacto con 12 dígitos totales (precisión) y 2 decimales (escala).
- **Formato esperado:** Decimal con la precisión/escala definidas.
- **Ejemplo ilustrativo ficticio:** `125.50`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** `'0.00'`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** CHECK `tb_buyer_orders_chk_2`: `(`shipping_cost` >= 0)`.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `fulfillment_status` — Estado de preparación

- **Nombre técnico:** `fulfillment_status`
- **Nombre comprensible:** Estado de preparación
- **Significado:** Etapa de preparación/entrega, limitada por ENUM.
- **Uso funcional:** Etapa de preparación/entrega, limitada por ENUM.
- **Tipo de dato SQL:** `enum('Pending','Accepted','Preparing','Sent','Delivered','Canceled','Returned')`; definición completa: `enum('Pending','Accepted','Preparing','Sent','Delivered','Canceled','Returned') NOT NULL DEFAULT 'Pending'`.
- **Composición del tipo:** Texto de una lista cerrada: Pending, Accepted, Preparing, Sent, Delivered, Canceled, Returned.
- **Formato esperado:** Uno de los valores ENUM declarados.
- **Ejemplo ilustrativo ficticio:** `Pending`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** `'Pending'`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** Pending, Accepted, Preparing, Sent, Delivered, Canceled, Returned
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `status` — Status

- **Nombre técnico:** `status`
- **Nombre comprensible:** Status
- **Significado:** Bandera de un bit; la semántica funcional no se define.
- **Uso funcional:** Bandera de un bit; la semántica funcional no se define.
- **Tipo de dato SQL:** `bit(1)`; definición completa: `bit(1) NOT NULL DEFAULT b'1'`.
- **Composición del tipo:** Un bit: b'0' o b'1'.
- **Formato esperado:** Valor binario del ancho declarado.
- **Ejemplo ilustrativo ficticio:** `b'1'`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** `b'1'`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** b'0', b'1' por BIT(1); significado según el campo no siempre especificado.
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `creation_date` — Fecha de creación

- **Nombre técnico:** `creation_date`
- **Nombre comprensible:** Fecha de creación
- **Significado:** Momento de creación de la cabecera.
- **Uso funcional:** Momento de creación de la cabecera.
- **Tipo de dato SQL:** `datetime`; definición completa: `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP`.
- **Composición del tipo:** Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS.
- **Formato esperado:** AAAA-MM-DD HH:MM:SS; sin zona horaria.
- **Ejemplo ilustrativo ficticio:** `2026-01-15 09:30:00`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** `CURRENT_TIMESTAMP`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `last_update` — Última actualización

- **Nombre técnico:** `last_update`
- **Nombre comprensible:** Última actualización
- **Significado:** Momento de última modificación; MySQL lo actualiza automáticamente.
- **Uso funcional:** Momento de última modificación; MySQL lo actualiza automáticamente.
- **Tipo de dato SQL:** `datetime`; definición completa: `datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP`.
- **Composición del tipo:** Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS.
- **Formato esperado:** AAAA-MM-DD HH:MM:SS; sin zona horaria.
- **Ejemplo ilustrativo ficticio:** `2026-01-15 09:30:00`
- **Permite valores nulos:** Sí.
- **Es obligatorio:** No; admite NULL.
- **Valor predeterminado:** `NULL`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** ON UPDATE CURRENT_TIMESTAMP.


## Tabla `tb_carts`

**Descripción sencilla:** Carrito asociado a una cuenta; UNIQUE(user_ID) permite como máximo un carrito por usuario.
**Ejemplo cotidiano:** Carritos se puede imaginar como una sección de un archivador con fichas; las tablas de asociación son como etiquetas que conectan dos fichas.
**Qué representa una fila:** Carrito individual.
**Cantidad de columnas:** 5
**Identificador principal:** `ID`.
**Relaciones declaradas:** `user_ID` → `tb_users.ID`
**Observaciones:** definición SQL en líneas 147–156.

### Resumen de columnas

| Campo técnico | Significado | Tipo SQL y composición | ¿Puede quedar vacío? | Ejemplo ficticio | Restricciones y relaciones |
|---|---|---|---|---|---|
| `ID` | Identificador técnico del carrito. | `int unsigned` — Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED). | No | `42` | PK; AUTO_INCREMENT |
| `user_ID` | Usuario al que pertenece el carrito; UNIQUE limita a uno por usuario. | `int unsigned` — Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED). | No | `42` | UNIQUE; FK `fk_carts_user` → `tb_users.ID` |
| `status` | Bandera binaria con default 1; activo/inactivo es inferido. | `bit(1)` — Un bit: b'0' o b'1'. | No | `b'1'` | No especificado en el respaldo |
| `creation_date` | Fecha/hora de creación. | `datetime` — Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS. | No | `2026-01-15 09:30:00` | No especificado en el respaldo |
| `last_update` | Fecha/hora inicial y automática al modificar. | `datetime` — Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS. | No | `2026-01-15 09:30:00` | ON UPDATE CURRENT_TIMESTAMP |

### Fichas individuales

#### `ID` — Identificador

- **Nombre técnico:** `ID`
- **Nombre comprensible:** Identificador
- **Significado:** Identificador técnico del carrito.
- **Uso funcional:** Identificador técnico del carrito.
- **Tipo de dato SQL:** `int unsigned`; definición completa: `int unsigned NOT NULL AUTO_INCREMENT`.
- **Composición del tipo:** Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED).
- **Formato esperado:** Número entero no negativo.
- **Ejemplo ilustrativo ficticio:** `42`
- **Permite valores nulos:** No.
- **Es obligatorio:** Se genera automáticamente; no se proporciona como entrada.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** Sí.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** Parte de la PRIMARY KEY. AUTO_INCREMENT.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `user_ID` — ID de usuario

- **Nombre técnico:** `user_ID`
- **Nombre comprensible:** ID de usuario
- **Significado:** Usuario al que pertenece el carrito; UNIQUE limita a uno por usuario.
- **Uso funcional:** Usuario al que pertenece el carrito; UNIQUE limita a uno por usuario.
- **Tipo de dato SQL:** `int unsigned`; definición completa: `int unsigned NOT NULL`.
- **Composición del tipo:** Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED).
- **Formato esperado:** Número entero no negativo.
- **Ejemplo ilustrativo ficticio:** `42`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** No.
- **Clave foránea:** Sí: `fk_carts_user` → `tb_users.ID`
- **Restricciones:** Participa en índice UNIQUE. FK `fk_carts_user` → `tb_users.ID`.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** `fk_carts_user` → `tb_users.ID`
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `status` — Status

- **Nombre técnico:** `status`
- **Nombre comprensible:** Status
- **Significado:** Bandera binaria con default 1; activo/inactivo es inferido.
- **Uso funcional:** Bandera binaria con default 1; activo/inactivo es inferido.
- **Tipo de dato SQL:** `bit(1)`; definición completa: `bit(1) NOT NULL DEFAULT b'1'`.
- **Composición del tipo:** Un bit: b'0' o b'1'.
- **Formato esperado:** Valor binario del ancho declarado.
- **Ejemplo ilustrativo ficticio:** `b'1'`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** `b'1'`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** b'0', b'1' por BIT(1); significado según el campo no siempre especificado.
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `creation_date` — Fecha de creación

- **Nombre técnico:** `creation_date`
- **Nombre comprensible:** Fecha de creación
- **Significado:** Fecha/hora de creación.
- **Uso funcional:** Fecha/hora de creación.
- **Tipo de dato SQL:** `datetime`; definición completa: `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP`.
- **Composición del tipo:** Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS.
- **Formato esperado:** AAAA-MM-DD HH:MM:SS; sin zona horaria.
- **Ejemplo ilustrativo ficticio:** `2026-01-15 09:30:00`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** `CURRENT_TIMESTAMP`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `last_update` — Última actualización

- **Nombre técnico:** `last_update`
- **Nombre comprensible:** Última actualización
- **Significado:** Fecha/hora inicial y automática al modificar.
- **Uso funcional:** Fecha/hora inicial y automática al modificar.
- **Tipo de dato SQL:** `datetime`; definición completa: `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP`.
- **Composición del tipo:** Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS.
- **Formato esperado:** AAAA-MM-DD HH:MM:SS; sin zona horaria.
- **Ejemplo ilustrativo ficticio:** `2026-01-15 09:30:00`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** `CURRENT_TIMESTAMP`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** ON UPDATE CURRENT_TIMESTAMP.


## Tabla `tb_logs`

**Descripción sencilla:** Datos de operación, usuario SQL, fecha y descripción. Triggers registran aquí cambios de varias tablas.
**Ejemplo cotidiano:** Bitácora se puede imaginar como una sección de un archivador con fichas; las tablas de asociación son como etiquetas que conectan dos fichas.
**Qué representa una fila:** Evento registrado individual.
**Cantidad de columnas:** 7
**Identificador principal:** `ID`.
**Relaciones declaradas:** Ninguna FK.
**Observaciones:** definición SQL en líneas 175–184.

### Resumen de columnas

| Campo técnico | Significado | Tipo SQL y composición | ¿Puede quedar vacío? | Ejemplo ficticio | Restricciones y relaciones |
|---|---|---|---|---|---|
| `ID` | Identificador técnico de la entrada. | `int` — Entero sin decimales con signo. | No | `42` | PK; AUTO_INCREMENT |
| `table_name` | Nombre de la tabla afectada. | `varchar(80)` — Texto variable, máximo declarado de 80 caracteres, sujeto al charset. | No | `Texto ficticio` | No especificado en el respaldo |
| `table_operation` | Operación registrada: Create, Read, Update o Delete; puede ser NULL. | `enum('Create','Read','Update','Delete')` — Texto de una lista cerrada: Create, Read, Update, Delete. | Sí | `Create` | No especificado en el respaldo |
| `db_users` | Identidad SQL relacionada con la operación según los triggers. | `varchar(80)` — Texto variable, máximo declarado de 80 caracteres, sujeto al charset. | No | `Texto ficticio` | No especificado en el respaldo |
| `operation_date` | Momento de la operación. | `datetime` — Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS. | No | `2026-01-15 09:30:00` | No especificado en el respaldo |
| `table_description` | Detalle textual de la operación. | `text` — Texto amplio; MySQL TEXT permite hasta 65,535 bytes, sujeto a codificación. | No | `Descripción ficticia.` | No especificado en el respaldo |
| `operation_status` | Bandera binaria; significado no está formalmente definido. | `bit(1)` — Un bit: b'0' o b'1'. | Sí | `b'1'` | No especificado en el respaldo |

### Fichas individuales

#### `ID` — Identificador

- **Nombre técnico:** `ID`
- **Nombre comprensible:** Identificador
- **Significado:** Identificador técnico de la entrada.
- **Uso funcional:** Identificador técnico de la entrada.
- **Tipo de dato SQL:** `int`; definición completa: `int NOT NULL AUTO_INCREMENT`.
- **Composición del tipo:** Entero sin decimales con signo.
- **Formato esperado:** Número entero.
- **Ejemplo ilustrativo ficticio:** `42`
- **Permite valores nulos:** No.
- **Es obligatorio:** Se genera automáticamente; no se proporciona como entrada.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** Sí.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** Parte de la PRIMARY KEY. AUTO_INCREMENT.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `table_name` — Tabla afectada

- **Nombre técnico:** `table_name`
- **Nombre comprensible:** Tabla afectada
- **Significado:** Nombre de la tabla afectada.
- **Uso funcional:** Nombre de la tabla afectada.
- **Tipo de dato SQL:** `varchar(80)`; definición completa: `varchar(80) NOT NULL`.
- **Composición del tipo:** Texto variable, máximo declarado de 80 caracteres, sujeto al charset.
- **Formato esperado:** Texto dentro de la longitud declarada.
- **Ejemplo ilustrativo ficticio:** `Texto ficticio`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `table_operation` — Operación

- **Nombre técnico:** `table_operation`
- **Nombre comprensible:** Operación
- **Significado:** Operación registrada: Create, Read, Update o Delete; puede ser NULL.
- **Uso funcional:** Operación registrada: Create, Read, Update o Delete; puede ser NULL.
- **Tipo de dato SQL:** `enum('Create','Read','Update','Delete')`; definición completa: `enum('Create','Read','Update','Delete') DEFAULT NULL`.
- **Composición del tipo:** Texto de una lista cerrada: Create, Read, Update, Delete.
- **Formato esperado:** Uno de los valores ENUM declarados.
- **Ejemplo ilustrativo ficticio:** `Create`
- **Permite valores nulos:** Sí.
- **Es obligatorio:** No; admite NULL.
- **Valor predeterminado:** `NULL`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** Create, Read, Update, Delete
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `db_users` — Usuario de base de datos

- **Nombre técnico:** `db_users`
- **Nombre comprensible:** Usuario de base de datos
- **Significado:** Identidad SQL relacionada con la operación según los triggers.
- **Uso funcional:** Identidad SQL relacionada con la operación según los triggers.
- **Tipo de dato SQL:** `varchar(80)`; definición completa: `varchar(80) NOT NULL`.
- **Composición del tipo:** Texto variable, máximo declarado de 80 caracteres, sujeto al charset.
- **Formato esperado:** Texto dentro de la longitud declarada.
- **Ejemplo ilustrativo ficticio:** `Texto ficticio`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `operation_date` — Fecha de operación

- **Nombre técnico:** `operation_date`
- **Nombre comprensible:** Fecha de operación
- **Significado:** Momento de la operación.
- **Uso funcional:** Momento de la operación.
- **Tipo de dato SQL:** `datetime`; definición completa: `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP`.
- **Composición del tipo:** Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS.
- **Formato esperado:** AAAA-MM-DD HH:MM:SS; sin zona horaria.
- **Ejemplo ilustrativo ficticio:** `2026-01-15 09:30:00`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** `CURRENT_TIMESTAMP`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `table_description` — Detalle

- **Nombre técnico:** `table_description`
- **Nombre comprensible:** Detalle
- **Significado:** Detalle textual de la operación.
- **Uso funcional:** Detalle textual de la operación.
- **Tipo de dato SQL:** `text`; definición completa: `text NOT NULL`.
- **Composición del tipo:** Texto amplio; MySQL TEXT permite hasta 65,535 bytes, sujeto a codificación.
- **Formato esperado:** Texto sin formato interno impuesto.
- **Ejemplo ilustrativo ficticio:** `Descripción ficticia.`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `operation_status` — Estado de operación

- **Nombre técnico:** `operation_status`
- **Nombre comprensible:** Estado de operación
- **Significado:** Bandera binaria; significado no está formalmente definido.
- **Uso funcional:** Bandera binaria; significado no está formalmente definido.
- **Tipo de dato SQL:** `bit(1)`; definición completa: `bit(1) DEFAULT b'1'`.
- **Composición del tipo:** Un bit: b'0' o b'1'.
- **Formato esperado:** Valor binario del ancho declarado.
- **Ejemplo ilustrativo ficticio:** `b'1'`
- **Permite valores nulos:** Sí.
- **Es obligatorio:** No; admite NULL.
- **Valor predeterminado:** `b'1'`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** b'0', b'1' por BIT(1); significado según el campo no siempre especificado.
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.


## Tabla `tb_products`

**Descripción sencilla:** Catálogo con SKU, nombre, descripción, precio, existencias, estado y fechas.
**Ejemplo cotidiano:** Productos se puede imaginar como una sección de un archivador con fichas; las tablas de asociación son como etiquetas que conectan dos fichas.
**Qué representa una fila:** Producto individual.
**Cantidad de columnas:** 9
**Identificador principal:** `ID`.
**Relaciones declaradas:** Ninguna FK.
**Observaciones:** definición SQL en líneas 205–217.

### Resumen de columnas

| Campo técnico | Significado | Tipo SQL y composición | ¿Puede quedar vacío? | Ejemplo ficticio | Restricciones y relaciones |
|---|---|---|---|---|---|
| `ID` | Identificador técnico del producto. | `int unsigned` — Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED). | No | `42` | PK; AUTO_INCREMENT |
| `SKU` | Código de inventario único. | `varchar(50)` — Texto variable, máximo declarado de 50 caracteres, sujeto al charset. | No | `SKU-DEMO-001` | UNIQUE |
| `name` | Nombre legible del producto. | `varchar(250)` — Texto variable, máximo declarado de 250 caracteres, sujeto al charset. | No | `Artículo de ejemplo` | No especificado en el respaldo |
| `description` | Descripción opcional. | `text` — Texto amplio; MySQL TEXT permite hasta 65,535 bytes, sujeto a codificación. | Sí | `Descripción ficticia.` | No especificado en el respaldo |
| `current_price` | Precio actual; moneda y regla de precio no especificadas. | `decimal(10,2)` — DECIMAL exacto con 10 dígitos totales (precisión) y 2 decimales (escala). | No | `125.50` | No especificado en el respaldo |
| `current_stock` | Existencias enteras no negativas por UNSIGNED. | `int unsigned` — Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED). | No | `42` | No especificado en el respaldo |
| `status` | Bandera de estado; los procedimientos usan 1 para activo y 0 para baja. | `bit(1)` — Un bit: b'0' o b'1'. | Sí | `b'1'` | No especificado en el respaldo |
| `creation_date` | Momento de alta. | `datetime` — Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS. | No | `2026-01-15 09:30:00` | No especificado en el respaldo |
| `last_update` | Actualización automática al cambiar la fila. | `datetime` — Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS. | No | `2026-01-15 09:30:00` | ON UPDATE CURRENT_TIMESTAMP |

### Fichas individuales

#### `ID` — Identificador

- **Nombre técnico:** `ID`
- **Nombre comprensible:** Identificador
- **Significado:** Identificador técnico del producto.
- **Uso funcional:** Identificador técnico del producto.
- **Tipo de dato SQL:** `int unsigned`; definición completa: `int unsigned NOT NULL AUTO_INCREMENT`.
- **Composición del tipo:** Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED).
- **Formato esperado:** Número entero no negativo.
- **Ejemplo ilustrativo ficticio:** `42`
- **Permite valores nulos:** No.
- **Es obligatorio:** Se genera automáticamente; no se proporciona como entrada.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** Sí.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** Parte de la PRIMARY KEY. AUTO_INCREMENT.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `SKU` — Código SKU

- **Nombre técnico:** `SKU`
- **Nombre comprensible:** Código SKU
- **Significado:** Código de inventario único.
- **Uso funcional:** Código de inventario único.
- **Tipo de dato SQL:** `varchar(50)`; definición completa: `varchar(50) NOT NULL`.
- **Composición del tipo:** Texto variable, máximo declarado de 50 caracteres, sujeto al charset.
- **Formato esperado:** Texto dentro de la longitud declarada.
- **Ejemplo ilustrativo ficticio:** `SKU-DEMO-001`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** Participa en índice UNIQUE.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `name` — Name

- **Nombre técnico:** `name`
- **Nombre comprensible:** Name
- **Significado:** Nombre legible del producto.
- **Uso funcional:** Nombre legible del producto.
- **Tipo de dato SQL:** `varchar(250)`; definición completa: `varchar(250) NOT NULL`.
- **Composición del tipo:** Texto variable, máximo declarado de 250 caracteres, sujeto al charset.
- **Formato esperado:** Texto dentro de la longitud declarada.
- **Ejemplo ilustrativo ficticio:** `Artículo de ejemplo`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `description` — Description

- **Nombre técnico:** `description`
- **Nombre comprensible:** Description
- **Significado:** Descripción opcional.
- **Uso funcional:** Descripción opcional.
- **Tipo de dato SQL:** `text`; definición completa: `text`.
- **Composición del tipo:** Texto amplio; MySQL TEXT permite hasta 65,535 bytes, sujeto a codificación.
- **Formato esperado:** Texto sin formato interno impuesto.
- **Ejemplo ilustrativo ficticio:** `Descripción ficticia.`
- **Permite valores nulos:** Sí.
- **Es obligatorio:** No; admite NULL.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `current_price` — Precio actual

- **Nombre técnico:** `current_price`
- **Nombre comprensible:** Precio actual
- **Significado:** Precio actual; moneda y regla de precio no especificadas.
- **Uso funcional:** Precio actual; moneda y regla de precio no especificadas.
- **Tipo de dato SQL:** `decimal(10,2)`; definición completa: `decimal(10,2) NOT NULL DEFAULT '0.00'`.
- **Composición del tipo:** DECIMAL exacto con 10 dígitos totales (precisión) y 2 decimales (escala).
- **Formato esperado:** Decimal con la precisión/escala definidas.
- **Ejemplo ilustrativo ficticio:** `125.50`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** `'0.00'`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `current_stock` — Existencias actuales

- **Nombre técnico:** `current_stock`
- **Nombre comprensible:** Existencias actuales
- **Significado:** Existencias enteras no negativas por UNSIGNED.
- **Uso funcional:** Existencias enteras no negativas por UNSIGNED.
- **Tipo de dato SQL:** `int unsigned`; definición completa: `int unsigned NOT NULL DEFAULT '0'`.
- **Composición del tipo:** Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED).
- **Formato esperado:** Número entero no negativo.
- **Ejemplo ilustrativo ficticio:** `42`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** `'0'`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `status` — Status

- **Nombre técnico:** `status`
- **Nombre comprensible:** Status
- **Significado:** Bandera de estado; los procedimientos usan 1 para activo y 0 para baja.
- **Uso funcional:** Bandera de estado; los procedimientos usan 1 para activo y 0 para baja.
- **Tipo de dato SQL:** `bit(1)`; definición completa: `bit(1) DEFAULT b'1'`.
- **Composición del tipo:** Un bit: b'0' o b'1'.
- **Formato esperado:** Valor binario del ancho declarado.
- **Ejemplo ilustrativo ficticio:** `b'1'`
- **Permite valores nulos:** Sí.
- **Es obligatorio:** No; admite NULL.
- **Valor predeterminado:** `b'1'`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** b'0', b'1' por BIT(1); significado según el campo no siempre especificado.
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `creation_date` — Fecha de creación

- **Nombre técnico:** `creation_date`
- **Nombre comprensible:** Fecha de creación
- **Significado:** Momento de alta.
- **Uso funcional:** Momento de alta.
- **Tipo de dato SQL:** `datetime`; definición completa: `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP`.
- **Composición del tipo:** Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS.
- **Formato esperado:** AAAA-MM-DD HH:MM:SS; sin zona horaria.
- **Ejemplo ilustrativo ficticio:** `2026-01-15 09:30:00`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** `CURRENT_TIMESTAMP`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `last_update` — Última actualización

- **Nombre técnico:** `last_update`
- **Nombre comprensible:** Última actualización
- **Significado:** Actualización automática al cambiar la fila.
- **Uso funcional:** Actualización automática al cambiar la fila.
- **Tipo de dato SQL:** `datetime`; definición completa: `datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP`.
- **Composición del tipo:** Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS.
- **Formato esperado:** AAAA-MM-DD HH:MM:SS; sin zona horaria.
- **Ejemplo ilustrativo ficticio:** `2026-01-15 09:30:00`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** ON UPDATE CURRENT_TIMESTAMP.


## Tabla `tb_users`

**Descripción sencilla:** Correo, apodo, valor de contraseña almacenado, fechas y estado. No se documenta el algoritmo de protección de password.
**Ejemplo cotidiano:** Usuarios se puede imaginar como una sección de un archivador con fichas; las tablas de asociación son como etiquetas que conectan dos fichas.
**Qué representa una fila:** Cuenta individual.
**Cantidad de columnas:** 8
**Identificador principal:** `ID`.
**Relaciones declaradas:** Ninguna FK.
**Observaciones:** definición SQL en líneas 350–362.

### Resumen de columnas

| Campo técnico | Significado | Tipo SQL y composición | ¿Puede quedar vacío? | Ejemplo ficticio | Restricciones y relaciones |
|---|---|---|---|---|---|
| `ID` | Identificador técnico de la cuenta. | `int unsigned` — Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED). | No | `42` | PK; AUTO_INCREMENT |
| `email` | Correo electrónico único; no hay validación de formato en SQL. | `varchar(100)` — Texto variable, máximo declarado de 100 caracteres, sujeto al charset. | No | `cuenta.demo@example.org` | UNIQUE |
| `nick` | Apodo único. | `varchar(50)` — Texto variable, máximo declarado de 50 caracteres, sujeto al charset. | No | `usuario_demo` | UNIQUE |
| `password` | Valor de contraseña requerido; el esquema no permite inferir algoritmo/hash/cifrado. | `varchar(255)` — Texto variable, máximo declarado de 255 caracteres, sujeto al charset. | No | `valor_ficticio_no_usable` | No especificado en el respaldo |
| `creation_date` | Momento de alta. | `datetime` — Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS. | No | `2026-01-15 09:30:00` | No especificado en el respaldo |
| `last_update` | Fecha opcional; no tiene ON UPDATE. | `datetime` — Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS. | Sí | `2026-01-15 09:30:00` | No especificado en el respaldo |
| `last_login` | Fecha opcional del último acceso. | `datetime` — Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS. | Sí | `2026-01-15 09:30:00` | No especificado en el respaldo |
| `status` | Bandera de estado con default 1; significado funcional general no declarado. | `bit(1)` — Un bit: b'0' o b'1'. | Sí | `b'1'` | No especificado en el respaldo |

### Fichas individuales

#### `ID` — Identificador

- **Nombre técnico:** `ID`
- **Nombre comprensible:** Identificador
- **Significado:** Identificador técnico de la cuenta.
- **Uso funcional:** Identificador técnico de la cuenta.
- **Tipo de dato SQL:** `int unsigned`; definición completa: `int unsigned NOT NULL AUTO_INCREMENT`.
- **Composición del tipo:** Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED).
- **Formato esperado:** Número entero no negativo.
- **Ejemplo ilustrativo ficticio:** `42`
- **Permite valores nulos:** No.
- **Es obligatorio:** Se genera automáticamente; no se proporciona como entrada.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** Sí.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** Parte de la PRIMARY KEY. AUTO_INCREMENT.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `email` — Email

- **Nombre técnico:** `email`
- **Nombre comprensible:** Email
- **Significado:** Correo electrónico único; no hay validación de formato en SQL.
- **Uso funcional:** Correo electrónico único; no hay validación de formato en SQL.
- **Tipo de dato SQL:** `varchar(100)`; definición completa: `varchar(100) NOT NULL`.
- **Composición del tipo:** Texto variable, máximo declarado de 100 caracteres, sujeto al charset.
- **Formato esperado:** Texto dentro de la longitud declarada.
- **Ejemplo ilustrativo ficticio:** `cuenta.demo@example.org`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** Participa en índice UNIQUE.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `nick` — Apodo

- **Nombre técnico:** `nick`
- **Nombre comprensible:** Apodo
- **Significado:** Apodo único.
- **Uso funcional:** Apodo único.
- **Tipo de dato SQL:** `varchar(50)`; definición completa: `varchar(50) NOT NULL`.
- **Composición del tipo:** Texto variable, máximo declarado de 50 caracteres, sujeto al charset.
- **Formato esperado:** Texto dentro de la longitud declarada.
- **Ejemplo ilustrativo ficticio:** `usuario_demo`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** Participa en índice UNIQUE.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `password` — Password

- **Nombre técnico:** `password`
- **Nombre comprensible:** Password
- **Significado:** Valor de contraseña requerido; el esquema no permite inferir algoritmo/hash/cifrado.
- **Uso funcional:** Valor de contraseña requerido; el esquema no permite inferir algoritmo/hash/cifrado.
- **Tipo de dato SQL:** `varchar(255)`; definición completa: `varchar(255) NOT NULL`.
- **Composición del tipo:** Texto variable, máximo declarado de 255 caracteres, sujeto al charset.
- **Formato esperado:** Texto dentro de la longitud declarada.
- **Ejemplo ilustrativo ficticio:** `valor_ficticio_no_usable`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se deduce método de protección; valores reales omitidos deliberadamente.

#### `creation_date` — Fecha de creación

- **Nombre técnico:** `creation_date`
- **Nombre comprensible:** Fecha de creación
- **Significado:** Momento de alta.
- **Uso funcional:** Momento de alta.
- **Tipo de dato SQL:** `datetime`; definición completa: `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP`.
- **Composición del tipo:** Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS.
- **Formato esperado:** AAAA-MM-DD HH:MM:SS; sin zona horaria.
- **Ejemplo ilustrativo ficticio:** `2026-01-15 09:30:00`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** `CURRENT_TIMESTAMP`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `last_update` — Última actualización

- **Nombre técnico:** `last_update`
- **Nombre comprensible:** Última actualización
- **Significado:** Fecha opcional; no tiene ON UPDATE.
- **Uso funcional:** Fecha opcional; no tiene ON UPDATE.
- **Tipo de dato SQL:** `datetime`; definición completa: `datetime DEFAULT NULL`.
- **Composición del tipo:** Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS.
- **Formato esperado:** AAAA-MM-DD HH:MM:SS; sin zona horaria.
- **Ejemplo ilustrativo ficticio:** `2026-01-15 09:30:00`
- **Permite valores nulos:** Sí.
- **Es obligatorio:** No; admite NULL.
- **Valor predeterminado:** `NULL`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `last_login` — Last login

- **Nombre técnico:** `last_login`
- **Nombre comprensible:** Last login
- **Significado:** Fecha opcional del último acceso.
- **Uso funcional:** Fecha opcional del último acceso.
- **Tipo de dato SQL:** `datetime`; definición completa: `datetime DEFAULT NULL`.
- **Composición del tipo:** Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS.
- **Formato esperado:** AAAA-MM-DD HH:MM:SS; sin zona horaria.
- **Ejemplo ilustrativo ficticio:** `2026-01-15 09:30:00`
- **Permite valores nulos:** Sí.
- **Es obligatorio:** No; admite NULL.
- **Valor predeterminado:** `NULL`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `status` — Status

- **Nombre técnico:** `status`
- **Nombre comprensible:** Status
- **Significado:** Bandera de estado con default 1; significado funcional general no declarado.
- **Uso funcional:** Bandera de estado con default 1; significado funcional general no declarado.
- **Tipo de dato SQL:** `bit(1)`; definición completa: `bit(1) DEFAULT b'1'`.
- **Composición del tipo:** Un bit: b'0' o b'1'.
- **Formato esperado:** Valor binario del ancho declarado.
- **Ejemplo ilustrativo ficticio:** `b'1'`
- **Permite valores nulos:** Sí.
- **Es obligatorio:** No; admite NULL.
- **Valor predeterminado:** `b'1'`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** b'0', b'1' por BIT(1); significado según el campo no siempre especificado.
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.


## Tabla `tbc_categories`

**Descripción sencilla:** Catálogo jerárquico; sup_id_category enlaza opcionalmente otra categoría.
**Ejemplo cotidiano:** Categorías se puede imaginar como una sección de un archivador con fichas; las tablas de asociación son como etiquetas que conectan dos fichas.
**Qué representa una fila:** Categoría individual.
**Cantidad de columnas:** 7
**Identificador principal:** `ID`.
**Relaciones declaradas:** `sup_id_category` → `tbc_categories.ID`
**Observaciones:** definición SQL en líneas 492–504.

### Resumen de columnas

| Campo técnico | Significado | Tipo SQL y composición | ¿Puede quedar vacío? | Ejemplo ficticio | Restricciones y relaciones |
|---|---|---|---|---|---|
| `ID` | Identificador técnico de la categoría. | `int unsigned` — Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED). | No | `42` | PK; AUTO_INCREMENT |
| `name` | Nombre único de categoría. | `varchar(120)` — Texto variable, máximo declarado de 120 caracteres, sujeto al charset. | No | `Texto ficticio` | UNIQUE |
| `description` | Descripción opcional. | `text` — Texto amplio; MySQL TEXT permite hasta 65,535 bytes, sujeto a codificación. | Sí | `Descripción ficticia.` | No especificado en el respaldo |
| `sup_id_category` | Categoría superior opcional, referencia a esta misma tabla. | `int unsigned` — Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED). | Sí | `42` | FK `fk_superior_category` → `tbc_categories.ID` |
| `status` | Bandera binaria con default 1. | `bit(1)` — Un bit: b'0' o b'1'. | No | `b'1'` | No especificado en el respaldo |
| `creation_date` | Momento de alta. | `datetime` — Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS. | No | `2026-01-15 09:30:00` | No especificado en el respaldo |
| `last_update` | Actualización automática al cambiar. | `datetime` — Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS. | No | `2026-01-15 09:30:00` | ON UPDATE CURRENT_TIMESTAMP |

### Fichas individuales

#### `ID` — Identificador

- **Nombre técnico:** `ID`
- **Nombre comprensible:** Identificador
- **Significado:** Identificador técnico de la categoría.
- **Uso funcional:** Identificador técnico de la categoría.
- **Tipo de dato SQL:** `int unsigned`; definición completa: `int unsigned NOT NULL AUTO_INCREMENT`.
- **Composición del tipo:** Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED).
- **Formato esperado:** Número entero no negativo.
- **Ejemplo ilustrativo ficticio:** `42`
- **Permite valores nulos:** No.
- **Es obligatorio:** Se genera automáticamente; no se proporciona como entrada.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** Sí.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** Parte de la PRIMARY KEY. AUTO_INCREMENT.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `name` — Name

- **Nombre técnico:** `name`
- **Nombre comprensible:** Name
- **Significado:** Nombre único de categoría.
- **Uso funcional:** Nombre único de categoría.
- **Tipo de dato SQL:** `varchar(120)`; definición completa: `varchar(120) NOT NULL`.
- **Composición del tipo:** Texto variable, máximo declarado de 120 caracteres, sujeto al charset.
- **Formato esperado:** Texto dentro de la longitud declarada.
- **Ejemplo ilustrativo ficticio:** `Texto ficticio`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** Participa en índice UNIQUE.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `description` — Description

- **Nombre técnico:** `description`
- **Nombre comprensible:** Description
- **Significado:** Descripción opcional.
- **Uso funcional:** Descripción opcional.
- **Tipo de dato SQL:** `text`; definición completa: `text`.
- **Composición del tipo:** Texto amplio; MySQL TEXT permite hasta 65,535 bytes, sujeto a codificación.
- **Formato esperado:** Texto sin formato interno impuesto.
- **Ejemplo ilustrativo ficticio:** `Descripción ficticia.`
- **Permite valores nulos:** Sí.
- **Es obligatorio:** No; admite NULL.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `sup_id_category` — ID de categoría superior

- **Nombre técnico:** `sup_id_category`
- **Nombre comprensible:** ID de categoría superior
- **Significado:** Categoría superior opcional, referencia a esta misma tabla.
- **Uso funcional:** Categoría superior opcional, referencia a esta misma tabla.
- **Tipo de dato SQL:** `int unsigned`; definición completa: `int unsigned DEFAULT NULL`.
- **Composición del tipo:** Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED).
- **Formato esperado:** Número entero no negativo.
- **Ejemplo ilustrativo ficticio:** `42`
- **Permite valores nulos:** Sí.
- **Es obligatorio:** No; admite NULL.
- **Valor predeterminado:** `NULL`
- **Clave primaria:** No.
- **Clave foránea:** Sí: `fk_superior_category` → `tbc_categories.ID`
- **Restricciones:** FK `fk_superior_category` → `tbc_categories.ID`.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** `fk_superior_category` → `tbc_categories.ID`
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `status` — Status

- **Nombre técnico:** `status`
- **Nombre comprensible:** Status
- **Significado:** Bandera binaria con default 1.
- **Uso funcional:** Bandera binaria con default 1.
- **Tipo de dato SQL:** `bit(1)`; definición completa: `bit(1) NOT NULL DEFAULT b'1'`.
- **Composición del tipo:** Un bit: b'0' o b'1'.
- **Formato esperado:** Valor binario del ancho declarado.
- **Ejemplo ilustrativo ficticio:** `b'1'`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** `b'1'`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** b'0', b'1' por BIT(1); significado según el campo no siempre especificado.
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `creation_date` — Fecha de creación

- **Nombre técnico:** `creation_date`
- **Nombre comprensible:** Fecha de creación
- **Significado:** Momento de alta.
- **Uso funcional:** Momento de alta.
- **Tipo de dato SQL:** `datetime`; definición completa: `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP`.
- **Composición del tipo:** Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS.
- **Formato esperado:** AAAA-MM-DD HH:MM:SS; sin zona horaria.
- **Ejemplo ilustrativo ficticio:** `2026-01-15 09:30:00`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** `CURRENT_TIMESTAMP`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `last_update` — Última actualización

- **Nombre técnico:** `last_update`
- **Nombre comprensible:** Última actualización
- **Significado:** Actualización automática al cambiar.
- **Uso funcional:** Actualización automática al cambiar.
- **Tipo de dato SQL:** `datetime`; definición completa: `datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP`.
- **Composición del tipo:** Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS.
- **Formato esperado:** AAAA-MM-DD HH:MM:SS; sin zona horaria.
- **Ejemplo ilustrativo ficticio:** `2026-01-15 09:30:00`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** ON UPDATE CURRENT_TIMESTAMP.


## Tabla `tbc_payment_methods_types`

**Descripción sencilla:** Catálogo con código único, descripción y estado.
**Ejemplo cotidiano:** Tipos de métodos de pago se puede imaginar como una sección de un archivador con fichas; las tablas de asociación son como etiquetas que conectan dos fichas.
**Qué representa una fila:** Tipo de método individual.
**Cantidad de columnas:** 6
**Identificador principal:** `ID`.
**Relaciones declaradas:** Ninguna FK.
**Observaciones:** definición SQL en líneas 630–639.

### Resumen de columnas

| Campo técnico | Significado | Tipo SQL y composición | ¿Puede quedar vacío? | Ejemplo ficticio | Restricciones y relaciones |
|---|---|---|---|---|---|
| `ID` | Identificador técnico del tipo. | `int unsigned` — Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED). | No | `42` | PK; AUTO_INCREMENT |
| `code` | Código de catálogo único. | `varchar(30)` — Texto variable, máximo declarado de 30 caracteres, sujeto al charset. | No | `Texto ficticio` | UNIQUE |
| `description` | Descripción obligatoria del tipo. | `text` — Texto amplio; MySQL TEXT permite hasta 65,535 bytes, sujeto a codificación. | No | `Descripción ficticia.` | No especificado en el respaldo |
| `status` | Bandera binaria con default 1. | `bit(1)` — Un bit: b'0' o b'1'. | No | `b'1'` | No especificado en el respaldo |
| `creation_date` | Momento de alta. | `datetime` — Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS. | No | `2026-01-15 09:30:00` | No especificado en el respaldo |
| `last_update` | Fecha opcional con actualización automática al cambiar. | `datetime` — Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS. | Sí | `2026-01-15 09:30:00` | ON UPDATE CURRENT_TIMESTAMP |

### Fichas individuales

#### `ID` — Identificador

- **Nombre técnico:** `ID`
- **Nombre comprensible:** Identificador
- **Significado:** Identificador técnico del tipo.
- **Uso funcional:** Identificador técnico del tipo.
- **Tipo de dato SQL:** `int unsigned`; definición completa: `int unsigned NOT NULL AUTO_INCREMENT`.
- **Composición del tipo:** Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED).
- **Formato esperado:** Número entero no negativo.
- **Ejemplo ilustrativo ficticio:** `42`
- **Permite valores nulos:** No.
- **Es obligatorio:** Se genera automáticamente; no se proporciona como entrada.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** Sí.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** Parte de la PRIMARY KEY. AUTO_INCREMENT.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `code` — Code

- **Nombre técnico:** `code`
- **Nombre comprensible:** Code
- **Significado:** Código de catálogo único.
- **Uso funcional:** Código de catálogo único.
- **Tipo de dato SQL:** `varchar(30)`; definición completa: `varchar(30) NOT NULL`.
- **Composición del tipo:** Texto variable, máximo declarado de 30 caracteres, sujeto al charset.
- **Formato esperado:** Texto dentro de la longitud declarada.
- **Ejemplo ilustrativo ficticio:** `Texto ficticio`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** Participa en índice UNIQUE.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `description` — Description

- **Nombre técnico:** `description`
- **Nombre comprensible:** Description
- **Significado:** Descripción obligatoria del tipo.
- **Uso funcional:** Descripción obligatoria del tipo.
- **Tipo de dato SQL:** `text`; definición completa: `text NOT NULL`.
- **Composición del tipo:** Texto amplio; MySQL TEXT permite hasta 65,535 bytes, sujeto a codificación.
- **Formato esperado:** Texto sin formato interno impuesto.
- **Ejemplo ilustrativo ficticio:** `Descripción ficticia.`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `status` — Status

- **Nombre técnico:** `status`
- **Nombre comprensible:** Status
- **Significado:** Bandera binaria con default 1.
- **Uso funcional:** Bandera binaria con default 1.
- **Tipo de dato SQL:** `bit(1)`; definición completa: `bit(1) NOT NULL DEFAULT b'1'`.
- **Composición del tipo:** Un bit: b'0' o b'1'.
- **Formato esperado:** Valor binario del ancho declarado.
- **Ejemplo ilustrativo ficticio:** `b'1'`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** `b'1'`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** b'0', b'1' por BIT(1); significado según el campo no siempre especificado.
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `creation_date` — Fecha de creación

- **Nombre técnico:** `creation_date`
- **Nombre comprensible:** Fecha de creación
- **Significado:** Momento de alta.
- **Uso funcional:** Momento de alta.
- **Tipo de dato SQL:** `datetime`; definición completa: `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP`.
- **Composición del tipo:** Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS.
- **Formato esperado:** AAAA-MM-DD HH:MM:SS; sin zona horaria.
- **Ejemplo ilustrativo ficticio:** `2026-01-15 09:30:00`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** `CURRENT_TIMESTAMP`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `last_update` — Última actualización

- **Nombre técnico:** `last_update`
- **Nombre comprensible:** Última actualización
- **Significado:** Fecha opcional con actualización automática al cambiar.
- **Uso funcional:** Fecha opcional con actualización automática al cambiar.
- **Tipo de dato SQL:** `datetime`; definición completa: `datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP`.
- **Composición del tipo:** Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS.
- **Formato esperado:** AAAA-MM-DD HH:MM:SS; sin zona horaria.
- **Ejemplo ilustrativo ficticio:** `2026-01-15 09:30:00`
- **Permite valores nulos:** Sí.
- **Es obligatorio:** No; admite NULL.
- **Valor predeterminado:** `NULL`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** ON UPDATE CURRENT_TIMESTAMP.


## Tabla `tbd_carts_items`

**Descripción sencilla:** Detalle asociado a carrito, proveedor y producto; PK compuesta por esos tres identificadores.
**Ejemplo cotidiano:** Artículos de carrito se puede imaginar como una sección de un archivador con fichas; las tablas de asociación son como etiquetas que conectan dos fichas.
**Qué representa una fila:** Línea individual.
**Cantidad de columnas:** 5
**Identificador principal:** `cart_ID, provider_ID, product_ID` (clave compuesta).
**Relaciones declaradas:** `cart_ID` → `tb_carts.ID`; `provider_ID` → `tbd_products_users_providers.user_ID`; `product_ID` → `tbd_products_users_providers.product_ID`
**Observaciones:** definición SQL en líneas 737–750.

### Resumen de columnas

| Campo técnico | Significado | Tipo SQL y composición | ¿Puede quedar vacío? | Ejemplo ficticio | Restricciones y relaciones |
|---|---|---|---|---|---|
| `cart_ID` | Carrito relacionado; parte de PK compuesta. | `int unsigned` — Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED). | No | `42` | PK; FK `tbd_carts_items_ibfk_1` → `tb_carts.ID` |
| `provider_ID` | Usuario/proveedor relacionado; referencia a componente no único de tabla puente. | `int unsigned` — Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED). | No | `42` | PK; FK `tbd_carts_items_ibfk_2` → `tbd_products_users_providers.user_ID` |
| `product_ID` | Producto relacionado; referencia a componente no único de tabla puente. | `int unsigned` — Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED). | No | `42` | PK; FK `tbd_carts_items_ibfk_3` → `tbd_products_users_providers.product_ID` |
| `quantity` | Unidades; UNSIGNED y CHECK > 0. | `int unsigned` — Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED). | No | `42` | CHECK chk_cart_quantity: (`quantity` > 0) |
| `creation_date` | Momento de alta de la línea. | `datetime` — Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS. | No | `2026-01-15 09:30:00` | No especificado en el respaldo |

### Fichas individuales

#### `cart_ID` — ID de carrito

- **Nombre técnico:** `cart_ID`
- **Nombre comprensible:** ID de carrito
- **Significado:** Carrito relacionado; parte de PK compuesta.
- **Uso funcional:** Carrito relacionado; parte de PK compuesta.
- **Tipo de dato SQL:** `int unsigned`; definición completa: `int unsigned NOT NULL`.
- **Composición del tipo:** Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED).
- **Formato esperado:** Número entero no negativo.
- **Ejemplo ilustrativo ficticio:** `42`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** Sí; compuesta (`cart_ID, provider_ID, product_ID`).
- **Clave foránea:** Sí: `tbd_carts_items_ibfk_1` → `tb_carts.ID`
- **Restricciones:** Parte de la PRIMARY KEY. FK `tbd_carts_items_ibfk_1` → `tb_carts.ID`.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** `tbd_carts_items_ibfk_1` → `tb_carts.ID`
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `provider_ID` — ID de proveedor

- **Nombre técnico:** `provider_ID`
- **Nombre comprensible:** ID de proveedor
- **Significado:** Usuario/proveedor relacionado; referencia a componente no único de tabla puente.
- **Uso funcional:** Usuario/proveedor relacionado; referencia a componente no único de tabla puente.
- **Tipo de dato SQL:** `int unsigned`; definición completa: `int unsigned NOT NULL`.
- **Composición del tipo:** Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED).
- **Formato esperado:** Número entero no negativo.
- **Ejemplo ilustrativo ficticio:** `42`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** Sí; compuesta (`cart_ID, provider_ID, product_ID`).
- **Clave foránea:** Sí: `tbd_carts_items_ibfk_2` → `tbd_products_users_providers.user_ID`
- **Restricciones:** Parte de la PRIMARY KEY. FK `tbd_carts_items_ibfk_2` → `tbd_products_users_providers.user_ID`.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** `tbd_carts_items_ibfk_2` → `tbd_products_users_providers.user_ID`
- **Observaciones y limitaciones:** La FK individual al destino no único no valida la asociación conjunta proveedor-producto.

#### `product_ID` — ID de producto

- **Nombre técnico:** `product_ID`
- **Nombre comprensible:** ID de producto
- **Significado:** Producto relacionado; referencia a componente no único de tabla puente.
- **Uso funcional:** Producto relacionado; referencia a componente no único de tabla puente.
- **Tipo de dato SQL:** `int unsigned`; definición completa: `int unsigned NOT NULL`.
- **Composición del tipo:** Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED).
- **Formato esperado:** Número entero no negativo.
- **Ejemplo ilustrativo ficticio:** `42`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** Sí; compuesta (`cart_ID, provider_ID, product_ID`).
- **Clave foránea:** Sí: `tbd_carts_items_ibfk_3` → `tbd_products_users_providers.product_ID`
- **Restricciones:** Parte de la PRIMARY KEY. FK `tbd_carts_items_ibfk_3` → `tbd_products_users_providers.product_ID`.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** `tbd_carts_items_ibfk_3` → `tbd_products_users_providers.product_ID`
- **Observaciones y limitaciones:** La FK individual al destino no único no valida la asociación conjunta proveedor-producto.

#### `quantity` — Quantity

- **Nombre técnico:** `quantity`
- **Nombre comprensible:** Quantity
- **Significado:** Unidades; UNSIGNED y CHECK > 0.
- **Uso funcional:** Unidades; UNSIGNED y CHECK > 0.
- **Tipo de dato SQL:** `int unsigned`; definición completa: `int unsigned NOT NULL DEFAULT '1'`.
- **Composición del tipo:** Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED).
- **Formato esperado:** Número entero no negativo.
- **Ejemplo ilustrativo ficticio:** `42`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** `'1'`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** CHECK `chk_cart_quantity`: `(`quantity` > 0)`.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `creation_date` — Fecha de creación

- **Nombre técnico:** `creation_date`
- **Nombre comprensible:** Fecha de creación
- **Significado:** Momento de alta de la línea.
- **Uso funcional:** Momento de alta de la línea.
- **Tipo de dato SQL:** `datetime`; definición completa: `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP`.
- **Composición del tipo:** Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS.
- **Formato esperado:** AAAA-MM-DD HH:MM:SS; sin zona horaria.
- **Ejemplo ilustrativo ficticio:** `2026-01-15 09:30:00`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** `CURRENT_TIMESTAMP`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.


## Tabla `tbd_order_items`

**Descripción sencilla:** Detalle de pedido con producto, proveedor, cantidad, precio y subtotal generado.
**Ejemplo cotidiano:** Artículos de pedido se puede imaginar como una sección de un archivador con fichas; las tablas de asociación son como etiquetas que conectan dos fichas.
**Qué representa una fila:** Línea de pedido individual.
**Cantidad de columnas:** 9
**Identificador principal:** `ID`.
**Relaciones declaradas:** `seller_order_ID` → `tb_buyer_orders.ID`; `product_ID` → `tbd_products_users_providers.product_ID`; `provider_ID` → `tbd_products_users_providers.user_ID`
**Observaciones:** definición SQL en líneas 847–866.

### Resumen de columnas

| Campo técnico | Significado | Tipo SQL y composición | ¿Puede quedar vacío? | Ejemplo ficticio | Restricciones y relaciones |
|---|---|---|---|---|---|
| `ID` | Identificador técnico de la línea. | `int unsigned` — Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED). | No | `42` | PK; AUTO_INCREMENT |
| `seller_order_ID` | Pedido que contiene esta línea. | `int unsigned` — Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED). | No | `42` | FK `tbd_order_items_ibfk_1` → `tb_buyer_orders.ID` |
| `product_ID` | Referencia al valor product_ID de la asociación usuario-producto. | `int unsigned` — Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED). | No | `42` | FK `tbd_order_items_ibfk_2` → `tbd_products_users_providers.product_ID` |
| `provider_ID` | Referencia al valor user_ID de la asociación usuario-producto. | `int unsigned` — Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED). | No | `42` | FK `tbd_order_items_ibfk_3` → `tbd_products_users_providers.user_ID` |
| `product_name` | Copia textual del nombre al registrar el producto en el pedido. | `varchar(255)` — Texto variable, máximo declarado de 255 caracteres, sujeto al charset. | No | `Texto ficticio` | No especificado en el respaldo |
| `quantity` | Unidades; UNSIGNED y CHECK > 0. | `int unsigned` — Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED). | No | `42` | CHECK tbd_order_items_chk_1: (`quantity` > 0) |
| `unit_price` | Importe unitario con CHECK >= 0; moneda no especificada. | `decimal(12,2)` — DECIMAL exacto con 12 dígitos totales (precisión) y 2 decimales (escala). | No | `125.50` | CHECK tbd_order_items_chk_2: (`unit_price` >= 0) |
| `subtotal` | Importe generado y almacenado como quantity × unit_price. | `decimal(12,2)` — DECIMAL exacto con 12 dígitos totales (precisión) y 2 decimales (escala). | Sí | `59.80 calculado` | GENERATED |
| `creation_date` | Momento de alta de la línea. | `datetime` — Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS. | No | `2026-01-15 09:30:00` | No especificado en el respaldo |

### Fichas individuales

#### `ID` — Identificador

- **Nombre técnico:** `ID`
- **Nombre comprensible:** Identificador
- **Significado:** Identificador técnico de la línea.
- **Uso funcional:** Identificador técnico de la línea.
- **Tipo de dato SQL:** `int unsigned`; definición completa: `int unsigned NOT NULL AUTO_INCREMENT`.
- **Composición del tipo:** Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED).
- **Formato esperado:** Número entero no negativo.
- **Ejemplo ilustrativo ficticio:** `42`
- **Permite valores nulos:** No.
- **Es obligatorio:** Se genera automáticamente; no se proporciona como entrada.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** Sí.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** Parte de la PRIMARY KEY. AUTO_INCREMENT.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `seller_order_ID` — ID de pedido

- **Nombre técnico:** `seller_order_ID`
- **Nombre comprensible:** ID de pedido
- **Significado:** Pedido que contiene esta línea.
- **Uso funcional:** Pedido que contiene esta línea.
- **Tipo de dato SQL:** `int unsigned`; definición completa: `int unsigned NOT NULL`.
- **Composición del tipo:** Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED).
- **Formato esperado:** Número entero no negativo.
- **Ejemplo ilustrativo ficticio:** `42`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** No.
- **Clave foránea:** Sí: `tbd_order_items_ibfk_1` → `tb_buyer_orders.ID`
- **Restricciones:** FK `tbd_order_items_ibfk_1` → `tb_buyer_orders.ID`.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** `tbd_order_items_ibfk_1` → `tb_buyer_orders.ID`
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `product_ID` — ID de producto

- **Nombre técnico:** `product_ID`
- **Nombre comprensible:** ID de producto
- **Significado:** Referencia al valor product_ID de la asociación usuario-producto.
- **Uso funcional:** Referencia al valor product_ID de la asociación usuario-producto.
- **Tipo de dato SQL:** `int unsigned`; definición completa: `int unsigned NOT NULL`.
- **Composición del tipo:** Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED).
- **Formato esperado:** Número entero no negativo.
- **Ejemplo ilustrativo ficticio:** `42`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** No.
- **Clave foránea:** Sí: `tbd_order_items_ibfk_2` → `tbd_products_users_providers.product_ID`
- **Restricciones:** FK `tbd_order_items_ibfk_2` → `tbd_products_users_providers.product_ID`.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** `tbd_order_items_ibfk_2` → `tbd_products_users_providers.product_ID`
- **Observaciones y limitaciones:** La FK individual al destino no único no valida la asociación conjunta proveedor-producto.

#### `provider_ID` — ID de proveedor

- **Nombre técnico:** `provider_ID`
- **Nombre comprensible:** ID de proveedor
- **Significado:** Referencia al valor user_ID de la asociación usuario-producto.
- **Uso funcional:** Referencia al valor user_ID de la asociación usuario-producto.
- **Tipo de dato SQL:** `int unsigned`; definición completa: `int unsigned NOT NULL`.
- **Composición del tipo:** Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED).
- **Formato esperado:** Número entero no negativo.
- **Ejemplo ilustrativo ficticio:** `42`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** No.
- **Clave foránea:** Sí: `tbd_order_items_ibfk_3` → `tbd_products_users_providers.user_ID`
- **Restricciones:** FK `tbd_order_items_ibfk_3` → `tbd_products_users_providers.user_ID`.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** `tbd_order_items_ibfk_3` → `tbd_products_users_providers.user_ID`
- **Observaciones y limitaciones:** La FK individual al destino no único no valida la asociación conjunta proveedor-producto.

#### `product_name` — Nombre del producto

- **Nombre técnico:** `product_name`
- **Nombre comprensible:** Nombre del producto
- **Significado:** Copia textual del nombre al registrar el producto en el pedido.
- **Uso funcional:** Copia textual del nombre al registrar el producto en el pedido.
- **Tipo de dato SQL:** `varchar(255)`; definición completa: `varchar(255) NOT NULL`.
- **Composición del tipo:** Texto variable, máximo declarado de 255 caracteres, sujeto al charset.
- **Formato esperado:** Texto dentro de la longitud declarada.
- **Ejemplo ilustrativo ficticio:** `Texto ficticio`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `quantity` — Quantity

- **Nombre técnico:** `quantity`
- **Nombre comprensible:** Quantity
- **Significado:** Unidades; UNSIGNED y CHECK > 0.
- **Uso funcional:** Unidades; UNSIGNED y CHECK > 0.
- **Tipo de dato SQL:** `int unsigned`; definición completa: `int unsigned NOT NULL`.
- **Composición del tipo:** Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED).
- **Formato esperado:** Número entero no negativo.
- **Ejemplo ilustrativo ficticio:** `42`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** CHECK `tbd_order_items_chk_1`: `(`quantity` > 0)`.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `unit_price` — Precio unitario

- **Nombre técnico:** `unit_price`
- **Nombre comprensible:** Precio unitario
- **Significado:** Importe unitario con CHECK >= 0; moneda no especificada.
- **Uso funcional:** Importe unitario con CHECK >= 0; moneda no especificada.
- **Tipo de dato SQL:** `decimal(12,2)`; definición completa: `decimal(12,2) NOT NULL`.
- **Composición del tipo:** DECIMAL exacto con 12 dígitos totales (precisión) y 2 decimales (escala).
- **Formato esperado:** Decimal con la precisión/escala definidas.
- **Ejemplo ilustrativo ficticio:** `125.50`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** CHECK `tbd_order_items_chk_2`: `(`unit_price` >= 0)`.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `subtotal` — Subtotal

- **Nombre técnico:** `subtotal`
- **Nombre comprensible:** Subtotal
- **Significado:** Importe generado y almacenado como quantity × unit_price.
- **Uso funcional:** Importe generado y almacenado como quantity × unit_price.
- **Tipo de dato SQL:** `decimal(12,2)`; definición completa: `decimal(12,2) GENERATED ALWAYS AS ((`quantity` * `unit_price`)) STORED`.
- **Composición del tipo:** DECIMAL exacto con 12 dígitos totales (precisión) y 2 decimales (escala).
- **Formato esperado:** Decimal con la precisión/escala definidas.
- **Ejemplo ilustrativo ficticio:** `59.80 calculado`
- **Permite valores nulos:** Sí.
- **Es obligatorio:** No; admite NULL.
- **Valor predeterminado:** Valor generado; no aplica DEFAULT de entrada.
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** GENERATED ALWAYS AS ((`quantity` * `unit_price`)) STORED.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** La expresión almacenada calcula cantidad × precio unitario.

#### `creation_date` — Fecha de creación

- **Nombre técnico:** `creation_date`
- **Nombre comprensible:** Fecha de creación
- **Significado:** Momento de alta de la línea.
- **Uso funcional:** Momento de alta de la línea.
- **Tipo de dato SQL:** `datetime`; definición completa: `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP`.
- **Composición del tipo:** Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS.
- **Formato esperado:** AAAA-MM-DD HH:MM:SS; sin zona horaria.
- **Ejemplo ilustrativo ficticio:** `2026-01-15 09:30:00`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** `CURRENT_TIMESTAMP`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.


## Tabla `tbd_products_categories`

**Descripción sencilla:** Asociación de productos con categorías, estado y fechas.
**Ejemplo cotidiano:** Productos por categoría se puede imaginar como una sección de un archivador con fichas; las tablas de asociación son como etiquetas que conectan dos fichas.
**Qué representa una fila:** Asignación individual.
**Cantidad de columnas:** 5
**Identificador principal:** `category_ID, product_ID` (clave compuesta).
**Relaciones declaradas:** `category_ID` → `tbc_categories.ID`; `product_ID` → `tb_products.ID`
**Observaciones:** definición SQL en líneas 975–985.

### Resumen de columnas

| Campo técnico | Significado | Tipo SQL y composición | ¿Puede quedar vacío? | Ejemplo ficticio | Restricciones y relaciones |
|---|---|---|---|---|---|
| `category_ID` | Categoría; parte de PK compuesta y FK. | `int unsigned` — Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED). | No | `42` | PK; FK `fk_category_prod` → `tbc_categories.ID` |
| `product_ID` | Producto; parte de PK compuesta y FK. | `int unsigned` — Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED). | No | `42` | PK; FK `fk_product_cat` → `tb_products.ID` |
| `status` | Bandera binaria con default 1. | `bit(1)` — Un bit: b'0' o b'1'. | No | `b'1'` | No especificado en el respaldo |
| `creation_date` | Momento de asignación. | `datetime` — Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS. | No | `2026-01-15 09:30:00` | No especificado en el respaldo |
| `last_update` | Actualización automática al cambiar. | `datetime` — Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS. | No | `2026-01-15 09:30:00` | ON UPDATE CURRENT_TIMESTAMP |

### Fichas individuales

#### `category_ID` — ID de categoría

- **Nombre técnico:** `category_ID`
- **Nombre comprensible:** ID de categoría
- **Significado:** Categoría; parte de PK compuesta y FK.
- **Uso funcional:** Categoría; parte de PK compuesta y FK.
- **Tipo de dato SQL:** `int unsigned`; definición completa: `int unsigned NOT NULL`.
- **Composición del tipo:** Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED).
- **Formato esperado:** Número entero no negativo.
- **Ejemplo ilustrativo ficticio:** `42`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** Sí; compuesta (`category_ID, product_ID`).
- **Clave foránea:** Sí: `fk_category_prod` → `tbc_categories.ID`
- **Restricciones:** Parte de la PRIMARY KEY. FK `fk_category_prod` → `tbc_categories.ID`.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** `fk_category_prod` → `tbc_categories.ID`
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `product_ID` — ID de producto

- **Nombre técnico:** `product_ID`
- **Nombre comprensible:** ID de producto
- **Significado:** Producto; parte de PK compuesta y FK.
- **Uso funcional:** Producto; parte de PK compuesta y FK.
- **Tipo de dato SQL:** `int unsigned`; definición completa: `int unsigned NOT NULL`.
- **Composición del tipo:** Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED).
- **Formato esperado:** Número entero no negativo.
- **Ejemplo ilustrativo ficticio:** `42`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** Sí; compuesta (`category_ID, product_ID`).
- **Clave foránea:** Sí: `fk_product_cat` → `tb_products.ID`
- **Restricciones:** Parte de la PRIMARY KEY. FK `fk_product_cat` → `tb_products.ID`.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** `fk_product_cat` → `tb_products.ID`
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `status` — Status

- **Nombre técnico:** `status`
- **Nombre comprensible:** Status
- **Significado:** Bandera binaria con default 1.
- **Uso funcional:** Bandera binaria con default 1.
- **Tipo de dato SQL:** `bit(1)`; definición completa: `bit(1) NOT NULL DEFAULT b'1'`.
- **Composición del tipo:** Un bit: b'0' o b'1'.
- **Formato esperado:** Valor binario del ancho declarado.
- **Ejemplo ilustrativo ficticio:** `b'1'`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** `b'1'`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** b'0', b'1' por BIT(1); significado según el campo no siempre especificado.
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `creation_date` — Fecha de creación

- **Nombre técnico:** `creation_date`
- **Nombre comprensible:** Fecha de creación
- **Significado:** Momento de asignación.
- **Uso funcional:** Momento de asignación.
- **Tipo de dato SQL:** `datetime`; definición completa: `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP`.
- **Composición del tipo:** Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS.
- **Formato esperado:** AAAA-MM-DD HH:MM:SS; sin zona horaria.
- **Ejemplo ilustrativo ficticio:** `2026-01-15 09:30:00`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** `CURRENT_TIMESTAMP`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `last_update` — Última actualización

- **Nombre técnico:** `last_update`
- **Nombre comprensible:** Última actualización
- **Significado:** Actualización automática al cambiar.
- **Uso funcional:** Actualización automática al cambiar.
- **Tipo de dato SQL:** `datetime`; definición completa: `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP`.
- **Composición del tipo:** Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS.
- **Formato esperado:** AAAA-MM-DD HH:MM:SS; sin zona horaria.
- **Ejemplo ilustrativo ficticio:** `2026-01-15 09:30:00`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** `CURRENT_TIMESTAMP`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** ON UPDATE CURRENT_TIMESTAMP.


## Tabla `tbd_products_users_providers`

**Descripción sencilla:** Asociación de usuarios y productos con tipo de participación, estado y fechas.
**Ejemplo cotidiano:** Productos por usuario/proveedor se puede imaginar como una sección de un archivador con fichas; las tablas de asociación son como etiquetas que conectan dos fichas.
**Qué representa una fila:** Asociación usuario-producto individual.
**Cantidad de columnas:** 7
**Identificador principal:** `user_ID, product_ID` (clave compuesta).
**Relaciones declaradas:** `product_ID` → `tb_products.ID`; `user_ID` → `tb_users.ID`
**Observaciones:** definición SQL en líneas 1074–1086.

### Resumen de columnas

| Campo técnico | Significado | Tipo SQL y composición | ¿Puede quedar vacío? | Ejemplo ficticio | Restricciones y relaciones |
|---|---|---|---|---|---|
| `user_ID` | Usuario asociado; parte de PK compuesta, referenciado también por FKs separadas. | `int unsigned` — Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED). | No | `42` | PK; FK `fk_user1` → `tb_users.ID` |
| `product_ID` | Producto asociado; parte de PK compuesta. | `int unsigned` — Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED). | No | `42` | PK; FK `fk_products2` → `tb_products.ID` |
| `type_ownership` | ENUM opcional Owner/Reseller/Distributor; roles deben confirmarse. | `enum('Owner','Reseller','Distributor')` — Texto de una lista cerrada: Owner, Reseller, Distributor. | Sí | `Reseller` | No especificado en el respaldo |
| `status` | Bandera binaria con default 1. | `bit(1)` — Un bit: b'0' o b'1'. | No | `b'1'` | No especificado en el respaldo |
| `avalaible_date` | Fecha de disponibilidad; se conserva el nombre exacto, incluida su ortografía. | `datetime` — Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS. | No | `2026-01-15 09:30:00` | No especificado en el respaldo |
| `creation_date` | Momento de alta. | `datetime` — Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS. | No | `2026-01-15 09:30:00` | No especificado en el respaldo |
| `last_update` | Actualización automática al cambiar. | `datetime` — Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS. | No | `2026-01-15 09:30:00` | ON UPDATE CURRENT_TIMESTAMP |

### Fichas individuales

#### `user_ID` — ID de usuario

- **Nombre técnico:** `user_ID`
- **Nombre comprensible:** ID de usuario
- **Significado:** Usuario asociado; parte de PK compuesta, referenciado también por FKs separadas.
- **Uso funcional:** Usuario asociado; parte de PK compuesta, referenciado también por FKs separadas.
- **Tipo de dato SQL:** `int unsigned`; definición completa: `int unsigned NOT NULL`.
- **Composición del tipo:** Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED).
- **Formato esperado:** Número entero no negativo.
- **Ejemplo ilustrativo ficticio:** `42`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** Sí; compuesta (`user_ID, product_ID`).
- **Clave foránea:** Sí: `fk_user1` → `tb_users.ID`
- **Restricciones:** Parte de la PRIMARY KEY. FK `fk_user1` → `tb_users.ID`.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** `fk_user1` → `tb_users.ID`
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `product_ID` — ID de producto

- **Nombre técnico:** `product_ID`
- **Nombre comprensible:** ID de producto
- **Significado:** Producto asociado; parte de PK compuesta.
- **Uso funcional:** Producto asociado; parte de PK compuesta.
- **Tipo de dato SQL:** `int unsigned`; definición completa: `int unsigned NOT NULL`.
- **Composición del tipo:** Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED).
- **Formato esperado:** Número entero no negativo.
- **Ejemplo ilustrativo ficticio:** `42`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** Sí; compuesta (`user_ID, product_ID`).
- **Clave foránea:** Sí: `fk_products2` → `tb_products.ID`
- **Restricciones:** Parte de la PRIMARY KEY. FK `fk_products2` → `tb_products.ID`.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** `fk_products2` → `tb_products.ID`
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `type_ownership` — Tipo de participación

- **Nombre técnico:** `type_ownership`
- **Nombre comprensible:** Tipo de participación
- **Significado:** ENUM opcional Owner/Reseller/Distributor; roles deben confirmarse.
- **Uso funcional:** ENUM opcional Owner/Reseller/Distributor; roles deben confirmarse.
- **Tipo de dato SQL:** `enum('Owner','Reseller','Distributor')`; definición completa: `enum('Owner','Reseller','Distributor') DEFAULT NULL`.
- **Composición del tipo:** Texto de una lista cerrada: Owner, Reseller, Distributor.
- **Formato esperado:** Uno de los valores ENUM declarados.
- **Ejemplo ilustrativo ficticio:** `Reseller`
- **Permite valores nulos:** Sí.
- **Es obligatorio:** No; admite NULL.
- **Valor predeterminado:** `NULL`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** Owner, Reseller, Distributor
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `status` — Status

- **Nombre técnico:** `status`
- **Nombre comprensible:** Status
- **Significado:** Bandera binaria con default 1.
- **Uso funcional:** Bandera binaria con default 1.
- **Tipo de dato SQL:** `bit(1)`; definición completa: `bit(1) NOT NULL DEFAULT b'1'`.
- **Composición del tipo:** Un bit: b'0' o b'1'.
- **Formato esperado:** Valor binario del ancho declarado.
- **Ejemplo ilustrativo ficticio:** `b'1'`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** `b'1'`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** b'0', b'1' por BIT(1); significado según el campo no siempre especificado.
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `avalaible_date` — Fecha de disponibilidad

- **Nombre técnico:** `avalaible_date`
- **Nombre comprensible:** Fecha de disponibilidad
- **Significado:** Fecha de disponibilidad; se conserva el nombre exacto, incluida su ortografía.
- **Uso funcional:** Fecha de disponibilidad; se conserva el nombre exacto, incluida su ortografía.
- **Tipo de dato SQL:** `datetime`; definición completa: `datetime NOT NULL`.
- **Composición del tipo:** Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS.
- **Formato esperado:** AAAA-MM-DD HH:MM:SS; sin zona horaria.
- **Ejemplo ilustrativo ficticio:** `2026-01-15 09:30:00`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `creation_date` — Fecha de creación

- **Nombre técnico:** `creation_date`
- **Nombre comprensible:** Fecha de creación
- **Significado:** Momento de alta.
- **Uso funcional:** Momento de alta.
- **Tipo de dato SQL:** `datetime`; definición completa: `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP`.
- **Composición del tipo:** Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS.
- **Formato esperado:** AAAA-MM-DD HH:MM:SS; sin zona horaria.
- **Ejemplo ilustrativo ficticio:** `2026-01-15 09:30:00`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** `CURRENT_TIMESTAMP`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `last_update` — Última actualización

- **Nombre técnico:** `last_update`
- **Nombre comprensible:** Última actualización
- **Significado:** Actualización automática al cambiar.
- **Uso funcional:** Actualización automática al cambiar.
- **Tipo de dato SQL:** `datetime`; definición completa: `datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP`.
- **Composición del tipo:** Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS.
- **Formato esperado:** AAAA-MM-DD HH:MM:SS; sin zona horaria.
- **Ejemplo ilustrativo ficticio:** `2026-01-15 09:30:00`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** ON UPDATE CURRENT_TIMESTAMP.


## Tabla `tbd_user_payment_methods`

**Descripción sencilla:** Método de pago asociado a usuario y tipo, con una referencia externa; no define datos completos de tarjeta.
**Ejemplo cotidiano:** Métodos de pago de usuarios se puede imaginar como una sección de un archivador con fichas; las tablas de asociación son como etiquetas que conectan dos fichas.
**Qué representa una fila:** Método guardado individual.
**Cantidad de columnas:** 11
**Identificador principal:** `ID`.
**Relaciones declaradas:** `user_ID` → `tb_users.ID`; `payment_method_type_ID` → `tbc_payment_methods_types.ID`
**Observaciones:** definición SQL en líneas 1183–1201.

### Resumen de columnas

| Campo técnico | Significado | Tipo SQL y composición | ¿Puede quedar vacío? | Ejemplo ficticio | Restricciones y relaciones |
|---|---|---|---|---|---|
| `ID` | Identificador técnico del método guardado. | `bigint unsigned` — Entero de 64 bits sin signo. | No | `42` | PK; AUTO_INCREMENT |
| `user_ID` | Usuario titular. | `int unsigned` — Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED). | No | `42` | FK `tbd_user_payment_methods_ibfk_1` → `tb_users.ID` |
| `payment_method_type_ID` | Tipo según el catálogo. | `int unsigned` — Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED). | No | `42` | FK `tbd_user_payment_methods_ibfk_2` → `tbc_payment_methods_types.ID` |
| `provider` | Nombre del proveedor externo; no es ENUM ni FK. | `varchar(50)` — Texto variable, máximo declarado de 50 caracteres, sujeto al charset. | No | `Texto ficticio` | UNIQUE |
| `provider_method_ref` | Referencia opaca del método en el proveedor; su formato depende del proveedor. | `varchar(255)` — Texto variable, máximo declarado de 255 caracteres, sujeto al charset. | No | `Texto ficticio` | UNIQUE |
| `label` | Etiqueta opcional legible. | `varchar(100)` — Texto variable, máximo declarado de 100 caracteres, sujeto al charset. | Sí | `Texto ficticio` | No especificado en el respaldo |
| `last_four` | Cuatro caracteres opcionales; SQL no exige que sean dígitos. | `char(4)` — Texto de longitud fija declarada de 4 caracteres. | Sí | `1234` | No especificado en el respaldo |
| `is_default` | TINYINT(1) con default 0; no existe CHECK que fuerce 0/1. | `tinyint(1)` — Entero pequeño de MySQL; apariencia booleana, pero no restringe a 0/1 sin CHECK. | No | `42` | No especificado en el respaldo |
| `status` | Bandera binaria con default 1. | `bit(1)` — Un bit: b'0' o b'1'. | No | `b'1'` | No especificado en el respaldo |
| `creation_date` | Momento de alta. | `datetime` — Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS. | No | `2026-01-15 09:30:00` | No especificado en el respaldo |
| `last_update` | Fecha opcional con actualización automática. | `datetime` — Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS. | Sí | `2026-01-15 09:30:00` | ON UPDATE CURRENT_TIMESTAMP |

### Fichas individuales

#### `ID` — Identificador

- **Nombre técnico:** `ID`
- **Nombre comprensible:** Identificador
- **Significado:** Identificador técnico del método guardado.
- **Uso funcional:** Identificador técnico del método guardado.
- **Tipo de dato SQL:** `bigint unsigned`; definición completa: `bigint unsigned NOT NULL AUTO_INCREMENT`.
- **Composición del tipo:** Entero de 64 bits sin signo.
- **Formato esperado:** Número entero no negativo.
- **Ejemplo ilustrativo ficticio:** `42`
- **Permite valores nulos:** No.
- **Es obligatorio:** Se genera automáticamente; no se proporciona como entrada.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** Sí.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** Parte de la PRIMARY KEY. AUTO_INCREMENT.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `user_ID` — ID de usuario

- **Nombre técnico:** `user_ID`
- **Nombre comprensible:** ID de usuario
- **Significado:** Usuario titular.
- **Uso funcional:** Usuario titular.
- **Tipo de dato SQL:** `int unsigned`; definición completa: `int unsigned NOT NULL`.
- **Composición del tipo:** Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED).
- **Formato esperado:** Número entero no negativo.
- **Ejemplo ilustrativo ficticio:** `42`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** No.
- **Clave foránea:** Sí: `tbd_user_payment_methods_ibfk_1` → `tb_users.ID`
- **Restricciones:** FK `tbd_user_payment_methods_ibfk_1` → `tb_users.ID`.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** `tbd_user_payment_methods_ibfk_1` → `tb_users.ID`
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `payment_method_type_ID` — ID del tipo de pago

- **Nombre técnico:** `payment_method_type_ID`
- **Nombre comprensible:** ID del tipo de pago
- **Significado:** Tipo según el catálogo.
- **Uso funcional:** Tipo según el catálogo.
- **Tipo de dato SQL:** `int unsigned`; definición completa: `int unsigned NOT NULL`.
- **Composición del tipo:** Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED).
- **Formato esperado:** Número entero no negativo.
- **Ejemplo ilustrativo ficticio:** `42`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** No.
- **Clave foránea:** Sí: `tbd_user_payment_methods_ibfk_2` → `tbc_payment_methods_types.ID`
- **Restricciones:** FK `tbd_user_payment_methods_ibfk_2` → `tbc_payment_methods_types.ID`.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** `tbd_user_payment_methods_ibfk_2` → `tbc_payment_methods_types.ID`
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `provider` — Provider

- **Nombre técnico:** `provider`
- **Nombre comprensible:** Provider
- **Significado:** Nombre del proveedor externo; no es ENUM ni FK.
- **Uso funcional:** Nombre del proveedor externo; no es ENUM ni FK.
- **Tipo de dato SQL:** `varchar(50)`; definición completa: `varchar(50) NOT NULL`.
- **Composición del tipo:** Texto variable, máximo declarado de 50 caracteres, sujeto al charset.
- **Formato esperado:** Texto dentro de la longitud declarada.
- **Ejemplo ilustrativo ficticio:** `Texto ficticio`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** Participa en índice UNIQUE.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `provider_method_ref` — Referencia del proveedor

- **Nombre técnico:** `provider_method_ref`
- **Nombre comprensible:** Referencia del proveedor
- **Significado:** Referencia opaca del método en el proveedor; su formato depende del proveedor.
- **Uso funcional:** Referencia opaca del método en el proveedor; su formato depende del proveedor.
- **Tipo de dato SQL:** `varchar(255)`; definición completa: `varchar(255) NOT NULL`.
- **Composición del tipo:** Texto variable, máximo declarado de 255 caracteres, sujeto al charset.
- **Formato esperado:** Texto dentro de la longitud declarada.
- **Ejemplo ilustrativo ficticio:** `Texto ficticio`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** Participa en índice UNIQUE.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `label` — Label

- **Nombre técnico:** `label`
- **Nombre comprensible:** Label
- **Significado:** Etiqueta opcional legible.
- **Uso funcional:** Etiqueta opcional legible.
- **Tipo de dato SQL:** `varchar(100)`; definición completa: `varchar(100) DEFAULT NULL`.
- **Composición del tipo:** Texto variable, máximo declarado de 100 caracteres, sujeto al charset.
- **Formato esperado:** Texto dentro de la longitud declarada.
- **Ejemplo ilustrativo ficticio:** `Texto ficticio`
- **Permite valores nulos:** Sí.
- **Es obligatorio:** No; admite NULL.
- **Valor predeterminado:** `NULL`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `last_four` — Últimos cuatro caracteres

- **Nombre técnico:** `last_four`
- **Nombre comprensible:** Últimos cuatro caracteres
- **Significado:** Cuatro caracteres opcionales; SQL no exige que sean dígitos.
- **Uso funcional:** Cuatro caracteres opcionales; SQL no exige que sean dígitos.
- **Tipo de dato SQL:** `char(4)`; definición completa: `char(4) DEFAULT NULL`.
- **Composición del tipo:** Texto de longitud fija declarada de 4 caracteres.
- **Formato esperado:** Texto dentro de la longitud declarada.
- **Ejemplo ilustrativo ficticio:** `1234`
- **Permite valores nulos:** Sí.
- **Es obligatorio:** No; admite NULL.
- **Valor predeterminado:** `NULL`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `is_default` — Predeterminado

- **Nombre técnico:** `is_default`
- **Nombre comprensible:** Predeterminado
- **Significado:** TINYINT(1) con default 0; no existe CHECK que fuerce 0/1.
- **Uso funcional:** TINYINT(1) con default 0; no existe CHECK que fuerce 0/1.
- **Tipo de dato SQL:** `tinyint(1)`; definición completa: `tinyint(1) NOT NULL DEFAULT '0'`.
- **Composición del tipo:** Entero pequeño de MySQL; apariencia booleana, pero no restringe a 0/1 sin CHECK.
- **Formato esperado:** Número entero.
- **Ejemplo ilustrativo ficticio:** `42`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** `'0'`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado; TINYINT(1) por sí solo no restringe a 0/1.
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `status` — Status

- **Nombre técnico:** `status`
- **Nombre comprensible:** Status
- **Significado:** Bandera binaria con default 1.
- **Uso funcional:** Bandera binaria con default 1.
- **Tipo de dato SQL:** `bit(1)`; definición completa: `bit(1) NOT NULL DEFAULT b'1'`.
- **Composición del tipo:** Un bit: b'0' o b'1'.
- **Formato esperado:** Valor binario del ancho declarado.
- **Ejemplo ilustrativo ficticio:** `b'1'`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** `b'1'`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** b'0', b'1' por BIT(1); significado según el campo no siempre especificado.
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `creation_date` — Fecha de creación

- **Nombre técnico:** `creation_date`
- **Nombre comprensible:** Fecha de creación
- **Significado:** Momento de alta.
- **Uso funcional:** Momento de alta.
- **Tipo de dato SQL:** `datetime`; definición completa: `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP`.
- **Composición del tipo:** Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS.
- **Formato esperado:** AAAA-MM-DD HH:MM:SS; sin zona horaria.
- **Ejemplo ilustrativo ficticio:** `2026-01-15 09:30:00`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** `CURRENT_TIMESTAMP`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `last_update` — Última actualización

- **Nombre técnico:** `last_update`
- **Nombre comprensible:** Última actualización
- **Significado:** Fecha opcional con actualización automática.
- **Uso funcional:** Fecha opcional con actualización automática.
- **Tipo de dato SQL:** `datetime`; definición completa: `datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP`.
- **Composición del tipo:** Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS.
- **Formato esperado:** AAAA-MM-DD HH:MM:SS; sin zona horaria.
- **Ejemplo ilustrativo ficticio:** `2026-01-15 09:30:00`
- **Permite valores nulos:** Sí.
- **Es obligatorio:** No; admite NULL.
- **Valor predeterminado:** `NULL`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** ON UPDATE CURRENT_TIMESTAMP.


## Tabla `tbd_users_wishlist_products`

**Descripción sencilla:** Asociación entre usuario y producto guardado, estado y fechas.
**Ejemplo cotidiano:** Lista de deseos se puede imaginar como una sección de un archivador con fichas; las tablas de asociación son como etiquetas que conectan dos fichas.
**Qué representa una fila:** Producto guardado individual.
**Cantidad de columnas:** 5
**Identificador principal:** `user_ID, product_ID` (clave compuesta).
**Relaciones declaradas:** `product_ID` → `tb_products.ID`; `user_ID` → `tb_users.ID`
**Observaciones:** definición SQL en líneas 1316–1326.

### Resumen de columnas

| Campo técnico | Significado | Tipo SQL y composición | ¿Puede quedar vacío? | Ejemplo ficticio | Restricciones y relaciones |
|---|---|---|---|---|---|
| `user_ID` | Usuario; parte de PK compuesta y FK. | `int unsigned` — Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED). | No | `42` | PK; FK `fk_user2` → `tb_users.ID` |
| `product_ID` | Producto; parte de PK compuesta y FK. | `int unsigned` — Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED). | No | `42` | PK; FK `fk_products3` → `tb_products.ID` |
| `status` | Bandera binaria con default 1. | `bit(1)` — Un bit: b'0' o b'1'. | No | `b'1'` | No especificado en el respaldo |
| `creation_date` | Momento en que se registra la relación. | `datetime` — Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS. | No | `2026-01-15 09:30:00` | No especificado en el respaldo |
| `last_update` | Actualización automática al cambiar. | `datetime` — Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS. | No | `2026-01-15 09:30:00` | ON UPDATE CURRENT_TIMESTAMP |

### Fichas individuales

#### `user_ID` — ID de usuario

- **Nombre técnico:** `user_ID`
- **Nombre comprensible:** ID de usuario
- **Significado:** Usuario; parte de PK compuesta y FK.
- **Uso funcional:** Usuario; parte de PK compuesta y FK.
- **Tipo de dato SQL:** `int unsigned`; definición completa: `int unsigned NOT NULL`.
- **Composición del tipo:** Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED).
- **Formato esperado:** Número entero no negativo.
- **Ejemplo ilustrativo ficticio:** `42`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** Sí; compuesta (`user_ID, product_ID`).
- **Clave foránea:** Sí: `fk_user2` → `tb_users.ID`
- **Restricciones:** Parte de la PRIMARY KEY. FK `fk_user2` → `tb_users.ID`.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** `fk_user2` → `tb_users.ID`
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `product_ID` — ID de producto

- **Nombre técnico:** `product_ID`
- **Nombre comprensible:** ID de producto
- **Significado:** Producto; parte de PK compuesta y FK.
- **Uso funcional:** Producto; parte de PK compuesta y FK.
- **Tipo de dato SQL:** `int unsigned`; definición completa: `int unsigned NOT NULL`.
- **Composición del tipo:** Entero sin decimales y sin signo (0 a 4,294,967,295 en MySQL INT UNSIGNED).
- **Formato esperado:** Número entero no negativo.
- **Ejemplo ilustrativo ficticio:** `42`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** No especificado en el respaldo
- **Clave primaria:** Sí; compuesta (`user_ID, product_ID`).
- **Clave foránea:** Sí: `fk_products3` → `tb_products.ID`
- **Restricciones:** Parte de la PRIMARY KEY. FK `fk_products3` → `tb_products.ID`.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** `fk_products3` → `tb_products.ID`
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `status` — Status

- **Nombre técnico:** `status`
- **Nombre comprensible:** Status
- **Significado:** Bandera binaria con default 1.
- **Uso funcional:** Bandera binaria con default 1.
- **Tipo de dato SQL:** `bit(1)`; definición completa: `bit(1) NOT NULL DEFAULT b'1'`.
- **Composición del tipo:** Un bit: b'0' o b'1'.
- **Formato esperado:** Valor binario del ancho declarado.
- **Ejemplo ilustrativo ficticio:** `b'1'`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** `b'1'`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** b'0', b'1' por BIT(1); significado según el campo no siempre especificado.
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `creation_date` — Fecha de creación

- **Nombre técnico:** `creation_date`
- **Nombre comprensible:** Fecha de creación
- **Significado:** Momento en que se registra la relación.
- **Uso funcional:** Momento en que se registra la relación.
- **Tipo de dato SQL:** `datetime`; definición completa: `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP`.
- **Composición del tipo:** Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS.
- **Formato esperado:** AAAA-MM-DD HH:MM:SS; sin zona horaria.
- **Ejemplo ilustrativo ficticio:** `2026-01-15 09:30:00`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** `CURRENT_TIMESTAMP`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** No se identifica otra limitación específica en la definición.

#### `last_update` — Última actualización

- **Nombre técnico:** `last_update`
- **Nombre comprensible:** Última actualización
- **Significado:** Actualización automática al cambiar.
- **Uso funcional:** Actualización automática al cambiar.
- **Tipo de dato SQL:** `datetime`; definición completa: `datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP`.
- **Composición del tipo:** Fecha y hora sin zona horaria embebida; formato AAAA-MM-DD HH:MM:SS.
- **Formato esperado:** AAAA-MM-DD HH:MM:SS; sin zona horaria.
- **Ejemplo ilustrativo ficticio:** `2026-01-15 09:30:00`
- **Permite valores nulos:** No.
- **Es obligatorio:** Sí; NOT NULL. Otras reglas funcionales no quedan demostradas.
- **Valor predeterminado:** `CURRENT_TIMESTAMP`
- **Clave primaria:** No.
- **Clave foránea:** No especificado en el respaldo.
- **Restricciones:** No especificado en el respaldo.
- **Valores permitidos:** No especificado en el respaldo
- **Relación con otros campos:** No especificado en el respaldo.
- **Observaciones y limitaciones:** ON UPDATE CURRENT_TIMESTAMP.


## Relaciones entre tablas

Todas las filas siguientes se respaldan en FKs del DDL. Las acciones ON DELETE y ON UPDATE no están declaradas explícitamente; InnoDB aplica su valor restrictivo predeterminado (NO ACTION equivale a RESTRICT). Una referencia a columna no única no garantiza cardinalidad uno.

| Restricción | Origen | Destino | Cardinalidad | Explicación | ON DELETE / ON UPDATE |
|---|---|---|---|---|---|
| `tb_buyer_orders_ibfk_1` | `tb_buyer_orders.seller_ID` | `tb_users.ID` | uno a muchos | Vincula `tb_buyer_orders.seller_ID` con `tb_users.ID`. | No especificadas; InnoDB predeterminado restrictivo (NO ACTION/RESTRICT) |
| `fk_carts_user` | `tb_carts.user_ID` | `tb_users.ID` | uno a uno | Vincula `tb_carts.user_ID` con `tb_users.ID`. | No especificadas; InnoDB predeterminado restrictivo (NO ACTION/RESTRICT) |
| `fk_superior_category` | `tbc_categories.sup_id_category` | `tbc_categories.ID` | uno a muchos | Vincula `tbc_categories.sup_id_category` con `tbc_categories.ID`. | No especificadas; InnoDB predeterminado restrictivo (NO ACTION/RESTRICT) |
| `tbd_carts_items_ibfk_1` | `tbd_carts_items.cart_ID` | `tb_carts.ID` | uno a muchos | Vincula `tbd_carts_items.cart_ID` con `tb_carts.ID`. | No especificadas; InnoDB predeterminado restrictivo (NO ACTION/RESTRICT) |
| `tbd_carts_items_ibfk_2` | `tbd_carts_items.provider_ID` | `tbd_products_users_providers.user_ID` | muchos a muchos posibles (destino no único) | Vincula `tbd_carts_items.provider_ID` con `tbd_products_users_providers.user_ID`. La FK apunta a una columna no única, función de compatibilidad de InnoDB; cardinalidad exacta no está garantizada. No existe FK compuesta para comprobar el par proveedor-producto. | No especificadas; InnoDB predeterminado restrictivo (NO ACTION/RESTRICT) |
| `tbd_carts_items_ibfk_3` | `tbd_carts_items.product_ID` | `tbd_products_users_providers.product_ID` | muchos a muchos posibles (destino no único) | Vincula `tbd_carts_items.product_ID` con `tbd_products_users_providers.product_ID`. La FK apunta a una columna no única, función de compatibilidad de InnoDB; cardinalidad exacta no está garantizada. No existe FK compuesta para comprobar el par proveedor-producto. | No especificadas; InnoDB predeterminado restrictivo (NO ACTION/RESTRICT) |
| `tbd_order_items_ibfk_1` | `tbd_order_items.seller_order_ID` | `tb_buyer_orders.ID` | uno a muchos | Vincula `tbd_order_items.seller_order_ID` con `tb_buyer_orders.ID`. | No especificadas; InnoDB predeterminado restrictivo (NO ACTION/RESTRICT) |
| `tbd_order_items_ibfk_2` | `tbd_order_items.product_ID` | `tbd_products_users_providers.product_ID` | muchos a muchos posibles (destino no único) | Vincula `tbd_order_items.product_ID` con `tbd_products_users_providers.product_ID`. La FK apunta a una columna no única, función de compatibilidad de InnoDB; cardinalidad exacta no está garantizada. No existe FK compuesta para comprobar el par proveedor-producto. | No especificadas; InnoDB predeterminado restrictivo (NO ACTION/RESTRICT) |
| `tbd_order_items_ibfk_3` | `tbd_order_items.provider_ID` | `tbd_products_users_providers.user_ID` | muchos a muchos posibles (destino no único) | Vincula `tbd_order_items.provider_ID` con `tbd_products_users_providers.user_ID`. La FK apunta a una columna no única, función de compatibilidad de InnoDB; cardinalidad exacta no está garantizada. No existe FK compuesta para comprobar el par proveedor-producto. | No especificadas; InnoDB predeterminado restrictivo (NO ACTION/RESTRICT) |
| `fk_category_prod` | `tbd_products_categories.category_ID` | `tbc_categories.ID` | uno a muchos | Vincula `tbd_products_categories.category_ID` con `tbc_categories.ID`. | No especificadas; InnoDB predeterminado restrictivo (NO ACTION/RESTRICT) |
| `fk_product_cat` | `tbd_products_categories.product_ID` | `tb_products.ID` | uno a muchos | Vincula `tbd_products_categories.product_ID` con `tb_products.ID`. | No especificadas; InnoDB predeterminado restrictivo (NO ACTION/RESTRICT) |
| `fk_products2` | `tbd_products_users_providers.product_ID` | `tb_products.ID` | uno a muchos | Vincula `tbd_products_users_providers.product_ID` con `tb_products.ID`. | No especificadas; InnoDB predeterminado restrictivo (NO ACTION/RESTRICT) |
| `fk_user1` | `tbd_products_users_providers.user_ID` | `tb_users.ID` | uno a muchos | Vincula `tbd_products_users_providers.user_ID` con `tb_users.ID`. | No especificadas; InnoDB predeterminado restrictivo (NO ACTION/RESTRICT) |
| `tbd_user_payment_methods_ibfk_1` | `tbd_user_payment_methods.user_ID` | `tb_users.ID` | uno a muchos | Vincula `tbd_user_payment_methods.user_ID` con `tb_users.ID`. | No especificadas; InnoDB predeterminado restrictivo (NO ACTION/RESTRICT) |
| `tbd_user_payment_methods_ibfk_2` | `tbd_user_payment_methods.payment_method_type_ID` | `tbc_payment_methods_types.ID` | uno a muchos | Vincula `tbd_user_payment_methods.payment_method_type_ID` con `tbc_payment_methods_types.ID`. | No especificadas; InnoDB predeterminado restrictivo (NO ACTION/RESTRICT) |
| `fk_products3` | `tbd_users_wishlist_products.product_ID` | `tb_products.ID` | uno a muchos | Vincula `tbd_users_wishlist_products.product_ID` con `tb_products.ID`. | No especificadas; InnoDB predeterminado restrictivo (NO ACTION/RESTRICT) |
| `fk_user2` | `tbd_users_wishlist_products.user_ID` | `tb_users.ID` | uno a muchos | Vincula `tbd_users_wishlist_products.user_ID` con `tb_users.ID`. | No especificadas; InnoDB predeterminado restrictivo (NO ACTION/RESTRICT) |

Diagrama disponible en [`relaciones_respaldo5.mmd`](./relaciones_respaldo5.mmd).

## Claves, índices y restricciones

- 13 claves primarias; son compuestas las de `tbd_carts_items`, `tbd_products_categories`, `tbd_products_users_providers` y `tbd_users_wishlist_products`.
- AUTO_INCREMENT: `tb_buyer_orders.ID`, `tb_carts.ID`, `tb_logs.ID`, `tb_products.ID`, `tb_users.ID`, `tbc_categories.ID`, `tbc_payment_methods_types.ID`, `tbd_order_items.ID`, `tbd_user_payment_methods.ID`.
- 7 UNIQUE keys, 32 índices totales contando PK/UNIQUE y 5 CHECK.
- La unicidad de SKU, email, nick, código de tipo y algunas asociaciones evita duplicados según el índice declarado.
- CHECK documentados: subtotal y shipping_cost ≥ 0; cantidad de renglón de carrito y pedido > 0; precio unitario de pedido ≥ 0.
- FKs confirman los enlaces listados; no se especifican cascadas de borrado/actualización.

### Inventario íntegro de índices y CHECK

- `tb_buyer_orders` — **PRIMARY KEY `PRIMARY`** sobre (`ID`).
- `tb_buyer_orders` — **KEY `seller_ID`** sobre (`seller_ID`).
- `tb_carts` — **PRIMARY KEY `PRIMARY`** sobre (`ID`).
- `tb_carts` — **UNIQUE KEY `uk_cart_user`** sobre (`user_ID`).
- `tb_logs` — **PRIMARY KEY `PRIMARY`** sobre (`ID`).
- `tb_products` — **PRIMARY KEY `PRIMARY`** sobre (`ID`).
- `tb_products` — **UNIQUE KEY `SKU`** sobre (`SKU`).
- `tb_users` — **PRIMARY KEY `PRIMARY`** sobre (`ID`).
- `tb_users` — **UNIQUE KEY `email`** sobre (`email`).
- `tb_users` — **UNIQUE KEY `nick`** sobre (`nick`).
- `tbc_categories` — **PRIMARY KEY `PRIMARY`** sobre (`ID`).
- `tbc_categories` — **UNIQUE KEY `name`** sobre (`name`).
- `tbc_categories` — **KEY `fk_superior_category`** sobre (`sup_id_category`).
- `tbc_payment_methods_types` — **PRIMARY KEY `PRIMARY`** sobre (`ID`).
- `tbc_payment_methods_types` — **UNIQUE KEY `code_UNIQUE`** sobre (`code`).
- `tbd_carts_items` — **PRIMARY KEY `PRIMARY`** sobre (`cart_ID`,`provider_ID`,`product_ID`).
- `tbd_carts_items` — **KEY `provider_ID`** sobre (`provider_ID`).
- `tbd_carts_items` — **KEY `product_ID`** sobre (`product_ID`).
- `tbd_order_items` — **PRIMARY KEY `PRIMARY`** sobre (`ID`).
- `tbd_order_items` — **KEY `seller_order_ID`** sobre (`seller_order_ID`).
- `tbd_order_items` — **KEY `product_ID`** sobre (`product_ID`).
- `tbd_order_items` — **KEY `provider_ID`** sobre (`provider_ID`).
- `tbd_products_categories` — **PRIMARY KEY `PRIMARY`** sobre (`category_ID`,`product_ID`).
- `tbd_products_categories` — **KEY `idx_product`** sobre (`product_ID`).
- `tbd_products_users_providers` — **PRIMARY KEY `PRIMARY`** sobre (`user_ID`,`product_ID`).
- `tbd_products_users_providers` — **KEY `fk_products2`** sobre (`product_ID`).
- `tbd_user_payment_methods` — **PRIMARY KEY `PRIMARY`** sobre (`ID`).
- `tbd_user_payment_methods` — **UNIQUE KEY `uk_provider_method`** sobre (`provider`,`provider_method_ref`).
- `tbd_user_payment_methods` — **KEY `user_ID`** sobre (`user_ID`).
- `tbd_user_payment_methods` — **KEY `payment_method_type_ID`** sobre (`payment_method_type_ID`).
- `tbd_users_wishlist_products` — **PRIMARY KEY `PRIMARY`** sobre (`user_ID`,`product_ID`).
- `tbd_users_wishlist_products` — **KEY `fk_products3`** sobre (`product_ID`).
- `tb_buyer_orders` — **CHECK `tb_buyer_orders_chk_1`**: `(`subtotal` >= 0)`.
- `tb_buyer_orders` — **CHECK `tb_buyer_orders_chk_2`**: `(`shipping_cost` >= 0)`.
- `tbd_carts_items` — **CHECK `chk_cart_quantity`**: `(`quantity` > 0)`.
- `tbd_order_items` — **CHECK `tbd_order_items_chk_1`**: `(`quantity` > 0)`.
- `tbd_order_items` — **CHECK `tbd_order_items_chk_2`**: `(`unit_price` >= 0)`.

## Vistas y lógica programada

### Vistas

| Vista | Función según SELECT final | Orígenes |
|---|---|---|
| `vw_trazabilidad_buyer_orders` | Eventos de bitácora de pedidos. | `tb_logs` |
| `vw_trazabilidad_carts_items` | Eventos de bitácora de líneas de carrito. | `tb_logs` |
| `vw_trazabilidad_categorias_productos` | Ruta jerárquica y conteos de productos por categoría. | `tb_products`, `tbd_products_categories`, `tbc_categories` |
| `vw_trazabilidad_categories` | Datos de categoría y eventos/roles; consulta mysql.role_edges. | `tbc_categories`, `tb_logs`, `mysql` |
| `vw_trazabilidad_categorizaciones` | Producto y categoría asociados. | `tb_products`, `tbc_categories` |
| `vw_trazabilidad_lista_deseos` | Eventos de bitácora de lista de deseos. | `tb_logs` |
| `vw_trazabilidad_order_items` | Eventos de bitácora de líneas de pedido. | `tb_logs` |
| `vw_trazabilidad_payment_methods_types` | Eventos de bitácora del catálogo de pagos. | `tb_logs` |
| `vw_trazabilidad_productos` | Eventos de bitácora de productos. | `tb_logs` |
| `vw_trazabilidad_productos_categorias` | Producto, categoría, estado y fechas. | `tb_products`, `tbc_categories` |
| `vw_trazabilidad_productos_proveedores` | Eventos de bitácora de asociaciones producto/proveedor. | `tb_logs` |
| `vw_trazabilidad_user_payment_methods` | Eventos de bitácora de métodos de pago. | `tb_logs` |
| `vw_trazabilidad_usuarios` | Eventos de usuario y roles; consulta mysql.role_edges. | `tb_logs`, `mysql` |

### Procedimientos almacenados

| Nombre | Parámetro | Regla definida |
|---|---|---|
| `sp_restore_product` (L1663) | `IN p_product_id INT UNSIGNED` | Valida existencia y estado; actualiza `tb_products.status` a 1 y genera SQLSTATE 45000 si no existe o ya está activo. |
| `sp_soft_delete_product` (L1705) | `IN p_product_id INT UNSIGNED` | Valida existencia y estado; actualiza `tb_products.status` a 0 (baja lógica) y genera SQLSTATE 45000 si no existe o ya está dado de baja. |

### Triggers

33 triggers AFTER INSERT/UPDATE/DELETE registran actividad en `tb_logs` para 11 tablas. `tb_logs` y `tb_carts` no tienen triggers declarados.

| Tabla | INSERT | UPDATE | DELETE |
|---|---|---|---|
| `tb_buyer_orders` | `trg_buyer_orders_after_insert` L61 | `trg_buyer_orders_after_update` L89 | `trg_buyer_orders_after_delete` L120 |
| `tb_products` | `trg_products_after_insert` L239 | `trg_products_after_update` L278 | `trg_products_after_delete` L315 |
| `tb_users` | `trg_users_after_insert` L383 | `trg_users_after_update` L421 | `trg_users_after_delete` L457 |
| `tbc_categories` | `tg_tbc_categories_after_insert` L524 | `tg_tbc_categories_after_update` L561 | `tg_tbc_categories_after_delete` L597 |
| `tbc_payment_methods_types` | `trg_payment_methods_types_after_insert` L659 | `trg_payment_methods_types_after_update` L685 | `trg_payment_methods_types_after_delete` L712 |
| `tbd_carts_items` | `trg_carts_items_after_insert` L770 | `trg_carts_items_after_update` L796 | `trg_carts_items_after_delete` L822 |
| `tbd_order_items` | `trg_order_items_after_insert` L886 | `trg_order_items_after_update` L916 | `trg_order_items_after_delete` L946 |
| `tbd_products_categories` | `trg_products_categories_after_insert` L1005 | `trg_products_categories_after_update` L1028 | `trg_products_categories_after_delete` L1052 |
| `tbd_products_users_providers` | `trg_products_users_providers_after_insert` L1106 | `trg_products_users_providers_after_update` L1131 | `trg_products_users_providers_after_delete` L1159 |
| `tbd_user_payment_methods` | `trg_user_payment_methods_after_insert` L1221 | `trg_user_payment_methods_after_update` L1250 | `trg_user_payment_methods_after_delete` L1288 |
| `tbd_users_wishlist_products` | `trg_users_wishlist_products_after_insert` L1346 | `trg_users_wishlist_products_after_update` L1369 | `trg_users_wishlist_products_after_delete` L1393 |

- Funciones: ninguna encontrada.
- Eventos: ninguno encontrado.
- Vistas, triggers y procedimientos declaran `DEFINER=root@localhost`; la cuenta/privilegios pueden ser dependencia al restaurar.
- Algunas vistas dependen de `mysql.role_edges`, con requisitos de permisos/versión del servidor.
- El campo `password` no declara protección criptográfica; la columna solo tiene tipo VARCHAR(255).

## Datos INSERT del respaldo

La fuente incluye 5 sentencias de carga directa con 10,036 filas: `tb_logs` (5,022), `tb_products` (5,007), `tb_users` (7). Las restantes tablas físicas no tienen INSERT de datos en este respaldo. No se copian valores reales; las cifras son conteos, no contenido.

## Reglas confirmadas, inferencias y dudas

### Confirmado por SQL

- ENUM de estado de pedido: `Pending`, `Accepted`, `Preparing`, `Sent`, `Delivered`, `Canceled`, `Returned`; default `Pending`.
- ENUM de operación de bitácora: `Create`, `Read`, `Update`, `Delete`; puede ser NULL.
- ENUM `type_ownership`: `Owner`, `Reseller`, `Distributor`; permite NULL.
- Las CHECK se detallan junto a las columnas y abajo; `tbd_order_items.subtotal` es generado/almacenado.
- Procedimientos de producto implementan baja lógica/restauración mediante `status`.
- UNIQUE de `tb_carts.user_ID` implementa máximo un carrito por usuario.

### Inferencias / preguntas pendientes

| Tabla/campo | Conocido | Falta / por qué importa | Pregunta concreta |
|---|---|---|---|
| `tb_users.password` | VARCHAR(255) obligatorio. | Mecanismo de hash/cifrado no se define; crítico para cuentas. | ¿Qué formato seguro se almacena y cómo se verifica? |
| `tb_buyer_orders.seller_ID` | FK a usuario; nombre indica seller. | No se demuestra si es comprador o vendedor. | ¿Qué rol tiene ese usuario en el pedido? |
| Importes/precios | DECIMAL; algunas reglas CHECK. | Moneda, impuestos, redondeo y suma no definidos. | ¿Qué moneda y fórmula de total utiliza el sistema? |
| Campos `status` / `is_default` | Bits/tinyint y defaults. | Etiquetas y estados permitidos no están definidos por completo. | ¿Qué representa cada valor y puede haber varios métodos predeterminados? |
| `type_ownership` | Enum de tres roles. | Efectos de permisos/negocio no documentados. | ¿Qué diferencia operativa hay entre Owner, Reseller y Distributor? |
| FKs proveedor-producto de detalles | Dos FKs separadas a columnas no únicas de la tabla puente. | No prueba que product_ID y provider_ID correspondan al mismo par. | ¿Se debe asegurar ese par con una FK compuesta? |
| `avalaible_date` | DATETIME NOT NULL; nombre exacto conserva typo. | Inicio, fin o fecha de disponibilidad desconocida. | ¿Qué evento fecha y en qué zona horaria? |
| Vistas que usan `mysql.role_edges` | Vista consulta una tabla del esquema de sistema. | Acceso/restauración portátil. | ¿Debe conservarse esta consulta a metadatos del servidor? |
| `DEFINER=root@localhost` | Está declarado en objetos. | Puede no existir en entorno destino. | ¿Qué definidor debe usarse al restaurar? |

## Glosario

- **Base de datos:** archivador general de información. **Tabla:** grupo de fichas semejantes. **Fila/registro:** una ficha. **Columna/campo:** dato de cada ficha.
- **Tipo de dato:** valores/formatos que acepta una columna. **NULL:** valor ausente, distinto de cero o texto vacío. **Valor predeterminado:** valor que MySQL aporta si se omite un campo.
- **Clave primaria (PK):** identifica cada fila; una compuesta usa varias columnas. **Clave foránea (FK):** declara una conexión con otra columna. **Integridad referencial:** coherencia de esa conexión.
- **Índice:** acceso auxiliar; UNIQUE además impide duplicados. **Restricción:** regla como NOT NULL, CHECK, FK o UNIQUE. **Relación:** vínculo entre tablas.
- **AUTO_INCREMENT:** identificador numérico asignado por el motor. **Precisión/escala:** en DECIMAL(p,s), p cuenta dígitos totales y s los decimales. **ENUM:** lista fija de textos.
- **Vista:** consulta guardada. **Procedimiento:** rutina SQL invocable. **Trigger:** rutina automática ante un evento. **Columna generada:** valor calculado por el motor.

## Matriz de cobertura

| Elemento | Detectado en SQL | Documentado | Pendiente |
|---|---:|---:|---:|
| Tablas | 13 | 13 | 0 |
| Columnas | 92 | 92 | 0 |
| Claves primarias | 13 | 13 | 0 |
| Claves foráneas | 17 | 17 | 0 |
| Índices | 32 | 32 | 0 |
| CHECK | 5 | 5 | 0 |
| Vistas | 13 | 13 | 0 |
| Procedimientos | 2 | 2 | 0 |
| Funciones | 0 | 0 | 0 |
| Triggers | 33 | 33 | 0 |
| Eventos | 0 | 0 | 0 |

Los ALTER TABLE DISABLE/ENABLE KEYS del dump rodean la carga y no agregan definiciones nuevas.

## Metadatos

- SHA-256 respaldo: `7a0da21a0ba926d59e1c588482c13786c0201cacb8854a8c8ddc6a4c709b3ad0`.
- Revisión del repositorio: `3d83d5b9280629cae7c71c32268bb1140c6cc31b`.
- Los valores ilustrativos no provienen de los INSERT reales.
