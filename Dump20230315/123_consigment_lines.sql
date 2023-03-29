-- MySQL dump 10.13  Distrib 8.0.31, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: 123
-- ------------------------------------------------------
-- Server version	8.0.31

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
-- Table structure for table `consigment_lines`
--

DROP TABLE IF EXISTS `consigment_lines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `consigment_lines` (
  `line_id` int NOT NULL AUTO_INCREMENT,
  `cons_id` int NOT NULL,
  `b_price` int NOT NULL,
  `b_amount` int NOT NULL,
  `b_id` int NOT NULL,
  PRIMARY KEY (`line_id`),
  UNIQUE KEY `line_id_UNIQUE` (`line_id`),
  KEY `b_id_idx` (`b_id`),
  KEY `cons_id_idx` (`cons_id`),
  CONSTRAINT `b_id` FOREIGN KEY (`b_id`) REFERENCES `nomenklatura` (`Nomen_blank_id`),
  CONSTRAINT `cons_id` FOREIGN KEY (`cons_id`) REFERENCES `consignment_note` (`cn_id`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `consigment_lines`
--

LOCK TABLES `consigment_lines` WRITE;
/*!40000 ALTER TABLE `consigment_lines` DISABLE KEYS */;
INSERT INTO `consigment_lines` VALUES (1,1,50,2,5),(2,1,100,1,3),(3,2,25,2,4),(4,2,50,1,4),(5,3,150,2,1),(6,4,50,6,2),(7,5,50,2,5),(8,6,300,1,6),(9,7,100,2,1),(10,5,100,3,1),(11,7,100,2,1),(12,7,200,4,4),(13,13,200,1,1),(14,14,200,23,1),(15,14,120,43,2),(16,15,200,12,1),(17,16,120,200,1),(18,16,200,300,2),(19,17,12,23,1),(20,18,200,32,1),(21,19,32,200,1),(22,19,32,120,4),(23,20,200,5,1),(24,21,200,23,1),(25,24,200,300,1),(26,24,200,100,2),(27,25,200,1,1),(28,25,200,453,2),(29,26,120,233,1),(30,27,200,200,1),(31,28,100,4523,1),(32,29,200,300,1),(33,30,300,5,1),(34,31,100,200,1),(38,37,100,200,1),(39,43,200,300,4),(40,44,200,300,1),(41,47,100,200,1),(42,49,200,300,1),(43,49,300,400,2),(44,50,100,200,1),(45,52,100,200,1),(46,53,200,300,1),(47,53,300,400,2),(48,54,100,200,1),(49,54,300,400,5);
/*!40000 ALTER TABLE `consigment_lines` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-03-15 23:27:32
