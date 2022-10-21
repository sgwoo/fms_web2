<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cus_reg.*"%>
<%@ include file="/acar/cookies.jsp"%>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id 		= request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String cmd 			= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String accid_id 	= request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String accid_st 	= request.getParameter("accid_st")==null?"":request.getParameter("accid_st");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String go_url 		= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String tot_dist = request.getParameter("tot_dist")==null?"0":AddUtil.parseDigit3(request.getParameter("tot_dist"));
	
	int result = 0;
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
%>


<%
	//주행거리 수정
	ServInfoBean siBn = cr_db.getServInfo(car_mng_id, serv_id);
	siBn.setTot_dist(tot_dist);
	result = cr_db.updateService_g2(siBn);
%>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' 	value='<%= auth_rw %>'>
<input type='hidden' name='c_id' 		value='<%= car_mng_id %>'>
<input type='hidden' name='car_mng_id' 	value='<%= car_mng_id %>'>
<input type='hidden' name='serv_id' 	value='<%= serv_id %>'>
<input type='hidden' name='cmd' 		value='<%= cmd %>'>
<input type='hidden' name='accid_id' 	value='<%= accid_id%>'>
<input type='hidden' name='accid_st' 	value='<%= accid_st%>'>
<input type='hidden' name='rent_mng_id' value='<%= rent_mng_id %>'>
<input type='hidden' name='rent_l_cd' 	value='<%= rent_l_cd %>'>
<input type='hidden' name='go_url'		value='<%=go_url%>'>   
<input type='hidden' name='mode'		value='<%=mode%>'>   
<input type='hidden' name='from_page'	value='<%=from_page%>'>   
</form>
<script language='javascript'>
	var fm = document.form1;	
	fm.action = '/acar/cus_reg/serv_reg.jsp';
	fm.target = '_parent';
	fm.submit();
</script>
</body>
</html>