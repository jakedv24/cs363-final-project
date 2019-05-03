<%@ page import="java.util.*" %>
<%@ page import="java.util.stream.Collectors" %>
<%

    // Declare query templating

    final class QueryParamType {
        static final int NUMBER = 0;
        static final int MONTH = 1;
        static final int YEAR = 2;
        static final int SUB_CATEGORY = 3;
        static final int HASHTAG = 4;
        static final int HASHTAG_LIST = 5;
        static final int STATE_LIST = 6;
        static final int MONTH_LIST = 7;
        static final int TEXT = 8;
        static final int YEAR_MULTI = 9;
        static final int NUMBER_MULTI = 10;
    }

    class QueryParam {
        String identifier;
        String name;
        int type;
        String value;
        String validationMessage;

        QueryParam(String identifier, String name, int type) {
            this.identifier = identifier;
            this.name = name;
            this.type = type;
        }

        String getLabel() {
            return "<label for=\"" + identifier + "\">" + name + "</label>";
        }

        String getInput() {
            switch (type) {
                case QueryParamType.NUMBER:
                case QueryParamType.NUMBER_MULTI:
                    return "<input type=\"text\" name=\"" + identifier + "\" value=\"" + (value == null ? "" : value) + "\" />";
                case QueryParamType.MONTH:
                    return "<input type=\"text\" name=\"" + identifier + "\" value=\"" + (value == null ? "" : value) + "\" />";
                case QueryParamType.YEAR:
                case QueryParamType.YEAR_MULTI:
                    return "<input type=\"text\" name=\"" + identifier + "\" value=\"" + (value == null ? "" : value) + "\" />";
                case QueryParamType.SUB_CATEGORY:
                    return "<input type=\"text\" name=\"" + identifier + "\" value=\"" + (value == null ? "" : value) + "\" />";
                case QueryParamType.HASHTAG:
                    return "<input type=\"text\" name=\"" + identifier + "\" value=\"" + (value == null ? "" : value) + "\" />";
                case QueryParamType.HASHTAG_LIST:
                    return "<input type=\"text\" name=\"" + identifier + "\" value=\"" + (value == null ? "" : value) + "\" />";
                case QueryParamType.STATE_LIST:
                    return "<input type=\"text\" name=\"" + identifier + "\" value=\"" + (value == null ? "" : value) + "\" />";
                case QueryParamType.MONTH_LIST:
                    return "<input type=\"text\" name=\"" + identifier + "\" value=\"" + (value == null ? "" : value) + "\" />";
                case QueryParamType.TEXT:
                    return "<input type=\"text\" name=\"" + identifier + "\" value=\"" + (value == null ? "" : value) + "\" />";
                default:
                    return "";
            }
        }

        boolean validateInput(String input) {
            value = input;
            if (value == null || value.trim().length() == 0) {
                validationMessage = "Value is required.";
                return false;
            }

            switch (type) {
                case QueryParamType.NUMBER:
                    if (!isNumber()) {
                        validationMessage = name + " must be a number.";
                        return false;
                    } else {
                        return true;
                    }
                case QueryParamType.MONTH:
                    if (!isNumber()) {
                        validationMessage = name + " must be a number.";
                        return false;
                    }
                    int month = toNumber();
                    if (month < 1 || month > 12) {
                        validationMessage = name + " must be between 1 and 12.";
                        return false;
                    }
                    return true;
                case QueryParamType.YEAR:
                    if (!isNumber()) {
                        validationMessage = name + " must be a number.";
                        return false;
                    }
                    int year = toNumber();
                    if (year < 2006 || year > 2019) {
                        validationMessage = name + " must be between 2006 and 2019.";
                        return false;
                    }
                    return true;
                case QueryParamType.HASHTAG:
                case QueryParamType.HASHTAG_LIST:
                    value = value.replaceAll("#", "");
                case QueryParamType.SUB_CATEGORY:
                case QueryParamType.STATE_LIST:
                case QueryParamType.MONTH_LIST:
                default:
                    return true;
            }
        }

        void setStatementParameter(int index, PreparedStatement stmt, Connection conn) throws SQLException {
            switch (type) {
                case QueryParamType.NUMBER:
                case QueryParamType.NUMBER_MULTI:
                case QueryParamType.MONTH:
                case QueryParamType.YEAR:
                case QueryParamType.YEAR_MULTI:
                    stmt.setInt(index, toNumber());
                    break;
                case QueryParamType.SUB_CATEGORY:
                case QueryParamType.HASHTAG:
                case QueryParamType.HASHTAG_LIST:
                case QueryParamType.STATE_LIST:
                case QueryParamType.MONTH_LIST:
                    this.setListParams(index, stmt, conn);
                default:
                    stmt.setString(index, value);
                    break;
            }
        }

        private void setListParams(int index, PreparedStatement stmt, Connection conn) throws SQLException {
            Set<String> values = this.parseStringValues();
            replaceNumberParameters(values.size(), index, stmt, conn);

            int i = index;
            for (String s : values) {
                stmt.setString(i, s);
                i++;
            }
        }

        private void replaceNumberParameters(int numParams, int index, PreparedStatement stmt, Connection conn) throws SQLException {
            String query = stmt.toString();
            int paramNumber = 0;
            int i = 0;

            while (paramNumber != index) {
                if (query.charAt(i) == '?') {
                    paramNumber++;
                }

                i++;
            }

            StringBuilder finalValue = new StringBuilder();
            finalValue.append(query.substring(0, i));

            for (int j = 0; j < numParams; j++) {
                finalValue.append('?');
                if (j != numParams - 1) {
                    finalValue.append(',');
                }
            }

            finalValue.append(query.substring(i));

            stmt = conn.prepareStatement(finalValue.toString());
        }

        private Set<String> parseStringValues() {
            Set<String> values = new HashSet<>(Arrays.asList((this.value.split(","))));

            return values.stream()
                    .map(String::trim)
                    .collect(Collectors.toSet());
        }

        boolean isNumber() {
            try {
                toNumber();
                return true;
            } catch (Exception e) {
                return false;
            }
        }

        int toNumber() {
            return Integer.parseInt(value);
        }
    }

    class Query {
        String identifier;
        String description;
        String query;
        List<QueryParam> parameters;

        Query(String identifier, String description, String query) {
            this.identifier = identifier;
            this.description = description;
            this.query = query;
            this.parameters = new ArrayList<>();
        }
    }

    // Collection of query templates and request-scoped data

    HashMap<String, Query> QUERIES = new HashMap<>();

    // ====== CONFIGURE QUERY 1 =================================================

    Query q1 = new Query("Q1",
            "List k most retweeted tweets in a given month and a given year; show the retweet count, the tweet text, the posting user's screen name, the posting user's category, the posting user's sub-category in descending order of the retweet count.",

            "SELECT 	t.rt_count, t.text, u.sname, u.category, u.sub_category " +
                    "FROM 		tweet t " +
                    "INNER JOIN	user u ON u.sname = t.tweeted_by " +
                    "WHERE		t.month = ? AND t.year = ? " +
                    "ORDER BY 	t.rt_count DESC " +
                    "LIMIT 		?"

    );

    q1.parameters.add(new QueryParam("month", "Month", QueryParamType.MONTH));
    q1.parameters.add(new QueryParam("year", "Year", QueryParamType.YEAR));
    q1.parameters.add(new QueryParam("k", "Top K Results", QueryParamType.NUMBER));

    QUERIES.put(q1.identifier, q1);

    // ====== CONFIGURE QUERY 2 =================================================

    Query q2 = new Query("Q2",
            "In a given month of a given year, find k users who used a given hashtag in a tweet with the most number of retweets; show the user's screen name, user's category, tweet text, and retweet count in descending order of the retweet count.",

            "SELECT 		u.sname, u.category, t.text, t.rt_count " +
                    "FROM 		user u " +
                    "INNER JOIN	tweet t ON t.tweeted_by = u.sname " +
                    "INNER JOIN 	tweet_hashtag h ON h.tweet_id = t.id " +
                    "WHERE		t.month = ? AND t.year = ? AND h.hashtag = ? " +
                    "ORDER BY 	t.rt_count DESC " +
                    "LIMIT		?"

    );

    q2.parameters.add(new QueryParam("month", "Month", QueryParamType.MONTH));
    q2.parameters.add(new QueryParam("year", "Year", QueryParamType.YEAR));
    q2.parameters.add(new QueryParam("hashtag", "Hashtag", QueryParamType.HASHTAG));
    q2.parameters.add(new QueryParam("k", "Top K Results", QueryParamType.NUMBER));

    QUERIES.put(q2.identifier, q2);

    // ====== CONFIGURE QUERY 3 =================================================

    Query q3 = new Query("Q3",
            "Find k hashtags that appeared in the most number of states in a given year; list the total number of states the hashtag appeared, the list of the distinct states it appeared, and the hashtag itself in descending order of the number of states the hashtag appeared.",

            "SELECT		q.hashtag, COUNT(*) AS state_count, GROUP_CONCAT(q.state) " +
                    "FROM 		( " +
                    "	SELECT 		h.hashtag, t.year, s.state, COUNT(*) AS tweet_count " +
                    "	FROM		tweet t " +
                    "	INNER JOIN	tweet_hashtag h ON h.tweet_id = t.id " +
                    "	INNER JOIN 	user u ON u.sname = t.tweeted_by " +
                    "	INNER JOIN	state s ON s.state = u.belongs " +
                    "	WHERE		t.year = ?" +
                    "	GROUP BY	h.hashtag, s.state, t.year " +
                    ") q " +
                    "GROUP BY	q.hashtag " +
                    "ORDER BY	state_count DESC " +
                    "LIMIT 		?"

    );

    q3.parameters.add(new QueryParam("year", "Year", QueryParamType.YEAR));
    q3.parameters.add(new QueryParam("k", "Top K Results", QueryParamType.NUMBER));

    QUERIES.put(q3.identifier, q3);

    // ====== CONFIGURE QUERY 6 =================================================

    Query q6 = new Query("Q6",
            "Find k users who used a certain set of hashtags in their tweets. Show the user's screen name and the state to which the user belongs in descending order of the number of followers",

            "SELECT u.sname, u.belongs " +
                    "FROM user u, hashtag h, tweet_hashtag th, tweet t " +
                    "WHERE t.tweeted_by=u.sname AND t.id=th.tweet_id AND h.hashtag IN (?)  " +
                    "GROUP BY (u.sname) HAVING COUNT(u.sname) = ? " +
                    "ORDER BY u.followers DESC " +
                    "LIMIT ?"

    );

    q6.parameters.add(new QueryParam("hashtags", "Hashtags", QueryParamType.HASHTAG_LIST));
    q6.parameters.add(new QueryParam("hashtag_count", "Hashtag Count", QueryParamType.NUMBER));
    q6.parameters.add(new QueryParam("k", "Top K Results", QueryParamType.NUMBER));

    QUERIES.put(q6.identifier, q6);

    // ====== CONFIGURE QUERY 10 =================================================

    Query q10 = new Query("Q10",
            "Find the list of distinct hashtags that appeared in one of the states in a given list in a given month of a given year; show the list of the hashtags and the names of the states in which they appeared.",

            "SELECT s.state " +
                    "FROM state s, user u, tweet t, tweet_hashtag th, hashtag h " +
                    "WHERE " +
                    "		s.state = u.belongs " +
                    "    AND u.sname = t.tweeted_by " +
                    "	AND t.month = ? " +
                    "	AND t.id = th.tweet_id " +
                    "    AND th.hashtag = h.hashtag " +
                    "    AND h.hashtag IN (?) " +
                    "GROUP BY (s.state) " +
                    "HAVING COUNT(DISTINCT h.hashtag) = ?"

    );

    q10.parameters.add(new QueryParam("month", "Month", QueryParamType.MONTH));
    q10.parameters.add(new QueryParam("hashtags", "Hashtags", QueryParamType.HASHTAG_LIST));
    q10.parameters.add(new QueryParam("hashtag_count", "Hashtag Count", QueryParamType.NUMBER));

    QUERIES.put(q10.identifier, q10);

    // ====== CONFIGURE QUERY 15 =================================================

    Query q15 = new Query("Q15",
            "Find users in a given sub-category along with the list of URLs used in the user’s tweets in a given month of a given year. Show the user’s screen name, the state the user belongs, and the list of URLs",

            "SELECT u.sname, s.state, ur.url " +
                    "FROM user u, state s, url ur, tweet t, tweet_url tu " +
                    "WHERE " +
                    "		s.state = u.belongs " +
                    "    AND t.tweeted_by = u.sname " +
                    "    AND tu.tweet_id = t.id  " +
                    "    AND tu.url = ur.url " +
                    "    AND u.sub_category = ? AND t.month = ? AND t.year = ?"

    );

    q15.parameters.add(new QueryParam("sub_category", "Sub-Category", QueryParamType.SUB_CATEGORY));
    q15.parameters.add(new QueryParam("month", "Month", QueryParamType.MONTH));
    q15.parameters.add(new QueryParam("year", "Year", QueryParamType.YEAR));

    QUERIES.put(q15.identifier, q15);

    // ====== CONFIGURE QUERY 23 =================================================

    Query q23 = new Query("Q23",
            "Find k most used hashtags with the count of tweets it appeared posted by a given sub-category of users in a list of months. Show the hashtag name and the count in descending order of the count.",

            "SELECT h.hashtag, COUNT(h.hashtag) as amnt " +
                    "FROM hashtag h, user u, tweet_hashtag th, tweet t " +
                    "WHERE " +
                    "		h.hashtag = th.hashtag " +
                    "	AND th.tweet_id = t.id " +
                    "    AND t.tweeted_by = u.sname " +
                    "    AND u.sub_category = ? " +
                    "    AND t.month IN ? " +
                    "	 AND t.year = ?" +
                    "GROUP BY (h.hashtag) " +
                    "ORDER BY COUNT(h.hashtag) DESC " +
                    "LIMIT ?"

    );

    q23.parameters.add(new QueryParam("sub_category", "Sub-Category", QueryParamType.SUB_CATEGORY));
    q23.parameters.add(new QueryParam("months", "Months", QueryParamType.MONTH_LIST));
    q23.parameters.add(new QueryParam("year", "Year", QueryParamType.YEAR));
    q23.parameters.add(new QueryParam("k", "Number most used hashtags", QueryParamType.MONTH_LIST));

    QUERIES.put(q23.identifier, q23);

    // ====== CONFIGURE QUERY 27 =================================================

    Query q27 = new Query("Q27",
            "Given a month and two selected years, report the screen names of influential users (based on top k retweet counts in that month in the two selected years).",

            "(	SELECT 		u.sname " +
                    "	FROM 		user u " +
                    "	INNER JOIN	tweet t ON t.tweeted_by = u.sname " +
                    "	WHERE		t.month = ? AND t.year = ? " +
                    "	GROUP BY	u.sname " +
                    "	ORDER BY 	SUM(t.rt_count) DESC " +
                    "	LIMIT 		?" +
                    ") UNION ( " +
                    "	SELECT 		u.sname " +
                    "	FROM 		user u " +
                    "	INNER JOIN	tweet t ON t.tweeted_by = u.sname " +
                    "	WHERE		t.month = ? AND t.year = ? " +
                    "	GROUP BY	u.sname " +
                    "	ORDER BY 	SUM(t.rt_count) DESC " +
                    "	LIMIT 		?); "

    );

    q27.parameters.add(new QueryParam("month1", "First Month", QueryParamType.MONTH));
    q27.parameters.add(new QueryParam("year", "Year", QueryParamType.YEAR_MULTI));
    q27.parameters.add(new QueryParam("k", "Number of users", QueryParamType.NUMBER_MULTI));
    q27.parameters.add(new QueryParam("month2", "Second month", QueryParamType.MONTH));
    q27.parameters.add(new QueryParam("year", "Year", QueryParamType.YEAR_MULTI));
    q27.parameters.add(new QueryParam("k", "Number of users", QueryParamType.NUMBER_MULTI));

    QUERIES.put(q27.identifier, q27);

    // ====== CONFIGURE QUERY I =================================================

    Query insert = new Query("I",
            "Insert information of a new user into the database.",
            "INSERT INTO db_user VALUES (?, sha1(?), ?);"
    );

    insert.parameters.add(new QueryParam("username", "Username", QueryParamType.TEXT));
    insert.parameters.add(new QueryParam("password", "Password", QueryParamType.TEXT));
    insert.parameters.add(new QueryParam("is_admin", "Is admin? (1 = true, 0 = false)", QueryParamType.NUMBER));

    QUERIES.put(insert.identifier, insert);

    // ====== CONFIGURE QUERY D =================================================

    Query delete = new Query("D",
            "Delete a given user and all the tweets the user has tweeted, relevant hashtags, and users mentioned",
            "DELETE FROM user WHERE sname=?;"
    );

    delete.parameters.add(new QueryParam("sname", "Screen Name", QueryParamType.TEXT));

    QUERIES.put(delete.identifier, delete);
%>