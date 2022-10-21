<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ page import="java.util.*, acar.util.*, acar.speedmate.*" %>
<jsp:useBean id="sm_db" scope="page" class="acar.speedmate.SpeedMateDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename="+AddUtil.getDate(4)+"_sk_speedmate_excel.xls");
%>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	Vector vt = sm_db.SpeedMateExcelList(s_kd, st_dt, end_dt);
	int vt_size = vt.size();
	
	long a1 = 0;
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<style>
.xl24
{mso-style-parent tyle0;
mso-number-format:"\@";}
</style>

<form name='form1' action='' method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <table border="1" cellspacing="0" cellpadding="0" width='100%'>
	<tr>
	  <td class="title">법인ID</td>	  
	  <td class="title">조직ID</td>	  	  
	  <td class="title">차고지ID</td>
	  <td class="title">차정ID</td>
	  <td class="title">차량번호</td>
	  <td class="title">연료구분코드</td>			
	  <td class="title">변속기종류코드</td>				  
	  <td class="title">연식년월</td>
	</tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);	%>
	<tr>
	  <td align="center" style="mso-number-format:\@" ><%=String.valueOf(ht.get("법인ID"))%></td>	  
	  <td align="center" style="mso-number-format:\@" ><%=ht.get("조직ID")%></td>	  	  
	  <td align="center"><%=ht.get("차고지ID")%></td>
	  <td align="center"><%=ht.get("차정ID")%></td>
	  <td align="center"><%=ht.get("차량번호")%></td>
	  <td align="center"><%=ht.get("연료구분코드")%></td>	  
	  <td align="center"><%=ht.get("변속기종류코드")%></td>
	  <td align="center"><%=ht.get("연식년월")%></td>
	</tr>
	<%	}%>
  </table>
</form>
<script language='javascript'>
<!--
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
