<!-- AUTHOR: JAKE VEATCH -->
<%@ page language="java" contentType="text/html"%>
<%@ page import="java.text.*,java.util.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Login</title>
</head>
<body>
	<!--See https://www.w3schools.com/html/html_forms.asp 
		"Always use POST if the form data contains sensitive or personal information. 
	     The POST method does not display the submitted form data in the page address field."
	 -->
	<form method="post" action="main.jsp">
		Username: <input type="text" name="username"><br>
		Password: <input type="password" name="password"><br>
		<input type="submit" value="Login">
	</form>
	
</body>
</html>