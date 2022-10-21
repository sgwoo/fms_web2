<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.credit.*, acar.user_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">

<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	
	//채권관계, 잔존채권의 처리의견/지시사항
	CarCreditBean cc = ac_db.getCarCredit(rent_mng_id, rent_l_cd);		
	cc.setRent_mng_id(rent_mng_id);
	cc.setRent_l_cd	(rent_l_cd);
	cc.setGi_amt(request.getParameter("gi_amt")==null?0:				AddUtil.parseDigit(request.getParameter("gi_amt"))); //보증보험금액
	cc.setGi_c_amt(request.getParameter("gi_c_amt")==null?0:			AddUtil.parseDigit(request.getParameter("gi_c_amt"))); //청구금액
	cc.setGi_j_amt(request.getParameter("gi_j_amt")==null?0:			AddUtil.parseDigit(request.getParameter("gi_j_amt"))); //잔존채권금액
	cc.setC_ins(request.getParameter("c_ins")==null?"":					request.getParameter("c_ins"));  //손해보험사 
	cc.setC_ins_d_nm(request.getParameter("c_ins_d_nm")==null?"":		request.getParameter("c_ins_d_nm"));  //담당자
	cc.setC_ins_tel(request.getParameter("c_ins_tel")==null?"":			request.getParameter("c_ins_tel"));  //전화번호
	cc.setCrd_reg_gu1(request.getParameter("crd_reg_gu1")==null?"":		request.getParameter("crd_reg_gu1"));  //보증보험청구여부
	cc.setCrd_reg_gu2(request.getParameter("crd_reg_gu2")==null?"":		request.getParameter("crd_reg_gu2"));  //연대보증구상여부
	cc.setCrd_reg_gu3(request.getParameter("crd_reg_gu3")==null?"":		request.getParameter("crd_reg_gu3"));  //채권추심외주
	cc.setCrd_reg_gu4(request.getParameter("crd_reg_gu4")==null?"":		request.getParameter("crd_reg_gu4"));  //자동차손해보험
	cc.setCrd_reg_gu5(request.getParameter("crd_reg_gu5")==null?"":		request.getParameter("crd_reg_gu5"));  //면제
	cc.setCrd_reg_gu6(request.getParameter("crd_reg_gu6")==null?"":		request.getParameter("crd_reg_gu6"));  //대손처리
	cc.setCrd_remark1(request.getParameter("crd_remark1")==null?"":		request.getParameter("crd_remark1"));  //보증보험청구 의견
	cc.setCrd_remark2(request.getParameter("crd_remark2")==null?"":		request.getParameter("crd_remark2"));  //연대보증인구상 의견
	cc.setCrd_remark3(request.getParameter("crd_remark3")==null?"":		request.getParameter("crd_remark3"));  //채권추심외주 의견
	cc.setCrd_remark4(request.getParameter("crd_remark4")==null?"":		request.getParameter("crd_remark4"));  //자동차손해보험 의견
	cc.setCrd_remark5(request.getParameter("crd_remark5")==null?"":		request.getParameter("crd_remark5"));  //면제 의견
	cc.setCrd_remark6(request.getParameter("crd_remark6")==null?"":		request.getParameter("crd_remark6"));  //대손처리 의견
	cc.setCrd_id(request.getParameter("crd_id")==null?"":				request.getParameter("crd_id"));  // 결재자
	cc.setCrd_reason(request.getParameter("crd_reason")==null?"":		request.getParameter("crd_reason"));  //사유
	cc.setUpd_id(user_id);	
	boolean cr1_flag = ac_db.updateCarCredit(cc);
	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
%>
<script language='javascript'>
<%	if(!cr1_flag){  %>
		alert("처리되지 않았습니다");
		location='about:blank';		
<%	}else{		%>
		alert("처리되었습니다");
		parent.opener.location.href = "lc_cls_d_frame.jsp<%=valus%>";
		parent.window.close();
<%	}			%>
</script>