<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ page import="acar.car_service.*"%>
<%@ include file="/acar/cookies.jsp" %> 

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
		si.setChecker			(ck_acar_id);
		si.setServ_dt			(AddUtil.replace(serv_dt,"-",""));
		si.setTot_dist			(tot_dist);
		si.setOff_id			("000086");
		si.setRep_cont			("������Ÿ��Է�");
		si.setNext_serv_dt		(si.getServ_dt());
		si.setReg_id			(ck_acar_id);
		
		serv_id = csD.insertServiceDist(si);
		
	}
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
</head>
<body>

<script>
<%	if(cmd.equals("i") && !serv_id.equals("")){%>		
		alert('��� �߽��ϴ�.');
		parent.window.close();
<%	}else{%>
		alert("�����߻�!");
<%	}%>
</script>
</body>
</html>