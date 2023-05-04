-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema littlelemonfinaldb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema littlelemonfinaldb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `littlelemonfinaldb` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `littlelemonfinaldb` ;

-- -----------------------------------------------------
-- Table `littlelemonfinaldb`.`customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemonfinaldb`.`customers` (
  `CustomersID` INT NOT NULL AUTO_INCREMENT,
  `GuestFirstName` VARCHAR(100) NOT NULL,
  `GuestLastName` VARCHAR(100) NOT NULL,
  `Email` VARCHAR(255) NOT NULL,
  `PhoneNumber` INT NOT NULL,
  PRIMARY KEY (`CustomersID`))
ENGINE = InnoDB
AUTO_INCREMENT = 13
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `littlelemonfinaldb`.`deliverystatus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemonfinaldb`.`deliverystatus` (
  `DeliveryID` INT NOT NULL,
  `Status` VARCHAR(45) NOT NULL,
  `Date` DATE NOT NULL,
  PRIMARY KEY (`DeliveryID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `littlelemonfinaldb`.`employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemonfinaldb`.`employees` (
  `EmployeeID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(100) NULL DEFAULT NULL,
  `Role` VARCHAR(100) NULL DEFAULT NULL,
  `Address` VARCHAR(100) NULL DEFAULT NULL,
  `Contact_Number` INT NULL DEFAULT NULL,
  `Email` VARCHAR(100) NULL DEFAULT NULL,
  `Annual_Salary` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`EmployeeID`))
