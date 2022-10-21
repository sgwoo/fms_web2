<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.offls_pre.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="olyD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String lev = request.getParameter("lev")==null?"":request.getParameter("lev");
	String reason = request.getParameter("reason")==null?"":request.getParameter("reason");
	String car_st = request.getParameter("car_st")==null?"":request.getParameter("car_st");
	String sago_yn = request.getParameter("sago_yn")==null?"":request.getParameter("sago_yn");
	String lpg_yn = request.getParameter("lpg_yn")==null?"":request.getParameter("lpg_yn");
	String km = request.getParameter("km")==null?"":AddUtil.parseDigit3(request.getParameter("km"));
	String damdang = request.getParameter("damdang")==null?"":request.getParameter("damdang");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String damdang_id = request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id");
	String apprsl_dt = request.getParameter("apprsl_dt")==null?"":AddUtil.ChangeString(request.getParameter("apprsl_dt"));
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");

	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");

	Off_ls_pre_apprsl apprsl = new Off_ls_pre_apprsl();
	apprsl.setLev(lev);
	apprsl.setReason(reason);
	apprsl.setCar_st(car_st);
	apprsl.setSago_yn(sago_yn);
	apprsl.setLpg_yn(lpg_yn);
	apprsl.setKm(km);
	apprsl.setDamdang(damdang);
	apprsl.setActn_id(client_id);
	apprsl.setDamdang_id(damdang_id);
	apprsl.setModify_id(user_id);
	apprsl.setApprsl_dt(apprsl_dt);

	int result = 0;
	if(gubun.equals("u")){
		result = olyD.upApprsl(car_mng_id, apprsl);
	}else if(gubun.equals("i")){
		result = olyD.inApprsl(car_mng_id, apprsl);
	}
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%if(result >= 1){
	if(gubun.equals("i")){%>
		alert("등록되었습니다.");
	<%}else if(gubun.equals("u")){%>
		alert("수정되었습니다.");
	<%}%>
	parent.parent.location.href = "off_ls_after_sc_in_detail_frame.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	window.close();				
<%}%>
//-->
</script>
</body>
</html>
