<%@ page import="java.util.*" %>
<%

	// Declare query templating

	public enum QueryParamType {
		NUMBER,
		MONTH,
		YEAR,
		HASHTAG,
		SUB_CATEGORY,
		HASHTAG_LIST,
		STATE_LIST,
		MONTH_LIST
	}

	public class QueryParam {
		public String name;
		public QueryParamType type;
		public String value;
		public String validationMessage;

		public QueryParam(String name, QueryParam type) {
			this.name = name;
			this.type = type;
		}
	}

	public class Query {
		public String identifier;
		public String query;
		public List<QueryParam> parameters;

		public Query(String identifier, String query) {
			this.identifier = identifier;
			this.query = query;
			this.parameters = new ArrayList<>();
		}
	}

	// Collection of query templates and request-scoped data
	
	HashMap<String, Query> QUERIES = new HashMap<>():

	// Configure query 1
	
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
	q1.parameters.add(new QueryParam(0, QueryParamType.MONTH));
	q1.parameters.add(new QueryParam(0, QueryParamType.YEAR));
	q1.parameters.add(new QueryParam(0, QueryParamType.NUMBER));

%>