-- Adminer 4.8.1 MySQL 5.7.37 dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;

CREATE DATABASE `chat` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `chat`;

SET NAMES utf8mb4;

DROP TABLE IF EXISTS `chat_log`;
CREATE TABLE `chat_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `map` varchar(128) NOT NULL,
  `steamid` varchar(21) NOT NULL,
  `name` varchar(128) NOT NULL,
  `message_style` tinyint(2) DEFAULT '0',
  `message` varchar(126) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE DATABASE `l4d2stats` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_bin */;
USE `l4d2stats`;

DROP TABLE IF EXISTS `ip2country`;
CREATE TABLE `ip2country` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `begin_ip_num` int(11) unsigned NOT NULL,
  `end_ip_num` int(11) unsigned NOT NULL,
  `country_code` varchar(4) NOT NULL,
  `country_name` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `begin_ip_num` (`begin_ip_num`,`end_ip_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `ip2country_blocks`;
CREATE TABLE `ip2country_blocks` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `begin_ip_num` int(11) unsigned NOT NULL,
  `end_ip_num` int(11) unsigned NOT NULL,
  `loc_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `beginend` (`begin_ip_num`,`end_ip_num`) USING BTREE,
  KEY `loc_id` (`loc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `ip2country_locations`;
CREATE TABLE `ip2country_locations` (
  `loc_id` int(11) unsigned NOT NULL,
  `country_code` varchar(4) NOT NULL,
  `loc_region` varchar(128) NOT NULL,
  `loc_city` tinyblob NOT NULL,
  `latitude` double NOT NULL,
  `longitude` double NOT NULL,
  PRIMARY KEY (`loc_id`),
  KEY `country_code` (`country_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `lilac_detections`;
CREATE TABLE `lilac_detections` (
  `name` varchar(128) CHARACTER SET utf8mb4 NOT NULL,
  `steamid` varchar(32) CHARACTER SET utf8mb4 NOT NULL,
  `ip` varchar(16) CHARACTER SET utf8mb4 NOT NULL,
  `cheat` varchar(50) CHARACTER SET utf8mb4 NOT NULL,
  `timestamp` int(11) NOT NULL,
  `detection` int(11) NOT NULL,
  `pos1` float NOT NULL,
  `pos2` float NOT NULL,
  `pos3` float NOT NULL,
  `ang1` float NOT NULL,
  `ang2` float NOT NULL,
  `ang3` float NOT NULL,
  `map` varchar(128) CHARACTER SET utf8mb4 NOT NULL,
  `team` int(11) NOT NULL,
  `weapon` varchar(64) CHARACTER SET utf8mb4 NOT NULL,
  `data1` float NOT NULL,
  `data2` float NOT NULL,
  `latency_inc` float NOT NULL,
  `latency_out` float NOT NULL,
  `loss_inc` float NOT NULL,
  `loss_out` float NOT NULL,
  `choke_inc` float NOT NULL,
  `choke_out` float NOT NULL,
  `connection_ticktime` float NOT NULL,
  `game_ticktime` float NOT NULL,
  `lilac_version` varchar(20) CHARACTER SET utf8mb4 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `maps`;
CREATE TABLE `maps` (
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `gamemode` int(1) NOT NULL DEFAULT '0',
  `custom` bit(1) NOT NULL DEFAULT b'0',
  `playtime_nor` int(11) NOT NULL DEFAULT '0',
  `playtime_adv` int(11) NOT NULL DEFAULT '0',
  `playtime_exp` int(11) NOT NULL DEFAULT '0',
  `restarts_nor` int(11) NOT NULL DEFAULT '0',
  `restarts_adv` int(11) NOT NULL DEFAULT '0',
  `restarts_exp` int(11) NOT NULL DEFAULT '0',
  `points_nor` int(11) NOT NULL DEFAULT '0',
  `points_adv` int(11) NOT NULL DEFAULT '0',
  `points_exp` int(11) NOT NULL DEFAULT '0',
  `points_infected_nor` int(11) NOT NULL DEFAULT '0',
  `points_infected_adv` int(11) NOT NULL DEFAULT '0',
  `points_infected_exp` int(11) NOT NULL DEFAULT '0',
  `kills_nor` int(11) NOT NULL DEFAULT '0',
  `kills_adv` int(11) NOT NULL DEFAULT '0',
  `kills_exp` int(11) NOT NULL DEFAULT '0',
  `survivor_kills_nor` int(11) NOT NULL DEFAULT '0',
  `survivor_kills_adv` int(11) NOT NULL DEFAULT '0',
  `survivor_kills_exp` int(11) NOT NULL DEFAULT '0',
  `infected_win_nor` int(11) NOT NULL DEFAULT '0',
  `infected_win_adv` int(11) NOT NULL DEFAULT '0',
  `infected_win_exp` int(11) NOT NULL DEFAULT '0',
  `survivors_win_nor` int(11) NOT NULL DEFAULT '0',
  `survivors_win_adv` int(11) NOT NULL DEFAULT '0',
  `survivors_win_exp` int(11) NOT NULL DEFAULT '0',
  `infected_smoker_damage_nor` bigint(20) NOT NULL DEFAULT '0',
  `infected_smoker_damage_adv` bigint(20) NOT NULL DEFAULT '0',
  `infected_smoker_damage_exp` bigint(20) NOT NULL DEFAULT '0',
  `infected_jockey_damage_nor` bigint(20) NOT NULL DEFAULT '0',
  `infected_jockey_damage_adv` bigint(20) NOT NULL DEFAULT '0',
  `infected_jockey_damage_exp` bigint(20) NOT NULL DEFAULT '0',
  `infected_jockey_ridetime_nor` double NOT NULL DEFAULT '0',
  `infected_jockey_ridetime_adv` double NOT NULL DEFAULT '0',
  `infected_jockey_ridetime_exp` double NOT NULL DEFAULT '0',
  `infected_charger_damage_nor` bigint(20) NOT NULL DEFAULT '0',
  `infected_charger_damage_adv` bigint(20) NOT NULL DEFAULT '0',
  `infected_charger_damage_exp` bigint(20) NOT NULL DEFAULT '0',
  `infected_tank_damage_nor` bigint(20) NOT NULL DEFAULT '0',
  `infected_tank_damage_adv` bigint(20) NOT NULL DEFAULT '0',
  `infected_tank_damage_exp` bigint(20) NOT NULL DEFAULT '0',
  `infected_boomer_vomits_nor` int(11) NOT NULL DEFAULT '0',
  `infected_boomer_vomits_adv` int(11) NOT NULL DEFAULT '0',
  `infected_boomer_vomits_exp` int(11) NOT NULL DEFAULT '0',
  `infected_boomer_blinded_nor` int(11) NOT NULL DEFAULT '0',
  `infected_boomer_blinded_adv` int(11) NOT NULL DEFAULT '0',
  `infected_boomer_blinded_exp` int(11) NOT NULL DEFAULT '0',
  `infected_spitter_damage_nor` int(11) NOT NULL DEFAULT '0',
  `infected_spitter_damage_adv` int(11) NOT NULL DEFAULT '0',
  `infected_spitter_damage_exp` int(11) NOT NULL DEFAULT '0',
  `infected_spawn_1_nor` int(11) NOT NULL DEFAULT '0' COMMENT 'Spawn as Smoker',
  `infected_spawn_1_adv` int(11) NOT NULL DEFAULT '0' COMMENT 'Spawn as Smoker',
  `infected_spawn_1_exp` int(11) NOT NULL DEFAULT '0' COMMENT 'Spawn as Smoker',
  `infected_spawn_2_nor` int(11) NOT NULL DEFAULT '0' COMMENT 'Spawn as Boomer',
  `infected_spawn_2_adv` int(11) NOT NULL DEFAULT '0' COMMENT 'Spawn as Boomer',
  `infected_spawn_2_exp` int(11) NOT NULL DEFAULT '0' COMMENT 'Spawn as Boomer',
  `infected_spawn_3_nor` int(11) NOT NULL DEFAULT '0' COMMENT 'Spawn as Hunter',
  `infected_spawn_3_adv` int(11) NOT NULL DEFAULT '0' COMMENT 'Spawn as Hunter',
  `infected_spawn_3_exp` int(11) NOT NULL DEFAULT '0' COMMENT 'Spawn as Hunter',
  `infected_spawn_4_nor` int(11) NOT NULL DEFAULT '0' COMMENT 'Spawn as Spitter',
  `infected_spawn_4_adv` int(11) NOT NULL DEFAULT '0' COMMENT 'Spawn as Spitter',
  `infected_spawn_4_exp` int(11) NOT NULL DEFAULT '0' COMMENT 'Spawn as Spitter',
  `infected_spawn_5_nor` int(11) NOT NULL DEFAULT '0' COMMENT 'Spawn as Jockey',
  `infected_spawn_5_adv` int(11) NOT NULL DEFAULT '0' COMMENT 'Spawn as Jockey',
  `infected_spawn_5_exp` int(11) NOT NULL DEFAULT '0' COMMENT 'Spawn as Jockey',
  `infected_spawn_6_nor` int(11) NOT NULL DEFAULT '0' COMMENT 'Spawn as Charger',
  `infected_spawn_6_adv` int(11) NOT NULL DEFAULT '0' COMMENT 'Spawn as Charger',
  `infected_spawn_6_exp` int(11) NOT NULL DEFAULT '0' COMMENT 'Spawn as Charger',
  `infected_spawn_8_nor` int(11) NOT NULL DEFAULT '0' COMMENT 'Spawn as Tank',
  `infected_spawn_8_adv` int(11) NOT NULL DEFAULT '0' COMMENT 'Spawn as Tank',
  `infected_spawn_8_exp` int(11) NOT NULL DEFAULT '0' COMMENT 'Spawn as Tank',
  `infected_hunter_pounce_counter_nor` int(11) NOT NULL DEFAULT '0',
  `infected_hunter_pounce_counter_adv` int(11) NOT NULL DEFAULT '0',
  `infected_hunter_pounce_counter_exp` int(11) NOT NULL DEFAULT '0',
  `infected_hunter_pounce_damage_nor` int(11) NOT NULL DEFAULT '0',
  `infected_hunter_pounce_damage_adv` int(11) NOT NULL DEFAULT '0',
  `infected_hunter_pounce_damage_exp` int(11) NOT NULL DEFAULT '0',
  `infected_tanksniper_nor` int(11) NOT NULL DEFAULT '0',
  `infected_tanksniper_adv` int(11) NOT NULL DEFAULT '0',
  `infected_tanksniper_exp` int(11) NOT NULL DEFAULT '0',
  `caralarm_nor` int(11) NOT NULL DEFAULT '0',
  `caralarm_adv` int(11) NOT NULL DEFAULT '0',
  `caralarm_exp` int(11) NOT NULL DEFAULT '0',
  `jockey_rides_nor` int(11) NOT NULL DEFAULT '0',
  `jockey_rides_adv` int(11) NOT NULL DEFAULT '0',
  `jockey_rides_exp` int(11) NOT NULL DEFAULT '0',
  `charger_impacts_nor` int(11) NOT NULL DEFAULT '0',
  `charger_impacts_adv` int(11) NOT NULL DEFAULT '0',
  `charger_impacts_exp` int(11) NOT NULL DEFAULT '0',
  `mutation` varchar(64) NOT NULL DEFAULT '',
  PRIMARY KEY (`name`,`gamemode`,`mutation`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `players`;
CREATE TABLE `players` (
  `steamid` varchar(255) CHARACTER SET utf8mb4 NOT NULL,
  `name` tinyblob NOT NULL,
  `lastontime` varchar(255) CHARACTER SET utf8mb4 NOT NULL,
  `lastgamemode` int(1) NOT NULL DEFAULT '0',
  `ip` varchar(16) CHARACTER SET utf8mb4 NOT NULL DEFAULT '0.0.0.0',
  `playtime` int(11) NOT NULL DEFAULT '0' COMMENT 'Playtime in Coop',
  `playtime_versus` int(11) NOT NULL DEFAULT '0' COMMENT 'Playtime in Versus',
  `playtime_realism` int(11) NOT NULL DEFAULT '0' COMMENT 'Playtime in Realism',
  `playtime_survival` int(11) NOT NULL DEFAULT '0' COMMENT 'Playtime in Survival',
  `playtime_scavenge` int(11) NOT NULL DEFAULT '0' COMMENT 'Playtime in Scavenge',
  `playtime_realismversus` int(11) NOT NULL DEFAULT '0' COMMENT 'Playtime in Realism',
  `points` int(11) NOT NULL DEFAULT '0',
  `points_realism` int(11) NOT NULL DEFAULT '0',
  `points_survival` int(11) NOT NULL DEFAULT '0',
  `points_survivors` int(11) NOT NULL DEFAULT '0',
  `points_infected` int(11) NOT NULL DEFAULT '0',
  `points_scavenge_survivors` int(11) NOT NULL DEFAULT '0',
  `points_scavenge_infected` int(11) NOT NULL DEFAULT '0',
  `points_realism_survivors` int(11) NOT NULL DEFAULT '0',
  `points_realism_infected` int(11) NOT NULL DEFAULT '0',
  `kills` int(11) NOT NULL DEFAULT '0',
  `melee_kills` int(11) NOT NULL DEFAULT '0',
  `headshots` int(11) NOT NULL DEFAULT '0',
  `kill_infected` int(11) NOT NULL DEFAULT '0',
  `kill_hunter` int(11) NOT NULL DEFAULT '0',
  `kill_smoker` int(11) NOT NULL DEFAULT '0',
  `kill_boomer` int(11) NOT NULL DEFAULT '0',
  `kill_spitter` int(11) NOT NULL DEFAULT '0',
  `kill_jockey` int(11) NOT NULL DEFAULT '0',
  `kill_charger` int(11) NOT NULL DEFAULT '0',
  `versus_kills_survivors` int(11) NOT NULL DEFAULT '0',
  `scavenge_kills_survivors` int(11) NOT NULL DEFAULT '0',
  `realism_kills_survivors` int(11) NOT NULL DEFAULT '0',
  `jockey_rides` int(11) NOT NULL DEFAULT '0',
  `charger_impacts` int(11) NOT NULL DEFAULT '0',
  `award_pills` int(11) NOT NULL DEFAULT '0',
  `award_adrenaline` int(11) NOT NULL DEFAULT '0',
  `award_fincap` int(11) NOT NULL DEFAULT '0' COMMENT 'Friendly incapacitation',
  `award_medkit` int(11) NOT NULL DEFAULT '0',
  `award_defib` int(11) NOT NULL DEFAULT '0',
  `award_charger` int(11) NOT NULL DEFAULT '0',
  `award_jockey` int(11) NOT NULL DEFAULT '0',
  `award_hunter` int(11) NOT NULL DEFAULT '0',
  `award_smoker` int(11) NOT NULL DEFAULT '0',
  `award_protect` int(11) NOT NULL DEFAULT '0',
  `award_revive` int(11) NOT NULL DEFAULT '0',
  `award_rescue` int(11) NOT NULL DEFAULT '0',
  `award_campaigns` int(11) NOT NULL DEFAULT '0',
  `award_tankkill` int(11) NOT NULL DEFAULT '0',
  `award_tankkillnodeaths` int(11) NOT NULL DEFAULT '0',
  `award_allinsafehouse` int(11) NOT NULL DEFAULT '0',
  `award_friendlyfire` int(11) NOT NULL DEFAULT '0',
  `award_teamkill` int(11) NOT NULL DEFAULT '0',
  `award_left4dead` int(11) NOT NULL DEFAULT '0',
  `award_letinsafehouse` int(11) NOT NULL DEFAULT '0',
  `award_witchdisturb` int(11) NOT NULL DEFAULT '0',
  `award_pounce_perfect` int(11) NOT NULL DEFAULT '0',
  `award_pounce_nice` int(11) NOT NULL DEFAULT '0',
  `award_perfect_blindness` int(11) NOT NULL DEFAULT '0',
  `award_infected_win` int(11) NOT NULL DEFAULT '0',
  `award_scavenge_infected_win` int(11) NOT NULL DEFAULT '0',
  `award_bulldozer` int(11) NOT NULL DEFAULT '0',
  `award_survivor_down` int(11) NOT NULL DEFAULT '0',
  `award_ledgegrab` int(11) NOT NULL DEFAULT '0',
  `award_gascans_poured` int(11) NOT NULL DEFAULT '0',
  `award_upgrades_added` int(11) NOT NULL DEFAULT '0',
  `award_matador` int(11) NOT NULL DEFAULT '0',
  `award_witchcrowned` int(11) NOT NULL DEFAULT '0',
  `award_scatteringram` int(11) NOT NULL DEFAULT '0',
  `infected_spawn_1` int(11) NOT NULL DEFAULT '0' COMMENT 'Spawned as Smoker',
  `infected_spawn_2` int(11) NOT NULL DEFAULT '0' COMMENT 'Spawned as Boomer',
  `infected_spawn_3` int(11) NOT NULL DEFAULT '0' COMMENT 'Spawned as Hunter',
  `infected_spawn_4` int(11) NOT NULL DEFAULT '0' COMMENT 'Spawned as Spitter',
  `infected_spawn_5` int(11) NOT NULL DEFAULT '0' COMMENT 'Spawned as Jockey',
  `infected_spawn_6` int(11) NOT NULL DEFAULT '0' COMMENT 'Spawned as Charger',
  `infected_spawn_8` int(11) NOT NULL DEFAULT '0' COMMENT 'Spawned as Tank',
  `infected_boomer_vomits` int(11) NOT NULL DEFAULT '0',
  `infected_boomer_blinded` int(11) NOT NULL DEFAULT '0',
  `infected_hunter_pounce_counter` int(11) NOT NULL DEFAULT '0',
  `infected_hunter_pounce_dmg` int(11) NOT NULL DEFAULT '0',
  `infected_smoker_damage` int(11) NOT NULL DEFAULT '0',
  `infected_jockey_damage` int(11) NOT NULL DEFAULT '0',
  `infected_jockey_ridetime` double NOT NULL DEFAULT '0',
  `infected_charger_damage` int(11) NOT NULL DEFAULT '0',
  `infected_tank_damage` int(11) NOT NULL DEFAULT '0',
  `infected_tanksniper` int(11) NOT NULL DEFAULT '0',
  `infected_spitter_damage` int(11) NOT NULL DEFAULT '0',
  `mutations_kills_survivors` int(11) NOT NULL DEFAULT '0',
  `playtime_mutations` int(11) NOT NULL DEFAULT '0',
  `points_mutations` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`steamid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `RPG`;
CREATE TABLE `RPG` (
  `steamid` varchar(255) CHARACTER SET utf8mb4 NOT NULL,
  `MELEE_DATA` int(10) NOT NULL,
  `BLOOD_DATA` int(10) NOT NULL,
  `HAT` int(10) NOT NULL DEFAULT '0',
  `GLOW` int(10) NOT NULL DEFAULT '0',
  `SKIN` int(10) NOT NULL DEFAULT '0',
  `RECOIL` int(10) NOT NULL DEFAULT '0',
  `CHATTAG` varchar(128) CHARACTER SET utf8mb4 DEFAULT NULL,
  PRIMARY KEY (`steamid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `server_settings`;
CREATE TABLE `server_settings` (
  `sname` varchar(64) CHARACTER SET utf8mb4 NOT NULL,
  `svalue` blob,
  PRIMARY KEY (`sname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `settings`;
CREATE TABLE `settings` (
  `steamid` varchar(255) CHARACTER SET utf8mb4 NOT NULL,
  `mute` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`steamid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `timedmaps`;
CREATE TABLE `timedmaps` (
  `map` varchar(255) CHARACTER SET utf8mb4 NOT NULL,
  `gamemode` int(1) unsigned NOT NULL,
  `difficulty` int(1) unsigned NOT NULL,
  `steamid` varchar(255) CHARACTER SET utf8mb4 NOT NULL,
  `plays` int(11) NOT NULL,
  `time` double NOT NULL,
  `players` int(2) NOT NULL,
  `modified` datetime NOT NULL,
  `created` date NOT NULL,
  `mutation` varchar(64) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `mode` int(1) unsigned NOT NULL DEFAULT '0',
  `sinum` int(1) unsigned NOT NULL DEFAULT '0',
  `sitime` int(1) unsigned NOT NULL DEFAULT '0',
  `usebuy` int(1) unsigned NOT NULL DEFAULT '0',
  `anneversion` varchar(64) CHARACTER SET utf8mb4 NOT NULL DEFAULT 'None',
  PRIMARY KEY (`map`,`gamemode`,`difficulty`,`steamid`,`time`,`mutation`,`mode`,`sinum`,`sitime`,`usebuy`,`anneversion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE DATABASE `sourcebans` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_bin */;
USE `sourcebans`;

DROP TABLE IF EXISTS `sb_admins`;
CREATE TABLE `sb_admins` (
  `aid` int(6) NOT NULL AUTO_INCREMENT,
  `user` varchar(64) NOT NULL,
  `authid` varchar(64) NOT NULL DEFAULT '',
  `password` varchar(128) NOT NULL,
  `gid` int(6) NOT NULL,
  `email` varchar(128) NOT NULL,
  `validate` varchar(128) DEFAULT NULL,
  `extraflags` int(10) NOT NULL,
  `immunity` int(10) NOT NULL DEFAULT '0',
  `srv_group` varchar(128) DEFAULT NULL,
  `srv_flags` varchar(64) DEFAULT NULL,
  `srv_password` varchar(128) DEFAULT NULL,
  `lastvisit` int(11) DEFAULT NULL,
  PRIMARY KEY (`aid`),
  UNIQUE KEY `user` (`user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `sb_admins_servers_groups`;
CREATE TABLE `sb_admins_servers_groups` (
  `admin_id` int(10) NOT NULL,
  `group_id` int(10) NOT NULL,
  `srv_group_id` int(10) NOT NULL,
  `server_id` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `sb_banlog`;
CREATE TABLE `sb_banlog` (
  `sid` int(6) NOT NULL,
  `time` int(11) NOT NULL,
  `name` varchar(128) NOT NULL,
  `bid` int(6) NOT NULL,
  PRIMARY KEY (`sid`,`time`,`bid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `sb_bans`;
CREATE TABLE `sb_bans` (
  `bid` int(6) NOT NULL AUTO_INCREMENT,
  `ip` varchar(32) DEFAULT NULL,
  `authid` varchar(64) NOT NULL DEFAULT '',
  `name` varchar(128) NOT NULL DEFAULT 'unnamed',
  `created` int(11) NOT NULL DEFAULT '0',
  `ends` int(11) NOT NULL DEFAULT '0',
  `length` int(10) NOT NULL DEFAULT '0',
  `reason` text NOT NULL,
  `aid` int(6) NOT NULL DEFAULT '0',
  `adminIp` varchar(32) NOT NULL DEFAULT '',
  `sid` int(6) NOT NULL DEFAULT '0',
  `country` varchar(4) DEFAULT NULL,
  `RemovedBy` int(8) DEFAULT NULL,
  `RemoveType` varchar(3) DEFAULT NULL,
  `RemovedOn` int(10) DEFAULT NULL,
  `type` tinyint(4) NOT NULL DEFAULT '0',
  `ureason` text,
  PRIMARY KEY (`bid`),
  KEY `sid` (`sid`),
  KEY `type_authid` (`type`,`authid`),
  KEY `type_ip` (`type`,`ip`),
  FULLTEXT KEY `reason` (`reason`),
  FULLTEXT KEY `authid_2` (`authid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `sb_comments`;
CREATE TABLE `sb_comments` (
  `cid` int(6) NOT NULL AUTO_INCREMENT,
  `bid` int(6) NOT NULL,
  `type` varchar(1) NOT NULL,
  `aid` int(6) NOT NULL,
  `commenttxt` longtext NOT NULL,
  `added` int(11) NOT NULL,
  `editaid` int(6) DEFAULT NULL,
  `edittime` int(11) DEFAULT NULL,
  KEY `cid` (`cid`),
  FULLTEXT KEY `commenttxt` (`commenttxt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `sb_comms`;
CREATE TABLE `sb_comms` (
  `bid` int(6) NOT NULL AUTO_INCREMENT,
  `authid` varchar(64) NOT NULL,
  `name` varchar(128) NOT NULL DEFAULT 'unnamed',
  `created` int(11) NOT NULL DEFAULT '0',
  `ends` int(11) NOT NULL DEFAULT '0',
  `length` int(10) NOT NULL DEFAULT '0',
  `reason` text NOT NULL,
  `aid` int(6) NOT NULL DEFAULT '0',
  `adminIp` varchar(32) NOT NULL DEFAULT '',
  `sid` int(6) NOT NULL DEFAULT '0',
  `RemovedBy` int(8) DEFAULT NULL,
  `RemoveType` varchar(3) DEFAULT NULL,
  `RemovedOn` int(11) DEFAULT NULL,
  `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '1 - Mute, 2 - Gag',
  `ureason` text,
  PRIMARY KEY (`bid`),
  KEY `sid` (`sid`),
  KEY `type` (`type`),
  KEY `RemoveType` (`RemoveType`),
  KEY `authid` (`authid`),
  KEY `created` (`created`),
  KEY `aid` (`aid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `sb_demos`;
CREATE TABLE `sb_demos` (
  `demid` int(6) NOT NULL,
  `demtype` varchar(1) NOT NULL,
  `filename` varchar(128) NOT NULL,
  `origname` varchar(128) NOT NULL,
  PRIMARY KEY (`demid`,`demtype`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `sb_groups`;
CREATE TABLE `sb_groups` (
  `gid` int(6) NOT NULL AUTO_INCREMENT,
  `type` smallint(6) NOT NULL DEFAULT '0',
  `name` varchar(128) NOT NULL DEFAULT 'unnamed',
  `flags` int(10) NOT NULL,
  PRIMARY KEY (`gid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `sb_log`;
CREATE TABLE `sb_log` (
  `lid` int(11) NOT NULL AUTO_INCREMENT,
  `type` enum('m','w','e') NOT NULL,
  `title` varchar(512) NOT NULL,
  `message` text NOT NULL,
  `function` text NOT NULL,
  `query` text NOT NULL,
  `aid` int(11) NOT NULL,
  `host` text NOT NULL,
  `created` int(11) NOT NULL,
  PRIMARY KEY (`lid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `sb_login_tokens`;
CREATE TABLE `sb_login_tokens` (
  `jti` varchar(16) NOT NULL,
  `secret` varchar(64) NOT NULL,
  `lastAccessed` int(11) NOT NULL,
  PRIMARY KEY (`jti`),
  UNIQUE KEY `secret` (`secret`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `sb_mods`;
CREATE TABLE `sb_mods` (
  `mid` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `icon` varchar(128) NOT NULL,
  `modfolder` varchar(64) NOT NULL,
  `steam_universe` tinyint(4) NOT NULL DEFAULT '0',
  `enabled` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`mid`),
  UNIQUE KEY `modfolder` (`modfolder`),
  UNIQUE KEY `name` (`name`),
  KEY `steam_universe` (`steam_universe`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `sb_overrides`;
CREATE TABLE `sb_overrides` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` enum('command','group') NOT NULL,
  `name` varchar(32) NOT NULL,
  `flags` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `type` (`type`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `sb_protests`;
CREATE TABLE `sb_protests` (
  `pid` int(6) NOT NULL AUTO_INCREMENT,
  `bid` int(6) NOT NULL,
  `datesubmitted` int(11) NOT NULL,
  `reason` text NOT NULL,
  `email` varchar(128) NOT NULL,
  `archiv` tinyint(1) DEFAULT '0',
  `archivedby` int(11) DEFAULT NULL,
  `pip` varchar(64) NOT NULL,
  PRIMARY KEY (`pid`),
  KEY `bid` (`bid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `sb_servers`;
CREATE TABLE `sb_servers` (
  `sid` int(6) NOT NULL AUTO_INCREMENT,
  `ip` varchar(64) NOT NULL,
  `port` int(5) NOT NULL,
  `rcon` varchar(64) NOT NULL,
  `modid` int(10) NOT NULL,
  `enabled` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`sid`),
  UNIQUE KEY `ip` (`ip`,`port`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `sb_servers_groups`;
CREATE TABLE `sb_servers_groups` (
  `server_id` int(10) NOT NULL,
  `group_id` int(10) NOT NULL,
  PRIMARY KEY (`server_id`,`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `sb_settings`;
CREATE TABLE `sb_settings` (
  `setting` varchar(128) NOT NULL,
  `value` text NOT NULL,
  UNIQUE KEY `setting` (`setting`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `sb_srvgroups`;
CREATE TABLE `sb_srvgroups` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `flags` varchar(30) NOT NULL,
  `immunity` int(10) unsigned NOT NULL,
  `name` varchar(120) NOT NULL,
  `groups_immune` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `sb_srvgroups_overrides`;
CREATE TABLE `sb_srvgroups_overrides` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` smallint(5) unsigned NOT NULL,
  `type` enum('command','group') NOT NULL,
  `name` varchar(32) NOT NULL,
  `access` enum('allow','deny') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_id` (`group_id`,`type`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `sb_submissions`;
CREATE TABLE `sb_submissions` (
  `subid` int(6) NOT NULL AUTO_INCREMENT,
  `submitted` int(11) NOT NULL,
  `ModID` int(6) NOT NULL,
  `SteamId` varchar(64) NOT NULL DEFAULT 'unnamed',
  `name` varchar(128) NOT NULL,
  `email` varchar(128) NOT NULL,
  `reason` text NOT NULL,
  `ip` varchar(64) NOT NULL,
  `subname` varchar(128) DEFAULT NULL,
  `sip` varchar(64) DEFAULT NULL,
  `archiv` tinyint(1) DEFAULT '0',
  `archivedby` int(11) DEFAULT NULL,
  `server` tinyint(3) DEFAULT NULL,
  PRIMARY KEY (`subid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE DATABASE `wgcloud` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci */;
USE `wgcloud`;

DROP TABLE IF EXISTS `ACCOUNT_INFO`;
CREATE TABLE `ACCOUNT_INFO` (
  `ID` char(32) NOT NULL,
  `ACCOUNT` varchar(50) DEFAULT NULL,
  `EMAIL` varchar(50) DEFAULT NULL,
  `PASSWD` varchar(50) DEFAULT NULL,
  `ACCOUNT_KEY` varchar(50) DEFAULT NULL,
  `REMARK` varchar(50) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `APP_INFO`;
CREATE TABLE `APP_INFO` (
  `ID` char(32) NOT NULL,
  `HOST_NAME` char(50) DEFAULT NULL,
  `APP_PID` char(200) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  `APP_NAME` varchar(50) DEFAULT NULL,
  `CPU_PER` double(8,2) DEFAULT NULL,
  `MEM_PER` double(10,2) DEFAULT NULL,
  `APP_TYPE` char(1) DEFAULT NULL,
  `STATE` char(1) DEFAULT NULL,
  `ACTIVE` char(1) DEFAULT NULL,
  `READ_BYTES` char(20) DEFAULT NULL,
  `WRITES_BYTES` char(20) DEFAULT NULL,
  `THREADS_NUM` varchar(20) DEFAULT NULL,
  `GATHER_PID` varchar(20) DEFAULT NULL,
  `GROUP_ID` varchar(32) DEFAULT NULL,
  `APP_TIMES` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `APP_STATE`;
CREATE TABLE `APP_STATE` (
  `ID` char(32) NOT NULL,
  `APP_INFO_ID` char(32) DEFAULT NULL,
  `CPU_PER` double(8,2) DEFAULT NULL,
  `MEM_PER` double(10,2) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  `THREADS_NUM` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `APP_STAT_INDEX` (`APP_INFO_ID`,`CREATE_TIME`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `CPU_STATE`;
CREATE TABLE `CPU_STATE` (
  `ID` char(32) NOT NULL,
  `HOST_NAME` char(50) DEFAULT NULL,
  `USER_PER` char(30) DEFAULT NULL,
  `SYS` double(8,2) DEFAULT NULL,
  `IDLE` double(8,2) DEFAULT NULL,
  `IOWAIT` double(8,2) DEFAULT NULL,
  `IRQ` char(30) DEFAULT NULL,
  `SOFT` char(30) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `CPU_ACC_HOST_INDEX` (`HOST_NAME`,`CREATE_TIME`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `CPU_TEMPERATURES`;
CREATE TABLE `CPU_TEMPERATURES` (
  `ID` char(32) NOT NULL,
  `HOST_NAME` char(50) DEFAULT NULL,
  `CORE_INDEX` varchar(50) DEFAULT NULL,
  `CRIT` char(10) DEFAULT NULL,
  `INPUT` char(10) DEFAULT NULL,
  `MAX` char(10) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `CUSTOM_INFO`;
CREATE TABLE `CUSTOM_INFO` (
  `ID` char(32) NOT NULL,
  `CUSTOM_NAME` varchar(50) DEFAULT NULL,
  `CUSTOM_SHELL` varchar(255) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `HOST_NAME` char(50) DEFAULT NULL,
  `ACTIVE` char(1) DEFAULT NULL,
  `STATE` char(1) DEFAULT NULL,
  `RESULT_EXP` varchar(100) DEFAULT NULL,
  `GROUP_ID` varchar(32) DEFAULT NULL,
  `CUSTOM_VALUE` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `CUSTOM_STATE`;
CREATE TABLE `CUSTOM_STATE` (
  `ID` char(32) NOT NULL,
  `CUSTOM_INFO_ID` char(32) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  `CUSTOM_VALUE` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `CUSTOM_STAT_INDEX` (`CUSTOM_INFO_ID`,`CREATE_TIME`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `DB_INFO`;
CREATE TABLE `DB_INFO` (
  `ID` char(32) NOT NULL,
  `DBTYPE` char(32) DEFAULT NULL,
  `USER_NAME` varchar(50) DEFAULT NULL,
  `PASSWD` varchar(50) DEFAULT NULL,
  `DBURL` varchar(500) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  `DB_STATE` char(1) DEFAULT NULL,
  `ALIAS_NAME` varchar(50) DEFAULT NULL,
  `ACCOUNT` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `DB_TABLE`;
CREATE TABLE `DB_TABLE` (
  `ID` char(32) NOT NULL,
  `TABLE_NAME` varchar(50) DEFAULT NULL,
  `WHERE_VAL` varchar(2000) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  `REMARK` varchar(50) DEFAULT NULL,
  `TABLE_COUNT` bigint(20) DEFAULT NULL,
  `DBINFO_ID` char(32) DEFAULT NULL,
  `ACTIVE` char(1) DEFAULT NULL,
  `STATE` varchar(1) DEFAULT NULL,
  `RESULT_EXP` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `DB_TABLE_COUNT`;
CREATE TABLE `DB_TABLE_COUNT` (
  `ID` char(32) NOT NULL,
  `DB_TABLE_ID` char(32) DEFAULT NULL,
  `TABLE_COUNT` bigint(20) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `DBTABLE_ID_CREATE_TIME` (`DB_TABLE_ID`,`CREATE_TIME`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `DCE_INFO`;
CREATE TABLE `DCE_INFO` (
  `ID` char(32) NOT NULL,
  `HOST_NAME` char(50) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `ACTIVE` char(1) DEFAULT NULL,
  `RES_TIMES` int(11) DEFAULT NULL,
  `REMARK` char(50) DEFAULT NULL,
  `GROUP_ID` varchar(32) DEFAULT NULL,
  `ACCOUNT` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `DCE_INFO_HOSTNAME_INDEX` (`HOST_NAME`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `DCE_STATE`;
CREATE TABLE `DCE_STATE` (
  `ID` char(32) NOT NULL,
  `DCE_ID` char(32) DEFAULT NULL,
  `RES_TIMES` int(11) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `DCE_STATE_DCEID_INDEX` (`DCE_ID`,`CREATE_TIME`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `DESK_IO`;
CREATE TABLE `DESK_IO` (
  `ID` char(32) NOT NULL,
  `FILE_STSTEM` varchar(200) DEFAULT NULL,
  `READ_COUNT` char(20) DEFAULT NULL,
  `WRITE_OUNT` char(20) DEFAULT NULL,
  `READ_BYTES` char(20) DEFAULT NULL,
  `WRITE_BYTES` char(20) DEFAULT NULL,
  `READ_TIME` char(20) DEFAULT NULL,
  `WRITE_TIME` char(20) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  `HOST_NAME` char(50) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `DISO_IO_HOST_INDEX` (`HOST_NAME`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `DISK_SMART`;
CREATE TABLE `DISK_SMART` (
  `ID` char(32) COLLATE utf8_bin NOT NULL,
  `HOST_NAME` char(50) COLLATE utf8_bin DEFAULT NULL,
  `FILE_STSTEM` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `DISK_STATE` char(50) COLLATE utf8_bin DEFAULT NULL,
  `POWER_HOURS` char(50) COLLATE utf8_bin DEFAULT NULL,
  `POWER_COUNT` char(50) COLLATE utf8_bin DEFAULT NULL,
  `TEMPERATURE` char(50) COLLATE utf8_bin DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


DROP TABLE IF EXISTS `DISK_STATE`;
CREATE TABLE `DISK_STATE` (
  `ID` char(32) NOT NULL,
  `HOST_NAME` char(50) DEFAULT NULL,
  `FILE_STSTEM` char(200) DEFAULT NULL,
  `DISK_SIZE` char(30) DEFAULT NULL,
  `USED` char(30) DEFAULT NULL,
  `AVAIL` char(30) DEFAULT NULL,
  `USE_PER` char(10) DEFAULT NULL,
  `DATE_STR` char(30) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `DOCKER_INFO`;
CREATE TABLE `DOCKER_INFO` (
  `ID` char(32) NOT NULL,
  `HOST_NAME` char(50) DEFAULT NULL,
  `DOCKER_ID` char(100) DEFAULT NULL,
  `DOCKER_NAME` char(100) DEFAULT NULL,
  `DOCKER_STATE` varchar(50) DEFAULT NULL,
  `MEM_PER` double(8,0) DEFAULT NULL,
  `STATE` char(1) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  `USER_TIME` char(20) DEFAULT NULL,
  `ACTIVE` char(1) DEFAULT NULL,
  `APP_TYPE` char(1) DEFAULT NULL,
  `DOCKER_IMAGE` varchar(100) DEFAULT NULL,
  `DOCKER_PORT` varchar(200) DEFAULT NULL,
  `DOCKER_COMMAND` varchar(500) DEFAULT NULL,
  `DOCKER_CREATED` varchar(50) DEFAULT NULL,
  `DOCKER_SIZE` varchar(20) DEFAULT NULL,
  `DOCKER_STATUS` varchar(100) DEFAULT NULL,
  `GATHER_DOCKER_NAMES` varchar(100) DEFAULT NULL,
  `GROUP_ID` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `DOCKER_STATE`;
CREATE TABLE `DOCKER_STATE` (
  `ID` char(32) NOT NULL,
  `DOCKER_INFO_ID` char(32) DEFAULT NULL,
  `CPU_PER` double(8,0) DEFAULT NULL,
  `MEM_PER` double(8,0) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `DOCKER_STATE_INDEX` (`DOCKER_INFO_ID`,`CREATE_TIME`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `EQUIPMENT`;
CREATE TABLE `EQUIPMENT` (
  `ID` char(32) NOT NULL,
  `NAME` char(50) DEFAULT NULL,
  `XINGHAO` char(50) DEFAULT NULL,
  `PERSON` char(50) DEFAULT NULL,
  `DEPT` char(50) DEFAULT NULL,
  `CODE` char(50) DEFAULT NULL,
  `PRICE` double(10,2) DEFAULT NULL,
  `GONGYINGSHANG` char(50) DEFAULT NULL,
  `CAIGOU_DATE` char(50) DEFAULT NULL,
  `REMARK` varchar(255) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  `ACCOUNT` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `FILE_SAFE`;
CREATE TABLE `FILE_SAFE` (
  `ID` char(32) NOT NULL,
  `HOST_NAME` char(50) DEFAULT NULL,
  `FILE_NAME` varchar(50) DEFAULT NULL,
  `STATE` char(1) DEFAULT NULL,
  `FILE_PATH` varchar(255) DEFAULT NULL,
  `ACTIVE` char(1) DEFAULT NULL,
  `FILE_SIGN` char(50) DEFAULT NULL,
  `FILE_MODTIME` char(50) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `FILE_WARN`;
CREATE TABLE `FILE_WARN` (
  `ID` char(32) NOT NULL,
  `FILE_PATH` varchar(255) DEFAULT NULL,
  `FILE_SIZE` char(32) DEFAULT NULL,
  `WARN_CHARS` varchar(500) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  `WARN_ROWS` char(20) DEFAULT NULL,
  `HOST_NAME` char(50) DEFAULT NULL,
  `REMARK` varchar(255) DEFAULT NULL,
  `ACTIVE` char(1) DEFAULT NULL,
  `FILE_NAME_PREFIX` varchar(50) DEFAULT NULL,
  `FILE_TYPE` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `FILE_WARN_STATE`;
CREATE TABLE `FILE_WARN_STATE` (
  `ID` char(32) NOT NULL,
  `WAR_CONTENT` text,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  `FILE_WARN_ID` char(32) DEFAULT NULL,
  `FILE_PATH` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `FILE_WARN_ID_INDEX` (`FILE_WARN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `HEATH_MONITOR`;
CREATE TABLE `HEATH_MONITOR` (
  `ID` char(32) NOT NULL,
  `APP_NAME` char(50) DEFAULT NULL,
  `HEATH_URL` varchar(255) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  `HEATH_STATUS` char(10) DEFAULT NULL,
  `RES_TIMES` int(11) DEFAULT NULL,
  `ACTIVE` char(1) DEFAULT NULL,
  `RES_KEYWORD` varchar(255) DEFAULT NULL,
  `METHOD` char(5) DEFAULT NULL,
  `POST_STR` varchar(2000) DEFAULT NULL,
  `RES_NO_KEYWORD` varchar(255) DEFAULT NULL,
  `HEADER_JSON` varchar(1500) DEFAULT NULL,
  `ACCOUNT` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `HEATH_STATE`;
CREATE TABLE `HEATH_STATE` (
  `ID` char(32) NOT NULL,
  `HEATH_ID` char(32) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  `RES_TIMES` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `HEATH_ID_CREATE_TIME` (`HEATH_ID`,`CREATE_TIME`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `HOST_DISK_PER`;
CREATE TABLE `HOST_DISK_PER` (
  `ID` char(32) NOT NULL,
  `HOST_NAME` char(50) DEFAULT NULL,
  `DISK_SUM_PER` double DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `HOST_GROUP`;
CREATE TABLE `HOST_GROUP` (
  `ID` char(32) NOT NULL,
  `GROUP_NAME` char(30) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `REMARK` varchar(255) DEFAULT NULL,
  `GROUP_TYPE` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `INTRUSION_INFO`;
CREATE TABLE `INTRUSION_INFO` (
  `ID` char(32) NOT NULL,
  `HOST_NAME` char(30) DEFAULT NULL,
  `LSMOD` text,
  `PASSWD_INFO` varchar(100) DEFAULT NULL,
  `CRONTAB` text,
  `PROMISC` varchar(100) DEFAULT NULL,
  `RPCINFO` text,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `LOG_INFO`;
CREATE TABLE `LOG_INFO` (
  `ID` char(32) NOT NULL,
  `HOST_NAME` char(200) DEFAULT NULL,
  `INFO_CONTENT` text,
  `STATE` char(1) DEFAULT NULL,
  `CREATE_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `MAIL_SET`;
CREATE TABLE `MAIL_SET` (
  `ID` char(32) COLLATE utf8_unicode_ci NOT NULL,
  `SEND_MAIL` char(60) COLLATE utf8_unicode_ci DEFAULT NULL,
  `FROM_MAIL_NAME` char(60) COLLATE utf8_unicode_ci DEFAULT NULL,
  `FROM_PWD` char(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `SMTP_HOST` char(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `SMTP_PORT` char(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `SMTP_SSL` char(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `TO_MAIL` varchar(300) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CPU_PER` char(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  `MEM_PER` char(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `HEATH_PER` char(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `MEM_STATE`;
CREATE TABLE `MEM_STATE` (
  `ID` char(32) NOT NULL,
  `HOST_NAME` char(50) DEFAULT NULL,
  `TOTAL` char(30) DEFAULT NULL,
  `USED` char(30) DEFAULT NULL,
  `FREE` char(30) DEFAULT NULL,
  `USE_PER` double(8,2) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `MEM_ACC_HOST_INDEX` (`HOST_NAME`,`CREATE_TIME`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `NETIO_STATE`;
CREATE TABLE `NETIO_STATE` (
  `ID` char(32) NOT NULL,
  `HOST_NAME` char(50) DEFAULT NULL,
  `RXPCK` char(30) DEFAULT NULL,
  `TXPCK` char(30) DEFAULT NULL,
  `RXBYT` char(30) DEFAULT NULL,
  `TXBYT` char(30) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  `DROPIN` char(30) DEFAULT NULL,
  `DROPOUT` char(30) DEFAULT NULL,
  `NET_CONNECTIONS` char(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `NETIO_ACC_HOST_INDEX` (`HOST_NAME`,`CREATE_TIME`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `PORT_INFO`;
CREATE TABLE `PORT_INFO` (
  `ID` char(32) NOT NULL,
  `PORT` char(30) DEFAULT NULL,
  `PORT_NAME` varchar(30) DEFAULT NULL,
  `STATE` char(1) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  `HOST_NAME` char(50) DEFAULT NULL,
  `ACTIVE` char(1) DEFAULT NULL,
  `TELNET_IP` varchar(300) DEFAULT NULL,
  `GROUP_ID` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `PORT_HOST_NAME_INDEX` (`HOST_NAME`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `SHELL_INFO`;
CREATE TABLE `SHELL_INFO` (
  `ID` char(32) NOT NULL,
  `SHELL` varchar(500) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  `STATE` char(1) DEFAULT NULL,
  `SHELL_NAME` varchar(50) DEFAULT NULL,
  `SHELL_TYPE` varchar(5) DEFAULT NULL,
  `SHELL_TIME` varchar(20) DEFAULT NULL,
  `SHELL_DAY` varchar(5) DEFAULT NULL,
  `ACCOUNT` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `SHELL_STATE`;
CREATE TABLE `SHELL_STATE` (
  `ID` char(32) NOT NULL,
  `SHELL_ID` char(32) DEFAULT NULL,
  `HOST_NAME` char(50) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  `STATE` varchar(500) DEFAULT NULL,
  `SHELL` varchar(500) DEFAULT NULL,
  `SHELL_TIME` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `SHELL_STATE_INDEX2` (`SHELL_ID`) USING BTREE,
  KEY `SHELL_STATE_INDEX1` (`HOST_NAME`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `SNMP_INFO`;
CREATE TABLE `SNMP_INFO` (
  `ID` char(32) NOT NULL,
  `HOST_NAME` varchar(50) DEFAULT NULL,
  `BYTES_RECV` varchar(30) DEFAULT NULL,
  `BYTES_SENT` varchar(30) DEFAULT NULL,
  `RECV_AVG` varchar(20) DEFAULT NULL,
  `SENT_AVG` varchar(20) DEFAULT NULL,
  `STATE` char(1) DEFAULT NULL,
  `ACTIVE` char(1) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  `SNMP_UNIT` varchar(20) DEFAULT NULL,
  `REMARK` varchar(50) DEFAULT NULL,
  `RECV_OID` varchar(2000) DEFAULT NULL,
  `SENT_OID` varchar(2000) DEFAULT NULL,
  `SNMP_COMMUNITY` varchar(50) DEFAULT NULL,
  `SNMP_PORT` varchar(10) DEFAULT NULL,
  `SNMP_VERSION` varchar(10) DEFAULT NULL,
  `ACCOUNT` varchar(50) DEFAULT NULL,
  `CPU_PER_OID` varchar(100) DEFAULT NULL,
  `MEM_SIZE_OID` varchar(100) DEFAULT NULL,
  `MEM_TOTAL_SIZE_OID` varchar(100) DEFAULT NULL,
  `CPU_PER` varchar(10) DEFAULT NULL,
  `MEM_PER` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `SNMP_STATE`;
CREATE TABLE `SNMP_STATE` (
  `ID` char(32) NOT NULL,
  `SNMP_INFO_ID` char(32) DEFAULT NULL,
  `RECV_AVG` varchar(20) DEFAULT NULL,
  `SENT_AVG` varchar(20) DEFAULT NULL,
  `CPU_PER` varchar(10) DEFAULT NULL,
  `MEM_PER` varchar(10) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `SNMP_ID_CREATE_TIME` (`SNMP_INFO_ID`,`CREATE_TIME`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `SYSTEM_INFO`;
CREATE TABLE `SYSTEM_INFO` (
  `ID` char(32) NOT NULL,
  `HOST_NAME` char(50) DEFAULT NULL,
  `PLATFORM` char(200) DEFAULT NULL,
  `CPU_PER` double(8,2) DEFAULT NULL,
  `MEM_PER` double(8,2) DEFAULT NULL,
  `CPU_CORE_NUM` char(10) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  `CPU_XH` char(150) DEFAULT NULL,
  `STATE` char(1) DEFAULT NULL,
  `BOOT_TIME` bigint(20) DEFAULT NULL,
  `PROCS` char(11) DEFAULT NULL,
  `PLATFORM_VERSION` char(100) DEFAULT NULL,
  `UPTIME` bigint(20) DEFAULT NULL,
  `GROUP_ID` char(32) DEFAULT NULL,
  `REMARK` varchar(100) DEFAULT NULL,
  `TOTAL_MEM` char(50) DEFAULT NULL,
  `SUBMIT_SECONDS` char(10) DEFAULT NULL,
  `AGENT_VER` char(50) DEFAULT NULL,
  `BYTES_RECV` char(20) DEFAULT NULL,
  `BYTES_SENT` char(20) DEFAULT NULL,
  `RXBYT` char(30) DEFAULT NULL,
  `TXBYT` char(30) DEFAULT NULL,
  `WIN_CONSOLE` varchar(255) DEFAULT NULL,
  `HOST_NAME_EXT` varchar(100) DEFAULT NULL,
  `FIVE_LOAD` double(8,2) DEFAULT NULL,
  `FIFTEEN_LOAD` double(8,2) DEFAULT NULL,
  `NET_CONNECTIONS` char(20) DEFAULT NULL,
  `SWAP_MEM_PER` varchar(20) DEFAULT NULL,
  `TOTAL_SWAP_MEM` varchar(50) DEFAULT NULL,
  `ACCOUNT` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `SYS_LOAD_STATE`;
CREATE TABLE `SYS_LOAD_STATE` (
  `ID` char(32) NOT NULL,
  `HOST_NAME` char(50) DEFAULT NULL,
  `ONE_LOAD` double(8,2) DEFAULT NULL,
  `FIVE_LOAD` double(8,2) DEFAULT NULL,
  `FIFTEEN_LOAD` double(8,2) DEFAULT NULL,
  `USERS` char(10) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `LOAD_ACC_HOST_INDEX` (`HOST_NAME`,`CREATE_TIME`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `TCP_STATE`;
CREATE TABLE `TCP_STATE` (
  `ID` char(32) NOT NULL,
  `HOST_NAME` char(30) DEFAULT NULL,
  `ACTIVE` char(30) DEFAULT NULL,
  `PASSIVE` char(30) DEFAULT NULL,
  `RETRANS` char(30) DEFAULT NULL,
  `DATE_STR` char(30) DEFAULT NULL,
  `CREATE_TIME` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `TCP_ACC_HOST_INDEX` (`HOST_NAME`,`CREATE_TIME`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- 2022-12-22 08:33:18
