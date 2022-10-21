<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_register.*,acar.common.*" %>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String car_ext 		= request.getParameter("car_ext")	==null?"":request.getParameter("car_ext");
	String cng_car_ext 	= request.getParameter("cng_car_ext")	==null?"":request.getParameter("cng_car_ext");
	String cng_dt		= request.getParameter("cng_dt")	==null?"":request.getParameter("cng_dt");
	String cng_cau		= request.getParameter("cng_cau")	==null?"":request.getParameter("cng_cau");
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	
	
	String cha_cau_sub = "";
	String car_ext_cd = "";
	String car_ext_nm = "";
	String cng_car_ext_nm = "";
	String car_mng_id = "";
	String car_no = "";
	int idx = 0;
	
	car_ext_cd = car_ext;
	car_ext_nm = c_db.getNameByIdCode("0032", "", car_ext_cd);
	
	
	car_ext_cd = cng_car_ext;
	cng_car_ext_nm = c_db.getNameByIdCode("0032", "", car_ext_cd);
	
	
	cha_cau_sub = cng_cau+"("+car_ext_nm+"->"+cng_car_ext_nm+")";
	
	
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	
	String ch_cd[] 		= request.getParameterValues("ch_cd");
	String value01[] 	= request.getParameterValues("car_mng_id");
	String value02[] 	= request.getParameterValues("car_no");	
	
	
	out.println("size="+ch_cd.length+"<br><br><br>");
	
	for(int i=0;i < ch_cd.length;i++){
		
		idx = AddUtil.parseInt(ch_cd[i]);
		
		
		car_mng_id 	= value01[idx];
		car_no 		= value02[idx];
		
		//차량정보
		cr_bean = crd.getCarRegBean(car_mng_id);


		//자동차번호이력
		ch_bean.setCar_mng_id	(car_mng_id);
		ch_bean.setCha_car_no	(car_no);
		ch_bean.setCha_dt	(cng_dt);
		ch_bean.setCha_cau	("1");
		ch_bean.setCha_cau_sub	(cha_cau_sub);
		ch_bean.setReg_id	(user_id);
		ch_bean.setReg_dt	(AddUtil.getDate());
		ch_bean.setScanfile	("");
		ch_bean.setCar_ext	(cng_car_ext);
		
		int result = crd.insertCarHis(ch_bean);
		
		cr_bean.setCar_ext(cng_car_ext);//지역
		
		if(!cr_bean.getCar_no().equals(car_no)){
			cr_bean.setCar_no(car_no); //차량번호
		}
		int count = crd.updateCarMain(cr_bean);
		
	}
	

%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
</form>
<script language='javascript'>
<!--
	alert('등록되었습니다.');
	window.close();
//-->
</script>
</body>
</html>
