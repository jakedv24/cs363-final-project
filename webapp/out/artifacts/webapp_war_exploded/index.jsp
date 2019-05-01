<%--
  Created by IntelliJ IDEA.
  User: Jake, Daniel
  Date: 4/16/2019
  Time: 9:44 AM
  To change this template use File | Settings | File Templates.
--%>

<%
// Require users to be logged in to view this page
if (session.getAttribute("authenticated") == null || !((boolean)session.getAttribute("authenticated"))) {
    response.sendRedirect("login.jsp");
    return;
}
%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Query Selection - Group 2 Final Project</title>
</head>
<body>

    <h1>Group 2 Final Project</h1>
    <h3>Query Selection</h3>

    <a href="logout.jsp">Logout</a>

    <hr />

    <form action="query.jsp" method="GET">
        <select name="q">
            <option value="Q1">Q1</option>
            <option value="Q2">Q2</option>
            <option value="Q3">Q3</option>
            <option value="Q6">Q6</option>
            <option value="Q10">Q10</option>
            <option value="Q15">Q15</option>
            <option value="Q23">Q23</option>
            <option value="Q27">Q27</option>
            <% if ((boolean)session.getAttribute("isAdministrator")) out.println("<option value=\"I\">I (admin)</option>"); %>
            <% if ((boolean)session.getAttribute("isAdministrator")) out.println("<option value=\"D\">D (admin)</option>"); %>
        </select>
        <button type="submit">Open Query Parameters</button>
    </form>

</body>
</html>
