<%@ page language="java" import="java.util.*,java.sql.*,java.io.*,java.net.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>welcom</title>
<!-- Meta tag Keywords -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="refresh" content="4;URL=login.jsp">
<meta name="keywords" content="<ͤ�Ʊʼ�,�Ʊʼ�,��쿲�" />
<script type="application/x-javascript"> addEventListener("load", function() { setTimeout(hideURLbar, 0); }, false);
function hideURLbar(){ window.scrollTo(0,1); } </script>
<!-- Meta tag Keywords -->
<!-- css files -->
<link href="css/style.css" rel="stylesheet" type="text/css" media="all">
</head>

  <body>
<!--header-->
<div class="agileheader">
	<h1>LANTING CLOUD NOTES</h1>
</div>
<!--//header-->
<!--main-->
<div class="main-w3l">
<div class="w3layouts-main">
<%
			String ip=request.getRemoteAddr();
			java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			java.util.Date currentTime = new java.util.Date();
			String date1 = formatter.format(currentTime); 
			String date2 = currentTime.toString(); 
			
			URL url=new URL("http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=&ip="+ip+"&encoding=UTF-8");
			URLConnection con=url.openConnection();
			InputStream in=con.getInputStream();
			byte[] b=new byte[100];
			in.read(b);
			String result1 = new String(b);
			char[] s=result1.toCharArray();
			String result="";
			for(int i=7;i<s.length;i++){
				if(s[i]!='\0'&& !Character.isSpace(s[i]))
					result+=s[i];
			} 
			//Find location by IP
			try{
					Class.forName("com.mysql.jdbc.Driver");
					Connection connection =DriverManager.getConnection("jdbc:mysql://localhost:3306/log?user=root&password=123&use&useUnicode=true&amp;characterEncoding=utf-8");
					PreparedStatement pre=connection.prepareStatement("insert into logs(time,ip,location) values(?,?,?)");
					pre.setString(1, date1+date2);
					pre.setString(2, ip);
					pre.setString(3,result);
					pre.execute();
					pre.close();
					connection.close();
			}catch (Exception e) {
					e.printStackTrace();
					out.print("error!");
					out.print( e.getClass().getName() + ": " + e.getMessage());
		      }
	 %>
	<h2>欢迎您，来自<%=result%>的用户</h2>
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
