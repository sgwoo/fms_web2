<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.fee.*, acar.util.*,acar.fee.*, acar.cont.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">

<body leftmargin="15">
<%
	
	String auth 		= request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt 		= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 		= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun 	= request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc 			= request.getParameter("asc")==null?"":request.getParameter("asc");
	
	//로그인 사용자정보
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	
	String m_id 		= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 		= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 		= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String rent_st 		= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String gubun 		= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String tae_no 		= request.getParameter("tae_no")==null?"":request.getParameter("tae_no");
	int idx 			= request.getParameter("idx")==null?2:AddUtil.parseInt(request.getParameter("idx"));
	
	String seq 			= request.getParameter("seq")==null?"":request.getParameter("seq");
	String stop_st 		= request.getParameter("stop_st")==null?"":request.getParameter("stop_st");
	String stop_s_dt 	= request.getParameter("stop_s_dt")==null?"":request.getParameter("stop_s_dt");
	String stop_e_dt 	= request.getParameter("stop_e_dt")==null?"":request.getParameter("stop_e_dt");
	String stop_cau 	= request.getParameter("stop_cau")==null?"":request.getParameter("stop_cau");
	String stop_doc_id 	= request.getParameter("stop_doc_id")==null?"":request.getParameter("stop_doc_id");
	String stop_doc_dt 	= request.getParameter("stop_doc_dt")==null?"":request.getParameter("stop_doc_dt");
	String stop_doc 	= request.getParameter("stop_doc")==null?"":request.getParameter("stop_doc");
	String stop_tax_dt 	= request.getParameter("stop_tax_dt")==null?"":request.getParameter("stop_tax_dt");
	String cancel_dt 	= request.getParameter("cancel_dt")==null?"":request.getParameter("cancel_dt");
	int stop_size 		= AddUtil.parseDigit(request.getParameter("stop_size"));
	
	int flag1 = 0;


	//세금계산서 발행 일시중지 등록 ----------------------------------------------------------------------
	
	FeeScdStopBean fee_scd = af_db.getFeeScdStop(m_id, l_cd, seq);
	
	fee_scd.setRent_mng_id	(m_id);
	fee_scd.setRent_l_cd	(l_cd);
	fee_scd.setStop_st		(stop_st);			//중지구분
	fee_scd.setStop_s_dt	(stop_s_dt);		//중지기간
	fee_scd.setStop_e_dt	(stop_e_dt);		//중지기간
	fee_scd.setStop_cau		(stop_cau);			//중지사유
	fee_scd.setDoc_id		(stop_doc_id);		//최고장번호
	fee_scd.setStop_doc_dt	(stop_doc_dt);		//내용증명발신일자
	fee_scd.setStop_doc		(stop_doc);			//최고장번호파일
	fee_scd.setStop_tax_dt	(stop_tax_dt);		//일괄발행일
	fee_scd.setCancel_dt	(cancel_dt);		//중지해제일
	
	if(!fee_scd.getCancel_dt().equals("") && fee_scd.getCancel_id().equals(""))		fee_scd.setCancel_id(user_id);
	
	if(fee_scd.getSeq().equals("")){
		fee_scd.setReg_id	(user_id);
		fee_scd.setSeq		(String.valueOf(stop_size+1));
		fee_scd.setRent_seq	("1");
		if(!af_db.insertFeeScdStop(fee_scd)) flag1 += 1;
	}else{
		if(fee_scd.getRent_seq().equals("")) fee_scd.setRent_seq	("1");
		if(!af_db.updateFeeScdStop(fee_scd)) flag1 += 1;
	}
	
	seq = fee_scd.getSeq();
%>
<form name='form1' method='post'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='seq' value='<%=seq%>'>
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
</form>
<script language='javascript'>
<%	if(flag1 > 0){%>
		alert("계산서 일시중지가 등록되지 않았습니다");
//		location='about:blank';
		
<%	}else{		%>		
		alert("계산서 일시중지가 등록되었습니다");
		var fm = document.form1;
		fm.target='ScdStopList';
		fm.action='./fee_scd_u_stoplist.jsp';
		fm.submit();	
<%	}			%>
</script>