-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: May 20, 2015 at 10:35 PM
-- Server version: 5.5.43-0ubuntu0.14.04.1
-- PHP Version: 5.5.9-1ubuntu4.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `findacar`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `check_email`(IN `em` VARCHAR(255))
    NO SQL
BEGIN

SELECT username, email FROM user WHERE email = em;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `check_username`(IN `un` VARCHAR(255))
BEGIN

SELECT username FROM user WHERE username = un;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `favcar`(IN `vid` INT, IN `un` VARCHAR(255))
    NO SQL
BEGIN

Update user SET favvid = vid WHERE username = un;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetColor`(IN `VID` INT)
    NO SQL
getColor:BEGIN


if((select count(*) from  Vehicle where Vehicle.VID = VID) != 1) then
	SIGNAL SQLSTATE '01000'
		SET MESSAGE_TEXT = 'An Error Occured';
		Select 'Not Valid VID' as 'error';
		Leave getColor;
END IF;


SELECT C.* 
FROM Vehicle v
JOIN Color_Option Co on v.VID = Co .VID JOIN Color C on
C.Color = Co.Color
where v.VID = VID;



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetEngine`(IN `VID` INT)
    NO SQL
getEngine:BEGIN


if((select count(*) from  Vehicle where Vehicle.VID = vid) != 1) then
	SIGNAL SQLSTATE '01000'
		SET MESSAGE_TEXT = 'An Error Occured';
		Select 'Not Valid VID' as 'error';
		Leave getEngine;
END IF;

Select E.*
From Vehicle v
JOIN Engine_Option Eo On v.VID = Eo.VID JOIN Engine E on E.EID = Eo.EID
Where v.VID = VID;



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getlikes`(IN `user` VARCHAR(50))
    NO SQL
BEGIN

SELECT v.VID, v.Trim, m.Name AS 'Name', m.Year AS 'Year', manf.Name AS 'manf' FROM user u 
JOIN Likes l ON u.username = l.Username
JOIN Vehicle v ON l.VID = v.VID
JOIN Model m ON m.id = v.MID
JOIN Manufacturer manf ON m.Manufacturer = manf.MID
WHERE u.username = user;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getManufacturers`(IN `manf` VARCHAR(20))
    NO SQL
getManf:BEGIN

if ((SELECT count(*)
FROM information_schema.tables
WHERE table_schema = 'findacar'
AND (table_name = 'Vehicle' OR 
     table_name = 'Transmission_Options' OR
     table_name = 'Transmission' OR
     table_name = 'Color_Option' OR 
     table_name = 'Color' OR
     table_name = 'Model' OR
     table_name = 'Manufacturer')) != 7) then
	SIGNAL SQLSTATE '01000'
		SET MESSAGE_TEXT = 'An Error Occured';
		Select 'Missing table in database' as 'error';
		Leave getManf;
END IF;



IF manf = 'fill' THEN SELECT Name FROM Manufacturer;
ELSE SELECT * FROM Manufacturer WHERE Name = manf;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getModelByYear`(IN `manf` VARCHAR(255), IN `year` INT)
    NO SQL
BEGIN

SELECT DISTINCT m.Name 
FROM Model m
JOIN Manufacturer ma ON ma.MID = m.Manufacturer
WHERE ma.Name = manf AND m.Year = year;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getModels`(IN `model` VARCHAR(30))
    NO SQL
BEGIN
 
IF model = 'fill' THEN 
	SELECT m.Name as outmodel, ma.Name as manf 
	FROM Model m
	JOIN Manufacturer ma on ma.MID = m.Manufacturer;
ELSE SELECT * FROM Model WHERE Name = model;
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getowns`(IN `user` VARCHAR(50))
    NO SQL
BEGIN

SELECT v.Trim, v.VID, m.Name AS 'Name', m.Year AS 'Year', manf.Name AS 'manf' FROM user u 
JOIN Owns o ON u.username = o.Username
JOIN Vehicle v ON o.VID = v.VID
JOIN Model m ON m.id = v.MID
JOIN Manufacturer manf ON m.Manufacturer = manf.MID
WHERE u.username = user;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetTransmission`(IN `VID` INT)
    NO SQL
getTransmission:BEGIN

if((select count(*) from  Vehicle where Vehicle.VID = VID) != 1) then
	SIGNAL SQLSTATE '01000'
		SET MESSAGE_TEXT = 'An Error Occured';
		Select 'Not Valid VID' as 'error';
		Leave getTransmission;
END IF;


SELECT T.* 
FROM Vehicle v
JOIN Transmission_Options T1 on v.VID = T1.VID JOIN Transmission T on
T.TID = T1.TID
where v.VID = VID;



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getTrim`(IN `manf` VARCHAR(255), IN `year` INT, IN `model` VARCHAR(255))
    NO SQL
BEGIN

SELECT DISTINCT v.Trim, v.VID 
FROM Vehicle v
JOIN Model m ON m.ID = v.MID
JOIN Manufacturer ma ON ma.MID = m.Manufacturer
WHERE ma.Name = manf AND m.Year = year AND m.Name = model;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getVehicle`(IN `vid` INT)
    NO SQL
getVehicle:BEGIN

if((select count(*) from  Vehicle where Vehicle.VID = vid) != 1) then
	SIGNAL SQLSTATE '01000'
		SET MESSAGE_TEXT = 'An Error Occured';
		Select 'Not Valid VID' as 'error';
		Leave getVehicle;
END IF;

 
SELECT v.*, m.*, manf.Name AS 'manf' FROM Vehicle v
JOIN Model m ON v.MID = m.ID
JOIN Manufacturer manf ON m.Manufacturer = manf.MID
WHERE v.VID = vid;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getYears`(IN `manf` VARCHAR(255))
    NO SQL
BEGIN

SELECT DISTINCT m.Year FROM Model m
JOIN Manufacturer ma ON m.Manufacturer = ma.MID
WHERE ma.Name = manf;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `likecar`(IN `v` INT, IN `u` VARCHAR(50))
    NO SQL
BEGIN

IF NOT EXISTS (SELECT * FROM Likes WHERE Username = u AND VID = v) THEN
	INSERT INTO Likes(Username, VID) VALUES (u,v);
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Login`(IN `un` VARCHAR(255), IN `ps` VARCHAR(255))
    NO SQL
BEGIN

SELECT username, name, email, password, favvid FROM user WHERE username = un and password = saltedHash(un, ps);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `own`(IN `v` INT, IN `u` VARCHAR(50))
    NO SQL
BEGIN
IF NOT EXISTS (SELECT * FROM Owns WHERE Username = u AND VID = v) THEN
	INSERT INTO Owns(Username, VID) VALUES (u,v);
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ReadReview`(IN `invid` INT(11))
    NO SQL
BEGIN
Select Rating,Description,Username
From Reviews
where VID=invid;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `register`(IN `un` VARCHAR(255), IN `name` VARCHAR(255), IN `email` VARCHAR(255), IN `password` VARCHAR(255))
BEGIN
    INSERT INTO user(username, name, email, password, favvid) VALUES (un, name, email, saltedHash(un,password), 0);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `retrieveValues`(IN `c` VARCHAR(50))
retrieveValues:BEGIN

if((c != 'Gen_Color') AND (c != 'Name') AND (c != 'Gears') AND (c != 'Type') AND (c != 'Fuel')) then
        
		SIGNAL SQLSTATE '01000'
		SET MESSAGE_TEXT = 'An Error Occured';
		Select 'Invalid value to retrieve' as 'error';
		Leave retrieveValues;
                                            
END IF;

if ((SELECT count(*)
FROM information_schema.tables
WHERE table_schema = 'findacar'
AND (table_name = 'Vehicle' OR 
     table_name = 'Transmission_Options' OR
     table_name = 'Transmission' OR
     table_name = 'Color_Option' OR 
     table_name = 'Color' OR
     table_name = 'Model' OR
     table_name = 'Manufacturer')) != 7) then
	SIGNAL SQLSTATE '01000'
		SET MESSAGE_TEXT = 'An Error Occured';
		Select 'Missing table in database' as 'error';
		Leave retrieveValues;
END IF;





if c = 'Gen_Color' then
	 Select Gen_Color from Color group by Gen_Color;
elseif c = 'Name' then
	 Select Name from Manufacturer group by Name asc;
elseif c = 'Gears' then 
	 Select Gears from Transmission group by Gears asc;
elseif c = 'Type' then
	 Select Type from Transmission group by Type asc;
elseif c = 'Fuel' then
	 Select  Fuel from Vehicle group by Fuel;
end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SearchACar2`(IN `transmissionS` VARCHAR(255), IN `gearName` VARCHAR(255), IN `manfName` VARCHAR(255), IN `colors` VARCHAR(255), IN `fuel` VARCHAR(255))
    NO SQL
searchACar:BEGIN


if(((Select Locate('select', transmissionS)) !=0)OR ((Select Locate('select', gearName)) !=0) OR
   ((Select Locate('select', manfName)) !=0) OR ((Select Locate('select', colors)) !=0) OR
   ((Select Locate('select', fuel)) !=0)) THEN
SIGNAL SQLSTATE '01000'
		SET MESSAGE_TEXT = 'An Error Occured';
		Select 'SQL Injection Detected, voiding query' as 'error';
		Leave searchACar;
END IF;

if(((Select Locate('Select', transmissionS)) !=0)OR ((Select Locate('Select', gearName)) !=0) OR
   ((Select Locate('Select', manfName)) !=0) OR ((Select Locate('Select', colors)) !=0) OR
   ((Select Locate('Select', fuel)) !=0)) THEN
		SIGNAL SQLSTATE '01000'
		SET MESSAGE_TEXT = 'An Error Occured';
		Select 'SQL Injection Detected, voiding query' as 'error';
		Leave searchACar;
END IF;

if(((Select Locate('delete', transmissionS)) !=0)OR ((Select Locate('delete', gearName)) !=0) OR
   ((Select Locate('delete', manfName)) !=0) OR ((Select Locate('delete', colors)) !=0) OR
   ((Select Locate('delete', fuel)) !=0)) THEN
		SIGNAL SQLSTATE '01000'
		SET MESSAGE_TEXT = 'An Error Occured';
		Select 'SQL Injection Detected, voiding query' as 'error';
		Leave searchACar;
END IF;

if(((Select Locate('Delete', transmissionS)) !=0)OR ((Select Locate('Delete', gearName)) !=0) OR
   ((Select Locate('Delete', manfName)) !=0) OR ((Select Locate('Delete', colors)) !=0) OR
   ((Select Locate('Delete', fuel)) !=0)) THEN
		SIGNAL SQLSTATE '01000'
		SET MESSAGE_TEXT = 'An Error Occured';
		Select 'SQL Injection Detected, voiding query' as 'error';
		Leave searchACar;
END IF;

if(((Select Locate('insert', transmissionS)) !=0)OR ((Select Locate('insert', gearName)) !=0) OR
   ((Select Locate('insert', manfName)) !=0) OR ((Select Locate('insert', colors)) !=0) OR
   ((Select Locate('insert', fuel)) !=0)) THEN
		SIGNAL SQLSTATE '01000'
		SET MESSAGE_TEXT = 'An Error Occured';
		Select 'SQL Injection Detected, voiding query' as 'error';
		Leave searchACar;
END IF;

if(((Select Locate('Insert', transmissionS)) !=0)OR ((Select Locate('Insert', gearName)) !=0) OR
   ((Select Locate('Insert', manfName)) !=0) OR ((Select Locate('Insert', colors)) !=0) OR
   ((Select Locate('Insert', fuel)) !=0)) THEN
		SIGNAL SQLSTATE '01000'
		SET MESSAGE_TEXT = 'An Error Occured';
		Select 'SQL Injection Detected, voiding query' as 'error';
		Leave searchACar;
END IF;

if(((Select Locate('drop', transmissionS)) !=0)OR ((Select Locate('drop', gearName)) !=0) OR
   ((Select Locate('drop', manfName)) !=0) OR ((Select Locate('drop', colors)) !=0) OR
   ((Select Locate('drop', fuel)) !=0)) THEN
		SIGNAL SQLSTATE '01000'
		SET MESSAGE_TEXT = 'An Error Occured';
		Select 'SQL Injection Detected, voiding query' as 'error';
		Leave searchACar;
END IF;


if(((Select Locate('Drop', transmissionS)) !=0)OR ((Select Locate('Drop', gearName)) !=0) OR
   ((Select Locate('Drop', manfName)) !=0) OR ((Select Locate('Drop', colors)) !=0) OR
   ((Select Locate('Drop', fuel)) !=0)) THEN
		SIGNAL SQLSTATE '01000'
		SET MESSAGE_TEXT = 'An Error Occured';
		Select 'SQL Injection Detected, voiding query' as 'error';
		Leave searchACar;
END IF;

if(((Select Locate('update', transmissionS)) !=0)OR ((Select Locate('update', gearName)) !=0) OR
   ((Select Locate('update', manfName)) !=0) OR ((Select Locate('update', colors)) !=0) OR
   ((Select Locate('update', fuel)) !=0)) THEN
		SIGNAL SQLSTATE '01000'
		SET MESSAGE_TEXT = 'An Error Occured';
		Select 'SQL Injection Detected, voiding query' as 'error';
		Leave searchACar;
END IF;

if(((Select Locate('Update', transmissionS)) !=0)OR ((Select Locate('Update', gearName)) !=0) OR
   ((Select Locate('Update', manfName)) !=0) OR ((Select Locate('Update', colors)) !=0) OR
   ((Select Locate('Update', fuel)) !=0)) THEN
		SIGNAL SQLSTATE '01000'
		SET MESSAGE_TEXT = 'An Error Occured';
		Select 'SQL Injection Detected, voiding query' as 'error';
		Leave searchACar;
END IF;


