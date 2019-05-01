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
				case QueryParamType.SUB_CATEGORY:
				case QueryParamType.HASHTAG:
				case QueryParamType.HASHTAG_LIST:
				case QueryParamType.STATE_LIST:
				case QueryParamType.MONTH_LIST:
				default:
					return true;
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
		"SELECT                  q.rt_count, q.`text`, q.sname, q.category, q.sub_category" +
		"FROM (" +
		"        SELECT          t.rt_count, t.`text`, u.sname, u.category, u.sub_category, t.`month`, t.`day`, t.`year`" +
		"        FROM            tweet t" +
		"        INNER JOIN      user u ON u.sname = t.tweeted_by" +
		"        WHERE           t.`month` = ? AND t.`year` = ?" +
		"        ORDER BY        t.rt_count DESC" +
		"        LIMIT           ?" +
		") q;"
	);

	q1.parameters.add(new QueryParam("month", "Month", QueryParamType.MONTH));
	q1.parameters.add(new QueryParam("year", "Year", QueryParamType.YEAR));
	q1.parameters.add(new QueryParam("k", "Top K Results", QueryParamType.NUMBER));

	QUERIES.put(q1.identifier, q1);

	// ====== CONFIGURE QUERY 2 =================================================

	Query q2 = new Query("Q2",
		"Q2 desc",
		"SELECT          *" +
		"FROM            user u" +
		"INNER JOIN      tweet t ON t.tweeted_by = u.sname" +
		"INNER JOIN      tweet_hashtag h ON h.tweet_id = t.id" +
		"WHERE           t.`month` = ? AND t.`year` = ? AND h.hashtag = ?" +
		"ORDER BY        t.rt_count DESC" +
		"LIMIT           ?;"
	);

	q2.parameters.add(new QueryParam("month", "Month", QueryParamType.MONTH));
	q2.parameters.add(new QueryParam("year", "Year", QueryParamType.YEAR));
	q2.parameters.add(new QueryParam("hashtag", "Hashtag", QueryParamType.NUMBER));
	q2.parameters.add(new QueryParam("k", "Top K Results", QueryParamType.NUMBER));

	QUERIES.put(q1.identifier, q1);

%>