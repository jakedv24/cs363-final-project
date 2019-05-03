-- Drop existing import tables

DROP TABLE IF EXISTS mentioned_import;
DROP TABLE IF EXISTS tagged_import;
DROP TABLE IF EXISTS tweets_import;
DROP TABLE IF EXISTS urlused_import;
DROP TABLE IF EXISTS user_import;

-- Create import tables

CREATE TABLE `mentioned_import` (
  `tid` varchar(100) DEFAULT NULL,
  `screen_name` text
);

CREATE TABLE `tagged_import` (
  `tid` varchar(100) DEFAULT NULL,
  `hastagname` text
);

CREATE TABLE `tweets_import` (
  `tid` varchar(100) NOT NULL,
  `textbody` text,
  `retweet_count` varchar(50) DEFAULT NULL,
  `retweeted` varchar(50) DEFAULT NULL,
  `posted` text,
  `posting_user` text,
  PRIMARY KEY (`tid`)
);

CREATE TABLE `urlused_import` (
  `tid` varchar(100) DEFAULT NULL,
  `url` text
);

CREATE TABLE `user_import` (
  `screen_name` text,
  `name` text,
  `sub_category` text,
  `category` text,
  `ofstate` text,
  `numFollowers` varchar(50) DEFAULT NULL,
  `numFollowing` varchar(50) DEFAULT NULL
);

-- Perform data import from CSV

LOAD DATA INFILE 'C:\\temp\\mentioned.csv'
INTO TABLE mentioned_import
FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE 'C:\\temp\\tagged.csv'
INTO TABLE tagged_import
FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE 'C:\\temp\\tweets.csv'
INTO TABLE tweets_import
FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE 'C:\\temp\\urlused.csv'
INTO TABLE urlused_import
FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE 'C:\\temp\\user.csv'
INTO TABLE user_import
FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- NOTE: Assumed projectDDL.sql just executed and tables empty
-- Migrate the data from import tables to actual tables

INSERT INTO state
SELECT DISTINCT ofstate
FROM user_import;

INSERT INTO user (sname, uname, category, sub_category, location, followers, following, belongs)
SELECT screen_name, name, category, sub_category, ofstate, numFollowers, numFollowing, ofstate
FROM user_import;

INSERT INTO url
SELECT DISTINCT url
FROM urlused_import;

INSERT INTO hashtag
SELECT DISTINCT hastagname
FROM tagged_import;

INSERT INTO tweet (id, text, day, month, year, rt_count, rtweeted, created_at, tweeted_by)
SELECT tid, textbody, DAY(posted), MONTH(posted), YEAR(posted), retweet_count, 0, posted, posting_user
FROM tweets_import;

INSERT INTO tweet_hashtag (tweet_id, hashtag)
SELECT tid, hastagname
FROM tagged_import;

INSERT INTO tweet_url (tweet_id, url)
SELECT DISTINCT tid, url
FROM urlused_import;

-- Initialize application users

INSERT INTO db_user VALUES ('ddway', SHA1('kmHVuhB8K2'), 1);
INSERT INTO db_user VALUES ('jdveatch', SHA1('1337h@ckrz'), 1);
INSERT INTO db_user VALUES ('jdoe', SHA1('eodj'), 0);