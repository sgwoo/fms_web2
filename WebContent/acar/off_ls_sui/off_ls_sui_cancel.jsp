<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String[] sui = request.getParameterValues("pr");

	int result = olsD.cancelOffls_sui(sui);
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%	if(result >= 1){%>
	alert("취소 되었습니다.\n상품관리 화면에서 확인 하시기 바랍니다.");
	parent.parent.parent.d_content.location.href = "off_ls_sui_frame.jsp?auth_rw=<%=auth_rw%>";
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	parent.parent.parent.d_content.location.href = "off_ls_sui_frame.jsp?auth_rw=<%=auth_rw%>";
<%}%>
//-->
</script>
</body>
</html>
