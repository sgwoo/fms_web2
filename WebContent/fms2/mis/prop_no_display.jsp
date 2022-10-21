<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.* "%>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String save_dt =  request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
		
	String bus_id[] = request.getParameterValues("bus_id");
	String p_amt[] = request.getParameterValues("p_amt");
	
	int bus_id_size = bus_id.length;

	int	flag = 0;
		
	for(int i = 0; i<bus_id_size; i++){ 
					
		if(!ac_db.updatePropPamt(save_dt, bus_id[i], AddUtil.parseDigit(p_amt[i])) ) flag += 1;
	}	
		
%>
<html>
<head>
<title>FMS</title>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
<script language='JavaScript' src='/include/common.js'></script>



</body>
</html>
