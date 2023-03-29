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
-- Temporary view structure for view `v1`
--

DROP TABLE IF EXISTS `v1`;
/*!50001 DROP VIEW IF EXISTS `v1`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v1` AS SELECT 
 1 AS `sup_name`,
 1 AS `sup_city`,
 1 AS `sup_date`,
 1 AS `sup_phone`,
 1 AS `cn_date_of_supply`,
 1 AS `sup_id`,
 1 AS `count(*)`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v2`
--

DROP TABLE IF EXISTS `v2`;
/*!50001 DROP VIEW IF EXISTS `v2`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v2` AS SELECT 
 1 AS `sup_name`,
 1 AS `sup_city`,
 1 AS `sup_date`,
 1 AS `sup_phone`,
 1 AS `cn_date_of_supply`,
 1 AS `sup_id`,
 1 AS `col`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `v1`
--

/*!50001 DROP VIEW IF EXISTS `v1`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v1` AS select `sup`.`sup_name` AS `sup_name`,`sup`.`sup_city` AS `sup_city`,`sup`.`sup_date` AS `sup_date`,`sup`.`sup_phone` AS `sup_phone`,`cn`.`cn_date_of_supply` AS `cn_date_of_supply`,`sup`.`sup_id` AS `sup_id`,count(0) AS `count(*)` from (`supplier` `sup` join `consignment_note` `cn` on((`sup`.`sup_id` = `cn`.`supplier_id`))) where (`cn`.`cn_date_of_supply` like '2020%') group by `cn`.`supplier_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v2`
--

/*!50001 DROP VIEW IF EXISTS `v2`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v2` AS select `sup`.`sup_name` AS `sup_name`,`sup`.`sup_city` AS `sup_city`,`sup`.`sup_date` AS `sup_date`,`sup`.`sup_phone` AS `sup_phone`,`cn`.`cn_date_of_supply` AS `cn_date_of_supply`,`sup`.`sup_id` AS `sup_id`,count(0) AS `col` from (`supplier` `sup` join `consignment_note` `cn` on((`sup`.`sup_id` = `cn`.`supplier_id`))) where (`cn`.`cn_date_of_supply` like '2020%') group by `cn`.`supplier_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Dumping events for database '123'
--

--
-- Dumping routines for database '123'
--
/*!50003 DROP PROCEDURE IF EXISTS `cons_insert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cons_insert`(cons_number int)
BEGIN
declare done int default 0;
declare `proc_blank`, `proc_amount`, `proc_price`,if_exists int;
declare `DATE_N` DATE;
declare `blank_rep_name` varchar(45);
declare c1 cursor for 
			select b_price, b_amount, b_id
            from consigment_lines
			where cons_id = cons_number;
declare exit handler for SQLSTATE '02000' set done = 1;
select cn_date_of_supply into `DATE_N` from consignment_note
    where cn_id = cons_number;
  open c1;
    while done = 0 do
      fetch c1 into `proc_price`, `proc_amount`, `proc_blank`;
            if exists(select blank_id from blank
        where blank_nomen_id = `proc_blank` and blank_price = `proc_price`) then
				  update blank SET blank_last_update = DATE_N, blank_amount = blank_amount + proc_amount
				  where blank_nomen_id = proc_blank and blank_price = proc_price;
                  else
      insert blank values(NULL, `DATE_N`, `proc_amount`,  `proc_price`, `proc_blank`);
      end if;
    end while;
    close c1;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `year_report` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `year_report`(in_year year, in_month int)
BEGIN
declare done int default 0;
declare `sup_year_date`, `sup_month_date`, `blank_rep_id`, `blank_rep_amount`, if_exists int;
declare `blank_rep_name` varchar(45);
declare c1 cursor for select b_id, blank_name, sum(b_amount)
            from consigment_lines cl
                        join consignment_note cn on cl.cons_id = cn.cn_id
                        join nomenklatura nm on nm.Nomen_blank_id = cl.b_id
                        where year(cn_date_of_supply) = in_year and month(cn_date_of_supply) = in_month
                        group by b_id;
declare exit handler for SQLSTATE '02000' set done = 1;
  open c1;
    while done = 0 do
      fetch c1 into `blank_rep_id`, `blank_rep_name`, `blank_rep_amount`;
      insert reports values(NULL, in_year, in_month, `blank_rep_id`, `blank_rep_name`, `blank_rep_amount`);
    end while;
    close c1;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `year_report1` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `year_report1`(in_year year, in_month int)
BEGIN
declare done int default 0;
declare `sup_year_date`, `sup_month_date`, `blank_rep_id`, `blank_rep_price`, if_exists int;
declare `blank_rep_name` varchar(45);
declare c1 cursor for select b_id, blank_name, sum(b_price * b_amount)
            from consigment_lines cl
                        join consignment_note cn on cl.cons_id = cn.cn_id
                        join nomenklatura nm on nm.Nomen_blank_id = cl.b_id
                        where year(cn_date_of_supply) = in_year and month(cn_date_of_supply) = in_month
                        group by b_id;
declare exit handler for SQLSTATE '02000' set done = 1;
  open c1;
    while done = 0 do
      fetch c1 into `blank_rep_id`, `blank_rep_name`, `blank_rep_price`;
      insert reports1 values(NULL, in_year, in_month, `blank_rep_id`, `blank_rep_name`, `blank_rep_price`);
    end while;
    close c1;
    
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

-- Dump completed on 2023-03-15 23:27:33
