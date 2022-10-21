<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.offls_actn.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="auction" class="acar.offls_actn.Offls_auctionBean" scope="page"/>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq = request.getParameter("seq")==null?"01":request.getParameter("seq");
	String actn_cnt = request.getParameter("actn_cnt")==null?"":request.getParameter("actn_cnt");
	
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	auction = olaD.getAuction(car_mng_id, seq);
	auction.setActn_st("1");
	
	int result = olaD.updAuction_ban(auction);
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<form name="form1" action="" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="seq" value="<%=seq%>">
<input type="hidden" name="actn_cnt" value="<%=actn_cnt%>">
</form>
<script language="JavaScript">
<!--
function move_page(){
	fm = document.form1;
	fm.action = "off_ls_jh_sc_in_detail_frame.jsp";
	fm.target = 'd_content';
	fm.submit();
}

<%if(result >= 1){%>
	alert("수정되었습니다.");
	move_page();
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	window.close();
<%}%>
//-->
</script>
</body>
</html>
