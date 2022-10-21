<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	
	String mon_amt = request.getParameter("mon_amt")==null?"":request.getParameter("mon_amt");	
	String save_dt  = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");	
	String cpt_cd = request.getParameter("cpt_cd")==null?"":request.getParameter("cpt_cd");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");	
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이					
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language='javascript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
function enter(){
	var keyValue = event.keyCode;
	if (keyValue =='13') search();
}
function search(){
	var fm = document.form1;
	fm.submit();
}
//-->
</script>
</head>

<body>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<form name='form1' method='post' action='servemp_ds_sc.jsp' target='dsc_body'>
<input type="hidden" name="auth_rw" value="<%= auth_rw %>">
<input type="hidden" name="off_id" value="<%= off_id %>">
<input type="hidden" name="mon_amt" value="<%= mon_amt %>">
<input type="hidden" name="save_dt" value="<%= save_dt %>">
<input type="hidden" name="cpt_cd" value="<%= cpt_cd %>">
<input type="hidden" name="gubun1" value="<%= gubun1 %>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 

</form>
</table>
</body>
</html>
