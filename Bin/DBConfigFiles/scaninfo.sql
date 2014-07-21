# Host: 127.0.0.1  (Version: 5.6.17)
# Date: 2014-07-21 11:21:05
# Generator: MySQL-Front 5.3  (Build 4.123)

/*!40101 SET NAMES utf8 */;

#
# Structure for table "scaninfo"
#

CREATE TABLE `scaninfo` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `barcode` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
