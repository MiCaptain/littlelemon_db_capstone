CREATE DEFINER=`root`@`localhost` PROCEDURE `GetMaxQuantity`()
SELECT MAX(quantity) AS "Max quantity in order" FROM orders