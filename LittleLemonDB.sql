-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema LittleLemonFinalDB
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema LittleLemonFinalDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `LittleLemonFinalDB` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `LittleLemonFinalDB` ;

-- -----------------------------------------------------
-- Table `LittleLemonFinalDB`.`customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonFinalDB`.`customers` (
  `CustomersID` INT NOT NULL AUTO_INCREMENT,
  `GuestFirstName` VARCHAR(100) NOT NULL,
  `GuestLastName` VARCHAR(100) NOT NULL,
  `Email` VARCHAR(255) NOT NULL,
  `PhoneNumber` INT NOT NULL,
  PRIMARY KEY (`CustomersID`))
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `LittleLemonFinalDB`.`deliverystatus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonFinalDB`.`deliverystatus` (
  `DeliveryID` INT NOT NULL,
  `Status` VARCHAR(45) NOT NULL,
  `Date` DATE NOT NULL,
  PRIMARY KEY (`DeliveryID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `LittleLemonFinalDB`.`employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonFinalDB`.`employees` (
  `EmployeeID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(100) NULL DEFAULT NULL,
  `Role` VARCHAR(100) NULL DEFAULT NULL,
  `Address` VARCHAR(100) NULL DEFAULT NULL,
  `Contact_Number` INT NULL DEFAULT NULL,
  `Email` VARCHAR(100) NULL DEFAULT NULL,
  `Annual_Salary` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`EmployeeID`))
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `LittleLemonFinalDB`.`menuitems`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonFinalDB`.`menuitems` (
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
-- Table `LittleLemonFinalDB`.`menus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonFinalDB`.`menus` (
  `MenuID` INT NOT NULL,
  `ItemID` INT NOT NULL,
  `MenuName` VARCHAR(100) NOT NULL,
  `Cuisine` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`MenuID`),
  INDEX `menuitems_fk_itemID_idx` (`ItemID` ASC) VISIBLE,
  CONSTRAINT `menuitems_fk_itemID`
    FOREIGN KEY (`ItemID`)
    REFERENCES `LittleLemonFinalDB`.`menuitems` (`ItemID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `LittleLemonFinalDB`.`orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonFinalDB`.`orders` (
  `OrderID` INT NOT NULL,
  `MenuID` INT NOT NULL,
  `BillAmount` DECIMAL(10,2) NOT NULL,
  `Quantity` INT NOT NULL,
  PRIMARY KEY (`OrderID`),
  INDEX `menu_fk_idx` (`MenuID` ASC) VISIBLE,
  CONSTRAINT `menu_fk`
    FOREIGN KEY (`MenuID`)
    REFERENCES `LittleLemonFinalDB`.`menus` (`MenuID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `LittleLemonFinalDB`.`bookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonFinalDB`.`bookings` (
  `BookingID` INT NOT NULL AUTO_INCREMENT,
  `BookingSlot` TIME NOT NULL,
  `EmployeeID` INT NOT NULL,
  `CustomersID` INT NOT NULL,
  `DeliveryID` INT NOT NULL,
  `OrderID` INT NOT NULL,
  PRIMARY KEY (`BookingID`),
  INDEX `customers_fk_idx` (`CustomersID` ASC) VISIBLE,
  INDEX `employee_fk_idx` (`EmployeeID` ASC) VISIBLE,
  INDEX `delivery_fk_idx` (`DeliveryID` ASC) VISIBLE,
  INDEX `orders_fk_idx` (`OrderID` ASC) VISIBLE,
  CONSTRAINT `customers_fk`
    FOREIGN KEY (`CustomersID`)
    REFERENCES `LittleLemonFinalDB`.`customers` (`CustomersID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `delivery_fk`
    FOREIGN KEY (`DeliveryID`)
    REFERENCES `LittleLemonFinalDB`.`deliverystatus` (`DeliveryID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `employee_fk`
    FOREIGN KEY (`EmployeeID`)
    REFERENCES `LittleLemonFinalDB`.`employees` (`EmployeeID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `orders_fk`
    FOREIGN KEY (`OrderID`)
    REFERENCES `LittleLemonFinalDB`.`orders` (`OrderID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
