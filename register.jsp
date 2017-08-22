<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>注册</title>
<!-- Meta tag Keywords -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="keywords" content="register" />
<script type="application/x-javascript"> addEventListener("load", function() { setTimeout(hideURLbar, 0); }, false);
function hideURLbar(){ window.scrollTo(0,1); } </script>
<!-- Meta tag Keywords -->
<!-- css files -->
<link href="css/style.css" rel="stylesheet" type="text/css" media="all">
<script type="application/x-javascript">
function compare(){
var a=document.getElementById('p1').value;
var b=document.getElementById('p2').value;
if(a!=b){
alert("两次密码不一致");
document.getElementById('p1').value="";
document.getElementById('p2').value="";
}
}
</script>
	<%
		if(request.getAttribute("fail")=="true"){
			out.print("<script type=\"application/x-javascript\">alert(\"E-mail has been used , please tyr another \");</script>");
		}
	 %>
  <script>!function(e){var c={nonSecure:"8123",secure:"8124"},t={nonSecure:"http://",secure:"https://"},r={nonSecure:"127.0.0.1",secure:"gapdebug.local.genuitec.com"},n="https:"===window.location.protocol?"secure":"nonSecure";script=e.createElement("script"),script.type="text/javascript",script.async=!0,script.src=t[n]+r[n]+":"+c[n]+"/codelive-assets/bundle.js",e.getElementsByTagName("head")[0].appendChild(script)}(document);</script></head>
  
  <body>
    <!--header-->
<div class="agileheader" data-genuitec-lp-enabled="false" data-genuitec-file-id="wc1-6" data-genuitec-path="/WebTest2/WebRoot/register.jsp">
	<h1>LANTING CLOU NOTES</h1>
</div>
<!--//header-->

<!--main-->
<div class="main-w3l">
<div class="w3layouts-main">
	<h2>register Now</h2>
		<form action="registerOp.jsp" method="post">
			<input  name="username" type="email" required placeholder="e-mail"/>
			<input  id="p1" name="password" type="password" required placeholder="please input your password"/>
            <input  id="p2"name="password" type="password" required placeholder="please confirm password" onBlur="compare()"/>
				<div class="clear"></div>
				<input type="submit" value="Register" name="register">
		</form>
		<p>Already registed ?<a href="login.jsp">Login Now</a></p>
</div>
</div>
<!--//main-->

<!--footer-->
<div class="footer-w3l">
	<p>&copy; 2017 Huweicai</p>
</div>
<!--//footer-->
  </body>
</html>
