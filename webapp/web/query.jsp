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

    <form method="POST">
        <table>
            <%@ include file="./dbconf.jsp"%>
            <%@ include file="./queryconf.jsp"%>
            <%
                // Grab the requested query by its identifier
                String queryIdentifier = request.getParameter("q");
                Query query = QUERIES.get(queryIdentifier);

                // Render form controls
                for (int i = 0; i < query.parameters.size(); i++) {
                    out.println("<tr>");

                    // Retrieve the control labeling/input from the parameter itself
                    QueryParam param = query.parameters.get(i);
                    out.println("<td>" + param.getLabel() + "</td>");
                    out.println("<td>" + param.getInput() + "</td>");

                    out.println("</tr>");
                }
            %>
            <tr>
                <td></td>
                <td><button type="submit">Execute Query</button></td>
            </tr>
        </table>
    </form>

</body>
</html>
