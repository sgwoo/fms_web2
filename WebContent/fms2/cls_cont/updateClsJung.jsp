<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cls.*, acar.credit.*, acar.user_mng.*, acar.bill_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

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
	String cng_item  	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	String rent_st  	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String cmd	  		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String c_st = "";
	
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
		//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
		
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, rent_st);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//해지의뢰정보
	ClsEtcBean cls = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);
	String cls_st = cls.getCls_st_r();
	
			//해지기타 추가 정보
	ClsEtcMoreBean clsm = ac_db.getClsEtcMore(rent_mng_id, rent_l_cd);
		
		//차량회수정보
	CarRecoBean carReco = ac_db.getCarReco(rent_mng_id, rent_l_cd);
	
	//기본정보
	Hashtable base1 = as_db.getSettleBase(rent_mng_id, rent_l_cd, cls.getCls_dt(), "");
	
	
	//해지의뢰상계정보
	ClsEtcSubBean clss = ac_db.getClsEtcSubCase(rent_mng_id, rent_l_cd, 1);

	//채권관리정보
	CarCreditBean carCre = ac_db.getCarCredit(rent_mng_id, rent_l_cd);	
	
		// 선수금정산정보	
	ClsContEtcBean cct = ac_db.getClsContEtc(rent_mng_id, rent_l_cd);
				
		//연대보증인 
	Vector gurs = a_db.getContGurList(rent_mng_id,  rent_l_cd);
	int gur_size = gurs.size();
		
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	//디스플레이 타입 - 선수금정산
	function cls_display4(){
		var fm = document.form1;
	
		if(fm.jung_st[1].checked == true){  //구분정산 선택시
			fm.h1_amt.value='0';  //선납금액
			fm.h2_amt.value='0';  //미납금액
			fm.h3_amt.value='0';  //정산금액
			fm.h4_amt.value='0';  //환불
			fm.h5_amt.value='0';  //환불정산
			fm.h6_amt.value='0';  //미납
			fm.h7_amt.value='0';  //미납정산
			
			fm.h4_amt.value = fm.c_amt.value; 	
			fm.h5_amt.value = fm.c_amt.value; 	
			fm.h6_amt.value =fm.fdft_amt1_1.value; 
			fm.h7_amt.value =fm.fdft_amt1_1.value; 
		//	fm.h3_amt.value =parseDecimal( toInt(parseDigit(fm.h1_amt.value)) - toInt(parseDigit(fm.h2_amt.value)) );		
			
						
		}else{
			fm.h1_amt.value='0';  //선납금액
			fm.h2_amt.value='0';  //미납금액
			fm.h3_amt.value='0';  //정산금액
			fm.h4_amt.value='0';  //환불
			fm.h5_amt.value='0';  //환불정산
			fm.h6_amt.value='0';  //미납
			fm.h7_amt.value='0';  //미납정산			
			
			fm.h1_amt.value = fm.c_amt.value; 	
			fm.h2_amt.value =fm.fdft_amt1_1.value; 
			fm.h3_amt.value =parseDecimal( toInt(parseDigit(fm.h1_amt.value)) - toInt(parseDigit(fm.h2_amt.value)) );		
		}
	}	
	
	//선납금액 정산 : 자동계산
	function set_cls_amt1(obj){
		var fm = document.form1;
			
		obj.value=parseDecimal(obj.value);
		if(obj == fm.ifee_mon || obj == fm.ifee_day){ //개시대여료 경과기간
			if(fm.ifee_s_amt.value != '0'){		
				fm.ifee_ex_amt.value	= parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) );
				fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );		
		
				v_ifee_ex_amt =  toInt(parseDigit( parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) )   )); //경과금액
				v_rifee_s_amt =  toInt(parseDigit( parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) )   ));														  //잔액
							
			}
			
		}else if(obj == fm.ifee_ex_amt){ //개시대여료 경과금액
			if(fm.ifee_s_amt.value != '0'){		
				fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );				
			}
		}else if(obj == fm.pded_s_amt){ //선납금 월공제액
			if(fm.pp_s_amt.value != '0'){		
			//	fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.r_mon.value)+toInt(fm.r_day.value)/30) );
				fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.m_mon.value)+toInt(fm.m_day.value)/30) );
				fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );		
			}
		}else if(obj == fm.tpded_s_amt){ //선납금 월공제액
			if(fm.pp_s_amt.value != '0'){		
				fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );		
			}
		}
		
		if(fm.pp_s_amt.value != '0') {
	 	 
	    	if ( toInt(fm.rent_end_dt.value) ==  toInt(replaceString("-","",fm.cls_dt.value))) { //만기일
	    		
	    		fm.pded_s_amt.value 	= 0;
				fm.tpded_s_amt.value 	= 0;
				fm.rfee_s_amt.value 	= 0;
	    	}   
	    }	
				
		if (toInt(parseDigit(fm.rfee_s_amt.value))  <= 0 ) { // 선납금액이 경과한 경우 (계약기간이 경과한 경우 - 연장계약없이 )
			fm.pded_s_amt.value 	= 0;
			fm.tpded_s_amt.value 	= 0;
			fm.rfee_s_amt.value 	= 0;		
		} 
				
		fm.c_amt.value 					= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value))  + toInt(parseDigit(fm.rfee_s_amt.value)) );					
		
		 //개시대여료가 다 경과한 경우 잔여개시대여료는 미납대여료에서 처리
	    if(fm.ifee_s_amt.value != '0') {
	    	 
	    	if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //만기이후 
	    		
	    		fm.ifee_ex_amt.value = '0';
	    		fm.rifee_s_amt.value = '0'; 
	      		fm.c_amt.value 	= parseDecimal( toInt(parseDigit(fm.grt_amt.value))  + toInt(parseDigit(fm.rfee_s_amt.value)) );
	    	}   
	    }	
			
	
		set_cls_s_amt();
	}	



	//등록하기
	function save(){
		fm = document.form1;
		
		set_cls_s_amt();
		
		if(  fm.jung_st_chk.value != "" ) {  
			 if ( toInt(parseDigit(fm.c_amt.value))  > 0 ) {
				if ( fm.cls_st.value == '1' || fm.cls_st.value == '2'  ) {   //계약만료 또는 중도해지만 해당
					//선수금정산관련 금액 		
					if  (  fm.jung_st[1].checked == true)  {  //구분정산 선택시
						 if ( ( toInt(parseDigit(fm.h5_amt.value)) -  toInt(parseDigit(fm.h7_amt.value)) ) * (-1)  !=   toInt(parseDigit(fm.fdft_amt2.value))  ) {	
					 		alert("고객납입금액과 구분정산금액이 틀립니다. 금액확인하세요.!!");
							return; 	
					 	}			
					} else {
					 	if ( toInt(parseDigit(fm.h3_amt.value)) *(-1)  !=  toInt(parseDigit(fm.fdft_amt2.value))  ) {
					 		alert("고객납입금액과 합산정산금액이 틀립니다. 금액확인하세요.!!");
							return; 	
					 	}		 		
					}	
	 			}
	 		}
	 	}		 		
	 		//월렌트정산관련 
	 	if(  fm.cls_st.value ==  "14" ) {
	 			//돌려줄 금액이 있다면
				if ( toInt(parseDigit(fm.fdft_amt2.value)) < 0 ) {
				      if(  fm.jung_st_chk.value == "3" ) {  //카드인경우   
				// 	 fm.h5_amt.value 			= parseDecimal( toInt(parseDigit(fm.t_amount.value )) );  //카드 재결재금액  
						  	 fm.h7_amt.value 			= parseDecimal( toInt(parseDigit(fm.h5_amt.value)) + toInt(parseDigit(fm.fdft_amt2.value)) );  //카드 재결재금액 
					 		 fm.jung_st_chk.value = '3';
					  }	 
				} else {
				   	 fm.h5_amt.value =0;
				  	 fm.h7_amt.value =0;
				  	 fm.jung_st_chk.value = '1';				  
				}		 			 			 			
		}
							
		if(!confirm("변경하시겠습니까?"))	return;
		fm.target = "i_no";
		fm.submit();
	}
	
	
	//등록하기
	function save1(){
		fm = document.form1;
		
	   if(  fm.jung_st_chk != "" ) {  
			 if ( toInt(parseDigit(fm.c_amt.value))  > 0 ) {
				if ( fm.cls_st.value == '1' || fm.cls_st.value == '2'  ) {   //계약만료 또는 중도해지만 해당
					//선수금정산관련 금액 		
					if  (  fm.jung_st[1].checked == true)  {  //구분정산 선택시
						 if ( ( toInt(parseDigit(fm.h5_amt.value)) -  toInt(parseDigit(fm.h7_amt.value)) ) * (-1)  !=   toInt(parseDigit(fm.fdft_amt2.value))  ) {	
					 		alert("고객납입금액과 구분정산금액이 틀립니다. 금액확인하세요.!!");
							return; 	
					 	}			
					} else {
					 	if ( toInt(parseDigit(fm.h3_amt.value)) *(-1)  !=  toInt(parseDigit(fm.fdft_amt2.value))  ) {
					 		alert("고객납입금액과 합산정산금액이 틀립니다. 금액확인하세요.!!");
							return; 	
					 	}		 		
					}	
	 			}
	 		}	
		}
		
				//월렌트정산관련 
	 	if(  fm.cls_st.value ==  "14" ) {
	 			//돌려줄 금액이 있다면
				if ( toInt(parseDigit(fm.fdft_amt2.value)) < 0 ) {
				      if(  fm.jung_st_chk.value == "3" ) {  //카드인경우   
				// 	 fm.h5_amt.value 			= parseDecimal( toInt(parseDigit(fm.t_amount.value )) );  //카드 재결재금액  
						  	 fm.h7_amt.value 			= parseDecimal( toInt(parseDigit(fm.h5_amt.value)) + toInt(parseDigit(fm.fdft_amt2.value)) );  //카드 재결재금액 
					 		 fm.jung_st_chk.value = '3';
					  }	 
				} else {
				   	 fm.h5_amt.value =0;
				  	 fm.h7_amt.value =0;
				  	 fm.jung_st_chk.value = '1';				  
				}		 			 			 			
		}
					
		if(!confirm("변경하시겠습니까?"))	return;
		fm.target = "i_no";
		fm.action = 'updateClsJung_a1.jsp'
		fm.submit();
	}
	
	//등록하기
	function save2(){
		fm = document.form1;
		
		if(  fm.cms_chk.value == "Y" ) {  // cms인출의뢰 		
			if ( toInt(parseDigit(fm.cms_amt.value))  < 1 ) {				
				 	alert("CMS 부분인출금액을 확인하세요.!!");
					return; 					
		 	}				
		}
		
		if(!confirm("변경하시겠습니까?"))	return;
		fm.target = "i_no";
		fm.action = 'updateClsAsset_a.jsp'
		fm.submit();
	}
	
	
	
	//미납 대여료 정산 : 자동계산
	function set_cls_amt2(obj){
		var fm = document.form1;
				
		var ifee_tm = 0;
		var pay_tm = 0;
		var v_rifee_s_amt = 0;  // 개시대여료 잔액
		var v_ifee_ex_amt = 0;  //개시대여료 경과금액
								
		obj.value=parseDecimal(obj.value);
			
		if(obj == fm.nfee_mon || obj == fm.nfee_day){ //미납입대여료 기간 (당초금액도 변경되도록)
										
			//잔여개시대여료 
			if(fm.ifee_s_amt.value != '0'){
				ifee_tm = parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) / toInt(parseDigit(fm.nfee_s_amt.value))) ;
			//	ifee_tm = toInt(parseDigit(fm.ifee_s_amt.value)) / toInt(parseDigit(fm.nfee_s_amt.value)) ;
				
				pay_tm = toInt(fm.con_mon.value)-ifee_tm;
				if(toInt(fm.r_mon.value) > pay_tm || (toInt(fm.r_mon.value) == pay_tm && toInt(fm.r_day.value) > 0)){
					fm.ifee_mon.value 	= Math.round(toInt(fm.r_mon.value)-pay_tm);
					fm.ifee_day.value 	= fm.r_day.value;
				}
			
				fm.ifee_ex_amt.value	= parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) );
				fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );
						
				v_ifee_ex_amt =  toInt(parseDigit( parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) )   )); //경과금액
				v_rifee_s_amt =  toInt(parseDigit( parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) )   ));														  //잔액
												    	 
		    	if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //만기이후 
		    		
		    		fm.ifee_ex_amt.value = '0';
		    		fm.rifee_s_amt.value = '0'; 
		    		v_rifee_s_amt = 0;
		      		
		    	}  
		    	 			
			}
			
			   //잔여선납금?
			if(fm.pp_s_amt.value != '0'){
				fm.pded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) / toInt(fm.con_mon.value) );
				fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.r_mon.value)+toInt(fm.r_day.value)/30) );
				fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );   //+ toInt(parseDigit(fm.ifee_s_amt.value)) 
			}else{
				fm.pded_s_amt.value 	= 0;
				fm.tpded_s_amt.value 	= 0;
				fm.rfee_s_amt.value 	= 0;
			}
			
			if(fm.pp_s_amt.value != '0') {
		 	 
		    	if ( toInt(fm.rent_end_dt.value) ==  toInt(replaceString("-","",fm.cls_dt.value))) { //만기일
		    		
		    		fm.pded_s_amt.value 	= 0;
					fm.tpded_s_amt.value 	= 0;
					fm.rfee_s_amt.value 	= 0;
		    	}   
		    }	
			if (toInt(parseDigit(fm.rfee_s_amt.value))  <= 0 ) { // 선납금액이 경과한 경우
				fm.pded_s_amt.value 	= 0;
				fm.tpded_s_amt.value 	= 0;
				fm.rfee_s_amt.value 	= 0;		
			} 
		    
			//선납금액	
			fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value)) + toInt(parseDigit(fm.rfee_s_amt.value))  );
		    	
			if(fm.ifee_s_amt.value == '0' ) {
	   	 			
				//대여 스케쥴이 생성안되고, 미납이 없는 경우 scd_fee가 없어서 nfee_mon, nfee_day 구할수 없음.
			   if ( toInt(fm.rent_end_dt.value) >= toInt(fm.use_s_dt.value)) { //만기이후 대여료 스케쥴이 생성이 안된 경우 
				 if ( toInt(fm.rent_end_dt.value) <= toInt(fm.dly_s_dt.value) ) { //만기일 이전에 미납분이 있는 경우
				   	     //    alert(" 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이 없는 경우");
				   		   	  	   
			   	  	   if (toInt(fm.r_con_mon.value) > 0) {  
				   	  	  	 fm.nfee_mon.value 	= 	toInt(fm.r_con_mon.value);  //해지일 - 만기일의 개월 수
				   	   } else {  //만기전해지인 경우  (개시대여료가 있는 경우)
				   	  	  	 fm.nfee_mon.value = '0';
				   	   } 
		   	  	  
			  	   	 //  if ( toInt(fm.rent_end_dt.value) >= toInt(fm.use_e_dt.value) ) { // 만기일과 스케쥴 만기일 비교	   	  	  	    	  	   
		  	   	    // 	fm.nfee_day.value 	= 	fm.r_day.value;
		  	   	    //   } 
		  	   	       
		  	   	       if ( toInt(replaceString("-","",fm.cls_dt.value)) >= toInt(fm.rent_end_dt.value) ) { // 만기일과 정산일 비교	   	  	  	    	  	   
		  	   	     	  fm.nfee_day.value 	= 	fm.r_day.value;
		  	   	   	   }
				 }
			  } else { //만기이후 스테쥴 생성이 된 경우
		   
			      if ( toInt(fm.rent_end_dt.value) <= toInt(fm.dly_s_dt.value) ) { //만기일 이전에 미납분이 없는 경우
				   	     //    alert(" 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이 없는 경우");
				   	 
			   	 // 	   if (toInt(fm.r_con_mon.value) > 0) {  
				//   	  	  	 fm.nfee_mon.value 	= 	toInt(fm.r_con_mon.value);  //해지일 - 만기일의 개월 수
				//   	   } else {  //만기전해지인 경우  (개시대여료가 있는 경우)
				 //  	  	  	 fm.nfee_mon.value = '0';
				//   	   } 
		   	  	  
		   	  	  	   if ( toInt(fm.rent_end_dt.value) < toInt(fm.use_e_dt.value) ) { // 만기일과 스케쥴 만기일 비교	   	
		   	  	  	    	if  ( fm.nnfee_s_amt.value  == '0' ) {  	  	    	  	   
			  	   	       		fm.nfee_day.value 	= 	fm.r_day.value;
			  	   	    	}   
			  	   	   }  
			   
			      }
		 	  }		   
			   	
		   }				
							
			//미납금액  - 개시대여료가 있는 경우 개시대여료만큼 스케쥴이 미생성, 만기일 이후 스케쥴이 생성된 건이라면 생성된 스케쥴로 미납금액 계산하고,
			//            스케쥴 생성하지 않은 경우는 경과개시대료를 계산하여 미납금액을 계산함
			 
			
		    fm.nfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );		
			fm.nfee_amt.value 			=  fm.nfee_amt_1.value;
		
			// 개시대여료 있는 경우에 한함. (해지일이 대여기간을 경과한 경우에 한함 )
		   	if(fm.ifee_s_amt.value != '0' ) {
								
		   		if (v_rifee_s_amt <= 0) {  //개시대여료를 다 소진한 경우
		   	    	fm.ifee_mon.value 	= '0';
			  		fm.ifee_day.value 	= '0';
						
			   	    if ( toInt(fm.rent_end_dt.value) <  toInt(fm.use_s_dt.value)) { //만기이후 대여료 스케쥴이 생성된 경우 
			   	       if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //만기일 이전에 미납분이 있는 경우  
			   	    //       alert(" 개시대여료 소진, 만기후 대여료스케쥴이 생성, 만기일 이전 미납분이 있는 경우");
			   	       	   fm.nfee_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - toInt(fm.ifee_s_amt.value));	// 총미납료에서 - 개시대여료 공제
			   	       }else {
			   	      //     alert(" 만기후 대여료스케쥴이 생성, 만기일 이전 미납분이 없는 경우");			   	      
					   	      
					   	           	//미납잔액이 있는 경우      	
					   	    	if  ( toInt(parseDigit(fm.di_amt.value)) > 0  ) {		   	    		
					   	   // 	     fm.nfee_mon.value 	= 	toInt(fm.s_mon.value) - 1;  // 잔액이 발생되었기에 1달 빼줌 
					   	    	  
					   	    	      //선납이 있다면 
					   	    	     if (  toInt(parseDigit(fm.ex_s_amt.value)) > 0 ){
					   	    	     	fm.nfee_day.value = 0;
					   	    	     } else {
					   	    	      
						   	    	  	 if ( toInt(fm.rent_end_dt.value) < toInt(replaceString("-","",fm.cls_dt.value)) ) {
						   	    	  		 if  ( fm.nnfee_s_amt.value  == '0' ) {
						   	    	  	 		fm.nfee_day.value 	= 	fm.r_day.value;
						   	    	  	 	 }	
						   	    	  	 }  	
						   	    	 } 	     	
					   	    	   	    	 	
					   	    	} else {
					   	    	      //선납이 있다면 
					   	    	   if (  toInt(parseDigit(fm.ex_s_amt.value)) > 0 ){
					   	    	     	fm.nfee_day.value = 0;		   	   
					   	    	   } else {  		
						   	    	   if  ( fm.nnfee_s_amt.value  == '0' && fm.r_con_mon.value == '0') {
							   	              fm.nfee_mon.value 	= 	toInt(fm.r_mon.value) - toInt(fm.con_mon.value);  //경과일수 표시
							   	       		  fm.nfee_day.value 	= 	fm.r_day.value;
							   	       		  
							   	       		  
							   	       		  	  // 대여료만기일과 정산일 비교 (실제연체일수 계산)	
								  	          var s1_str = fm.use_e_dt.value;
									   		  var e1_str = fm.cls_dt.value;
											  var  count1 = 0;
												
											  var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1 , s1_str.substring(6,8) );
											  var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1, e1_str.substring(8,10) );				
									
											  var diff1_date = e1_date.getTime() - s1_date.getTime();
									
											  count1 = Math.floor(diff1_date/(24*60*60*1000));
										    						 
									  	   	  if ( count1 >= 0 ) {							  	   	      	  	  	    	  	   
									  	   	     fm.nfee_day.value 	= 	count1;
									  	   	  }		
							   	       		  
						   	    	   }
						   	       }	   	
					   	    	
					   	    	} 		   	      	 
			   	    	/*
			   	     		 if (toInt(fm.r_con_mon.value) > 0) {  
							   	  	  	 fm.nfee_mon.value 	= 	toInt(fm.r_con_mon.value);  //해지일 - 만기일의 개월 수 (실사용월수)
							 } else {  
								   	  	 fm.nfee_mon.value = '0';			   	  	  	 
							 } 			   	   
							   	  	  	   //선납이 있으면	   	  	  	 	  	
							 if (  toInt(parseDigit(fm.ex_s_amt.value)) > 0 ){
							   	       	fm.nfee_day.value = 0;
							 } else {
							   	       if ( toInt(fm.rent_end_dt.value) < toInt(fm.use_e_dt.value) ) { // 만기일과 스케쥴 만기일 비교	
								   	  	   if  ( fm.nnfee_s_amt.value  == '0' ) {   	  	  	    	  	   
									  	   	     fm.nfee_day.value 	= 	fm.r_day.value;
									  	   }
									  	   
									  	   // 대여료만기일과 정산일 비교 (실제연체일수 계산)	   
									  	   var s1_str = fm.use_e_dt.value;
										   var e1_str = fm.cls_dt.value;
										   var  count1 = 0;
											
										   var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1, s1_str.substring(6,8) );
										   var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1, e1_str.substring(8,10) );
								
										   var diff1_date = e1_date.getTime() - s1_date.getTime();
								
										   count1 = Math.floor(diff1_date/(24*60*60*1000));
											
								  	   	   if ( count1 >= 0 ) { 	  	  	    	  	   
								  	   	     fm.nfee_day.value 	= 	count1;
							  	   	  	   } 						  	   
									  	   
									   }	   
							 } */
				   	       	   	  
			   	       	     fm.nfee_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ); 
			   	       }
			   	    } else { //만기이후 대여료 스케쥴이 생성이 안된 경우 - 경과 개시대여료 계산하여 미납분 표시 
			   	      if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //만기일 이전에 미납분이 있는 경우
			   	       //	   alert(" 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이 있는 경우");
			   	        //   fm.nfee_amt_1.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - toInt(fm.ifee_s_amt.value));	// 총미납료에서 - 개시대여료 공제   	   
			   	     	
			   	     	 var r_tm = 0;       
					   	 r_tm 			    = 	toInt(fm.s_mon.value) - ifee_tm ;	// 총미납료에서 - 개시대여료 공제   
					   	 fm.nfee_mon.value 	= r_tm;
					   	 fm.nfee_amt_1.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ) ;	// 총미납료에서 - 개시대여료 공제   
					  	
			   	     
			   	      }else {
			   	       //    alert(" 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이 없는 경우");
			   	       	   fm.nfee_amt_1.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - v_rifee_s_amt ) ; 
			   	      	   fm.nfee_mon.value 	= 	toInt(fm.r_mon.value) - toInt(fm.con_mon.value);  //경과일수 표시
			   	      	   fm.nfee_day.value 	= 	fm.r_day.value;
			   	       }
			   	   }
			    } else {  //개시대여료가 남아있는 경우
			        if ( toInt(fm.rent_end_dt.value) <  toInt(fm.use_s_dt.value)) { //만기이후 대여료 스케쥴이 생성된 경우 
			   	       if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //만기일 이전에 미납분이 있는 경우  
			   	    //   	   alert(" 개시대여료 잔액있음, 만기후 대여료스케쥴이 생성, 만기일 이전 미납분이 있는 경우");
			   	       	   fm.nfee_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - v_ifee_ex_amt);	// 총미납료에서 - 개시대여료 공제
			   	       }else {
			   	    //       alert(" 개시대여료 잔액있음, 만기후 대여료스케쥴이 생성, 만기일 이전 미납분이 없는 경우");
			   	       	   fm.nfee_amt_1.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ); 
			   	       }
			   	    } else { //만기이후 대여료 스케쥴이 생성이 안된 경우 - 경과 개시대여료 계산하여 미납분 표시 
			   	      if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //만기일 이전에 미납분이 있는 경우
			   	     //      alert(" 개시대여료 잔액있음, 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이 있는 경우");
			   	           fm.nfee_amt_1.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - v_ifee_ex_amt);	// 총미납료에서 - 개시대여료 공제   	   
			   	      }else {
			   	     //      alert(" 개시대여료 잔액있음, 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이없는 경우");
			   	       	   fm.nfee_amt_1.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ) ; 
			   	
			   	       }
			   	   }
			    }   
		   	}
		   	
			fm.nfee_amt.value 			=  fm.nfee_amt_1.value;			
		}
				
	//	if ( fm.cls_st.value == '8' ) {
	//		//매입옵션만???
	//		if(obj == fm.nfee_amt_1){ //미납입대여료 기간 (당초금액도 변경되도록)
	//			fm.nfee_amt.value 			=  fm.nfee_amt_1.value;	
	//		}
	//	}
		
						//과부족 및 과입금관련 vat 	
		if ( fm.ex_di_amt_1.value != fm.ex_di_amt.value ) {
		//	fm.ex_di_amt.value = fm.ex_di_amt_1.value
		//	fm.ex_di_v_amt.value = parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) * 0.1 );
			fm.ex_di_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) * 0.1 );
		} 
		
		if ( fm.ex_di_amt_1.value == 0 ) {
		//	fm.ex_di_amt.value = 0;
		//	fm.ex_di_v_amt.value = 0;
			fm.ex_di_v_amt_1.value = 0;
		}
					   			
			//과부족 및 과입금관련 vat 	
		if ( fm.ex_di_amt_1.value != fm.ex_di_amt.value ) {
			fm.ex_di_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) * 0.1 );
		} else { 					
		   fm.ex_di_v_amt_1.value		=  ( ( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) ) * 0.1 ) -  ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1) ;
		} 
	
		//vat계산 (대여료)
		var no_v_amt = 0;
		var no_v_amt1 = 0;
			
		//각각 부가세 계산하여 더한다.	
	//	no_v_amt = toInt(parseDigit(fm.ex_di_v_amt.value)) + ( toInt(parseDigit(fm.nfee_amt.value)) * 0.1) + ( toInt(parseDigit(fm.over_amt.value)) *0.1 ) -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ; 	
		no_v_amt1 = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1) + (toInt(parseDigit(fm.over_amt_1.value)) *0.1 )   -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
			
		
		fm.rifee_v_amt.value = parseDecimal(  toInt(parseDigit(fm.rifee_s_amt.value)) *0.1 );  //개시대여료 
	    fm.rfee_v_amt.value = parseDecimal(  toInt(parseDigit(fm.rfee_s_amt.value)) *0.1) ;     //선납금 
	    	    
	//	fm.dfee_v_amt.value =  toInt(parseDigit(fm.ex_di_v_amt.value)) + ( toInt(parseDigit(fm.nfee_amt.value)) *0.1 );  //당초 대여료 부가세 
		fm.dfee_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) *0.1 ) );  //확정 대여료 부가세 
					    
	//	fm.over_v_amt.value =  toInt(parseDigit(fm.over_amt.value)) *0.1;  //당초 초과운행 부가세 
		fm.over_v_amt_1.value = parseDecimal(  toInt(parseDigit(fm.over_amt_1.value)) *0.1 );  //확정 초과운행 부가세 
						        
	//	fm.no_v_amt.value 		= parseDecimal( toInt(no_v_amt) );		
		fm.no_v_amt_1.value 	= parseDecimal( toInt(no_v_amt1) );		
		
		/*
		if ( fm.tax_chk0.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[0].value)));	
		}		
						
		if ( fm.tax_chk1.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[1].value)));	
		}		 	
		
				
		if ( fm.tax_chk2.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[2].value)));	
		}						
									
		if ( fm.tax_chk3.checked == true) {				    
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[3].value)));					    				
		}		
		*/
		
	//	if ( fm.tax_chk4.checked == true) {				    
	//			    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));					    				
	//	}		
						
		set_cls_s_amt();
	}	
	
		//확정금액 셋팅
	function set_cls_amt(obj){
		var fm = document.form1;	
		obj.value=parseDecimal(obj.value);
	
		/*
		if(obj == fm.dft_amt_1){ //중도해지
			fm.tax_supply[0].value 	= obj.value;
			fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );	
		
						
		}else if(obj == fm.etc_amt_1){ //회수외주비용
			fm.tax_supply[1].value 	= obj.value;			
			fm.tax_value[1].value 	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );
		
					
		}else if(obj == fm.etc2_amt_1){ //회수부대비용
			fm.tax_supply[2].value 	= obj.value;
			fm.tax_value[2].value 	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );		
			
			
		}else if(obj == fm.etc4_amt_1){ //기타손해배상금
			fm.tax_supply[3].value 	= obj.value;
			fm.tax_value[3].value 	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );
			
		}else */
		
		if(obj == fm.over_amt_1){ //초과운행부담금
		
			fm.tax_supply[4].value 	= obj.value;
			fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(obj.value)) * 0.1 );			
	
		}
								
			//과부족 및 과입금관련 vat 	
		if ( fm.ex_di_amt_1.value != fm.ex_di_amt.value ) {
			fm.ex_di_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) * 0.1 );
		} else { 					
		   fm.ex_di_v_amt_1.value		=  ( ( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) ) * 0.1 ) -  ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1) ;
		} 
		
		//vat계산 (대여료)
	//	var no_v_amt = 0;
		var no_v_amt1 = 0;
			
		//각각 부가세 계산하여 더한다.	
