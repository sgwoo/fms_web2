<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.offls_actn.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp"%>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq = request.getParameter("seq")==null?"01":request.getParameter("seq");//경매관리 연번
	String actn_cnt = request.getParameter("actn_cnt")==null?"":request.getParameter("actn_cnt");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	int cust_pr = request.getParameter("cust_pr")==null?0:AddUtil.parseDigit(request.getParameter("cust_pr"));
	int ama_pr = request.getParameter("ama_pr")==null?0:AddUtil.parseDigit(request.getParameter("ama_pr"));
	int nak_pr = request.getParameter("nak_pr")==null?0:AddUtil.parseDigit(request.getParameter("nak_pr"));
	String reason = request.getParameter("reason")==null?"":request.getParameter("reason");
	String nak_seq = "";
	String per_seq = "";
	
	Offls_per_talkBean per_talk = new Offls_per_talkBean();
	per_talk.setCar_mng_id(car_mng_id);
	per_talk.setActn_cnt(actn_cnt);
	int i_seq = Integer.parseInt(olaD.getPer_talk_maxSeq(car_mng_id,actn_cnt));
	if(i_seq<10){
		per_seq = "0"+String.valueOf(i_seq+1);
	}else{
		per_seq = String.valueOf(i_seq+1);
	}
	per_talk.setSeq(per_seq);
	per_talk.setCust_pr(cust_pr);
	per_talk.setAma_pr(ama_pr);
	per_talk.setReason(reason);
	
	int result = 0;
	if(gubun.equals("n")){
		result = olaD.insPer_talk2(per_talk);
		if(result>0) result = olaD.updAuction_nak(car_mng_id, seq, nak_pr, "");	//경매테이블_낙찰가격만 저장
		if(result>0) result = olaD.updActn_st_nak(car_mng_id, seq); //경매테이블 낙찰상태로
	}else if(gubun.equals("r")){
		result = olaD.insPer_talk(per_talk); 
	}else if(gubun.equals("c")){
		result = olaD.updActn_st(car_mng_id, seq);
	}
%>
<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<script language="JavaScript">
<!--
<%	if(result >= 1){
		if(gubun.equals("n")){%>
			alert("낙찰 되었읍니다.");
			parent.parent.location.href = "off_ls_jh_st_frame.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&seq=<%=seq%>";
<%		}else if(gubun.equals("r")){%>
			parent.location.href = "off_ls_jh_sc_in_per.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&seq=<%=seq%>&actn_cnt=<%=actn_cnt%>";
<%		}else if(gubun.equals("c")){%>
			alert("최종유찰 되었읍니다.");
			parent.parent.location.href = "off_ls_jh_st_frame.jsp?auth_rw=<%=auth_rw%>&car_mng_id=<%=car_mng_id%>&seq=<%=seq%>";
<%		}
}else{%>
	alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
	window.close();
<%}%>
//-->
</script>
</body>
</html>
