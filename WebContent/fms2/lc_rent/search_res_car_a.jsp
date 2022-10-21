<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.common.*, acar.car_mst.*, acar.car_register.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
<script language='javascript'>

<%
	//기존차량 선택시 셋팅 처리 페이지
	
	String taecha		= request.getParameter("taecha")==null?"":request.getParameter("taecha");
	String car_st 		= request.getParameter("car_st")==null?"":request.getParameter("car_st");
	String car_cd 		= request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	String rent_mng_id 	= request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd");
	String car_comp_id 	= request.getParameter("car_comp_id");
	String car_mng_id 	= request.getParameter("car_mng_id");
	String car_no 		= request.getParameter("car_no");
	String car_nm 		= request.getParameter("car_nm");
	String car_name 	= request.getParameter("car_name");
	String deli_dt		= request.getParameter("deli_dt")==null?"":request.getParameter("deli_dt");
	String rent_s_cd	= request.getParameter("rent_s_cd")==null?"":request.getParameter("rent_s_cd");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	//자동차기초정보
	ContCarBean car = a_db.getContCar(rent_mng_id, rent_l_cd);
	
	
	//자동차등록정보
	cr_bean = crd.getCarRegBean(car_mng_id);
%>

	var fm = parent.opener.form1;
	
	
		fm.tae_car_mng_id.value		='<%=car_mng_id%>';	
		fm.tae_car_no.value			='<%=car_no%>';
		fm.tae_car_nm.value			='<%=car_nm%>';
		fm.tae_init_reg_dt.value	='<%=cr_bean.getInit_reg_dt()%>';		
		fm.tae_car_id.value			='<%=car.getCar_id()%>';	
		fm.tae_car_seq.value		='<%=car.getCar_seq()%>';					
		fm.tae_s_cd.value			='<%=rent_s_cd%>';					
		
		if(fm.tae_car_rent_st.value == ''){
			fm.tae_car_rent_st.value		='<%=deli_dt%>';					
		} 
	
	parent.close();
	
</script>
</body>
</html>