ENGINE = InnoDB
AUTO_INCREMENT = 9
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `littlelemonfinaldb`.`menuitems`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemonfinaldb`.`menuitems` (
  `ItemID` INT NOT NULL AUTO_INCREMENT,
  `CourseName` VARCHAR(200) NULL DEFAULT NULL,
  `StarterName` VARCHAR(100) NULL DEFAULT NULL,
  `DesertName` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`ItemID`))
ENGINE = InnoDB
AUTO_INCREMENT = 18
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `littlelemonfinaldb`.`menus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemonfinaldb`.`menus` (
  `MenuID` INT NOT NULL,
  `ItemID` INT NOT NULL,
  `MenuName` VARCHAR(100) NOT NULL,
  `Cuisine` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`MenuID`),
  INDEX `menuitems_fk_itemID_idx` (`ItemID` ASC) VISIBLE,
  CONSTRAINT `menuitems_fk_itemID`
    FOREIGN KEY (`ItemID`)
    REFERENCES `littlelemonfinaldb`.`menuitems` (`ItemID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `littlelemonfinaldb`.`orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemonfinaldb`.`orders` (
  `OrderID` INT NOT NULL,
  `MenuID` INT NOT NULL,
  `BillAmount` DECIMAL(10,2) NOT NULL,
  `Quantity` INT NOT NULL,
  `BookingID` INT NOT NULL,
  PRIMARY KEY (`OrderID`),
  INDEX `menu_fk_idx` (`MenuID` ASC) VISIBLE,
  INDEX `vcbcb_idx` (`BookingID` ASC) VISIBLE,
  CONSTRAINT `menu_fk`
    FOREIGN KEY (`MenuID`)
    REFERENCES `littlelemonfinaldb`.`menus` (`MenuID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `littlelemonfinaldb`.`bookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemonfinaldb`.`bookings` (
  `BookingID` INT NOT NULL AUTO_INCREMENT,
  `BookingSlot` TIME NOT NULL,
  `EmployeeID` INT NULL DEFAULT NULL,
  `CustomersID` INT NOT NULL,
  `DeliveryID` INT NULL DEFAULT NULL,
  `OrderID` INT NULL DEFAULT NULL,
  `TableNO` INT NOT NULL,
  `BookingDate` DATE NOT NULL,
  PRIMARY KEY (`BookingID`),
  INDEX `customers_fk_idx` (`CustomersID` ASC) VISIBLE,
  INDEX `employee_fk_idx` (`EmployeeID` ASC) VISIBLE,
  INDEX `delivery_fk_idx` (`DeliveryID` ASC) VISIBLE,
  INDEX `orders_fk_idx` (`OrderID` ASC) VISIBLE,
  CONSTRAINT `customers_fk`
    FOREIGN KEY (`CustomersID`)
    REFERENCES `littlelemonfinaldb`.`customers` (`CustomersID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `delivery_fk`
    FOREIGN KEY (`DeliveryID`)
    REFERENCES `littlelemonfinaldb`.`deliverystatus` (`DeliveryID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `employee_fk`
    FOREIGN KEY (`EmployeeID`)
    REFERENCES `littlelemonfinaldb`.`employees` (`EmployeeID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `orders_fk`
    FOREIGN KEY (`OrderID`)
    REFERENCES `littlelemonfinaldb`.`orders` (`OrderID`))
ENGINE = InnoDB
AUTO_INCREMENT = 16
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `littlelemonfinaldb` ;

-- -----------------------------------------------------
-- Placeholder table for view `littlelemonfinaldb`.`ordersview`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemonfinaldb`.`ordersview` (`OrderID` INT, `Quantity` INT, `BillAmount` INT);

-- -----------------------------------------------------
-- procedure AddBooking
-- -----------------------------------------------------

DELIMITER $$
USE `littlelemonfinaldb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddBooking`(IN CustID INT, IN TableNumb INT, IN BookingD date)
BEGIN
START TRANSACTION; 
	If (SELECT count(TableNO) FROM Bookings WHERE TableNO=TableNumb AND BookingDate=BookingD) THEN
		SELECT concat('Table ', TableNumb,' on date',BookingD, ' is allready booked.') AS "Booking Status";
        rollback;
    ELSE
        INSERT IGNORE INTO Bookings (CustomersID, TableNO, BookingDate)
		VALUES
		(CustID, TableNumb, BookingD);
        SELECT concat('Your booking at table number: ', TableNumb, ' on date: ', BookingD, ' is placed.') AS "Booking Status";

    END IF;
COMMIT; 
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure CancelBooking
-- -----------------------------------------------------

DELIMITER $$
USE `littlelemonfinaldb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CancelBooking`(IN BookID INT)
BEGIN
START TRANSACTION; 
	DELETE FROM Bookings WHERE BookingID=BookID ;
	SELECT concat('Your booking at ID: ', BookID, ' is deleted now.') AS "Booking Status";

COMMIT; 
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure CheckBooking
-- -----------------------------------------------------

DELIMITER $$
USE `littlelemonfinaldb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CheckBooking`(IN BS TIME, IN CustID INT, IN TableNumb INT, IN BookingD date)
BEGIN
START TRANSACTION; 
	If (SELECT count(TableNO) FROM Bookings WHERE TableNO=TableNumb AND BookingDate=BookingD) THEN
		SELECT concat('Table ', TableNumb,' on date',BookingD, ' is allready booked.') AS "Booking Status";
        rollback;
    ELSE
        INSERT IGNORE INTO Bookings (BookingSlot, CustomersID, TableNO, BookingDate)
		VALUES
		(BS, CustID, TableNumb, BookingD);
        SELECT concat('Your booking at table number: ', TableNumb, ' on date: ', BookingD, ' is placed.') AS "Booking Status";

    END IF;
COMMIT; 
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure DeleteOrder
-- -----------------------------------------------------

DELIMITER $$
USE `littlelemonfinaldb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteOrder`(IN ID INT)
BEGIN
DELETE FROM orders WHERE OrderID = ID;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GetMaxQuantity
-- -----------------------------------------------------

DELIMITER $$
USE `littlelemonfinaldb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetMaxQuantity`()
SELECT MAX(quantity) AS "Max quantity in order" FROM orders$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure UpdateBooking
-- -----------------------------------------------------

DELIMITER $$
USE `littlelemonfinaldb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateBooking`(IN BookID INT, IN BookingD date)
BEGIN
START TRANSACTION; 
	UPDATE Bookings SET BookingDate=BookingD WHERE BookingID=BookID;
	SELECT concat('Your booking at ID: ', BookID, ' is booked for ', BookingD, ' now.') AS "Booking Status";

COMMIT; 
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure new_procedure
-- -----------------------------------------------------

DELIMITER $$
USE `littlelemonfinaldb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `new_procedure`(IN TableNumb INT, IN BookingD date)
BEGIN
START TRANSACTION; 
	If (SELECT count(TableNO) FROM Bookings WHERE TableNO=TableNumb AND BookingDate=BookingD) THEN
		SELECT concat('Table', TableNumb, 'is allready booked') AS TableStatus;
    ELSE
        SELECT 'Working 2' AS Result;
    END IF;
COMMIT; 
END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `littlelemonfinaldb`.`ordersview`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `littlelemonfinaldb`.`ordersview`;
USE `littlelemonfinaldb`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `littlelemonfinaldb`.`ordersview` AS select `littlelemonfinaldb`.`orders`.`OrderID` AS `OrderID`,`littlelemonfinaldb`.`orders`.`Quantity` AS `Quantity`,`littlelemonfinaldb`.`orders`.`BillAmount` AS `BillAmount` from `littlelemonfinaldb`.`orders` where (`littlelemonfinaldb`.`orders`.`Quantity` > 2);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
