<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String next_serv_dt = request.getParameter("next_serv_dt")==null?"":AddUtil.ChangeString(request.getParameter("next_serv_dt"));
	String serv_cng_cau = request.getParameter("serv_cng_cau")==null?"":request.getParameter("serv_cng_cau");
	String h_all = request.getParameter("h_all")==null?"":request.getParameter("h_all");
	
	/* ������ ���� */
	CusReg_Database cr_db = CusReg_Database.getInstance();
	int result = cr_db.modifyScdServ(car_mng_id,serv_id,next_serv_dt,serv_cng_cau,h_all);

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
		alert('�����߻�!');
<%	}else{%>
		alert('ó���Ǿ����ϴ�');
		parent.opener.scd_serv.location="cus_reg_service_in.jsp?car_mng_id=<%=car_mng_id%>";
		parent.close();		
<%	}%>
</script>
</body>
</html>