//		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt.value)) + ( toInt(parseDigit(fm.nfee_amt.value)) * 0.1)  +  ( toInt(parseDigit(fm.over_amt.value)) * 0.1)  -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ; 	
		no_v_amt1 = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)  +  ( toInt(parseDigit(fm.over_amt_1.value)) * 0.1)  -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
			
		fm.rifee_v_amt.value = parseDecimal(  toInt(parseDigit(fm.rifee_s_amt.value)) *0.1 );  //개시대여료 
	    fm.rfee_v_amt.value = parseDecimal(  toInt(parseDigit(fm.rfee_s_amt.value)) *0.1 );    //선납금 
	    
	//    fm.dfee_v_amt.value =  toInt(parseDigit(fm.ex_di_v_amt.value)) + ( toInt(parseDigit(fm.nfee_amt.value)) *0.1 );  //당초 대여료 부가세 
		fm.dfee_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) *0.1 ) );  //확정 대여료 부가세 
					    
//		fm.over_v_amt.value =  toInt(parseDigit(fm.over_amt.value)) *0.1;  //당초 초과운행 부가세 
		fm.over_v_amt_1.value = parseDecimal(  toInt(parseDigit(fm.over_amt_1.value)) *0.1 );  //확정 초과운행 부가세 
						        
//		fm.no_v_amt.value 		= parseDecimal( toInt(no_v_amt) );		
		fm.no_v_amt_1.value 	= parseDecimal( toInt(no_v_amt1) );		
						
		/*			
		if ( fm.tax_chk0.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[0].value)));	
		}							
					
		if ( fm.tax_chk1.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[1].value)));	
		}		 	
							
		if ( fm.tax_chk2.checked == true) {
				    fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[2].value)));				   
		}		
							
		if ( fm.tax_chk3.checked == true) {				    
			   fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[3].value)));					    				
		}	
				
		if ( fm.tax_chk4.checked == true) {				    
			   fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));					    				
		}	
		*/
		
		set_cls_s_amt();
				
	}	
	
		//은행선택시 계좌번호 가져오기
	function change_bank(){
		var fm = document.form1;
		//은행
		var bank_code = fm.bank_code.options[fm.bank_code.selectedIndex].value;
		fm.bank_code2.value = bank_code.substring(0,3);
		fm.bank_name.value = bank_code.substring(3);
				
		drop_deposit();		

		if(bank_code == ''){
			fm.bank_code.options[0] = new Option('선택', '');
			return;
		}else{
			fm.target='i_no';
			fm.action='/fms2/con_fee/get_deposit_nodisplay.jsp?bank_code='+bank_code.substring(0,3);
			fm.submit();
		}
	}	
	
	function drop_deposit(){
		var fm = document.form1;
		var deposit_len = fm.deposit_no.length;
		for(var i = 0 ; i < deposit_len ; i++){
			fm.deposit_no.options[deposit_len-(i+1)] = null;
		}
	}	
		
	function add_deposit(idx, val, str){
		document.form1.deposit_no[idx] = new Option(str, val);		
	}		
	//조회하기
	function ven_search(idx){
		var fm = document.form1;
		window.open("/acar/con_debt/vendor_list.jsp?idx="+idx, "VENDOR_LIST", "left=50, top=50, width=500, height=400, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	
		//확정금액 셋팅
	function set_cls_s_amt(){
		var fm = document.form1;	
	
		fm.dfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) );
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );
						
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)) +  toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.etc2_amt.value)) + toInt(parseDigit(fm.etc3_amt.value)) + toInt(parseDigit(fm.etc4_amt.value))  + toInt(parseDigit(fm.over_amt.value))    + toInt(parseDigit(fm.no_v_amt.value)));		
		fm.fdft_amt1_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) + toInt(parseDigit(fm.dly_amt_1.value))  +  toInt(parseDigit(fm.dft_amt_1.value)) + toInt(parseDigit(fm.car_ja_amt_1.value)) + toInt(parseDigit(fm.fine_amt_1.value)) + toInt(parseDigit(fm.etc_amt_1.value)) + toInt(parseDigit(fm.etc2_amt_1.value)) + toInt(parseDigit(fm.etc3_amt_1.value)) + toInt(parseDigit(fm.etc4_amt_1.value))   + toInt(parseDigit(fm.over_amt_1.value))   + toInt(parseDigit(fm.no_v_amt_1.value)));	 //확정금액	
			
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		 		 	
		if (fm.cls_st.value  == '8' ) {	//매입옵션
			fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));					
			fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));						
		}  			
						
		if (fm.cls_st.value  == '8' ) {	//매입옵션
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt3.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		} else {
			fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		}
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );	
				
	}	
		
		//미납 중도해지위약금 정산 : 자동계산
	function set_cls_amt3(obj){
		var fm = document.form1;
	//	obj.value=parseDecimal(obj.value);
		if(obj == fm.rcon_mon || obj == fm.rcon_day){ //잔여대여계약기간
			if(fm.mfee_amt.value != '0'){		
				fm.trfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );
				fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toFloat(fm.dft_int.value)/100) );
				fm.dft_amt_1.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toFloat(fm.dft_int_1.value)/100) );
			}
		}else if(obj == fm.dft_int_1){ //위약금 적용요율
			if(fm.trfee_amt.value != '0'){		
				fm.dft_amt_1.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toFloat(fm.dft_int_1.value)/100) );
			
			}			
		}
		
	//	fm.dfee_amt.value					= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) );
		
		set_cls_s_amt();
	}	
	
		
	//차량회수비용
	function set_etc_amt(){
		var fm = document.form1;
		
		fm.etc_out_amt.value 		= parseDecimal( toInt(parseDigit(fm.etc_d1_amt.value)) + toInt(parseDigit(fm.etc2_d1_amt.value)));
		
		fm.etc_amt.value 		    = parseDecimal( toInt(parseDigit(fm.etc_d1_amt.value)));
		fm.etc2_amt.value 		    = parseDecimal( toInt(parseDigit(fm.etc2_d1_amt.value)));
	
		fm.etc_amt_1.value 		    = parseDecimal( toInt(parseDigit(fm.etc_d1_amt.value)));
		fm.etc2_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.etc2_d1_amt.value)));
		
		set_cls_s_amt();
						
	}
	
	
	//세금계산서 check 관련 부가세 - 고객납입액에 부가세 만큼 더한다(대여료, 면책금은 예외 (이미 더해졌음)) - 세금계산서 발행되면 외상매출금계정 
	function set_vat_amt(obj){
		var fm = document.form1;
		
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );
		
		/*
		if(obj == fm.tax_chk0){ // 위약금
		 	if (obj.checked == true) {
		 			fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(fm.dft_amt_1.value)) * 0.1 );	
		 			fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[0].value)));	
		 			fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[0].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[0].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[0].value)));		
			} else {
					fm.tax_value[0].value 	= parseDecimal( toInt(parseDigit(fm.dft_amt_1.value)) * 0.1 );	
					fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[0].value)));	
					fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[0].value)));	
					fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[0].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[0].value)));		
			}	
	
		} else if(obj == fm.tax_chk1){ // 외주비용
			 if (obj.checked == true) {
			 		fm.tax_value[1].value 	= parseDecimal( toInt(parseDigit(fm.etc_amt_1.value)) * 0.1 );
				 	fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[1].value)));	
				 	fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[1].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[1].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[1].value)));
			 } else {
			 		fm.tax_value[1].value 	= parseDecimal( toInt(parseDigit(fm.etc_amt_1.value)) * 0.1 );
			 		fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[1].value)));	
			 		fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[1].value)));	
			 		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[1].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[1].value)));
			 }	
			 
		} else if(obj == fm.tax_chk2){ // 부대비용
			 if (obj.checked == true) {
			 		fm.tax_value[2].value 	= parseDecimal( toInt(parseDigit(fm.etc2_amt_1.value)) * 0.1 );
				 	fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[2].value)));	
				 	fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[2].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[2].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[2].value)));
			 } else {
			 		fm.tax_value[2].value 	= parseDecimal( toInt(parseDigit(fm.etc2_amt_1.value)) * 0.1 );
			 		fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[2].value)));	
			 		fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[2].value)));	
			 		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[2].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[2].value)));
			 }	
			 
		} else if(obj == fm.tax_chk3){ // 기타손해배상금
			 if (obj.checked == true) {
			 		fm.tax_value[3].value 	= parseDecimal( toInt(parseDigit(fm.etc4_amt_1.value)) * 0.1 );			 	
				 	fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[3].value)));	
				 	fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[3].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[3].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[3].value)));
			 } else {
			 		fm.tax_value[3].value 	= parseDecimal( toInt(parseDigit(fm.etc4_amt_1.value)) * 0.1 );		
			 		fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[3].value)));	
			 		fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[3].value)));	
			 		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[3].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[3].value)));
			 }	
		
		} else if(obj == fm.tax_chk4){ // 초과운행부담금  
			 if (obj.checked == true) {
			 		fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.over_amt_1.value)) * 0.1 );			 	
				 	fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));	
				 	fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))+ toInt(parseDigit(fm.tax_value[4].value)));	
				 	fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.tax_value[4].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))+ toInt(parseDigit(fm.tax_value[4].value)));
			 } else {
			 		fm.tax_value[4].value 	= parseDecimal( toInt(parseDigit(fm.over_amt_1.value)) * 0.1 );		
			 		fm.no_v_amt_1.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt_1.value))- toInt(parseDigit(fm.tax_value[4].value)));	
			 		fm.fdft_amt1_1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value))- toInt(parseDigit(fm.tax_value[4].value)));	
			 		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.tax_value[4].value)));			
					fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.est_amt.value))- toInt(parseDigit(fm.tax_value[4].value)));
			 }		 
			 
		}
		*/
				
		fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt_1.value)) );
		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt_1.value)) );	
	
		
		//vat계산 (대여료)
	//	var no_v_amt = 0;
		var no_v_amt1 = 0;
			
		//각각 부가세 계산하여 더한다.	
	//	no_v_amt = toInt(parseDigit(fm.ex_di_v_amt.value)) + ( toInt(parseDigit(fm.nfee_amt.value)) * 0.1) + ( toInt(parseDigit(fm.over_amt.value)) *0.1 ) -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ; 	
		no_v_amt1 = toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) * 0.1)  + (toInt(parseDigit(fm.over_amt_1.value)) *0.1 )  -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
		
		fm.rifee_v_amt.value = parseDecimal(  toInt(parseDigit(fm.rifee_s_amt.value)) *0.1 );  //개시대여료 
	    fm.rfee_v_amt.value = parseDecimal( toInt(parseDigit(fm.rfee_s_amt.value)) *0.1 );    //선납금 
	    
	//    fm.dfee_v_amt.value =  toInt(parseDigit(fm.ex_di_v_amt.value)) + ( toInt(parseDigit(fm.nfee_amt.value)) *0.1 );  //당초 대여료 부가세 
		fm.dfee_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.ex_di_v_amt_1.value)) + ( toInt(parseDigit(fm.nfee_amt_1.value)) *0.1 ) );  //확정 대여료 부가세 
					    
