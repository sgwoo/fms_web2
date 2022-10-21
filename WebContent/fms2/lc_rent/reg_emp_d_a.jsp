<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_office.*" %>
<jsp:useBean id="coe_bean" class="acar.car_office.CarOffEmpBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");	
	String emp_id = request.getParameter("emp_id")==null?"":request.getParameter("emp_id");
  	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int count = 0;

	if(cmd.equals("d")){
		coe_bean = umd.getCarOffEmpBean(emp_id);
		coe_bean.setUse_yn("N");
		count = umd.updateCarOffEmp(coe_bean);
	}
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table.css"></link>
</head>
<body>
<script language="JavaScript">
<!--
	alert("정상적으로 등록되었습니다.");
	<%if(from_page.equals("car_agent_c.jsp")){%>
		<%if(cmd.equals("d")){%>
			parent.location.reload();
		<%}else{%>	
			parent.opener.location.reload();
			parent.self.close();
		<%}%>	
	<%}%>	
//-->
</script>
</body>
</html>
