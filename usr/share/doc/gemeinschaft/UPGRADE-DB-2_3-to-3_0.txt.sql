USE `asterisk`;

--
-- Update structure for table `queue_cf_timerules`
--

ALTER TABLE `queue_cf_timerules`
 ADD `id` int(10) unsigned NOT NULL auto_increment FIRST;

ALTER TABLE `queue_cf_timerules`
 ADD PRIMARY KEY  (`id`);


--
-- Update structure for table `ast_queue_members`
--


ALTER TABLE `ast_queue_members`
 DROP PRIMARY KEY;

ALTER TABLE `ast_queue_members`
 ADD PRIMARY KEY (`uniqueid`);

ALTER TABLE `ast_queue_members`
 ADD UNIQUE KEY `queue_name_interface` (`queue_name`,`interface`);



--
-- Since: QueueMon
--

SET character_set_client = utf8;
CREATE TABLE `monitor` (
  `user_id` int(10) unsigned NOT NULL,
  `type` tinyint(2) unsigned NOT NULL default '1',
  `display_x` smallint(4) unsigned NOT NULL default '0',
  `display_y` smallint(4) unsigned NOT NULL default '0',
  `columns` tinyint(2) unsigned NOT NULL default '2',
  `update` smallint(4) unsigned NOT NULL default '2',
  `reload` smallint(4) unsigned NOT NULL default '120',
  PRIMARY KEY  (`user_id`, `type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8  COLLATE=utf8_unicode_ci;

SET character_set_client = utf8;
CREATE TABLE `monitor_colors` (
  `user_id` int(10) unsigned NOT NULL,
  `type` tinyint(2) unsigned NOT NULL default '1',
  `status` tinyint(3) unsigned NOT NULL default '2',
  `color` varchar(20) collate utf8_unicode_ci NOT NULL default '#fff',
  PRIMARY KEY  (`user_id`, `type`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8  COLLATE=utf8_unicode_ci;

SET character_set_client = utf8;
CREATE TABLE `monitor_queues` (
  `user_id` int(10) unsigned NOT NULL,
  `queue_id` int(10) unsigned NOT NULL,
  `active` tinyint(1) unsigned NOT NULL default '1',
  `display_columns` tinyint(2) unsigned NOT NULL default '2',
  `display_width` smallint(4) unsigned NOT NULL default '500',
  `display_height` smallint(4) unsigned NOT NULL default '150',
  `display_calls` smallint(5) unsigned NOT NULL default '15',
  `display_answered` smallint(5) unsigned NOT NULL default '15',
  `display_abandoned` smallint(5) unsigned NOT NULL default '15',
  `display_timeout` smallint(5) unsigned NOT NULL default '15',
  `display_wait_max` smallint(5) unsigned NOT NULL default '15',
  `display_wait_min` smallint(5) unsigned NOT NULL default '15',
  `display_wait_avg` smallint(5) unsigned NOT NULL default '15',
  `display_call_max` smallint(5) unsigned NOT NULL default '15',
  `display_call_min` smallint(5) unsigned NOT NULL default '15',
  `display_call_avg` smallint(5) unsigned NOT NULL default '15',
  `display_extension` smallint(5) unsigned NOT NULL default '0',
  `display_name` smallint(5) unsigned NOT NULL default '4',			       
  PRIMARY KEY  (`user_id`, `queue_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8  COLLATE=utf8_unicode_ci;

CREATE TABLE `monitor_groups` (
  `user_id` int(10) unsigned NOT NULL,
  `group_id` int(10) unsigned NOT NULL,
  `active` tinyint(1) unsigned NOT NULL default '1',
  `display_columns` tinyint(2) unsigned NOT NULL default '2',
  `display_width` smallint(4) unsigned NOT NULL default '500',
  `display_height` smallint(4) unsigned NOT NULL default '150',
  `display_extension` smallint(5) unsigned NOT NULL default '2',
  `display_name` smallint(5) unsigned NOT NULL default '4',
  `display_forw` smallint(5) unsigned NOT NULL default '3',
  `display_comment` smallint(5) unsigned NOT NULL default '0',
  PRIMARY KEY  (`user_id`, `group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8  COLLATE=utf8_unicode_ci;

--
-- Menu `wakeupcalls`moved to `admin`


INSERT INTO `group_members` VALUES ((SELECT `id` FROM `groups` WHERE `name` = 'admins' LIMIT 1),15014);

DELETE FROM `group_members` WHERE `member`=22000 OR `member`=22001;

--
-- After: 0abbe0e728149d5d8343c761f15be21d66b2ef42 (private_call)
--
INSERT INTO `group_permissions` VALUES ('private_call',(SELECT `id` FROM `groups` WHERE `name` = 'users' LIMIT 1),(SELECT `id` FROM `groups` WHERE `name` = 'users' LIMIT 1));
--
-- After: b80bd254fd443778893dc725120db981252298a8 (new group nobody_users)
--

INSERT INTO `groups` VALUES (NULL,'nobody_users','All Nobody Users','user');
INSERT INTO `group_connections` VALUES ('mysql',(SELECT `id` FROM `groups` WHERE `name` = 'nobody_users' LIMIT 1),'id','SELECT `id` FROM `users` WHERE `nobody_index` IS NOT NULL');
INSERT INTO `group_permissions` VALUES ('phonebook_user',(SELECT `id` FROM `groups` WHERE `name` = 'nobody_users' LIMIT 1),(SELECT `id` FROM `groups` WHERE `name` = 'users' LIMIT 1));

--
-- Cache table for prov_checkcfg phonetypes
-- As this contains only temp. data, it can safely be dropped and recreated
--

DROP TABLE IF EXISTS `phones_typecache`;
CREATE TABLE IF NOT EXISTS `phones_typecache` (
 `entrytype` enum('ip','ext') COLLATE utf8_unicode_ci NOT NULL,
 `value` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
 `phonetype` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
 `epoch_inserted` bigint(20) NOT NULL,
 KEY `idx_entrytype` (`entrytype`),
 KEY `idx_value` (`value`),
 KEY `idx_epoch_inserted` (`epoch_inserted`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


--
-- Add new column with primary key to table `gate_params`
--

ALTER TABLE `gate_params` ADD `param_id` INT( 8 ) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;

--
-- Allow column `param` being null in table `gate_params`
--

ALTER TABLE `gate_params` CHANGE `param` `param` VARCHAR( 50 ) CHARACTER SET ascii COLLATE ascii_general_ci NULL;

--
-- Column `ipaddr` in table `ast_sipfriends` needs a length of 45 characters 
--

ALTER TABLE `ast_sipfriends` CHANGE `ipaddr` `ipaddr` VARCHAR( 45 ) CHARACTER SET ascii COLLATE ascii_general_ci NULL DEFAULT NULL;

--
-- Renamed column `_uniqueid` to `uniqueid` in table `ast_voicemail` (for asterisk 1.8)
--

ALTER TABLE `ast_voicemail` CHANGE `_uniqueid` `uniqueid` INT( 11 ) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Resize column `regseconds` in table `ast_sipfriends` (for asterisk 1.8)
--

ALTER TABLE `ast_sipfriends` CHANGE `regseconds` `regseconds` INT( 11 ) NULL DEFAULT NULL;