//		fm.over_v_amt.value =  toInt(parseDigit(fm.over_amt.value)) *0.1;  //당초 초과운행 부가세 
		fm.over_v_amt_1.value = parseDecimal( toInt(parseDigit(fm.over_amt_1.value)) *0.1 );  //확정 초과운행 부가세 
		
	//	fm.no_v_amt.value 		= parseDecimal( toInt(no_v_amt) );		
		fm.no_v_amt_1.value 	= parseDecimal( toInt(no_v_amt1) );		
						
		set_cls_s_amt();
		
				
	}
		
   		//구분정산 금액 수정시 - 잔여개시대여료 또는 선납금이 있는경우 조정시 
	function set_h_amt(){
		var fm = document.form1;	
							
		fm.h5_amt.value 			= parseDecimal( toInt(parseDigit(fm.h4_amt.value)) );
	  	fm.h7_amt.value 			= parseDecimal( toInt(parseDigit(fm.h6_amt.value)) );
		
		/*
		fm.dfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) );
		fm.dfee_amt_1.value 		= parseDecimal( toInt(parseDigit(fm.ex_di_amt_1.value)) + toInt(parseDigit(fm.nfee_amt_1.value)) );
						
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value)) +  toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.etc2_amt.value)) + toInt(parseDigit(fm.etc3_amt.value)) + toInt(parseDigit(fm.etc4_amt.value))  + toInt(parseDigit(fm.over_amt.value))    + toInt(parseDigit(fm.no_v_amt.value)));		
		fm.fdft_amt1_1.value 		= parseDecimal( toInt(parseDigit(fm.d_amt_1.value)) + toInt(parseDigit(fm.dft_amt_1.value)) + toInt(parseDigit(fm.car_ja_amt_1.value)) + toInt(parseDigit(fm.fine_amt_1.value)) + toInt(parseDigit(fm.etc_amt_1.value)) + toInt(parseDigit(fm.etc2_amt_1.value)) + toInt(parseDigit(fm.etc3_amt_1.value)) + toInt(parseDigit(fm.etc4_amt_1.value))   + toInt(parseDigit(fm.over_amt_1.value))   + toInt(parseDigit(fm.no_v_amt_1.value)));	 //확정금액	
			
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		fm.est_amt.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1_1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
		*/ 		 	
						
	}	
	
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='updateClsJung_a.jsp' method='post'>
<input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
<input type='hidden' name='user_id' 		value='<%=user_id%>'>
<input type='hidden' name='br_id' 		value='<%=br_id%>'>
<input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
<input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
<input type='hidden' name='andor'	 		value='<%=andor%>'>
<input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
<input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
<input type='hidden' name="from_page" 	value="<%=from_page%>">
<input type='hidden' name="cancel_yn" 	value="<%=cls.getCancel_yn()%>"> 
<input type='hidden' name="cls_st" 	value="<%=cls.getCls_st_r()%>"> 

