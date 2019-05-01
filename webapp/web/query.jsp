<%-- AUTHOR: DANIEL --%>

<%@ page import="java.sql.*, com.mysql.jdbc.Driver" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
// Require users to be logged in to view this page
if (!((boolean)session.getAttribute("authenticated")))
    response.sendRedirect("login.jsp");
%>

<%@ include file="./dbconf.jsp"%>
<%@ include file="./queryconf.jsp"%>
<%
    // Grab the requested query by its identifier
    String queryIdentifier = request.getParameter("q");
    Query query = QUERIES.get(queryIdentifier);
    boolean validationError = false;

    // Handle query form submission
    if (request.getParameter("submit") != null) {

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

        // If no errors, forward to results page
        if (!validationError) {
            // Build results page query string
            String resultsParameters = "?";
            for (QueryParam param : query.parameters)
                resultsParameters += param.identifier + "=" + param.value + "&";

            // Redirect to results page
            response.sendRedirect("results.jsp" + resultsParameters);
        }
    }
%>

<html>
<head>
    <title>Results</title>
</head>
<body>
    <h1>Query Parameters</h1>

    <form method="POST">
        <table>
            <%
                // Render form controls
                for (QueryParam param : query.parameters) {
                    // Render validation errors, if any
                    if (validationError && param.validationMessage != null) {
                        out.println("<tr><td style=\"color:red;\">" + param.validationMessage + "</td></tr>");
                    }

                    // Render control label/input
                    out.println("<tr>");
                    out.println("<td>" + param.getLabel() + "</td>");
                    out.println("<td>" + param.getInput() + "</td>");
                    out.println("</tr>");
                }
            %>
            <tr>
                <td></td>
                <td><input type="submit" name="submit" value="Execute Query" /></td>
            </tr>
        </table>
    </form>

</body>
</html>
