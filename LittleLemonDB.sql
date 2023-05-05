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


INSERT IGNORE INTO Bookings (BookingID, BookingSlot, EmployeeID, CustomersID, DeliveryID, OrderID, TableNO, BookingDate)
VALUES
(1, '19:00:00', 5, 9, 1, 1, 1, 2022-10-15),
(2, '19:00:00', 8, 4, 2, 2, 2, 2022-10-15),
(3, '15:00:00', 7, 8, 3, 5, 3, 2022-10-15),
(4, '17:30:00', 7, 12, 4, 8, 4, 2022-10-15),
(5, '18:30:00', 5, 7, 5, 3, 5, 2022-10-15),
(6, '20:00:00', 8, 2, 6, 4, 6, 2022-10-15),
(7, '18:00:00', 5, 7, 7, 6, 5, 2022-10-10),
(8, '18:00:00', 5, 3, 8, 7, 3, 2022-10-12),
(9, '17:00:00', 5, 9, 9, 9, 2, 2022-10-11),
(10, '19:00:00', 5, 11, 10, 10, 2, 2022-10-13);

INSERT IGNORE INTO MenuItems (ItemID, CourseName, StarterName, DesertName)
VALUES
(1, 'Salmon', 'Caesar Salad', 'Cheesecake'),
(2, 'Beef Wellington', 'Caprese Salad', 'Chocolate Mousse'),
(3, 'Lobster Bisque', 'Tuna Tartare', 'Crème Brûlée'),
(4, 'Mushroom Risotto', 'Minestrone Soup', 'Tiramisu'),
(5, 'Chicken Marsala', 'Bruschetta', 'Panna Cotta'),
(6, 'Shrimp Scampi', 'House Salad', 'Gelato'),
(7, 'Filet Mignon', 'French Onion Soup', 'Chocolate Fondant'),
(8, 'Grilled Octopus', 'Greek Salad', 'Baklava'),
(9, 'Lamb Chops', 'Hummus', 'Turkish Delight'),
(10, 'Veal Parmesan', 'Antipasti Platter', 'Cannoli'),
(11, 'Sushi Platter', 'Miso Soup', 'Green Tea Ice Cream'),
(12, 'Crab Cakes', 'Seafood Chowder', 'Key Lime Pie'),
(13, 'Pork Tenderloin', 'Arugula Salad', 'Chocolate Cake'),
(14, 'Vegetable Curry', 'Naan Bread', 'Mango Sorbet');

INSERT IGNORE INTO Menus (MenuID, ItemID, MenuName, Cuisine)
VALUES
(1, 1, 'Pacific Catch', 'Seafood'),
(2, 2, 'English Countryside', 'British'),
(3, 3, 'New England Feast', 'American'),
(4, 4, 'Italian Delight', 'Italian'),
(5, 5, 'Mediterranean Nights', 'Mediterranean'),
(6, 6, 'Coastal Bliss', 'Seafood'),
(7, 7, 'Classic Steakhouse', 'American'),
(8, 8, 'Greek Isles', 'Greek'),
(9, 9, 'Middle Eastern Journey', 'Middle Eastern'),
(10, 10, 'Italian Feast', 'Italian'),
(11, 11, 'Sushi Night', 'Japanese'),
(12, 12, 'East Coast Seafood', 'Seafood'),
(13, 13, 'Taste of the South', 'American'),
(14, 14, 'Vegetarian Delight', 'Vegetarian');

INSERT IGNORE INTO Customers (CustomersID, GuestFirstName, GuestLastName, Email, PhoneNumber)
VALUES
(1, 'Anna','Iversen','Anna.Iv@Livmail.com',984253698),
(2, 'John', 'Doe', 'johndoe@example.com', 123456789),
(3, 'Jane', 'Doe', 'janedoe@example.com', 234567890),
(4, 'Alice', 'Smith', 'alicesmith@example.com', 345678901),
(5, 'Bob', 'Smith', 'bobsmith@example.com', 456789012),
(6, 'David', 'Lee', 'davidlee@example.com', 567890123),
(7, 'Sarah', 'Kim', 'sarahkim@example.com', 678901234),
(8, 'James', 'Johnson', 'jamesjohnson@example.com', 789012345),
(9, 'Emily', 'Davis', 'emilydavis@example.com', 890123456),
(10, 'William', 'Brown', 'williambrown@example.com', 901234567),
(11, 'Olivia', 'Taylor', 'oliviataylor@example.com', 123456789),
(12, 'Michael', 'Miller', 'michaelmiller@example.com', 234567890);

