<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = "";
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function SearchIP()
{
	var theForm = document.IPSearchForm;
	theForm.target = "c_foot";
	theForm.submit();
}
//-->
</script>
</head>
<body>


<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<form action="./ip_s_sc.jsp" name="IPSearchForm" method="POST" target="c_foot">
    <tr>
		<td>
			<font color="navy">MASTER -> </font><font color="red">IP ����</font>
		</td>
	</tr>
	<tr>
		<td>
			<!--table border="0" cellspacing="1" cellpadding="0">
				<tr>
					<td>�˻� : </td>
					<td> 
						<select name="gubun" onChange="javascript:document.BbsSearchForm.gubun_nm.focus()">
							<option value="">��ü</option>
							<option value="title">����</option>
							<option value="content">����</option>
							<option value="user_nm">�ۼ���</option>
							<option value="reg_dt">��¥	</option>
						</select>
					</td>
					<td><input type='text' name="gubun_nm" size='15' class='text'></td>
					<td><a href="javascript:SearchIP()">�˻�</a></td>
				</tr>
			</table-->
			<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
		</td>
	</tr>
</form>

</table>
</body>
</html>