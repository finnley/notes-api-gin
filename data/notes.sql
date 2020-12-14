/*
 Navicat Premium Data Transfer

 Source Server         : @127.0.0.1
 Source Server Type    : MySQL
 Source Server Version : 50729
 Source Host           : localhost:3306
 Source Schema         : notes

 Target Server Type    : MySQL
 Target Server Version : 50729
 File Encoding         : 65001

 Date: 14/12/2020 07:58:48
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for banner
-- ----------------------------
DROP TABLE IF EXISTS `banner`;
CREATE TABLE `banner` (
  `uuid` char(36) NOT NULL COMMENT '主键ID',
  `name` varchar(50) DEFAULT '' COMMENT 'Banner名称',
  `description` varchar(255) DEFAULT '' COMMENT 'Banner描述',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '软删除时间',
  PRIMARY KEY (`uuid`),
  KEY `idx_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='banner';

-- ----------------------------
-- Table structure for banner_item
-- ----------------------------
DROP TABLE IF EXISTS `banner_item`;
CREATE TABLE `banner_item` (
  `uuid` char(36) NOT NULL COMMENT '主键ID',
  `banner_uuid` char(36) NOT NULL COMMENT 'banner id',
  `image_uuid` char(36) NOT NULL COMMENT 'image id',
  `type` tinyint(4) unsigned NOT NULL DEFAULT '1' COMMENT '跳转类型，可能导向商品，可能导向专题，可能导向其他。0，无导向；1：导向商品;2:导向专题',
  `keyword` varchar(100) NOT NULL COMMENT '执行关键字，根据不同的type含义不同。比如跳转商品，保存的可能是商品ID',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '软删除时间',
  PRIMARY KEY (`uuid`),
  KEY `idx_banner_uuid` (`banner_uuid`),
  KEY `idx_image_uuid` (`image_uuid`),
  KEY `idx_type` (`type`),
  KEY `idx_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='banner子项';

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `uuid` char(36) NOT NULL COMMENT '主键ID',
  `module_uuid` char(36) NOT NULL DEFAULT '' COMMENT '模块ID',
  `category_name` varchar(255) NOT NULL DEFAULT '' COMMENT '分类名称',
  `number` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '数量',
  `sort` tinyint(4) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `state` tinyint(4) unsigned NOT NULL DEFAULT '1' COMMENT '状态，0-关闭 1-启用',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '软删除时间',
  PRIMARY KEY (`uuid`),
  KEY `idx_module_uuid` (`module_uuid`),
  KEY `idx_category_name` (`category_name`),
  KEY `idx_sort` (`sort`),
  KEY `idx_state` (`state`),
  KEY `idx_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='分类';

-- ----------------------------
-- Records of category
-- ----------------------------
BEGIN;
INSERT INTO `category` VALUES ('06606d7e-1a5f-4a2d-835b-99e28e1e9bdc', '306da09a-ba5e-4c4f-becb-27828e0ef9f4', '运维&测试', 0, 0, 1, '2020-12-01 22:14:06', '2020-12-01 22:14:06', NULL);
INSERT INTO `category` VALUES ('6d1e3c67-4bfc-43b4-9525-dd43bc52768f', '306da09a-ba5e-4c4f-becb-27828e0ef9f4', '计算机基础', 0, 0, 1, '2020-12-01 22:15:02', '2020-12-01 22:15:02', NULL);
INSERT INTO `category` VALUES ('78327f8d-13ef-4ca7-a224-f14f40054dea', '306da09a-ba5e-4c4f-becb-27828e0ef9f4', '前沿技术', 0, 0, 1, '2020-12-01 22:14:49', '2020-12-01 22:14:49', NULL);
INSERT INTO `category` VALUES ('854cd419-eca1-44b3-a03e-d543da0d3d78', '306da09a-ba5e-4c4f-becb-27828e0ef9f4', '移动开发', 0, 0, 1, '2020-12-01 22:15:19', '2020-12-01 22:15:19', NULL);
INSERT INTO `category` VALUES ('a1bf65fd-130f-4b9f-9cca-228dd08cba21', '306da09a-ba5e-4c4f-becb-27828e0ef9f4', '后端开发', 0, 0, 1, '2020-12-01 22:15:27', '2020-12-01 22:15:27', NULL);
INSERT INTO `category` VALUES ('e0014f37-d795-4aea-8731-caffc5d8888a', '306da09a-ba5e-4c4f-becb-27828e0ef9f4', '云计算&大数据', 0, 0, 1, '2020-12-01 22:14:28', '2020-12-01 22:14:28', NULL);
INSERT INTO `category` VALUES ('e80e9bc3-fbb5-4db2-a90b-77b25d7b4a41', '306da09a-ba5e-4c4f-becb-27828e0ef9f4', '数据库', 0, 0, 1, '2020-12-01 22:13:30', '2020-12-01 22:13:30', NULL);
INSERT INTO `category` VALUES ('f48aea8d-f6db-4491-93d7-3bbd45768362', '306da09a-ba5e-4c4f-becb-27828e0ef9f4', '前端开发', 0, 0, 1, '2020-12-01 22:15:38', '2020-12-01 22:15:38', NULL);
COMMIT;

-- ----------------------------
-- Table structure for image
-- ----------------------------
DROP TABLE IF EXISTS `image`;
CREATE TABLE `image` (
  `uuid` char(36) NOT NULL COMMENT '主键ID',
  `from` tinyint(4) unsigned NOT NULL DEFAULT '1' COMMENT '1 来自本地，2 来自公网',
  `url` varchar(255) NOT NULL COMMENT '图片路径',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '软删除时间',
  PRIMARY KEY (`uuid`),
  KEY `idx_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='图片总表';

-- ----------------------------
-- Table structure for module
-- ----------------------------
DROP TABLE IF EXISTS `module`;
CREATE TABLE `module` (
  `uuid` char(36) NOT NULL COMMENT '主键ID',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '名称',
  `english_name` varchar(255) NOT NULL DEFAULT '' COMMENT '英文名称',
  `description` varchar(255) NOT NULL DEFAULT '' COMMENT '介绍',
  `english_description` varchar(255) NOT NULL DEFAULT '' COMMENT '英文介绍',
  `icon` varchar(255) NOT NULL DEFAULT '' COMMENT 'image path,icon',
  `cover` varchar(255) NOT NULL DEFAULT '' COMMENT '封面',
  `new_feature_deadline` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新模块截止日期',
  `landing_page_url` varchar(255) NOT NULL DEFAULT '' COMMENT '跳转页面 url',
  `status` tinyint(4) unsigned NOT NULL DEFAULT '1' COMMENT '状态，0-关闭 1-启用',
  `sort` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '排序',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `deleted_at` datetime DEFAULT NULL COMMENT '软删除时间',
  PRIMARY KEY (`uuid`),
  KEY `idx_deleted_at` (`deleted_at`),
  KEY `idx_name` (`name`),
  KEY `idx_status` (`status`),
  KEY `idx_sort` (`sort`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='模块';

-- ----------------------------
-- Records of module
-- ----------------------------
BEGIN;
INSERT INTO `module` VALUES ('0eb56800-aedd-44cb-bdf6-98c6ce233f07', 'music', '', '', '', '', '', 0, '', 1, 0, '2020-12-13 23:47:58', '2020-12-13 23:47:58', NULL);
INSERT INTO `module` VALUES ('19cf3dc1-63fb-4540-bd17-c3c4622c5a0c', 'Hanfu', '', '', '', '', '', 0, '', 0, 0, '2020-12-12 16:42:31', '2020-12-12 17:12:22', '2020-12-12 17:12:23');
INSERT INTO `module` VALUES ('a8cbb6c8-2a3c-4cab-b1e8-78992b8db8c4', 'video', '', '', '', '', '', 1617180151, '', 1, 0, '2020-12-12 16:47:37', '2020-12-12 17:31:30', NULL);
INSERT INTO `module` VALUES ('f99db74f-1ab8-422d-9a28-893d038ff810', 'note', '', '', '', '', '', 0, '', 1, 0, '2020-12-12 16:44:03', '2020-12-12 17:05:27', NULL);
COMMIT;

-- ----------------------------
-- Table structure for notes_article
-- ----------------------------
DROP TABLE IF EXISTS `notes_article`;
CREATE TABLE `notes_article` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tag_id` int(10) unsigned DEFAULT '0' COMMENT '标签ID',
  `title` varchar(100) DEFAULT '' COMMENT '文章标题',
  `desc` varchar(255) DEFAULT '' COMMENT '简述',
  `content` text,
  `created_on` int(11) DEFAULT NULL,
  `created_by` varchar(100) DEFAULT '' COMMENT '创建人',
  `modified_on` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  `modified_by` varchar(255) DEFAULT '' COMMENT '修改人',
  `deleted_on` int(10) unsigned DEFAULT '0',
  `state` tinyint(3) unsigned DEFAULT '1' COMMENT '状态 0为禁用1为启用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COMMENT='文章管理';

-- ----------------------------
-- Records of notes_article
-- ----------------------------
BEGIN;
INSERT INTO `notes_article` VALUES (1, 3, 'test1', 'test-desc', 'test-content', 1606034442, 'test-created', 0, '', 0, 1);
COMMIT;

-- ----------------------------
-- Table structure for notes_auth
-- ----------------------------
DROP TABLE IF EXISTS `notes_auth`;
CREATE TABLE `notes_auth` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT '' COMMENT '账号',
  `password` varchar(50) DEFAULT '' COMMENT '密码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of notes_auth
-- ----------------------------
BEGIN;
INSERT INTO `notes_auth` VALUES (1, 'test', 'test123456');
COMMIT;

-- ----------------------------
-- Table structure for notes_tag
-- ----------------------------
DROP TABLE IF EXISTS `notes_tag`;
CREATE TABLE `notes_tag` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT '' COMMENT '标签名称',
  `created_on` int(10) unsigned DEFAULT '0' COMMENT '创建时间',
  `created_by` varchar(100) DEFAULT '' COMMENT '创建人',
  `modified_on` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  `modified_by` varchar(100) DEFAULT '' COMMENT '修改人',
  `deleted_on` int(10) unsigned DEFAULT '0',
  `state` tinyint(3) unsigned DEFAULT '1' COMMENT '状态 0为禁用、1为启用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COMMENT='标签管理';

-- ----------------------------
-- Records of notes_tag
-- ----------------------------
BEGIN;
INSERT INTO `notes_tag` VALUES (2, '2', 1606018350, 'test', 0, '', 0, 1);
INSERT INTO `notes_tag` VALUES (3, '技术', 1606034432, 'test', 0, '', 0, 1);
COMMIT;

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `created_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) DEFAULT NULL,
  `deleted_at` datetime(3) DEFAULT NULL,
  `name` varchar(20) NOT NULL,
  `telephone` varchar(191) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `telephone` (`telephone`),
  KEY `idx_users_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of users
-- ----------------------------
BEGIN;
INSERT INTO `users` VALUES (1, '2020-11-21 04:37:39.525', '2020-11-21 04:37:39.525', NULL, 'A5X9bXmWYF', '13390703506', '123123');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
