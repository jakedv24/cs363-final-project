<%-- AUTHOR: DANIEL --%>

<%@ page import="java.sql.*, com.mysql.jdbc.Driver" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
// Require users to be logged in to view this page
if (session.getAttribute("authenticated") != null && !((boolean)session.getAttribute("authenticated")))
    response.sendRedirect("login.jsp");
%>

<%@ include file="./dbconf.jsp"%>
<%@ include file="./queryconf.jsp"%>
<%
    // Grab the requested query by its identifier
    String queryIdentifier = request.getParameter("q");
    Query query = QUERIES.get(queryIdentifier);
    boolean validationError = false;

    // Check if an invalid query was requested
    if (query == null) {
        response.sendRedirect("main.jsp");
    }

    // Step through parameters validating
    for (QueryParam param : query.parameters) {
        if (!param.validateInput(request.getParameter(param.identifier))) {
            validationError = true;
        }
    }

    // If errors (shouldn't be, we already validated), send back to the main screen
    if (validationError) {
        // Redirect to results page
        response.sendRedirect("main.jsp");
    }
%>

<html>
<head>
    <title>Results</title>
    <style type="text/css">
        td, th {
            font-size: 12px;
        }
    </style>
</head>
<body>
    <h1>Query Results</h1>

    <%
        Connection conn;
        PreparedStatement stmt;
        ResultSet rs;
        ResultSetMetaData rsMeta;

        try {
            // Load driver and connect
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(CONN_STR, CONN_USR, CONN_PWD);

            // Setup query statement
            stmt = conn.prepareStatement(query.query);

            // Add query parameters
            for (int i = 0; i < query.parameters.size(); i++) {
                QueryParam param = query.parameters.get(i);
                param.setStatementParameter(i + 1, stmt);
            }

            // Execute
            rs = stmt.executeQuery();
            rsMeta = rs.getMetaData();

            // Render results
            out.println("<table border=\"1\">");

            out.println("<tr>");
            for (int i = 0; i < rsMeta.getColumnCount(); i++) {
                out.println("<th>" + rsMeta.getColumnName(i + 1) + "</th>");
            }
            out.println("</tr>");

            while (rs.next()) {
                out.println("<tr>");
                for (int i = 0; i < rsMeta.getColumnCount(); i++) {
                    out.println("<td>" + rs.getString(i + 1) + "</td>");
                }
                out.println("</tr>");
            }
            out.println("</table>");
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    %>

</body>
</html>
