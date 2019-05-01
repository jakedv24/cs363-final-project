<%@ page import="java.util.*" %>
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
					return "<input type=\"text\" name=\"" + identifier + "\" value=\"" + (value == null ? "" : value) + "\" />";
				case QueryParamType.MONTH:
					return "<input type=\"text\" name=\"" + identifier + "\" value=\"" + (value == null ? "" : value) + "\" />";
				case QueryParamType.YEAR:
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

		void setStatementParameter(int index, PreparedStatement stmt) throws SQLException {
			switch (type) {
				case QueryParamType.NUMBER:
				case QueryParamType.MONTH:
				case QueryParamType.YEAR:
					stmt.setInt(index, toNumber());
					break;
				case QueryParamType.SUB_CATEGORY:
				case QueryParamType.HASHTAG:
				case QueryParamType.HASHTAG_LIST:
				case QueryParamType.STATE_LIST:
				case QueryParamType.MONTH_LIST:
				default:
					stmt.setString(index, value);
					break;
			}
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
		"SELECT                  q.rt_count, q.`text`, q.sname, q.category, q.sub_category " +
		"FROM ( " +
		"        SELECT          t.rt_count, t.`text`, u.sname, u.category, u.sub_category, t.`month`, t.`day`, t.`year` " +
		"        FROM            tweet t " +
		"        INNER JOIN      user u ON u.sname = t.tweeted_by " +
		"        WHERE           t.`month` = ? AND t.`year` = ? " +
		"        ORDER BY        t.rt_count DESC " +
		"        LIMIT           ? " +
		") q;"
	);

	q1.parameters.add(new QueryParam("month", "Month", QueryParamType.MONTH));
	q1.parameters.add(new QueryParam("year", "Year", QueryParamType.YEAR));
	q1.parameters.add(new QueryParam("k", "Top K Results", QueryParamType.NUMBER));

	QUERIES.put(q1.identifier, q1);

	// ====== CONFIGURE QUERY 2 =================================================

	Query q2 = new Query("Q2",
		"In a given month of a given year, find k users who used a given hashtag in a tweet with the most number of retweets; show the user's screen name, user's category, tweet text, and retweet count in descending order of the retweet count.",
		"SELECT          * " +
		"FROM            user u " +
		"INNER JOIN      tweet t ON t.tweeted_by = u.sname " +
		"INNER JOIN      tweet_hashtag h ON h.tweet_id = t.id " +
		"WHERE           t.`month` = ? AND t.`year` = ? AND h.hashtag = ? " +
		"ORDER BY        t.rt_count DESC " +
		"LIMIT           ?;"
	);

	q2.parameters.add(new QueryParam("month", "Month", QueryParamType.MONTH));
	q2.parameters.add(new QueryParam("year", "Year", QueryParamType.YEAR));
	q2.parameters.add(new QueryParam("hashtag", "Hashtag", QueryParamType.HASHTAG));
	q2.parameters.add(new QueryParam("k", "Top K Results", QueryParamType.NUMBER));

	QUERIES.put(q2.identifier, q2);

	// ====== CONFIGURE QUERY 3 =================================================

	Query q3 = new Query("Q3",
		"Find k hashtags that appeared in the most number of states in a given year; list the total number of states the hashtag appeared, the list of the distinct states it appeared, and the hashtag itself in descending order of the number of states the hashtag appeared.",
		"SELECT          q.hashtag, COUNT(*) AS state_count, GROUP_CONCAT(q.state) " +
		"FROM            ( " +
		"        SELECT          h.hashtag, t.`year`, s.state, COUNT(*) AS tweet_count " +
		"        FROM            tweet t " +
		"        INNER JOIN      tweet_hashtag h ON h.tweet_id = t.id " +
		"        INNER JOIN      user u ON u.sname = t.tweeted_by " +
		"        INNER JOIN      state s ON s.state = u.belongs " +
		"		 WHERE 			 t.`year` = ?" +
		"        GROUP BY        h.hashtag, s.state, t.`year` " +
		") q " +
		"GROUP BY        q.hashtag " +
		"ORDER BY        state_count DESC " +
		"LIMIT           ?;"
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
		"LIMIT ?;"
	);

	q6.parameters.add(new QueryParam("hashtags", "Hashtags", QueryParamType.HASHTAG_LIST));
	q6.parameters.add(new QueryParam("hashtag_count", "Hashtag Count", QueryParamType.NUMBER));
	q6.parameters.add(new QueryParam("k", "Top K Results", QueryParamType.NUMBER));

	QUERIES.put(q6.identifier, q6);

	// ====== CONFIGURE QUERY 10 =================================================

	Query q10 = new Query("Q10",
			"Find the list of distinct hashtags that appeared in one of the states in a given list in a given month of a given year; show the list of the hashtags and the names of the states in which they appeared.",
			"SELECT s.state FROM state s, user u, tweet t, tweet_hashtag th, hashtag h" +
                    "WHERE s.state=u.belongs AND u.sname=t.tweeted_by AND t.month=1 AND t.id=th.tweet_id AND th.hashtag=h.hashtag AND h.hashtag IN (?)" +
					"GROUP BY (s.state)" +
					"HAVING COUNT(DISTINCT h.hashtag)=?;"
			);

	q10.parameters.add(new QueryParam("hashtags", "Hashtags", QueryParamType.HASHTAG_LIST));
	q10.parameters.add(new QueryParam("hashtag_count", "Hashtag Count", QueryParamType.NUMBER));

	QUERIES.put(q10.identifier, q10);

    // ====== CONFIGURE QUERY 10 =================================================

    Query q15 = new Query("Q15",
            "Find users in a given sub-category along with the list of URLs used in the user’s tweets in a given month of a given year. Show the user’s screen name, the state the user belongs, and the list of URLs",
            ""
    );

    q15.parameters.add(new QueryParam("hashtags", "Hashtags", QueryParamType.HASHTAG_LIST));
    q15.parameters.add(new QueryParam("hashtag_count", "Hashtag Count", QueryParamType.NUMBER));

    QUERIES.put(q15.identifier, q10);
%>