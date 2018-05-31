-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Dec 05, 2017 at 06:31 PM
-- Server version: 5.5.57-0ubuntu0.14.04.1
-- PHP Version: 5.5.9-1ubuntu4.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `CLUB_MANAGEMENT`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`ashwini19`@`%` PROCEDURE `EmployeesWorkingOn`( IN DAY VARCHAR( 25 ) )
BEGIN SELECT CONCAT( e.first_name, ' ', e.last_name ) AS Name, GROUP_CONCAT(ep.phone_no ) AS 'PhoneNo(s)'
FROM Employee e
INNER JOIN EmployeePhone ep ON e.id = ep.id
INNER JOIN EmployeeActivity ea ON ep.id = ea.employee_id
INNER JOIN ActivitySchedule actS ON ea.activity_instance_id = actS.id
INNER JOIN DayOfWeek dw ON actS.day_of_week = dw.id
WHERE dw.day_of_week = 
DAY 
GROUP BY (
e.id
);
END$$

CREATE DEFINER=`ashwini19`@`%` PROCEDURE `MemberDetailsForActivity`(IN `act_name` VARCHAR(25))
    SQL SECURITY INVOKER
BEGIN SELECT DISTINCT CONCAT_WS( ' ', m.first_name, m.last_name ) AS name,GROUP_CONCAT( DISTINCT mp.phone_no ) AS phone_no
FROM Member m
INNER JOIN MemberActivity ma ON ma.member_id = m.id
INNER JOIN ActivitySchedule a ON a.id = ma.activity_instance_id
INNER JOIN Activity act ON act.id = a.activity_id
INNER JOIN MemberPhone mp ON m.id = mp.id
WHERE act.activity_name = act_name
GROUP BY name;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `Activity`
--

