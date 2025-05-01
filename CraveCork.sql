-- Create Database
CREATE DATABASE CraveCork;
USE CraveCork;

-- Create Tables
CREATE TABLE `Country` (
    `CountryID` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `CountryName` VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE `Region` (
    `RegionID` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `RegionName` VARCHAR(255) NOT NULL UNIQUE,
    `CountryID` INT NOT NULL,
    FOREIGN KEY (`CountryID`) REFERENCES `Country`(`CountryID`) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE `WineImporter` (
    `ImporterID` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `ImporterName` VARCHAR(255) NOT NULL UNIQUE,
    `ImporterWebsite` VARCHAR(255)
);

CREATE TABLE `WineType` (
    `WineTypeID` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `WineTypeName` VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE `Wine` (
    `WineID` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `Name` VARCHAR(255) NOT NULL UNIQUE,
    `ProductionYear` YEAR NOT NULL,
    `PercentageAlcohol` DECIMAL(5, 2) CHECK (`PercentageAlcohol` BETWEEN 0 AND 100),
    `TypicalPrice` DECIMAL(10, 2),
    `WineBottleLabel` VARCHAR(255),
    `ImporterID` INT,
    FOREIGN KEY (`ImporterID`) REFERENCES `WineImporter`(`ImporterID`) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE `CuisineGenre` (
    `CuisineGenreID` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `CuisineName` VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE `Dish` (
    `DishID` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `DishName` VARCHAR(255) NOT NULL UNIQUE,
    `CuisineGenreID` INT NOT NULL,
    FOREIGN KEY (`CuisineGenreID`) REFERENCES `CuisineGenre`(`CuisineGenreID`) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE `User` (
    `UserID` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `FirstName` VARCHAR(255) NOT NULL,
    `LastName` VARCHAR(255) NOT NULL,
    `Email` VARCHAR(255) NOT NULL UNIQUE,
    `PhoneNumber` VARCHAR(15) UNIQUE,
    `PricePreferenceMin` DECIMAL(10, 2) DEFAULT NULL,
    `PricePreferenceMax` DECIMAL(10, 2) DEFAULT NULL,
    `Password` VARCHAR(255) NOT NULL,
    `LastOrderDate` DATETIME DEFAULT NULL,
    CONSTRAINT chk_price_preference CHECK (`PricePreferenceMin` <= `PricePreferenceMax`)
);

CREATE TABLE `Order` (
    `OrderID` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `UserID` INT NOT NULL,
    `DishID` INT DEFAULT NULL,
    `WineID` INT DEFAULT NULL,
    `OrderDate` DATE NOT NULL,
    FOREIGN KEY (`UserID`) REFERENCES `User`(`UserID`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`DishID`) REFERENCES `Dish`(`DishID`) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (`WineID`) REFERENCES `Wine`(`WineID`) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE `UserFavorites` (
    `FavoriteID` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `WineID` INT,
    `UserID` INT NOT NULL,
    `AddedDate` DATE NOT NULL,
    `Rating` INT CHECK (`Rating` BETWEEN 1 AND 5),
    `Review` TEXT,
    FOREIGN KEY (`WineID`) REFERENCES `Wine`(`WineID`) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (`UserID`) REFERENCES `User`(`UserID`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `Pairing` (
    `PairingID` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `DishID` INT NOT NULL,
    `WineID` INT NOT NULL,
    FOREIGN KEY (`DishID`) REFERENCES `Dish`(`DishID`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`WineID`) REFERENCES `Wine`(`WineID`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `WineNote` (
    `WineNoteID` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `NoteDescription` VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE `WineNoteAssign` (
    `WineNoteAssignID` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `WineID` INT NOT NULL,
    `WineNoteID` INT NOT NULL,
    FOREIGN KEY (`WineID`) REFERENCES `Wine`(`WineID`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`WineNoteID`) REFERENCES `WineNote`(`WineNoteID`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `FlavorNote` (
    `FlavorNoteID` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `FlavorName` VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE `FlavorNoteWine` (
    `FlavorWineID` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `WineID` INT NOT NULL,
    `FlavorNoteID` INT NOT NULL,
    FOREIGN KEY (`WineID`) REFERENCES `Wine`(`WineID`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`FlavorNoteID`) REFERENCES `FlavorNote`(`FlavorNoteID`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `FlavorNoteDish` (
    `FlavorNoteDishID` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `DishID` INT NOT NULL,
    `FlavorNoteID` INT NOT NULL,
    FOREIGN KEY (`DishID`) REFERENCES `Dish`(`DishID`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`FlavorNoteID`) REFERENCES `FlavorNote`(`FlavorNoteID`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `WineRegion` (
    `WineRegionID` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `WineID` INT NOT NULL,
    `RegionID` INT NOT NULL,
    FOREIGN KEY (`WineID`) REFERENCES `Wine`(`WineID`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`RegionID`) REFERENCES `Region`(`RegionID`) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE `WineCountry` (
    `WineCountryID` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `WineID` INT NOT NULL,
    `CountryID` INT NOT NULL,
    FOREIGN KEY (`WineID`) REFERENCES `Wine`(`WineID`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`CountryID`) REFERENCES `Country`(`CountryID`) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE `WineTypeAssign` (
    `WineTypeAssignID` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `WineID` INT NOT NULL,
    `WineTypeID` INT NOT NULL,
    FOREIGN KEY (`WineID`) REFERENCES `Wine`(`WineID`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`WineTypeID`) REFERENCES `WineType`(`WineTypeID`) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE `DishRegion` (
    `DishRegionID` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `DishID` INT NOT NULL,
    `RegionID` INT NOT NULL,
    FOREIGN KEY (`DishID`) REFERENCES `Dish`(`DishID`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`RegionID`) REFERENCES `Region`(`RegionID`) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Additional Triggers
DELIMITER $$

CREATE TRIGGER update_last_order_date
AFTER INSERT ON `Order`
FOR EACH ROW
BEGIN
    UPDATE `User`
    SET LastOrderDate = NEW.OrderDate
    WHERE `UserID` = NEW.`UserID`;
END $$

DELIMITER ;

DELIMITER $$
CREATE TRIGGER log_wine_price_changes
AFTER UPDATE ON `Wine`
FOR EACH ROW
BEGIN
    INSERT INTO `WineAudit` (`WineID`, `Action`, `ActionTime`, `OldPrice`, `NewPrice`)
    VALUES (OLD.`WineID`, 'Price Change', NOW(), OLD.`TypicalPrice`, NEW.`TypicalPrice`);
END $$
DELIMITER ;

-- adding fake data

INSERT INTO `Country` (`CountryName`)
VALUES ('France'), ('Italy'), ('USA'), ('Spain'), ('Australia');

INSERT INTO `WineImporter` (`ImporterName`, `ImporterWebsite`)
VALUES
('Vineyard Imports', 'https://vineyardimports.com'),
('Global Wine Co.', 'https://globalwineco.com'),
('Fine Vintages', 'https://finevintages.com'),
('Elite Importers', 'https://eliteimporters.com'),
('Classic Selections', 'https://classicselections.com');

INSERT INTO `WineType` (`WineTypeName`)
VALUES ('Red'), ('White'), ('Rosé'), ('Sparkling'), ('Dessert');

INSERT INTO `CuisineGenre` (`CuisineName`)
VALUES ('French'), ('Italian'), ('American'), ('Spanish'), ('Indian');

INSERT INTO `FlavorNote` (`FlavorName`)
VALUES ('Bitter'), ('Sweet'), ('Spicy'), ('Umami'), ('Tangy');

INSERT INTO `WineNote` (`NoteDescription`)
VALUES ('Fruity'), ('Earthy'), ('Spicy'), ('Floral'), ('Oaky');

INSERT INTO `User` (`FirstName`, `LastName`, `Email`, `PhoneNumber`, `PricePreferenceMin`, `PricePreferenceMax`, `Password`)
VALUES
('Idris', 'Elba', 'idris.elba@hollywoodvibes.com', '1234567890', 50.00, 100.00, 'stringerBell123'),
('Tommy', 'Pickles', 'tommy.pickles@rugratsmail.com', '2345678902', NULL, NULL, 'diaperDays'),
('Kim', 'Possible', 'kim.possible@cheerhero.com', '0123456790', 75.00, 150.00, 'whatsTheSitch'),
('Rihanna', 'Fenty', 'rihanna.fenty@fentywine.com', '7890123456', 200.00, 500.00, 'shineBright!'),
('Issa', 'Rae', 'issa.rae@awkwardnotes.com', '9012345678', 25.00, 75.00, 'insecure123');


INSERT INTO `Region` (`RegionName`, `CountryID`)
VALUES
('Bordeaux', 1),
('Tuscany', 2),
('Napa Valley', 3),
('Rioja', 3),
('Barossa Valley', 4);


INSERT INTO `Dish` (`DishName`, `CuisineGenreID`)
VALUES
('Beef Bourguignon', 1),
('Margherita Pizza', 2),
('BBQ Ribs', 3),
('Paella', 4),
('Lamb Saag', 5);


INSERT INTO `Wine` (`Name`, `ProductionYear`, `PercentageAlcohol`, `TypicalPrice`, `WineBottleLabel`, `ImporterID`)
VALUES
('Château Margaux', 2018, 13.5, 350.00, 'https://wine-labels.com/chateau-margaux.jpg', 1),
('Brunello di Montalcino', 2016, 14.0, 120.00, 'https://wine-labels.com/brunello.jpg', 2),
('Cabernet Sauvignon Reserve', 2020, 14.5, 60.00, 'https://wine-labels.com/cabernet-reserve.jpg', 3),
('Rioja Gran Reserva', 2015, 13.5, 45.00, 'https://wine-labels.com/rioja.jpg', 4),
('Penfolds Grange', 2019, 14.2, 600.00, 'https://wine-labels.com/penfolds.jpg', 5);


INSERT INTO `DishRegion` (`DishID`, `RegionID`)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

INSERT INTO `WineRegion` (`WineID`, `RegionID`)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

INSERT INTO `WineCountry` (`WineID`, `CountryID`)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

INSERT INTO `FlavorNoteDish` (`DishID`, `FlavorNoteID`)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);


INSERT INTO `FlavorNoteWine` (`WineID`, `FlavorNoteID`)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);


INSERT INTO `WineNoteAssign` (`WineID`, `WineNoteID`)
VALUES
(1, 2),
(2, 1),
(3, 2),
(4, 4),
(5, 5);

INSERT INTO `UserFavorites` (`WineID`, `UserID`, `AddedDate`, `Rating`, `Review`)
VALUES
(1, 1, '2024-03-20', 5, 'Excellent wine, perfect with French dishes.'),
(2, 2, '2024-03-21', 4, 'Great for pizza night.'),
(3, 3, '2024-03-22', 5, 'Outstanding with BBQ ribs.'),
(4, 4, '2024-03-23', 4, 'Perfect match for paella.'),
(5, 1, '2024-03-24', 5, 'A unique experience.');


INSERT INTO `Pairing` (`DishID`, `WineID`)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- QUERIES
SET SQL_SAFE_UPDATES = 0;
DELETE FROM `Dish`
WHERE `DishName` = 'Paella';
SET SQL_SAFE_UPDATES = 1;

UPDATE `User`
SET `PricePreferenceMin` = 40.00, `PricePreferenceMax` = 100.00
WHERE `UserID` = 1;

INSERT INTO `CuisineGenre` (`CuisineName`)
VALUES ('Jamaican');

INSERT INTO `Dish` (`DishName`, `CuisineGenreID`)
VALUES
('Jerk_CHicken', 6);

SELECT * FROM `User`;
SELECT * FROM `Dish`;
SELECT * FROM `Wine`;

SET FOREIGN_KEY_CHECKS = 0;
INSERT INTO `Order` (`UserID`, `DishID`, `WineID`, `OrderDate`)
VALUES
(1, 1, 1, '2024-03-01'),
(2, 2, 2, '2024-03-02'),
(3, 3, 3, '2024-03-03'),
(4, 4, 4, '2024-03-04'),
(5, 5, 5, '2024-03-05');

SET FOREIGN_KEY_CHECKS = 1;


SELECT * FROM `UserFavorites`;

SELECT u.FirstName, u.LastName, COUNT(o.OrderID) AS TotalOrders
FROM `User` u
LEFT JOIN `Order` o ON u.UserID = o.UserID
GROUP BY u.UserID;

SELECT w.Name, w.ProductionYear, w.PercentageAlcohol, w.TypicalPrice
FROM `Wine` w
JOIN `WineRegion` wr ON w.WineID = wr.WineID
JOIN `Region` r ON wr.RegionID = r.RegionID
WHERE r.RegionName = 'Bordeaux';

SELECT d.DishName
FROM `Dish` d
JOIN `FlavorNoteDish` fnd ON d.DishID = fnd.DishID
JOIN `FlavorNote` fn ON fnd.FlavorNoteID = fn.FlavorNoteID
WHERE fn.FlavorName = 'Spicy';


SELECT Name, TypicalPrice
FROM `Wine`
WHERE `TypicalPrice` > (SELECT AVG(`TypicalPrice`) FROM `Wine`);


CREATE VIEW BestPairings AS
SELECT p.PairingID, d.DishName, w.Name AS WineName, w.TypicalPrice, cg.CuisineName
FROM `Pairing` p
JOIN `Dish` d ON p.DishID = d.DishID
JOIN `Wine` w ON p.WineID = w.WineID
JOIN `CuisineGenre` cg ON d.CuisineGenreID = cg.CuisineGenreID;


SELECT w.Name, COUNT(uf.FavoriteID) AS FavoriteCount
FROM `UserFavorites` uf
JOIN `Wine` w ON uf.WineID = w.WineID
GROUP BY w.WineID
ORDER BY FavoriteCount DESC;

START TRANSACTION;

UPDATE `User`
SET `PricePreferenceMin` = 30.00, `PricePreferenceMax` = 80.00
WHERE `UserID` = 1;

INSERT INTO `UserFavorites` (`WineID`, `UserID`, `AddedDate`, `Rating`, `Review`)
VALUES (3, 1, '2024-03-25', 4, 'Great for BBQ and grilled dishes.');

COMMIT;

SELECT w.Name AS WineSuggestion, d.DishName, cg.CuisineName
FROM `Dish` d
JOIN `CuisineGenre` cg ON d.CuisineGenreID = cg.CuisineGenreID
JOIN `Pairing` p ON d.DishID = p.DishID
JOIN `Wine` w ON p.WineID = w.WineID
WHERE cg.CuisineName = 'Italian';

SELECT w.Name, w.ProductionYear, w.PercentageAlcohol, w.TypicalPrice, wi.ImporterName, wn.NoteDescription
FROM `Wine` w
JOIN `WineImporter` wi ON w.ImporterID = wi.ImporterID
JOIN `WineNoteAssign` wna ON w.WineID = wna.WineID
JOIN `WineNote` wn ON wna.WineNoteID = wn.WineNoteID;

SELECT d.DishName, w.Name AS WineName, c.CountryName
FROM `Dish` d
JOIN `Pairing` p ON d.DishID = p.DishID
JOIN `Wine` w ON p.WineID = w.WineID
JOIN `WineCountry` wc ON w.WineID = wc.WineID
JOIN `Country` c ON wc.CountryID = c.CountryID
WHERE c.CountryName = 'France';