INSERT IGNORE INTO Bookings (BookingID, BookingSlot, EmployeeID, CustomersID, DeliveryID, OrderID, TableNO, BookingDate)
VALUES
(1, '19:00:00', 5, 9, 1, 1, 1, 2022-10-15),
(2, '19:00:00', 8, 4, 2, 2, 2, 2022-10-15),
(3, '15:00:00', 7, 8, 3, 5, 3, 2022-10-15),
(4, '17:30:00', 7, 12, 4, 8, 4, 2022-10-15),
(5, '18:30:00', 5, 7, 5, 3, 5, 2022-10-15),
(6, '20:00:00', 8, 2, 6, 4, 6, 2022-10-15),
(7, '18:00:00', 5, 7, 7, 6, 5, 2022-10-10),
(8, '18:00:00', 5, 3, 8, 7, 3, 2022-10-12),
(9, '17:00:00', 5, 9, 9, 9, 2, 2022-10-11),
(10, '19:00:00', 5, 11, 10, 10, 2, 2022-10-13);

INSERT IGNORE INTO deliverystatus (DeliveryID, Status, Date)
VALUES
(1, 'Being prepared', '2022-10-15'),
(2, 'Being prepared', '2022-10-15'),
(3, 'Delivered', '2022-10-15'),
(4, 'Delivered', '2022-10-15'),
(5, 'Delivered', '2022-10-15'),
(6, 'Waiting in line', '2022-10-15'),
(7, 'Delivered', '2022-10-10'),
(8, 'Delivered', '2022-10-12'),
(9, 'Delivered', '2022-10-11'),
(10, 'Delivered', '2022-10-13');

INSERT IGNORE INTO Orders (OrderID, MenuID, BillAmount, Quantity)
VALUES
(1, 12, 25, 1),
(2, 7, 40, 2),
(3, 5, 30, 1),
(4, 3, 225, 1),
(5, 8, 45, 2),
(6, 2, 15, 1),
(7, 6, 35, 1),
(8, 4, 175, 1),
(9, 11, 50, 3),
(10, 9, 25, 1),
(11, 1, 60, 2),
(12, 10, 40, 2);

INSERT IGNORE INTO employees (EmployeeID, Name, Role, Address, Contact_Number, Email, Annual_Salary)
VALUES
(1,'Mario Gollini','Manager','724, Parsley Lane, Old Town, Chicago, IL',351258074,'Mario.g@littlelemon.com','$70,000'),
(2,'Adrian Gollini','Assistant Manager','334, Dill Square, Lincoln Park, Chicago, IL',351474048,'Adrian.g@littlelemon.com','$65,000'),
(3,'Giorgos Dioudis','Head Chef','879 Sage Street, West Loop, Chicago, IL',351970582,'Giorgos.d@littlelemon.com','$50,000'),
(4,'Fatma Kaya','Assistant Chef','132 Bay Lane, Chicago, IL',351963569,'Fatma.k@littlelemon.com','$45,000'),
(5,'Elena Salvai','Head Waiter','989 Thyme Square, EdgeWater, Chicago, IL',351074198,'Elena.s@littlelemon.com','$40,000'),
(6,'John Millar','Receptionist','245 Dill Square, Lincoln Park, Chicago, IL',351584508,'John.m@littlelemon.com','$35,000'),
(7,'Tom Smith','Waiter','111 Olive Ave, Lakeview, Chicago, IL',351753951,'Tom.s@littlelemon.com','$30,000'),
(8,'Linda Brown','Waiter','432 Cherry St, River North, Chicago, IL',351852369,'Linda.b@littlelemon.com','$30,000');