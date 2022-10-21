<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.offls_actn.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="auction_re" class="acar.offls_actn.Offls_auction_reBean" scope="page"/>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq = request.getParameter("seq")==null?"01":request.getParameter("seq");
	String damdang_id = request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id");
	int hp_pr = request.getParameter("hp_pr")==null?0:AddUtil.parseDigit(request.getParameter("hp_pr"));
	int st_pr = request.getParameter("st_pr")==null?0:AddUtil.parseDigit(request.getParameter("st_pr"));
	String re_dt = request.getParameter("re_dt")==null?"":AddUtil.ChangeString(request.getParameter("re_dt"));
	String re_nm = request.getParameter("re_nm")==null?"":request.getParameter("re_nm");
	String re_tel = request.getParameter("re_tel")==null?"":request.getParameter("re_tel");
	String actn_cnt = request.getParameter("actn_cnt")==null?"":request.getParameter("actn_cnt");

	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");

	auction_re.setCar_mng_id(car_mng_id);
	auction_re.setActn_cnt(actn_cnt);
	auction_re.setHp_pr(hp_pr);
	auction_re.setSt_pr(st_pr);
	auction_re.setRe_dt(re_dt);
	auction_re.setRe_nm(re_nm);
	auction_re.setRe_tel(re_tel);
	auction_re.setDamdang_id(damdang_id);
	auction_re.setHp_pr(hp_pr);
	auction_re.setSt_pr(st_pr);
	auction_re.setModify_id(user_id);

	int result = 0;
	result = olaD.updAuction_re(auction_re);	//재출품수정
	
	if(result>0){
		result = olaD.updActn_st(car_mng_id, seq);						//재출품전 경매상태(유찰) 등록		
		if(result>0){
			result = olaD.reAuction(car_mng_id, seq, auction_re, user_id);	//재출품 새 레코드생성
		}
		
	}
		
	seq = olaD.getAuction_maxSeq(car_mng_id);	//최근연번
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%if(result >= 1){%>
	alert("재출품 되었습니다.");
	parent.parent.parent.location.href = "off_ls_jh_sc_in_detail_frame.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&seq=<%=seq%>";
<%}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	window.close();
<%}%>
//-->
</script>
</body>
</html>
