<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");

	

	/* ������ �߰� */
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
		alert("�������� �߰����� �ʾҽ��ϴ�");
		location='about:blank';
		
<%	}else{		%>		
		alert("�������� �߰��Ǿ����ϴ�");
		parent.scd_serv.location.href="cus_reg_service_in.jsp?car_mng_id=<%=car_mng_id%>";
<%	}			%>
</script>
</body>
</html>