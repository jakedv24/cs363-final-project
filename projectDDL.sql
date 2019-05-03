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
	sname VARCHAR(15),
    uname TEXT,
    category TEXT,
    sub_category TEXT,
    location TEXT,
    followers INT,
    `following` INT,
    belongs VARCHAR(20),
    
    PRIMARY KEY (sname),
    CONSTRAINT user_state_fk FOREIGN KEY `user`(belongs) REFERENCES state(state)
);

CREATE TABLE tweet (
	id BIGINT,
    `text` TEXT,
    `day` TINYINT,
    `month` TINYINT,
    `year` INT,
    rt_count INT,
    rtweeted BIT,
    created_at TIMESTAMP,
    tweeted_by VARCHAR(15) NOT NULL,
    
    PRIMARY KEY (id),
    CONSTRAINT tweet_user_fk FOREIGN KEY tweet(tweeted_by) REFERENCES `user`(sname) ON UPDATE CASCADE ON DELETE CASCADE
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
