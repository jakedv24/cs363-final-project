-- Table 1: ID Q1

SET @k = 10; # NOTE: Hardcoded because of MySQL bug, will use JDBC parameterized queries
SET @`month` = 5;
SET @`year` = 2016;

SELECT			q.rt_count, q.`text`, q.uname, q.category, q.sub_category
FROM (
	SELECT 		t.rt_count, t.`text`, u.uname, u.category, u.sub_category, t.`month`, t.`day`, t.`year`
	FROM 		tweet t
	INNER JOIN	user u ON u.uname = t.tweeted_by
	WHERE		t.`month` = @`month` AND t.`year` = @`year`
	ORDER BY 	t.rt_count DESC
	LIMIT 		10
) q;

-- Table 1: ID Q2

SET @k = 10; # NOTE: Hardcoded because of MySQL bug, will use JDBC parameterized queries
SET @hashtag = 'RPC2016';
SET @`month` = 5;
SET @`year` = 2016;

SELECT 		*
FROM 		user u
INNER JOIN	tweet t ON t.tweeted_by = u.uname
INNER JOIN 	tweet_hashtag h ON h.tweet_id = t.id
WHERE		t.`month` = @`month` AND t.`year` = @`year` AND h.hashtag = @hashtag
ORDER BY 	t.rt_count DESC
LIMIT		10;

-- Table 1: ID Q27

SET @k = 10; # NOTE: Hardcoded because of MySQL bug, will use JDBC parameterized queries
SET @`month` = 5;
SET @year1 = 2017;
SET @year2 = 2016;

DROP TEMPORARY TABLE IF EXISTS InfluentialUsers1;
DROP TEMPORARY TABLE IF EXISTS InfluentialUsers2;
CREATE TEMPORARY TABLE InfluentialUsers1 ( uname VARCHAR(15) );
CREATE TEMPORARY TABLE InfluentialUsers2 ( uname VARCHAR(15) );

INSERT INTO InfluentialUsers1
SELECT 		u.uname
FROM 		user u
INNER JOIN	tweet t ON t.tweeted_by = u.uname
WHERE		t.`month` = @`month` AND t.`year` = @year1
GROUP BY	u.uname
ORDER BY 	SUM(t.rt_count) DESC
LIMIT 		10;

INSERT INTO InfluentialUsers2
SELECT 		u.uname
FROM 		user u
INNER JOIN	tweet t ON t.tweeted_by = u.uname
WHERE		t.`month` = @`month` AND t.`year` = @year2
GROUP BY	u.uname
ORDER BY 	SUM(t.rt_count) DESC
LIMIT 		10;

SELECT 		*
FROM		InfluentialUsers1
UNION
SELECT		*
FROM		InfluentialUsers2;