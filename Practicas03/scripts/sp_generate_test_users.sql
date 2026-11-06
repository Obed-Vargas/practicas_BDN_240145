USE `db_test_7b`;

DELIMITER $$

CREATE PROCEDURE `sp_generate_test_users`(
    IN p_scenario varchar(32)
)
SQL SECURITY INVOKER
MODIFIES SQL DATA
BEGIN
    DECLARE v_scenario varchar(32);
    DECLARE v_total int unsigned;
    DECLARE v_inserted int unsigned DEFAULT 0;
    DECLARE v_active_count int unsigned DEFAULT NULL;
    DECLARE v_inactive_count int unsigned DEFAULT NULL;
    DECLARE v_age_valid_count int unsigned DEFAULT NULL;
    DECLARE v_country_count int unsigned DEFAULT 0;
    DECLARE v_attempt tinyint unsigned DEFAULT 0;
    DECLARE v_duplicate_key boolean DEFAULT FALSE;
    DECLARE v_transaction_started boolean DEFAULT FALSE;
    DECLARE v_now datetime;
    DECLARE v_catalog json;
    DECLARE v_birth_start date;
    DECLARE v_birth_end date;
    DECLARE v_birth_span int unsigned;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        IF v_transaction_started THEN
            ROLLBACK;
        END IF;
        RESIGNAL;
    END;

    SET v_scenario = UPPER(TRIM(p_scenario));

    IF v_scenario IS NULL OR v_scenario NOT IN
       ('USA_500', 'INTERNATIONAL_2000', 'STATUS_5000') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Escenario invalido: usa USA_500, INTERNATIONAL_2000 o STATUS_5000.';
    END IF;

    SET v_total = CASE v_scenario
        WHEN 'USA_500' THEN 500
        WHEN 'INTERNATIONAL_2000' THEN 2000
        WHEN 'STATUS_5000' THEN 5000
    END;
    SET v_now = CURRENT_TIMESTAMP;

    /* Catalogos locales: no se crean tablas ni se persisten estos datos. */
    SET v_catalog = JSON_ARRAY(
        JSON_OBJECT('country_code', 'US',
            'first_names', JSON_ARRAY(
                JSON_OBJECT('name','Olivia','gender','mujer'), JSON_OBJECT('name','Noah','gender','hombre'),
                JSON_OBJECT('name','Ava','gender','mujer'), JSON_OBJECT('name','Ethan','gender','hombre'),
                JSON_OBJECT('name','Sophia','gender','mujer'), JSON_OBJECT('name','Benjamin','gender','hombre'),
                JSON_OBJECT('name','Harper','gender','mujer'), JSON_OBJECT('name','Alexander','gender','hombre'),
                JSON_OBJECT('name','Evelyn','gender','mujer'), JSON_OBJECT('name','Daniel','gender','hombre'),
                JSON_OBJECT('name','Abigail','gender','mujer'), JSON_OBJECT('name','Henry','gender','hombre'),
                JSON_OBJECT('name','Ella','gender','mujer'), JSON_OBJECT('name','Jackson','gender','hombre'),
                JSON_OBJECT('name','Grace','gender','mujer'), JSON_OBJECT('name','Samuel','gender','hombre'),
                JSON_OBJECT('name','Madison','gender','mujer'), JSON_OBJECT('name','Owen','gender','hombre'),
                JSON_OBJECT('name','Lily','gender','mujer'), JSON_OBJECT('name','Wyatt','gender','hombre'),
                JSON_OBJECT('name','Natalie','gender','mujer'), JSON_OBJECT('name','Caleb','gender','hombre'),
                JSON_OBJECT('name','Zoe','gender','mujer'), JSON_OBJECT('name','Isaac','gender','hombre')
            ),
            'family_names', JSON_ARRAY(
                'Bennett','Brooks','Collins','Carter','Reed','Hayes','Morgan','Perry',
                'Foster','Ward','Powell','Long','Simmons','Butler','Peterson','Price',
                'Cooper','Gray','James','Bell','Bailey','Murphy','Kelly','Rivera'
            )
        ),
        JSON_OBJECT('country_code', 'MX',
            'first_names', JSON_ARRAY(
                JSON_OBJECT('name','Camila','gender','mujer'), JSON_OBJECT('name','Mateo','gender','hombre'),
                JSON_OBJECT('name','Valeria','gender','mujer'), JSON_OBJECT('name','Santiago','gender','hombre'),
                JSON_OBJECT('name','Renata','gender','mujer'), JSON_OBJECT('name','Emiliano','gender','hombre'),
                JSON_OBJECT('name','Natalia','gender','mujer'), JSON_OBJECT('name','Sebastian','gender','hombre')
            ),
            'family_names', JSON_ARRAY('Torres','Hernandez','Rios','Cruz','Flores','Mendoza','Vargas','Morales')
        ),
        JSON_OBJECT('country_code', 'CA',
            'first_names', JSON_ARRAY(
                JSON_OBJECT('name','Olivia','gender','mujer'), JSON_OBJECT('name','Liam','gender','hombre'),
                JSON_OBJECT('name','Chloe','gender','mujer'), JSON_OBJECT('name','Noah','gender','hombre'),
                JSON_OBJECT('name','Amelia','gender','mujer'), JSON_OBJECT('name','Ethan','gender','hombre'),
                JSON_OBJECT('name','Sophie','gender','mujer'), JSON_OBJECT('name','Lucas','gender','hombre')
            ),
            'family_names', JSON_ARRAY('Martin','Wilson','Campbell','Tremblay','Thompson','Anderson','Gagnon','Brown')
        ),
        JSON_OBJECT('country_code', 'BR',
            'first_names', JSON_ARRAY(
                JSON_OBJECT('name','Ana','gender','mujer'), JSON_OBJECT('name','Lucas','gender','hombre'),
                JSON_OBJECT('name','Beatriz','gender','mujer'), JSON_OBJECT('name','Gabriel','gender','hombre'),
                JSON_OBJECT('name','Mariana','gender','mujer'), JSON_OBJECT('name','Rafael','gender','hombre'),
                JSON_OBJECT('name','Isabela','gender','mujer'), JSON_OBJECT('name','Pedro','gender','hombre')
            ),
            'family_names', JSON_ARRAY('Costa','Silva','Lima','Souza','Oliveira','Pereira','Almeida','Ferreira')
        ),
        JSON_OBJECT('country_code', 'AR',
            'first_names', JSON_ARRAY(
                JSON_OBJECT('name','Lucia','gender','mujer'), JSON_OBJECT('name','Mateo','gender','hombre'),
                JSON_OBJECT('name','Martina','gender','mujer'), JSON_OBJECT('name','Tomas','gender','hombre'),
                JSON_OBJECT('name','Sofia','gender','mujer'), JSON_OBJECT('name','Nicolas','gender','hombre'),
                JSON_OBJECT('name','Catalina','gender','mujer'), JSON_OBJECT('name','Joaquin','gender','hombre')
            ),
            'family_names', JSON_ARRAY('Romero','Gonzalez','Alvarez','Fernandez','Benitez','Herrera','Castro','Diaz')
        ),
        JSON_OBJECT('country_code', 'ES',
            'first_names', JSON_ARRAY(
                JSON_OBJECT('name','Lucia','gender','mujer'), JSON_OBJECT('name','Hugo','gender','hombre'),
                JSON_OBJECT('name','Sofia','gender','mujer'), JSON_OBJECT('name','Daniel','gender','hombre'),
                JSON_OBJECT('name','Paula','gender','mujer'), JSON_OBJECT('name','Adrian','gender','hombre'),
                JSON_OBJECT('name','Carmen','gender','mujer'), JSON_OBJECT('name','Pablo','gender','hombre')
            ),
            'family_names', JSON_ARRAY('Garcia','Navarro','Molina','Vega','Ortega','Serrano','Delgado','Iglesias')
        ),
        JSON_OBJECT('country_code', 'FR',
            'first_names', JSON_ARRAY(
                JSON_OBJECT('name','Camille','gender','mujer'), JSON_OBJECT('name','Jules','gender','hombre'),
                JSON_OBJECT('name','Lea','gender','mujer'), JSON_OBJECT('name','Louis','gender','hombre'),
                JSON_OBJECT('name','Manon','gender','mujer'), JSON_OBJECT('name','Arthur','gender','hombre'),
                JSON_OBJECT('name','Chloe','gender','mujer'), JSON_OBJECT('name','Theo','gender','hombre')
            ),
            'family_names', JSON_ARRAY('Laurent','Bernard','Moreau','Dubois','Petit','Robert','Richard','Durand')
        ),
        JSON_OBJECT('country_code', 'DE',
            'first_names', JSON_ARRAY(
                JSON_OBJECT('name','Mia','gender','mujer'), JSON_OBJECT('name','Leon','gender','hombre'),
                JSON_OBJECT('name','Lena','gender','mujer'), JSON_OBJECT('name','Felix','gender','hombre'),
                JSON_OBJECT('name','Emma','gender','mujer'), JSON_OBJECT('name','Paul','gender','hombre'),
                JSON_OBJECT('name','Clara','gender','mujer'), JSON_OBJECT('name','Jonas','gender','hombre')
            ),
            'family_names', JSON_ARRAY('Schneider','Weber','Wagner','Fischer','Hoffmann','Schulz','Koch','Richter')
        ),
        JSON_OBJECT('country_code', 'IT',
            'first_names', JSON_ARRAY(
                JSON_OBJECT('name','Giulia','gender','mujer'), JSON_OBJECT('name','Luca','gender','hombre'),
                JSON_OBJECT('name','Sofia','gender','mujer'), JSON_OBJECT('name','Matteo','gender','hombre'),
                JSON_OBJECT('name','Aurora','gender','mujer'), JSON_OBJECT('name','Andrea','gender','hombre'),
                JSON_OBJECT('name','Alice','gender','mujer'), JSON_OBJECT('name','Marco','gender','hombre')
            ),
            'family_names', JSON_ARRAY('Romano','Rossi','Ricci','Conti','Marino','Greco','Bruno','Gallo')
        ),
        JSON_OBJECT('country_code', 'JP',
            'first_names', JSON_ARRAY(
                JSON_OBJECT('name','Yui','gender','mujer'), JSON_OBJECT('name','Haruto','gender','hombre'),
                JSON_OBJECT('name','Aoi','gender','mujer'), JSON_OBJECT('name','Ren','gender','hombre'),
                JSON_OBJECT('name','Hina','gender','mujer'), JSON_OBJECT('name','Sota','gender','hombre'),
                JSON_OBJECT('name','Mei','gender','mujer'), JSON_OBJECT('name','Yuto','gender','hombre')
            ),
            'family_names', JSON_ARRAY('Tanaka','Sato','Ito','Suzuki','Yamamoto','Nakamura','Kobayashi','Kato')
        ),
        JSON_OBJECT('country_code', 'IN',
            'first_names', JSON_ARRAY(
                JSON_OBJECT('name','Ananya','gender','mujer'), JSON_OBJECT('name','Aarav','gender','hombre'),
                JSON_OBJECT('name','Diya','gender','mujer'), JSON_OBJECT('name','Arjun','gender','hombre'),
                JSON_OBJECT('name','Isha','gender','mujer'), JSON_OBJECT('name','Vivaan','gender','hombre'),
                JSON_OBJECT('name','Kavya','gender','mujer'), JSON_OBJECT('name','Reyansh','gender','hombre')
            ),
            'family_names', JSON_ARRAY('Patel','Sharma','Gupta','Rao','Mehta','Singh','Nair','Iyer')
        ),
        JSON_OBJECT('country_code', 'AU',
            'first_names', JSON_ARRAY(
                JSON_OBJECT('name','Charlotte','gender','mujer'), JSON_OBJECT('name','Oliver','gender','hombre'),
                JSON_OBJECT('name','Isla','gender','mujer'), JSON_OBJECT('name','Jack','gender','hombre'),
                JSON_OBJECT('name','Mia','gender','mujer'), JSON_OBJECT('name','Thomas','gender','hombre'),
                JSON_OBJECT('name','Ruby','gender','mujer'), JSON_OBJECT('name','William','gender','hombre')
            ),
            'family_names', JSON_ARRAY('Wilson','Taylor','Bennett','Murphy','Anderson','Robinson','Campbell','Mitchell')
        )
    );

    SET v_attempt = 0;

    IF v_scenario = 'INTERNATIONAL_2000' THEN
        SET v_birth_start = DATE_ADD(
            DATE_SUB(CURRENT_DATE, INTERVAL 36 YEAR), INTERVAL 1 DAY
        );
        SET v_birth_end = DATE_SUB(CURRENT_DATE, INTERVAL 19 YEAR);
        SET v_birth_span = DATEDIFF(v_birth_end, v_birth_start) + 1;

        WITH `digits` AS (
            SELECT 0 AS `d` UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL
            SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL
            SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
        ),
        `numbers` AS (
            SELECT 1 + d0.`d` + 10 * d1.`d` + 100 * d2.`d` + 1000 * d3.`d` AS `seq`
            FROM `digits` AS d0
            CROSS JOIN `digits` AS d1
            CROSS JOIN `digits` AS d2
            CROSS JOIN `digits` AS d3
        ),
        `synthetic_birthdays` AS (
            SELECT DATE_ADD(
                       v_birth_start,
                       INTERVAL MOD(CRC32(CONCAT(UUID(), ':', `seq`)), v_birth_span) DAY
                   ) AS `birth_date`
            FROM `numbers`
            WHERE `seq` <= v_total
        )
        SELECT COUNT(*) INTO v_age_valid_count
        FROM `synthetic_birthdays`
        WHERE TIMESTAMPDIFF(YEAR, `birth_date`, CURRENT_DATE) BETWEEN 19 AND 35;

        IF v_age_valid_count <> v_total THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'No se pudieron validar todas las edades de 19 a 35 anos.';
        END IF;
    END IF;

    IF v_scenario = 'STATUS_5000' THEN
        SET v_active_count = 4000;
        SET v_inactive_count = 1000;
    END IF;

    SELECT COUNT(*) INTO v_country_count
    FROM JSON_TABLE(
        v_catalog,
        '$[*]' COLUMNS (
            `country_code` char(2) PATH '$.country_code'
        )
    ) AS `catalog_countries`
    WHERE v_scenario <> 'USA_500' OR `country_code` = 'US';

    IF v_country_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El catalogo no tiene paises para el escenario solicitado.';
    END IF;

    insert_retry: LOOP
    SET v_duplicate_key = FALSE;
    START TRANSACTION;
    SET v_transaction_started = TRUE;

    BEGIN
    DECLARE CONTINUE HANDLER FOR 1062 SET v_duplicate_key = TRUE;

    INSERT INTO `tb_users`
        (`email`, `nick`, `password`, `creation_date`, `last_update`, `last_login`, `status`)
    WITH `digits` AS (
        SELECT 0 AS `d` UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL
        SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL
        SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
    ),
    `numbers` AS (
        SELECT 1 + d0.`d` + 10 * d1.`d` + 100 * d2.`d` + 1000 * d3.`d` AS `seq`
        FROM `digits` AS d0
        CROSS JOIN `digits` AS d1
        CROSS JOIN `digits` AS d2
        CROSS JOIN `digits` AS d3
    ),
    `country_pool` AS (
        SELECT `country_no`, `country_code`
        FROM JSON_TABLE(
            v_catalog,
            '$[*]' COLUMNS (
                `country_no` FOR ORDINALITY,
                `country_code` char(2) PATH '$.country_code'
            )
        ) AS `catalog_countries`
        WHERE v_scenario <> 'USA_500' OR `country_code` = 'US'
    ),
    `numbered` AS (
        SELECT `seq`
        FROM `numbers`
        WHERE `seq` <= v_total
    ),
    `country_rows` AS (
        SELECT
            n.`seq`,
            c.`country_no`,
            c.`country_code`,
            FLOOR(RAND() * JSON_LENGTH(JSON_EXTRACT(
                v_catalog, CONCAT('$[', c.`country_no` - 1, '].first_names')
            ))) AS `first_index`,
            FLOOR(RAND() * JSON_LENGTH(JSON_EXTRACT(
                v_catalog, CONCAT('$[', c.`country_no` - 1, '].family_names')
            ))) AS `family_index`,
            FLOOR(RAND() * 94608001) AS `creation_offset`,
            FLOOR(RAND() * 100) AS `update_roll`,
            FLOOR(RAND() * 100) AS `login_roll`,
            FLOOR(RAND() * 100) AS `status_roll`,
            LOWER(LEFT(REPLACE(UUID(), '-', ''), 12)) AS `email_suffix`,
            LOWER(LEFT(REPLACE(UUID(), '-', ''), 12)) AS `nick_suffix`
        FROM `numbered` AS n
        JOIN `country_pool` AS c
          ON c.`country_no` = 1 + MOD(n.`seq` - 1, v_country_count)
    ),
    `named_rows` AS (
        SELECT
            r.`seq`,
            r.`country_code`,
            r.`creation_offset`,
            r.`update_roll`,
            r.`login_roll`,
            r.`status_roll`,
            JSON_UNQUOTE(JSON_EXTRACT(
                v_catalog,
                CONCAT('$[', r.`country_no` - 1, '].first_names[', r.`first_index, '].name')
            )) AS `given_name`,
            JSON_UNQUOTE(JSON_EXTRACT(
                v_catalog,
                CONCAT('$[', r.`country_no` - 1, '].first_names[', r.`first_index, '].gender')
            )) AS `gender`,
            JSON_UNQUOTE(JSON_EXTRACT(
                v_catalog,
                CONCAT('$[', r.`country_no` - 1, '].family_names[', r.`family_index, ']')
            )) AS `family_name`
        FROM `country_rows` AS r
    ),
    `account_rows` AS (
        SELECT
            `seq`,
            `given_name`,
            `family_name`,
            `creation_offset`,
            `update_roll`,
            `login_roll`,
            `status_roll`,
            CASE
                WHEN v_scenario = 'STATUS_5000' AND `seq` <= 4000 THEN b'1'
                WHEN v_scenario = 'STATUS_5000' THEN b'0'
                WHEN `status_roll` < 90 THEN b'1'
                ELSE b'0'
            END AS `account_status`
        FROM `named_rows`
    )
    SELECT
        LOWER(CONCAT(`given_name`, '.', `family_name`, '.', LPAD(`seq`, 4, '0'),
                     '.', `email_suffix`, '@example.com')),
        LOWER(CONCAT(`given_name`, '.', `family_name`, '.', LPAD(`seq`, 4, '0'),
                     '.', `nick_suffix`)),
        MD5('TestOnly!2026'),
        DATE_SUB(v_now, INTERVAL `creation_offset` SECOND),
        CASE
            WHEN `update_roll` < 20 THEN
                DATE_SUB(v_now, INTERVAL FLOOR(RAND() * (`creation_offset` + 1)) SECOND)
            ELSE NULL
        END,
        CASE
            WHEN `account_status` = b'1' THEN
                DATE_SUB(v_now, INTERVAL FLOOR(RAND() * (`creation_offset` + 1)) SECOND)
            ELSE NULL
        END,
        `account_status`
    FROM `account_rows`
    ORDER BY `seq`;

    IF NOT v_duplicate_key THEN
        SET v_inserted = ROW_COUNT();
    END IF;
    END;

    IF v_duplicate_key THEN
        ROLLBACK;
        SET v_transaction_started = FALSE;

        IF v_attempt >= 5 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Colision de correo o nick tras cinco reintentos.';
        END IF;

        SET v_attempt = v_attempt + 1;
    ELSE

        IF v_inserted <> v_total THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'La cantidad insertada no coincide con el escenario solicitado.';
        END IF;

        IF v_scenario = 'STATUS_5000'
           AND (v_active_count <> 4000 OR v_inactive_count <> 1000) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'La distribucion de estados no coincide con 4000 activos y 1000 inactivos.';
        END IF;

        COMMIT;
        SET v_transaction_started = FALSE;
        LEAVE insert_retry;
    END IF;
    END LOOP;

    SELECT
        v_scenario AS `scenario`,
        v_total AS `requested_count`,
        v_inserted AS `inserted_count`,
        v_active_count AS `active_count`,
        v_inactive_count AS `inactive_count`,
        v_country_count AS `generated_country_count`,
        v_age_valid_count AS `international_ages_19_to_35_validated`,
        'batch_history_birth_date_and_country_are_not_stored' AS `storage_limitation`;
END$$

DELIMITER ;