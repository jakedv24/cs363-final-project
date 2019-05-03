-- NOTE FOR ALL QUERIES!!
-- Parameters assumed to be provided by JDBC, hardcoded here to demonstrate query

-- Table 1: ID Q1

SELECT 		t.rt_count, t.text, u.sname, u.category, u.sub_category
FROM 		tweet t
INNER JOIN	user u ON u.sname = t.tweeted_by
WHERE		t.month = 4 AND t.year = 2016
ORDER BY 	t.rt_count DESC
LIMIT 		10;

-- Table 1: ID Q2

SELECT 		u.sname, u.category, t.text, t.rt_count
FROM 		user u
INNER JOIN	tweet t ON t.tweeted_by = u.sname
INNER JOIN 	tweet_hashtag h ON h.tweet_id = t.id
WHERE		t.month = 4 AND t.year = 2016 AND h.hashtag = 'DemDebate'
ORDER BY 	t.rt_count DESC
LIMIT		10;

-- Table 1: ID Q3

SELECT		q.hashtag, COUNT(*) AS state_count, GROUP_CONCAT(q.state)
FROM 		(
	SELECT 		h.hashtag, t.year, s.state, COUNT(*) AS tweet_count
	FROM		tweet t
	INNER JOIN	tweet_hashtag h ON h.tweet_id = t.id
	INNER JOIN 	user u ON u.sname = t.tweeted_by
	INNER JOIN	state s ON s.state = u.belongs
	GROUP BY	h.hashtag, s.state, t.year
) q
GROUP BY	q.hashtag
ORDER BY	state_count DESC
LIMIT 		10;

-- Table 1: ID Q6

SELECT u.sname, u.belongs
FROM user u, hashtag h, tweet_hashtag th, tweet t
WHERE t.tweeted_by=u.sname AND t.id=th.tweet_id AND h.hashtag IN ("GOPDebate", "DemDebate") 
GROUP BY (u.sname) HAVING COUNT(u.sname) = 2
ORDER BY u.followers DESC;

-- Table 1: ID Q10

SELECT s.state
FROM state s, user u, tweet t, tweet_hashtag th, hashtag h
WHERE
		s.state = u.belongs
    AND u.sname = t.tweeted_by
	AND t.month = 4
	AND t.id = th.tweet_id
    AND th.hashtag = h.hashtag
    AND h.hashtag IN ("HB375", "AK")
GROUP BY (s.state)
HAVING COUNT(DISTINCT h.hashtag) = 2;

-- Table 1: ID Q15

SELECT u.sname, s.state, ur.url
FROM user u, state s, url ur, tweet t, tweet_url tu
WHERE s.state=u.belongs AND t.tweeted_by=u.sname AND tu.tweet_id=t.id AND tu.url=ur.url AND u.sub_category="democrat" AND t.month=1;

-- TABLE 1: ID Q23

SELECT h.hashtag, COUNT(h.hashtag) as amnt
FROM hashtag h, user u, tweet_hashtag th, tweet t
WHERE h.hashtag=th.hashtag AND th.tweet_id=t.id AND t.tweeted_by=u.sname AND u.sub_category="democrat" AND t.month IN (1, 2, 3)
GROUP BY (h.hashtag)
ORDER BY COUNT(h.hashtag) 
DESC LIMIT 5;

-- Table 1: ID Q27

SET @k = 10; # NOTE: Hardcoded because of MySQL bug, will use JDBC parameterized queries
SET @`month` = 5;
SET @year1 = 2017;
SET @year2 = 2016;

(SELECT 		u.sname
FROM 		user u
INNER JOIN	tweet t ON t.tweeted_by = u.sname
WHERE		t.`month` = @`month` AND t.`year` = @year1
GROUP BY	u.sname
ORDER BY 	SUM(t.rt_count) DESC
LIMIT 		10)
UNION
(SELECT 		u.sname
FROM 		user u
INNER JOIN	tweet t ON t.tweeted_by = u.sname
WHERE		t.`month` = @`month` AND t.`year` = @year2
GROUP BY	u.sname
ORDER BY 	SUM(t.rt_count) DESC
LIMIT 		10);

-- Table 1: ID I

INSERT INTO db_user VALUES ("jdveatch", sha1("donthackme"), true);

-- TABLE 1: ID D

DELETE FROM user WHERE sname="ajcads";