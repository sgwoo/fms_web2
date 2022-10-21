<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_gubun1 = request.getParameter("s_gubun1")==null?"":request.getParameter("s_gubun1");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

	CusReg_Database cr_db = CusReg_Database.getInstance();
	
	Vector cars = new Vector();
	if(!t_wd.equals("")){
		cars = cr_db.getCarList(t_wd);
	}
	int car_size = cars.size();
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>

<body>
<script language='javascript'>
<%if(car_size >= 2){ %>
	var SUBWIN="./cr_l_service.jsp?auth_rw=<%= auth_rw %>&s_gubun1=<%= s_gubun1 %>&s_kd=<%= s_kd %>&t_wd=<%= t_wd %>";
	window.open(SUBWIN, "carList", "left=100, top=200, width=440, height=200, resizable=yes, scrollbars=yes, status=yes");
<%}else if(car_size == 1){
	Hashtable car = (Hashtable)cars.elementAt(0);%>
	parent.parent.c_body.location.href = "cus_reg_service.jsp?client_id=<%= car.get("CLIENT_ID") %>&car_mng_id=<%= car.get("CAR_MNG_ID") %>";	
<%}else{ %>
	alert("해당하는 자동차가 없습니다!");
<%}%>
</script>
</body>
</html>
