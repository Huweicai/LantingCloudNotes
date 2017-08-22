 <%@ page language="java" import="java.util.*,java.sql.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>兰亭云笔记</title>
<!-- Meta tag Keywords -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="keywords" content="兰亭云笔记,云笔记" />
<script type="application/x-javascript"> addEventListener("load", function() { setTimeout(hideURLbar, 0); }, false);
function hideURLbar(){ window.scrollTo(0,1); } </script>
<!-- Meta tag Keywords -->
<!-- css files -->
<link href="css/style.css" rel="stylesheet" type="text/css" media="all">

  <script>!function(e){var c={nonSecure:"8123",secure:"8124"},t={nonSecure:"http://",secure:"https://"},r={nonSecure:"127.0.0.1",secure:"gapdebug.local.genuitec.com"},n="https:"===window.location.protocol?"secure":"nonSecure";script=e.createElement("script"),script.type="text/javascript",script.async=!0,script.src=t[n]+r[n]+":"+c[n]+"/codelive-assets/bundle.js",e.getElementsByTagName("head")[0].appendChild(script)}(document);</script></head>
  
  <body>
  <%
			try{
					Class.forName("com.mysql.jdbc.Driver");
					Connection connection =DriverManager.getConnection("jdbc:mysql://localhost:3306/userdb?user=root&password=123&use&useUnicode=true&amp;characterEncoding=utf-8");
					Statement s=connection.createStatement();
					String username=request.getParameter("username");
					String password=request.getParameter("password");
					session.setAttribute("name", username);//session保存用户邮箱
					////我这里有一个超级大的疑问？？？？？两次跳转request怎么算呢
					ResultSet rs=s.executeQuery("select * from user where username=\""+username+"\" and password=\""+password+"\"");
						if(rs.next()){
							pageContext.setAttribute("notes", rs.getString("notes"));
						}else{
							//如果用户名或者密码错误，重定向回登录界面，所以该页面无法被直接访问
							request.setAttribute("relogin", "true");
							RequestDispatcher rd=request.getRequestDispatcher("login.jsp");
							rd.forward(request,response);
						}
						s.close();
						connection.close();
						request.setCharacterEncoding("utf-8");
			}catch (Exception e) {
					e.printStackTrace();
					out.print("error!");
					out.print( e.getClass().getName() + ": " + e.getMessage());
		      }
	 %>
<div class="agileheader" data-genuitec-lp-enabled="false" data-genuitec-file-id="wc1-5" data-genuitec-path="/WebTest2/WebRoot/notes.jsp">
	<h1>LANTING CLOUD NOTES</h1>
</div>
<!--//header-->

<!--main-->
<div class="main-w3l">
<div class="w3layouts-main">
	<h2>WRITE DOWN WHAT YOU ARE THINKING</h2>
		<form action="save.jsp" method="post">
		<!--  rows="20" -->
          <textarea  name="text" style="width:90%; height:60%" autofocus required  ><%=pageContext.getAttribute("notes") %></textarea>
          <br/>
		  <input type="submit" value="SAVE" name="save">
		</form>
</div>
</div>
<!--//main-->

<!--footer-->
<div class="footer-w3l">
	<p>&copy;  2017 uweicai</p>
</div>
<!--//footer-->
  </body>
</html>
