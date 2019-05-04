USE group2;

DROP TABLE IF EXISTS tweet_hashtag;
DROP TABLE IF EXISTS tweet_url;
DROP TABLE IF EXISTS tweet;
DROP TABLE IF EXISTS `user`;
DROP TABLE IF EXISTS hashtag;
DROP TABLE IF EXISTS url;
DROP TABLE IF EXISTS state;
DROP TABLE IF EXISTS db_user;

CREATE TABLE db_user(uname varchar(12), pswd varchar(100), is_admin boolean);

CREATE TABLE hashtag (
	hashtag VARCHAR(279),
    
    PRIMARY KEY (hashtag)
);

CREATE TABLE url (
	url VARCHAR(500),
    
    PRIMARY KEY (url)
);

CREATE TABLE state (
	state VARCHAR(20),
    
    PRIMARY KEY (state)
);

CREATE TABLE `user` (
  `sname` varchar(15) NOT NULL,
  `uname` text,
  `category` text,
  `sub_category` text,
  `location` text,
  `followers` int(11) DEFAULT NULL,
  `following` int(11) DEFAULT NULL,
  `belongs` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`sname`),
  KEY `user_state_fk` (`belongs`),
  KEY `idx_user_followers` (`followers`),
  CONSTRAINT `user_state_fk` FOREIGN KEY (`belongs`) REFERENCES `state` (`state`)
);

CREATE TABLE `tweet` (
  `id` bigint(20) NOT NULL,
  `text` text,
  `day` tinyint(4) DEFAULT NULL,
  `month` tinyint(4) DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  `rt_count` int(11) DEFAULT NULL,
  `rtweeted` bit(1) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `tweeted_by` varchar(15) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_tweet_tweeted_by` (`tweeted_by`),
  KEY `idx_tweet_day_month_year` (`day`,`month`,`year`),
  KEY `idx_tweet_rt_count` (`rt_count`),
  CONSTRAINT `tweet_user_fk` FOREIGN KEY (`tweeted_by`) REFERENCES `user` (`sname`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE tweet_hashtag (
	tweet_id BIGINT,
    hashtag VARCHAR(279),
    
    PRIMARY KEY (tweet_id, hashtag),
    CONSTRAINT tweethashtag_tweet_fk FOREIGN KEY tweet_hashtag(tweet_id) REFERENCES tweet(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT tweethashtag_hashtag_fk FOREIGN KEY tweet_hashtag(hashtag) REFERENCES hashtag(hashtag) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE tweet_url (
	tweet_id BIGINT,
    url VARCHAR(500),
    
    PRIMARY KEY (tweet_id, url),
    CONSTRAINT tweeturl_tweet_fk FOREIGN KEY tweet_url(tweet_id) REFERENCES tweet(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT tweeturl_url_fk FOREIGN KEY tweet_url(url) REFERENCES url(url) ON UPDATE CASCADE ON DELETE CASCADE
);
