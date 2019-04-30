<%-- AUTHOR: DANIEL --%>

<%
// Require users to be logged in to view this page
if (!((boolean)session.getAttribute("authenticated")))
    response.sendRedirect("login.jsp");
%>

<%@ page import="java.sql.*, com.mysql.jdbc.Driver" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Results</title>
</head>
<body>
    <h1>Query Parameters</h1>

    <%@ include file="./dbconf.jsp"%>
    <%@ include file="./queryconf.jsp"%>
    <%
        // Grab the requested query by its identifier
        String queryIdentifier = request.getParameter("q");
        Query query = QUERIES.get(queryIdentifier);

        for (QueryParam param : query.parameters) {
            switch (param.type) {
                case QueryParamType.NUMBER:
                    out.println(param.name + " NUMBER");
                    break;
                case QueryParamType.MONTH:
                    out.println(param.name + " MONTH");
                    break;
                case QueryParamType.YEAR:
                    out.println(param.name + " YEAR");
                    break;
            }
        }
    %>

</body>
</html>
