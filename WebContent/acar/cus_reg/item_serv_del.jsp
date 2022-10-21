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
	alert("삭제되었습니다!");
	parent.inner4.location.reload();
	parent.opener.item_serv_in.location.reload();
	parent.window.close();
	//parent.inner4.location.href = "item_serv.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&serv_id=<%=serv_id%>";
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	parent.inner4.location.reload();
	parent.window.close();
	//parent.inner4.location.href = "item_serv.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&serv_id=<%=serv_id%>";
<%}%>
//-->
</script>
</body>
</html>
