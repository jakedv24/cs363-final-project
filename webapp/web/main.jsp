<%--
  Created by IntelliJ IDEA.
  User: Jake, Daniel
  Date: 4/16/2019
  Time: 9:51 AM
  To change this template use File | Settings | File Templates.
--%>

<%
// Require users to be logged in to view this page
if (!((boolean)session.getAttribute("authenticated")))
    response.sendRedirect("login.jsp");
%>

<%@ page import="java.sql.*, com.mysql.jdbc.Driver" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Main</title>
</head>
<body>
    <%@ include file="./dbconf.jsp"%>

    <%
        Connection conn;
        PreparedStatement stmt;
        ResultSet rs;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(CONN_STR, CONN_USR, CONN_PWD);

            out.println("<p>Connection made!</p>");
            out.println("<h3>Select a query</h3>");
            out.println("<form><select name='selectedQuery'>");

            // TODO dynamically render options based on admin status
            out.println("<option value='Q1'>Q1</option>");

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