<input type='hidden' name='cls_s_amt' value='<%=AddUtil.parseDecimal(cls.getCls_s_amt())%>' >
<input type='hidden' name='cls_v_amt' value='<%=AddUtil.parseDecimal(cls.getCls_v_amt())%>' >

<input type='hidden' name='nfee_s_amt' value='<%=AddUtil.parseDecimal(cls.getNfee_s_amt())%>'>
<input type='hidden' name='pp_s_amt' value='<%=AddUtil.parseDecimal(cls.getPp_s_amt())%>'>
<input type='hidden' name='ifee_s_amt' value='<%=AddUtil.parseDecimal(cls.getIfee_s_amt())%>'>
<input type='hidden' name='cls_dt' value='<%=cls.getCls_dt()%>' 
<input type='hidden' name='rent_start_dt' value='<%=base1.get("RENT_START_DT")%>'>
<input type='hidden' name='rent_end_dt' value='<%=base1.get("RENT_END_DT")%>'>  
<input type='hidden' name='use_s_dt' value='<%=base1.get("USE_S_DT")%>'> 
<input type='hidden' name='use_e_dt' value='<%=base1.get("USE_E_DT")%>'> 
<input type='hidden' name='dly_s_dt' value='<%=base1.get("DLY_S_DT")%>'> 
<input type='hidden' name='r_con_mon' value='<%=base1.get("R_CON_MON")%>'> <!--만기일기준 경과계약기간 -->
<input type='hidden' name='r_mon'  value='<%=cls.getR_mon()%>'>
<input type='hidden' name='r_day' value='<%=cls.getR_day()%>' >
<input type='hidden' name='con_mon' value='<%=base1.get("CON_MON")%>'>
<input type='hidden' name='ex_di_v_amt'  value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_V_AMT"))+AddUtil.parseInt((String)base1.get("DI_V_AMT")))%>'  >
<input type='hidden' name='ex_di_v_amt_1' value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base1.get("EX_V_AMT"))+AddUtil.parseInt((String)base1.get("DI_V_AMT")))%>' >
<input type='hidden' name='nnfee_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("NFEE_S_AMT")))%>'>       

