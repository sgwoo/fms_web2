<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cus_bus.*"%>
<%@ include file="/acar/cookies.jsp"%>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String mng_id = request.getParameter("mng_id")==null?"":request.getParameter("mng_id");
	String mode = request.getParameter("mode")==null?"1":request.getParameter("mode");
	
	CusBus_Database cb_db = CusBus_Database.getInstance();
	int result = cb_db.setMng_id(rent_mng_id, rent_l_cd, mng_id, mode);
	
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%if(result>0){%>
	alert("��ϵǾ����ϴ�.");	
	parent.opener.location.reload();
	parent.window.close();
<%}else{%>
	alert("�����ͺ��̽��� ������ �߻��Ͽ����ϴ�.\n �����ڴԲ� �����ϼ��� !");					
<%}%>
//-->
</script>
</body>
</html>
