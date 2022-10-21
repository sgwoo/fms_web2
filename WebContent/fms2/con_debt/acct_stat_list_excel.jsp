<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=acct_stat_list_excel.xls");
%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
		
	Vector vt = ad_db.getSettleAccount_list4_2016(gubun1, "client", "Y", gubun2);  //네오엠과 차액 표시
	int vt_size = vt.size();
		
	long total_amt1	= 0;
	long total_amt2	= 0;
	long total_amt3	= 0;
	long total_amt4	= 0;
	long total_amt5	= 0;
	

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
  <input type='hidden' name='gubun1' value='<%=gubun1%>'>
  <table border="0" cellspacing="1" cellpadding="0" width=90%>
	<tr>
	  <td align="center"><% if ( gubun2.equals("1") ) { %>(네오엠기준)<% } else {%>(FMS기준)<% } %></td>
	</tr>		
	<tr>
	  <td>&nbsp;</td>	  
    </tr>		
	<tr>
		<td class=line2></td>
	</tr>
	<tr> 
		<td class=line>
			<table border=1 cellspacing=1 width=100%>
			    <tr>
			      <td width="50" class="title">연번</td>
				  <td width="320" class="title">거래처명</td>
				  <td width="120" class="title">사업자번호</td>
				  <td width="120" class="title">보증금액</td>
				  <td width="120" class="title">입금액</td>
				  <td width="120" class="title">차액</td>
				  <td width="120" class="title">네오엠</td>
				  <td width="120" class="title">네오엠 차액</td>
				  <td width="120" class="title">네오엠코드</td>
				  
			    </tr>
			    <%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);					
					total_amt1	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("GRT_AMT")));					
					total_amt2	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("PAY_AMT")));
					total_amt3	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT")));
					total_amt4	= total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("ACCT_AMT")));
			    %>
			    <tr>
				  <td class="title"><%=i+1%></td>
				  <td align="center"><%=ht.get("FIRM_NM")%></td>
				  <td align="center"><%=AddUtil.ChangeEnp(String.valueOf(ht.get("ENP_NO")))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("GRT_AMT"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("PAY_AMT"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("DLY_AMT"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("ACCT_AMT"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("CAL_AMT"))))%></td>
				  <td align="right"><%=ht.get("ACCT_CODE")%></td>
				  
			    </tr>
			    <%	}%>	
			    <tr> 
				  <td class="title">&nbsp;</td>
				  <td class="title">&nbsp;</td>
				  <td class="title">&nbsp;</td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2)%></td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt3)%></td>
				  <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt4)%></td>
				  <td class="title" style='text-align:right'></td>
				  <td class="title">&nbsp;</td>
			    </tr>		    
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


