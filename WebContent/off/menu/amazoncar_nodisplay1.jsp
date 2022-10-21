<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*" %>
<%@ include file="/off/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String acar_id = request.getParameter("acar_id")==null?"":request.getParameter("acar_id");
	int bbs_id = request.getParameter("bbs_id")==null?0:Util.parseInt(request.getParameter("bbs_id"));
	int count = 0;
	
	OffAncDatabase oad = OffAncDatabase.getInstance();
	count = oad.readChkAnc(bbs_id, acar_id);
%>
<html>
<HEAD>
<title>FMS</title>
<script language='javascript'>
<!--
	//parent.document.all.inner.src='amazoncar_main_in1.jsp?auth_rw=<%=auth_rw%>';
//-->
</script>
<head>
<body></body>
</html>
