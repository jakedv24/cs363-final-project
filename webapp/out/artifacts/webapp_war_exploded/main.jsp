<%@ page import="java.sql.*" %>
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
            Class.forName("com.mysql.jdbc.driver");
            conn = DriverManager.getConnection(DB_URL, session.getAttribute("username").toString(), session.getAttribute("password").toString());
            out.println("<p>Connection made!</p>");
        } catch (ClassNotFoundException e) {
            out.println("<p>ERROR: Unable to find mysql jdbc driver</p>");
            throw e;
        } catch (SQLException e) {
            out.println("<p>ERROR: Unable to connect to sql database</p>");
        }
    %>

    <h3>Select an action</h3>

</body>
</html>
