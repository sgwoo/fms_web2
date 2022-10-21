<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String fee_pay_dt 	= request.getParameter("fee_pay_dt")==null?"":request.getParameter("fee_pay_dt");
	
	Vector vt = ad_db.getSelectAccountEstFeePayList(fee_pay_dt);
	int vt_size = vt.size();
	
	Vector vt2 = ad_db.getSelectAccountEstFeeCmsList(fee_pay_dt);
	int vt_size2 = vt2.size();
	
	long sum = 0;
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
  <input type='hidden' name='cont_end_dt' value='<%=fee_pay_dt%>'>
  <table border="1" cellspacing="0" cellpadding="0" width=400>
	<tr>
	  <td colspan="3" align="center"><%=fee_pay_dt%> 대여료 입금 리스트</td>
	</tr>		
	<tr>
	  <td>&nbsp;</td>	  
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	</tr>		
	<tr>
	  <td width="50" class="title">연번</td>
	  <td width="150" class="title">일자</td>
	  <td width="200" class="title">금액</td>
	</tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
	<tr>
	  <td class="title"><%=i+1%></td>
	  <td align="center"><%=ht.get("일자")%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("금액")))%></td>
	</tr>
	<%	}%>
	
	<tr>
	  <td>&nbsp;</td>	  
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	</tr>			
	<tr>
	  <td colspan="3" align="center"><%=fee_pay_dt%> CMS 입금 리스트</td>
	</tr>			
	<tr>
	  <td>&nbsp;</td>	  
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	</tr>		
	<tr>
	  <td width="50" class="title">연번</td>
	  <td width="150" class="title">일자</td>
	  <td width="200" class="title">금액</td>
	</tr>
	<%	for(int i = 0 ; i < vt_size2 ; i++){
			Hashtable ht = (Hashtable)vt2.elementAt(i);%>
	<tr>
	  <td class="title"><%=i+1%></td>
	  <td align="center"><%=ht.get("일자")%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("금액")))%></td>
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
