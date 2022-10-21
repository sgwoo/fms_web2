<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.fee.*, acar.util.*,acar.fee.*, acar.cont.*, acar.insur.*, tax.*, acar.user_mng.*, acar.car_sche.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">

<%
	String auth 	= request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc 	= request.getParameter("asc")==null?"":request.getParameter("asc");
	
	//로그인 사용자정보
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String rent_seq	= request.getParameter("rent_seq")==null?"1":request.getParameter("rent_seq");
	String fee_tm 	= request.getParameter("fee_tm")==null?"":request.getParameter("fee_tm");
	String tm_st1 	= request.getParameter("tm_st1")==null?"":request.getParameter("tm_st1");
	String tm_st2 	= request.getParameter("tm_st2")==null?"":request.getParameter("tm_st2");
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String cng_st 	= request.getParameter("cng_st")==null?"":request.getParameter("cng_st");
	String cng_cau 	= request.getParameter("cng_cau")==null?"":request.getParameter("cng_cau");
	String etc 		= request.getParameter("etc")==null?"":request.getParameter("etc");
	int idx 		= request.getParameter("idx")==null?2:AddUtil.parseInt(request.getParameter("idx"));
	
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode   		= request.getParameter("mode")==null?"":request.getParameter("mode");
	

	String rtn_yn 		= request.getParameter("rtn_yn")==null?"":request.getParameter("rtn_yn");
	String use_s_dt 	= request.getParameter("use_s_dt")==null?"":request.getParameter("use_s_dt");
	String use_e_dt 	= request.getParameter("use_e_dt")==null?"":request.getParameter("use_e_dt");
	String req_dt 		= request.getParameter("req_dt")==null?"":request.getParameter("req_dt");
	String tax_out_dt 	= request.getParameter("tax_out_dt")==null?"":request.getParameter("tax_out_dt");
	String fee_est_dt 	= request.getParameter("fee_est_dt")==null?"":request.getParameter("fee_est_dt");
	String max_tm_auto 	= request.getParameter("max_tm_auto")==null?"":request.getParameter("max_tm_auto");
	int fee_amt 		= request.getParameter("fee_amt")==null?0:AddUtil.parseDigit(request.getParameter("fee_amt"));
	int fee_s_amt 		= request.getParameter("fee_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("fee_s_amt"));
	int fee_v_amt 		= request.getParameter("fee_v_amt")==null?0:AddUtil.parseDigit(request.getParameter("fee_v_amt"));
	int flag = 0;
	
	//기존대여스케줄 대여횟수 최대값
	int max_fee_tm = af_db.getMax_fee_tmEst(m_id, l_cd);

	
	FeeScdBean fee = af_db.getScdFeeEst(m_id, l_cd, rent_st, rent_seq, fee_tm, tm_st1);
			
	fee.setFee_s_amt	(fee_s_amt);
	fee.setFee_v_amt	(fee_v_amt);
	fee.setUse_s_dt		(use_s_dt);
	fee.setUse_e_dt		(use_e_dt);
	fee.setTax_out_dt	(tax_out_dt);
	fee.setReq_dt			(req_dt);
	fee.setR_req_dt		(af_db.getValidDt(fee.getReq_dt()));
	fee.setFee_est_dt	(fee_est_dt);
	fee.setR_fee_est_dt	(af_db.getValidDt(fee.getFee_est_dt()));
	fee.setUpdate_id	(user_id);
	if(AddUtil.parseInt(AddUtil.replace(fee.getTax_out_dt(),"-","")) == AddUtil.parseInt(AddUtil.replace(fee.getReq_dt(),"-",""))){
		fee.setR_req_dt	(fee.getReq_dt());
	}
	fee.setEtc(etc);
	
	
	//마지막회차 이면서 대여료 금액이 0 이면 삭제
	if(fee_s_amt==0 && max_fee_tm==AddUtil.parseInt(fee_tm)){
		if(!af_db.dropFeeScdEst(m_id, l_cd, rent_st, rent_seq, fee_tm, tm_st1)) flag += 1;		
	//수정
	}else{	
		if(!af_db.updateFeeScdEst(fee)) flag += 1;
	}

%>
<form name='form1' method='post'>
<input type='hidden' name='rent_mng_id' value='<%=m_id%>'>
<input type='hidden' name='rent_l_cd' value='<%=l_cd%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
  <input type='hidden' name="doc_no" 			value="<%=doc_no%>">
  <input type='hidden' name="mode" 			value="<%=mode%>">

</form>
<script language='javascript'>
<%	if(flag != 0){%>
		alert("스케줄이 변경되지 않았습니다");

		
<%	}else{		%>		
		alert("스케줄이 변경되었습니다");
		var fm = document.form1;
		fm.target='d_content';
		fm.action='/fms2/lc_rent/lc_start_doc.jsp';
		fm.submit();	
		
		parent.window.close();	
<%	}			%>
</script>