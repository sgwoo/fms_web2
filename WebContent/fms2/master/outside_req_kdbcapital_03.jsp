<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	

	Vector vt = ad_db.getOutsideReq03(end_dt);
	int vt_size = vt.size();
	
	long sum0 = 0;
	long sum1 = 0;
	long sum2 = 0;
	long sum3 = 0;
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
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='end_dt' value='<%=end_dt%>'>
  <table border="1" cellspacing="0" cellpadding="0" width=1050>
	<tr>
	  <td colspan="7" align="center">대여료연체리스트</td>
	</tr>		
	<tr>
	  <td>&nbsp;</td>	  
	  <td colspan="4">&nbsp;</td>	  
	  <td colspan="2">&nbsp;</td>	  
	</tr>		
	<tr>
	  <td width="50" class="title">연번</td>
	  <td width="400" class="title">상호</td>
	  <td width="200" class="title">차명</td>
	  <td width="100" class="title">차량번호</td>
	  <td width="100" class="title">연체개월</td>
	  <td width="100" class="title">연체금액</td>
	  <td width="100" class="title">비고</td>
	</tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			sum2  = sum2  + Util.parseLong(String.valueOf(ht.get("AMT")));%>
	<tr>
	  <td class="title"><%=i+1%></td>
	  <td align="center"><%=ht.get("FIRM_NM")%></td>
	  <td align="center"><%=ht.get("CAR_NM")%></td>
	  <td align="center"><%=ht.get("CAR_NO")%></td>
	  <td align="center"><%=ht.get("CNT")%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("AMT")))%></td>
	  <td align="right">&nbsp;</td>
	</tr>
	<%	}%>
	<tr>
	  <td colspan="5" align="center">합계</td>	  
	  <td align="right"><%=Util.parseDecimal(sum2)%></td>
	  <td align="right">&nbsp;</td>	  
	</tr>			
  </table>
</form>
<script language='javascript'>
<!--
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
