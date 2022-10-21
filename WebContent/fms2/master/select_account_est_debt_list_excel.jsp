<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
String debt_end_dt 	= request.getParameter("debt_end_dt")==null?"":AddUtil.replace(request.getParameter("debt_end_dt"),"-","");

response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=select_account_est_debt_list_excel_"+debt_end_dt+".xls");
%>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
		
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
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
</head>
<body>
  <table border="1" cellspacing="0" cellpadding="0" width=450>
  	<tr>
	  <td width="100"  rowspan='2' align="center">귀속년월</td>
	  <td width="50" rowspan='2' align="center">일자</td>
	  <td colspan='3' align="center">상환예정금액</td>
	</tr>
	<tr>
	  <td width="100" align="center">소계</td>
	  <td width="100" align="center">원금</td>
	  <td width="100" align="center">이자</td>
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
	  <td colspan='2' align="center">합계</td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[2])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[0])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[1])%></td>
	</tr>		
  </table>
</body>
</html>
