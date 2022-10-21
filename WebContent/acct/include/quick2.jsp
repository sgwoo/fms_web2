<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.beans.*, acar.ma.*"%>

<%
	String height = request.getParameter("height")==null?"":request.getParameter("height");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>:: NEW FMS(Fleet Management System) ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="main.css">
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="162" height="<%=height%>" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td height="61" valign="top"><a href="http://www.hyundai-motor.com/main.html" target="_blank"><img src="images/main/be_01.gif" width="162" height="51" border="0"></a></td>
  </tr>
  <tr>
    <td height="61" valign="top"><a href="http://www.kia.co.kr/" target="_blank"><img src="images/main/be_02.gif" width="162" height="51" border="0"></a></td>
  </tr>
  <tr>
    <td height="61" valign="top"><a href="http://www.renaultsamsungm.com/NewJsp/index.jsp" target="_blank"><img src="images/main/be_03.gif" width="162" height="51" border="0"></a></td>
  </tr>
  <tr>
    <td height="61" valign="top"><a href="http://www.gmdaewoo.co.kr/kor/index.jsp" target="_blank"><img src="images/main/be_04.gif" width="162" height="51" border="0"></a></td>
  </tr>
  <tr>
    <td height="61" valign="top"><a href="http://www.smotor.com/kr/index.jsp" target="_blank"><img src="images/main/be_05.gif" width="162" height="51" border="0"></a></td>
  </tr>
  <tr>
    <td bgcolor="E6E4E5"> 
       <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr> 
            
          <td bgcolor="#FFFFFF" align="center" height="200"><font size="2">리콜</font></td>
          </tr>
        </table>
      </td>
  </tr>  
</table>
</body>
</html>
