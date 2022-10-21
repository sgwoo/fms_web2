<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String end_dt 	= request.getParameter("end_dt_07")==null?"":request.getParameter("end_dt_07");
	
//	AdminDatabase ad_db = AdminDatabase.getInstance();
	
	Vector vt = ad_db.getOutsideReq07_20110518(end_dt);
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
  <table border="0" cellspacing="1" cellpadding="0" width=250>
	<tr>
	  <td colspan="12" align="center">대여만기예정현황(진행) </td>
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
				  <td width="100" class="title">년월</td>
				  <td width="100" class="title">건수</td>
				</tr>

				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
						sum0  = sum0  + Util.parseLong(String.valueOf(ht.get("CNT")));
			%>
				<tr>
				  <td class="title"><%=i+1%></td>
				  <td align="center"><%=ht.get("YM")%></td>
				  <td align="right"><%=ht.get("CNT")%></td>
				</tr>
				<%	}%>
				<tr>
				  <td class="title" colspan='2'>합계</td>
				  <td align="right"><%=Util.parseDecimal(sum0)%></td>
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
