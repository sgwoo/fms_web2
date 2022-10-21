<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.offls_pre.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_actn.*"%>
<jsp:useBean id="olpD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	int hppr = request.getParameter("hppr")==null?0:AddUtil.parseDigit(request.getParameter("hppr"));
	int stpr = request.getParameter("stpr")==null?0:AddUtil.parseDigit(request.getParameter("stpr"));
	String determ_id = request.getParameter("determ_id")==null?"":request.getParameter("determ_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");

	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");

	Offls_auctionBean auction = new Offls_auctionBean();
	auction.setCar_mng_id(car_mng_id);
	auction.setHp_pr(hppr);
	auction.setSt_pr(stpr);
	auction.setDamdang_id(determ_id);
	auction.setModify_id(user_id);
	
	int result = 0;
	if(gubun.equals("u")){
		result = olaD.updAuction2(auction);
	}else if(gubun.equals("i")&& !olpD.getCar_mng_id_ban(car_mng_id).equals("")){
		result = olaD.updAuction2(auction);
	}else{
		result = olaD.insAuction(auction);
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
