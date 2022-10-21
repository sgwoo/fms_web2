<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String insurmmyy1 	= request.getParameter("insurmmyy1")==null?"":request.getParameter("insurmmyy1");
	String insurgubun 	= request.getParameter("insurgubun")==null?"":request.getParameter("insurgubun");
	
	String settle_year 	= request.getParameter("settle_year")==null?"":request.getParameter("settle_year");
	String table_width	= request.getParameter("table_width")==null?"":request.getParameter("table_width");
	
	
	Vector vt = ad_db.getSettleAccount_list6(insurmmyy1,insurgubun);
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
	  <td colspan="3" align="center"><%=insurmmyy1%> 선급보험료 월별 조회 </td>
	</tr>		
	<tr>
	  <td colspan="3">&nbsp;</td>	  
  </tr>		
	<tr>
		<td class=line2></td>
	</tr>
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>		
			    <tr>
				  <td width="150" class="title">기간비용 차량번호</td>
				  <td width="150" class="title">금액</td>
				  <td width="150" class="title">현재 차량번호(변경시)</td>

			    </tr>
			   
			    <%	for(int i = 0 ; i < vt_size ; i++){
			    Hashtable ht = (Hashtable)vt.elementAt(i);%>
			    <tr>
					  <td align="center"><%=ht.get("CAR_NO")%></td>
					  <td align="right"><%=ht.get("AMT")%></td>
					  <td align="center"><%if(!String.valueOf(ht.get("CAR_NO")).equals(String.valueOf(ht.get("CAR_NO2")))){%><%=ht.get("CAR_NO2")%><%}%></td>
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
