<!-- AUTHOR: JAKE VEATCH, DANIEL WAY -->
<%@ page language="java" contentType="text/html"%>
<%@ page import="java.text.*,java.util.*,java.sql.*" %>

<%

String username = request.getParameter("username");
String password = request.getParameter("password");

bool authenticationFailure = false; // Flag for form validation

// Are we processing a POST'd login?
if (username != null || username.trim().length() > 0
	&& password != null && password.trim().length() > 0) {

	Connection conn;
	PreparedStatement authStmt;
	ResultSet res;	

	try {	

		// Initialize JDBC driver and connect to database
		// TODO: Using integrated creds now, user in future ?
		Class.forName("com.mysql.jdbc.Driver");
		conn = DriverManager.getConnection("jdbc:mysql://cs363winservdb.misc.iastate.edu:3306/team6/?useSSL=false", "", "");

		// Prep. the user query
		authStmt = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE username = ? AND password = ?");
		authStmt.setString(1, username);
		authStmt.setString(2, password);

		// Execute, and depending on request update session or indicate a faillure
		res = authStmt.executeQuery();
		if (res.count() > 0) {
			session.setAttribute("authenticated", "true");
			session.setAttribute("username", username);
			session.setAttribute("password", password);
		} else {
			authenticationFailure = true;
		}

	} catch (Exception e) {
		// swallow
	} finally {
		// Clean up
		if (res != null) res.close();
		if (authStmt != null) authStmt.close();
		if (conn != null) conn.close();
	}

}

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Login</title>
</head>
<body>
	<h3>Login</h3>

	<%
	// If this is a POST'd login that failed, indicate so
	if (authenticationFailure) {
		out.println("<b style="color:red;">Authentication failed, please check that your username and password is correct.</b>");
	}
	%>

	<form method="post">
		Username: <input type="text" name="username"><br>
		Password: <input type="password" name="password"><br>
		<input type="submit" value="Login">
	</form>
	
</body>
</html>
