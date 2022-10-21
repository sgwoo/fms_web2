<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.offls_actn.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="auction_ban" class="acar.offls_actn.Offls_auction_banBean" scope="page"/>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq = request.getParameter("seq")==null?"01":request.getParameter("seq");
	String actn_cnt = request.getParameter("actn_cnt")==null?"":request.getParameter("actn_cnt");
	String ban_nm = request.getParameter("ban_nm")==null?"":request.getParameter("ban_nm");
	String ban_tel = request.getParameter("ban_tel")==null?"":request.getParameter("ban_tel");
	String ban_dt = request.getParameter("ban_dt")==null?"":AddUtil.ChangeString(request.getParameter("ban_dt"));
	String ban_reason = request.getParameter("ban_reason")==null?"":request.getParameter("ban_reason");
	String ban_car_st = request.getParameter("ban_car_st")==null?"":request.getParameter("ban_car_st");
	int js_chul = request.getParameter("js_chul")==null?0:AddUtil.parseDigit(request.getParameter("js_chul"));
	int js_tak = request.getParameter("js_tak")==null?0:AddUtil.parseDigit(request.getParameter("js_tak"));
	int js_in_amt = request.getParameter("js_in_amt")==null?0:AddUtil.parseDigit(request.getParameter("js_in_amt"));
	String js_dt = request.getParameter("js_dt")==null?"":AddUtil.ChangeString(request.getParameter("js_dt"));
	String tak_up = request.getParameter("tak_up")==null?"":request.getParameter("tak_up");
	String tak_nm = request.getParameter("tak_nm")==null?"":request.getParameter("tak_nm");
	String tak_tel = request.getParameter("tak_tel")==null?"":request.getParameter("tak_tel");
	String insu_id = request.getParameter("insu_id")==null?"":request.getParameter("insu_id");
	String ban_chk = request.getParameter("ban_chk")==null?"":request.getParameter("ban_chk");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");

	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");

	auction_ban.setCar_mng_id(car_mng_id);
	auction_ban.setActn_cnt(actn_cnt);
	auction_ban.setBan_nm(ban_nm);
	auction_ban.setBan_tel(ban_tel);
	auction_ban.setBan_dt(ban_dt);
	auction_ban.setBan_reason(ban_reason);
	auction_ban.setBan_car_st(ban_car_st);
	auction_ban.setJs_chul(js_chul);
	auction_ban.setJs_tak(js_tak);
	auction_ban.setJs_in_amt(js_in_amt);
	auction_ban.setJs_dt(js_dt);
	auction_ban.setTak_up(tak_up);
	auction_ban.setTak_nm(tak_nm);
	auction_ban.setTak_tel(tak_tel);
	auction_ban.setInsu_id(insu_id);
	auction_ban.setBan_chk(ban_chk);
	auction_ban.setModify_id(user_id);
	
	
	String max_seq = olaD.getAuction_maxSeq(car_mng_id);
  String next_seq = AddUtil.addZero2(AddUtil.parseInt(max_seq)+1);
	

	out.println(car_mng_id);
	out.println(max_seq);
	out.println(next_seq);

	int result = 0;
	
	result = olaD.cancelOffls_actn(car_mng_id, max_seq, next_seq);
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%if(result >= 1){%>
	alert("해당 차량이 반출되었습니다.\n상품관리를 참조하시기 바랍니다.");
	parent.parent.parent.parent.d_content.location.href = "off_ls_jh_frame.jsp?auth_rw=<%=auth_rw%>";
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	window.close();
<%}%>
//-->
</script>
</body>
</html>
