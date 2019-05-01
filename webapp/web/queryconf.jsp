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
					return "<input type=\"text\" name=\"" + identifier + "\" />";
				case QueryParamType.MONTH:
					return "<input type=\"text\" name=\"" + identifier + "\" />";
				case QueryParamType.YEAR:
					return "<input type=\"text\" name=\"" + identifier + "\" />";
				case QueryParamType.SUB_CATEGORY:
				case QueryParamType.HASHTAG:
				case QueryParamType.HASHTAG_LIST:
				case QueryParamType.STATE_LIST:
				case QueryParamType.MONTH_LIST:
				default:
					return "";
			}
		}
	}

	class Query {
		String identifier;
		String query;
		List<QueryParam> parameters;

		Query(String identifier, String query) {
			this.identifier = identifier;
			this.query = query;
			this.parameters = new ArrayList<>();
		}
	}

	// Collection of query templates and request-scoped data
	
	HashMap<String, Query> QUERIES = new HashMap<>();

	// ====== CONFIGURE QUERY 1 =================================================

	Query q1 = new Query("Q1",
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

%>