if(char_length(gearName) > 15) then
	SIGNAL SQLSTATE '01000'
		SET MESSAGE_TEXT = 'An Error Occured';
		Select 'Invalid input for gear count' as 'error';
		Leave searchACar;
END IF;
if((char_length(transmissionS) > 26) OR ((char_length(transmissionS) != 0) AND (char_length(transmissionS)<2))) then
	SIGNAL SQLSTATE '01000'
		SET MESSAGE_TEXT = 'An Error Occured';
		Select 'Invalid input for transmission type' as 'error';
		Leave searchACar;
END IF;
if((char_length(manfName) > 44) OR ((char_length(manfName) < 4)AND (char_length(manfName)!= 2))) then
	SIGNAL SQLSTATE '01000'
		SET MESSAGE_TEXT = 'An Error Occured';
		Select 'Invalid input for manufacturer name' as 'error';
		Leave searchACar;
END IF; 

if(char_length(colors) > 255) then
	SIGNAL SQLSTATE '01000'
		SET MESSAGE_TEXT = 'An Error Occured';
		Select 'Invalid input for color name' as 'error';
		Leave searchACar;
END IF;       

if(char_length(fuel) > 36 OR ((char_length(fuel) < 16) AND (char_length(fuel) != 2))) then
	SIGNAL SQLSTATE '01000'
		SET MESSAGE_TEXT = 'An Error Occured';
		Select 'Invalid input for fuel name' as 'error';
		Leave searchACar;
END IF;                                                                          

SET @lengthG = char_length(gearName);
SET @lengthT = char_length(transmissionS);
SET @lengthM = char_length(manfName);
SET @lengthC = char_length(colors);
SET @lengthF = char_length(fuel);
SET @gearLine = '';
SET @transLine = '';
SET @manfLine = '';
SET @colorLine = '';
SET @fuelLine = '';
SET @where = '';
if(@lengthG> 2 OR @lengthT > 2 OR @lengthM >2 OR @lengthC > 2 OR @lengthF > 2) then
		SET @where = ' where ';
END IF;


if ((SELECT count(*)
FROM information_schema.tables
WHERE table_schema = 'findacar'
AND (table_name = 'Vehicle' OR 
     table_name = 'Transmission_Options' OR
     table_name = 'Transmission' OR
     table_name = 'Color_Option' OR 
     table_name = 'Color' OR
     table_name = 'Model' OR
     table_name = 'Manufacturer')) != 7) then
	SIGNAL SQLSTATE '01000'
		SET MESSAGE_TEXT = 'An Error Occured';
		Select 'Missing table in database' as 'error';
		Leave searchACar;
END IF;


/**Select @lengthT, @lengthG, @lengthM, @lengthC, @lengthF; **/
SET gearName =  Replace(gearName, '**', "','");
SET transmissionS =  Replace(transmissionS, '**', "','");
SET manfName =   Replace(manfName, '**', "','");
SET colors =   Replace(colors, '**', "','");
SET fuel =  Replace(fuel, '**', "','");
if(@lengthG > 2) then
	SET @gearLine = CONCAT('Tr.Gears IN (', gearName, ') ');
	if(@lengthT > 2 OR @lengthM >2 OR @lengthC > 2 OR @lengthF > 2) then
		SET @gearLine = CONCAT(@gearLine, ' AND ');
	END IF;
END IF;
IF(@lengthM > 2) then
	SET @manfLine = CONCAT('Man.Name IN (',manfName,') ');
	if(@lengthT > 2 OR @lengthC > 2 OR @lengthF > 2) then
		SET @manfLine = CONCAT(@manfLine, ' AND ');
	END IF;
END IF;
IF(@lengthF > 2) THEN
	SET @fuelLine = CONCAT('V.Fuel IN (',fuel,') ');
	IF (@lengthT > 2 OR @lengthC > 2) then
		SET @fuelLine = CONCAT(@fuelLine, ' AND ' );
	END IF;
END IF;
IF(@lengthC > 2) THEN
	SET @colorLine = CONCAT('C.Gen_Color IN (',colors,') ');
	IF (@lengthT > 2) then
		SET @colorLine = CONCAT(@colorLine, ' AND ' );
	END IF;
END IF;
IF(@lengthT > 2) THEN
	SET @transLine = CONCAT('Tr.Type IN (',transmissionS,') ');
END IF;

