<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<jsp:useBean id="olyD" class="acar.offls_yb.Offls_ybDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String[] car = request.getParameterValues("pr");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");	

	int result = olyD.setPrepareC(car);
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>
<body>
<script language="JavaScript">
<!--
<%if(result >= 1){%>
	alert("�����Ͻ� ������ �縮�� ���� �����Ǿ����ϴ�.");
	window.top.frames["d_content"].location = "/acar/off_lease/off_lease_frame.jsp?auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>";
	//parent.parent.location.href = "/acar/off_lease/off_lease_frame.jsp?auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>";
<%}else{%>
	alert("�����ͺ��̽��� ������ �߻��Ͽ����ϴ�.\n �����ڴԲ� �����ϼ��� !");
	window.top.frames["d_content"].location = "/acar/off_lease/off_lease_frame.jsp?auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>";
	//parent.c_foot.inner.location.href = "/acar/off_lease/off_lease_frame.jsp?auth_rw=<%=auth_rw%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>";
<%}%>
//-->
</script>
</body>
</html>
