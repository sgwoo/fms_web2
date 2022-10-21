<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String debt_end_dt 	= request.getParameter("debt_end_dt")==null?"":AddUtil.replace(request.getParameter("debt_end_dt"),"-","");
	
	//debt_end_dt 2021-05
	int days 	= AddUtil.getMonthDate(AddUtil.parseInt(debt_end_dt.substring(0,4)), AddUtil.parseInt(debt_end_dt.substring(4,6)));
	
	Vector vt = ad_db.getSelectAccountEstDebtList(debt_end_dt);
	int vt_size = vt.size();
	
	long sum_amt[]	= new long[3];
		
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
function save()
{
	var fm = document.form1;
	fm.target = '_blank';
	fm.action = 'select_account_est_debt_list_excel.jsp';
	fm.submit();
}			
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
  <input type='hidden' name='debt_end_dt' value='<%=debt_end_dt%>'>
  <table border=0 cellspacing=0 cellpadding=0 width=450>
    <tr>
      <td><a href="javascript:save()"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a></td>
    </tr>
    <tr>
      <td> </td>
    </tr>
  </table>
  <table border="1" cellspacing="0" cellpadding="0" width=450>
  
    	<tr>
	  <td width="100"  rowspan='2' class="title">귀속년월</td>
	  <td width="50" rowspan='2' class="title">일자</td>
	  <td colspan='3' class="title">상환예정금액</td>
	</tr>
	<tr>
	  <td width="100" class="title">소계</td>
	  <td width="100" class="title">원금</td>
	  <td width="100" class="title">이자</td>
	</tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			sum_amt[0] = sum_amt[0] + AddUtil.parseLong((String)ht.get("원금"));
			sum_amt[1] = sum_amt[1] + AddUtil.parseLong((String)ht.get("이자"));
			sum_amt[2] = sum_amt[2] + AddUtil.parseLong((String)ht.get("금액"));
	%>
	<tr>
	  <%if(i==0){ %><td rowspan='<%=days%>' class="title"><%=AddUtil.getDate3(debt_end_dt)%></td><%} %>	  
	  <td align="center"><%=ht.get("DAY")%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("금액")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("원금")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("이자")))%></td>	  
	</tr>
	<%	}%>
	<tr>
	  <td colspan='2' class="title">합계</td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[2])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[0])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[1])%></td>
	</tr>	
	
  </table>
</form>
</body>
</html>