<input type='hidden' name='ex_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("EX_S_AMT")))%>'> <!--스케쥴의 선납대여료 -->
<input type='hidden' name='ex_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("EX_V_AMT")))%>'>  

<input type='hidden' name='di_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base1.get("DI_AMT")))%>'> <!--스케쥴의 연체월대여료 -잔액 -->
<input type='hidden' name='s_mon' value='<%=base1.get("S_MON")%>'>

<input type='hidden' name='m_mon' value='<%=base1.get("M_MON")%>'>
<input type='hidden' name='m_day' value='<%=base1.get("M_DAY")%>'>
  
<input type='hidden' name='jung_st_chk' value='<%=cct.getJung_st()%>' >

<input type='hidden' name='rifee_v_amt' value='<%=cls.getRifee_v_amt()%>'> <!-- 부가세 관련  -->
<input type='hidden' name='rfee_v_amt' value='<%=cls.getRfee_v_amt()%>'>
<input type='hidden' name='dfee_v_amt' value='<%=cls.getDfee_v_amt()%>'>
<input type='hidden' name='dfee_v_amt_1' value='<%=cls.getDfee_v_amt_1()%>'>
<input type='hidden' name='over_v_amt' value='<%=cls.getOver_v_amt()%>'>
<input type='hidden' name='over_v_amt_1' value='<%=cls.getOver_v_amt_1()%>'>
  
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='20%'>계약번호</td>
                    <td width='20%' align="center"><%=rent_l_cd%></td>
    			    <td class='title' width='15%'>상호</td>
                    <td width='45%'>&nbsp;<%=client.getFirm_nm()%></td>
                </tr>
                <tr> 
                    <td class='title' width='20%'>차량번호</td>
                    <td width='20%' align="center"><%=cr_bean.getCar_no()%></td>
    			    <td class='title' width='15%'>차명</td>
                    <td width='45%'>&nbsp;<%=cm_bean.getCar_name()%>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>  
    <tr> 
        <td align="right"></td>
    </tr>

   <tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>외주비용</span></td>
	</tr>
		<tr>
        <td class=line2></td>
    </tr> 
  	<tr> 
		      <td class='line'> 
		        <table border="0" cellspacing="1" cellpadding="0" width=100%>
         		  <tr>      
		            <td width='10%' class='title'>외주비용</td>
		            <td>&nbsp;
					   <input type='text' name='etc_d1_amt' size='15'  value='<%=AddUtil.parseDecimal(carReco.getEtc_d1_amt())%>'  class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_etc_amt();'> 원</td>
		            </td>
		            <td width='10%' class='title'>부대비용</td>
		            <td>&nbsp;
					   <input type='text' name='etc2_d1_amt' size='15'   value='<%=AddUtil.parseDecimal(carReco.getEtc2_d1_amt())%>'  class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_etc_amt();'> 원</td>
		            </td>
		            <td width='10%' class='title'>비용계</td>
		            <td>&nbsp;
					 <input type='text' name='etc_out_amt' size='15' readonly value='<%=AddUtil.parseDecimal(carReco.getEtc2_d1_amt() + carReco.getEtc_d1_amt())%>' class='num' readonly onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td>
		            </td>
		          </tr>
		      
		        </table>
		      </td>
		    </tr>
		    <tr>
		      <td>&nbsp;</td>
		    </tr>	
		</table>
      </td>	 
    </tr>	     
	<tr> 
 	  <td> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
    
	    	 <tr>
			  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>선납금액 정산</span>[공급가]</td>
			</tr>
				<tr>
			    <td class=line2></td>
			</tr>
			
			<tr>
			    <td>
			        <table width=100% border=0 cellspacing=0 cellpadding=0>
			            <tr> 
				            <td  colspan="2" class='line'> 
				              <table border="0" cellspacing="1" cellpadding="0" width="100%">
				                <tr> 
				                  <td class='title' align='right' colspan="3">항목</td>
				                  <td class='title' width='38%' align="center">정산</td>
				                  <td class='title' width="40%">비고</td>
				                </tr>
				                <tr> 
				                  <td class='title' rowspan="7" width=4%>환<br>
				                    불<br>
				                    금<br>
				                    액</td>
				                  <td class='title' colspan="2">보증금(A)</td>
				                  <td class='title' > 
				                    <input type='text' name='grt_amt' value='<%=AddUtil.parseDecimal(cls.getGrt_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
				                    원</td>
				                  <td class='title'>&nbsp;</td>
				                </tr>
				                <tr> 
				                  <td class='title' rowspan="3" width=4%>개<br>
				                    시<br>
				                    대<br>
				                    여<br>
				                    료</td>
				                  <td width="14%" align="center" >경과기간</td>
				                  <td align="center"> 
				                    <input type='text' size='3' name='ifee_mon'   value='<%=cls.getIfee_mon()%>'  class='num' maxlength='4' onBlur='javascript:set_cls_amt1(this);'>
				                    개월&nbsp;&nbsp;&nbsp; 
				                    <input type='text' size='3' name='ifee_day'   value='<%=cls.getIfee_day()%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt1(this);'>
				                    일</td>
				                  <td>&nbsp;</td>
				                </tr>
				                <tr>
				                  <td align="center" >경과금액</td>
				                  <td align="center"> 
				                    <input type='text' name='ifee_ex_amt' value='<%=AddUtil.parseDecimal(cls.getIfee_ex_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
				                    원</td>
				                  <td>=개시대여료×경과기간</td>
				                </tr>
				                <tr> 
				                  <td class='title' align='right'>잔여 개시대여료(B)</td>
				                  <td class='title' align="center"> 
				                    <input type='text' name='rifee_s_amt'  value='<%=AddUtil.parseDecimal(cls.getRifee_s_amt())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
				                    원</td>
				                  <td class='title'>=개시대여료-경과금액</td>
				                </tr>
				                <tr> 
				                  <td class='title' rowspan="3">선<br>
				                    납<br>
				                    금</td>
				                  <td align='center'>월공제액 </td>
				                  <td align="center"> 
				                    <input type='text' name='pded_s_amt' value='<%=AddUtil.parseDecimal(cls.getPded_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
				                    원</td>
				                  <td>=선납금÷계약기간</td>
				                </tr>
				                <tr> 
				                  <td align='center'>선납금 공제총액 </td>
				                  <td align="center"> 
				                    <input type='text' name='tpded_s_amt' value='<%=AddUtil.parseDecimal(cls.getTpded_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
				                    원</td>
				                  <td>=월공제액×실이용기간</td>
				                </tr>
				                <tr> 
				                  <td class='title' align='right'>잔여 선납금(C)</td>
				                  <td class='title' align="center"> 
				                    <input type='text' name='rfee_s_amt'  value='<%=AddUtil.parseDecimal(cls.getRfee_s_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
				                    원</td>
				                  <td class='title'>=선납금-선납금 공제총액</td>
				                </tr>
				                <tr> 
				                  <td class='title' align='right' colspan="3">계</td>
				                  <td class='title' align="center"> 
				                    <input type='text' name='c_amt' value='' readonly size='15' class='num' >
				                    원</td>
				                  <td class='title'>=(A+B+C)</td>
				                </tr>
				              </table>
				            </td>
					     </tr>
			
			        </table>
			    </td>
			</tr>
			<tr></tr><tr></tr><tr></tr>
			
			 <input type='hidden' name='ex_ip_amt'  value='0'> 
			 <input type='hidden' name='ex_ip_dt' > 
			 <input type='hidden' name='bank_code' > 
			 <input type='hidden' name='deposit_no' > 
	
			<tr>
			    <td class=h></td>
			</tr>

	    
			<tr>
			  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>미납금액 정산</span>[공급가]</td>
			</tr>
			<tr>
		        <td class=line2></td>
		    </tr>
		    
		       <tr> 
		        <td colspan="2" class='line'> 
		          <table border="0" cellspacing="1" cellpadding="0" width=100%>
		            <tr> 
		              <td class="title" colspan="4" rowspan=2>항목</td>
		              <td class="title" width='38%' colspan=2> 채권</td>                
		              <td class="title" width='40%' rowspan=2>비고</td>
		            </tr>
		            <tr>                 
		              <td class="title"'> 당초금액</td>
		              <td class="title"'> 확정금액</td>
		              
		            </tr>
		            <tr> 
		              <td class="title" rowspan="19" width="4%">미<br>
		                납<br>
		                입<br>
		                금<br>
		                액</td>
		              <td class="title" colspan="3">과태료/범칙금(D)</td>
		              <td align="center" class="title"> 
		              <input type='text' name='fine_amt'   value='<%=AddUtil.parseDecimal(cls.getFine_amt())%>' size='15' class='num' >
		               원</td>
		              <td  align="center" class="title"> 
		               <input type='text' name='fine_amt_1'  value='<%=AddUtil.parseDecimal(cls.getFine_amt_1())%>' size='15' class='num'  > 
		               원</td>
		           
		              <td class="title">&nbsp;</td>
		             </tr>
		             <tr> 
		              <td class="title" colspan="3">자기차량손해면책금(E)</td>
		              <td width='19%' align="center" class="title"> 
		                <input type='text' name='car_ja_amt' value='<%=AddUtil.parseDecimal(cls.getCar_ja_amt())%>' size='15' class='num' >
		                원</td>
		              <td width='19%' align="center" class="title">
		              <input type='text' name='car_ja_amt_1'  value='<%=AddUtil.parseDecimal(cls.getCar_ja_amt_1())%>'   size='15' class='num'  > 
		                원</td>   
		                     
		              <td width='40%' class="title">&nbsp;</td>
		            </tr>
		             <tr>
		              <td class="title" rowspan="4" width="4%"><br>
		                대<br>
		                여<br>
		                료</td>
		              <td align="center" colspan="2" class="title">과부족</td>
		              <td class='' align="center"> 
		                <input type='text' name='ex_di_amt'  readonly  value='<%=AddUtil.parseDecimal(cls.getEx_di_amt())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '> 원</td> 
		               
		              <td class='' align="center"> 
		                <input type='text' name='ex_di_amt_1'  value='<%=AddUtil.parseDecimal(cls.getEx_di_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'> 원</td> 
		             
		              <td>&nbsp;</td>
		             
		            </tr>
		         
		            <tr> 
		              <td rowspan="2" align="center" class="title" width="4%">미<br>
		                납</td>
		              <td width='10%' align="center" class="title">기간</td>
		              <td class='' colspan=2  align="center"> 
		                <input type='text' size='3' name='nfee_mon' value='<%=cls.getNfee_mon()%>'  class='num' maxlength='4' >
		                개월&nbsp;&nbsp;&nbsp; 
		                <input type='text' size='3' name='nfee_day' value='<%=cls.getNfee_day()%>'   class='num' maxlength='4' >
		                일</td>
		              <td>&nbsp;     
		              </td>
		            </tr>
		            <tr> 
		              <td align="center" class="title">금액</td>
		              <td align="center"> 
		                <input type='text' size='15' name='nfee_amt'   value='<%=AddUtil.parseDecimal(cls.getNfee_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '> 원</td>  
		              <td align="center"> 
		                <input type='text' size='15' name='nfee_amt_1' value='<%=AddUtil.parseDecimal(cls.getNfee_amt_1())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'> 원</td>  
		             
		              <td>기발행계산서의 유지 또는 취소여부를 확인        </td>
		            </tr>			            
		  
		            <tr> 
		              <td class="title" colspan="2">소계(F)</td>
		              <td class='title' align="center" class="title"> 
		                <input type='text' size='15' name='dfee_amt' value='<%=AddUtil.parseDecimal(cls.getDfee_amt())%>' readonly class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
		                <td class='title' align="center" class="title"> 
		                <input type='text' size='15' name='dfee_amt_1' readonly value='<%=AddUtil.parseDecimal(cls.getDfee_amt_1())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>  
		               
		                 <td class='title'>&nbsp;=과부족 + 미납</td>
                 
		            </tr>
		             <input type='hidden' size='15' name='d_amt' >          
               		 <input type='hidden' size='15' name='d_amt_1'> 
		            <tr> 
		              <td rowspan="6" class="title">중<br>
		                도<br>
		                해<br>
		                지<br>
		                위<br>
		                약<br>
		                금</td>
		              <td align="center" colspan="2" class="title">대여료총액</td>
		              <td class='' colspan=2  align="center"> 
		                <input type='text' name='tfee_amt' size='15' readonly value='<%=AddUtil.parseDecimal(cls.getTfee_amt())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
		                원</td>
		              <td>=선납금+월대여료총액</td>
		            </tr>
		            <tr> 
		              <td align="center" colspan="2" class="title">월대여료(환산)</td>
		              <td class='' colspan=2 align="center"> 
		                <input type='text' name='mfee_amt' size='15' readonly  value='<%=AddUtil.parseDecimal(cls.getMfee_amt())%>' class='num' >
		                원</td>
		              <td>=대여료총액÷계약기간</td>
		            </tr>
		            <tr> 
		              <td align="center" colspan="2" class="title">잔여대여계약기간</td>
		              <td class=''  colspan=2  align="center"> 
		                <input type='text' name='rcon_mon'   size='3' value='<%=cls.getRcon_mon()%>' class='num' onBlur='javascript:set_cls_amt3(this)'  maxlength='4' >
		                개월&nbsp;&nbsp;&nbsp; 
		                <input type='text' name='rcon_day'  size='3' value='<%=cls.getRcon_day()%>' class='num' onBlur='javascript:set_cls_amt3(this)' maxlength='4'>
		                일</td>
		              <td>&nbsp;</td>
		            </tr>
		            <tr> 
		              <td align="center" colspan="2" class="title">잔여기간 대여료 총액</td>
		              <td class=''  colspan=2 align="center"> 
		                <input type='text' name='trfee_amt' value='<%=AddUtil.parseDecimal(cls.getTrfee_amt())%>' readonly size='15' class='num' >
		                원</td>
		              <td>&nbsp;</td>
		            </tr>
		            <tr> 
		              <td align="center" colspan="2" class="title"><font color="#FF0000">*</font> 위약금 
		                적용요율</td>
		              <td class='' align="center"> 
		                <input type='text' readonly name='dft_int'  value='<%=cls.getDft_int()%>' size='5' class='num'  maxlength='5'>
		                %</td>
		              <td class='' align="center"> 
		                <input type='text' name='dft_int_1'  value='<%=cls.getDft_int_1()%>' size='5' class='num' onBlur='javascript:set_cls_amt3(this)' maxlength='5'>
		                %</td>  
		              <td>위약금 적용요율은 계약서를 확인</td>
		            </tr>
		            <tr> 
		              <td  class="title" colspan="2">중도해지위약금(G)</td>
		              <td  align="center" class="title"> 
		                <input type='text' name='dft_amt' readonly  size='15' class='num' value='<%=AddUtil.parseDecimal(cls.getDft_amt())%>' >
		                원</td>
		               <td align="center" class="title"> 
		                <input type='text' name='dft_amt_1' size='15' class='num' value='<%=AddUtil.parseDecimal(cls.getDft_amt_1())%>' onBlur='javascript:set_cls_amt(this)'>
		                원</td>
		                <input type='hidden' name='tax_supply' readonly  value='<%=AddUtil.parseDecimal(cls.getDft_amt_s())%>' size='15' class='num' >      
		                <input type='hidden' name='tax_value' readonly  value='<%=AddUtil.parseDecimal(cls.getDft_amt_v())%>' size='15' class='num' >  
		                <input type='hidden' name='tax_g' size='20' class='text' value='중도해지 위약금'>          
		                <td class="title">&nbsp;<input type='checkbox' name='tax_chk0'  value='Y' <%if(cls.getTax_chk0().equals("Y")){%>checked<%}%>   disabled ></td>
		            </tr>      
		       
		             <tr> 
		              <td class="title" rowspan="6"><br>
		                기<br>
		                타</td> 		
		             
 			     <td colspan="2" align="center" class="title">연체료(H)</td>
		              <td class='title' align="center" class="title"> 
		                <input type='text' name='dly_amt' value='<%=AddUtil.parseDecimal(cls.getDly_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'> 원</td>
		              <td class='title' align="center" class="title"> 
		                <input type='text' name='dly_amt_1'  value='<%=AddUtil.parseDecimal(cls.getDly_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'> 원</td>
		               <td class='title'>&nbsp; </td>
			   </tr>	
			   <tr>           
		               <td class="title" colspan="2">차량회수외주비용(I)</td>
		              <td  align="center" class="title"> 
		                <input type='text' name='etc_amt' readonly value='<%=AddUtil.parseDecimal(cls.getEtc_amt())%>' size='15' class='num' >
		                원</td>
		               <td  align="center" class="title"> 
		                <input type='text' name='etc_amt_1'  value='<%=AddUtil.parseDecimal(cls.getEtc_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
		                원</td>  
		                <input type='hidden' name='tax_supply' readonly  value='<%=AddUtil.parseDecimal(cls.getEtc_amt_s())%>' size='15' class='num' >  
		                <input type='hidden' name='tax_value' readonly  value='<%=AddUtil.parseDecimal(cls.getEtc_amt_v())%>' size='15' class='num' >  
		                <input type='hidden' name='tax_g' size='20' class='text' value='회수 차량외주비용'>     
		               <td class="title">&nbsp;<input type='checkbox' name='tax_chk1'  value='Y' <%if(cls.getTax_chk1().equals("Y")){%>checked<%}%>  disabled  ></td>
		            </tr>
		            <tr> 
		              <td class="title" colspan="2">차량회수부대비용(J)</td>
		              <td  align="center" class="title"> 
		                <input type='text' name='etc2_amt' readonly value='<%=AddUtil.parseDecimal(cls.getEtc2_amt())%>' size='15' class='num' >
		                원</td>
		              <td align="center" class="title"> 
		                <input type='text' name='etc2_amt_1'  value='<%=AddUtil.parseDecimal(cls.getEtc2_amt_1())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
		                원</td>  
		                <input type='hidden' name='tax_supply' readonly value='<%=AddUtil.parseDecimal(cls.getEtc2_amt_s())%>' size='15' class='num' > 
		                <input type='hidden' name='tax_value' readonly value='<%=AddUtil.parseDecimal(cls.getEtc2_amt_v())%>' size='15' class='num' >  
		                <input type='hidden' name='tax_g' size='20' class='text' value='회수 부대비용'>  
		               <td class="title">&nbsp;<input type='checkbox' name='tax_chk2'  value='Y' <%if(cls.getTax_chk2().equals("Y")){%>checked<%}%>  disabled  ></td>
		            </tr>
		            <tr> 
		              <td colspan="2" class="title">잔존차량가격(K)</td>
		              <td align="center" class="title"> 
		                <input type='text' name='etc3_amt' readonly value='<%=AddUtil.parseDecimal(cls.getEtc3_amt())%>' size='15' class='num' >
		                원</td>
		              <td align="center" class="title"> 
		                <input type='text' name='etc3_amt_1' value='<%=AddUtil.parseDecimal(cls.getEtc3_amt_1())%>'size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
		                원</td> 
		            
		              <td class="title">&nbsp;</td>
		            </tr>
		            <tr> 
		              <td class="title" colspan="2">기타손해배상금(L)</td>
		              <td align="center" class="title"> 
		                <input type='text' name='etc4_amt' readonly value='<%=AddUtil.parseDecimal(cls.getEtc4_amt())%>'  size='15' class='num' >
		                원</td>
		              <td align="center" class="title"> 
		                <input type='text' name='etc4_amt_1'  value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_1())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
		                원</td>  
		               <input type='hidden' name='tax_supply' readonly  value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_s())%>' size='15' class='num' > 
		               <input type='hidden' name='tax_value' readonly  value='<%=AddUtil.parseDecimal(cls.getEtc4_amt_v())%>' size='15' class='num' >  
		               <input type='hidden' name='tax_g' size='20' class='text' value='기타손해배상금'>  
		              <td class="title">&nbsp;<input type='checkbox' name='tax_chk3' value='Y' <%if(cls.getTax_chk3().equals("Y")){%>checked<%}%>  disabled ></td>		                                          
		            </tr>
		             <tr> 
		              <td class="title" colspan="2">초과운행대여료(M)</td>
		              <td align="center" class="title"> 
		                <input type='text' name='over_amt' value='<%=AddUtil.parseDecimal(cls.getOver_amt())%>'  size='15' class='num' >
		                원</td>
		              <td align="center" class="title"> 
		                <input type='text' name='over_amt_1'  value='<%=AddUtil.parseDecimal(cls.getOver_amt_1())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
		                원</td> 
		                 <input type='hidden' name='tax_supply'   value='<%=AddUtil.parseDecimal(cls.getOver_amt_s())%>' size='15' class='num' > 
		               <input type='hidden' name='tax_value' readonly  value='<%=AddUtil.parseDecimal(cls.getOver_amt_v())%>' size='15' class='num' >  
		               <input type='hidden' name='tax_g' size='20' class='text' value='초과운행추가대여료'>    
		              <td class="title">&nbsp;<input type='checkbox' name='tax_chk4' value='Y' <%if(cls.getTax_chk4().equals("Y")){%>checked<%}%> onClick="javascript:set_vat_amt(this);"  disabled >계산서발행의뢰</td>		                                          
		                                             
		            </tr>
		                   
		            <tr> 
		              <td class="title" colspan="3">부가세(N)</td>
		              <td align="center" class="title"> 
		                <input type='text' name='no_v_amt' value='<%=AddUtil.parseDecimal(cls.getNo_v_amt())%>'  size='15' class='num' onBlur='javascript:set_cls_s_amt()'>
		                원</td>
		              <td align="center" class="title"> 
		                <input type='text' name='no_v_amt_1' value='<%=AddUtil.parseDecimal(cls.getNo_v_amt_1())%>'  size='15' class='num' onBlur='javascript:set_cls_s_amt()'>
		                원</td> 
		         
		              <td> 
		                <table width="100%" border="0" cellspacing="0" cellpadding="0">
		                  <tr> 
		                    <td id=td_cancel_n style="display:<%if( cls.getCancel_yn().equals("N") ){%>none<%}else{%>''<%}%>" class="title">=(F+M-B-C)×10%  </td>
		                    <td id=td_cancel_y style="display:<%if( cls.getCancel_yn().equals("Y") ){%>none<%}else{%>''<%}%>" class='title'>=(F+M-B-C)×10%  </td>
		                  </tr>
		                </table>
		              </td>
		            </tr>
		            
		            <tr> 
		              <td class="title_p" colspan="4">계</td>
		              <td class='title_p' align="center"> 
		                <input type='text' name='fdft_amt1'value='<%=AddUtil.parseDecimal(cls.getFdft_amt1())%>' readonly  size='15' class='num' >
		                원</td>
		              <td class='title_p' align="center"> 
		                <input type='text' name='fdft_amt1_1' value='<%=AddUtil.parseDecimal(cls.getFdft_amt1_1())%>' readonly  size='15' class='num' >
		                원</td>  
		                
		              <td class='title_p'>=(D+E+F+G+H+I+J+K+L+M+N)</td>
		            </tr>
		          </table>
		        </td>         
		    </tr>
		   
		    <tr></tr><tr></tr><tr></tr>
		
		        <!-- 선수금 정산 추가 - 20150706 -->
		     <tr id=tr_jung style="display:<%if( cct.getJung_st().equals("1") ||   cct.getJung_st().equals("2")  ){%>''<%}else{%>none<%}%>"> 
		 	  <td> 
		    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
					<tr>
					  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차액 정산</span></td>
					</tr>
					<tr>
				        <td class=line2></td>
				    </tr>
				    	
		   		  <tr> 
				        <td colspan="2" class='line'> 
				          <table border="0" cellspacing="1" cellpadding="0" width=100%>
				            <tr> 
					            <td width='10%' class='title'>정산구분</td>
					            <td colspan=5>&nbsp;<input type="radio" name="jung_st" value="1"   <%if(cct.getJung_st().equals("1"))%>checked<%%> onClick='javascript:cls_display4()'>합산정산
			                            <input type="radio" name="jung_st" value="2"  <%if(cct.getJung_st().equals("2"))%>checked<%%> onClick='javascript:cls_display4()'>구분정산</td>
			                    </tr>
				           <tr> 
				               <td class="title" rowspan=3 width='10%'>구분</td>                
				              <td class="title"  rowspan=3  width='12%'>합산정산(상계)</td>
				              <td class="title"  colspan="3"  width='35%'>구분정산</td>
				              <td class="title" rowspan=3  width='43%'>적요</td>
				            </tr>
				            <tr> 
				               <td class="title" rowspan=2 width='12%'>환불</td>
				               <td class="title" colspan=2 >청구</td>
				            </tr>
				              <tr> 
				               <td class="title" >금액</td>
				               <td class="title" >구분</td>
				            </tr>
				            <tr> 
				              <td class="title"  >선납금액</td>   
				              <td>&nbsp; <input type='text' name='h1_amt' value='<%=AddUtil.parseDecimal(cct.getH1_amt())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
				              <td>&nbsp; <input type='text' name='h4_amt' value='<%=AddUtil.parseDecimal(cct.getH4_amt())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_h_amt();'></td>
				              <td align="center" >&nbsp; </td>
				              <td align="left" >&nbsp;</td>
				              <td align="left"  rowspan=3>※ 구분정산은 청구금액 선입금후 해지정산 및 선납금액 환불처리가 가능하며,후불처리는 사전결재(총무팀장)를 득한 후 진행바랍니다.</td> 
				             </tr>
				                <tr> 
				              <td class="title"  >미납입금액</td>   
				              <td>&nbsp; <input type='text' name='h2_amt' value='<%=AddUtil.parseDecimal(cct.getH2_amt())%>'  size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
				              <td>&nbsp;</td>
				              <td align="center" >&nbsp;<input type='text' name='h6_amt' value='<%=AddUtil.parseDecimal(cct.getH6_amt())%>'   size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_h_amt();'></td>
				              <td align="left" >&nbsp; <select name='h_st'>
					                <option value="">--선택--</option>
					                <option value="1" >계약자</option>
				                         <option value="2" >운전자</option>
				                         <option value="3" >기타</option>
					              </select>
				              </td>
				             </tr>
				             <tr> 
				              <td class="title"  >정산금액</td>   
				              <td>&nbsp; <input type='text' name='h3_amt' value='<%=AddUtil.parseDecimal(cct.getH3_amt())%>' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
				              <td>&nbsp; <input type='text' name='h5_amt' value='<%=AddUtil.parseDecimal(cct.getH5_amt())%>' readonly size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '></td>
				              <td align="center" >&nbsp;<input type='text' name='h7_amt' value='<%=AddUtil.parseDecimal(cct.getH7_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '> </td>
				              <td align="left" >&nbsp;입금예정일: <input type='text' name='h_ip_dt' size='10'  value='<%=AddUtil.ChangeDate2(cct.getH_ip_dt())%>' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'>
				              <input type='hidden' name='r_date' value='<%=cct.getR_date()%>' >  
				               </td>
				             </tr>
				             </table>
				            </td>
				      </tr> 
				                
				</table>
		      </td>	 
		    </tr>	     
		    
		      <tr></tr><tr></tr><tr></tr>
		    <tr>
		        <td class=line>
		            <table width=100% border=0 cellspacing=1 cellpadding=0>
		       		  <tr>
		                    <td class=title width=12%>고객납입금액</td>
		                    <td width=14% >&nbsp;<input type='text' name='fdft_amt2' value='<%=AddUtil.parseDecimal(cls.getFdft_amt2())%>' size='14' class='num' readonly  > 원</td>
		                    <input type='hidden' name='est_amt' value='<%=AddUtil.parseDecimal(cls.getEst_amt())%>' size='15' class='num' readonly  >
		                    <td colspan=6>&nbsp;<input type='hidden' name='cms_chk' value='<%=cls.getCms_chk()%>' >
			                   <%if(cls.getCms_chk().equals("Y")){%>
			              		<font color="blue">(CMS인출의뢰)</font>&nbsp;
			              		&nbsp;부분인출금액&nbsp;<input type='text' name='cms_amt'  size='15' class='num' value='<%=AddUtil.parseDecimal(clsm.getCms_amt())%>' >			              		
			              		<% } %>   
			                    ※ 미납입금액계 - 환불금액계
			                    <%if ( user_id.equals("000063")  ) {%>
							        <a href='javascript:save2()'>부분인출변경</a>&nbsp;
							    <% } %>
			                    </td>             		
                    		            
		              </tr>
		              
		              </table>
		         </td>       
		    <tr>
		    
		    <tr id=tr_sale style="display:<%if( cls.getCls_st().equals("매입옵션") ){%>''<%}else{%>none<%}%>"> 
    
		        <td class=line>
		            <table width=100% border=0 cellspacing=1 cellpadding=0>
		       		  <tr>
		                    <td class=title width=12% >매입옵션시<br>고객납입금액</td>
		                    <input type='hidden' name='opt_amt'  value="<%=AddUtil.parseDecimal(cls.getOpt_amt())%>" >
		                    <input type='hidden' name='sui_d_amt'  value="<%=AddUtil.parseDecimal(clsm.getSui_d_amt())%>" >
		                    <td width=14% >&nbsp;<input type='text' name='fdft_amt3'  value='<%=AddUtil.parseDecimal(cls.getFdft_amt3())%>' size='14' class='num' readonly  > 원</td>
		                    <td colspan=6>&nbsp;※ 고객납입금액  + 매입옵션가 + 이전등록비용(발생한 경우)</td>
		              </tr>
		                       
		              </table>
		         </td>       
   			</tr> 
		    <tr></tr><tr></tr><tr></tr>

	
    	</table>
      </td>	 
    </tr>	  	 	
   <tr></tr><tr></tr><tr></tr>
    <tr> 
	       <td class="line">
	               <table width="100%" border="0" cellspacing="1" cellpadding="0">
	                    <tr> 
	                        <td></td>	                    
	                        <td  colspan="4" align=left><font color="#FF0000">***</font> 세금계산서변경은 반드시 부가세(L)이 정확히 계산되었는지 다시한번 확인하세요.!!!!</td>
	                    </tr>                 
	                                  
	                </table>
	       </td>
    </tr> 
	
    <tr> 
        <td align="right">
        <%if ( user_id.equals("000063")  ) {%>
        <a href='javascript:save1()'>cct변경</a>&nbsp;
        <% } %>
     
        <a href='javascript:save()'><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
	
</table>

</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--
	set_init();
		
	function set_init(){
		var fm = document.form1;		
		fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value)) + toInt(parseDigit(fm.rfee_s_amt.value)));
	}
			
//-->
</script>
</body>
</html>
