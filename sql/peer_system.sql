/*
 Navicat Premium Data Transfer

 Source Server         : MySQL
 Source Server Type    : MySQL
 Source Server Version : 80033 (8.0.33)
 Source Host           : localhost:3306
 Source Schema         : peer_system

 Target Server Type    : MySQL
 Target Server Version : 80033 (8.0.33)
 File Encoding         : 65001

 Date: 22/12/2023 00:18:17
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for class
-- ----------------------------
DROP TABLE IF EXISTS `class`;
CREATE TABLE `class`  (
  `uuid` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `max_num` int NOT NULL DEFAULT 500,
  `userID` int NOT NULL,
  `num` int NOT NULL DEFAULT 0,
  `accessCode` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`uuid`) USING BTREE,
  UNIQUE INDEX `accessCode`(`accessCode` ASC) USING BTREE,
  INDEX `userID`(`userID` ASC) USING BTREE,
  CONSTRAINT `userID` FOREIGN KEY (`userID`) REFERENCES `user` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for class_source
-- ----------------------------
DROP TABLE IF EXISTS `class_source`;
CREATE TABLE `class_source`  (
  `uuid` int NOT NULL AUTO_INCREMENT,
  `classID` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `attachment` longblob NOT NULL,
  `time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`uuid`) USING BTREE,
  INDEX `classID_source`(`classID` ASC) USING BTREE,
  CONSTRAINT `classID_source` FOREIGN KEY (`classID`) REFERENCES `class` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for correct
-- ----------------------------
DROP TABLE IF EXISTS `correct`;
CREATE TABLE `correct`  (
  `uuid` int NOT NULL AUTO_INCREMENT,
  `homeworkID` int NOT NULL,
  `userID_o` int NOT NULL,
  `userID_c` int NULL DEFAULT NULL,
  `score` double NULL DEFAULT NULL,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `time` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`uuid`) USING BTREE,
  INDEX `homeworkID_correct`(`homeworkID` ASC) USING BTREE,
  INDEX `userID_o`(`userID_o` ASC) USING BTREE,
  INDEX `userID_c`(`userID_c` ASC) USING BTREE,
  CONSTRAINT `homeworkID_correct` FOREIGN KEY (`homeworkID`) REFERENCES `homework` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `userID_c` FOREIGN KEY (`userID_c`) REFERENCES `user` (`uuid`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `userID_o` FOREIGN KEY (`userID_o`) REFERENCES `user` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 107 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for homework
-- ----------------------------
DROP TABLE IF EXISTS `homework`;
CREATE TABLE `homework`  (
  `uuid` int NOT NULL AUTO_INCREMENT,
  `classID` int NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `attachment_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `attachment` longblob NULL,
  `date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `submit_time` datetime NOT NULL,
  `correct_time` datetime NULL DEFAULT NULL COMMENT '批改截至日期',
  `score_method` double NULL DEFAULT NULL,
  `default_score` double NULL DEFAULT 100,
  `corrected` int NOT NULL DEFAULT 0,
  PRIMARY KEY (`uuid`) USING BTREE,
  INDEX `classID_homework`(`classID` ASC) USING BTREE,
  CONSTRAINT `classID_homework` FOREIGN KEY (`classID`) REFERENCES `class` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for information
-- ----------------------------
DROP TABLE IF EXISTS `information`;
CREATE TABLE `information`  (
  `uuid` int NOT NULL AUTO_INCREMENT,
  `userid` int NOT NULL,
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `state` int NOT NULL DEFAULT 0 COMMENT '0表示未读',
  PRIMARY KEY (`uuid`) USING BTREE,
  INDEX `userid_information`(`userid` ASC) USING BTREE,
  CONSTRAINT `userid_information` FOREIGN KEY (`userid`) REFERENCES `user` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for post
-- ----------------------------
DROP TABLE IF EXISTS `post`;
CREATE TABLE `post`  (
  `uuid` int NOT NULL AUTO_INCREMENT,
  `classID` int NOT NULL,
  `userID` int NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `pic` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`uuid`) USING BTREE,
  INDEX `classID_post`(`classID` ASC) USING BTREE,
  INDEX `userID_post`(`userID` ASC) USING BTREE,
  CONSTRAINT `classID_post` FOREIGN KEY (`classID`) REFERENCES `class` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `userID_post` FOREIGN KEY (`userID`) REFERENCES `user` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for reassessment
-- ----------------------------
DROP TABLE IF EXISTS `reassessment`;
CREATE TABLE `reassessment`  (
  `uuid` int NOT NULL AUTO_INCREMENT,
  `submitID` int NOT NULL,
  `teacherID` int NOT NULL,
  `time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `state` int NOT NULL DEFAULT 0,
  `score` int NULL DEFAULT NULL,
  PRIMARY KEY (`uuid`) USING BTREE,
  INDEX `homeworkID_reassessment`(`submitID` ASC) USING BTREE,
  INDEX `userID_reassessment`(`teacherID` ASC) USING BTREE,
  CONSTRAINT `homeworkID_reassessment` FOREIGN KEY (`submitID`) REFERENCES `homework` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `userID_reassessment` FOREIGN KEY (`teacherID`) REFERENCES `user` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for response_post
-- ----------------------------
DROP TABLE IF EXISTS `response_post`;
CREATE TABLE `response_post`  (
  `uuid` int NOT NULL AUTO_INCREMENT,
  `postID` int NOT NULL,
  `userID` int NOT NULL,
  `information` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `pic` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`uuid`) USING BTREE,
  INDEX `postID_re`(`postID` ASC) USING BTREE,
  INDEX `userID_re`(`userID` ASC) USING BTREE,
  CONSTRAINT `postID_re` FOREIGN KEY (`postID`) REFERENCES `post` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `userID_re` FOREIGN KEY (`userID`) REFERENCES `user` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sc
-- ----------------------------
DROP TABLE IF EXISTS `sc`;
CREATE TABLE `sc`  (
  `uuid` int NOT NULL AUTO_INCREMENT,
  `userID` int NOT NULL,
  `classID` int NOT NULL,
  PRIMARY KEY (`uuid`) USING BTREE,
  INDEX `userID_sc`(`userID` ASC) USING BTREE,
  INDEX `classID_sc`(`classID` ASC) USING BTREE,
  CONSTRAINT `classID_sc` FOREIGN KEY (`classID`) REFERENCES `class` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `userID_sc` FOREIGN KEY (`userID`) REFERENCES `user` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for submit
-- ----------------------------
DROP TABLE IF EXISTS `submit`;
CREATE TABLE `submit`  (
  `uuid` int NOT NULL AUTO_INCREMENT,
  `homeworkID` int NOT NULL,
  `userID` int NOT NULL,
  `time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `attachment` longblob NULL,
  `attachment_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `score` double NOT NULL DEFAULT -1,
  `corrected` int NOT NULL DEFAULT 0,
  `integrity` int NOT NULL DEFAULT 1,
  PRIMARY KEY (`uuid`) USING BTREE,
  INDEX `userID_submit`(`userID` ASC) USING BTREE,
  INDEX `homeworkID_submit`(`homeworkID` ASC) USING BTREE,
  CONSTRAINT `homeworkID_submit` FOREIGN KEY (`homeworkID`) REFERENCES `homework` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `userID_submit` FOREIGN KEY (`userID`) REFERENCES `user` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for teacher_recorrect
-- ----------------------------
DROP TABLE IF EXISTS `teacher_recorrect`;
CREATE TABLE `teacher_recorrect`  (
  `uuid` int NOT NULL AUTO_INCREMENT,
  `teacherid` int NOT NULL,
  `submitid` int NOT NULL,
  PRIMARY KEY (`uuid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 33 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `uuid` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `identity` int NULL DEFAULT 3 COMMENT '0 1 2 3',
  `school` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `school_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`uuid`) USING BTREE,
  UNIQUE INDEX `email`(`email` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10013 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
