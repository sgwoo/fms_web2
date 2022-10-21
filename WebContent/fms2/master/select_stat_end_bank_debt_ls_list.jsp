<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String bank_end_dt 	= request.getParameter("bank_end_dt")==null?"":request.getParameter("bank_end_dt");
	String s_var	 	= request.getParameter("s_var")==null?"":request.getParameter("s_var");
	
//	AdminDatabase ad_db = AdminDatabase.getInstance();
	//bank_end_dt = "2015-02-01";
	//s_var = "0057";
	Vector vt = ad_db.getSelectStatEndBankDebtLsList(AddUtil.ChangeDate2(bank_end_dt), s_var);
	int vt_size = vt.size();
	
	if(vt_size == 0){
		out.println("스케줄이 없습니다.");
		return;
	}
	out.println(vt_size);
	//if(1==1)return;
	Hashtable ht1 = (Hashtable)vt.elementAt(0);
	Hashtable ht2 = (Hashtable)vt.elementAt(vt_size-1);
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
  <input type='hidden' name='cont_end_dt' value='<%=bank_end_dt%>'>
  <table border="1" cellspacing="0" cellpadding="0" width=400>
	<tr>
	  <td colspan="2" align="center"><%=bank_end_dt%> 차입금상환일정표</td>
	</tr>		
	<tr>
	  <td colspan="2" ><%=ht1.get("귀속년월")%>~<%=ht2.get("귀속년월")%> (<%=vt_size%>건)</td>	  
	</tr>		
	<tr>
	  <td width="200" class="title">상환</td>
	  <td width="200" class="title">잔액</td>
	</tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
	<tr>
	  <td align="right"><%if(i>0){%><%=Util.parseDecimalLong(String.valueOf(ht.get("상환")))%><%}else{%>0<%}%></td>	  
	  <td align="right"><%=Util.parseDecimalLong(String.valueOf(ht.get("잔액")))%></td>	  	  
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
