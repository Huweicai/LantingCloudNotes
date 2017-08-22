<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>登陆</title>
<!-- Meta tag Keywords -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="keywords" content="Smart Login Form Responsive Widget,Login form widgets, Sign up Web forms , Login signup Responsive web form,Flat Pricing table,Flat Drop downs,Registration Forms,News letter Forms,Elements" />
<script type="application/x-javascript"> addEventListener("load", function() { setTimeout(hideURLbar, 0); }, false);
function hideURLbar(){ window.scrollTo(0,1); } </script>
<!-- Meta tag Keywords -->
<!-- css files -->
<link href="css/style.css" rel="stylesheet" type="text/css" media="all">
<script>!function(e){var c={nonSecure:"8123",secure:"8124"},t={nonSecure:"http://",secure:"https://"},r={nonSecure:"127.0.0.1",secure:"gapdebug.local.genuitec.com"},n="https:"===window.location.protocol?"secure":"nonSecure";script=e.createElement("script"),script.type="text/javascript",script.async=!0,script.src=t[n]+r[n]+":"+c[n]+"/codelive-assets/bundle.js",e.getElementsByTagName("head")[0].appendChild(script)}(document);</script></head>


  <body>
<!--header-->
<div class="agileheader" data-genuitec-lp-enabled="false" data-genuitec-file-id="wc1-4" data-genuitec-path="/WebTest2/WebRoot/login.jsp">
	<h1>LANTING CLOUD NOTES</h1>
</div>
<!--//header-->

<!--main-->
<div class="main-w3l">
<div class="w3layouts-main">
	<h2>Login Now</h2>
	<%
		if(request.getAttribute("relogin")=="true"){
			out.print("<script type=\"application/x-javascript\">alert(\"Login fial , Please check your username or password \");</script>");
		}
	 %>
		<form action="notes.jsp" method="post">
			<input  name="username" type="email" required placeholder="e-mail"/>
			<input  name="password" type="password" required placeholder="password"/>
				<div class="clear"></div>
				<input type="submit" value="login" name="login">
		</form>
		<p>Don't Have an Account ?<a href="register.jsp">Register Now</a></p>
</div>
</div>
<!--//main-->
<!--footer-->
<div class="footer-w3l">
	<p>&copy; 2017 Huweicai QQ:1792663772</p>
</div>
<!--//footer-->
  </body>
