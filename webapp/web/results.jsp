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
    <h1>Query Results</h1>

    <%@ include file="./dbconf.jsp"%>
    <%
        Connection conn;
        PreparedStatement stmt;
        ResultSet rs;

        try {
            // Load driver and connect
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(CONN_STR, CONN_USR, CONN_PWD);

            // Grab the requested query
            String requestedQuery = request.getParameter("q");

            out.println("<p>Connection made!</p>");
            out.println("<h3>Select a query</h3>");
            out.println("<form><select name='selectedQuery'>");

            out.println("<option value='Q1'>Q1</option>");
            out.println("<option value='Q2'>Q2</option>");
            out.println("<option value='Q3'>Q3</option>");
            out.println("<option value='Q6'>Q6</option>");
            out.println("<option value='Q10'>Q10</option>");
            out.println("<option value='Q15'>Q15</option>");
            out.println("<option value='Q23'>Q23</option>");
            out.println("<option value='Q27'>Q27</option>");

            // TODO dynamically render options based on admin status
            // How do we want to handle "user table" logins? Two login pages, one for db, other for user?
            out.println("<option value='I'>I</option>");
            out.println("<option value='D'>D</option>");

            out.println("</select></form>");
        } catch (ClassNotFoundException e) {
            out.println("<p>ERROR: Unable to find mysql jdbc driver</p>");
        } catch (SQLException e) {
            out.println("<p>ERROR: Unable to connect to sql database. Check username and password and try again.</p>");
            out.println("<form action='login.jsp'><button type='submit'>Back to login</button></form>");
        }
    %>

</body>
</html>
