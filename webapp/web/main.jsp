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

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Main</title>
</head>
<body>

    <h1>Query Selection</h1>
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
            <option value="I">I</option>
            <option value="D">D</option>
        </select>
        <button type="submit">Open Query Parameters</button>
    </form>

</body>
</html>
