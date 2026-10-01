CREATE DATABASE  IF NOT EXISTS `db_test_7b` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `db_test_7b`;
-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: db_test_7b
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `tb_logs`
--

DROP TABLE IF EXISTS `tb_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_logs` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `table_name` varchar(80) NOT NULL,
  `table_operation` enum('Create','Read','Update','Delete') DEFAULT NULL,
  `db_users` varchar(80) NOT NULL,
  `operation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `table_description` text NOT NULL,
  `operation_status` bit(1) DEFAULT b'1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_logs`
--

LOCK TABLES `tb_logs` WRITE;
/*!40000 ALTER TABLE `tb_logs` DISABLE KEYS */;
INSERT INTO `tb_logs` VALUES (1,'tb_users','Create','root@localhost','2026-09-10 10:11:26','Usuario creado. ID=4,EMAIL=240145@utxicotepec.edu.mx,nick=240145-Obed,creation_date=2026-09-10 10:11:26,status=',_binary ''),(2,'tb_users','Create','root@localhost','2026-09-10 10:15:56','Usuario creado. ID=5,EMAIL=240146@utxicotepec.edu.mx,nick=240146-Jimena,creation_date=2026-09-10 10:15:56,status=',_binary ''),(3,'tb_users','Create','root@localhost','2026-09-10 10:16:07','Usuario creado. ID=6,EMAIL=240147@utxicotepec.edu.mx,nick=240147-Jorge,creation_date=2026-09-10 10:16:07,status=',_binary ''),(4,'tb_users','Create','jorge.eloy@DESKTOP-PC3TGIH','2026-09-10 10:54:33','Usuario creado. ID=7,EMAIL=sus@gmail,nick=su,creation_date=2026-09-10 10:54:33,status=',_binary ''),(5,'tb_users','Create','jorge.eloy@DESKTOP-PC3TGIH','2026-09-10 10:55:30','Usuario creado. ID=8,EMAIL=asusena@gmail,nick=susy,creation_date=2026-09-10 10:55:30,status=',_binary ''),(6,'tb_users','Create','jorge.eloy@DESKTOP-PC3TGIH','2026-09-10 10:56:06','Usuario creado. ID=9,EMAIL=Jorge@gmail.com,nick=JorgeEloy,creation_date=2026-09-10 10:56:06,status=',_binary ''),(7,'tb_users','Update','root@localhost','2026-09-10 11:20:34','Usuario modificado. ID=4 | Anterior Nick=240145-Obed -> Nuevo Nick=Obed-Updated | Anterior Email=240145@utxicotepec.edu.mx -> Nuevo Email=240145@utxicotepec.edu.mx',_binary ''),(8,'tb_users','Delete','root@localhost','2026-09-10 11:20:41','Usuario eliminado. ID=5,EMAIL=240146@utxicotepec.edu.mx,nick=240146-Jimena',_binary ''),(9,'tb_users','Update','jorge.eloy@DESKTOP-PC3TGIH','2026-09-10 11:21:32','Usuario modificado. ID=8 | Anterior Nick=susy -> Nuevo Nick=JorgeEloyDev | Anterior Email=asusena@gmail -> Nuevo Email=jorge.eloy@gmail.com',_binary ''),(10,'tb_users','Delete','jorge.eloy@DESKTOP-PC3TGIH','2026-09-10 11:22:17','Usuario eliminado. ID=9,EMAIL=Jorge@gmail.com,nick=JorgeEloy',_binary ''),(11,'tb_users','Create','yaneth.garrido@PC-03','2026-09-17 10:58:38','Usuario creado. ID=10,EMAIL=obed@example.com,nick=obedV,creation_date=2026-09-17 10:58:38,status=',_binary ''),(12,'tb_users','Create','yaneth.garrido@PC-03','2026-09-17 10:58:38','Usuario creado. ID=11,EMAIL=yaneth@example.com,nick=YG,creation_date=2026-09-17 10:58:38,status=',_binary ''),(13,'tb_users','Create','yaneth.garrido@PC-03','2026-09-17 10:58:38','Usuario creado. ID=12,EMAIL=dorian@example.com,nick=dorianV,creation_date=2026-09-17 10:58:38,status=',_binary ''),(14,'tb_products','Create','root@localhost','2026-09-17 11:21:27','Producto creado. ID=1,SKU=PROD-001,name=Smartphone Galaxy S23,price=15000.00,stock=10,status=',_binary ''),(15,'tb_products','Create','root@localhost','2026-09-17 11:22:16','Producto creado. ID=2,SKU=PROD-02,name=Smartphone Galaxy S26 ultra,price=36000.00,stock=10,status=',_binary ''),(16,'tb_products','Create','osmar.ortega@PC-05','2026-09-17 13:06:35','Producto creado. ID=3,SKU=PROD-003,name=Audífonos Bluetooth,price=850.00,stock=20,status=',_binary ''),(17,'tb_products','Create','osmar.ortega@PC-05','2026-09-17 13:06:35','Producto creado. ID=4,SKU=PROD-004,name=Teclado Mecánico,price=1200.00,stock=15,status=',_binary ''),(18,'tb_products','Create','osmar.ortega@PC-05','2026-09-17 13:06:35','Producto creado. ID=5,SKU=PROD-005,name=Mouse Gamer,price=650.00,stock=25,status=',_binary ''),(19,'tb_products','Create','osmar.ortega@PC-05','2026-09-17 13:06:35','Producto creado. ID=6,SKU=PROD-006,name=Monitor 24 Pulgadas,price=3200.00,stock=12,status=',_binary ''),(20,'tb_products','Create','osmar.ortega@PC-05','2026-09-17 13:06:35','Producto creado. ID=7,SKU=PROD-007,name=Bocina Bluetooth,price=1100.00,stock=18,status=',_binary ''),(21,'tb_products','Update','root@localhost','2026-09-17 13:24:12','Producto modificado. ID=6 | Nombre: Monitor 24 Pulgadas -> Monitor 24 Pulgadas | Precio: 3200.00 -> 3200.00 | Stock: 12 -> 12',_binary ''),(22,'tb_products','Update','root@localhost','2026-09-17 13:25:03','Producto modificado. ID=6 | Nombre: Monitor 24 Pulgadas -> Monitor 24 Pulgadas | Precio: 3200.00 -> 3200.00 | Stock: 12 -> 12',_binary '');
/*!40000 ALTER TABLE `tb_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tb_products`
--

DROP TABLE IF EXISTS `tb_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_products` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `SKU` varchar(50) NOT NULL,
  `name` varchar(250) NOT NULL,
  `description` text,
  `current_price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `current_stock` int unsigned NOT NULL DEFAULT '0',
  `status` bit(1) DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `SKU` (`SKU`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_products`
--

LOCK TABLES `tb_products` WRITE;
/*!40000 ALTER TABLE `tb_products` DISABLE KEYS */;
INSERT INTO `tb_products` VALUES (1,'PROD-001','Smartphone Galaxy S23','...',15000.00,10,_binary '','2026-09-17 11:21:27','2026-09-17 11:21:27'),(2,'PROD-02','Smartphone Galaxy S26 ultra','un s26b ultra perro',36000.00,10,_binary '','2026-09-17 11:22:16','2026-09-17 11:22:16'),(3,'PROD-003','Audífonos Bluetooth','Audífonos inalámbricos con conexión Bluetooth',850.00,20,_binary '','2026-09-17 13:06:35','2026-09-17 13:06:35'),(4,'PROD-004','Teclado Mecánico','Teclado mecánico para computadora',1200.00,15,_binary '','2026-09-17 13:06:35','2026-09-17 13:06:35'),(5,'PROD-005','Mouse Gamer','Mouse óptico para videojuegos',650.00,25,_binary '','2026-09-17 13:06:35','2026-09-17 13:06:35'),(6,'PROD-006','Monitor 24 Pulgadas','Monitor LED de 24 pulgadas para computadora',3200.00,12,_binary '','2026-09-17 13:06:35','2026-09-17 13:25:03'),(7,'PROD-007','Bocina Bluetooth','Bocina portátil inalámbrica con conexión Bluetooth',1100.00,18,_binary '','2026-09-17 13:06:35','2026-09-17 13:06:35');
/*!40000 ALTER TABLE `tb_products` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_products_after_insert` AFTER INSERT ON `tb_products` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        table_operation,
        db_users,
        table_description,
        operation_date,
        operation_status
    )
    VALUES (
        'tb_products',
        'Create',
        USER(),
        CONCAT(
            'Producto creado. ID=', NEW.ID,
            ',SKU=', NEW.SKU,
            ',name=', NEW.name,
            ',price=', NEW.current_price,
            ',stock=', NEW.current_stock,
            ',status=', NEW.status
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_products_after_update` AFTER UPDATE ON `tb_products` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        table_operation,
        db_users,
        table_description,
        operation_date,
        operation_status
    )
    VALUES (
        'tb_products',
        'Update',
        USER(),
        CONCAT(
            'Producto modificado. ID=', NEW.ID,
            ' | Nombre: ', OLD.name, ' -> ', NEW.name,
            ' | Precio: ', OLD.current_price, ' -> ', NEW.current_price,
            ' | Stock: ', OLD.current_stock, ' -> ', NEW.current_stock
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_products_after_delete` AFTER DELETE ON `tb_products` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        table_operation,
        db_users,
        table_description,
        operation_date,
        operation_status
    )
    VALUES (
        'tb_products',
        'Delete',
        USER(),
        CONCAT(
            'Producto eliminado. ID=', OLD.ID,
            ',SKU=', OLD.SKU,
            ',name=', OLD.name
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tb_users`
--

DROP TABLE IF EXISTS `tb_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tb_users` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `nick` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `status` bit(1) DEFAULT b'1',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `nick` (`nick`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tb_users`
--

LOCK TABLES `tb_users` WRITE;
/*!40000 ALTER TABLE `tb_users` DISABLE KEYS */;
INSERT INTO `tb_users` VALUES (4,'240145@utxicotepec.edu.mx','Obed-Updated','25d55ad283aa400af464c76d713c07ad','2026-09-10 10:11:26',NULL,NULL,_binary ''),(6,'240147@utxicotepec.edu.mx','240147-Jorge','25d55ad283aa400af464c76d713c07ad','2026-09-10 10:16:07',NULL,NULL,_binary ''),(7,'sus@gmail','su','ea3af61554c1e19ec62ba6c8029ca257','2026-09-10 10:54:33',NULL,NULL,_binary ''),(8,'jorge.eloy@gmail.com','JorgeEloyDev','9edcf5566ead58c2a093c2d293a55511','2026-09-10 10:55:30','2026-09-10 11:21:32',NULL,_binary ''),(10,'obed@example.com','obedV','12345678','2026-09-17 10:58:38',NULL,NULL,_binary ''),(11,'yaneth@example.com','YG','12345678','2026-09-17 10:58:38',NULL,NULL,_binary ''),(12,'dorian@example.com','dorianV','12345678','2026-09-17 10:58:38',NULL,NULL,_binary '');
/*!40000 ALTER TABLE `tb_users` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_users_after_insert` AFTER INSERT ON `tb_users` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        table_operation,
        db_users,
        table_description,
        operation_date,
        operation_status
    )
    VALUES (
        'tb_users',
        'Create',
        USER(),
        CONCAT(
            'Usuario creado. ID=', NEW.ID,
            ',EMAIL=', NEW.email,
            ',nick=', NEW.nick,
            ',creation_date=', NEW.creation_date,
            ',status=', NEW.status
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_users_after_update` AFTER UPDATE ON `tb_users` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        table_operation,
        db_users,
        table_description,
        operation_date,
        operation_status
    )
    VALUES (
        'tb_users',
        'Update',
        USER(),
        CONCAT(
            'Usuario modificado. ID=', NEW.ID,
            ' | Anterior Nick=', OLD.nick, ' -> Nuevo Nick=', NEW.nick,
            ' | Anterior Email=', OLD.email, ' -> Nuevo Email=', NEW.email
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_users_after_delete` AFTER DELETE ON `tb_users` FOR EACH ROW BEGIN
    INSERT INTO tb_logs (
        table_name,
        table_operation,
        db_users,
        table_description,
        operation_date,
        operation_status
    )
    VALUES (
        'tb_users',
        'Delete',
        USER(),
        CONCAT(
            'Usuario eliminado. ID=', OLD.ID,
            ',EMAIL=', OLD.email,
            ',nick=', OLD.nick
        ),
        CURRENT_TIMESTAMP,
        b'1'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping events for database 'db_test_7b'
--

--
-- Dumping routines for database 'db_test_7b'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_restore_product` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_restore_product`(
    IN p_product_id INT UNSIGNED
)
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM tb_products
        WHERE ID = p_product_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El producto especificado no existe';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM tb_products
        WHERE ID = p_product_id
          AND status = b'1'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El producto ya se encuentra activo';
    END IF;

    UPDATE tb_products
    SET status = b'1'
    WHERE ID = p_product_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_soft_delete_product` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_soft_delete_product`(
    IN p_product_id INT UNSIGNED
)
BEGIN

    /* Validar que el producto exista */
    IF NOT EXISTS (
        SELECT 1
        FROM tb_products
        WHERE ID = p_product_id
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El producto especificado no existe';
    END IF;

    /* Validar que el producto no esté eliminado */
    IF EXISTS (
        SELECT 1
        FROM tb_products
        WHERE ID = p_product_id
            AND status = b'0'
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El producto ya se encuentra eliminado';
    END IF;

    /* Soft Delete */
    UPDATE tb_products
    SET status = b'0'
    WHERE ID = p_product_id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-17 13:34:16
