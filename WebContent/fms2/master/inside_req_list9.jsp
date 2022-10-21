<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");	
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	Vector vt = ad_db.getInsideReq09(start_dt, end_dt);
	int vt_size = vt.size();
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

<form name='form1' action='' method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='start_dt' value='<%=start_dt%>'>
  <input type='hidden' name='end_dt' value='<%=end_dt%>'>
  <table border="1" cellspacing="0" cellpadding="0" width=400>
	<tr>
	  <td colspan="2" align="center">전기차 매출현황</td>
	</tr>		
	<tr>
	  <td width="150" class="title">계산서 발행월</td>
	  <td width="250" class="title">계산서 공급가</td>
	</tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
	%>
	<tr>
	  <td align="center"><%=ht.get("TAX_M")%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT")))%></td>
	</tr>
	<%	}%>
  </table>
</form>
</body>
</html>