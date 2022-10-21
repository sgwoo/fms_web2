<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.offls_actn.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<%//@ include file="/acar/cookies.jsp"%>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq = request.getParameter("seq")==null?"01":request.getParameter("seq");
	String actn_st = request.getParameter("actn_st")==null?"":request.getParameter("actn_st");
	String actn_cnt = request.getParameter("actn_cnt")==null?"":request.getParameter("actn_cnt");
	String actn_num = request.getParameter("actn_num")==null?"":request.getParameter("actn_num");
	String actn_dt = request.getParameter("actn_dt")==null?"":AddUtil.ChangeString(request.getParameter("actn_dt"));
	int st_pr = request.getParameter("st_pr")==null?0:AddUtil.parseDigit(request.getParameter("st_pr"));
	int hp_pr = request.getParameter("hp_pr")==null?0:AddUtil.parseDigit(request.getParameter("hp_pr"));
	String ama_jum = request.getParameter("ama_jum")==null?"":request.getParameter("ama_jum");
	String ama_rsn = request.getParameter("ama_rsn")==null?"":request.getParameter("ama_rsn");
	String ama_nm = request.getParameter("ama_nm")==null?"":request.getParameter("ama_nm");
	String actn_jum = request.getParameter("actn_jum")==null?"":request.getParameter("actn_jum");
	String actn_rsn = request.getParameter("actn_rsn")==null?"":request.getParameter("actn_rsn");
	String actn_nm = request.getParameter("actn_nm")==null?"":request.getParameter("actn_nm");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	int o_s_amt = request.getParameter("o_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("o_s_amt"));
	
				
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	Offls_auctionBean auction = olaD.getAuction(car_mng_id, seq);
	
	auction.setActn_st(actn_st);
	auction.setActn_cnt(actn_cnt);
	auction.setActn_num(actn_num);
	auction.setActn_dt(actn_dt);
	auction.setSt_pr(st_pr);
	auction.setHp_pr(hp_pr);
	auction.setAma_jum(ama_jum);
	auction.setAma_rsn(ama_rsn);
	auction.setAma_nm(ama_nm);
	auction.setActn_jum(actn_jum);
	auction.setActn_rsn(actn_rsn);
	auction.setActn_nm(actn_nm);
	auction.setModify_id(user_id);
	auction.setO_s_amt(o_s_amt);
	
	int result = 0;
	
	if(auction.getCar_mng_id().equals("")){
		auction.setDamdang_id("000004");
		auction.setSeq(seq);
		auction.setCar_mng_id(car_mng_id);
		result = olaD.insAuction(auction);
		
		result = olaD.updAuction(auction);
	}else{
		result = olaD.updAuction(auction);
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
	parent.parent.location.href = "off_ls_jh_st_frame.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&seq=<%=seq%>&flag=y";
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	window.close();
<%}%>
//-->
</script>
</body>
</html>