SET @query2 = CONCAT(
    'SELECT DISTINCT Man.Name as "manf", M.Name as "mod",
    M.Year as "year", V.Trim as "trim", V.VID AS
    "VID" FROM Vehicle V
JOIN Transmission_Options TrO on V.VID = TrO.VID 
JOIN Transmission Tr on  TrO.TID = Tr.TID
JOIN Color_Option Co on V.VID = Co.VID
JOIN Color C on C.Color = Co.Color
JOIN Model M on M.ID = V.MID 
JOIN Manufacturer Man on Man.MID = M.Manufacturer ', @where ,@gearLine , @manfLine, @fuelLine, @colorLine, @transLine, ' ;');
/**
Select @query;
Select @query2;
**/


PREPARE stmt FROM @query2;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `writeReview`(IN `UserName` VARCHAR(50), IN `VID` INT(11), IN `Rating` INT(11), IN `Descr` VARCHAR(1000))
    NO SQL
BEGIN

Insert into Reviews Values(Username,VID,Rating,Descr);


END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `saltedHash`(`username` VARCHAR(255), `password` VARCHAR(255)) RETURNS binary(20)
    DETERMINISTIC
RETURN UNHEX(SHA1(CONCAT(username, password)))$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `Color`
--

CREATE TABLE IF NOT EXISTS `Color` (
  `Color` varchar(75) NOT NULL DEFAULT '',
  `Gen_Color` varchar(25) DEFAULT NULL,
  `Links` varchar(500) NOT NULL,
  PRIMARY KEY (`Color`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Color`
--

INSERT INTO `Color` (`Color`, `Gen_Color`, `Links`) VALUES
('Absolutely Red', 'Red', ''),
('Alabaster Silver Metallic', 'Silver', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/alabaster_silver_metall'),
('Amazon Green Metallic', 'Green', ''),
('Amazon Metallic Green', 'Green', ''),
('Army Rock Metallic', 'Brown', ''),
('Atlantis Green Metallic', 'Green', ''),
('Atomic Blue Metallic', 'Blue', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/atomic_blue_metallic.gi'),
('Azura Blue', 'Blue', ''),
('Azurite Blue Pearl', 'Blue', ''),
('Bali Blue Pearl', 'Blue', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/bali_blue_pearl.gif'),
('Barcelona Red Metallic', 'Red', ''),
('Basque Red Pearl', 'Red', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/basque_red_pearl.gif'),
('Bayou Blue Pearl', 'Blue', ''),
('Belize Blue Pearl', 'Blue', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/belize_blue_pearl.gif'),
('Black', 'Black', ''),
('Black Currant Metallic', 'Black', ''),
('Black Obsidian', 'Black', ''),
('Black Pearl Slate Metallic', 'Black', ''),
('Black Sand Pearl', 'Black', ''),
('Blackberry Pearl', 'Blue', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/blackberry_pearl.gif'),
('Blazing Blue Pearl', 'Blue', ''),
('Blizzard Pearl', 'Blue', ''),
('Blue Flame Metallic', 'Blue', ''),
('Blue Streak Metallic', 'Blue', ''),
('Bold Beige Metallic', 'Tan', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/bold_beige_metallic.gif'),
('Brilliant Silver Metallic', 'Silver', ''),
('Camelia Red Pearl', 'Red', ''),
('Carmine Red Metallic', 'Red', ''),
('Cement', 'Gray', ''),
('Cinnamon Metallic', 'Red', ''),
('Citrus Fire Metallic', 'Orange', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/citrus_fire_metallic.gi'),
('Classic Silver Metallic', 'Silver', ''),
('Clear Sky Blue Metallic', 'Blue', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/clear_sky_blue_metallic'),
('Code Red', 'Red', ''),
('Crystal Black Pearl', 'Black', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/crystal_black_pearl.gif'),
('Crystal Black Sillica', 'Black', ''),
('Cypress Green Pearl', 'Green', ''),
('Dark Blue', 'Blue', ''),
('Dark Blue Pearl Metallic', 'blue', ''),
('Dark Cherry Pearl', 'Red', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/dark_cherry_pearl.gif'),
('Dark Copper Metallic', 'Red', ''),
('Dark Gray Metallic', 'Gray', ''),
('Dark Ink Blue Metallic', 'Blue', ''),
('Dark Shadow Grey Metallic', 'Gray', ''),
('Dark Slate', 'Gray', ''),
('Dyno Blue Pearl', 'Blue', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/dyno_blue_pearl.gif'),
('Elusive Blue Metallic', 'Blue', ''),
('Flint Mica', 'Gray', ''),
('Frost', 'White', ''),
('Frozen White', 'White', ''),
('Glacier Blue Metallic', 'Blue', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/glacier_blue_metallic.g'),
('Gold Leaf Metallic', 'Gold', ''),
('Grabber Blue', 'blue', ''),
('Graphite Gray Metallic', 'Gray', ''),
('Gun Metallic', 'Gray', ''),
('Harvest Gold Metallic', 'Gold', ''),
('Hot Lava', 'Red', ''),
('Hypnotic Teal Mica', 'Blue', ''),
('Ingot Silver Metallic', 'Silver', ''),
('Ivory Pearl', 'White', ''),
('Jade Sea Metallic', 'Green', ''),
('Kiwi Green Metallic', 'Green', ''),
('Kona Blue Metallic', 'Blue', ''),
('Lava Metallic', 'Red', ''),
('Light Ice Blue Metallic', 'Blue', ''),
('Lightning Red', 'Red', ''),
('Magnetic Gray Metallic', 'Gray', ''),
('Magnetic Pearl', 'Gray', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/magnetic_pearl.gif'),
('Meteorite Metallic', 'Gray', ''),
('Milano Red', 'Red', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/milano_red.gif'),
('Mocha Metallic', 'Brown', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/mocha_metallic.gif'),
('Molten Orange Metallic Tri-coat', 'Orange', ''),
('Mystic Green Metallic', 'Green', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/mystic_green_metallic.g'),
('Natural Neutral Metallic', 'Gray', ''),
('Nautical Blue Metallic', 'Blue', ''),
('Navy Blue', 'Blue', ''),
('Newport Blue Pearl', 'Blue', ''),
('Obsidian Black Pearl', 'Black', ''),
('Ocean Mist Metallic', 'Blue', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/ocean_mist_metallic.gif'),
('Omni Blue Pearl', 'Blue', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/omni_blue_pearl.gif'),
('Opal Sage Metallic', 'Green', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/opal_sage_metallic.gif'),
('Orange Revolution Metallic', 'Orange', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/orange_revolution_metal'),
('Oxford White', 'White', ''),
('Pacific Blue Metallic', 'Blue', ''),
('Panther Black Metallic', 'Black', ''),
('Paprika Red Pearl', 'Red', ''),
('Paprila Red Pearl', 'Red', ''),
('Performance White', 'White', ''),
('Polar White', 'White', ''),
('Polished Metal Metallic', 'Silver', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/polished_metal_metallic'),
('Precision Gray', 'Gray', ''),
('Pueble Gold Metallic', 'gold', ''),
('Pueblo Gold Metallic', 'Gold', ''),
('Radiant Silver', 'Silver', ''),
('Rallye Red', 'Red', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/rallye_red.gif'),
('Red Brick', 'Red', ''),
('Red Candy Metallic Tinted Clearcoat', 'Red', ''),
('Redfire Metallic', 'Red', ''),
('Redline Orange Pearl', 'Orange', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/redline_orange_pearl.gi'),
('Royal Blue Pearl', 'Blue', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/royal_blue_pearl.gif'),
('Royal Red Metallic', 'Red', ''),
('Ruby Red Pearl', 'Red', ''),
('Sage Green Metallic', 'Green', ''),
('San Marino Red', 'Red', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/san_marino_red.gif'),
('Sangria Red Metallic', 'Red', ''),
('Satin White Pearl', 'White', ''),
('School Bus Yellow', 'Yellow', ''),
('Silver Metallic', 'Silver', ''),
('Silver Streak Kica', 'Silver', ''),
('Silver Streak Metallic', 'Silver', ''),
('Sizzling Crimson Mica', 'Red', ''),
('Sky Blue Metallic', 'Blue', ''),
('Slate Green Metallic', 'Gray', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/slate_green_metallic.gi'),
('Smokestone Metallic', 'Silver', ''),
('Solid Red', 'Red', ''),
('Sonoran Sand', 'Tan', ''),
('Spark Silver Metallic', 'Silver', ''),
('Spectrum White Pearl', 'White', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/spectrum_white_pearl.gi'),
('Sport Blue Metallic', 'Blue', ''),
('Steel Blue Metallic', 'Blue', ''),
('Steel Silver Metallic', 'Silver', ''),
('Sterling Grey Metallic', 'Gray', ''),
('Stingray Metallic', 'Gray', ''),
('Storm Silver Metallic', 'Silver', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/storm_silver_metallic.g'),
('Sunset Gold Metallic', 'Gold', ''),
('Super Black', 'Black', ''),
('Super Silver', 'Silver', ''),
('Super White', 'White', ''),
('Taffeta White', 'White', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/taffeta_white.gif'),
('Tango Red Pearl', 'Red', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/tango_red_pearl.gif'),
('Tidewater Blue Metallic', 'Blue', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/tidewater_blue_metallic'),
('Titanium', 'Gray', ''),
('Torch Red', 'Red', ''),
('Tuxedo Black Metallic', 'Black', ''),
('Urban Titanium Metallic', 'Silver', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/urban_titanium_metallic'),
('Vermillion Red', 'Red', ''),
('Vista Blue Metallic', 'Blue', ''),
('Wave Line Pearl', 'Blue', ''),
('White', 'White', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/white.gif'),
('White Diamond Pearl', 'White', 'http://automobiles.honda.com/images/tools/customize/colors/exterior_swatches/white_diamond_pearl.gif'),
('White Platinum Metallic Tri-Coat', 'White', ''),
('White Suede', 'White', ''),
('Winter Frost', 'White', ''),
('WR Blue Mica', 'Blue', ''),
('Yellow Jolt', 'Yellow', ''),
('Zephyr Blue Metallic', 'Blue', '');

-- --------------------------------------------------------

--
-- Table structure for table `Color_Option`
--

CREATE TABLE IF NOT EXISTS `Color_Option` (
  `VID` int(11) DEFAULT NULL,
  `Color` varchar(75) DEFAULT NULL,
  KEY `Color` (`Color`),
  KEY `VID` (`VID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Color_Option`
--

INSERT INTO `Color_Option` (`VID`, `Color`) VALUES
(0, 'Black Sand Pearl'),
(0, 'Sizzling Crimson Mica'),
(0, 'Super White'),
(0, 'Wave Line Pearl'),
(0, 'Classic Silver Metallic'),
(0, 'Flint Mica'),
(0, 'Nautical Blue Metallic'),
(1, 'Black Sand Pearl'),
(1, 'Sizzling Crimson Mica'),
(1, 'Super White'),
(1, 'Wave Line Pearl'),
(1, 'Classic Silver Metallic'),
(1, 'Flint Mica'),
(1, 'Nautical Blue Metallic'),
(4, 'Black Sand Pearl'),
(4, 'Polar White'),
(4, 'Yellow Jolt'),
(4, 'Barcelona Red Metallic'),
(4, 'Meteorite Metallic'),
(4, 'Blazing Blue Pearl'),
(4, 'Jade Sea Metallic'),
(4, 'Bayou Blue Pearl'),
(4, 'Zephyr Blue Metallic'),
(4, 'Absolutely Red'),
(4, 'Flint Mica'),
(4, 'Pacific Blue Metallic'),
(4, 'Carmine Red Metallic'),
(4, 'Silver Streak Metallic'),
(4, 'Blue Streak Metallic'),
(9, 'Black Sand Pearl'),
(9, 'Polar White'),
(9, 'Yellow Jolt'),
(9, 'Barcelona Red Metallic'),
(9, 'Meteorite Metallic'),
(9, 'Blazing Blue Pearl'),
(9, 'Jade Sea Metallic'),
(9, 'Bayou Blue Pearl'),
(9, 'Zephyr Blue Metallic'),
(9, 'Absolutely Red'),
(9, 'Flint Mica'),
(9, 'Pacific Blue Metallic'),
(9, 'Carmine Red Metallic'),
(9, 'Silver Streak Metallic'),
(9, 'Blue Streak Metallic'),
(10, 'Black Sand Pearl'),
(10, 'Polar White'),
(10, 'Yellow Jolt'),
(10, 'Barcelona Red Metallic'),
(10, 'Meteorite Metallic'),
(10, 'Blazing Blue Pearl'),
(10, 'Jade Sea Metallic'),
(10, 'Bayou Blue Pearl'),
(10, 'Zephyr Blue Metallic'),
(10, 'Absolutely Red'),
(10, 'Flint Mica'),
(10, 'Pacific Blue Metallic'),
(10, 'Carmine Red Metallic'),
(10, 'Silver Streak Metallic'),
(10, 'Blue Streak Metallic'),
(13, 'Black Sand Pearl'),
(13, 'Polar White'),
(13, 'Yellow Jolt'),
(13, 'Barcelona Red Metallic'),
(13, 'Meteorite Metallic'),
(13, 'Blazing Blue Pearl'),
(13, 'Jade Sea Metallic'),
(13, 'Bayou Blue Pearl'),
(13, 'Zephyr Blue Metallic'),
(13, 'Absolutely Red'),
(13, 'Flint Mica'),
(13, 'Pacific Blue Metallic'),
(13, 'Carmine Red Metallic'),
(13, 'Silver Streak Metallic'),
(13, 'Blue Streak Metallic'),
(18, 'Black Sand Pearl'),
(18, 'Polar White'),
(18, 'Yellow Jolt'),
(18, 'Barcelona Red Metallic'),
(18, 'Meteorite Metallic'),
(18, 'Blazing Blue Pearl'),
(18, 'Jade Sea Metallic'),
(18, 'Bayou Blue Pearl'),
(18, 'Zephyr Blue Metallic'),
(18, 'Absolutely Red'),
(18, 'Flint Mica'),
(18, 'Pacific Blue Metallic'),
(18, 'Carmine Red Metallic'),
(18, 'Silver Streak Metallic'),
(18, 'Blue Streak Metallic'),
(19, 'Black Sand Pearl'),
(19, 'Polar White'),
(19, 'Yellow Jolt'),
(19, 'Barcelona Red Metallic'),
(19, 'Meteorite Metallic'),
(19, 'Blazing Blue Pearl'),
(19, 'Jade Sea Metallic'),
(19, 'Bayou Blue Pearl'),
(19, 'Zephyr Blue Metallic'),
(19, 'Absolutely Red'),
(19, 'Flint Mica'),
(19, 'Pacific Blue Metallic'),
(19, 'Carmine Red Metallic'),
(19, 'Silver Streak Metallic'),
(19, 'Blue Streak Metallic'),
(7, 'Black'),
(7, 'Cement'),
(7, 'Super White'),
(7, 'Magnetic Gray Metallic'),
(7, 'Classic Silver Metallic'),
(7, 'Sizzling Crimson Mica'),
(7, 'Nautical Blue Metallic'),
(8, 'Black'),
(8, 'Cement'),
(8, 'Super White'),
(8, 'Magnetic Gray Metallic'),
(8, 'Classic Silver Metallic'),
(8, 'Sizzling Crimson Mica'),
(8, 'Nautical Blue Metallic'),
(17, 'Super White'),
(17, 'Classic Silver Metallic'),
(17, 'Magnetic Gray Metallic'),
(17, 'Black'),
(17, 'Cement'),
(17, 'Sizzling Crimson Mica'),
(17, 'Nautical Blue Metallic'),
(16, 'Super White'),
(16, 'Classic Silver Metallic'),
(16, 'Magnetic Gray Metallic'),
(16, 'Black'),
(16, 'Cement'),
(16, 'Sizzling Crimson Mica'),
(16, 'Nautical Blue Metallic'),
(5, 'Silver Streak Kica'),
(5, 'Black Sand Pearl'),
(5, 'Nautical Blue Metallic'),
(5, 'Super White'),
(5, 'Magnetic Gray Metallic'),
(5, 'Barcelona Red Metallic'),
(6, 'Silver Streak Kica'),
(6, 'Black Sand Pearl'),
(6, 'Nautical Blue Metallic'),
(6, 'Super White'),
(6, 'Magnetic Gray Metallic'),
(6, 'Barcelona Red Metallic'),
(14, 'Silver Streak Kica'),
(14, 'Black Sand Pearl'),
(14, 'Nautical Blue Metallic'),
(14, 'Super White'),
(14, 'Magnetic Gray Metallic'),
(14, 'Barcelona Red Metallic'),
(14, 'Classic Silver Metallic'),
(14, 'Amazon Green Metallic'),
(14, 'Black Currant Metallic'),
(15, 'Silver Streak Kica'),
(15, 'Black Sand Pearl'),
(15, 'Nautical Blue Metallic'),
(15, 'Super White'),
(15, 'Magnetic Gray Metallic'),
(15, 'Barcelona Red Metallic'),
(15, 'Classic Silver Metallic'),
(15, 'Amazon Green Metallic'),
(15, 'Black Currant Metallic'),
(22, 'Silver Streak Kica'),
(22, 'Black Sand Pearl'),
(22, 'Nautical Blue Metallic'),
(22, 'Super White'),
(22, 'Magnetic Gray Metallic'),
(22, 'Barcelona Red Metallic'),
(22, 'Classic Silver Metallic'),
(22, 'Amazon Green Metallic'),
(22, 'Black Currant Metallic'),
(23, 'Silver Streak Kica'),
(23, 'Black Sand Pearl'),
(23, 'Nautical Blue Metallic'),
(23, 'Super White'),
(23, 'Magnetic Gray Metallic'),
(23, 'Barcelona Red Metallic'),
(23, 'Classic Silver Metallic'),
(23, 'Amazon Green Metallic'),
(23, 'Black Currant Metallic'),
(3, 'Black Sand Pearl'),
(3, 'Sizzling Crimson Mica'),
(3, 'Super White'),
(3, 'Hypnotic Teal Mica'),
(3, 'Classic Silver Metallic'),
(3, 'Stingray Metallic'),
(2, 'Black Sand Pearl'),
(2, 'Sizzling Crimson Mica'),
(2, 'Super White'),
(2, 'Hypnotic Teal Mica'),
(2, 'Classic Silver Metallic'),
(2, 'Stingray Metallic'),
(11, 'Super White'),
(11, 'Classic Silver Metallic'),
(11, 'Black Sand Pearl'),
(11, 'Army Rock Metallic'),
(11, 'Stingray Metallic'),
(11, 'Elusive Blue Metallic'),
(12, 'Super White'),
(12, 'Classic Silver Metallic'),
(12, 'Black Sand Pearl'),
(12, 'Army Rock Metallic'),
(12, 'Stingray Metallic'),
(12, 'Elusive Blue Metallic'),
(20, 'Super White'),
(20, 'Classic Silver Metallic'),
(20, 'Black Sand Pearl'),
(20, 'Army Rock Metallic'),
(20, 'Stingray Metallic'),
(20, 'Elusive Blue Metallic'),
(21, 'Super White'),
(21, 'Classic Silver Metallic'),
(21, 'Black Sand Pearl'),
(21, 'Army Rock Metallic'),
(21, 'Stingray Metallic'),
(21, 'Elusive Blue Metallic'),
(24, 'Blizzard Pearl'),
(24, 'Classic Silver Metallic'),
(24, 'Magnetic Gray Metallic'),
(24, 'Black Sand Pearl'),
(24, 'Hot Lava'),
(24, 'Pacific Blue Metallic'),
(24, 'Black Currant Metallic'),
(30, 'Alabaster Silver Metallic'),
(30, 'Belize Blue Pearl'),
(30, 'Crystal Black Pearl'),
(30, 'Polished Metal Metallic'),
(30, 'San Marino Red'),
(30, 'Taffeta White'),
(31, 'Alabaster Silver Metallic'),
(31, 'Belize Blue Pearl'),
(31, 'Crystal Black Pearl'),
(31, 'Polished Metal Metallic'),
(31, 'San Marino Red'),
(31, 'Taffeta White'),
(32, 'Alabaster Silver Metallic'),
(32, 'Belize Blue Pearl'),
(32, 'Crystal Black Pearl'),
(32, 'Polished Metal Metallic'),
(32, 'San Marino Red'),
(32, 'Taffeta White'),
(33, 'Alabaster Silver Metallic'),
(33, 'Belize Blue Pearl'),
(33, 'Crystal Black Pearl'),
(33, 'Polished Metal Metallic'),
(33, 'San Marino Red'),
(33, 'Taffeta White'),
(34, 'Alabaster Silver Metallic'),
(34, 'Belize Blue Pearl'),
(34, 'Crystal Black Pearl'),
(34, 'Polished Metal Metallic'),
(34, 'San Marino Red'),
(34, 'Taffeta White'),
(35, 'Alabaster Silver Metallic'),
(35, 'Basque Red Pearl'),
(35, 'Bold Beige Metallic'),
(35, 'Crystal Black Pearl'),
(35, 'Polished Metal Metallic'),
(35, 'Royal Blue Pearl'),
(35, 'Taffeta White'),
(36, 'Basque Red Pearl'),
(36, 'Bold Beige Metallic'),
(36, 'Crystal Black Pearl'),
(36, 'Polished Metal Metallic'),
(36, 'Royal Blue Pearl'),
(36, 'Taffeta White'),
(37, 'Basque Red Pearl'),
(37, 'Bold Beige Metallic'),
(37, 'Crystal Black Pearl'),
(37, 'Polished Metal Metallic'),
(37, 'Royal Blue Pearl'),
(37, 'Taffeta White'),
(38, 'Basque Red Pearl'),
(38, 'Bold Beige Metallic'),
(38, 'Crystal Black Pearl'),
(38, 'Polished Metal Metallic'),
(38, 'Royal Blue Pearl'),
(38, 'Taffeta White'),
(51, 'Satin White Pearl'),
(51, 'Spark Silver Metallic'),
(51, 'Paprila Red Pearl'),
(51, 'Camelia Red Pearl'),
(51, 'Newport Blue Pearl'),
(51, 'Dark Gray Metallic'),
(51, 'Obsidian Black Pearl'),
(52, 'Satin White Pearl'),
(52, 'Spark Silver Metallic'),
(52, 'Paprila Red Pearl'),
(52, 'Camelia Red Pearl'),
(52, 'Newport Blue Pearl'),
(52, 'Dark Gray Metallic'),
(52, 'Obsidian Black Pearl'),
(53, 'Satin White Pearl'),
(53, 'Spark Silver Metallic'),
(53, 'Paprila Red Pearl'),
(53, 'Camelia Red Pearl'),
(53, 'Newport Blue Pearl'),
(53, 'Dark Gray Metallic'),
(53, 'Obsidian Black Pearl'),
(54, 'Satin White Pearl'),
(54, 'Spark Silver Metallic'),
(54, 'Paprila Red Pearl'),
(54, 'Camelia Red Pearl'),
(54, 'Newport Blue Pearl'),
(54, 'Dark Gray Metallic'),
(54, 'Obsidian Black Pearl'),
(55, 'Satin White Pearl'),
(55, 'Spark Silver Metallic'),
(55, 'Paprila Red Pearl'),
(55, 'Camelia Red Pearl'),
(55, 'Newport Blue Pearl'),
(55, 'Dark Gray Metallic'),
(55, 'Obsidian Black Pearl'),
(56, 'Satin White Pearl'),
(56, 'Spark Silver Metallic'),
(56, 'Paprila Red Pearl'),
(56, 'Camelia Red Pearl'),
(56, 'Newport Blue Pearl'),
(56, 'Dark Gray Metallic'),
(56, 'Obsidian Black Pearl'),
(57, 'Satin White Pearl'),
(57, 'Spark Silver Metallic'),
(57, 'Paprila Red Pearl'),
(57, 'Camelia Red Pearl'),
(57, 'Newport Blue Pearl'),
(57, 'Dark Gray Metallic'),
(57, 'Obsidian Black Pearl'),
(58, 'Satin White Pearl'),
(58, 'Spark Silver Metallic'),
(58, 'Lightning Red'),
(58, 'WR Blue Mica'),
(58, 'Dark Gray Metallic'),
(58, 'Obsidian Black Pearl'),
(59, 'Satin White Pearl'),
(59, 'Spark Silver Metallic'),
(59, 'Lightning Red'),
(59, 'WR Blue Mica'),
(59, 'Dark Gray Metallic'),
(59, 'Obsidian Black Pearl'),
(60, 'Satin White Pearl'),
(60, 'Spark Silver Metallic'),
(60, 'Lightning Red'),
(60, 'WR Blue Mica'),
(60, 'Dark Gray Metallic'),
(60, 'Obsidian Black Pearl'),
(61, 'Satin White Pearl'),
(61, 'Spark Silver Metallic'),
(61, 'Lightning Red'),
(61, 'WR Blue Mica'),
(61, 'Dark Gray Metallic'),
(61, 'Obsidian Black Pearl'),
(62, 'Satin White Pearl'),
(62, 'Spark Silver Metallic'),
(62, 'Lightning Red'),
(62, 'WR Blue Mica'),
(62, 'Dark Gray Metallic'),
(62, 'Obsidian Black Pearl'),
(63, 'Satin White Pearl'),
(63, 'Spark Silver Metallic'),
(63, 'Lightning Red'),
(63, 'WR Blue Mica'),
(63, 'Dark Gray Metallic'),
(63, 'Obsidian Black Pearl'),
(64, 'Satin White Pearl'),
(64, 'Spark Silver Metallic'),
(64, 'Lightning Red'),
(64, 'WR Blue Mica'),
(64, 'Dark Gray Metallic'),
(64, 'Obsidian Black Pearl'),
(65, 'Satin White Pearl'),
(65, 'Spark Silver Metallic'),
(65, 'Lightning Red'),
(65, 'WR Blue Mica'),
(65, 'Dark Gray Metallic'),
(65, 'Obsidian Black Pearl'),
(66, 'Satin White Pearl'),
(66, 'Spark Silver Metallic'),
(66, 'Lightning Red'),
(66, 'WR Blue Mica'),
(66, 'Dark Gray Metallic'),
(66, 'Obsidian Black Pearl'),
(67, 'Satin White Pearl'),
(67, 'Spark Silver Metallic'),
(67, 'Lightning Red'),
(67, 'WR Blue Mica'),
(67, 'Dark Gray Metallic'),
(67, 'Obsidian Black Pearl'),
(68, 'Satin White Pearl'),
(68, 'Spark Silver Metallic'),
(68, 'Lightning Red'),
(68, 'WR Blue Mica'),
(68, 'Dark Gray Metallic'),
(68, 'Obsidian Black Pearl'),
(69, 'Satin White Pearl'),
(69, 'Spark Silver Metallic'),
(69, 'Lightning Red'),
(69, 'WR Blue Mica'),
(69, 'Dark Gray Metallic'),
(69, 'Obsidian Black Pearl'),
(83, 'Blue Flame Metallic'),
(83, 'Sangria Red Metallic'),
(83, 'White Suede'),
(83, 'Natural Neutral Metallic'),
(83, 'Ingot Silver Metallic'),
(83, 'Sterling Grey Metallic'),
(83, 'Black'),
(86, 'Satin White Pearl'),
(86, 'Steel Silver Metallic'),
(86, 'Harvest Gold Metallic'),
(86, 'Sky Blue Metallic'),
(86, 'Azurite Blue Pearl'),
(86, 'Ruby Red Pearl'),
(86, 'Graphite Gray Metallic'),
(86, 'Crystal Black Sillica'),
(87, 'Satin White Pearl'),
(87, 'Steel Silver Metallic'),
(87, 'Harvest Gold Metallic'),
(87, 'Sky Blue Metallic'),
(87, 'Azurite Blue Pearl'),
(87, 'Ruby Red Pearl'),
(87, 'Graphite Gray Metallic'),
(87, 'Crystal Black Sillica'),
(88, 'Satin White Pearl'),
(88, 'Steel Silver Metallic'),
(88, 'Harvest Gold Metallic'),
(88, 'Sky Blue Metallic'),
(88, 'Azurite Blue Pearl'),
(88, 'Ruby Red Pearl'),
(88, 'Graphite Gray Metallic'),
(88, 'Crystal Black Sillica'),
(89, 'Satin White Pearl'),
(89, 'Steel Silver Metallic'),
(89, 'Harvest Gold Metallic'),
(89, 'Sky Blue Metallic'),
(89, 'Azurite Blue Pearl'),
(89, 'Ruby Red Pearl'),
(89, 'Graphite Gray Metallic'),
(89, 'Crystal Black Sillica'),
(90, 'Satin White Pearl'),
(90, 'Steel Silver Metallic'),
(90, 'Harvest Gold Metallic'),
(90, 'Sky Blue Metallic'),
(90, 'Azurite Blue Pearl'),
(90, 'Ruby Red Pearl'),
(90, 'Graphite Gray Metallic'),
(90, 'Crystal Black Sillica'),
(91, 'Satin White Pearl'),
(91, 'Steel Silver Metallic'),
(91, 'Harvest Gold Metallic'),
(91, 'Sky Blue Metallic'),
(91, 'Azurite Blue Pearl'),
(91, 'Ruby Red Pearl'),
(91, 'Graphite Gray Metallic'),
(91, 'Crystal Black Sillica'),
(92, 'Satin White Pearl'),
(92, 'Steel Silver Metallic'),
(92, 'Harvest Gold Metallic'),
(92, 'Sky Blue Metallic'),
(92, 'Azurite Blue Pearl'),
(92, 'Ruby Red Pearl'),
(92, 'Graphite Gray Metallic'),
(92, 'Crystal Black Sillica'),
(93, 'Satin White Pearl'),
(93, 'Steel Silver Metallic'),
(93, 'Harvest Gold Metallic'),
(93, 'Sky Blue Metallic'),
(93, 'Azurite Blue Pearl'),
(93, 'Ruby Red Pearl'),
(93, 'Graphite Gray Metallic'),
(93, 'Crystal Black Sillica'),
(94, 'Satin White Pearl'),
(94, 'Steel Silver Metallic'),
(94, 'Harvest Gold Metallic'),
(94, 'Sky Blue Metallic'),
(94, 'Azurite Blue Pearl'),
(94, 'Ruby Red Pearl'),
(94, 'Graphite Gray Metallic'),
(94, 'Crystal Black Sillica'),
(95, 'Satin White Pearl'),
(95, 'Steel Silver Metallic'),
(95, 'Harvest Gold Metallic'),
(95, 'Sky Blue Metallic'),
(95, 'Azurite Blue Pearl'),
(95, 'Ruby Red Pearl'),
(95, 'Graphite Gray Metallic'),
(95, 'Crystal Black Sillica'),
(97, 'Blue Flame Metallic'),
(97, 'Sangria Red Metallic'),
(97, 'White Suede'),
(97, 'Natural Neutral Metallic'),
(97, 'Ingot Silver Metallic'),
(97, 'Sterling Grey Metallic'),
(97, 'Black'),
(99, 'Blue Flame Metallic'),
(101, 'Blue Flame Metallic'),
(99, 'Sangria Red Metallic'),
(101, 'Sangria Red Metallic'),
(99, 'White Suede'),
(101, 'White Suede'),
(99, 'Natural Neutral Metallic'),
(101, 'Natural Neutral Metallic'),
(99, 'Ingot Silver Metallic'),
(101, 'Ingot Silver Metallic'),
(99, 'Sterling Grey Metallic'),
(101, 'Sterling Grey Metallic'),
(99, 'Black'),
(101, 'Black'),
(103, 'Blue Flame Metallic'),
(103, 'Sangria Red Metallic'),
(103, 'White Suede'),
(103, 'Natural Neutral Metallic'),
(103, 'Ingot Silver Metallic'),
(103, 'Sterling Grey Metallic'),
(103, 'Blue Flame Metallic'),
(103, 'Sangria Red Metallic'),
(103, 'White Suede'),
(103, 'Natural Neutral Metallic'),
(103, 'Ingot Silver Metallic'),
(103, 'Sterling Grey Metallic'),
(103, 'Black'),
(104, 'Blue Flame Metallic'),
(104, 'Sangria Red Metallic'),
(104, 'White Suede'),
(104, 'Natural Neutral Metallic'),
(104, 'Ingot Silver Metallic'),
(104, 'Sterling Grey Metallic'),
(104, 'Black'),
(105, 'Sangria Red Metallic'),
(105, 'Smokestone Metallic'),
(105, 'Tuxedo Black Metallic'),
(105, 'White Suede'),
(105, 'Brilliant Silver Metallic'),
(106, 'Sangria Red Metallic'),
(106, 'Sport Blue Metallic'),
(106, 'Sterling Grey Metallic'),
(106, 'Smokestone Metallic'),
(106, 'Tuxedo Black Metallic'),
(106, 'White Suede'),
(106, 'Atlantis Green Metallic'),
(106, 'White Platinum Metallic Tri-Coat'),
(106, 'Brilliant Silver Metallic'),
(107, 'Sangria Red Metallic'),
(107, 'Sport Blue Metallic'),
(107, 'Sterling Grey Metallic'),
(107, 'Smokestone Metallic'),
(107, 'Tuxedo Black Metallic'),
(107, 'White Suede'),
(107, 'Atlantis Green Metallic'),
(107, 'White Platinum Metallic Tri-Coat'),
(107, 'Brilliant Silver Metallic'),
(108, 'Satin White Pearl'),
(108, 'Steel Silver Metallic'),
(108, 'Harvest Gold Metallic'),
(108, 'Cypress Green Pearl'),
(108, 'Sky Blue Metallic'),
(108, 'Azurite Blue Pearl'),
(108, 'Graphite Gray Metallic'),
(108, 'Crystal Black Sillica'),
(109, 'Satin White Pearl'),
(109, 'Steel Silver Metallic'),
(109, 'Harvest Gold Metallic'),
(109, 'Sky Blue Metallic'),
(109, 'Azurite Blue Pearl'),
(109, 'Cypress Green Pearl'),
(109, 'Graphite Gray Metallic'),
(109, 'Crystal Black Sillica'),
(110, 'Satin White Pearl'),
(110, 'Steel Silver Metallic'),
(110, 'Harvest Gold Metallic'),
(110, 'Sky Blue Metallic'),
(110, 'Azurite Blue Pearl'),
(110, 'Cypress Green Pearl'),
(110, 'Graphite Gray Metallic'),
(110, 'Crystal Black Sillica'),
(111, 'Satin White Pearl'),
(111, 'Steel Silver Metallic'),
(111, 'Harvest Gold Metallic'),
(111, 'Sky Blue Metallic'),
(111, 'Azurite Blue Pearl'),
(111, 'Cypress Green Pearl'),
(111, 'Graphite Gray Metallic'),
(111, 'Crystal Black Sillica'),
(112, 'Satin White Pearl'),
(112, 'Steel Silver Metallic'),
(112, 'Harvest Gold Metallic'),
(112, 'Sky Blue Metallic'),
(112, 'Azurite Blue Pearl'),
(112, 'Cypress Green Pearl'),
(112, 'Graphite Gray Metallic'),
(112, 'Crystal Black Sillica'),
(113, 'Satin White Pearl'),
(113, 'Steel Silver Metallic'),
(113, 'Harvest Gold Metallic'),
(113, 'Sky Blue Metallic'),
(113, 'Azurite Blue Pearl'),
(113, 'Cypress Green Pearl'),
(113, 'Graphite Gray Metallic'),
(113, 'Crystal Black Sillica'),
(114, 'Satin White Pearl'),
(114, 'Steel Silver Metallic'),
(114, 'Harvest Gold Metallic'),
(114, 'Sky Blue Metallic'),
(114, 'Azurite Blue Pearl'),
(114, 'Cypress Green Pearl'),
(114, 'Graphite Gray Metallic'),
(114, 'Crystal Black Sillica'),
(115, 'Satin White Pearl'),
(115, 'Steel Silver Metallic'),
(115, 'Harvest Gold Metallic'),
(115, 'Sky Blue Metallic'),
(115, 'Azurite Blue Pearl'),
(115, 'Cypress Green Pearl'),
(115, 'Graphite Gray Metallic'),
(115, 'Crystal Black Sillica'),
(116, 'Satin White Pearl'),
(116, 'Spark Silver Metallic'),
(116, 'Steel Silver Metallic'),
(116, 'Harvest Gold Metallic'),
(116, 'Sage Green Metallic'),
(116, 'Newport Blue Pearl'),
(116, 'Paprika Red Pearl'),
(116, 'Camelia Red Pearl'),
(116, 'Dark Gray Metallic'),
(116, 'Obsidian Black Pearl'),
(117, 'Satin White Pearl'),
(117, 'Spark Silver Metallic'),
(117, 'Steel Silver Metallic'),
(117, 'Harvest Gold Metallic'),
(117, 'Sage Green Metallic'),
(117, 'Newport Blue Pearl'),
(117, 'Paprika Red Pearl'),
(117, 'Camelia Red Pearl'),
(117, 'Dark Gray Metallic'),
(117, 'Obsidian Black Pearl'),
(118, 'Satin White Pearl'),
(118, 'Spark Silver Metallic'),
(118, 'Steel Silver Metallic'),
(118, 'Harvest Gold Metallic'),
(118, 'Sage Green Metallic'),
(118, 'Newport Blue Pearl'),
(118, 'Paprika Red Pearl'),
(118, 'Camelia Red Pearl'),
(118, 'Dark Gray Metallic'),
(118, 'Obsidian Black Pearl'),
(119, 'Satin White Pearl'),
(119, 'Spark Silver Metallic'),
(119, 'Steel Silver Metallic'),
(119, 'Harvest Gold Metallic'),
(119, 'Sage Green Metallic'),
(119, 'Newport Blue Pearl'),
(119, 'Paprika Red Pearl'),
(119, 'Camelia Red Pearl'),
(119, 'Dark Gray Metallic'),
(119, 'Obsidian Black Pearl'),
(120, 'Satin White Pearl'),
(120, 'Spark Silver Metallic'),
(120, 'Steel Silver Metallic'),
(120, 'Harvest Gold Metallic'),
(120, 'Sage Green Metallic'),
(120, 'Newport Blue Pearl'),
(120, 'Paprika Red Pearl'),
(120, 'Camelia Red Pearl'),
(120, 'Dark Gray Metallic'),
(120, 'Obsidian Black Pearl'),
(121, 'Satin White Pearl'),
(121, 'Spark Silver Metallic'),
(121, 'Steel Silver Metallic'),
(121, 'Harvest Gold Metallic'),
(121, 'Sage Green Metallic'),
(121, 'Newport Blue Pearl'),
(121, 'Paprika Red Pearl'),
(121, 'Camelia Red Pearl'),
(121, 'Dark Gray Metallic'),
(121, 'Obsidian Black Pearl'),
(122, 'Satin White Pearl'),
(122, 'Spark Silver Metallic'),
(122, 'Steel Silver Metallic'),
(122, 'Harvest Gold Metallic'),
(122, 'Sage Green Metallic'),
(122, 'Newport Blue Pearl'),
(122, 'Paprika Red Pearl'),
(122, 'Camelia Red Pearl'),
(122, 'Dark Gray Metallic'),
(122, 'Obsidian Black Pearl'),
(133, 'Sangria Red Metallic'),
(133, 'Sport Blue Metallic'),
(133, 'Tuxedo Black Metallic'),
(133, 'Atlantis Green Metallic'),
(133, 'Brilliant Silver Metallic'),
(134, 'Sterling Grey Metallic'),
(134, 'Light Ice Blue Metallic'),
(134, 'Tuxedo Black Metallic'),
(134, 'Atlantis Green Metallic'),
(134, 'White Platinum Metallic Tri-coat'),
(134, 'Brilliant Silver Metallic'),
(135, 'Cinnamon Metallic'),
(135, 'White Suede'),
(135, 'Ingot Silver Metallic'),
(135, 'Steel Blue Metallic'),
(135, 'Tuxedo Black Metallic'),
(136, 'Cinnamon Metallic'),
(136, 'Red Candy Metallic Tinted Clearcoat'),
(136, 'Gold Leaf Metallic'),
(136, 'White Platinum Metallic Tri-Coat'),
(136, 'White Suede'),
(136, 'Ingot Silver Metallic'),
(136, 'Steel Blue Metallic'),
(136, 'Tuxedo Black Metallic'),
(137, 'Cinnamon Metallic'),
(137, 'Red Candy Metallic Tinted Clearcoat'),
(137, 'Gold Leaf Metallic'),
(137, 'White Platinum Metallic Tri-Coat'),
(137, 'White Suede'),
(137, 'Ingot Silver Metallic'),
(137, 'Steel Blue Metallic'),
(137, 'Tuxedo Black Metallic'),
(138, 'Cinnamon Metallic'),
(138, 'Red Candy Metallic Tinted Clearcoat'),
(138, 'Gold Leaf Metallic'),
(138, 'White Platinum Metallic Tri-Coat'),
(138, 'White Suede'),
(138, 'Ingot Silver Metallic'),
(138, 'Steel Blue Metallic'),
(138, 'Tuxedo Black Metallic'),
(139, 'Sangria Red Metallic'),
(139, 'Blue Flame Metallic'),
(139, 'Dark Copper Metallic'),
(139, 'Black Pearl Slate Metallic'),
(139, 'Black'),
(139, 'Brilliant Silver Metallic'),
(139, 'White Suede'),
(140, 'Sangria Red Metallic'),
(140, 'Blue Flame Metallic'),
(140, 'Dark Copper Metallic'),
(140, 'Black Pearl Slate Metallic'),
(140, 'Black'),
(140, 'Brilliant Silver Metallic'),
(140, 'White Suede'),
(141, 'Blue Flame Metallic'),
(141, 'Black'),
(141, 'Brilliant Silver Metallic'),
(141, 'Torch Red'),
(27, 'Winter Frost'),
(27, 'Super Black'),
(27, 'Code Red'),
(27, 'Precision Gray'),
(27, 'Azura Blue'),
(27, 'Dark Slate'),
(27, 'Radiant Silver'),
(28, 'Winter Frost'),
(28, 'Super Black'),
(28, 'Code Red'),
(28, 'Precision Gray'),
(28, 'Azura Blue'),
(28, 'Dark Slate'),
(28, 'Radiant Silver'),
(29, 'Winter Frost'),
(29, 'Super Black'),
(29, 'Code Red'),
(29, 'Precision Gray'),
(29, 'Azura Blue'),
(29, 'Dark Slate'),
(29, 'Radiant Silver'),
(142, 'Brilliant Silver Metallic'),
(142, 'Sterling Grey Metallic'),
(142, 'Kona Blue Metallic'),
(142, 'Grabber Blue'),
(142, 'Torch Red'),
(142, 'Red Candy Metallic Tinted Clearcoat'),
(142, 'Performance White'),
(142, 'Sunset Gold Metallic'),
(142, 'Black'),
(25, 'Black Obsidian'),
(25, 'Gun Metallic'),
(25, 'Titanium'),
(25, 'Super Silver'),
(25, 'Ivory Pearl'),
(25, 'Solid Red'),
(26, 'Black Obsidian'),
(26, 'Gun Metallic'),
(26, 'Titanium'),
(26, 'Super Silver'),
(26, 'Ivory Pearl'),
(26, 'Solid Red'),
(143, 'Brilliant Silver Metallic'),
(143, 'Sterling Grey Metallic'),
(143, 'Kona Blue Metallic'),
(143, 'Grabber Blue'),
(143, 'Torch Red'),
(143, 'Red Candy Metallic Tinted Clearcoat'),
(143, 'Performance White'),
(143, 'Sunset Gold Metallic'),
(143, 'Black'),
(144, 'Brilliant Silver Metallic'),
(144, 'Sterling Grey Metallic'),
(144, 'Kona Blue Metallic'),
(144, 'Grabber Blue'),
(144, 'Torch Red'),
(144, 'Red Candy Metallic Tinted Clearcoat'),
(144, 'Performance White'),
(144, 'Sunset Gold Metallic'),
(144, 'Black'),
(145, 'Brilliant Silver Metallic'),
(145, 'Sterling Grey Metallic'),
(145, 'Kona Blue Metallic'),
(145, 'Grabber Blue'),
(145, 'Torch Red'),
(145, 'Red Candy Metallic Tinted Clearcoat'),
(145, 'Performance White'),
(145, 'Sunset Gold Metallic'),
(145, 'Black'),
(146, 'Brilliant Silver Metallic'),
(146, 'Sterling Grey Metallic'),
(146, 'Kona Blue Metallic'),
(146, 'Grabber Blue'),
(146, 'Torch Red'),
(146, 'Performance White'),
(146, 'Black'),
(147, 'Oxford White'),
(147, 'Pueble Gold Metallic'),
(147, 'School Bus Yellow'),
(147, 'Royal Red Metallic'),
(147, 'Dark Blue Pearl Metallic'),
(147, 'Ingot Silver Metallic'),
(147, 'Vermillion Red'),
(147, 'Black'),
(149, 'Oxford White'),
(149, 'Pueble Gold Metallic'),
(149, 'School Bus Yellow'),
(149, 'Royal Red Metallic'),
(149, 'Dark Blue Pearl Metallic'),
(149, 'Ingot Silver Metallic'),
(149, 'Vermillion Red'),
(149, 'Black'),
(148, 'Oxford White'),
(148, 'Pueble Gold Metallic'),
(148, 'Royal Red Metallic'),
(148, 'Dark Blue Pearl Metallic'),
(148, 'Black'),
(150, 'Oxford White'),
(150, 'Pueble Gold Metallic'),
(150, 'Royal Red Metallic'),
(150, 'Dark Blue Pearl Metallic'),
(150, 'Black');

-- --------------------------------------------------------

--
-- Table structure for table `Engine`
--

CREATE TABLE IF NOT EXISTS `Engine` (
  `EID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(75) DEFAULT NULL,
  `Torque` varchar(20) DEFAULT NULL,
  `HP` varchar(20) DEFAULT NULL,
  `Type` varchar(50) DEFAULT NULL,
  `Cylinders` int(11) DEFAULT NULL,
  `EngineDisp` double DEFAULT NULL,
  `HybridType` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`EID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=31 ;

--
-- Dumping data for table `Engine`
--

INSERT INTO `Engine` (`EID`, `Name`, `Torque`, `HP`, `Type`, `Cylinders`, `EngineDisp`, `HybridType`) VALUES
(1, '16 Valve DOHC i-VTEC', '162 @ 4400', '190 @ 7000', 'In-Line 4-Cylinder', 4, 2.35, NULL),
(2, '24 Valve DOHC i-VTEC', '251 @ 5000', '271 @ 6200', 'V-6', 6, 3.47, NULL),
(3, 'Double Overhead Cam [DOHC] 16-Valve', '162 @ 4000', '161 @ 6000', 'VVT-I 4 Cylinders', 4, 2.4, NULL),
(4, 'Double Overhead Cam [DOHC] 16-Valve', '162 @ 4000', '158 @ 6000', 'VVT-I 4 Cylinders', 4, 2.4, NULL),
(5, 'Double Overhead Cam [DOHC] 16-Valve', '125 @ 4400', '128 @ 6000', 'Dual VVT-I 4 Cylinders', 4, 1.8, NULL),
(6, 'Double Overhead Cam [DOHC] 16-Valve', '173 @ 4100', '180 @ 6000', 'Dual VVT-I 4 Cylinders', 4, 2.5, NULL),
(7, 'Double Overhead Cam [DOHC] 16-Valve', '89 @ 4400', '94 @ 6000', 'Dual VVT-I 4 Cylinders', 4, 1.4, NULL),
(8, 'SOHC Aluminum-Alloy 16-Valve', '170 @ 4400', '170 @ 6000', '4-Cylinder Horizonatally Opposed', 4, 2.5, NULL),
(9, 'DOHC Intercooled, Tubrocharged Aluminum-Alloy 16-Valve', '224 @ 2800', '226 @ 5200', '4-Cylinder Horizonatally Opposed', 4, 2.5, NULL),
(10, 'DOHC Intercooled, Tubrocharged Aluminum-Alloy 16-Valve', '224 @ 4000', '255 @ 6000', '4-Cylinder Horizonatally Opposed', 4, 2.5, NULL),
(11, 'SOHC Aluminum-Alloy 16-Valve', '170 @ 4000', '170 @ 5600', '4-Cylinder Horizonatally Opposed', 4, 2.5, NULL),
(12, 'DOHC Intercooled, Tubrocharged Aluminum-Alloy 16-Valve', '258 @ 5200', '265 @ 6000', '4-Cylinder Horizonatally Opposed', 4, 2.5, NULL),
(13, 'DOHC Aluminum-Alloy 24-Valve', '247 @ 4400', '256 @ 6600', '6-Cylinder Horizonatally Opposed', 6, 3.6, NULL),
(15, 'DOHC Intercooled, Tubrocharged Aluminum-Alloy 16-Valve', '226 @ 2800', '224 @ 5200', '4-Cylinder Horizonatally Opposed', 4, 2.5, NULL),
(16, 'DOHC Intercooled, Turbocharged Aluminum-Alloy 16-Valve', '290 @ 4000', '305 @ 6000', '4-Cylinder Horizontally Opposed', 4, 2.5, NULL),
(17, '2.0L DuratecÂ® I-4 Engine', '136 @ 4250 ', '140 @ 6000', NULL, 4, 2, NULL),
(18, '2.5L DOHC DuratecÂ® I-4 engine', '172 @ 4500 ', '175 @ 6000', NULL, 4, 2.5, NULL),
(19, '3.0L V6 FFV engine', '223 @ 4500', '240 @ 6550', NULL, 6, 3, NULL),
(20, '3.5L Duratec V6 Engine', '249 @ 4500', '263 @ 6250', NULL, 6, 3.5, 'N/A'),
(21, '2.5L IVCT I-4 Atkinson-cycle engine', 'N/A', '191', NULL, 4, 2.5, 'Hybrid'),
(22, '3.5L EcoBoost V6 Engine', '350 @ 3500', '365 @ 5500', NULL, 6, 3.5, 'N/A'),
(23, '4.0L SOHC V6 Engine', '254 @ 3700', '210 @ 5100', NULL, 6, 4, 'N/A'),
(24, '4.6L 3V V8 Engine', '315 @ 4000', '292 @ 5700', NULL, 8, 4.6, 'N/A'),
(25, 'QR25DE - DOHC 16-Valve', '180 @ 3900', '175 @ 5600', '4-Cylinder', 4, 2.5, NULL),
(26, 'VQ35DE - DOHC 24-Valve', '258 @ 4400', '270 @ 6000', '4-Cylinder', 4, 3.5, NULL),
(27, '5.4L DOHC V8 Engine', '510 @ 4500', '540 @ 6000', NULL, 8, 5.4, 'N/A'),
(28, 'VR38DETT Twin-Turbocharged 24-Valve', '420 @ 5200', '480 @ 6400', 'V6', 6, 3.8, NULL),
(29, '6.8L SOHC V10 Engine', '420 @ 3250', '305 @ 4250', NULL, 10, 6.8, 'N/A'),
(30, 'DOHC 16-Valve VVT-i', '103 @ 4200', '106 @ 6000', '4-Cylinder', 4, 1.5, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `Engine_Option`
--

CREATE TABLE IF NOT EXISTS `Engine_Option` (
  `VID` int(11) DEFAULT NULL,
  `EID` int(11) DEFAULT NULL,
  KEY `fk_EID` (`EID`),
  KEY `VID` (`VID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Engine_Option`
--

INSERT INTO `Engine_Option` (`VID`, `EID`) VALUES
(0, 3),
(1, 3),
(16, 6),
(17, 6),
(5, 5),
(6, 5),
(14, 5),
(15, 5),
(22, 5),
(23, 5),
(2, 4),
(3, 4),
(11, 4),
(12, 4),
(20, 4),
(21, 4),
(41, 7),
(30, 1),
(31, 1),
(51, 8),
(52, 8),
(53, 8),
(54, 8),
(55, 8),
(56, 8),
(58, 8),
(59, 8),
(60, 8),
(61, 8),
(62, 8),
(63, 8),
(64, 9),
(65, 10),
(66, 10),
(67, 10),
(68, 10),
(69, 16),
(83, 17),
(97, 17),
(97, 17),
(86, 11),
(87, 11),
(88, 11),
(89, 11),
(90, 11),
(91, 12),
(92, 12),
(93, 13),
(94, 13),
(95, 13),
(99, 17),
(101, 17),
(103, 17),
(104, 17),
(105, 18),
(106, 18),
(106, 19),
(107, 18),
(107, 19),
(108, 11),
(109, 11),
(110, 11),
(111, 11),
(112, 11),
(113, 13),
(114, 13),
(115, 13),
(116, 8),
(117, 8),
(118, 8),
(119, 8),
(120, 8),
(121, 15),
(122, 15),
(133, 20),
(134, 21),
(135, 20),
(136, 20),
(137, 20),
(138, 20),
(139, 23),
(140, 23),
(140, 24),
(141, 23),
(142, 23),
(143, 23),
(144, 24),
(145, 24),
(142, 23),
(143, 23),
(144, 24),
(145, 24),
(27, 25),
(28, 25),
(29, 26),
(146, 27),
(25, 28),
(26, 28),
(147, 24),
(147, 27),
(148, 24),
(148, 27),
(149, 27),
(149, 29),
(150, 27),
(150, 29),
(4, 30);

-- --------------------------------------------------------

--
-- Table structure for table `Likes`
--

CREATE TABLE IF NOT EXISTS `Likes` (
  `Username` varchar(50) DEFAULT NULL,
  `VID` int(11) DEFAULT NULL,
  KEY `Username` (`Username`),
  KEY `VID` (`VID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Likes`
--

INSERT INTO `Likes` (`Username`, `VID`) VALUES
('razorcat', 145),
('razorcat', 26);

-- --------------------------------------------------------

--
-- Table structure for table `Manufacturer`
--

CREATE TABLE IF NOT EXISTS `Manufacturer` (
  `MID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(30) NOT NULL,
  `Pic_Link` varchar(255) DEFAULT NULL,
  `Headquarters` varchar(255) DEFAULT NULL,
  `Website` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`MID`),
  KEY `MID` (`MID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `Manufacturer`
--

INSERT INTO `Manufacturer` (`MID`, `Name`, `Pic_Link`, `Headquarters`, `Website`) VALUES
(1, 'Honda', NULL, 'Minato, Tokyo, Japan', 'http://www.honda.com/'),
(2, 'Subaru', NULL, 'Ebisu, Tokyo, Japan', 'http://www.subaru.com/'),
(3, 'Scion', NULL, 'Torrance, California, US', 'http://www.scion.com/'),
(4, 'Toyota', NULL, 'Toyota, Aichi, Japan', 'http://www.toyota.com/'),
(5, 'Ford', NULL, 'Dearborn, Michigan, U.S', 'http://www.ford.com/'),
(6, 'Nissan', NULL, 'Nishi-ku, Yokohama, Japan', 'http://www.nissanusa.com/');

-- --------------------------------------------------------

--
-- Table structure for table `Model`
--

CREATE TABLE IF NOT EXISTS `Model` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) DEFAULT NULL,
  `Year` int(4) DEFAULT NULL,
  `Manufacturer` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `Manufacturer` (`Manufacturer`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=54 ;

--
-- Dumping data for table `Model`
--

INSERT INTO `Model` (`ID`, `Name`, `Year`, `Manufacturer`) VALUES
(1, 'TC', 2010, 3),
(2, 'xB', 2010, 3),
(3, 'xD', 2010, 3),
(4, 'TC', 2011, 3),
(5, 'xB', 2011, 3),
(6, 'xD', 2011, 3),
(7, 'TC', 2012, 3),
(8, 'xB', 2012, 3),
(9, 'xD', 2012, 3),
(10, 'Impreza', 2010, 2),
(11, 'Legacy', 2010, 2),
(12, 'Outback', 2010, 2),
(13, 'Forester', 2010, 2),
(14, 'Focus', 2010, 5),
(15, 'Fusion', 2010, 5),
(16, 'Taurus', 2010, 5),
(17, 'Mustang', 2010, 5),
(18, 'Edge', 2010, 5),
(19, 'Flex', 2010, 5),
(20, 'Explorer', 2010, 5),
(21, 'Escape', 2010, 5),
(22, 'Expedition', 2010, 5),
(23, 'Explorer Sport Trac', 2010, 5),
(24, 'TransitConnect', 2010, 5),
(25, 'F-150', 2010, 5),
(26, 'Ranger', 2010, 5),
(27, 'E-Series', 2010, 5),
(28, 'Accord', 2010, 1),
(29, 'AccordCrosstour', 2010, 1),
(30, 'Civic', 2010, 1),
(31, 'CRV', 2010, 1),
(32, 'Element', 2010, 1),
(33, 'Insight', 2010, 1),
(34, 'Odyssey', 2010, 1),
(35, 'Pilot', 2010, 1),
(36, 'Ridgeline', 2010, 1),
(37, 'Yaris', 2010, 4),
(38, 'Corolla', 2010, 4),
(39, 'Altima', 2010, 6),
(40, 'GT-R', 2010, 6),
(41, 'iQ', 2012, 3),
(48, 'Impreza', 2010, 2),
(49, 'Legacy', 2010, 2),
(50, 'Outback', 2010, 2),
(51, 'Forester', 2010, 2);

-- --------------------------------------------------------

--
-- Table structure for table `Owns`
--

CREATE TABLE IF NOT EXISTS `Owns` (
  `Username` varchar(50) DEFAULT NULL,
  `VID` int(11) DEFAULT NULL,
  KEY `Username` (`Username`),
  KEY `VID` (`VID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Owns`
--

INSERT INTO `Owns` (`Username`, `VID`) VALUES
('razorcat', 145),
('razorcat', 139);

-- --------------------------------------------------------

--
-- Table structure for table `Reviews`
--

CREATE TABLE IF NOT EXISTS `Reviews` (
  `Username` varchar(50) NOT NULL DEFAULT '',
  `VID` int(11) NOT NULL DEFAULT '0',
  `Rating` int(11) DEFAULT NULL,
  `Description` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`Username`,`VID`),
  KEY `VID` (`VID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Reviews`
--

INSERT INTO `Reviews` (`Username`, `VID`, `Rating`, `Description`) VALUES
('larry2', 22, 0, 'Squirel!'),
('larry2', 25, 6, 'hello'),
('larry2', 51, 0, 'hi''; drop table User;--!\r\n'),
('larry2', 58, 9, 'Really liked this car'),
('razorcat', 139, 0, '\r\n&lt;!DOCTYPE html&gt;\r\n&lt;html lang=&quot;en&quot; dir=&quot;ltr&quot; class=&quot;client-nojs&quot;&gt;\r\n&lt;head&gt;\r\n&lt;meta charset=&quot;UTF-8&quot; /&gt;\r\n&lt;title&gt;George Washington - Wikipedia, the free encyclopedia&lt;/title&gt;\r\n&lt;meta name=&quot;generator&quot; content=&quot;MediaWiki 1.26wmf5&quot; /&gt;\r\n&lt;link rel=&quot;alternate&quot; href=&quot;android-app://org.wikipedia/http/en.m.wikipedia.org/wiki/George_Washington&quot; /&gt;\r\n&lt;link rel=&quot;apple-touch-icon&quot; href=&quot;/static/apple-touch/wikipedia.png&quot; /&gt;\r\n&lt;link rel=&quot;shortcut icon&quot; href=&quot;/static/favicon/wikipedia.ico&quot; /&gt;\r\n&lt;link rel=&quot;search&quot; type=&quot;application/opensearchdescription+xml&quot; href=&quot;/w/opensearch_desc.php&quot; title=&quot;Wikipedia (en)&quot; /&gt;\r\n&lt;link rel=&quot;EditURI&quot; type=&quot;application/rsd+xml&quot; href=&quot;//en.wikipedia.org/w/api.php?action=rsd&quot; /&gt;\r\n&lt;link rel=&quot;alternate&quot; hreflang='),
('user', 53, 0, '&lt;script&gt;\r\nconsole.log(&quot;gotcha&quot;)\r\n&lt;/script&gt;'),
('valley428', 20, 3, 'this car was ok but I it was very very loud'),
('valley428', 31, 10, 'I really really like this car dood');

-- --------------------------------------------------------

--
-- Table structure for table `Transmission`
--

CREATE TABLE IF NOT EXISTS `Transmission` (
  `TID` int(11) NOT NULL AUTO_INCREMENT,
  `Type` varchar(10) DEFAULT NULL,
  `Gears` int(11) DEFAULT NULL,
  PRIMARY KEY (`TID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=107 ;

--
-- Dumping data for table `Transmission`
--

INSERT INTO `Transmission` (`TID`, `Type`, `Gears`) VALUES
(100, 'Manual', 5),
(101, 'Automatic', 4),
(102, 'CVT', -1),
(103, 'Manual', 6),
(104, 'Automatic', 5),
(106, 'Automatic', 6);

-- --------------------------------------------------------

--
-- Table structure for table `Transmission_Options`
--

CREATE TABLE IF NOT EXISTS `Transmission_Options` (
  `VID` int(11) DEFAULT NULL,
  `TID` int(11) DEFAULT NULL,
  KEY `fk_TID` (`TID`),
  KEY `fk_VID` (`VID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Transmission_Options`
--

INSERT INTO `Transmission_Options` (`VID`, `TID`) VALUES
(0, 100),
(1, 101),
(7, 100),
(8, 101),
(16, 100),
(17, 101),
(5, 100),
(6, 101),
(14, 100),
(15, 101),
(22, 100),
(23, 101),
(2, 100),
(3, 101),
(11, 100),
(12, 101),
(20, 100),
(21, 101),
(24, 102),
(30, 100),
(31, 104),
(32, 100),
(32, 104),
(46, 104),
(47, 100),
(48, 100),
(49, 104),
(50, 104),
(51, 100),
(53, 100),
(55, 100),
(58, 100),
(60, 100),
(62, 100),
(65, 100),
(66, 100),
(67, 100),
(68, 100),
(69, 100),
(52, 101),
(54, 101),
(56, 101),
(57, 101),
(59, 101),
(61, 101),
(63, 101),
(64, 101),
(70, 104),
(71, 102),
(72, 100),
(73, 100),
(74, 100),
(75, 100),
(76, 100),
(77, 104),
(78, 104),
(79, 104),
(80, 104),
(81, 103),
(82, 103),
(84, 102),
(85, 102),
(83, 100),
(83, 101),
(97, 101),
(97, 100),
(86, 103),
(87, 102),
(88, 103),
(89, 102),
(90, 102),
(91, 103),
(92, 103),
(93, 104),
(94, 104),
(95, 104),
(99, 101),
(99, 100),
(101, 101),
(101, 100),
(103, 101),
(103, 100),
(104, 100),
(104, 101),
(105, 106),
(105, 103),
(106, 103),
(106, 106),
(107, 106),
(108, 103),
(109, 102),
(110, 103),
(111, 102),
(112, 102),
(113, 104),
(114, 104),
(115, 104),
(116, 100),
(117, 101),
(118, 100),
(119, 101),
(120, 101),
(121, 101),
(122, 101),
(133, 106),
(134, 102),
(135, 106),
(136, 106),
(137, 106),
(138, 106),
(139, 104),
(140, 104),
(140, 106),
(141, 104),
(27, 103),
(29, 103),
(28, 102),
(142, 100),
(142, 104),
(143, 100),
(143, 104),
(144, 100),
(144, 104),
(145, 100),
(145, 104),
(146, 103),
(26, 103),
(25, 103),
(147, 101),
(148, 101),
(149, 101),
(149, 104),
(150, 101),
(150, 104),
(4, 100);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE IF NOT EXISTS `user` (
  `username` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` binary(20) NOT NULL,
  `favvid` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`username`),
  UNIQUE KEY `email` (`email`),
  KEY `favvid` (`favvid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`username`, `name`, `email`, `password`, `favvid`) VALUES
('aaron', 'Aaron', 'hippmanb@gmail.com', 'Ü~à­ÕB…í"Rí9[AZo%', 0),
('admin', 'Harold Finch', 'craneh@ift.com', '_4XC•ÅR"KÍÄåh.0ˆèXL', 0),
('larry', 'larry', 'larry@ift.com', '\ZÖ\ZqG\rì“¼ÑS´XP^Æ¥a', 30),
('larry12', 'Larry', 'larry@gmail.com', '°-šs@>±¨•<´J^hqM:[-5', 0),
('larry2', 'Lary', 'larry@rose-hulmane.edu', '¢vW•	üqÆ[¬ƒV[	YÞbù', 34),
('razorcat', 'Aaron', 'aaron@mvfa.com', 't\ZjL…§°”á²Æ\0ö/Ï¢\ZçØ', 139),
('razorcat272', 'razorcat', 'email@email.edu', 'dVó’ì;‡E½™\0ÛÓ_¼*}ÉH', 0),
('razr', 'Aaron', 'aaron@mvfarm.com2', '•ÒÛ‰,8Šùe»è›!r‚µ€Â', 0),
('RHpresident', 'Dr. Professor Mohan', 'mohan@myspace.net', '¹Ne½]Fm#³\Zoö0çF.Q', 0),
('superhero', 'DR.PROFESSOR SRIRAM SUPERMAN', 'sram@123.com', 'ð÷íå$Ûeþ6t‚Ç>öä¾7', 151),
('user', 'name', 'email', 'Ç;¢˜,U·êÐä	Š’÷"½³£³Ø', 53),
('valley428', 'Aaron', 'aaron@mvfarm.com', 'Xý —ä{ttøÇÃEˆ3®CËå', 0);

-- --------------------------------------------------------

--
-- Table structure for table `Vehicle`
--

CREATE TABLE IF NOT EXISTS `Vehicle` (
  `VID` int(11) NOT NULL AUTO_INCREMENT,
  `MID` int(11) DEFAULT NULL,
  `Seats` int(11) DEFAULT NULL,
  `Fuel_Capacity` int(11) DEFAULT NULL,
  `Trim` varchar(25) DEFAULT NULL,
  `MPG` varchar(12) DEFAULT NULL,
  `Door_Count` int(11) DEFAULT NULL,
  `Pic_Link` varchar(256) DEFAULT NULL,
  `Drivetrain` varchar(8) DEFAULT NULL,
  `Fuel` varchar(25) DEFAULT NULL,
  `Body_Type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`VID`),
  KEY `fk_MID` (`MID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=153 ;

--
-- Dumping data for table `Vehicle`
--

INSERT INTO `Vehicle` (`VID`, `MID`, `Seats`, `Fuel_Capacity`, `Trim`, `MPG`, `Door_Count`, `Pic_Link`, `Drivetrain`, `Fuel`, `Body_Type`) VALUES
(0, 1, 5, 15, 'Base', '20/27/24', 2, NULL, 'FWD', 'Unleaded Regular', 'Coupe'),
(1, 1, 2, 15, 'Base', '21/29/25', 2, NULL, 'FWD', 'Unleaded Regular', 'Coupe'),
(2, 2, 5, 14, 'Base', '22/28/25', 4, NULL, 'FWD', 'Unleaded Regular', 'Compact Hatchback'),
(3, 2, 5, 14, 'Base', '22/28/25', 4, NULL, 'FWD', 'Unleaded Regular', 'Compact Hatchback'),
(4, 37, 5, 11, 'Base', '29/36/32', 3, NULL, 'Fwd', 'Unleaded Regular', 'Liftback'),
(5, 3, 5, 11, 'Base', '27/33/30', 4, NULL, 'FWD', 'Unleaded Regular', 'Subcompact Hatchback'),
(6, 3, 5, 11, 'Base', '27/33/30', 4, NULL, 'FWD', 'Unleaded Regular', 'Subcompact Hatchback'),
(7, 4, 5, 15, 'Base', '23/31/27', 2, NULL, 'FWD', 'Unleaded Regular', 'Coupe'),
(8, 4, 5, 15, 'Base', '23/31/27', 2, NULL, 'FWD', 'Unleaded Regular', 'Coupe'),
(9, 37, 5, 11, 'Base', '29/36/32', 4, NULL, 'fwd', 'Unleaded Regular', 'Sedan'),
(10, 37, 5, 11, 'Base', '29/35/32', 3, NULL, 'fwd', 'Unleaded Regular', 'Liftback'),
(11, 5, 5, 14, 'Base', '22/28/25', 4, NULL, 'FWD', 'Unleaded Regular', 'Compact Hatchback'),
(12, 5, 5, 14, 'Base', '22/28/25', 4, NULL, 'FWD', 'Unleaded Regular', 'Compact Hatchback'),
(13, 37, 5, 11, 'Base', '29/35/32', 5, NULL, 'fwd', 'Unleaded Regular', 'Liftback'),
(14, 6, 5, 11, 'Base', '27/33/30', 4, NULL, 'FWD', 'Unleaded Regular', 'Subcompact Hatchback'),
(15, 6, 5, 11, 'Base', '27/33/30', 4, NULL, 'FWD', 'Unleaded Regular', 'Subcompact Hatchback'),
(16, 7, 5, 15, 'Base', '23/31/27', 2, NULL, 'FWD', 'Unleaded Regular', 'Coupe'),
(17, 7, 5, 15, 'Base', '23/31/27', 2, NULL, 'FWD', 'Unleaded Regular', 'Coupe'),
(18, 37, 4, 11, 'Base', '29/35/32', 4, NULL, 'fwd', 'Unleaded Regular', 'Sedan'),
(19, 38, 4, 15, 'Base', '26/35/31', 4, NULL, 'fwd', 'Unleaded Regular', 'Sedan'),
(20, 8, 5, 14, 'Base', '22/28/25', 4, NULL, 'FWD', 'Unleaded Regular', 'Compact Hatchback'),
(21, 8, 5, 14, 'Base', '22/28/25', 4, NULL, 'FWD', 'Unleaded Regular', 'Compact Hatchback'),
(22, 9, 5, 11, 'Base', '27/33/30', 4, NULL, 'FWD', 'Unleaded Regular', 'Subcompact Hatchback'),
(23, 9, 5, 11, 'Base', '27/33/30', 4, NULL, 'FWD', 'Unleaded Regular', 'Subcompact Hatchback'),
(24, 41, 2, 11, 'Base', '36/37/37', 2, NULL, 'FWD', 'Unleaded Regular', 'Hatchback'),
(25, 40, 4, 20, 'Base', '16/21/19', 2, NULL, 'AWD', 'Unleaded Regular', 'Coupe'),
(26, 40, 4, 20, 'Prem. Ed', '16/21/19', 2, NULL, 'AWD', 'Unleaded Regular', 'Coupe'),
(27, 39, 5, 20, '2.5S', '23/32/287', 2, NULL, 'FWD', 'Unleaded Regular', 'Coupe'),
(28, 39, 5, 20, '2.5S', '23/31/27', 2, NULL, 'FWD', 'Unleaded Regular', 'Coupe'),
(29, 39, 5, 20, '3.5SE', '19/27/13', 2, NULL, 'FWD', 'Unleaded Regular', 'Coupe'),
(30, 28, 5, 19, 'LX-S', '21/31/25', 2, NULL, 'FWD', 'Unleaded Regular', 'Coupe'),
(31, 28, 5, 19, 'LX-S', '21/31/25', 2, NULL, 'FWD', 'Unleaded Regular', 'Coupe'),
(32, 28, 5, 19, 'EX', '21/31/25', 2, NULL, 'FWD', 'Unleaded Regular', 'Coupe'),
(33, 28, 5, 19, 'EX-L', '21/31/25', 2, NULL, 'FWD', 'Unleaded Regular', 'Coupe'),
(34, 28, 5, 19, 'EX-L V6', '21/31/25', 2, NULL, 'FWD', 'Unleaded Regular', 'Coupe'),
(35, 28, 5, 19, 'LX', '21/31/25', 4, NULL, 'FWD', 'Unleaded Regular', 'Sedan'),
(36, 28, 5, 19, 'LX-P', '21/31/25', 4, NULL, 'FWD', 'Unleaded Regular', 'Sedan'),
(37, 28, 5, 19, 'LX', '21/31/25', 4, NULL, 'FWD', 'Unleaded Regular', 'Sedan'),
(38, 28, 5, 19, 'LX-P', '22/31/25', 4, NULL, 'FWD', 'Unleaded Regular', 'Sedan'),
(39, 28, 5, 19, 'EX', '21/31/25', 4, NULL, 'FWD', 'Unleaded Regular', 'Sedan'),
(40, 28, 5, 19, 'EX-L', '22/31/25', 4, NULL, 'FWD', 'Unleaded Regular', 'Sedan'),
(41, 28, 5, 19, 'EX V-6', '19/29/23', 4, NULL, 'FWD', 'Unleaded Regular', 'Sedan'),
(42, 34, 7, 21, 'LX', '21/31/25', 4, NULL, 'FWD', 'Unleaded Regular', 'Minivan'),
(43, 34, 8, 21, 'EX', '16/23/18', 4, NULL, 'FWD', 'Unleaded Regular', 'Minivan'),
(44, 34, 8, 21, 'EX-L', '17/25/20', 4, NULL, 'FWD', 'Unleaded Regular', 'Minivan'),
(45, 34, 8, 21, 'LX', '17/25/20', 4, NULL, 'FWD', 'Unleaded Regular', 'Touring'),
(46, 30, 5, 13, 'DX', '26/34/29', 2, NULL, 'FWD', 'Unleaded Regular', 'Coupe'),
(47, 30, 5, 13, 'LX', '26/34/29', 2, NULL, 'FWD', 'Unleaded Regular', 'Coupe'),
(48, 30, 5, 13, 'DX', '26/34/29', 2, NULL, 'FWD', 'Unleaded Regular', 'Coupe'),
(49, 30, 5, 13, 'LX', '26/34/29', 2, NULL, 'FWD', 'Unleaded Regular', 'Coupe'),
(50, 30, 5, 13, 'GX', '24/36/28', 4, NULL, 'FWD', 'Unleaded Regular', 'Sedan'),
(51, 48, 5, 17, '2.5i', '20/27/24', 4, NULL, 'AWD', 'Unleaded Regular', 'Hatchback'),
(52, 48, 5, 17, '2.5i', '20/26/23', 4, NULL, 'AWD', 'Unleaded Regular', 'Hatchback'),
(53, 48, 5, 17, '2.5i Premium', '20/27/24', 4, NULL, 'AWD', 'Unleaded Regular', 'Hatchback'),
(54, 48, 5, 17, '2.5i Premium', '20/26/23', 4, NULL, 'AWD', 'Unleaded Regular', 'Hatchback'),
(55, 48, 5, 17, 'Outback Sport', '20/27/24', 4, NULL, 'AWD', 'Unleaded Regular', 'Hatchback'),
(56, 48, 5, 17, 'Outback Sport', '20/26/23', 4, NULL, 'AWD', 'Unleaded Regular', 'Hatchback'),
(57, 48, 5, 17, '2.5GT', '19/24/22', 4, NULL, 'AWD', 'Unleaded Premium', 'Hatchback'),
(58, 48, 5, 17, '2.5i', '20/27/24', 4, NULL, 'AWD', 'Unleaded Regular', 'Sedan'),
(59, 48, 5, 17, '2.5i', '20/26/23', 4, NULL, 'AWD', 'Unleaded Regular', 'Sedan'),
(60, 48, 5, 17, '2.5i Premium', '20/27/24', 4, NULL, 'AWD', 'Unleaded Regular', 'Sedan'),
(61, 48, 5, 17, '2.5i Premium', '20/26/23', 4, NULL, 'AWD', 'Unleaded Regular', 'Sedan'),
(62, 48, 5, 17, 'Outback Sport', '20/27/24', 4, NULL, 'AWD', 'Unleaded Regular', 'Sedan'),
(63, 48, 5, 17, 'Outback Sport', '20/26/23', 4, NULL, 'AWD', 'Unleaded Regular', 'Sedan'),
(64, 48, 5, 17, '2.5GT', '19/24/22', 4, NULL, 'AWD', 'Unleaded Premium', 'Sedan'),
(65, 48, 5, 17, 'WRX', '18/25/22', 4, NULL, 'AWD', 'Unleaded Premium', 'Sedan'),
(66, 48, 5, 17, 'WRX', '18/25/22', 4, NULL, 'AWD', 'Unleaded Premium', 'Hatchback'),
(67, 48, 5, 17, 'WRX Premium', '18/25/22', 4, NULL, 'AWD', 'Unleaded Premium', 'Sedan'),
(68, 48, 5, 17, 'WRX Premium', '18/25/22', 4, NULL, 'AWD', 'Unleaded Premium', 'Hatchback'),
(69, 48, 5, 17, 'WRX STI', '17/23/20', 4, NULL, 'AWD', 'Unleaded Premium', 'Hatchback'),
(70, 30, 5, 12, 'Hybrid', '40/45/42', 4, NULL, 'FWD', 'Unleaded Regular', 'Sedan'),
(71, 30, 5, 13, 'DX', '26/34/29', 4, NULL, 'FWD', 'Unleaded Regular', 'Sedan'),
(72, 30, 5, 13, 'DX-VP', '26/34/29', 4, NULL, 'FWD', 'Unleaded Regular', 'Sedan'),
(73, 30, 5, 13, 'LX', '26/34/29', 4, NULL, 'FWD', 'Unleaded Regular', 'Sedan'),
(74, 30, 5, 13, 'LX-S', '26/34/29', 4, NULL, 'FWD', 'Unleaded Regular', 'Sedan'),
(75, 30, 5, 13, 'EX', '26/34/29', 4, NULL, 'FWD', 'Unleaded Regular', 'Sedan'),
(76, 30, 5, 13, 'LX-S', '26/34/29', 4, NULL, 'FWD', 'Unleaded Regular', 'Sedan'),
(77, 30, 5, 13, 'LX', '26/34/29', 4, NULL, 'FWD', 'Unleaded Regular', 'Sedan'),
(78, 30, 5, 13, 'LX-S', '26/34/29', 4, NULL, 'FWD', 'Unleaded Regular', 'Sedan'),
(79, 30, 5, 13, 'EX', '26/34/29', 4, NULL, 'FWD', 'Unleaded Regular', 'Sedan'),
(80, 30, 5, 13, 'EX-L', '26/34/29', 4, NULL, 'FWD', 'Unleaded Regular', 'Sedan'),
(81, 30, 5, 13, 'Si', '21/29/34', 2, NULL, 'FWD', 'Unleaded Regular', 'Coupe'),
(82, 30, 5, 13, 'Si', '21/29/34', 4, NULL, 'FWD', 'Unleaded Regular', 'Sedan'),
(83, 14, 5, 14, 'S', '24/34/29', 4, NULL, 'FWD', 'Unleaded Regular', 'Sedan'),
(84, 33, 5, 11, 'LX', '40/43/41', 4, NULL, 'FWD', 'Unleaded Regular', 'Hatchback Hybrid'),
(85, 33, 5, 11, 'EX', '40/43/41', 4, NULL, 'FWD', 'Unleaded Regular', 'Hatchback Hybrid'),
(86, 49, 5, 19, '2.5i', '19/27/23', 4, NULL, 'AWD', 'Unleaded Regular', 'Sedan'),
(87, 49, 5, 19, '2.5i', '23/31/27', 4, NULL, 'AWD', 'Unleaded Regular', 'Sedan'),
(88, 49, 5, 19, '2.5i Premium', '19/27/23', 4, NULL, 'AWD', 'Unleaded Regular', 'Sedan'),
(89, 49, 5, 19, '2.5i Premium', '23/31/27', 4, NULL, 'AWD', 'Unleaded Regular', 'Sedan'),
(90, 49, 5, 19, '2.5i Limited', '23/31/27', 4, NULL, 'AWD', 'Unleaded Regular', 'Sedan'),
(91, 49, 5, 19, '2.5GT Premium', '18/25/22', 4, NULL, 'AWD', 'Unleaded Premium', 'Sedan'),
(92, 49, 5, 19, '2,5GT Limited', '18/25/22', 4, NULL, 'AWD', 'Unleaded Premium', 'Sedan'),
(93, 49, 5, 19, '3.6R', '18/25/22', 4, NULL, 'AWD', 'Unleaded Regular', 'Sedan'),
(94, 49, 5, 19, '3.6R Premium', '18/25/22', 4, NULL, 'AWD', 'Unleaded Regular', 'Sedan'),
(95, 49, 5, 19, '3.6R Limited', '18/25/22', 4, NULL, 'AWD', 'Unleaded Regular', 'Sedan'),
(96, 34, 7, 21, 'LX', '16/23/18', 4, NULL, 'FWD', 'Unleaded Regular', 'Minivan'),
(97, 14, 5, 14, 'SE', '24/34/29', 4, NULL, 'FWD', 'Unleaded Regular', 'Sedan'),
(98, 34, 8, 21, 'EX', '16/23/18', 4, NULL, 'FWD', 'Unleaded Regular', 'Minivan'),
(99, 14, 5, 14, 'SEL', '24/34/29', 4, NULL, 'FWD', 'Unleaded Regular', 'Sedan'),
(100, 34, 7, 21, 'EX-L', '17/25/20', 4, NULL, 'FWD', 'Unleaded Regular', 'Minivan'),
(101, 14, 5, 14, 'SES', '24/34/29', 4, NULL, 'FWD', 'Unleaded Regular', 'Sedan'),
(102, 34, 8, 21, 'Touring', '17/25/20', 4, NULL, 'FWD', 'Unleaded Regular', 'Minivan'),
(103, 14, 5, 14, 'SE', '24/34/29', 2, NULL, 'FWD', 'Unleaded Regular', 'Coupe'),
(104, 14, 5, 14, 'SES', '24/34/29', 2, NULL, 'FWD', 'Unleaded Regular', 'Coupe'),
(105, 15, 5, 18, 'S', '22/31/26', 4, NULL, 'FWD', 'Unleaded Regular', 'Sedan'),
(106, 15, 5, 18, 'SE', '22/29/25', 4, NULL, 'FWD', 'Unleaded Regular', 'Sedan'),
(107, 15, 5, 18, 'SEL', '22/31/26', 4, NULL, 'FWD', 'Unleaded Regular', 'Sedan'),
(108, 50, 5, 19, '2.5i', '19/27/23', 4, NULL, 'AWD', 'Unleaded Regular', 'Station Wagon'),
(109, 50, 5, 19, '2.5i', '22/29/26', 4, NULL, 'AWD', 'Unleaded Regular', 'Station Wagon'),
(110, 50, 5, 19, '2.5i Premium', '19/27/23', 4, NULL, 'AWD', 'Unleaded Regular', 'Station Wagon'),
(111, 50, 5, 19, '2.5i Premium', '22/29/26', 4, NULL, 'AWD', 'Unleaded Regular', 'Station Wagon'),
(112, 50, 5, 19, '2.5i Limited', '22/29/26', 4, NULL, 'AWD', 'Unleaded Regular', 'Station Wagon'),
(113, 50, 5, 19, '3.6R', '18/25/22', 4, NULL, 'AWD', 'Unleaded Regular', 'Station Wagon'),
(114, 50, 5, 19, '3.6R Premium', '18/25/22', 4, NULL, 'AWD', 'Unleaded Regular', 'Station Wagon'),
(115, 50, 5, 19, '3.6R Limited', '18/25/22', 4, NULL, 'AWD', 'Unleaded Regular', 'Station Wagon'),
(116, 51, 5, 17, '2.5X', '20/26/23', 4, NULL, 'AWD', 'Unleaded Regular', 'Compact Crossover SUV'),
(117, 51, 5, 17, '2.5X', '20/26/23', 4, NULL, 'AWD', 'Unleaded Regular', 'Compact Crossover SUV'),
(118, 51, 5, 17, '2.5X Premium', '20/26/23', 4, NULL, 'AWD', 'Unleaded Regular', 'Compact Crossover SUV'),
(119, 51, 5, 17, '2.5X Premium', '20/26/23', 4, NULL, 'AWD', 'Unleaded Regular', 'Compact Crossover SUV'),
(120, 51, 5, 17, '2.5X Limited', '19/24/22', 4, NULL, 'AWD', 'Unleaded Regular', 'Compact Crossover SUV'),
(121, 51, 5, 17, '2.5XT Premium', '19/24/22', 4, NULL, 'AWD', 'Unleaded Premium', 'Compact Crossover SUV'),
(122, 51, 5, 17, '2.5XT Limited', '19/24/22', 4, NULL, 'AWD', 'Unleaded Premium', 'Compact Crossover SUV'),
(123, 31, 5, 15, 'LX', '21/28/24', 4, NULL, 'FWD', 'Unleaded Regular', 'Compact Crossover SUV'),
(124, 31, 5, 15, 'EX', '21/28/24', 4, NULL, 'FWD', 'Unleaded Regular', 'Compact Crossover SUV'),
(125, 31, 5, 15, 'EX-L', '21/28/24', 4, NULL, 'FWD', 'Unleaded regular', 'Compact Crossover SUV'),
(126, 31, 5, 15, 'LX', '21/27/23', 4, NULL, 'FWD', 'Unleaded regular', 'Compact Crossover SUV'),
(127, 31, 5, 15, 'EX', '21/27/23', 4, NULL, 'FWD', 'Unleaded regular', 'Compact Crossover SUV'),
(128, 31, 5, 15, 'EX-L', '21/27/23', 4, NULL, 'FWD', 'Unleaded regular', 'Compact Crossover SUV'),
(129, 31, 4, 15, 'LX', '20/25/22', 4, NULL, 'FWD', 'Unleaded regular', 'Crossover Compact SUV'),
(130, 32, 4, 16, 'EX', '20/25/22', 4, NULL, 'FWD', 'Unleaded regular', 'Crossover Compact SUV'),
(131, 32, 4, 16, 'LX', '19/24/21', 4, NULL, 'FWD', 'Unleaded Regular', 'Crossover Compact SUV'),
(132, 32, 4, 16, 'SC', '20/25/22', 4, NULL, 'FWD', 'Unleaded regular', 'Crossover Compact SUV'),
(133, 15, 5, 17, 'Sport', '17/24/20', 4, NULL, 'AWD', 'Unleaded Regular', 'Sedan'),
(134, 15, 5, 18, 'Hybrid', '41/36/38', 4, NULL, 'FWD', 'Unleaded Regular', 'Sedan'),
(135, 16, 5, 20, 'SE', '18/28/23', 5, NULL, 'FWD', 'Unleaded Regular', 'Sedan'),
(136, 16, 5, 20, 'SEL', '18/27/22', 4, NULL, 'FWD', 'Unleaded Regular', 'Sedan'),
(137, 16, 5, 19, 'Limited', '17/25/21', 4, NULL, 'AWD', 'Unleaded Regular', 'Sedan'),
(138, 16, 5, 20, 'SHO', '17/25/21', 4, NULL, 'FWD', 'Unleaded Regular', 'Sedan'),
(139, 23, 5, 23, 'XLT', '13/19/16', 4, NULL, 'AWD', 'Unleaded Regular', 'Pickup'),
(140, 23, 5, 23, 'Limited', '13/19/16', 4, NULL, 'AWD', 'Unleaded Regular', 'Pickup'),
(141, 23, 4, 23, 'Adrenalin', '14/20/17', 4, NULL, 'FWD', 'Unleaded Regular', 'Pickup'),
(142, 17, 4, 16, 'V6', '18/26/22', 2, NULL, 'RWD', 'Unleaded Regular', 'Coupe'),
(143, 17, 4, 16, 'V6 Premium', '18/26/22', 2, NULL, 'RWD', 'Unleaded Regular', 'Coupe'),
(144, 17, 4, 16, 'GT', '16/24/20', 2, NULL, 'RWD', 'Unleaded Regular', 'Coupe'),
(145, 17, 4, 16, 'GT Premium', '17/23/20', 2, NULL, 'RWD', 'Unleaded Regular', 'Coupe'),
(146, 17, 4, 16, 'Shelby GT500', '14/22/18', 2, NULL, 'RWD', 'Unleaded Regular', 'Coupe'),
(147, 27, 8, 35, 'XL', '13/17/15', 3, NULL, 'RWD', 'Unleaded Regular', 'Full-size van'),
(148, 27, 8, 35, 'XLT', '13/17/15', 3, NULL, 'RWD', 'Unleaded Regular', 'Full-size van'),
(149, 27, 12, 35, 'Super Duty XL', '12/15/13', 3, NULL, 'RWD', 'Unleaded Regular', 'Full-size van'),
(150, 27, 12, 35, 'Super Duty XLT', '12/15/13', 3, NULL, 'RWD', 'Unleaded Regular', 'Full-size van'),
(151, 36, 5, 21, 'RT', '15/20/17', 4, NULL, 'FWD', 'Unleaded Regular', 'Full-size Pickup Truck'),
(152, 36, 5, 21, 'RT', '15/20/17', 4, NULL, 'FWD', 'Unleaded Regular', 'Full-size Pickup Truck');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `Color_Option`
--
ALTER TABLE `Color_Option`
  ADD CONSTRAINT `Color_Option_ibfk_2` FOREIGN KEY (`VID`) REFERENCES `Vehicle` (`VID`),
  ADD CONSTRAINT `Color_Option_ibfk_1` FOREIGN KEY (`Color`) REFERENCES `Color` (`Color`);

--
-- Constraints for table `Engine_Option`
--
ALTER TABLE `Engine_Option`
  ADD CONSTRAINT `Engine_Option_ibfk_1` FOREIGN KEY (`VID`) REFERENCES `Vehicle` (`VID`),
  ADD CONSTRAINT `fk_EID` FOREIGN KEY (`EID`) REFERENCES `Engine` (`EID`);

--
-- Constraints for table `Likes`
--
ALTER TABLE `Likes`
  ADD CONSTRAINT `Likes_ibfk_2` FOREIGN KEY (`VID`) REFERENCES `Vehicle` (`VID`),
  ADD CONSTRAINT `Likes_ibfk_1` FOREIGN KEY (`Username`) REFERENCES `user` (`username`);

--
-- Constraints for table `Model`
--
ALTER TABLE `Model`
  ADD CONSTRAINT `Model_ibfk_1` FOREIGN KEY (`Manufacturer`) REFERENCES `Manufacturer` (`MID`) ON DELETE NO ACTION;

--
-- Constraints for table `Owns`
--
ALTER TABLE `Owns`
  ADD CONSTRAINT `Owns_ibfk_1` FOREIGN KEY (`Username`) REFERENCES `user` (`username`),
  ADD CONSTRAINT `Owns_ibfk_2` FOREIGN KEY (`VID`) REFERENCES `Vehicle` (`VID`);

--
-- Constraints for table `Reviews`
--
ALTER TABLE `Reviews`
  ADD CONSTRAINT `fk_Username` FOREIGN KEY (`Username`) REFERENCES `user` (`username`),
  ADD CONSTRAINT `Reviews_ibfk_1` FOREIGN KEY (`VID`) REFERENCES `Vehicle` (`VID`);

--
-- Constraints for table `Transmission_Options`
--
ALTER TABLE `Transmission_Options`
  ADD CONSTRAINT `fk_TID` FOREIGN KEY (`TID`) REFERENCES `Transmission` (`TID`),
  ADD CONSTRAINT `fk_VID` FOREIGN KEY (`VID`) REFERENCES `Vehicle` (`VID`);

--
-- Constraints for table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `user_ibfk_1` FOREIGN KEY (`favvid`) REFERENCES `Vehicle` (`VID`);

--
-- Constraints for table `Vehicle`
--
ALTER TABLE `Vehicle`
  ADD CONSTRAINT `fk_MID` FOREIGN KEY (`MID`) REFERENCES `Model` (`ID`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
