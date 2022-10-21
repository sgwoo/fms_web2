<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.offls_actn.*"%>
<jsp:useBean id="olaBean" class="acar.offls_actn.Offls_actnBean" scope="page"/>
<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<script language="javascript">
<!--
function view_detail(seq){

	parent.c_body.location.href = "off_ls_jh_actn_mng.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&seq="+seq;
	parent.st_foot.location.href = "off_ls_jh_sc_in_nodis.jsp";
}
//-->
</script>
<body bgcolor="#FFFFFF" text="#000000" >
<form name="form1" action="" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
    	<td><iframe src="./off_ls_jh_actn_mng_list_in.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>" name="inner" width="100%" height="140" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
	</tr>
</table>
</form>
</body>
</html>
