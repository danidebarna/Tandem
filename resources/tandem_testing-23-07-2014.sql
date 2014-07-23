-- phpMyAdmin SQL Dump
-- version 4.1.12
-- http://www.phpmyadmin.net
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 23-07-2014 a las 17:27:02
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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `course`
--

CREATE TABLE IF NOT EXISTS `course` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `courseKey` varchar(70) DEFAULT NULL,
  `title` varchar(150) DEFAULT NULL,
  `use_waiting_room` bit(1) DEFAULT b'0',
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `courseKey` (`courseKey`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Volcado de datos para la tabla `course`
--

INSERT INTO `course` (`id`, `courseKey`, `title`, `use_waiting_room`, `created`) VALUES
(2, 'test:2', 'SAC101', b'0', '2014-07-16 14:39:24');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `course_exercise`
--

CREATE TABLE IF NOT EXISTS `course_exercise` (
  `id_course` int(11) NOT NULL DEFAULT '0',
  `id_exercise` int(11) NOT NULL DEFAULT '0',
  `created` datetime DEFAULT NULL,
  `created_user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_course`,`id_exercise`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `course_exercise`
--

INSERT INTO `course_exercise` (`id_course`, `id_exercise`, `created`, `created_user_id`) VALUES
(2, 1, '2014-07-16 14:44:33', 2),
(2, 2, '2014-07-18 15:01:58', 2),
(2, 3, '2014-07-21 09:33:06', 2),
(2, 4, '2014-07-21 09:33:15', 2),
(2, 5, '2014-07-21 09:33:26', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `exercise`
--

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
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- Volcado de datos para la tabla `exercise`
--

INSERT INTO `exercise` (`id`, `name`, `name_xml_file`, `enabled`, `created`, `created_user_id`, `modified`, `modified_user_id`, `relative_path`) VALUES
(1, 'verbos y conjunciones', 'TandemXWikiboilsc181220131303', '1', '2014-07-16 14:44:33', 2, '2014-07-16 14:44:33', 2, '\\1'),
(2, 'testeo del tiempo', 'TandemXWikiadmin060220131529', '1', '2014-07-18 15:01:58', 2, '2014-07-18 15:01:58', 2, '\\2'),
(3, 'vocabulario y adjetivos', 'TandemXWikiadmin060220131529', '1', '2014-07-21 09:33:06', 2, '2014-07-21 09:33:06', 2, '\\3'),
(4, 'false friends', 'TandemXWikiboilsc181220131303', '1', '2014-07-21 09:33:15', 2, '2014-07-21 09:33:15', 2, '\\4'),
(5, 'expresiones regulares', 'TandemXWikiadmin060220131529', '1', '2014-07-21 09:33:26', 2, '2014-07-21 09:33:26', 2, '\\5');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lti_application`
--

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

CREATE TABLE IF NOT EXISTS `lti_disabled_application_context` (
  `id_tool` int(11) NOT NULL,
  `id_context` varchar(24) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id_tool`,`id_context`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `remote_application`
--

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

CREATE TABLE IF NOT EXISTS `remote_disabled_application_context` (
  `id_tool` int(11) NOT NULL,
  `id_context` varchar(24) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id_tool`,`id_context`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tandem`
--

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
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Volcado de datos para la tabla `tandem`
--

INSERT INTO `tandem` (`id`, `id_exercise`, `id_course`, `id_resource_lti`, `id_user_host`, `id_user_guest`, `message`, `xml`, `is_guest_user_logged`, `date_guest_user_logged`, `user_agent_host`, `user_agent_guest`, `is_finished`, `finalized`, `created`) VALUES
(1, 2, 2, 'test_1104', 2, 1, '', '<?xml version="1.0"?>\n<tandem>\n  <usuarios room="TandemXWikiadmin060220131529test_1104_1" exercise="TandemXWikiadmin060220131529"><usuario name="Teacher" email="teacher@teacher.com" icq="" skype="" msn="" yahoo="" image="http://www.gravatar.com/avatar.php?gravatar_id=c80090398a4fe1379cd8e4f989c6dfb0&amp;size=40" points="985">a</usuario><usuario name="Dani" email="dani@tresipunt.com" icq="" skype="" msn="" yahoo="" image="http://www.gravatar.com/avatar.php?gravatar_id=f723a3fb4b9998195d2bf025845c6346&amp;size=40" points="289">b</usuario></usuarios>\n</tandem>\n', b'0', '2014-07-18 15:02:17', 'Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36', 'Mozilla/5.0 (Windows NT 6.3; WOW64; rv:30.0) Gecko/20100101 Firefox/30.0', b'0', NULL, '2014-07-18 15:02:06'),
(3, 2, 2, NULL, 1, NULL, NULL, NULL, NULL, NULL, '', '', NULL, NULL, NULL),
(4, 2, 2, NULL, 1, NULL, NULL, NULL, NULL, NULL, '', '', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user`
--

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

--
-- Volcado de datos para la tabla `user`
--

INSERT INTO `user` (`id`, `username`, `firstname`, `surname`, `fullname`, `email`, `image`, `last_session`, `icq`, `skype`, `msn`, `yahoo`, `blocked`, `created`) VALUES
(1, 'dani', 'Dani', 'Herrera', 'Dani Herrera', 'dani@tresipunt.com', 'http://www.gravatar.com/avatar.php?gravatar_id=f723a3fb4b9998195d2bf025845c6346&size=40', '2014-07-22 16:21:46', '', '', '', '', b'0', '2014-07-16 14:36:31'),
(2, 'teacher', 'Teacher', 'Teacher', 'Teacher Teacher', 'teacher@teacher.com', 'http://www.gravatar.com/avatar.php?gravatar_id=c80090398a4fe1379cd8e4f989c6dfb0&size=40', '2014-07-22 11:02:01', '', '', '', '', b'0', '2014-07-16 14:44:23');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_course`
--

CREATE TABLE IF NOT EXISTS `user_course` (
  `id_user` int(11) NOT NULL DEFAULT '0',
  `id_course` int(11) NOT NULL DEFAULT '0',
  `is_instructor` bit(1) DEFAULT NULL,
  `lis_result_sourceid` varchar(255) NOT NULL,
  `inTandem` tinyint(1) NOT NULL DEFAULT '0',
  `lastAccessTandem` datetime NOT NULL,
  PRIMARY KEY (`id_user`,`id_course`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `user_course`
--

INSERT INTO `user_course` (`id_user`, `id_course`, `is_instructor`, `lis_result_sourceid`, `inTandem`, `lastAccessTandem`) VALUES
(1, 1, b'0', '', 0, '2014-07-16 14:36:31'),
(1, 2, b'0', '', 1, '2014-07-18 15:02:06'),
(2, 2, b'1', '', 1, '2014-07-18 15:02:06');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_tandem`
--

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

--
-- Volcado de datos para la tabla `user_tandem`
--

INSERT INTO `user_tandem` (`id_tandem`, `id_user`, `total_time`, `points`, `is_finished`, `finalized`, `created`) VALUES
(1, 2, '30.00', '0.00', b'0', NULL, '2014-07-18 15:02:09'),
(1, 1, '179490.00', '0.00', b'0', NULL, '2014-07-18 15:02:17');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_tandem_task`
--

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

--
-- Volcado de datos para la tabla `user_tandem_task`
--

INSERT INTO `user_tandem_task` (`id_user`, `id_tandem`, `task_number`, `total_time`, `points`, `is_finished`, `finalized`, `created`) VALUES
(2, 1, '1', '27.00', '0.00', b'0', NULL, '2014-07-18 15:02:09'),
(1, 1, '1', '179479.00', '0.00', b'0', NULL, '2014-07-18 15:02:17');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user_tandem_task_question`
--

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

--
-- Volcado de datos para la tabla `user_tandem_task_question`
--

INSERT INTO `user_tandem_task_question` (`id_user`, `id_tandem`, `task_number`, `question_number`, `total_time`, `points`, `is_finished`, `finalized`, `created`) VALUES
(2, 1, '1', '0', '0.00', '0.00', b'0', NULL, '2014-07-18 15:02:09'),
(1, 1, '1', '0', '0.00', '0.00', b'0', NULL, '2014-07-18 15:02:17');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `waiting_room`
--

CREATE TABLE IF NOT EXISTS `waiting_room` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `language` varchar(10) COLLATE utf8_bin NOT NULL,
  `id_course` int(11) NOT NULL,
  `id_exercise` int(11) NOT NULL,
  `number_user_waiting` decimal(6,0) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=55 ;

--
-- Volcado de datos para la tabla `waiting_room`
--

INSERT INTO `waiting_room` (`id`, `language`, `id_course`, `id_exercise`, `number_user_waiting`, `created`) VALUES
(22, 'en_US', 2, 3, '2', '2014-07-21 13:56:58'),
(24, 'es_ES', 2, 1, '14', '2014-07-21 13:56:58'),
(25, 'en_US', 2, 2, '1', '2014-07-21 13:56:58'),
(27, 'es_ES', 2, 4, '8', '2014-07-21 13:56:58'),
(28, 'es_ES', 2, 5, '2', '2014-07-21 13:56:59');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `waiting_room_history`
--

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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=3 ;

--
-- Volcado de datos para la tabla `waiting_room_history`
--

INSERT INTO `waiting_room_history` (`id`, `id_waiting_room`, `language`, `id_course`, `id_exercise`, `number_user_waiting`, `created`, `created_history`) VALUES
(1, 19, 'en_US', 2, 0, '1', '2014-07-17 13:01:26', '2014-07-17 13:01:27'),
(2, 20, 'en_US', 2, 40, '1', '2014-07-17 13:02:07', '2014-07-17 13:02:08');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `waiting_room_user`
--

CREATE TABLE IF NOT EXISTS `waiting_room_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_waiting_room` bigint(20) NOT NULL,
  `id_user` bigint(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=97 ;

--
-- Volcado de datos para la tabla `waiting_room_user`
--

INSERT INTO `waiting_room_user` (`id`, `id_waiting_room`, `id_user`, `created`) VALUES
(1, 13, 1, '2014-07-17 11:23:04'),
(2, 14, 1, '2014-07-17 11:43:35'),
(3, 15, 1, '2014-07-17 12:55:53'),
(4, 16, 1, '2014-07-17 12:56:50'),
(5, 17, 1, '2014-07-17 12:59:17'),
(6, 18, 1, '2014-07-17 13:00:48'),
(7, 19, 1, '2014-07-17 13:01:26'),
(8, 20, 1, '2014-07-17 13:02:08'),
(9, 21, 1, '2014-07-17 13:06:56'),
(10, 23, 1, '2014-07-17 13:11:12'),
(11, 24, 1, '2014-07-17 14:06:16'),
(12, 25, 1, '2014-07-17 14:06:25'),
(13, 26, 1, '2014-07-17 16:10:36'),
(14, 27, 1, '2014-07-17 16:15:16'),
(15, 28, 1, '2014-07-17 16:22:17'),
(16, 29, 1, '2014-07-17 16:25:09'),
(17, 30, 1, '2014-07-17 16:30:36'),
(18, 31, 1, '2014-07-17 16:31:10'),
(19, 32, 1, '2014-07-17 16:33:31'),
(20, 33, 1, '2014-07-17 16:34:38'),
(21, 34, 1, '2014-07-17 16:36:01'),
(22, 39, 1, '2014-07-17 16:40:19'),
(23, 40, 1, '2014-07-17 16:40:22'),
(24, 41, 1, '2014-07-17 16:40:25'),
(25, 42, 1, '2014-07-17 16:43:18'),
(26, 43, 1, '2014-07-17 16:47:39'),
(27, 44, 1, '2014-07-17 16:48:10'),
(28, 45, 1, '2014-07-17 16:48:23'),
(29, 46, 1, '2014-07-17 16:48:53'),
(30, 47, 1, '2014-07-17 16:51:04'),
(31, 48, 1, '2014-07-17 16:51:06'),
(32, 49, 1, '2014-07-17 16:51:18'),
(33, 50, 1, '2014-07-17 16:59:06'),
(34, 51, 1, '2014-07-17 16:59:19'),
(35, 54, 1, '2014-07-17 17:01:15'),
(36, 55, 1, '2014-07-17 17:01:19'),
(37, 56, 1, '2014-07-17 17:01:21'),
(38, 57, 1, '2014-07-17 17:02:47'),
(39, 58, 1, '2014-07-17 17:02:49'),
(40, 59, 1, '2014-07-17 17:03:52'),
(41, 60, 1, '2014-07-17 17:03:53'),
(42, 61, 1, '2014-07-17 17:03:59'),
(43, 62, 1, '2014-07-17 17:04:30'),
(44, 63, 1, '2014-07-17 17:04:56'),
(45, 64, 1, '2014-07-17 17:07:23'),
(46, 67, 1, '2014-07-17 17:09:22'),
(47, 68, 1, '2014-07-17 17:10:30'),
(48, 69, 1, '2014-07-17 17:10:32'),
(49, 72, 1, '2014-07-17 17:14:22'),
(50, 73, 1, '2014-07-17 17:14:24'),
(51, 74, 1, '2014-07-17 17:14:58'),
(52, 75, 1, '2014-07-17 17:20:33'),
(53, 76, 1, '2014-07-17 17:21:27'),
(54, 77, 1, '2014-07-17 17:22:25'),
(55, 78, 1, '2014-07-17 17:22:57'),
(56, 79, 1, '2014-07-17 17:24:47'),
(57, 80, 1, '2014-07-17 18:44:56'),
(58, 81, 1, '2014-07-17 20:56:04'),
(59, 82, 1, '2014-07-17 20:56:29'),
(60, 83, 1, '2014-07-17 20:57:55'),
(61, 84, 1, '2014-07-17 20:58:53'),
(62, 85, 1, '2014-07-17 20:59:25'),
(63, 86, 1, '2014-07-17 22:14:15'),
(64, 87, 1, '2014-07-17 22:14:24'),
(65, 88, 1, '2014-07-17 22:30:53'),
(66, 89, 1, '2014-07-17 22:31:14'),
(67, 90, 1, '2014-07-17 22:31:58'),
(68, 91, 1, '2014-07-17 22:37:45'),
(69, 92, 1, '2014-07-17 23:26:18'),
(70, 93, 1, '2014-07-18 09:08:21'),
(71, 94, 1, '2014-07-18 09:08:26'),
(72, 95, 1, '2014-07-18 09:28:49'),
(73, 29, 1, '2014-07-22 16:02:27'),
(74, 30, 1, '2014-07-22 16:06:45'),
(75, 31, 1, '2014-07-22 16:06:48'),
(76, 32, 1, '2014-07-22 16:06:53'),
(77, 33, 1, '2014-07-22 16:08:20'),
(78, 34, 1, '2014-07-22 16:16:49'),
(79, 35, 1, '2014-07-22 16:16:58'),
(80, 36, 1, '2014-07-22 16:17:02'),
(81, 37, 1, '2014-07-22 16:18:56'),
(82, 38, 1, '2014-07-22 16:23:07'),
(83, 39, 1, '2014-07-22 16:25:29'),
(84, 40, 1, '2014-07-22 16:26:04'),
(85, 41, 1, '2014-07-22 16:26:17'),
(86, 42, 1, '2014-07-22 16:28:01'),
(87, 43, 1, '2014-07-22 16:28:19'),
(88, 44, 1, '2014-07-22 16:30:54'),
(89, 45, 1, '2014-07-22 16:31:23'),
(90, 46, 1, '2014-07-22 16:31:30'),
(91, 47, 1, '2014-07-22 16:37:55'),
(92, 48, 1, '2014-07-22 16:38:12'),
(93, 49, 1, '2014-07-22 16:38:23'),
(94, 50, 1, '2014-07-22 16:38:45'),
(95, 51, 1, '2014-07-22 16:38:56'),
(96, 52, 1, '2014-07-22 16:39:06');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `waiting_room_user_history`
--

CREATE TABLE IF NOT EXISTS `waiting_room_user_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `id_waiting_room` bigint(20) NOT NULL,
  `id_user` bigint(11) NOT NULL,
  `status` enum('waiting','assigned','lapsed','give_up') COLLATE utf8_bin NOT NULL,
  `created` datetime NOT NULL,
  `created_history` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=2 ;

--
-- Volcado de datos para la tabla `waiting_room_user_history`
--

INSERT INTO `waiting_room_user_history` (`id`, `id_waiting_room`, `id_user`, `status`, `created`, `created_history`) VALUES
(1, 1, 2, 'waiting', '2014-07-08 00:00:00', '2014-07-17 12:40:46');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
