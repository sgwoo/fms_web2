<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*, acar.bill_mng.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String cardno 	= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String buy_id 	= request.getParameter("buy_id")==null?"":request.getParameter("buy_id");
	
	String acct_code 	= request.getParameter("acct_code")==null?"":request.getParameter("acct_code");
	String acct_code_g 	= request.getParameter("acct_code_g")==null?"":request.getParameter("acct_code_g");
	String buy_dt 		= request.getParameter("buy_dt")==null?"":request.getParameter("buy_dt");
	
	int flag = 0;
	
	out.println("전표수정"+"<br><br>");
	
	//정비입력으로 인한 변경 - 20091015	
	String acct_cont[] 		= request.getParameterValues("acct_cont"); //적요 : 정비 및 사고이외는 1행
	String item_name[] 		= request.getParameterValues("item_name"); // car_no
	String rent_l_cd[] 		= request.getParameterValues("rent_l_cd"); //rent_l_cd
	String serv_id[] 		= request.getParameterValues("serv_id"); //정비id
	String item_code[] 		= request.getParameterValues("item_code"); //car_mng_id
	String call_t_nm[] 		= request.getParameterValues("call_t_nm");   //정비 call center 관련
	String call_t_tel[] 	= request.getParameterValues("call_t_tel");
	
	String o_cau[] 		= request.getParameterValues("o_cau");   // 사유 
	String oil_liter[] 	= request.getParameterValues("oil_liter");  //쥬유량
	String tot_dist[] 	= request.getParameterValues("tot_dist");  //주행거리 
		
	//카드정보
	CardDocBean cd_bean = CardDb.getCardDoc(cardno, buy_id);
	
	cd_bean.setBuy_dt(buy_dt);
	cd_bean.setBuy_s_amt(request.getParameter("buy_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("buy_s_amt")));
	cd_bean.setBuy_v_amt(request.getParameter("buy_v_amt")==null?0:AddUtil.parseDigit(request.getParameter("buy_v_amt")));
	cd_bean.setBuy_amt(request.getParameter("buy_amt")==null?0:AddUtil.parseDigit(request.getParameter("buy_amt")));
	cd_bean.setVen_code(request.getParameter("ven_code")==null?"":request.getParameter("ven_code"));
	cd_bean.setVen_name(request.getParameter("ven_name")==null?"":request.getParameter("ven_name"));
	cd_bean.setAcct_code(request.getParameter("acct_code")==null?"":request.getParameter("acct_code"));
	cd_bean.setTax_yn(request.getParameter("tax_yn")==null?"N":request.getParameter("tax_yn"));
	cd_bean.setVen_st(request.getParameter("ven_st")==null?"1":request.getParameter("ven_st"));
	cd_bean.setR_buy_dt(request.getParameter("r_buy_dt")==null?"":request.getParameter("r_buy_dt"));
	
	//복리후생비,접대비,여비교통비,차량유류대,차량정비비
	if(acct_code.equals("00001") || acct_code.equals("00002") || acct_code.equals("00003") || acct_code.equals("00004") || acct_code.equals("00005") || acct_code.equals("00009") || acct_code.equals("00016") || acct_code.equals("00017") ){
		cd_bean.setAcct_code_g(request.getParameter("acct_code_g")==null?"":request.getParameter("acct_code_g"));
	}
	//복리후생비
	if(acct_code.equals("00001") || acct_code.equals("00004") || acct_code.equals("00005")){
		cd_bean.setAcct_code_g2(request.getParameter("acct_code_g2")==null?"":request.getParameter("acct_code_g2"));
	}
	
	//차량유류비,차량정비비,사고수리비, 운반비, 주차요금
	if(acct_code.equals("00004") || acct_code.equals("00005") || acct_code.equals("00006") || acct_code.equals("00018") || acct_code.equals("00019") ){
		cd_bean.setItem_code(item_code[0]);
		cd_bean.setItem_name(item_name[0]);		
		
	}
	
	//차량정비비,사고수리비
	if(acct_code.equals("00005") || acct_code.equals("00006") ){
		cd_bean.setServ_id(serv_id[0]);
		 
	}
	
	if(acct_code.equals("00004")) {			
		cd_bean.setRent_l_cd(rent_l_cd[0]);
		cd_bean.setO_cau	(o_cau[0]);
		cd_bean.setOil_liter	( AddUtil.parseFloat( oil_liter[0]  )  );
		cd_bean.setTot_dist		(AddUtil.parseInt(tot_dist[0]));
		
	}
	
	if( ( acct_code.equals("00005")  &&  acct_code_g.equals("6")  ) || acct_code.equals("00006")){	
//	if(acct_code.equals("00005")) {
		cd_bean.setCall_t_nm(call_t_nm[0]);
		cd_bean.setCall_t_tel(call_t_tel[0]);
	}
	
	cd_bean.setAcct_cont(acct_cont[0]);
	cd_bean.setUser_su(request.getParameter("user_su")==null?"":request.getParameter("user_su"));
	cd_bean.setUser_cont(request.getParameter("user_cont")==null?"":request.getParameter("user_cont"));
	cd_bean.setBuy_user_id(request.getParameter("buy_user_id")==null?"":request.getParameter("buy_user_id"));
	cd_bean.setRent_l_cd(rent_l_cd[0]);
	
	if(!CardDb.updateCardDoc(cd_bean)) flag += 1;
	
	out.println("flag="+flag+"<br><br>");
	
	//[1_1단계] 전표수정-참가자 수정
	//참가자 관리
	int user_su 	= request.getParameter("user_su")==null?0:AddUtil.parseInt(request.getParameter("user_su"));
	
	String value1[] = request.getParameterValues("user_case_id");
	String value2[] = request.getParameterValues("money");
	String value3[] = request.getParameterValues("client_nm");
	String value4[] = request.getParameterValues("mgr_nm");
	String value5[] = request.getParameterValues("user_nm");
	int cnt = 0;
	
	if(!CardDb.deleteCardDocUser(cardno, buy_id)) flag += 1;
	
	if(user_su > 0){
		for(int i=0;i < user_su;i++){
			if(!value2[i].equals("0")){
				CardDocUserBean cdu_bean = new CardDocUserBean();
				cdu_bean.setCardno	(cardno);
				cdu_bean.setBuy_id	(buy_id);
				cdu_bean.setSeq		(AddUtil.addZero2(i+1));
				cdu_bean.setUser_st	("1");
				if(!value1[i].equals("")) 		cdu_bean.setDoc_user(value1[i]);
				else							cdu_bean.setDoc_user(value5[i+1]);
				cdu_bean.setDoc_amt	(AddUtil.parseDigit(value2[i]));
				if(!CardDb.insertCardDocUser(cdu_bean)) flag += 1;
				cnt ++;
			}
		}
	}
	
	//
	int cnt1 = 0;
	int car_su = request.getParameter("car_su")==null?0:AddUtil.parseInt(request.getParameter("car_su")) ;
	//정비 및 사고관련하여 다중으로 차량 입력 한 경우		
	
	if( ( acct_code.equals("00005")  &&  acct_code_g.equals("6")  ) ||  ( acct_code.equals("00005")  &&  acct_code_g.equals("21")  )   || acct_code.equals("00006")){	
			
		   //정비데이타 결재 무효 처리
		Vector vt = CardDb.getCardDocItemList(cardno, buy_id);
		int vt_size = vt.size();
		
		for(int i=0; i < vt_size; i++){
       		Hashtable ht = (Hashtable)vt.elementAt(i);       		
       		if(!CardDb.updateCardDocItem(String.valueOf(ht.get("ITEM_CODE")), String.valueOf(ht.get("SERV_ID")))  ) flag += 1;       	       				
		}	
		
		if(!CardDb.deleteCardDocItem(cardno, buy_id)) flag += 1;
		
		for(int i=0;i < car_su;i++){
			if(!item_name[i].equals("")){
					CardDocItemBean cdi_bean = new CardDocItemBean();
					cdi_bean.setCardno	(cardno);
					cdi_bean.setBuy_id	(buy_id);
					cdi_bean.setSeq		(AddUtil.addZero2(i+1));
					cdi_bean.setItem_code(item_code[i]);	
					cdi_bean.setRent_l_cd(rent_l_cd[i]);	
					cdi_bean.setServ_id(serv_id[i]);	
					cdi_bean.setItem_name(item_name[i]);	
					cdi_bean.setAcct_cont(acct_cont[i]);	
					cdi_bean.setCall_t_nm(call_t_nm[i]);	
					cdi_bean.setCall_t_tel(call_t_tel[i]);						
												
				//	cdi_bean.setDoc_amt	(AddUtil.parseDigit(doc_amt[i]));
					if(!CardDb.insertCardDocItem(cdi_bean)) flag += 1;
					
					//정비에 정산 표시 - car_mng_id , serv_id 로 jung_st = '1'로 
					if(!CardDb.updateCardDocServiceItem(item_code[i], serv_id[i], buy_dt , call_t_nm[i], call_t_tel[i] ) ) flag += 1;
					cnt1 ++;
			}
		}
	}
	
	// 전기차 충전인경우 (유류대)  - 다중입력 
	if(  acct_code.equals("00004")  &&  acct_code_g.equals("27")  ) {	
			
		if(!CardDb.deleteCardDocItem(cardno, buy_id)) flag += 1;
		
		for(int i=0;i < car_su; i++){
			if(!item_name[i].equals("")){
					CardDocItemBean cdi_bean = new CardDocItemBean();
					cdi_bean.setCardno	(cardno);
					cdi_bean.setBuy_id	(buy_id);
					cdi_bean.setSeq		(AddUtil.addZero2(i));
					cdi_bean.setItem_code(item_code[i]);	
					cdi_bean.setRent_l_cd(rent_l_cd[i]);			
					cdi_bean.setItem_name(item_name[i]);	
					cdi_bean.setAcct_cont(acct_cont[i]);	
					cdi_bean.setO_cau(o_cau[i]);	  //사유
					cdi_bean.setOil_liter	( AddUtil.parseFloat( oil_liter[i]  )  );
					cdi_bean.setTot_dist		(AddUtil.parseInt(tot_dist[i]));
																	
				//	cdi_bean.setDoc_amt	(AddUtil.parseDigit(doc_amt[i]));
					if(!CardDb.insertCardDocItem(cdi_bean)) flag += 1;								
					cnt1 ++;
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
		document.domain = "amazoncar.co.kr";
		fm.action = 'doc_mng_frame.jsp';
		fm.target = "_parent";
		fm.submit();

		parent.window.close();		
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' action='' method='post'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='cardno' 	value='<%=cardno%>'>
</form>
<a href="javascript:go_step()">다음으로</a>
<script language='javascript'>
<!--
<%		if(flag > 0){//에러발생%>
		alert("에러가 발생하였습니다.");
<%		}else{//정상%>
		alert("수정되었습니다.");
		go_step();
<%		}%>
//-->
</script>
</body>
</html>
