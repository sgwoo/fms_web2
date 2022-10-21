<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, card.*, acar.user_mng.*, acar.bill_mng.*, acar.coolmsg.*, acar.cus_reg.*,acar.car_service.*"%>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String cardno 	= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String buy_id 	= request.getParameter("buy_id")==null?"":request.getParameter("buy_id");
	
	String acct_code 	= request.getParameter("acct_code")==null?"":request.getParameter("acct_code");
	String acct_code_g 	= request.getParameter("acct_code_g")==null?"":request.getParameter("acct_code_g");
	String acct_code_g2 	= request.getParameter("acct_code_g2")==null?"":request.getParameter("acct_code_g2");
	String acct_code_s 	= request.getParameter("acct_code_s")==null?"":request.getParameter("acct_code_s");
	String buy_dt 		= request.getParameter("buy_dt")==null?"":request.getParameter("buy_dt");
	String reg_id 		= request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	String app_id 		= request.getParameter("app_id")==null?"":request.getParameter("app_id");
	String buy_user_id 		= request.getParameter("buy_user_id")==null?"":request.getParameter("buy_user_id");
	String user_cont = request.getParameter("user_cont")==null?"":request.getParameter("user_cont");
	
	int  buy_amt = request.getParameter("buy_amt")==null?0:AddUtil.parseDigit(request.getParameter("buy_amt")) ;
	
	int flag = 0;
	
	String currdate   = new java.text.SimpleDateFormat("yyyyMMdd").format(new java.util.Date());
			
	CommonDataBase c_db = CommonDataBase.getInstance();
	
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
	String doc_amt[] 	= request.getParameterValues("doc_amt");  //아이템별 금액
	
	
	buy_dt = AddUtil.replace(buy_dt, "-", "");
	
	String buy_user_nm = "";
	buy_user_nm = c_db.getNameById(buy_user_id, "USER"); //사용자명 - 유류대, 정비비, 사고수리비
		
	//카드정보
	CardDocBean cd_bean = CardDb.getCardDoc(cardno, buy_id);
	
	cd_bean.setBuy_dt(buy_dt);
	cd_bean.setBuy_s_amt(request.getParameter("buy_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("buy_s_amt")));
	cd_bean.setBuy_v_amt(request.getParameter("buy_v_amt")==null?0:AddUtil.parseDigit(request.getParameter("buy_v_amt")));
	cd_bean.setBuy_amt(request.getParameter("buy_amt")==null?0:AddUtil.parseDigit(request.getParameter("buy_amt")));
	cd_bean.setVen_code(request.getParameter("ven_code")==null?"":request.getParameter("ven_code"));
	cd_bean.setVen_name(request.getParameter("ven_name")==null?"":request.getParameter("ven_name"));
	cd_bean.setAcct_code(acct_code);
	cd_bean.setTax_yn(request.getParameter("tax_yn")==null?"N":request.getParameter("tax_yn"));
	cd_bean.setVen_st(request.getParameter("ven_st")==null?"1":request.getParameter("ven_st"));
	
	cd_bean.setAcct_cont(acct_cont[0]);
	cd_bean.setUser_su(request.getParameter("user_su")==null?"":request.getParameter("user_su"));
	cd_bean.setUser_cont(user_cont);
	cd_bean.setBuy_user_id(buy_user_id);
	cd_bean.setRent_l_cd(rent_l_cd[0]);//일반정비 확인!!
	
	//미등록의 경우 등록자 등록
	if(app_id.equals("") && reg_id.equals("")){
		cd_bean.setReg_id(user_id);
		cd_bean.setReg_dt(currdate);
	}else if(app_id.equals("") && !reg_id.equals("")){
	}
		
	//복리후생비, 접대비, 여비교통비, 차량유류대, 차량정비비, 통신비, 대여사업차량, 리스사업차량 
	if(acct_code.equals("00001") || acct_code.equals("00002") || acct_code.equals("00003") || acct_code.equals("00004") || acct_code.equals("00005") || acct_code.equals("00009") || acct_code.equals("00016") || acct_code.equals("00017") ){
		cd_bean.setAcct_code_g(request.getParameter("acct_code_g")==null?"":request.getParameter("acct_code_g"));
	}
	//복리후생비, 차량유류대, 차량정비비 
	if(acct_code.equals("00001") || acct_code.equals("00004") || acct_code.equals("00005") ){
		cd_bean.setAcct_code_g2(request.getParameter("acct_code_g2")==null?"":request.getParameter("acct_code_g2"));
	}
	
	//차량유류대
	if(acct_code.equals("00004")){
		cd_bean.setItem_code(item_code[0]);
		cd_bean.setItem_name(item_name[0]);
		cd_bean.setRent_l_cd(rent_l_cd[0]);
		cd_bean.setO_cau	(o_cau[0]);
		cd_bean.setOil_liter	( AddUtil.parseFloat( oil_liter[0]  )  );
		cd_bean.setTot_dist		(AddUtil.parseInt(tot_dist[0]));
		cd_bean.setAcct_cont(acct_cont[0]);	
	}
		
	//차량정비비, 사고수리비, 운반비, 주차요금
	if(acct_code.equals("00005") || acct_code.equals("00006") || acct_code.equals("00018") || acct_code.equals("00019")){
		cd_bean.setItem_code(item_code[0]);
		cd_bean.setItem_name(item_name[0]);
		cd_bean.setRent_l_cd(rent_l_cd[0]);
		cd_bean.setAcct_cont(acct_cont[0]);
	}
	
	//차량정비비-일반정비, 사고수리비
	if( ( acct_code.equals("00005")  &&  acct_code_g.equals("6")  ) || ( acct_code.equals("00005")  &&  acct_code_g.equals("21")  ) || acct_code.equals("00006")){
		cd_bean.setCall_t_nm(call_t_nm[0]);
		cd_bean.setCall_t_tel(call_t_tel[0]);
		cd_bean.setServ_id(serv_id[0]);
	}
	
	
	if(!CardDb.updateCardDocScard(cd_bean)) flag += 1;
	
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
	
	if(acct_code_s.equals("0")||acct_code_s.equals("1")){
		CardDocUserBean cdu_bean = new CardDocUserBean();
		cdu_bean.setCardno	(cardno);
		cdu_bean.setBuy_id	(buy_id);
		cdu_bean.setSeq		(AddUtil.addZero2(1));
		cdu_bean.setUser_st	("1");
		cdu_bean.setDoc_user(buy_user_id);
		cdu_bean.setDoc_amt	(request.getParameter("buy_amt")==null?0:AddUtil.parseDigit(request.getParameter("buy_amt")));
		if(!CardDb.insertCardDocUser(cdu_bean)) flag += 1;
		cnt ++;
	}else{
	
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
	}
	
	//
	int cnt1 = 0;
	int car_su = request.getParameter("car_su")==null?0:AddUtil.parseInt(request.getParameter("car_su")) ;
	//정비 및 사고관련하여 다중으로 차량 입력 한 경우		, 전기차 충전인경우 (유류대) 
	
	if( ( acct_code.equals("00005")  &&  acct_code_g.equals("6")  ) ||  ( acct_code.equals("00005")  &&  acct_code_g.equals("21")  )   || acct_code.equals("00006")){	
		
		   //정비데이타 결재 무효 처리
		Vector vt = CardDb.getCardDocItemList(cardno, buy_id);
		int vt_size = vt.size();
		
		for(int i=0; i < vt_size; i++){
       		Hashtable ht = (Hashtable)vt.elementAt(i);       		
       		if(!CardDb.updateCardDocItem(String.valueOf(ht.get("ITEM_CODE")), String.valueOf(ht.get("SERV_ID")))  ) flag += 1;       	       				
       		
		}	
		
		if(!CardDb.deleteCardDocItem(cardno, buy_id)) flag += 1;
		
		for(int i=0;i < car_su; i++){
			if(!item_name[i].equals("")){
					CardDocItemBean cdi_bean = new CardDocItemBean();
					cdi_bean.setCardno	(cardno);
					cdi_bean.setBuy_id	(buy_id);					
					cdi_bean.setSeq		(AddUtil.addZero2(i));
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
	
	
	// 주차요금 다중 
	if(  acct_code.equals("00019")   ) {	
			
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
					cdi_bean.setDoc_amt	(AddUtil.parseDigit(doc_amt[i]));
					if(cdi_bean.getDoc_amt()==0){
						cdi_bean.setDoc_amt	( buy_amt / car_su );
					}					
					if(!CardDb.insertCardDocItem(cdi_bean)) flag += 1;								
					cnt1 ++;
			}
		}
	}
	
	if(acct_code.equals("00004") && acct_code_g2.equals("12") && buy_user_id.equals("000026")){
		
		boolean flag6 = true;
		UserMngDatabase umd = UserMngDatabase.getInstance();
		//2. 쿨메신저 알람 등록----------------------------------------------------------------------------------------
			
			String sub 		= "차량유류대-예비차 보충";
			String cont 	= "카드전표 "+acct_cont[1]+" 차량유류대-예비차 보충이 김광수님 이름으로 등록되었습니다.";			

			//사용자 정보 조회
			String target_id = "000026";
					
		
				UsersBean target_bean 	= umd.getUsersBean(target_id);
				UsersBean sender_bean 	= umd.getUsersBean(user_id);
				
				String url 		= "/card/doc_mng/doc_mng_frame.jsp";
				System.out.println("http://fms1.amazoncar.co.kr/card/doc_app/doc_reg_u.jsp?cardno="+cardno+"&buy_id="+buy_id);
				
				String xml_data = "";
				
				xml_data =  "<COOLMSG>"+
			  				"<ALERTMSG>"+
			  				"<BACKIMG>4</BACKIMG>"+
			  				"<MSGTYPE>104</MSGTYPE>"+
			  				"<SUB>"+sub+"</SUB>"+
			  				"<CONT>"+cont+"</CONT>"+
			  				"<URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
			
				
					//받는사람
				xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
				
			
				//보낸사람
				xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
				
				  			"   <MSGICON>10</MSGICON>"+
			  				"    <MSGSAVE>1</MSGSAVE>"+
			  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
			  				"    <FLDTYPE>1</FLDTYPE>"+
			  				"  </ALERTMSG>"+
			  				"</COOLMSG>";
			
			
				CdAlertBean msg = new CdAlertBean();
				msg.setFlddata(xml_data);
				msg.setFldtype("1");
				
				flag6 = cm_db.insertCoolMsg(msg);
							
			
			// 메신져 끝	
		}


//	int tot_dist = request.getParameter("tot_dist")==null?0:AddUtil.parseInt(request.getParameter("tot_dist")) ; //주행거리
   					
	int  ttot_dist 	= AddUtil.parseInt(tot_dist[0]);  //주행거리 
  
//	if(acct_code.equals("00004")  && !acct_code_g.equals("00027")  ) {//유류대 카드전표 등록시 Service 에도 입력.  --전기차 제외  
	if( acct_code.equals("00004")  ) {//유류대 카드전표 등록시 Service 에도 입력.  --전기차 포함(20180904)
		if(ttot_dist > 1000 ) {  //주행거리가 100보다 크면 Service에 등록.
			String serv_id2 = "";
			CusReg_Database cr_db = CusReg_Database.getInstance();
			CarServDatabase    	csD 	= CarServDatabase.getInstance();			
			
			CarInfoBean ci_bean = new CarInfoBean();
			
			ci_bean = cr_db.getCarInfo(item_code[0]);
			
			ServiceBean siBn = new ServiceBean();
			
			if ( !ci_bean.getRent_mng_id().equals("") ) {
				siBn.setCar_mng_id	(item_code[0]);
				siBn.setRent_mng_id	(ci_bean.getRent_mng_id());
				siBn.setRent_l_cd	(ci_bean.getRent_l_cd());
				siBn.setServ_st		("1");  //순회점검
				siBn.setServ_dt		(buy_dt);
				siBn.setChecker		(user_id);
				siBn.setSpdchk_dt	(buy_dt);
				siBn.setTot_dist	(Integer.toString(ttot_dist));
				siBn.setReg_id		(user_id);
				
				serv_id2 = csD.insertService(siBn);
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
		fm.action = 'sc_doc_mng_frame.jsp';
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
<%		if(flag > 0){//에러발생%>
		alert("에러가 발생하였습니다.");
<%		}else{//정상%>
		alert("처리되었습니다.");
		go_step();
<%		}%>
//-->
</script>
</body>
</html>
