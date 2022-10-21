<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*, acar.fee.*, acar.cont.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	out.println("세금계산서 발행하기 1단계"+"<br><br>");
	
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))		br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "06", "09");
	
	String reg_st 			= request.getParameter("reg_st")==null?"":request.getParameter("reg_st");//all-전체발행,select선택발행
	String reg_gu 			= request.getParameter("reg_gu")==null?"":request.getParameter("reg_gu");//1-일괄발행,2-통합발행,3-개별발행
	String mail_auto_yn = request.getParameter("mail_auto_yn")==null?"":request.getParameter("mail_auto_yn");//메일발행방식
	String tax_out_dt 	= request.getParameter("tax_out_dt")==null?"":AddUtil.replace(request.getParameter("tax_out_dt"),"-","");//세금일자
	
	String vid1[] 		= request.getParameterValues("h_l_cd");
	String vid2[] 		= request.getParameterValues("ch_l_cd");
	
	String vid_num		= "";
	String ch_m_id		= "";
	String ch_l_cd		= "";
	String ch_rent_st	= "";
	String ch_rent_seq	= "";
	String ch_fee_tm	= "";
	String car_mng_id = "";
	String client_id 	= "";
	String site_id 		= "";
	String item_id 		= "";
	int vid_size 			= 0;
	int seq 		= 0;
	int flag 		= 0;
	
	
	if(reg_st.equals("all")){
		vid_size = vid1.length;
	}else{
		vid_size = vid2.length;
	}
	
	out.println("선택건수="+vid_size+"<br><br>");
	
	
	String reg_code  = Long.toString(System.currentTimeMillis());
	out.println("실행코드="+reg_code+"<br>");
	
	
	
	//[1단계] 거래명세서 리스트 생성
	
	for(int i=0;i < vid_size;i++){
		if(reg_st.equals("all")){
			vid_num = vid1[i];
		}else{
			vid_num = vid2[i];
		}
		ch_m_id 		= vid_num.substring(0,6);
		ch_l_cd 		= vid_num.substring(6,19);
		ch_rent_st 		= vid_num.substring(19,20);
		ch_rent_seq		= vid_num.substring(20,21);
		ch_fee_tm 		= vid_num.substring(21);
		
		//장기계약 상단정보
		LongRentBean base = ScdMngDb.getScdMngLongRentInfo(ch_m_id, ch_l_cd);
		
		//대여료스케줄가져오기(회차)
		FeeScdBean scd = af_db.getScdNew(ch_m_id, ch_l_cd, ch_rent_st, ch_rent_seq, ch_fee_tm, "0");
		
		//이미 발행한 계산서 중복체크하기
		if(IssueDb.getTaxMakeCheck2(ch_l_cd, ch_fee_tm, ch_rent_st, ch_rent_seq) > 0){
			System.out.println("이미 발행한 계산서");
			continue;
		}
		
		//이미 발행한 청구서 중복체크하기
		if(IssueDb.getTaxItemMakeCheck(ch_l_cd, ch_fee_tm, ch_rent_st, ch_rent_seq) > 0){
			System.out.println("이미 발행한 청구서");
			continue;
		}
		
		item_id = IssueDb.getItemIdNext(scd.getReq_dt());
		
		seq = 1;
		
		TaxItemListBean til_bean = new TaxItemListBean();
		
		til_bean.setItem_id			(item_id);
		til_bean.setItem_seq		(seq);
		til_bean.setItem_g			("대여료");
		til_bean.setItem_car_no	(base.getCar_no());
		til_bean.setItem_car_nm	(base.getCar_nm());
		til_bean.setItem_dt1		(scd.getUse_s_dt());
		til_bean.setItem_dt2		(scd.getUse_e_dt());
		til_bean.setItem_supply	(scd.getFee_s_amt());
		til_bean.setItem_value	(scd.getFee_v_amt());
		til_bean.setRent_l_cd		(ch_l_cd);
		til_bean.setCar_mng_id	(base.getCar_mng_id());
		til_bean.setTm					(ch_fee_tm);
		til_bean.setGubun				("1");
		til_bean.setReg_id			(user_id);
		til_bean.setReg_code		(reg_code);
		til_bean.setRent_st			(ch_rent_st);
		til_bean.setRent_seq		(ch_rent_seq);
		til_bean.setCar_use			(base.getCar_use());
		til_bean.setItem_dt			(scd.getReq_dt());
		til_bean.setEtc					(scd.getEtc());
		
		if(scd.getTm_st2().equals("4")){
			til_bean.setItem_g			("선급대여료");
		}
		
		//월렌트이고 지정 세금일자가 있다면..
		if(base.getCar_st().equals("4") && !tax_out_dt.equals("")){
			til_bean.setItem_dt	(tax_out_dt);
		}
		
		if(scd.getTm_st2().equals("2")){
			String taecha_no  	= scd.getTaecha_no();
			
			if(taecha_no.equals("")){
				taecha_no = a_db.getMaxTaechaNo(scd.getRent_mng_id(), scd.getRent_l_cd())+"";
			}
					
			//출고지연대차
			ContTaechaBean taecha = a_db.getTaecha(scd.getRent_mng_id(), scd.getRent_l_cd(), taecha_no);
			
			til_bean.setItem_car_no	(taecha.getCar_no());
			til_bean.setItem_car_nm	(taecha.getCar_nm());
			til_bean.setCar_mng_id	(taecha.getCar_mng_id());
			if(taecha.getCar_no().indexOf("허") == -1)					til_bean.setCar_use		("2");
			else if(taecha.getCar_no().indexOf("하") == -1)		til_bean.setCar_use		("2");
			else if(taecha.getCar_no().indexOf("호") == -1)		til_bean.setCar_use		("2");
			else																							til_bean.setCar_use		("1");
		}
		
		if(!IssueDb.insertTaxItemList(til_bean)) flag += 1;
		
		seq++;
		
		//gubun = 1 대여료, 2 보증금, 3 선납금, 4 개시대여료, 5 위약금, 6 차량매각대금, 7 정비비, 8 과태료, 9 self, 10 보험대차, 11 대차료, 12 휴차료, 13 업무대여 
		
		out.println(base.getCar_mng_id()+ch_l_cd+scd.getReq_dt()+"<br>");
		
		seq = 0;//개별발행
	}
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = 'tax_reg_step2.jsp';
		fm.submit();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body onLoad="javascript:init()">
<form name='form1' action='' method='post'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='reg_st' 		value='<%=reg_st%>'>
<input type='hidden' name='reg_gu' 		value='<%=reg_gu%>'>
<input type='hidden' name='reg_code' 		value='<%=reg_code%>'>
<input type='hidden' name='mail_auto_yn' 	value='<%=mail_auto_yn%>'>
<input type='hidden' name='tax_out_dt' 		value='<%=tax_out_dt%>'>
</form>
<a href="javascript:go_step()">2단계로 가기</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//에러발생
		//이미 작성한 거래명서세 리스트 삭제
		if(!IssueDb.deleteTaxAll(reg_code)) flag += 1;%>
		alert("거래명세서 리스트 작성중 에러가 발생하였습니다.");
<%	}else{//정상%>
		go_step();
<%	}%>
//-->
</script>
</body>
</html>
