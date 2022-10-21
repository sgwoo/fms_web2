<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*" %>
<jsp:useBean id="cd_bean" class="acar.car_mst.CarDcBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String car_cd = request.getParameter("car_cd")==null?"":request.getParameter("car_cd");
	String car_id = request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String car_seq = request.getParameter("car_seq")==null?"":request.getParameter("car_seq");
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String view_dt = request.getParameter("view_dt")==null?"":request.getParameter("view_dt");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String car_b_dt = request.getParameter("car_b_dt")==null?"":request.getParameter("car_b_dt");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	int count = 0;
	
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	
	cd_bean.setCar_comp_id(car_comp_id);
	cd_bean.setCar_cd(car_cd);
	cd_bean.setCar_d_seq(request.getParameter("h_car_d_seq")==null?"":request.getParameter("h_car_d_seq"));
	cd_bean.setCar_d(request.getParameter("h_car_d")==null?"":request.getParameter("h_car_d"));
	cd_bean.setCar_d_p(request.getParameter("h_car_d_p")==null?0:AddUtil.parseDigit(request.getParameter("h_car_d_p")));
	cd_bean.setCar_d_st(request.getParameter("h_car_d_st")==null?"":request.getParameter("h_car_d_st"));
	cd_bean.setCar_d_et(request.getParameter("h_car_d_et")==null?"":request.getParameter("h_car_d_et"));
	
	if(mode.equals("i")){
		count = a_cmb.insertCarDc(cd_bean);
	}else if(mode.equals("u")){
		count = a_cmb.updateCarDc(cd_bean);
	}else if(mode.equals("d")){
		count = a_cmb.deleteCarDc(cd_bean);
	}
%>
<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<form action="car_dc.jsp" name="form1" method="POST">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">    
  <input type="hidden" name="car_comp_id" value="<%=car_comp_id%>">
  <input type="hidden" name="car_cd" value="<%=car_cd%>">
  <input type="hidden" name="car_id" value="<%=car_id%>">
  <input type="hidden" name="car_seq" value="<%=car_seq%>">
  <input type="hidden" name="car_b_dt" value="<%=car_b_dt%>">    
  <input type="hidden" name="car_nm" value="<%=car_nm%>">    
  <input type="hidden" name="view_dt" value="<%=view_dt%>">        
  <input type="hidden" name="cmd" value="<%=cmd%>">
</form>
<script>
<%	if(count==1){%>
		alert("정상적으로 처리되었습니다.");
		document.form1.target='popwin3';
		document.form1.submit();		
<%	}else{%>
		alert("처리오류 발생!!");
<%	}	%>
</script>
</body>
</html>