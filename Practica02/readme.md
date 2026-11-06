# Práctica 02 - Conexiones remotas para base de datos SQL

## Descripción

En esta práctica trabajé con la configuración y administración de conexiones remotas a una base de datos MySQL, así como con la asignación de usuarios, roles y privilegios para controlar accesos desde distintas fuentes de red o Internet.

También realicé consultas de verificación para confirmar que los usuarios, roles, permisos y registros quedaron correctamente configurados en la base de datos `db_test_7b`.

## Objetivo

Aprender a:

- Crear usuarios remotos en MySQL.
- Asignar permisos a nivel global y por base de datos.
- Definir roles y otorgar privilegios por rol.
- Configurar usuarios con accesos específicos según su función.
- Verificar la operación de la base de datos mediante consultas SQL.
- Cargar datos de prueba en tablas y respaldar la base de datos.

## Contenido de la práctica

### 1. Creación de usuarios remotos y privilegios

Se creó un conjunto de usuarios remotos con distintos permisos para simular un entorno de administración de datos con acceso desde origenes remotos.

Archivos relacionados:

- `scripts/remote_users_privileges_creation.sql`

Entre los usuarios configurados se encuentran:

- `marco.ramirez`
- `obed.vargas`
- `osmar.ortega`
- `yaneth.garrido`
- `jorge.eloy`

También se asignaron roles como:

- `superadmin`
- `admin`
- `seller`
- `buyer`
- `support`
- `common`
- `user_not_registered`

Se habilitó el uso de `LOAD DATA LOCAL INFILE` y se otorgaron permisos necesarios para la carga de archivos locales.

### 2. Consultas de verificación

Se desarrollaron consultas para validar lo siguiente:

- Número de tablas en la base de datos.
- Número de triggers.
- Cantidad de registros en `tb_users` y `tb_logs`.
- Operaciones registradas en la bitácora.
- Usuarios creados en MySQL.
- Roles existentes.
- Relación entre usuarios y roles.
- Procedimientos almacenados presentes.
- Conteo y trazabilidad de productos.

Archivo relacionado:

- `queries/consultas_verificacion.sql`

### 3. Carga masiva de productos

Se preparó una carga de datos para insertar 5,000 productos en la tabla `tb_products` mediante un archivo CSV.

Archivos relacionados:

- `seeds/carga_5k_productos_seller2.sql`
- `seeds/productos_5000.csv`

Esto permitió practicar la importación de datos locales con MySQL y confirmar la funcionalidad del rol de vendedor.

### 4. Respaldos de la base de datos

Se almacenaron copias de respaldo de la base de datos para fines de recuperación y respaldo.

Archivos relacionados:

- `backups/db_test_7b copy.sql`
- `backups/respaldo1.sql`
- `backups/respaldo2.sql`
- `backups/respaldo3.sql`
- `backups/respaldo4.sql`
- `backups/respaldo5.sql`

## Estructura de la carpeta

```text
Practica02/
├── backups/
│   ├── db_test_7b copy.sql
│   ├── respaldo1.sql
│   ├── respaldo2.sql
│   ├── respaldo3.sql
│   ├── respaldo4.sql
│   └── respaldo5.sql
├── queries/
│   └── consultas_verificacion.sql
├── scripts/
│   └── remote_users_privileges_creation.sql
├── seeds/
│   ├── carga_5k_productos_seller2.sql
│   └── productos_5000.csv
└── README.md
```

## Resultado

La práctica quedó concluida con la configuración de acceso remoto, la administración de roles y permisos, la validación de la base de datos y la carga de datos de prueba. También quedó documentado el trabajo realizado para futuras consultas o repeticiones de la práctica.

## Estado

✅ Concluida
