<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=settle_account_list_excel9.xls");
%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String settle_year 	= request.getParameter("settle_year")==null?"":request.getParameter("settle_year");
	String table_width	= request.getParameter("table_width")==null?"":request.getParameter("table_width");
	
	
	Vector vt = ad_db.getSettleAccount_list9(settle_year);
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
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='settle_year' value='<%=settle_year%>'>
<table border="0" cellspacing="1" cellpadding="0" width=<%=table_width%>>
	<tr>
	  <td colspan="7" align="center"><%=settle_year%>년 대여료 세금계산서 발행분중 미입금리스트</td>
	</tr>
	<tr>
	  <td colspan="7">&nbsp;</td>
    </tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>		
			  <tr>
				  <td width="50" class="title" rowspan='2'>연번</td>
				  <td width="300" class="title" rowspan='2'>상호</td>
				  <td width="100" class="title" rowspan='2'>사업자번호<br>생년월일</td>
				  <td width="50" class="title" rowspan='2'>건수</td>
				  <td width="100" class="title" rowspan='2'>금액</td>
				  <td colspan='2' class="title">입금예정일</td>
			  </tr>
			  <tr>
				  <td width="100" class="title">최소일자</td>
				  <td width="100" class="title">최대일자</td>
			  </tr>
			  <%for(int i = 0 ; i < vt_size ; i++){
			   		Hashtable ht = (Hashtable)vt.elementAt(i);%>
			  <tr>
				  <td align="center"><%=i+1%></td>
				  <td align="center"><%=ht.get("RECCONAME")%></td>
				  <td align="center"><%=ht.get("RECCOREGNO")%></td>
				  <td align="right"><%=ht.get("CNT")%></td>
				  <td align="right"><%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("SUM_AMT"))))%></td>
				  <td align="center"><%=ht.get("MIN_DT")%></td>
				  <td align="center"><%=ht.get("MAX_DT")%></td>
			  </tr>
			  <%}%>
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
