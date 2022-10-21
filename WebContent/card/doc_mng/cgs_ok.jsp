<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String cardno 	= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String buy_id 	= request.getParameter("buy_id")==null?"":request.getParameter("buy_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");

	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	
	user_id = login.getCookieValue(request, "acar_id");
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
function save(){
	var fm = document.form1;
	fm.action = './check_a.jsp';		
	fm.submit();
}

//-->
</script>
</head>
<body>
<form name='form1' action='' method="POST">
<input type="hidden" name="cd_reg_id" value="<%=user_id%>">
<input type="hidden" name="cardno" value="<%=cardno%>">
<input type="hidden" name="buy_id" value="<%=buy_id%>">


<table width=100% border=0 cellpadding=0 cellspacing=0>
	<tr>
		<td width=10%><input type="radio" name="cgs_ok" value="1"> : 예정</td>
		<td width=10%><input type="radio" name="cgs_ok" value="2"> : 수령</td>
		<td width=10%><input type="radio" name="cgs_ok" value="3"> : 미정</td>

	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td colspan="3" align=right>
			<a href="javascript:save();" ><img src=/acar/images/center/button_reg.gif  align=absmiddle  border="0"></a>
		</td>
	</tr>
</table> 
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</form>
</body>

</html>
