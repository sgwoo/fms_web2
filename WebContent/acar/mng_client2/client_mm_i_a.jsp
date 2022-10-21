<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.client.*"%>
<jsp:useBean id="l_db" scope="page" class="acar.client.ClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body leftmargin="15">
<%
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	ClientMMBean c_mm = new ClientMMBean();
	c_mm.setClient_id(client_id);
	c_mm.setReg_id(request.getParameter("reg_id")==null?"":request.getParameter("reg_id"));
	c_mm.setContent(request.getParameter("content")==null?"":request.getParameter("content"));
	c_mm.setReg_dt(request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt"));
%>
<script language='javascript'>
<%
	if(l_db.insertClientMM(c_mm))
	{
%>
		alert('등록되었습니다');
		parent.location='/acar/mng_client2/client_mm_p.jsp?client_id=<%=client_id%>&auth_rw=R/W';

<%
	}
	else
	{
%>
		alert('등록되지 않았습니다');
<%
	}
%>
</script>
</body>
</html>
