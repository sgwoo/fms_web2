<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");

	

	/* 스케줄 추가 */
	CusReg_Database cr_db = CusReg_Database.getInstance();
	int result = cr_db.extendScdServ(car_mng_id);
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>

<body>
<script language='javascript'>
<%	if(result <= 0){%>
		alert("스케줄이 추가되지 않았습니다");
		location='about:blank';
		
<%	}else{		%>		
		alert("스케줄이 추가되었습니다");
		parent.scd_serv.location.href="cus_reg_service_in.jsp?car_mng_id=<%=car_mng_id%>";
<%	}			%>
</script>
</body>
</html>