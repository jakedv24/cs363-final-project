-- Table 1: ID Q1

SET @k = 10;
SET @`month` = 5;
SET @`year` = 2016;

SET @rnum = 0;

SELECT 		q2.rt_count, q2.`text`, q2.uname, q2.category, q2.sub_category
FROM (
	SELECT		(@rnum := @rnum + 1), q1.rt_count, q1.`text`, q1.uname, q1.category, q1.sub_category
	FROM (
		SELECT 		t.rt_count, t.`text`, u.uname, u.category, u.sub_category, t.`month`, t.`day`, t.`year`
		FROM 		tweet t
		INNER JOIN	user u ON u.uname = t.tweeted_by
		WHERE		t.`month` = @`month` AND t.`year` = @`year`
		ORDER BY 	t.rt_count DESC
	) q1
    WHERE		@rnum < @k
) q2;

-- Table 1: ID Q2

SET @k = 10;
SET @hashtag = 'RPC2016';
SET @`month` = 5;
SET @`year` = 2016;

SET @rnum = 0;

SELECT 		q2.*
FROM (
	SELECT		(@rnum := @rnum + 1), q1.*
	FROM (
		SELECT 		*
		FROM 		user u
		INNER JOIN	tweet t ON t.tweeted_by = u.uname
        INNER JOIN 	tweet_hashtag h ON h.tweet_id = t.id
		WHERE		t.`month` = @`month` AND t.`year` = @`year` AND h.hashtag = @hashtag
		ORDER BY 	t.rt_count DESC
	) q1
    WHERE		@rnum < @k
) q2;