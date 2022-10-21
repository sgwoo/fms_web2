<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.master_car.*"%>
<jsp:useBean id="mc_db" scope="page" class="acar.master_car.Master_CarDatabase"/>
<%@ include file="/acar/cookies.jsp"%>
<%
	
	String m1_no = request.getParameter("m1_no")==null?"":request.getParameter("m1_no");//
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");		//target
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String mng_id = request.getParameter("mng_id")==null?"":request.getParameter("mng_id");//
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");//
	
	int flag = 0;
	
	//car_maint_req
	if (mode.equals("D")) {
		if(!mc_db.deleteCarReq(m1_no)) flag += 1;
	} else {
		if(!mc_db.updateCarReq(m1_no, rent_l_cd, c_id, mng_id)) flag += 1;
	}
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language='javascript'>
<%	if(flag != 0)	{	%>
		alert('처리되지 않았습니다');
<%	}else{	%>
		alert("처리되었습니다");		
		parent.window.close();
	<!--	parent.close();  -->
<%	}	%>
</script>
</body>
</html>