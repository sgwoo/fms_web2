<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.fee.*, acar.util.*,acar.fee.*, acar.cont.*, acar.insur.*, tax.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
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
	String asc 		= request.getParameter("asc")==null?"":request.getParameter("asc");
	
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
	int idx 	= request.getParameter("idx")==null?2:AddUtil.parseInt(request.getParameter("idx"));

	//만기매칭대차
	String cng_rent_mng_id2 	= request.getParameter("cng_rent_mng_id2")==null?"":request.getParameter("cng_rent_mng_id2");	
	String cng_rent_l_cd2		= request.getParameter("cng_rent_l_cd2")==null?"":request.getParameter("cng_rent_l_cd2");	
	String cng_choice4 		= request.getParameter("cng_choice4")==null?"":request.getParameter("cng_choice4");
	int cng_fee_tm 			= request.getParameter("cng_fee_tm")==null?0:AddUtil.parseInt(request.getParameter("cng_fee_tm"));
	
	
	int flag = 0;
	int flag2 = 0;
	boolean c_flag3 = true;
	
	
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(cng_rent_mng_id2, cng_rent_l_cd2);
		
	
	
	
	for(int i = cng_fee_tm ; i <= AddUtil.parseInt(fee_tm) ; i++){
	
		FeeScdBean fee = af_db.getScdNew(m_id, l_cd, rent_st, rent_seq, String.valueOf(i), tm_st1);
	
		//대차대여스케줄 대여횟수 최대값
		int max_fee_tm = a_db.getMax_fee_tm(cng_rent_mng_id2, cng_rent_l_cd2);
	
		if(!af_db.updateFeeScdCng2(fee, "4", cng_rent_mng_id2, cng_rent_l_cd2, String.valueOf(max_fee_tm+1), "만기매칭대차 이관")) flag += 1;
		
		
		//자동이체 인출일자 연동
		if(i==cng_fee_tm && !cms.getRent_mng_id().equals("") && !cms.getCms_acc_no().equals("")){
			cms.setCms_start_dt	(AddUtil.getDate());	
			//[20130930]대여료스케줄 생성시 자동이체 신청일자 넣어줌
			cms.setApp_dt(AddUtil.getDate());
			cms.setUpdate_id	(user_id);
			c_flag3 = a_db.updateContCmsMng(cms);		
		}
		
		//기발행 거래명세서 미사용 처리 (세금계산서 미발행건)
				
		//계산서 발행여부
		int chk_cnt1 = af_db.getTaxDtChk(l_cd, rent_st, rent_seq, fee.getFee_tm());
		
		//계산서 미발행상태
		if(chk_cnt1 ==0){
			//거래명세서 발행여부
			String item_id = af_db.getTaxItemDtChk(l_cd, rent_st, rent_seq, fee.getFee_tm());
			if(!item_id.equals("")){
				//거래명세서 조회
				TaxItemBean ti_bean 	= IssueDb.getTaxItemCase(item_id);
				ti_bean.setUse_yn	("N");
				if(!IssueDb.updateTaxItem(ti_bean)) flag2 += 1;
			}							
		}
	}
		
	System.out.println("만기매칭대차 스케줄 이관=======");
	System.out.println("m_id="+m_id);
	System.out.println("l_cd="+l_cd);
	System.out.println("fee_tm="+fee_tm);
	System.out.println("cng_fee_tm="+cng_fee_tm);
	System.out.println("cng_rent_mng_id2="+cng_rent_mng_id2);
	System.out.println("cng_rent_l_cd2="+cng_rent_l_cd2);	
	
		


%>
<form name='form1' method='post'>
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
</form>
<script language='javascript'>
<%	if(flag != 0){%>
		alert("스케줄이 변경되지 않았습니다");
//		location='about:blank';
		
<%	}else{		%>		
		alert("스케줄이 변경되었습니다");
		var fm = document.form1;
		fm.target='d_body';
		fm.action='./fee_scd_u_sc.jsp';
		fm.submit();	
		
		parent.window.close();	
<%	}			%>
</script>