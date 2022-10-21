<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String car_end_dt 	= request.getParameter("car_end_dt")==null?"":request.getParameter("car_end_dt");
	
//	AdminDatabase ad_db = AdminDatabase.getInstance();
	
	Vector vt = ad_db.getSelectStatEndCarList(car_end_dt);
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
  <input type='hidden' name='cont_end_dt' value='<%=car_end_dt%>'>
  <table border="0" cellspacing="1" cellpadding="0" width=750>
	<tr>
	  <td colspan="5" align="center"><%=car_end_dt%> ������Ȳ</td>
	</tr>		
	<tr>
	  <td>&nbsp;</td>	  
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>	  
	  <td>&nbsp;</td>
	</tr>		
	<tr>
		<td class=line2></td>
	</tr>
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>		
				<tr>
				  <td width="50" class="title">����</td>
				  <td width="400" class="title">����</td>
				  <td width="100" class="title">������ȣ</td>
				  <td width="100" class="title">�����</td>
				  <td width="100" class="title">���</td>	  
				</tr>
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);%>
				<tr>
				  <td class="title"><%=i+1%></td>
				  <td align="center"><%=ht.get("����")%></td>
				  <td align="center"><%=ht.get("������ȣ")%></td>
				  <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("�����")))%></td>
				  <td align="center"><%=ht.get("���")%></td>	  
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
