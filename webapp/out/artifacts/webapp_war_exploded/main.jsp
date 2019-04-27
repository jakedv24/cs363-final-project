<%@ page import="java.sql.*, com.mysql.jdbc.Driver" %>
<%--
  Created by IntelliJ IDEA.
  User: Jake
  Date: 4/16/2019
  Time: 9:51 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Main</title>
</head>
<body>
    <%@ include file="./DBInfo.jsp"%>

    <%
        if (request.getParameter("username") != null && request.getParameter("password") != null) {
            session.setAttribute("username", request.getParameter("username"));
            session.setAttribute("password", request.getParameter("password"));
        }
    %>

    <%
        Connection conn;
        PreparedStatement stmt;
        ResultSet rs;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, session.getAttribute("username").toString(), session.getAttribute("password").toString());

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

    <h3>Select an action</h3>

</body>
</html>
