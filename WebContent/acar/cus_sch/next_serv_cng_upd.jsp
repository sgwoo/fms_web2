<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp"%>
<%
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String next_serv_dt = request.getParameter("next_serv_dt")==null?"":AddUtil.ChangeString(request.getParameter("next_serv_dt"));
	String next_rep_cont = request.getParameter("next_rep_cont")==null?"":request.getParameter("next_rep_cont");	
		
	ServInfoBean siBn = new ServInfoBean();
	siBn.setCar_mng_id(car_mng_id);
	siBn.setServ_id(serv_id);
	siBn.setNext_serv_dt(next_serv_dt);
	siBn.setNext_rep_cont(next_rep_cont);

	CusReg_Database cr_db = CusReg_Database.getInstance();
	int result = cr_db.updateService(siBn);
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%if(result>0){%>
	alert("해당 일자로 수정 되었습니다.");
	parent.opener.location.reload();
	parent.window.close();
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");					
<%}%>
//-->
</script>
</body>
</html>
