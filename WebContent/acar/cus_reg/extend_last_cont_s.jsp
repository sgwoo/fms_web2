<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String first_serv_dt = AddUtil.ChangeString(request.getParameter("first_serv_dt"));
	int cycle_serv_mon = AddUtil.parseInt(request.getParameter("cycle_serv_mon"));
	int cycle_serv_day = AddUtil.parseInt(request.getParameter("cycle_serv_day"));
	int tot_serv = AddUtil.parseInt(request.getParameter("tot_serv"));

	
	/* 스케줄 생성 */
	CusReg_Database cr_db = CusReg_Database.getInstance();
	int result = cr_db.extend_last_cont_s(car_mng_id,first_serv_dt,cycle_serv_mon,cycle_serv_day,tot_serv);
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
		alert("스케줄이 등록되지 않았습니다.\n관리자님께 문의하시기 바랍니다.");
		location='about:blank';
		
<%	}else{		%>		
		alert("스케줄이 등록되었습니다");
		parent.scd_serv.location.href="cus_reg_service_in.jsp?car_mng_id=<%=car_mng_id%>";
<%	}			%>
</script>
</body>
</html>