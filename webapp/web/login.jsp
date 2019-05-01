<!-- AUTHOR: JAKE VEATCH, DANIEL WAY -->
<%@ page language="java" contentType="text/html"%>
<%@ page import="java.text.*,java.util.*,java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%@ include file="dbconf.jsp" %>

<%

String username = request.getParameter("username");
String password = request.getParameter("password");

boolean authenticationFailure = false; // Flag for form validation

// Are we processing a POST'd login?
if (username != null && username.trim().length() > 0 && password != null && password.trim().length() > 0) {

	Connection conn = null;
	PreparedStatement authStmt = null;
	ResultSet res = null;

	try {
		// Initialize JDBC driver and connect to database
		Class.forName("com.mysql.jdbc.Driver");
		conn = DriverManager.getConnection(CONN_STR, CONN_USR, CONN_PWD);

		// Prep. the user query
		authStmt = conn.prepareStatement("SELECT * FROM db_user WHERE uname = ? AND pswd = SHA1(?)");
		authStmt.setString(1, username);
		authStmt.setString(2, password);

		// Execute, and depending on request update session or indicate a faillure
		res = authStmt.executeQuery();
		if (res.next()) {
			session.setAttribute("authenticated", true);
			session.setAttribute("isAdministrator", res.getString("is_admin").equals("1"));
		} else {
			authenticationFailure = true;
		}
	} catch (Exception e) {
		// Swallow, debug in comments
		out.println("<!--" + e.getMessage() + "-->");
	} finally {
		// Clean up
		if (res != null) res.close();
		if (authStmt != null) authStmt.close();
		if (conn != null) conn.close();
	}
}

// Redirect if the user is logged-in
if (session.getAttribute("authenticated") != null && (boolean)session.getAttribute("authenticated")) {
	response.sendRedirect("index.jsp");
}

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Login - Group 2 Final Project</title>
</head>
<body>
    <h1>Group 2 Final Project</h1>
    <h3>Login</h3>
    <h5>You must be logged in to access this application.</h5>

    <hr />

	<%
	// If this is a POST'd login that failed, indicate so
	if (authenticationFailure) {
		out.println("<b style=\"color:red;\">Authentication failed, please check that your username and password is correct.</b>");
	}
	%>

	<form method="post">
		Username: <input type="text" name="username"><br>
		Password: <input type="password" name="password"><br>
		<input type="submit" value="Login">
	</form>
	
</body>
</html>
