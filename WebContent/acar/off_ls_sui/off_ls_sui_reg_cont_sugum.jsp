<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.offls_sui.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String[] tms = request.getParameterValues("c_tm");//==null?"":request.getParameter("c_tm");
	String[] cont_amts = request.getParameterValues("c_cont_amt");//==null?0:AddUtil.parseDigit(request.getParameter("c_cont_amt"));
	String[] est_dts = request.getParameterValues("c_est_dt");//==null?"":AddUtil.ChangeString(request.getParameter("c_est_dt"));
	String[] pay_amts = request.getParameterValues("c_pay_amt");//==null?0:AddUtil.parseDigit(request.getParameter("c_pay_amt"));
	String[] pay_dts = request.getParameterValues("c_pay_dt");//==null?"":AddUtil.ChangeString(request.getParameter("c_pay_dt"));
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");

	//마직막값 입금처리할것
	String tm = tms[tms.length-1];
	int cont_amt = AddUtil.parseDigit(cont_amts[cont_amts.length-1]);
	String est_dt = AddUtil.ChangeString(est_dts[est_dts.length-1]);
	int pay_amt = AddUtil.parseDigit(pay_amts[pay_amts.length-1]);
	String pay_dt = AddUtil.ChangeString(pay_dts[pay_dts.length-1]);

	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");

	Scd_sui_contBean sscb = new Scd_sui_contBean();
	sscb.setCar_mng_id(car_mng_id);
	sscb.setTm(tm);
	sscb.setCont_amt(cont_amt);
	sscb.setEst_dt(est_dt);
	sscb.setPay_amt(pay_amt);
	sscb.setPay_dt(pay_dt);

	int result = 0;
	if(gubun.equals("i")){
		result = olsD.inScd_sui_cont(sscb);
	}else if(gubun.equals("u")){
		result = olsD.upScd_sui_cont(sscb);
	}else if(gubun.equals("c")){
		result = olsD.delScd_sui_cont(sscb);
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
		alert("입금 되었읍니다.");
	<%}else if(gubun.equals("u")){%>
		alert("수정 되었읍니다.");
	<%}else if(gubun.equals("c")){%>
		alert("취소 되었읍니다.");
	<%}%>
	parent.location.href = "off_ls_sui_reg_sugum.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	parent.location.href = "off_ls_sui_reg_sugum.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>";
<%}%>
//-->
</script>
</body>
</html>
