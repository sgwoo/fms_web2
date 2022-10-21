<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*, acar.common.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String save_dt 	= request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector vt2 = ad_db.getSelectStatEndBankDebtListDB_Bank(save_dt);
	int vt_size2 = vt2.size();
	
	Vector vt = ad_db.getSelectStatEndBankDebtListDB(save_dt, vt2);
	int vt_size = vt.size();
	
	/*
	String bank_cd[]	 	= new String[18];
	bank_cd[0]  = "0005";
	bank_cd[1]  = "0001";
	bank_cd[2]  = "0002";
	bank_cd[3]  = "0003";
	bank_cd[4]  = "0004";
	bank_cd[5]  = "0010";
	bank_cd[6]  = "0009";
	bank_cd[7]  = "0018";
	bank_cd[8]  = "0038";
	bank_cd[9]  = "0039";
	bank_cd[10] = "0040";
	bank_cd[11] = "0041";
	bank_cd[12] = "0042";
	bank_cd[13] = "0043";
	bank_cd[14] = "0044";
	bank_cd[15] = "0051";
	bank_cd[16] = "0052";
	bank_cd[17] = "0055";
	*/
	
	
	String bank_cd[]	 	= new String[vt_size2];
	
	for(int i = 0 ; i < vt_size2 ; i++){
		Hashtable ht = (Hashtable)vt2.elementAt(i);
		bank_cd[i]  = String.valueOf(ht.get("BANK_CD"));
	}
	
	int bank_size = bank_cd.length; //bank_cd 배열 사이즈
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
  <input type='hidden' name='save_dt' value='<%=save_dt%>'>
  <table border="0" cellspacing="1" cellpadding="0" width=<%=50+80+(200*bank_size)+200%>>
	<tr>
	  <td align="center"><%=save_dt%> 차입금상환일정표</td>
	</tr>			
	<tr>
	  <td>&nbsp;</td>	  
	</tr>		
	<tr>
		<td class=line2></td>
	</tr>
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>		
				<tr>
				  <td colspan='2' class="title">구분</td>
				  <%for(int j = 0 ; j < bank_size ; j++){%>
				  <td colspan='2' class="title"><%=c_db.getNameById(bank_cd[j], "BANK")%></td>
				  <%}%>
				  <td colspan='2' class="title">합계</td>
				</tr>
				<tr>
				  <td width="50" class="title">연번</td>
				  <td width="80" class="title">귀속년월</td>				  
				  <%for(int j = 0 ; j < (bank_size+1) ; j++){%>
				  <td width="100" class="title">상환</td>
				  <td width="100" class="title">잔액</td>	
				  <%}%>
				</tr>		
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);%>
				<tr>
				  <td class="title"><%=i+1%></td>
				  <td align="center"><%=ht.get("EST_MON")%></td>
				  <%for(int j = 0 ; j < bank_size ; j++){%>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("P_AMT_"+bank_cd[j])))%></td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("R_AMT_"+bank_cd[j])))%></td>
				  <%}%>	
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("P_AMT")))%></td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("R_AMT")))%></td>				  
				</tr>						
				<%	}%>				
			</table>
		</td>
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
