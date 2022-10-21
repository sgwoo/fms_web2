<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.offls_sui.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String tm = request.getParameter("tm")==null?"":request.getParameter("tm");
	int s_amt = request.getParameter("s_amt")==null?0:AddUtil.parseDigit(request.getParameter("s_amt"));
	int v_amt = request.getParameter("v_amt")==null?0:AddUtil.parseDigit(request.getParameter("v_amt"));
	String est_dt = request.getParameter("est_dt")==null?"":AddUtil.ChangeString(request.getParameter("est_dt"));
	int pay_amt = request.getParameter("pay_amt")==null?0:AddUtil.parseDigit(request.getParameter("pay_amt"));
	String pay_dt = request.getParameter("pay_dt")==null?"":AddUtil.ChangeString(request.getParameter("pay_dt"));

	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");

	Scd_suiBean ssb = new Scd_suiBean();
	ssb.setCar_mng_id(car_mng_id);
	ssb.setTm(tm);
	ssb.setS_amt(s_amt);
	ssb.setV_amt(v_amt);
	ssb.setEst_dt(est_dt);
	ssb.setPay_amt(pay_amt);
	ssb.setPay_dt(pay_dt);

	int result = 0;
	result = olsD.reg_pay_ipgum(ssb);
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
	parent.location.href = "off_ls_sui_reg_sugum.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	parent.location.href = "off_ls_sui_reg_sugum.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
<%}%>
//-->
</script>
</body>
</html>