CREATE TABLE IF NOT EXISTS `Activity` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `activity_name` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `activity_name` (`activity_name`),
  KEY `idx_id` (`id`),
  KEY `idx_act_name` (`activity_name`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `Activity`
--

INSERT INTO `Activity` (`id`, `activity_name`) VALUES
(1, 'Badminton'),
(5, 'Basketball'),
(3, 'Maths_Magic'),
(4, 'Swimming'),
(2, 'Yoga'),
(6, 'Zumba');

-- --------------------------------------------------------

--
-- Table structure for table `ActivityCategory`
--

CREATE TABLE IF NOT EXISTS `ActivityCategory` (
  `activity_id` int(10) DEFAULT NULL,
  `category_id` int(10) DEFAULT NULL,
  KEY `activity_id` (`activity_id`),
  KEY `category_id` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ActivityCategory`
--

INSERT INTO `ActivityCategory` (`activity_id`, `category_id`) VALUES
(1, 1),
(2, 1),
(2, 2),
(3, 3),
(4, 1),
(5, 1),
(6, 4),
(6, 5);

-- --------------------------------------------------------

--
-- Table structure for table `ActivityInventory`
--

CREATE TABLE IF NOT EXISTS `ActivityInventory` (
  `activity_instance_id` int(10) NOT NULL DEFAULT '0',
  `item_id` int(11) NOT NULL DEFAULT '0',
  `quantity` int(10) DEFAULT NULL,
  PRIMARY KEY (`activity_instance_id`,`item_id`),
  KEY `item_id` (`item_id`),
  KEY `idx_activity_inventory_actvity_instance_id` (`activity_instance_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ActivityInventory`
--

INSERT INTO `ActivityInventory` (`activity_instance_id`, `item_id`, `quantity`) VALUES
(1, 10, 20),
(2, 10, 20),
(3, 10, 20),
(4, 10, 20),
(5, 11, 12),
(6, 11, 12),
(7, 1, 15),
(8, 1, 25),
(9, 2, 12),
(10, 3, 50),
(10, 6, 100),
(10, 7, 1),
(10, 8, 1),
(10, 9, 100),
(11, 12, 4);

-- --------------------------------------------------------

--
-- Table structure for table `ActivitySchedule`
--

CREATE TABLE IF NOT EXISTS `ActivitySchedule` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `day_of_week` int(11) DEFAULT NULL,
  `start_at` time DEFAULT NULL,
  `end_at` time DEFAULT NULL,
  `activity_id` int(10) DEFAULT NULL,
  `venue_id` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `activity_id` (`activity_id`),
  KEY `venue_id` (`venue_id`),
  KEY `day_of_week` (`day_of_week`),
  KEY `idx_act_inst_id` (`id`),
  KEY `idx_day_num` (`day_of_week`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=12 ;

--
-- Dumping data for table `ActivitySchedule`
--

INSERT INTO `ActivitySchedule` (`id`, `day_of_week`, `start_at`, `end_at`, `activity_id`, `venue_id`) VALUES
(1, 1, '16:00:00', '18:00:00', 4, 4),
(2, 1, '16:00:00', '18:00:00', 4, 3),
(3, 4, '16:00:00', '18:00:00', 4, 4),
(4, 4, '16:00:00', '18:00:00', 4, 3),
(5, 1, '16:00:00', '18:00:00', 1, 1),
(6, 2, '16:00:00', '18:00:00', 1, 1),
(7, 6, '07:00:00', '09:00:00', 2, 8),
(8, 7, '07:00:00', '09:00:00', 2, 8),
(9, 6, '17:00:00', '21:00:00', 5, 9),
(10, 5, '11:00:00', '13:00:00', 3, 6),
(11, 5, '18:00:00', '20:00:00', 6, 8);

-- --------------------------------------------------------

--
-- Table structure for table `Category`
--

CREATE TABLE IF NOT EXISTS `Category` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_cat_name` (`category_name`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `Category`
--

INSERT INTO `Category` (`id`, `category_name`) VALUES
(5, 'Dance'),
(3, 'Education'),
(4, 'Fitness'),
(2, 'Recreation'),
(1, 'Sports');

-- --------------------------------------------------------

--
-- Table structure for table `DayOfWeek`
--

CREATE TABLE IF NOT EXISTS `DayOfWeek` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `day_of_week` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_day` (`day_of_week`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `DayOfWeek`
--

INSERT INTO `DayOfWeek` (`id`, `day_of_week`) VALUES
(5, 'Friday'),
(1, 'Monday'),
(6, 'Saturday'),
(7, 'Sunday'),
(4, 'Thursday'),
(2, 'Tuesday'),
(3, 'Wednesday');

-- --------------------------------------------------------

--
-- Table structure for table `Employee`
--

CREATE TABLE IF NOT EXISTS `Employee` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(12) NOT NULL,
  `last_name` varchar(12) DEFAULT NULL,
  `line1` varchar(25) NOT NULL,
  `line2` varchar(25) DEFAULT NULL,
  `city` varchar(15) DEFAULT NULL,
  `state` varchar(15) DEFAULT NULL,
  `zip` int(5) DEFAULT NULL,
  `reportsTo` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_emp_id` (`id`),
  KEY `idx_emp_lastname` (`last_name`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Dumping data for table `Employee`
--

INSERT INTO `Employee` (`id`, `first_name`, `last_name`, `line1`, `line2`, `city`, `state`, `zip`, `reportsTo`) VALUES
(1, 'Smita', 'Joshi', '9343 John Kirk', NULL, 'San Diego', 'California', 24533, 3),
(2, 'John', 'Baptist', '454 Palmilla', NULL, 'San Diego', 'California', 24533, 3),
(3, 'Michael', 'Jordan', '23 bulls', NULL, 'Chicago', 'Illinois', 60176, NULL),
(4, 'Smita', 'Patil', '45 Snow Island', NULL, 'San Diego', 'California', 24533, 3),
(5, 'Pablo', 'Escobar', '13 Biscayne Boulevard', NULL, 'Miami', 'Florida', 33018, 3),
(6, 'Ranveer', 'Kulkarni', 'Hollywood', NULL, 'Los Angeles', 'California', 90001, 3),
(7, 'John', 'Hutchingson', '454 Downtown', NULL, 'Charlotte', 'North Carolina', 28261, 5),
(8, 'Priyanka', 'Patel', 'Hollywood', NULL, 'Los Angeles', 'California', 90032, 5),
(9, 'Deepika', 'Paranjape', 'Hollywood', NULL, 'Los Angeles', 'California', 90004, 3),
(10, 'Will', 'Smith', '93 Star Island', NULL, 'Los Angeles', 'California', 24533, 3);

-- --------------------------------------------------------

--
-- Table structure for table `EmployeeActivity`
--

CREATE TABLE IF NOT EXISTS `EmployeeActivity` (
  `employee_id` int(10) NOT NULL DEFAULT '0',
  `activity_instance_id` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`employee_id`,`activity_instance_id`),
  KEY `idx_emp_activity_index_id` (`activity_instance_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `EmployeeActivity`
--

INSERT INTO `EmployeeActivity` (`employee_id`, `activity_instance_id`) VALUES
(1, 1),
(2, 1),
(4, 2),
(6, 2),
(1, 3),
(2, 3),
(4, 4),
(6, 4),
(8, 5),
(9, 5),
(6, 6),
(6, 7),
(10, 8),
(9, 9),
(10, 9),
(2, 10),
(8, 10),
(5, 11);

-- --------------------------------------------------------

--
-- Table structure for table `EmployeeEmail`
--

CREATE TABLE IF NOT EXISTS `EmployeeEmail` (
  `id` int(10) NOT NULL DEFAULT '0',
  `email` varchar(16) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`,`email`),
  KEY `idx_emp_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `EmployeeEmail`
--

INSERT INTO `EmployeeEmail` (`id`, `email`) VALUES
(1, 'smitaj@uncc.edu'),
(1, 'smitajoshi@gmail'),
(2, 'jbap@gmail.com'),
(3, 'jordanmichael@gm'),
(4, 'smitap@gmail.com'),
(4, 'smitap@uncc.edu'),
(5, 'pablo@hotmail.co'),
(5, 'pabloesco@gmail.'),
(6, 'ranveer@gmaill.c'),
(7, 'johnh@gmail.com'),
(8, 'piggychops@hotma'),
(9, 'deepspadukone@ya'),
(10, 'willy@yahoo.com');

-- --------------------------------------------------------

--
-- Table structure for table `EmployeeEvent`
--

CREATE TABLE IF NOT EXISTS `EmployeeEvent` (
  `employee_id` int(10) NOT NULL DEFAULT '0',
  `event_id` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`employee_id`,`event_id`),
  KEY `idx_emp_event_id` (`event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `EmployeeEvent`
--

INSERT INTO `EmployeeEvent` (`employee_id`, `event_id`) VALUES
(1, 1),
(2, 1),
(6, 2),
(7, 3),
(8, 3),
(9, 4),
(5, 5),
(10, 5),
(6, 6),
(2, 7),
(4, 7);

-- --------------------------------------------------------

--
-- Table structure for table `EmployeeLogin`
--

CREATE TABLE IF NOT EXISTS `EmployeeLogin` (
  `id` int(10) NOT NULL DEFAULT '0',
  `pass` varchar(16) NOT NULL,
  PRIMARY KEY (`id`,`pass`),
  KEY `idx_employee_login_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `EmployeeLogin`
--

INSERT INTO `EmployeeLogin` (`id`, `pass`) VALUES
(1, 'pass@smita'),
(2, 'pass@234'),
(3, 'pass@789'),
(4, 'pass@7850'),
(5, 'pass@frty'),
(6, 'pass@ptyu'),
(7, 'pass@1234'),
(8, 'pass@ftyu'),
(9, 'pass@890'),
(10, 'pass@100');

-- --------------------------------------------------------

--
-- Table structure for table `EmployeePhone`
--

CREATE TABLE IF NOT EXISTS `EmployeePhone` (
  `id` int(10) NOT NULL DEFAULT '0',
  `phone_no` varchar(16) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`,`phone_no`),
  KEY `idx_emp_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `EmployeePhone`
--

INSERT INTO `EmployeePhone` (`id`, `phone_no`) VALUES
(1, '7503452231'),
(1, '9283452231'),
(2, '8308590606'),
(3, '9822762896'),
(4, '4445678901'),
(5, '9003452231'),
(6, '8033452231'),
(7, '7773452231'),
(8, '7890452031'),
(8, '8670452231'),
(9, '7503452231'),
(9, '9803892231'),
(10, '7507652231');

-- --------------------------------------------------------

--
-- Table structure for table `Event`
--

CREATE TABLE IF NOT EXISTS `Event` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(35) NOT NULL,
  `event_date` date DEFAULT NULL,
  `start_at` time DEFAULT NULL,
  `end_at` time DEFAULT NULL,
  `venue_id` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_event_venue_id_date` (`venue_id`,`event_date`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `Event`
--

INSERT INTO `Event` (`id`, `name`, `event_date`, `start_at`, `end_at`, `venue_id`) VALUES
(1, 'RecFest', '2017-12-07', '14:00:00', '16:00:00', 5),
(2, 'Charlotte Prom', '2017-11-25', '20:00:00', '22:00:00', 10),
(3, 'Chopra Reception', '2017-12-05', '18:00:00', '23:50:00', 12),
(4, 'Career Carnival', '2017-12-01', '18:00:00', '20:00:00', 12),
(5, 'Food Fest', '2018-01-03', '18:00:00', '23:00:00', 11),
(6, 'Keith Birthday', '2017-11-29', '19:00:00', '23:00:00', 12),
(7, 'Haunted Union', '2017-10-31', '20:00:00', '23:00:00', 12);

-- --------------------------------------------------------

--
-- Stand-in structure for view `EventDuration`
--
CREATE TABLE IF NOT EXISTS `EventDuration` (
`name` varchar(35)
,`event_date` date
,`start_at` time
,`duration` time
,`venue_name` varchar(25)
);
-- --------------------------------------------------------

--
-- Table structure for table `EventInventory`
--

CREATE TABLE IF NOT EXISTS `EventInventory` (
  `event_id` int(10) NOT NULL DEFAULT '0',
  `item_id` int(10) NOT NULL DEFAULT '0',
  `quantity` int(10) DEFAULT NULL,
  PRIMARY KEY (`event_id`,`item_id`),
  KEY `item_id` (`item_id`),
  KEY `idx_event_inventory_event_id` (`event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `EventInventory`
--

INSERT INTO `EventInventory` (`event_id`, `item_id`, `quantity`) VALUES
(1, 7, 2),
(2, 7, 1),
(2, 8, 5),
(3, 3, 300),
(3, 4, 20),
(4, 4, 30),
(5, 4, 50),
(6, 3, 80),
(6, 4, 20),
(7, 8, 18);

-- --------------------------------------------------------

--
-- Stand-in structure for view `IndoorVenue`
--
CREATE TABLE IF NOT EXISTS `IndoorVenue` (
`venue_name` varchar(25)
,`capacity` int(10)
,`opening_time` time
,`closing_time` time
);
-- --------------------------------------------------------

--
-- Table structure for table `Inventory`
--

CREATE TABLE IF NOT EXISTS `Inventory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_name` varchar(20) DEFAULT NULL,
  `item_quantity` int(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `item_name` (`item_name`),
  KEY `idx_inventory_id` (`id`),
  KEY `idx_inventory_item_name` (`item_name`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=13 ;

--
-- Dumping data for table `Inventory`
--

INSERT INTO `Inventory` (`id`, `item_name`, `item_quantity`) VALUES
(1, 'Yoga Mats', 100),
(2, 'Basketball', 50),
(3, 'Chairs', 1500),
(4, 'Tables', 500),
(5, 'Football', 50),
(6, 'Notebooks', 500),
(7, 'Mic', 10),
(8, 'Speakers', 10),
(9, 'Pens', 1000),
(10, 'Swimming floats', 100),
(11, 'Badminton rackets', 60),
(12, 'First Aid Kit', 40);

-- --------------------------------------------------------

--
-- Table structure for table `Member`
--

CREATE TABLE IF NOT EXISTS `Member` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(12) NOT NULL,
  `last_name` varchar(12) DEFAULT NULL,
  `line1` varchar(35) NOT NULL,
  `line2` varchar(25) DEFAULT NULL,
  `city` varchar(15) DEFAULT NULL,
  `state` varchar(15) DEFAULT NULL,
  `zip` int(5) DEFAULT NULL,
  `reg_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_mem_id` (`id`),
  KEY `idx_mem_lastname` (`last_name`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=12 ;

--
-- Dumping data for table `Member`
--

INSERT INTO `Member` (`id`, `first_name`, `last_name`, `line1`, `line2`, `city`, `state`, `zip`, `reg_date`) VALUES
(1, 'Ashwini', 'Kasbekar', '9527 University Terrace Drive', 'Apt F', 'Charlotte', 'North Carolina', 28262, '2017-10-09'),
(2, 'Dev', 'Takle', '9544 University Terrace Drive', 'Apt A', 'Charlotte', 'North Carolina', 28262, '2016-05-30'),
(3, 'Satyam', 'Shukla', '9544 University Terrace Drive', 'Apt A', 'Charlotte', 'North Carolina', 28262, '2016-08-16'),
(4, 'Akshith', 'Subramaniam', '9544 University Terrace Drive', 'Apt A', 'Charlotte', 'North Carolina', 28262, '2017-10-08'),
(5, 'Rajesh', 'Tarkunde', '926 Spring Mist Court', NULL, 'Sugar Land', 'Texas', 77479, '2017-06-07'),
(6, 'Nikita', 'Nalawade', '10004 Graduate Ln Apt B', NULL, 'Charlotte', 'North Carolina', 28262, '2017-05-07'),
(7, 'Manasi', 'Prabhune', '10004 Graduate Ln Apt B', NULL, 'Charlotte', 'North Carolina', 28262, '2017-07-10'),
(8, 'Prutha', 'Shirodkar', '10004 Graduate Ln Apt B', NULL, 'Charlotte', 'North Carolina', 28262, '2017-07-03'),
(9, 'Sanyogeeta', 'Lawande', '10004 Graduate Ln Apt B', NULL, 'Charlotte', 'North Carolina', 28262, '2017-09-04'),
(10, 'Bijay', 'Thomas', '209 Barton Creek Drive ', NULL, 'Charlotte', 'North Carolina', 28262, '2017-09-01'),
(11, 'John', 'Snow', 'Green Park', 'Apt G', 'Charlotte', 'North Carolina', 28262, '2017-11-16');

--
-- Triggers `Member`
--
DROP TRIGGER IF EXISTS `before_Member_insert`;
DELIMITER //
CREATE TRIGGER `before_Member_insert` BEFORE INSERT ON `Member`
 FOR EACH ROW BEGIN 
SET new.reg_date = CURDATE( );
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `MemberActivity`
--

CREATE TABLE IF NOT EXISTS `MemberActivity` (
  `member_id` int(10) NOT NULL DEFAULT '0',
  `activity_instance_id` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`member_id`,`activity_instance_id`),
  KEY `idx_mem_activity_index_id` (`activity_instance_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `MemberActivity`
--

INSERT INTO `MemberActivity` (`member_id`, `activity_instance_id`) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 2),
(5, 2),
(1, 3),
(2, 3),
(3, 3),
(4, 4),
(5, 4),
(6, 5),
(7, 5),
(6, 6),
(7, 6),
(1, 8),
(2, 8),
(3, 8),
(4, 8),
(2, 9),
(7, 10),
(7, 11),
(10, 11);

-- --------------------------------------------------------

--
-- Table structure for table `MemberEmail`
--

CREATE TABLE IF NOT EXISTS `MemberEmail` (
  `id` int(10) NOT NULL DEFAULT '0',
  `email` varchar(16) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`,`email`),
  KEY `idx_mem_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `MemberEmail`
--

INSERT INTO `MemberEmail` (`id`, `email`) VALUES
(1, 'a.kasbeka@gmail.'),
(1, 'akasbeka@uncc.ed'),
(2, 'dtakle@uncc.edu'),
(3, 'sshukla@uncc.edu'),
(4, 'wtuscano@uncc.ed'),
(5, 'rajesh.tarkunde@'),
(6, 'nnalawad@uncc.ed'),
(7, 'mprabhun@uncc.ed'),
(8, 'pshirodk@uncc.ed'),
(9, 'sanyogeetalawand'),
(9, 'slawande@uncc.ed'),
(10, 'bthomas@gmail.co');

-- --------------------------------------------------------

--
-- Table structure for table `MemberEvent`
--

CREATE TABLE IF NOT EXISTS `MemberEvent` (
  `member_id` int(10) NOT NULL DEFAULT '0',
  `event_id` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`member_id`,`event_id`),
  KEY `idx_mem_event_id` (`event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `MemberEvent`
--

INSERT INTO `MemberEvent` (`member_id`, `event_id`) VALUES
(3, 3),
(4, 6);

-- --------------------------------------------------------

--
-- Table structure for table `MemberLogin`
--

CREATE TABLE IF NOT EXISTS `MemberLogin` (
  `id` int(10) NOT NULL DEFAULT '0',
  `pass` varchar(16) NOT NULL,
  PRIMARY KEY (`id`,`pass`),
  KEY `idx_member_login_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `MemberLogin`
--

INSERT INTO `MemberLogin` (`id`, `pass`) VALUES
(1, 'password@1'),
(2, 'password@2'),
(3, 'password@3'),
(4, 'password@4'),
(5, 'password@5'),
(6, 'password@789'),
(7, 'password@23'),
(8, 'password@56'),
(9, 'password@89'),
(10, 'password@10');

-- --------------------------------------------------------

--
-- Table structure for table `MemberPhone`
--

CREATE TABLE IF NOT EXISTS `MemberPhone` (
  `id` int(10) NOT NULL DEFAULT '0',
  `phone_no` varchar(16) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`,`phone_no`),
  KEY `idx_mem_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `MemberPhone`
--

INSERT INTO `MemberPhone` (`id`, `phone_no`) VALUES
(1, '9803659168'),
(2, '8325819712'),
(3, '8844459168'),
(3, '9803659168'),
(4, '9364273668'),
(5, '9803658868'),
(6, '9809659168'),
(7, '8325219712'),
(8, '9804569168'),
(9, '8844409168'),
(10, '9364473668'),
(10, '9803008868');

-- --------------------------------------------------------

--
-- Stand-in structure for view `OutdoorActivityDetails`
--
CREATE TABLE IF NOT EXISTS `OutdoorActivityDetails` (
`activity_name` varchar(12)
,`day_of_week` varchar(12)
,`start_at` time
,`end_at` time
,`venue_name` varchar(25)
);
-- --------------------------------------------------------

--
-- Table structure for table `Venue`
--

CREATE TABLE IF NOT EXISTS `Venue` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `venue_name` varchar(25) NOT NULL,
  `location_type` enum('indoor','outdoor','','') NOT NULL,
  `capacity` int(10) NOT NULL,
  `opening_time` time DEFAULT NULL,
  `closing_time` time DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_venue_id` (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=13 ;

--
-- Dumping data for table `Venue`
--

INSERT INTO `Venue` (`id`, `venue_name`, `location_type`, `capacity`, `opening_time`, `closing_time`) VALUES
(1, 'Badminton Court 1', 'outdoor', 10, '08:00:00', '18:00:00'),
(3, 'Pool 1', 'indoor', 25, '07:00:00', '22:00:00'),
(4, 'Pool 2', 'outdoor', 50, '08:00:00', '18:00:00'),
(5, 'Lawn 1', 'outdoor', 300, '08:00:00', '23:00:00'),
(6, 'Library', 'indoor', 100, '08:00:00', '22:00:00'),
(7, 'Amphitheatre', 'outdoor', 100, '16:00:00', '21:00:00'),
(8, 'Gym', 'indoor', 50, '06:00:00', '23:00:00'),
(9, 'Basketball Court', 'outdoor', 100, '08:00:00', '22:00:00'),
(10, 'Ballroom', 'indoor', 500, '18:00:00', '22:00:00'),
(11, 'EC Ground', 'outdoor', 500, '08:00:00', '23:00:00'),
(12, 'Duke Hall', 'indoor', 200, '12:00:00', '23:00:00');

-- --------------------------------------------------------

--
-- Structure for view `EventDuration`
--
DROP TABLE IF EXISTS `EventDuration`;

CREATE ALGORITHM=UNDEFINED DEFINER=`ashwini19`@`%` SQL SECURITY DEFINER VIEW `EventDuration` AS select distinct `e`.`name` AS `name`,`e`.`event_date` AS `event_date`,`e`.`start_at` AS `start_at`,timediff(`e`.`end_at`,`e`.`start_at`) AS `duration`,`v`.`venue_name` AS `venue_name` from (`Event` `e` join `Venue` `v` on((`e`.`venue_id` = `v`.`id`)));

-- --------------------------------------------------------

--
-- Structure for view `IndoorVenue`
--
DROP TABLE IF EXISTS `IndoorVenue`;

CREATE ALGORITHM=UNDEFINED DEFINER=`ashwini19`@`%` SQL SECURITY DEFINER VIEW `IndoorVenue` AS select `Venue`.`venue_name` AS `venue_name`,`Venue`.`capacity` AS `capacity`,`Venue`.`opening_time` AS `opening_time`,`Venue`.`closing_time` AS `closing_time` from `Venue` where (`Venue`.`location_type` = 'indoor');

-- --------------------------------------------------------

--
-- Structure for view `OutdoorActivityDetails`
--
DROP TABLE IF EXISTS `OutdoorActivityDetails`;

CREATE ALGORITHM=UNDEFINED DEFINER=`ashwini19`@`%` SQL SECURITY DEFINER VIEW `OutdoorActivityDetails` AS select distinct `a`.`activity_name` AS `activity_name`,`dow`.`day_of_week` AS `day_of_week`,`actS`.`start_at` AS `start_at`,`actS`.`end_at` AS `end_at`,`v`.`venue_name` AS `venue_name` from (((`Activity` `a` join `ActivitySchedule` `actS` on((`a`.`id` = `actS`.`activity_id`))) join `DayOfWeek` `dow` on((`dow`.`id` = `actS`.`day_of_week`))) join `Venue` `v` on((`v`.`id` = `actS`.`venue_id`))) where (`v`.`location_type` = 'outdoor');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `ActivityCategory`
--
ALTER TABLE `ActivityCategory`
  ADD CONSTRAINT `ActivityCategory_ibfk_1` FOREIGN KEY (`activity_id`) REFERENCES `Activity` (`id`),
  ADD CONSTRAINT `ActivityCategory_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `Category` (`id`);

--
-- Constraints for table `ActivityInventory`
--
ALTER TABLE `ActivityInventory`
  ADD CONSTRAINT `ActivityInventory_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `Inventory` (`id`),
  ADD CONSTRAINT `ActivityInventory_ibfk_2` FOREIGN KEY (`activity_instance_id`) REFERENCES `ActivitySchedule` (`id`);

--
-- Constraints for table `ActivitySchedule`
--
ALTER TABLE `ActivitySchedule`
  ADD CONSTRAINT `ActivitySchedule_ibfk_1` FOREIGN KEY (`activity_id`) REFERENCES `Activity` (`id`),
  ADD CONSTRAINT `ActivitySchedule_ibfk_2` FOREIGN KEY (`venue_id`) REFERENCES `Venue` (`id`);

--
-- Constraints for table `EmployeeActivity`
--
ALTER TABLE `EmployeeActivity`
  ADD CONSTRAINT `EmployeeActivity_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `Employee` (`id`),
  ADD CONSTRAINT `EmployeeActivity_ibfk_2` FOREIGN KEY (`activity_instance_id`) REFERENCES `ActivitySchedule` (`id`);

--
-- Constraints for table `EmployeeEmail`
--
ALTER TABLE `EmployeeEmail`
  ADD CONSTRAINT `EmployeeEmail_ibfk_1` FOREIGN KEY (`id`) REFERENCES `Employee` (`id`);

--
-- Constraints for table `EmployeeEvent`
--
ALTER TABLE `EmployeeEvent`
  ADD CONSTRAINT `EmployeeEvent_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `Employee` (`id`),
  ADD CONSTRAINT `EmployeeEvent_ibfk_2` FOREIGN KEY (`event_id`) REFERENCES `Event` (`id`);

--
-- Constraints for table `EmployeeLogin`
--
ALTER TABLE `EmployeeLogin`
  ADD CONSTRAINT `EmployeeLogin_ibfk_1` FOREIGN KEY (`id`) REFERENCES `Employee` (`id`);

--
-- Constraints for table `EmployeePhone`
--
ALTER TABLE `EmployeePhone`
  ADD CONSTRAINT `EmployeePhone_ibfk_1` FOREIGN KEY (`id`) REFERENCES `Employee` (`id`);

--
-- Constraints for table `Event`
--
ALTER TABLE `Event`
  ADD CONSTRAINT `Event_ibfk_1` FOREIGN KEY (`venue_id`) REFERENCES `Venue` (`id`);

--
-- Constraints for table `EventInventory`
--
ALTER TABLE `EventInventory`
  ADD CONSTRAINT `EventInventory_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `Event` (`id`),
  ADD CONSTRAINT `EventInventory_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `Inventory` (`id`);

--
-- Constraints for table `MemberActivity`
--
ALTER TABLE `MemberActivity`
  ADD CONSTRAINT `MemberActivity_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `Member` (`id`),
  ADD CONSTRAINT `MemberActivity_ibfk_2` FOREIGN KEY (`activity_instance_id`) REFERENCES `ActivitySchedule` (`id`);

--
-- Constraints for table `MemberEmail`
--
ALTER TABLE `MemberEmail`
  ADD CONSTRAINT `MemberEmail_ibfk_1` FOREIGN KEY (`id`) REFERENCES `Member` (`id`);

--
-- Constraints for table `MemberEvent`
--
ALTER TABLE `MemberEvent`
  ADD CONSTRAINT `MemberEvent_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `Member` (`id`),
  ADD CONSTRAINT `MemberEvent_ibfk_2` FOREIGN KEY (`event_id`) REFERENCES `Event` (`id`);

--
-- Constraints for table `MemberLogin`
--
ALTER TABLE `MemberLogin`
  ADD CONSTRAINT `MemberLogin_ibfk_1` FOREIGN KEY (`id`) REFERENCES `Member` (`id`);

--
-- Constraints for table `MemberPhone`
--
ALTER TABLE `MemberPhone`
  ADD CONSTRAINT `MemberPhone_ibfk_1` FOREIGN KEY (`id`) REFERENCES `Member` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
