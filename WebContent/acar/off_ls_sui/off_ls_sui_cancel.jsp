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
	alert("��� �Ǿ����ϴ�.\n��ǰ���� ȭ�鿡�� Ȯ�� �Ͻñ� �ٶ��ϴ�.");
	parent.parent.parent.d_content.location.href = "off_ls_sui_frame.jsp?auth_rw=<%=auth_rw%>";
<%}else{%>
	alert("�����ͺ��̽��� ������ �߻��Ͽ����ϴ�.\n �����ڴԲ� �����ϼ��� !");
	parent.parent.parent.d_content.location.href = "off_ls_sui_frame.jsp?auth_rw=<%=auth_rw%>";
<%}%>
//-->
</script>
</body>
</html>
