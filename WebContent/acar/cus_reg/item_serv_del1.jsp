<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");		
	String[] seqs = request.getParameterValues("pr");
	String del = request.getParameter("del")==null?"":request.getParameter("del");
	int result = 0;
//System.out.println("c="+car_mng_id);
//System.out.println("s="+serv_id);

	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	if(del.equals("all")){
		result = cr_db.delServ_item_all(car_mng_id, serv_id);		
	}else{
		result = cr_db.delServ_item(car_mng_id, serv_id, seqs);
	}
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%	if(result >0){%>
	alert("�����Ǿ����ϴ�!");		
//	parent.location.reload();
	parent.item_serv_in.location.reload();	
	
<%}else{%>
	alert("�����ͺ��̽��� ������ �߻��Ͽ����ϴ�.\n �����ڴԲ� �����ϼ��� !");
		
<%}%>
//-->
</script>
</body>
</html>
