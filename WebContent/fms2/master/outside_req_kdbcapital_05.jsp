<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
//	AdminDatabase ad_db = AdminDatabase.getInstance();
	
	Vector vt = ad_db.getOutsideReq05_20110517();
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
  <table border="0" cellspacing="1" cellpadding="0" width=650>
	<tr>
	  <td colspan="12" align="center">대여료연체현황 </td>
	</tr>		
	<tr>
	  <td>&nbsp;</td>	  
	  <td colspan="7">&nbsp;</td>	  
	  <td>&nbsp;</td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>		
				<tr>
				  <td width="50" class="title">연번</td>
				  <td width="200" class="title">게약자</td>
				  <td width="100" class="title">차량번호</td>
				  <td width="150" class="title">연체금액</td>
				  <td width="150" class="title">미도래총금액(연체분제외)</td>
				</tr>

				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						sum0  = sum0  + Util.parseLong(String.valueOf(ht.get("TOT_AMT3")));
						sum1  = sum1  + Util.parseLong(String.valueOf(ht.get("AMT4")));
			%>
				<tr>
				  <td class="title"><%=i+1%></td>
				  <td align="center"><%=ht.get("FIRM_NM")%></td>
				  <td align="center"><%=ht.get("CAR_NO")%></td>
				  <td align="right"><%=ht.get("TOT_AMT3")%></td>
				  <td align="right"><%=ht.get("AMT4")%></td>
				</tr>
				<%	}%>
				<tr>
				  <td class="title" colspan='3'>합계</td>
				  <td align="right"><%=Util.parseDecimal(sum0)%></td>
	  			  <td align="right"><%=Util.parseDecimal(sum1)%></td>
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
