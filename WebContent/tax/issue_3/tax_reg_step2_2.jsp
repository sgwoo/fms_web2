<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*, tax.*, acar.fee.*, acar.forfeit_mng.*, acar.user_mng.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
	
	out.println("세금계산서 발행하기 2단계"+"<br><br>");
	
	String client_id 		= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String tax_g 			= request.getParameter("tax_g")==null?"":request.getParameter("tax_g");
	String tax_bigo 		= request.getParameter("tax_bigo")==null?"":request.getParameter("tax_bigo");
	String req_dt 			= request.getParameter("req_dt")==null?"":request.getParameter("req_dt");
	String reg_gu 			= request.getParameter("reg_gu")==null?"":request.getParameter("reg_gu");//1-일괄발행,2-통합발행,3-개별발행
	String reg_code 		= request.getParameter("reg_code")==null?"":request.getParameter("reg_code");
	String item_list_cnt 	= request.getParameter("item_list_cnt")==null?"":request.getParameter("item_list_cnt");
	String item_id 			= request.getParameter("item_id")==null?"":request.getParameter("item_id");
	String item_seq 		= request.getParameter("item_seq")==null?"":request.getParameter("item_seq");
	String t_item_supply 	= request.getParameter("t_item_supply")==null?"":request.getParameter("t_item_supply");
	String t_item_value 	= request.getParameter("t_item_value")==null?"":request.getParameter("t_item_value");
	String t_item_amt 		= request.getParameter("t_item_amt")==null?"":request.getParameter("t_item_amt");
	String tax_bigo_t 		= request.getParameter("tax_bigo_t")==null?"":request.getParameter("tax_bigo_t");
	String tax_bigo_50 		= request.getParameter("tax_bigo_50")==null?"":request.getParameter("tax_bigo_50");
	String tax_dt 		= request.getParameter("tax_dt")==null?"":request.getParameter("tax_dt");
	
	String con_agnt_nm 		= request.getParameter("con_agnt_nm")==null?"":request.getParameter("con_agnt_nm");
	String con_agnt_dept 	= request.getParameter("con_agnt_dept")==null?"":request.getParameter("con_agnt_dept");
	String con_agnt_title 	= request.getParameter("con_agnt_title")==null?"":request.getParameter("con_agnt_title");
	String con_agnt_email 	= request.getParameter("con_agnt_email")==null?"":request.getParameter("con_agnt_email");
	String con_agnt_m_tel 	= request.getParameter("con_agnt_m_tel")==null?"":request.getParameter("con_agnt_m_tel");
	
	String go_url 	= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String site_id 		= request.getParameter("i_site_id")==null?"":request.getParameter("i_site_id");
	String brch_id 		= request.getParameter("o_br_id")==null?"":request.getParameter("o_br_id");
	
	String ebill_yn = request.getParameter("ebill_yn")==null?"N":request.getParameter("ebill_yn");//트러스빌사용여부
	
	if(!con_agnt_email.equals(""))	ebill_yn = "Y";
	if(tax_dt.equals("")) 			tax_dt = req_dt;
	
	out.println("client_id  ="+client_id+"<br>");
	out.println("site_id  ="+site_id+"<br>");
	out.println("brch_id="+brch_id+"<br>");
	out.println("tax_g  ="+tax_g+"<br>");
	out.println("tax_bigo  ="+tax_bigo+"<br>");
	out.println("req_dt  ="+req_dt+"<br>");
	out.println("reg_gu  ="+reg_gu+"<br>");	
	out.println("reg_code="+reg_code+"<br>");
	out.println("item_list_cnt="+item_list_cnt+"<br><br>");
	out.println("item_id="+item_id+"<br><br>");
	
	int flag = 0;
	String item_man = "";

