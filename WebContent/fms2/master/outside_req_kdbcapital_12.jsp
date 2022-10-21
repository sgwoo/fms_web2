<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String end_dt 	= request.getParameter("end_dt_12")==null?"":request.getParameter("end_dt_12");
	
	Vector vt = ad_db.getOutsideReq12(end_dt);
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
  <table border="1" cellspacing="0" cellpadding="0" width=700>
	<tr>
	  <td colspan="5" align="center">계약번호 연동 계산서 발행현황</td>
	</tr>		
	<tr>
	  <td colspan="5">&nbsp;</td>	  
	</tr>			
	<tr>
	  <td width="100" class="title">발행월</td>
	  <td width="150" class="title">합계</td>
	  <td width="150" class="title">전기차</td>
	  <td width="150" class="title">1년이상</td>
	  <td width="150" class="title">1년미만</td>
	  
    </tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
	<tr>
	  <td align="center"><%=ht.get("TAX_M")%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("E_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT11")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT12")))%></td>
	</tr>
	<%	}%>		
  </table>
</form>
</body>
</html>
