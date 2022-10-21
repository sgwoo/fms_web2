<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.cus0601.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	int count = -1;
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");

	Cus0601_Database c61_db = Cus0601_Database.getInstance();
	count = c61_db.deleteServOff(off_id);
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function NullAction(){
	<% if(count>0){ %>
		alert("정상적으로 삭제되었습니다.");
	<% }else{ %>
		alert("데이터베이스에 문제가 발생하였읍니다.\n관리자님께 문의바랍니다.");
	<% } %>

	var theForm = document.form1;
	theForm.target="c_body";
	theForm.submit();
	window.location="about:blank";

}
//-->
</script>
</head>
<body onLoad="javascript:NullAction()">
<form name="form1" method="post" action="cus0601_sc.jsp">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="s_kd" value="<%= s_kd %>">
<input type="hidden" name="t_wd" value="<%= t_wd %>">
<input type="hidden" name="sort_gubun" value="<%= sort_gubun %>">
<input type="hidden" name="sort" value="<%= sort %>">
</form>
</body>
</html>