/*
	//[2단계] 거래명세서 생성

	Vector vt = IssueDb.getTaxItemListSusi(reg_code);
	int vt_size = vt.size();
	if(reg_gu.equals("3_1")){//선수금
		out.println("선수금 거래구분="+reg_gu+"<br><br>");
	}else if(reg_gu.equals("3_2")){//단기대여
		out.println("단기대여 거래구분="+reg_gu+"<br><br>");
	}else if(reg_gu.equals("3_3")){//매각
		out.println("단기대여 거래구분="+reg_gu+"<br><br>");
	}else if(reg_gu.equals("3_4")){//차량수리
		out.println("차량수리 거래구분="+reg_gu+"<br><br>");
	}
	out.println("거래명세서 생성="+vt_size+"<br><br>");
	
	
	for(int i=0;i < vt_size;i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		TaxItemBean ti_bean = new TaxItemBean();
		ti_bean.setClient_id(client_id);
		ti_bean.setSeq(site_id);
		ti_bean.setItem_dt(req_dt);
		ti_bean.setTax_id("");
		ti_bean.setItem_id(String.valueOf(ht.get("ITEM_ID")));
		ti_bean.setItem_hap_str(AddUtil.parseDecimalHan(String.valueOf(ht.get("ITEM_HAP_NUM")))+"원");
		ti_bean.setItem_hap_num(AddUtil.parseInt(String.valueOf(ht.get("ITEM_HAP_NUM"))));
		ti_bean.setItem_man(String.valueOf(ht.get("ITEM_MAN")));
		
		if(!IssueDb.insertTaxItem(ti_bean)) flag += 1;
	}
*/


	//거래명세서 조회
		TaxItemBean ti_bean 	= IssueDb.getTaxItemCase(item_id);
		
		ti_bean.setItem_dt(tax_dt);
		ti_bean.setItem_hap_str	(AddUtil.parseDecimalHan(t_item_amt)+"원");
		ti_bean.setItem_hap_num	(AddUtil.parseDigit(t_item_amt));
		if(!IssueDb.updateTaxItem(ti_bean)) flag += 1;
		item_man = ti_bean.getItem_man();
		
	//거래명세서 리스트 조회
		TaxItemListBean til_bean = IssueDb.getTaxItemListCase(item_id, item_seq);
		til_bean.setItem_supply	(AddUtil.parseDigit(t_item_supply));
		til_bean.setItem_value	(AddUtil.parseDigit(t_item_value));
		if(!IssueDb.updateTaxItemList(til_bean)) flag += 1;



	//[3단계] 세금계산서 생성
	if(!reg_gu.equals("3_6")){//3_6 휴차료는 거래명세서 발행까지만 한다.
		//사용할 tax_no 가져오기
		String tax_no = IssueDb.getTaxNoNext();
		String min_tax_no = tax_no;
		out.println("tax_no="+tax_no+"<br><br>");

		Vector vt2 = IssueDb.getTaxItemSusi(reg_code);
		int vt_size2 = vt2.size();
		out.println("세금계산서 생성="+vt_size2+"<br><br>");
		
		for(int i=0;i < vt_size2;i++){
			Hashtable ht = (Hashtable)vt2.elementAt(i);
			
			//tax_no = min_tax_no.substring(0,3)+AddUtil.addZero5(AddUtil.parseInt(min_tax_no.substring(3))+i);
			
			TaxBean t_bean = new TaxBean();
			t_bean.setClient_id(client_id);
			t_bean.setSeq(site_id);
			t_bean.setTax_dt(tax_dt);
			t_bean.setBranch_g(brch_id);
			t_bean.setTax_g(tax_g);
			t_bean.setTax_bigo(tax_bigo_50);
			t_bean.setTax_no(tax_no);
			t_bean.setRent_l_cd(String.valueOf(ht.get("RENT_L_CD")));
			t_bean.setFee_tm(String.valueOf(ht.get("TM")));
			t_bean.setCar_mng_id(String.valueOf(ht.get("CAR_MNG_ID")));
			if(AddUtil.parseInt(item_list_cnt) == 1){
				t_bean.setUnity_chk("0");//통합여부0=개별,1=통합
			}else{
				t_bean.setUnity_chk("1");//통합여부0=개별,1=통합
			}
			t_bean.setTax_supply(AddUtil.parseInt(String.valueOf(ht.get("TAX_SUPPLY"))));
			t_bean.setTax_value(AddUtil.parseInt(String.valueOf(ht.get("TAX_VALUE"))));
			t_bean.setTax_id(String.valueOf(ht.get("CLIENT_ID")));
			t_bean.setItem_id(String.valueOf(ht.get("ITEM_ID")));
			t_bean.setCar_no(String.valueOf(ht.get("CAR_NO")));
			t_bean.setCar_nm(String.valueOf(ht.get("CAR_NM")));
			t_bean.setTax_st("O");
			t_bean.setReg_id(user_id);
		  	if(site_id.equals("") || site_id.equals("00")){
	  			t_bean.setTax_type("1");
  			}else{
  				t_bean.setTax_type("2");
	  		}
			t_bean.setGubun(String.valueOf(ht.get("GUBUN")));
			t_bean.setCon_agnt_nm(con_agnt_nm);
			t_bean.setCon_agnt_dept(con_agnt_dept);
			t_bean.setCon_agnt_title(con_agnt_title);
			t_bean.setCon_agnt_email(con_agnt_email.trim());
			t_bean.setCon_agnt_m_tel(con_agnt_m_tel);
			
			//공급받는자정보 : 20090608 작업
			t_bean.setRecTel			(String.valueOf(ht.get("RECTEL")));
			t_bean.setRecCoRegNo		(String.valueOf(ht.get("RECCOREGNO")));
			t_bean.setRecCoName			(String.valueOf(ht.get("RECCONAME2")));
			t_bean.setRecCoCeo			(String.valueOf(ht.get("RECCOCEO")));
			t_bean.setRecCoAddr			(String.valueOf(ht.get("RECCOADDR")));
			t_bean.setRecCoBizType		(String.valueOf(ht.get("RECCOBIZTYPE2")));
			t_bean.setRecCoBizSub		(String.valueOf(ht.get("RECCOBIZSUB2")));
			
			//공급받는자가 개인일때와 법인일대의 처리
			if(String.valueOf(ht.get("RECCOREGNO")).length() == 13){
				t_bean.setTax_bigo	(t_bean.getTax_bigo()+"-"+String.valueOf(ht.get("RECCOREGNO")));
				t_bean.setRecCoRegNo("0000000000");
			}else{
				t_bean.setRecCoRegNo(String.valueOf(ht.get("RECCOREGNO")));
			}
			
			if(!IssueDb.insertTax(t_bean)) flag += 1;
			
			if(reg_gu.equals("3_9")){
				UserMngDatabase umd = UserMngDatabase.getInstance();
				UsersBean sender_bean 	= umd.getUsersBean(user_id);
				UsersBean target_bean 	= umd.getUserNmBean(item_man);
				if(!sender_bean.getUser_nm().equals(target_bean.getUser_nm())){
					IssueDb.insertsendMail(sender_bean.getUser_m_tel(), sender_bean.getUser_nm(), target_bean.getUser_m_tel(), target_bean.getUser_nm(), "", "", "[대차료계산서발행]"+t_bean.getCar_no());
				}
			}
		}
	}
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		if(fm.reg_gu.value == '3_3'){		
			alert("정상적으로 발행하였습니다.");
			fm.action = '/tax/issue_3/issue_3_frame3.jsp';		
			fm.target = 'd_content';			
		}else if(fm.reg_gu.value == '3_6'){
			alert("정상적으로 발행하였습니다.");
			fm.action = '/tax/issue_3/issue_3_frame6.jsp';		
			fm.target = 'd_content';					
		}else{
			fm.action = '../issue_1/tax_reg_step4.jsp';
		}		
		fm.submit();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' action='' method='post'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='client_id' 	value='<%=client_id%>'>
<input type='hidden' name='site_id' 	value='<%=site_id%>'>
<input type='hidden' name='brch_id' 	value='<%=brch_id%>'>
<input type='hidden' name='tax_g' 		value='<%=tax_g%>'>
<input type='hidden' name='tax_bigo' 	value='<%=tax_bigo%>'>
<input type='hidden' name='req_dt' 		value='<%=req_dt%>'>
<input type='hidden' name='reg_gu' 		value='<%=reg_gu%>'>
<input type='hidden' name='reg_code' 	value='<%=reg_code%>'>
<input type='hidden' name='ebill_yn' 	value='<%=ebill_yn%>'>
<input type='hidden' name='tax_bigo_t' 	value='<%=tax_bigo_t%>'>
<input type='hidden' name='go_url' value='<%=go_url%>'>
<a href="javascript:go_step()">3단계로 가기</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//에러발생
		//이미 작성한 거래명서세/세금계산서  삭제
//		if(!IssueDb.deleteTaxAll(reg_code)) flag += 1;%>
		alert("거래명세서/세금계산서 작성중 에러가 발생하였습니다.");
<%	}else{//정상%>
		go_step();
<%	}%>
//-->
</script>
</form>
</body>
</html>
