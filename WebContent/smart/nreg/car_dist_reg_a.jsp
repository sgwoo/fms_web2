<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ page import="acar.car_service.*"%>
<%@ include file="/smart/cookies.jsp" %> 

<%
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");	
	String cmd 			= request.getParameter("cmd")==null?"i":request.getParameter("cmd");
	
	String serv_id		= request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String serv_dt 		= request.getParameter("serv_dt")==null?"":request.getParameter("serv_dt");
	String tot_dist 	= request.getParameter("tot_dist")==null?"":request.getParameter("tot_dist");
	
	
	
	CarServDatabase csD 	= CarServDatabase.getInstance();
	
	int result = 0;
	
	ServiceBean si = new ServiceBean();
	
	if(cmd.equals("i")){
		
		si.setRent_mng_id		(rent_mng_id);
		si.setRent_l_cd			(rent_l_cd);
		si.setCar_mng_id		(car_mng_id);
		si.setAccid_id			("");
		si.setServ_jc			("");
		si.setServ_st			("1");
		si.setChecker			(user_id);
		si.setServ_dt			(AddUtil.replace(serv_dt,"-",""));
		si.setTot_dist			(tot_dist);
		si.setOff_id			("000086");
		si.setRep_cont			("실주행거리입력");
		si.setNext_serv_dt		(si.getServ_dt());
		si.setReg_id			(user_id);
		
		serv_id = csD.insertServiceDist(si);
		
	}else if(cmd.equals("u")){
		
		si = csD.getServiceDist(car_mng_id, serv_id);
		
		si.setRent_mng_id		(rent_mng_id);
		si.setRent_l_cd			(rent_l_cd);
		si.setCar_mng_id		(car_mng_id);
		si.setServ_id			(serv_id);
		si.setServ_dt			(AddUtil.replace(serv_dt,"-",""));
		si.setTot_dist			(tot_dist);
		si.setCust_serv_dt		(si.getServ_dt());
		si.setNext_serv_dt		(si.getServ_dt());
		si.setUpdate_id			(user_id);
		result = csD.updateServiceDist(si);
		
	}else if(cmd.equals("d")){
		result = csD.deleteServiceDist(car_mng_id, serv_id);
	}
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
</head>
<body>
<form action="car_dist_view.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
	<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
	<input type='hidden' name='rent_l_cd' 	value='<%=rent_l_cd%>'>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>	
	<input type='hidden' name='serv_id'		value='<%=serv_id%>'>		
</form>
<script>
<%	if(cmd.equals("i") && !serv_id.equals("")){%>		
		document.form1.action = "car_dist_view.jsp";
		document.form1.target = '_parent';		
		document.form1.submit();		
<%	}else if(cmd.equals("u") && result==1){%>		
		document.form1.action = "car_dist_view.jsp";
		document.form1.target = '_parent';		
		document.form1.submit();		
<%	}else if(cmd.equals("d") && result==1){%>		
		document.form1.action = "nreg_main.jsp";
		document.form1.target = '_parent';		
		document.form1.submit();		
<%	}else{%>
		alert("에러발생!");
<%	}%>
</script>
</body>
</html>