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
