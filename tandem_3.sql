-- phpMyAdmin SQL Dump
-- version 4.1.12
-- http://www.phpmyadmin.net
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 28-07-2014 a las 18:36:12
-- Versión del servidor: 5.6.16
-- Versión de PHP: 5.5.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de datos: `tandem`
--
CREATE DATABASE IF NOT EXISTS `tandem` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
USE `tandem`;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `course`
--

DROP TABLE IF EXISTS `course`;
CREATE TABLE IF NOT EXISTS `course` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `courseKey` varchar(70) DEFAULT NULL,
  `title` varchar(150) DEFAULT NULL,
  `use_waiting_room` bit(1) DEFAULT b'0',
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `courseKey` (`courseKey`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `course_exercise`
--

DROP TABLE IF EXISTS `course_exercise`;
CREATE TABLE IF NOT EXISTS `course_exercise` (
  `id_course` int(11) NOT NULL DEFAULT '0',
  `id_exercise` int(11) NOT NULL DEFAULT '0',
  `created` datetime DEFAULT NULL,
  `created_user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_course`,`id_exercise`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `exercise`
--

DROP TABLE IF EXISTS `exercise`;
CREATE TABLE IF NOT EXISTS `exercise` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) DEFAULT NULL,
  `name_xml_file` varchar(60) DEFAULT NULL,
  `enabled` decimal(1,0) DEFAULT '0',
  `created` datetime DEFAULT NULL,
  `created_user_id` int(11) DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_user_id` int(11) DEFAULT NULL,
  `relative_path` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=10 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lti_application`
--

DROP TABLE IF EXISTS `lti_application`;
CREATE TABLE IF NOT EXISTS `lti_application` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `toolurl` varchar(150) COLLATE utf8_bin NOT NULL,
  `name` varchar(150) COLLATE utf8_bin NOT NULL,
  `description` mediumtext COLLATE utf8_bin NOT NULL,
  `resourcekey` varchar(150) COLLATE utf8_bin NOT NULL,
  `password` varchar(150) COLLATE utf8_bin NOT NULL,
  `preferheight` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `sendname` decimal(1,0) NOT NULL DEFAULT '0',
  `sendemailaddr` decimal(1,0) NOT NULL DEFAULT '0',
  `acceptgrades` decimal(1,0) NOT NULL DEFAULT '0',
  `allowroster` decimal(1,0) NOT NULL DEFAULT '0',
  `allowsetting` decimal(1,0) NOT NULL DEFAULT '0',
  `customparameters` text COLLATE utf8_bin,
  `allowinstructorcustom` decimal(1,0) NOT NULL DEFAULT '0',
  `organizationid` varchar(150) COLLATE utf8_bin NOT NULL,
  `organizationurl` varchar(150) COLLATE utf8_bin NOT NULL,
  `launchinpopup` decimal(1,0) DEFAULT '0',
  `debugmode` decimal(1,0) NOT NULL DEFAULT '0',
  `registered` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lti_disabled_application_context`
--

DROP TABLE IF EXISTS `lti_disabled_application_context`;
CREATE TABLE IF NOT EXISTS `lti_disabled_application_context` (
  `id_tool` int(11) NOT NULL,
  `id_context` varchar(24) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id_tool`,`id_context`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `remote_application`
--

DROP TABLE IF EXISTS `remote_application`;
CREATE TABLE IF NOT EXISTS `remote_application` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `toolurl` varchar(250) COLLATE utf8_bin NOT NULL,
  `name` varchar(150) COLLATE utf8_bin NOT NULL,
  `description` mediumtext COLLATE utf8_bin NOT NULL,
  `launchinpopup` decimal(1,0) DEFAULT '0',
  `debugmode` decimal(1,0) NOT NULL DEFAULT '0',
  `registered` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `remote_disabled_application_context`
--

DROP TABLE IF EXISTS `remote_disabled_application_context`;
CREATE TABLE IF NOT EXISTS `remote_disabled_application_context` (
  `id_tool` int(11) NOT NULL,
  `id_context` varchar(24) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id_tool`,`id_context`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tandem`
--

DROP TABLE IF EXISTS `tandem`;
CREATE TABLE IF NOT EXISTS `tandem` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_exercise` int(11) DEFAULT NULL,
  `id_course` int(11) DEFAULT NULL,
  `id_resource_lti` varchar(100) DEFAULT NULL,
  `id_user_host` int(11) DEFAULT NULL COMMENT 'User who invited to the tandem',
  `id_user_guest` int(11) DEFAULT NULL COMMENT 'User who is invited to the tandem',
  `message` mediumtext COMMENT 'To indicate to the other user to',
  `xml` text COMMENT 'To save the xml to reproduce',
  `is_guest_user_logged` bit(1) DEFAULT NULL,
  `date_guest_user_logged` datetime DEFAULT NULL,
  `user_agent_host` varchar(255) NOT NULL,
  `user_agent_guest` varchar(255) NOT NULL,
  `is_finished` bit(1) DEFAULT NULL,
  `finalized` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=12 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(70) DEFAULT NULL,
  `firstname` varchar(50) NOT NULL,
  `surname` varchar(75) NOT NULL,
  `fullname` varchar(150) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `image` varchar(150) DEFAULT NULL,
  `last_session` datetime DEFAULT NULL,
  `icq` varchar(70) DEFAULT NULL,
  `skype` varchar(70) DEFAULT NULL,
  `msn` varchar(70) DEFAULT NULL,
  `yahoo` varchar(70) DEFAULT NULL,
  `blocked` bit(1) DEFAULT b'0',
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `username` (`username`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_course`
--

DROP TABLE IF EXISTS `user_course`;
CREATE TABLE IF NOT EXISTS `user_course` (
  `id_user` int(11) NOT NULL DEFAULT '0',
  `id_course` int(11) NOT NULL DEFAULT '0',
  `is_instructor` bit(1) DEFAULT NULL,
  `lis_result_sourceid` varchar(255) NOT NULL,
  `inTandem` tinyint(1) NOT NULL DEFAULT '0',
  `lastAccessTandem` datetime NOT NULL,
  PRIMARY KEY (`id_user`,`id_course`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_tandem`
--

DROP TABLE IF EXISTS `user_tandem`;
CREATE TABLE IF NOT EXISTS `user_tandem` (
  `id_tandem` int(11) NOT NULL DEFAULT '0',
  `id_user` int(11) NOT NULL DEFAULT '0' COMMENT 'User who start the tandem',
  `total_time` decimal(10,2) DEFAULT NULL COMMENT 'Time in seconds',
  `points` decimal(10,2) DEFAULT NULL,
  `is_finished` bit(1) DEFAULT NULL,
  `finalized` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id_tandem`,`id_user`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_tandem_task`
--

DROP TABLE IF EXISTS `user_tandem_task`;
CREATE TABLE IF NOT EXISTS `user_tandem_task` (
  `id_user` int(11) NOT NULL DEFAULT '0',
  `id_tandem` int(11) NOT NULL DEFAULT '0',
  `task_number` decimal(4,0) NOT NULL DEFAULT '0',
  `total_time` decimal(10,2) DEFAULT NULL COMMENT 'Time in seconds',
  `points` decimal(10,2) DEFAULT NULL,
  `is_finished` bit(1) DEFAULT NULL,
  `finalized` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id_user`,`id_tandem`,`task_number`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_tandem_task_question`
--

DROP TABLE IF EXISTS `user_tandem_task_question`;
CREATE TABLE IF NOT EXISTS `user_tandem_task_question` (
  `id_user` int(11) NOT NULL DEFAULT '0',
  `id_tandem` int(11) NOT NULL DEFAULT '0',
  `task_number` decimal(4,0) NOT NULL DEFAULT '0',
  `question_number` decimal(4,0) NOT NULL DEFAULT '0',
  `total_time` decimal(10,2) DEFAULT NULL COMMENT 'Time in seconds',
  `points` decimal(10,2) DEFAULT NULL,
  `is_finished` bit(1) DEFAULT NULL,
  `finalized` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id_user`,`id_tandem`,`task_number`,`question_number`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `waiting_room`
--

DROP TABLE IF EXISTS `waiting_room`;
CREATE TABLE IF NOT EXISTS `waiting_room` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `language` varchar(10) COLLATE utf8_bin NOT NULL,
  `id_course` int(11) NOT NULL,
  `id_exercise` int(11) NOT NULL,
  `number_user_waiting` decimal(6,0) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=78 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `waiting_room_history`
--

DROP TABLE IF EXISTS `waiting_room_history`;
CREATE TABLE IF NOT EXISTS `waiting_room_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_waiting_room` bigint(20) NOT NULL,
  `language` varchar(10) COLLATE utf8_bin NOT NULL,
  `id_course` int(11) NOT NULL,
  `id_exercise` int(11) NOT NULL,
  `number_user_waiting` decimal(6,0) NOT NULL,
  `created` datetime NOT NULL,
  `created_history` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=60 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `waiting_room_user`
--

DROP TABLE IF EXISTS `waiting_room_user`;
CREATE TABLE IF NOT EXISTS `waiting_room_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_waiting_room` bigint(20) NOT NULL,
  `id_user` bigint(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=15 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `waiting_room_user_history`
--

DROP TABLE IF EXISTS `waiting_room_user_history`;
CREATE TABLE IF NOT EXISTS `waiting_room_user_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_waiting_room` bigint(20) NOT NULL,
  `id_user` bigint(11) NOT NULL,
  `status` enum('waiting','assigned','lapsed','give_up') COLLATE utf8_bin NOT NULL,
  `created` datetime NOT NULL,
  `created_history` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=2 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
