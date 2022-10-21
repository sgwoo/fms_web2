<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.* "%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	out.println("세금계산서 발행하기 1단계"+"<br><br>");
	
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))		br_id 	= acar_br;
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "06", "10");
	
	String reg_st 		= request.getParameter("reg_st")==null?"":request.getParameter("reg_st");//all-전체발행,select선택발행
	String reg_gu 		= request.getParameter("reg_gu")==null?"":request.getParameter("reg_gu");//1-일괄발행,2-통합발행,3-개별발행
	String mail_auto_yn = request.getParameter("mail_auto_yn")==null?"":request.getParameter("mail_auto_yn");//메일발행방식
	
	String vid1[] 		= request.getParameterValues("h_l_cd");
	String vid2[] 		= request.getParameterValues("ch_l_cd");
	
	String vid_num			= "";
	String ch_client_id	= "";
	String ch_site_id		= "";
	String ch_r_req_dt	= "";
	String ch_tax_out_dt= "";
	String ch_print_st	= "";
	String ch_s_st			= "";
	String ch_cnt				= "";
	String car_mng_id 	= "";
	String client_id 		= "";
	String site_id 			= "";
	String item_id 			= "";
	int vid_size 				= 0;
	int seq 			= 1;
	int flag 			= 0;


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
		ch_client_id 	= vid_num.substring(0,6);
		ch_site_id 		= vid_num.substring(6,8);
		ch_r_req_dt 	= vid_num.substring(8,16);
		ch_tax_out_dt = vid_num.substring(16,24);
		ch_print_st 	= vid_num.substring(24,25);
		ch_s_st 			= vid_num.substring(25,26);
		ch_cnt 				= vid_num.substring(26);
		
		Vector vt = IssueDb.getIssue2FeeScdList(ch_client_id, ch_site_id, ch_r_req_dt, ch_tax_out_dt, ch_s_st);
		int vt_size = vt.size();
		out.println(ch_client_id+ch_site_id+ch_r_req_dt+ch_tax_out_dt+ch_s_st+" 스케줄갯수="+vt_size+"<br>");
		
		//사용할 item_id 가져오기
		item_id = IssueDb.getItemIdNext(ch_r_req_dt);
		
		for(int j=0;j < vt_size;j++){
			Hashtable ht = (Hashtable)vt.elementAt(j);
			TaxItemListBean til_bean = new TaxItemListBean();
			til_bean.setItem_id			(item_id);
			til_bean.setItem_seq		(seq);
			til_bean.setItem_g			("대여료");
			til_bean.setItem_car_no	(String.valueOf(ht.get("CAR_NO")));
			til_bean.setItem_car_nm	(String.valueOf(ht.get("CAR_NM")));
			til_bean.setItem_dt1		(String.valueOf(ht.get("USE_S_DT")));
			til_bean.setItem_dt2		(String.valueOf(ht.get("USE_E_DT")));
			til_bean.setItem_supply	(AddUtil.parseInt(String.valueOf(ht.get("FEE_S_AMT"))));
			til_bean.setItem_value	(AddUtil.parseInt(String.valueOf(ht.get("FEE_V_AMT"))));
			til_bean.setRent_l_cd		(String.valueOf(ht.get("RENT_L_CD")));
			til_bean.setCar_mng_id	(String.valueOf(ht.get("CAR_MNG_ID")));
			til_bean.setTm					(String.valueOf(ht.get("FEE_TM")));
			til_bean.setGubun				("1");
			til_bean.setReg_id			(user_id);
			til_bean.setReg_code		(reg_code);
			til_bean.setRent_st			(String.valueOf(ht.get("RENT_ST")));
			til_bean.setRent_seq		(String.valueOf(ht.get("RENT_SEQ")));
			til_bean.setCar_use			(String.valueOf(ht.get("CAR_USE")));
			til_bean.setItem_dt			(String.valueOf(ht.get("REQ_DT")));
			til_bean.setEtc					(String.valueOf(ht.get("ETC")));
			
			if(String.valueOf(ht.get("TM_ST2")).equals("4")){
				til_bean.setItem_g			("선급대여료");
			}
			
			//gubun = 1 대여료, 2 보증금, 3 선납금, 4 개시대여료, 5 위약금, 6 차량매각대금, 7 정비비, 8 과태료, 9 self, 10 보험대차, 11 대차료, 12 휴차료, 13 업무대여 
			
			if(!IssueDb.insertTaxItemList(til_bean)) flag += 1;
			seq++;
			
			out.println(" car_mng_id, rent_l_cd ="+ht.get("RENT_L_CD")+ " " +ht.get("CAR_MNG_ID")+"<br>");
		}
		seq = 1;
	}
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = '/tax/issue_1_item/tax_reg_step2.jsp';
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
<input type='hidden' name='reg_st' value='<%=reg_st%>'>
<input type='hidden' name='reg_gu' value='<%=reg_gu%>'>
<input type='hidden' name='reg_code' value='<%=reg_code%>'>
<input type='hidden' name='mail_auto_yn' value='<%=mail_auto_yn%>'>
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
