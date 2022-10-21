<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cls.*, tax.*, acar.bill_mng.*, acar.user_mng.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String tax_dt 	= request.getParameter("tax_dt")==null?"":request.getParameter("tax_dt");
	String tax_g 	= request.getParameter("tax_g")==null?"":request.getParameter("tax_g");
 	String tax_bigo = request.getParameter("tax_bigo")==null?"":	request.getParameter("tax_bigo");
	
	String tax_amt[] 	= request.getParameterValues("tax_amt");
	String tax_supply[] 	= request.getParameterValues("tax_supply");
	String tax_value[] 	= request.getParameterValues("tax_value");
	String user_nm[] 	= request.getParameterValues("user_nm");
	String user_ssn[] 	= request.getParameterValues("user_ssn");
	String car_mng_id[] 	= request.getParameterValues("car_mng_id");
	String car_no[] 	= request.getParameterValues("car_no");
	String car_nm[] 	= request.getParameterValues("car_nm");
	String car_use[] 	= request.getParameterValues("car_use");
	
	
	String vid[] = request.getParameterValues("ch_l_cd");
	
	String vid_num="";
	String ch_user_id="";
	int ch_idx = 0;
	int vid_size = 0;
	int seq = 1;
	int flag = 0;

	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	

   	out.println("tax_dt="+tax_dt+"<br>");
   	out.println("tax_g="+tax_g+"<br>");
   	out.println("tax_bigo="+tax_bigo+"<br>");

	vid_size = vid.length;
	out.println("선택건수="+vid_size+"<br><br>");

	String reg_code  = Long.toString(System.currentTimeMillis());
	out.println("실행코드="+reg_code+"<br>");


	//[1단계] 세금계산서 리스트 생성
	
	int tax_size = tax_amt.length;
	String tax_no = "";
	String item_id = "";
	int data_no =0;
  	int tax_cnt = 0;
	
	UsersBean sender_bean 	= umd.getUsersBean(nm_db.getWorkAuthUser("세금계산서담당자"));
	
	for(int i=0;i < vid_size;i++){
		
		vid_num = vid[i];
		ch_user_id 		= vid_num.substring(0,6);
		ch_idx 			= AddUtil.parseInt(vid_num.substring(6));
		out.println("ch_user_id="+ch_user_id+", ch_idx="+ch_idx+"<br>");
   		out.println("선택"+i+"=<br><br>");
		
		UsersBean user_bean 	= umd.getUsersBean(ch_user_id);
		
		
		
		//사용할 item_id 가져오기
		item_id = IssueDb.getItemIdNext(AddUtil.replace(tax_dt,"-",""));
		
		TaxItemListBean til_bean = new TaxItemListBean();
		
		til_bean.setItem_id			(item_id);
		til_bean.setItem_seq		(1);
		til_bean.setItem_g			(tax_g);
		til_bean.setItem_car_no		(car_no[ch_idx]);
		til_bean.setItem_car_nm		(car_nm[ch_idx]);
		til_bean.setItem_dt1		("");
		til_bean.setItem_dt2		("");
		til_bean.setItem_supply		(AddUtil.parseDigit(tax_supply[ch_idx]));
		til_bean.setItem_value		(AddUtil.parseDigit(tax_value[ch_idx]));
		til_bean.setRent_l_cd		("");
		til_bean.setCar_mng_id		(car_mng_id[ch_idx]);
		til_bean.setTm				("");
		til_bean.setGubun			("13");
		til_bean.setReg_id			(sender_bean.getUser_id());
		til_bean.setReg_code		(reg_code);
		til_bean.setRent_seq		("");
		til_bean.setCar_use			(car_use[ch_idx]);
		til_bean.setItem_dt			(AddUtil.replace(tax_dt,"-",""));
		
		if(!IssueDb.insertTaxItemList(til_bean)) flag += 1;
		
		
		
		TaxItemBean ti_bean = new TaxItemBean();
		ti_bean.setClient_id		(ch_user_id);
		ti_bean.setSeq				("");
		ti_bean.setItem_dt			(AddUtil.replace(tax_dt,"-",""));
		ti_bean.setTax_id			("");
		ti_bean.setItem_id			(item_id);
		ti_bean.setItem_hap_str		(AddUtil.parseDecimalHan(String.valueOf(til_bean.getItem_supply()+til_bean.getItem_value()))+"원");
		ti_bean.setItem_hap_num		(til_bean.getItem_supply()+til_bean.getItem_value());
		ti_bean.setItem_man			(sender_bean.getUser_nm());
		ti_bean.setCust_st			("4");
		
		if(!IssueDb.insertTaxItem(ti_bean)) flag += 1;
		
		
    		tax_no = IssueDb.getTaxNoNext(AddUtil.replace(tax_dt,"-",""));
       		out.println("tax_no="+tax_no+"<br>");
       		out.println("setTax_supply="+tax_supply[ch_idx]+"<br>");
       		out.println("setTax_value="+tax_value[ch_idx]+"<br>");
		
		
       		tax.TaxBean t_bean = new tax.TaxBean();
		
       		t_bean.setClient_id			(ch_user_id);
       		t_bean.setTax_dt			(tax_dt);
      		t_bean.setUnity_chk			("0");//통합여부0=개별,1=통합
   		t_bean.setRent_l_cd			("");
   		t_bean.setFee_tm			("");
       		t_bean.setCar_mng_id			(car_mng_id[ch_idx]);
		t_bean.setBranch_g			("S1");
   		t_bean.setTax_g				(tax_g);
   		t_bean.setTax_supply			(AddUtil.parseDigit(tax_supply[ch_idx]));
 		t_bean.setTax_value			(AddUtil.parseDigit(tax_value[ch_idx]));
   		t_bean.setTax_id			(ch_user_id);
   		t_bean.setItem_id			(item_id);
   		t_bean.setTax_bigo			(tax_bigo);
   		t_bean.setSeq				("");
   		t_bean.setTax_no			(tax_no);
   		t_bean.setCar_no			(car_no[ch_idx]);
   		t_bean.setCar_nm			(car_nm[ch_idx]);
   		t_bean.setTax_st			("O");
   		t_bean.setTax_type			("");
   		t_bean.setGubun				("13");
   		t_bean.setReg_id			(sender_bean.getUser_id());
		
		t_bean.setCon_agnt_nm			(user_bean.getUser_nm());
		t_bean.setCon_agnt_dept			(user_bean.getDept_nm());
		t_bean.setCon_agnt_title		(user_bean.getUser_pos());
		t_bean.setCon_agnt_email		("");//user_bean.getUser_email()
		t_bean.setCon_agnt_m_tel		("");//user_bean.getUser_m_tel()
		
		//공급받는자정보 : 20090608 작업
		t_bean.setRecTel			(user_bean.getUser_m_tel());
		t_bean.setRecCoRegNo			(user_bean.getUser_ssn());
		t_bean.setRecCoName			(user_bean.getUser_nm());
		t_bean.setRecCoCeo			(user_bean.getUser_nm());
		t_bean.setRecCoAddr			(user_bean.getAddr());
		t_bean.setRecCoBizType			("");
		t_bean.setRecCoBizSub			("");
		t_bean.setRecCoSsn			(user_bean.getUser_ssn());
		t_bean.setReccoregnotype		("02");//사업자구분-주민등록번호
		t_bean.setCust_st			("4");
		
   		if(!IssueDb.insertTax(t_bean)) flag += 1;
   		
   		
   		//신입사원 더존 거래처등록
   		if(user_bean.getVen_code().equals("")){
   		
   			NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
   				
			String ven_code2 ="";
			int count = 0;
			int flag2 = 0;
		
			ven_code2 = neoe_db.getVenCodeChk("2", user_bean.getUser_nm(), user_bean.getUser_ssn(), "");
		
			if(ven_code2.equals("")){
			
			
				TradeBean tr_bean = new TradeBean();
				
				tr_bean.setCust_name		(user_bean.getUser_nm());
				tr_bean.setS_idno		("8888888888");
				tr_bean.setId_no		(user_bean.getUser_ssn());
				tr_bean.setDname		(user_bean.getUser_nm());
				tr_bean.setMail_no		(user_bean.getZip());
				tr_bean.setS_address		(user_bean.getAddr());
				tr_bean.setUptae		("");
				tr_bean.setJong			("");
			
				if(!neoe_db.insertTrade(tr_bean)) flag2 += 1;	//-> neoe_db 변환
				
				ven_code2 = neoe_db.getVenCodeChk("2", user_bean.getUser_nm(), user_bean.getUser_ssn(), "");
				
				user_bean.setVen_code	(ven_code2);
			
				count = umd.updateUserBank(user_bean);
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
//		fm.action = '/tax/issue_3/issue_3_est8.jsp';
		fm.action = 'tax_reg_step3_proc.jsp';
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
<input type='hidden' name='tax_dt' 		value='<%=tax_dt%>'>
<input type='hidden' name='tax_g' 		value='<%=tax_g%>'>
<input type='hidden' name='tax_bigo' 	value='<%=tax_bigo%>'>
<input type='hidden' name='reg_code' 	value='<%=reg_code%>'>
<input type='hidden' name='reg_gu' 		value='3_8'>
<a href="javascript:go_step()">3단계로 가기</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//에러발생
		//이미 작성한 거래명서세/세금계산서  삭제
		if(!IssueDb.deleteTaxAll(reg_code)) flag += 1;%>
		alert("거래명세서/세금계산서 작성중 에러가 발생하였습니다.");
<%	}else{//정상%>
		go_step();
<%	}%>
//-->
</script>
</form>
</body>
</html>