<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String first_vst_dt = AddUtil.ChangeString(request.getParameter("first_vst_dt"));
	int cycle_vst_mon = AddUtil.parseInt(request.getParameter("cycle_vst_mon"));
	int cycle_vst_day = AddUtil.parseInt(request.getParameter("cycle_vst_day"));
	int tot_vst = AddUtil.parseInt(request.getParameter("tot_vst"));

	
	/* 스케줄 생성 */
	CusReg_Database cr_db = CusReg_Database.getInstance();
	int result = cr_db.createScdVst(client_id,first_vst_dt,cycle_vst_mon,cycle_vst_day,tot_vst);
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
		alert("스케줄이 등록되지 않았습니다");
		location='about:blank';
		
<%	}else{		%>		
		alert("스케줄이 등록되었습니다");
		parent.scd_vst.location.href="cus_reg_visit_in.jsp?client_id=<%=client_id%>";
<%	}			%>
</script>
</body>
</html>