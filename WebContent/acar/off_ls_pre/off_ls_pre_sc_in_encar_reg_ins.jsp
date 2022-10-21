<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.offls_pre.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String encar_id = request.getParameter("encar_id")==null?"":request.getParameter("encar_id");
	String reg_dt = request.getParameter("reg_dt")==null?"":AddUtil.ChangeString(request.getParameter("reg_dt"));
	int count = request.getParameter("count")==null?0:AddUtil.parseDigit(request.getParameter("count"));
	String opt_value = request.getParameter("opt_value")==null?"":request.getParameter("opt_value");
	int d_car_amt = request.getParameter("d_car_amt")==null?0:AddUtil.parseDigit(request.getParameter("d_car_amt"));
	int s_car_amt = request.getParameter("s_car_amt")==null?0:AddUtil.parseDigit(request.getParameter("s_car_amt"));
	int e_car_amt = request.getParameter("e_car_amt")==null?0:AddUtil.parseDigit(request.getParameter("e_car_amt"));
	int ea_car_amt = request.getParameter("ea_car_amt")==null?0:AddUtil.parseDigit(request.getParameter("ea_car_amt"));
	String content = request.getParameter("content")==null?"":request.getParameter("content");
	String guar_no = request.getParameter("guar_no")==null?"":request.getParameter("guar_no");
	int day_car_amt = request.getParameter("day_car_amt")==null?0:AddUtil.parseDigit(request.getParameter("day_car_amt"));
	String img_path =request.getParameter("img_path")==null?"":request.getParameter("img_path");

	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	Off_ls_pre_encar encar = new Off_ls_pre_encar();
	encar.setCar_mng_id(car_mng_id);
	encar.setEncar_id(encar_id);
	encar.setReg_dt(reg_dt);
	encar.setCount(count);
	encar.setOpt_value(opt_value);
	encar.setD_car_amt(d_car_amt);
	encar.setS_car_amt(s_car_amt);
	encar.setE_car_amt(e_car_amt);
	encar.setEa_car_amt(ea_car_amt);
	encar.setContent(content);
	encar.setGuar_no(guar_no);
	encar.setDay_car_amt(day_car_amt);
	encar.setReg_id(user_id);
	encar.setImg_path(img_path);

	int result = 0;
	result = olpD.insEncar(encar);
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%if(result >= 1){%>
	alert("등록되었습니다.");	
	parent.location.href = "off_ls_pre_sc_in_encar.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	window.close();				
<%}%>
//-->
</script>
</body>
</html>
