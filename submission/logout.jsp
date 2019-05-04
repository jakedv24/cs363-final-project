<!-- AUTHOR: JAKE VEATCH, DANIEL WAY -->
<%@ page language="java" contentType="text/html"%>

<%
session.setAttribute("authenticated", false);
session.setAttribute("isAdministrator", false);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Logout - Group 2 Final Project</title>
</head>
<body>

    <h1>Group 2 Final Project</h1>
    <h3>Logout</h3>
    <h5>You have been logged out. <a href="login.jsp">Login</a></h5>
	
</body>
</html>
