<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String[] actn = request.getParameterValues("pr");
	
	for(int i=0; i<actn.length; i++){
		actn[i] = actn[i].substring(0,6);
	}
	int result = olaD.setOffls_actn(actn);
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%	if(result >= 1){%>
	alert("등록되었습니다.\n자동차 경매 위탁관리 화면에서 확인 하시기 바랍니다.");
	window.top.frames["d_content"].location = "/acar/off_ls_pre/off_ls_pre_frame.jsp?auth_rw=<%=auth_rw%>";
	//parent.parent.location.href = "/acar/off_ls_pre/off_ls_pre_frame.jsp?auth_rw=<%=auth_rw%>";
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	//parent.parent.location.href = "off_lease_frame.jsp?auth_rw=<%=auth_rw%>";
<%}%>
//-->
</script>
</body>
</html>
