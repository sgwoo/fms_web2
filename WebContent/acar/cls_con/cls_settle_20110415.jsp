<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.fee.*, acar.cls.*, acar.cont.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	if(m_id.equals(""))	m_id = as_db.getRent_mng_id(l_cd);

	//기본정보
	Hashtable base = as_db.getSettleBase(m_id, l_cd, "", "");
	
	int pp_amt = AddUtil.parseInt((String)base.get("PP_S_AMT"));
//	int pp_amt = AddUtil.parseInt((String)base.get("PP_S_AMT"))+AddUtil.parseInt((String)base.get("IFEE_S_AMT"));
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(m_id, l_cd);
	
		//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(m_id, l_cd);
	
	ContFeeBean ext_fee = a_db.getContFeeNew(m_id, l_cd, Integer.toString(fee_size));
 		
	String s_opt_per="";
	int  s_opt_amt = 0;
	int	 s_opt_s_amt = 0;	
			
%>	

<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_p.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--


	//중도해지정산  보기
	function view_settle(m_id, l_cd){
		window.open("/acar/cls_con/cls_settle1.jsp?m_id="+m_id+"&l_cd="+l_cd, "VIEW_SETTLE1", "left=100, top=10, width=700, height=630, scrollbars=yes, status=yes");		
	}	
	
	
	
	//특이사항  보기
	function view_cng_etc(m_id, l_cd){
		window.open("/fms2/lc_rent/cng_etc.jsp?from_page=99&rent_mng_id="+m_id+"&rent_l_cd="+l_cd, "VIEW_CNG_ETC", "left=100, top=10, width=900, height=600, scrollbars=yes, status=yes");		
	}	
	
	
		//디스플레이 타입
	function cls_display(){
		var fm = document.form1;
				
		var s_str = fm.rent_end_dt.value;
		var e_str = fm.cls_dt.value;
		
		var s_date =  new Date (s_str.substring(0,4), s_str.substring(4,6) -1 , s_str.substring(6,8) );
		var e_date =  new Date (e_str.substring(0,4), e_str.substring(5,7) -1, e_str.substring(8,10) );
		
		var diff_date = s_date.getTime() - e_date.getTime();
		
		count = Math.floor(diff_date/(24*60*60*1000));
													
		if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '8'){ //매입옵션 선택시 디스플레이
		
			//해지일이 계약만료일 1개월전 경우 매입옵션 행사 불가
			if ( count > 30 ) {  
			  	alert("해지일이 계약만료일 1개월 이전인 경우 매입옵션을 행사할수 없습니다..!!!");
			  	set_day();  
			  	return;				
			}
			
			if(fm.opt_chk.value != '1' ){ //매입옵션 선택시 디스플레이		
			  	alert("계약당시 매입옵션 내용이 없습니다. 이같은 경우 매입옵션을 행사할수 없습니다..!!!");
			  	set_day();  
			  	return;				
			}			
		}
										
		if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '8'){ //매입옵션 선택시 디스플레이
			tr_opt.style.display 		= 'block';  //매입옵션	
			tr_sale.style.display		= 'block';	//차량매각
		}else{
			tr_opt.style.display 		= 'none';	//매입옵션
			tr_sale.style.display		= 'none';	//차량매각			
		}
						
		set_init();
	  
		fm.opt_per.value='0';
		fm.opt_amt.value='0';
	   	fm.fdft_amt3.value='0';  //차량매각
	   	fm.sui_st[0].checked = false; 		
	   		
		if(fm.cls_st.options[fm.cls_st.selectedIndex].value == '8'){
			fm.opt_per.value=fm.mopt_per.value;
			fm.opt_amt.value=fm.mopt_amt.value;
								
			//만기일보다 해지일자가 적은 경우 만기일로 다시 재계산
			if ( toInt(fm.rent_end_dt.value) >  toInt(replaceString("-","",fm.cls_dt.value))) { //만기이후 			
				set_day_sui(fm.rent_end_dt.value);											
			}
			
			
			set_sui_c_amt();			
		}		
	//	} else {
		 
			set_day();
	//	}		
	
	}	
		
	//디스플레이 타입
	function cancel_display(){
		var fm = document.form1;
		if(toInt(parseDigit(fm.fdft_amt2.value)) < 0 && toInt(parseDigit(fm.ifee_s_amt.value))+toInt(parseDigit(fm.pp_s_amt.value)) > 0){
			fm.cancel_yn[0].checked = true;
			alert('중도해지정산금액이 '+fm.fdft_amt2.value+'원으로 환불해야 합니다. \n\n이와 같은 경우에는 매출취소만 가능합니다.');
			return;			
		}
	}	
	
	//변경된 해지일자로 다시 계산
	function set_day(){
		var fm = document.form1;	
		
		if(fm.cls_dt.value == ''){ 	alert('해지일자를 입력하십시오'); 	fm.cls_dt.focus(); 	return;	}
	
		if(!isDate(fm.cls_dt.value)){ fm.cls_dt.focus(); return;	}	
		
		var s_str = fm.rent_end_dt.value;
		var e_str = fm.cls_dt.value;
		
		var s_date =  new Date (s_str.substring(0,4), s_str.substring(4,6) -1, s_str.substring(6,8) );
		var e_date =  new Date (e_str.substring(0,4), e_str.substring(5,7) -1 , e_str.substring(8,10) );
		
		var diff_date = s_date.getTime() - e_date.getTime();
		
		count = Math.floor(diff_date/(24*60*60*1000));
		
		if(fm.cls_st.value == '8'){ //매입옵션 선택시 디스플레이
								
			if(fm.opt_chk.value != '1' ){ //매입옵션 선택시 디스플레이		
			  	alert("계약당시 매입옵션 내용이 없습니다. 이같은 경우 매입옵션을 행사할수 없습니다..!!!");
			  	tr_opt.style.display 		= 'none';	//매입옵션
			  	fm.action='./lc_cls_c_nodisplay.jsp';
				fm.cls_st.value="";				
			} else {
							
				//해지일이 계약만료일 1개월전 경우 매입옵션 행사 불가
				if ( count > 30 ) { 
					alert("해지일이 계약만료일 1개월 이전인 경우 매입옵션을 행사할수 없습니다.!!!!"); 	
					tr_opt.style.display 		= 'none';	//매입옵션
					fm.action='./lc_cls_c_nodisplay.jsp';
					fm.cls_st.value="";	
					fm.dly_c_dt.value="";		
							  			
				} else {
					if ( toInt(fm.rent_end_dt.value) >  toInt(replaceString("-","",fm.cls_dt.value))) { //만기이후 		
					    fm.dly_c_dt.value = fm.cls_dt.value;
				  		fm.action='./lc_cls_c_nodisplay.jsp?dly_c_dt='+fm.dly_c_dt.value+'&cls_gubun=Y&cls_dt='+fm.rent_end_dt.value;
				    } else { 
				   		fm.action='./lc_cls_c_nodisplay.jsp?cls_gubun=Y';
				    }
				}	
			}
			
		}else {
		   	fm.action='./lc_cls_c_nodisplay.jsp';		
		}	
				
		fm.target='i_no';
		fm.submit();
	}	
	
			//변경된 해지일자로 다시 계산
	function set_day_sui(cls_dt){
		var fm = document.form1;	
					
		fm.action='./lc_cls_c_nodisplay.jsp?dly_c_dt='+fm.cls_dt.value+'&cls_gubun=Y&cls_dt='+cls_dt;		
		fm.target='i_no';
		fm.submit();
	}			
	
	
	//선납금액 정산 : 자동계산
	function set_cls_amt1(obj){
		var fm = document.form1;
			
		obj.value=parseDecimal(obj.value);
		
		if(obj == fm.r_day){ //이용기간 일 	
			set_init();
		}
		
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
				fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.r_mon.value)+toInt(fm.r_day.value)/30) );
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
	    
		if (toInt(parseDigit(fm.rfee_s_amt.value))  <= 0 ) { // 선납금액이 경과한 경우
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
				
		set_cls_amt();
	}	
		
	//미납 대여료 정산 : 자동계산
	function set_cls_amt2(obj){
		var fm = document.form1;
		
		var ifee_tm = 0;
		var pay_tm = 0;
		var v_rifee_s_amt = 0;  // 개시대여료 잔액
		var v_ifee_ex_amt = 0;  //개시대여료 경과금액
		var  re_nfee_amt = 0;  //마지막차 스케쥴에서 일수 계산한 금액이 아닌 경우 check
										
		obj.value=parseDecimal(obj.value);
	
		if(obj == fm.nfee_mon || obj == fm.nfee_day){ //미납입대여료 기간
												
			//잔여개시대여료 
			if(fm.ifee_s_amt.value != '0'){
				ifee_tm = parseDecimal( ( toInt(parseDigit(fm.ifee_s_amt.value))+1) / toInt(parseDigit(fm.nfee_s_amt.value))) ;
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
												 		    	 
		    	if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //만기이후  - 개시대여료 전체 다 공제됨
		    		
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
				 if ( toInt(fm.rent_end_dt.value) <= toInt(fm.dly_s_dt.value) ) { //이전 미납분이 없는 경우
				   	     //    alert(" 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이 없는 경우");
				   		   	  	   
			   	  	  if (toInt(fm.r_con_mon.value) > 0) {  
				   	  	  	 fm.nfee_mon.value 	= 	toInt(fm.r_con_mon.value);  //해지일 - 만기일의 개월 수
				   	  } else {  //만기전해지인 경우  
				   	  	  	 fm.nfee_mon.value = '0';
				   	  } 
		  	   	  	   
		  	   	  	      //선납이 있으면	   	  	  	 	  	
			   	      if (  toInt(parseDigit(fm.ex_s_amt.value)) > 0 ){
			   	    	     	fm.nfee_day.value = 0;
			   	      } else {
			   	  	  	   if ( toInt(fm.rent_end_dt.value) >= toInt(fm.use_e_dt.value) ) { // 만기일과 스케쥴 만기일 비교	   	  	  	    	  	   
				  	   	     fm.nfee_day.value 	= 	fm.r_day.value;
				  	   	   }				  	   	  
			  	   	  }		  	   	   	  	  	   	
		  	   	   	   
		  	   	      if ( toInt(fm.rent_end_dt.value) < toInt(fm.use_e_dt.value) ) {	  	   	      	     
				  	   	   var s1_str = fm.use_e_dt.value;
						   var e1_str = fm.cls_dt.value;
						   var  count1 = 0;
							
						   var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1 , s1_str.substring(6,8) );
						   var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1, e1_str.substring(8,10) );				
				
						   var diff1_date = e1_date.getTime() - s1_date.getTime();
				
						   count1 = Math.floor(diff1_date/(24*60*60*1000));
							
				  	   	   if ( count1 >= 0 ) { // 대여료만기일과 정산일 비교 (실제연체일수 계산)	   	  	  	    	  	   
				  	   	     fm.nfee_day.value 	= 	count1;
				  	   	   } 
				  	   }
				  	   
				 } else { //만기일 이전에 미납분이 있는 경우  - 
				   //  alert(" 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이 있는 경우");
		   	    	//미납잔액이 있는 경우      	
		   	    	if  ( toInt(parseDigit(fm.di_amt.value)) > 0  ) {		   	    		
		   	    	//     fm.nfee_mon.value 	= 	toInt(fm.s_mon.value) - 1;  // 잔액이 발생되었기에 1달 빼줌 
		   	    	  
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
			   	    		  if (	toInt(fm.s_day.value) == 0 ) {  //미납일자가 없다
			   	    		 	  fm.nfee_day.value = 0;
			   	    		  } else {	 //미납일자가 있다 
			   	    		   
			   	    		  	 fm.ex_di_amt.value  =   parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value)) / 30  *  toInt(fm.s_day.value)) -  toInt(parseDigit(fm.ex_s_amt.value)) );
								 fm.ex_di_v_amt.value  =   parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) * 0.1 );		
								 fm.nfee_day.value = 0;
							
			   	    		  }		  		   	   	   	   
		   	    	   } else {  		
			   	    	   if  ( fm.nnfee_s_amt.value  == '0' && fm.r_con_mon.value == '0') {
				   	              fm.nfee_mon.value 	= 	toInt(fm.r_mon.value) - toInt(fm.con_mon.value);  //경과일수 표시
				   	       		  fm.nfee_day.value 	= 	fm.r_day.value;
			   	    	   }
			   	    	   
			   	    	   if  ( fm.nnfee_s_amt.value  != '0' ) {
			   	   		   			   	   		  
						   	   		  // 대여료만기일과 정산일 비교 (실제연체일수 계산)	
									var s1_str = fm.use_e_dt.value;
									var e1_str = fm.cls_dt.value;
									var  count1 = 0;
																 							
									var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1 , s1_str.substring(6,8) );
									var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1, e1_str.substring(8,10) );				
										
									var diff1_date = e1_date.getTime() - s1_date.getTime();
													
									count1 = Math.floor(diff1_date/(24*60*60*1000));
													    			   			 
									if ( count1 >= 0 ) { 
									  	    re_nfee_amt  = toInt(parseDigit(fm.nnfee_s_amt.value))  +  (toInt(parseDigit(fm.nfee_s_amt.value))*count1 /30) ;
									}			   	   	   	   		   	   
			   	       		}	    	   
			   	    	   		   	    	   
			   	       }	   	
		   	    	
		   	    	} 					
				 }
				 
			 } else { //만기이후 스케쥴 생성이 된 경우
		   		    
			      if ( toInt(fm.rent_end_dt.value) <= toInt(fm.dly_s_dt.value) ) { //만기일 이전에 미납분이 없는 경우
				   	     //    alert(" 만기후 대여료스케쥴이 생성 됨, 만기일 이전 미납분이 없는 경우");   			   
				   	     //선납이 있으면	   	  	  	 	  	
				   	       if (  toInt(parseDigit(fm.ex_s_amt.value)) > 0 ){
				   	    	     	fm.nfee_day.value = 0;
				   	       } else {
				   	       	   if ( toInt(fm.rent_end_dt.value) < toInt(fm.use_e_dt.value) ) { // 만기일과 스케쥴 만기일 비교
					   	  	  	    if  ( fm.nnfee_s_amt.value  == '0' ) {   				   	  	  	     
					   	  	  	      	if ( toInt(fm.use_e_dt.value) == toInt(replaceString("-","",fm.cls_dt.value)) ) { //스케쥴만기일과 해지일이 같다면	  	    	  	   
					   	  	  	      		fm.nfee_day.value = 0;
					   	  	  	      	} else {			   	  	  	      	  	    	   
						  	   	        	fm.nfee_day.value 	= 	fm.r_day.value;
						  	   	        }	
						  	   	    }
						  	       
						  	   }	   
					  	   }	  
			  	   	 		   
			       } else {
			      	 //  alert(" 만기후 대여료스케쥴이 생성 됨, 만기일 이전 미납분이 있는 경우");			   	 		   	    			   	    	
			   	    	//미납잔액이 있는 경우      	
			   	    	if  ( toInt(parseDigit(fm.di_amt.value)) > 0  ) {		   	    		
			   	    	//     fm.nfee_mon.value 	= 	toInt(fm.s_mon.value) - 1;  // 잔액이 발생되었기에 1달 빼줌 
			   	    	  
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
				   	    	   }
				   	       }	   	
			   	    	
			   	    	}  
		          }
		       		 
		     } //스케쥴
			
		   } //개시대여료가 없는 경우	 	   		   		    
							
			//미납금액  - 개시대여료가 있는 경우 개시대여료만큼 스케쥴이 미생성, 만기일 이후 스케쥴이 생성된 건이라면 생성된 스케쥴로 미납금액 계산하고,
			//            스케쥴 생성하지 않은 경우는 경과개시대료를 계산하여 미납금액을 계산함
							 
		   fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );		
			
		   		//마지막회차인경우(일수 계산을 한경우)는 스케쥴에 남아있는 금액으로 처리 ..
			//매입옵션인 경우는 틀림.
		   if ( fm.cls_st.value == '8') { //매입옵션 
				    
					if (fm.ifee_s_amt.value == '0' ) {	
					  if ( toInt(fm.rent_end_dt.value) >= toInt(replaceString("-","",fm.cls_dt.value)) ) {
					     if  ( fm.nfee_amt.value  != '0' ) {
						     if ( fm.nfee_amt.value  != fm.nnfee_s_amt.value ) {
						 		fm.nfee_amt.value = fm.nnfee_s_amt.value;
						 		
						 	 }	
						 }	 
					  }				  
					  if ( toInt(fm.rent_end_dt.value) < toInt(replaceString("-","",fm.cls_dt.value)) ) {					  
					      if  ( fm.nfee_amt.value  != '0' ) {				      	 
					          if ( re_nfee_amt > 0 ) {	 
						 		if ( 	toInt(parseDigit(fm.nfee_amt.value))  <  re_nfee_amt) {
						 			fm.nfee_amt.value = parseDecimal(re_nfee_amt);
						 		}				  	    	
							  }
						  }	 
				      } 		  		  
					  
					}  
			} else {
			
				 if (fm.ifee_s_amt.value == '0' ) {	
				  	if ( toInt(fm.rent_end_dt.value) == toInt(replaceString("-","",fm.cls_dt.value)) ) {
				      if  ( fm.nfee_amt.value  != '0' ) {
					     if ( fm.nfee_amt.value  != fm.nnfee_s_amt.value ) {
				 	    	fm.nfee_amt.value = fm.nnfee_s_amt.value;
					 	 }	
					  }	 
				    }
				    if ( toInt(fm.rent_end_dt.value) < toInt(replaceString("-","",fm.cls_dt.value)) ) {
				      if  ( fm.nfee_amt.value  != '0' ) {
				          if ( re_nfee_amt > 0 ) {	 
					 		if ( 	toInt(parseDigit(fm.nfee_amt.value))  <  re_nfee_amt) {
					 			fm.nfee_amt.value = parseDecimal(re_nfee_amt);
					 		}				  	    	
						  }
					  }	 
				    }
				    		    
				 }  			
		    }			
						
			// 개시대여료 있는 경우에 한함. (해지일이 대여기간을 경과한 경우에 한함 )
		   if(fm.ifee_s_amt.value != '0' ) {
			    					
		   		if (v_rifee_s_amt <= 0) {  //개시대여료를 다 소진한 경우
		   	    	fm.ifee_mon.value 	= '0';
			  		fm.ifee_day.value 	= '0';
						
			   	    if ( toInt(fm.rent_end_dt.value) <  toInt(fm.use_s_dt.value)) { //만기이후 대여료 스케쥴이 생성된 경우 
			   	       if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //만기일 이전에 미납분이 있는 경우  
			   	    //       alert(" 개시대여료 소진, 만기후 대여료스케쥴이 생성, 만기일 이전 미납분이 있는 경우");
			   	       	   fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - toInt(fm.ifee_s_amt.value));	// 총미납료에서 - 개시대여료 공제
			   	       }else {
			   	      //  alert(" 만기후 대여료스케쥴이 생성, 만기일 이전 미납분이 없는 경우");				   	       	  
				   	       	//만기후 미납이 있는 경우   				   	       	    	
				   	    	if  ( toInt(parseDigit(fm.di_amt.value)) > 0  ) {		   	    		
				   	    	 //    fm.nfee_mon.value 	= 	toInt(fm.s_mon.value) - 1;  // 잔액이 발생되었기에 1달 빼줌 
				   	    	  
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
									
								   var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1 , s1_str.substring(6,8) );
								   var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1, e1_str.substring(8,10) );				
						
								   var diff1_date = e1_date.getTime() - s1_date.getTime();
						
								   count1 = Math.floor(diff1_date/(24*60*60*1000));
															 
						  	   	   if ( count1 >= 0 ) {   	  	    	  	   
						  	   	     fm.nfee_day.value 	= 	count1;
						  	   	   }
							   }	   
						  }	
						  */   	       	 	   	       	 
			   	       	  
			   	       	  fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ); 
			   	       }
			   	    } else { //만기이후 대여료 스케쥴이 생성이 안된 경우 - 경과 개시대여료 계산하여 미납분 표시 
			   	      if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //만기일 이전에 미납분이 있는 경우
			   	       //	   alert(" 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이 있는 경우");
			   	        	 var r_tm = 0;       
				   	       	 if  ( toInt(parseDigit(fm.di_amt.value)) > 0  ) {						 
						   	 	r_tm 			    = 	toInt(fm.s_mon.value)   - ifee_tm ;	// 총미납료에서 - 개시대여료 공제  , 잔액이 발생되었기에 1달 빼줌 
						   	 } else {
						   	 	r_tm 			    = 	toInt(fm.s_mon.value)  - ifee_tm ;	// 총미납료에서 - 개시대여료 공제   
						   	 }
				   	         fm.nfee_mon.value 	= r_tm;
				   	      	 fm.nfee_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30)) ;	// 총미납료에서 - 개시대여료 공제   
				   	     	   	         
			   	      }else {
			   	       //    alert(" 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이 없는 경우");
			   	        
			   	       	   fm.nfee_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - v_rifee_s_amt ) ; 
			   	      	   fm.nfee_mon.value 	= 	toInt(fm.r_mon.value) - toInt(fm.con_mon.value);  //경과일수 표시
			   	      	   fm.nfee_day.value 	= 	fm.r_day.value;			   	      	 
			   	       }
			   	   }
			    } else {  //개시대여료가 남아있는 경우
			        if ( toInt(fm.rent_end_dt.value) <  toInt(fm.use_s_dt.value)) { //만기이후 대여료 스케쥴이 생성된 경우 
			   	       if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //만기일 이전에 미납분이 있는 경우  
			   	    //   	   alert(" 개시대여료 잔액있음, 만기후 대여료스케쥴이 생성, 만기일 이전 미납분이 있는 경우");
			   	       	   fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - v_ifee_ex_amt);	// 총미납료에서 - 개시대여료 공제
			   	       }else {
			   	    //       alert(" 개시대여료 잔액있음, 만기후 대여료스케쥴이 생성, 만기일 이전 미납분이 없는 경우");
			   	       	   fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ); 
			   	       }
			   	    } else { //만기이후 대여료 스케쥴이 생성이 안된 경우 - 경과 개시대여료 계산하여 미납분 표시 
			   	      if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //만기일 이전에 미납분이 있는 경우
			   	     //      alert(" 개시대여료 잔액있음, 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이 있는 경우");
			   	           if  ( toInt(parseDigit(fm.di_amt.value)) > 0  ) {
			   	    		//	fm.nfee_mon.value 	= 	toInt(fm.s_mon.value) - 1;  // 잔액이 발생되었기에 1달 빼줌 
			   	    		//	alert(fm.nfee_mon.value);
			   	    			if ( toInt(fm.r_con_mon.value) == 0 ) { //중도해지인 경우
			   	    	     		fm.nfee_day.value 	= 	fm.r_day.value;
			   	    	   		} 
			   	    	   } else {
			   	    	      if  ( fm.nnfee_s_amt.value  == '0' && fm.r_con_mon.value == '0') {
				   	              fm.nfee_mon.value 	= 	toInt(fm.r_mon.value) - toInt(fm.con_mon.value);  //경과일수 표시
				   	       		  fm.nfee_day.value 	= 	fm.r_day.value;
			   	    		   }		   	    	
			   	    	   }   	 
			   	           fm.nfee_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - v_ifee_ex_amt);	// 총미납료에서 - 개시대여료 공제   	   
			   	      }else {
			   	     //      alert(" 개시대여료 잔액있음, 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이없는 경우");
			   	       	   fm.nfee_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ) ; 
			   	
			   	       }
			   	   }
			    }   
		   	} 
		   	
		} //미납입대여료 기간 	
		
		//과부족 및 과입금관련 vat 				
		fm.ex_di_v_amt.value = parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) * 0.1 );			
	//	alert(	fm.ex_di_v_amt.value );
				
			//각각 부가세 계산하여 더한다.	 		
		var no_v_amt = 0;
	
		no_v_amt = toInt(parseDigit(fm.ex_di_v_amt.value)) + ( toInt(parseDigit(fm.nfee_amt.value)) * 0.1)  -  ( toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  ( toInt(parseDigit(fm.rifee_s_amt.value)) *0.1) ;
			
		var no_v_amt2 	 = no_v_amt;
		fm.no_v_amt.value 			= parseDecimal( toInt(no_v_amt2) );		
				
		fm.d_amt.value 					= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
		set_cls_amt();
	}
				
	//미납 중도해지위약금 정산 : 자동계산
	function set_cls_amt3(obj){
		var fm = document.form1;
		obj.value=parseDecimal(obj.value);
		if(obj == fm.rcon_mon || obj == fm.rcon_day){ //잔여대여계약기간
			if(fm.mfee_amt.value != '0'){		
				fm.trfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );
				fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toInt(fm.dft_int.value)/100) );
			}
		}else if(obj == fm.dft_int){ //위약금 적용요율
			if(fm.trfee_amt.value != '0'){		
				fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toInt(fm.dft_int.value)/100) );
			}			
		}
		fm.d_amt.value 						= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
		set_cls_amt();
	}
					
	//고객납입하실 금액 셋팅
	function set_cls_amt(){
		var fm = document.form1;	
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value)) + toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.etc2_amt.value)) + toInt(parseDigit(fm.etc3_amt.value)) + toInt(parseDigit(fm.etc4_amt.value)) + toInt(parseDigit(fm.etc5_amt.value))+ toInt(parseDigit(fm.no_v_amt.value)));		
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value)) - toInt(parseDigit(fm.c_amt.value)));			

		if (fm.cls_st.value  == '8' ) {	//매입옵션
		   	fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)) );					
		
		}		
		
//		fm.cls_s_amt.value 			= parseDecimal( toInt(parseDigit(fm.fdft_amt2.value)) - toInt(parseDigit(fm.no_v_amt.value)) );
//		fm.cls_v_amt.value 			= parseDecimal( toInt(parseDigit(fm.no_v_amt.value)) );
	}
	
	
		//세금계산서 check 관련 부가세 - 고객납입액에 부가세 만큼 더한다(대여료, 면책금은 예외 (이미 더해졌음)) - 외상매출금 계정
	function set_vat_amt(obj){
		var fm = document.form1;
	
	//	fm.dft_v_amt.value 	= parseDecimal( toInt(parseDigit(fm.dft_amt.value)) * 0.1 );
				
		if(obj == fm.dft_tax){ // 위약금
			fm.dft_v_amt.value 	= parseDecimal( toInt(parseDigit(fm.dft_amt.value)) * 0.1 );
			
		 	if (obj.checked == true) {
		 			fm.no_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt.value))+ toInt(parseDigit(fm.dft_v_amt.value)));	
		 			fm.fdft_amt1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value))+ toInt(parseDigit(fm.dft_v_amt.value)));	
				 	fm.fdft_amt2.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.dft_v_amt.value)));			
						
			} else {
					fm.no_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt.value))- toInt(parseDigit(fm.dft_v_amt.value)));	
					fm.fdft_amt1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value))- toInt(parseDigit(fm.dft_v_amt.value)));	
					fm.fdft_amt2.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.dft_v_amt.value)));			
					
			}	
			
			
		} else if(obj == fm.etc4_tax){ // 기타손해배상금 - 회수후 판단하여 면책금등을 추가할 때
			fm.etc4_v_amt.value 	= parseDecimal( toInt(parseDigit(fm.etc4_amt.value)) * 0.1 );
		 	if (obj.checked == true) {
		 			fm.no_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt.value))+ toInt(parseDigit(fm.etc4_v_amt.value)));	
		 			fm.fdft_amt1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value))+ toInt(parseDigit(fm.etc4_v_amt.value)));	
				 	fm.fdft_amt2.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))+ toInt(parseDigit(fm.etc4_v_amt.value)));			
						
			} else {
					fm.no_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.no_v_amt.value))- toInt(parseDigit(fm.etc4_v_amt.value)));	
					fm.fdft_amt1.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value))- toInt(parseDigit(fm.etc4_v_amt.value)));	
					fm.fdft_amt2.value 		= parseDecimal(toInt(parseDigit(fm.fdft_amt2.value))- toInt(parseDigit(fm.etc4_v_amt.value)));			
					
			}		
		}	
				
	}	
	
		//이전등록비용(매입옵션)
	function set_sui_c_amt(){
		
		var fm = document.form1;
								
		if (fm.cls_st.value  == '8' ) {
		  fm.dft_amt.value = '0'; //중도해지위약금
			  		 
		 						
		  if(fm.sui_st[0].checked == true){ 		//등록비용 포함	
		  		fm.sui_d1_amt.value		= parseDecimal( toInt(parseDigit(fm.mopt_s_amt.value)) * 0.05 );  //등록세
				fm.sui_d2_amt.value		= parseDecimal( toInt(parseDigit(fm.mopt_s_amt.value)) * 0.06 * 0.25 );  //채권할인 (default:25%)
				fm.sui_d3_amt.value		= parseDecimal( toInt(parseDigit(fm.mopt_s_amt.value)) * 0.02 );  //취득세 
				fm.sui_d4_amt.value		= '3,000';  //인지대 
				fm.sui_d5_amt.value		= '1,000';  //증지대 
				fm.sui_d6_amt.value		= '11,000';  //번호판대
				fm.sui_d7_amt.value		= '10,000';  //보조번호판대
				fm.sui_d8_amt.value		= '50,000';  //등록대행료
								
				fm.sui_d_amt.value 		= parseDecimal( hun_th_rnd(toInt(parseDigit(fm.sui_d1_amt.value)) + toInt(parseDigit(fm.sui_d2_amt.value)) + toInt(parseDigit(fm.sui_d3_amt.value)) + toInt(parseDigit(fm.sui_d4_amt.value)) + toInt(parseDigit(fm.sui_d5_amt.value)) + toInt(parseDigit(fm.sui_d6_amt.value)) + toInt(parseDigit(fm.sui_d7_amt.value)) + toInt(parseDigit(fm.sui_d8_amt.value))));
					
		  } else {
				fm.sui_d1_amt.value		= '0';
				fm.sui_d2_amt.value		= '0';
				fm.sui_d3_amt.value		= '0';
				fm.sui_d4_amt.value		= '0';
				fm.sui_d5_amt.value		= '0';
				fm.sui_d6_amt.value		= '0';
				fm.sui_d7_amt.value		= '0';
				fm.sui_d8_amt.value		= '0';
				 				
				fm.sui_d_amt.value		= '0';
		  }
		} else { 		
			fm.sui_d1_amt.value		= '0';
			fm.sui_d2_amt.value		= '0';
			fm.sui_d3_amt.value		= '0';
			
			fm.sui_d_amt.value		= '0';
		}	
		
		set_cls_s_amt();
	
	}	
	
	//이전등록비용(매입옵션)
	function set_sui_amt(){
	
		var fm = document.form1;
				
		fm.sui_d_amt.value 		= parseDecimal( hun_th_rnd(toInt(parseDigit(fm.sui_d1_amt.value)) + toInt(parseDigit(fm.sui_d2_amt.value)) + toInt(parseDigit(fm.sui_d3_amt.value)) + toInt(parseDigit(fm.sui_d4_amt.value)) + toInt(parseDigit(fm.sui_d5_amt.value)) + toInt(parseDigit(fm.sui_d6_amt.value)) + toInt(parseDigit(fm.sui_d7_amt.value)) + toInt(parseDigit(fm.sui_d8_amt.value))));
							
		set_cls_s_amt();	
	}	
	
		//확정금액 셋팅
	function set_cls_s_amt(){
		var fm = document.form1;	
					
		fm.d_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
	 			
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value)) +  toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.etc2_amt.value)) + toInt(parseDigit(fm.etc3_amt.value)) + toInt(parseDigit(fm.etc4_amt.value))  + toInt(parseDigit(fm.no_v_amt.value)));		
	
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
	 	
		if (fm.cls_st.value  == '8' ) {	//매입옵션
		   	fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)) );					
		
		} 	
	}	
		
//-->
</script>
</head>
<body>
<form name='form1' method='post' >
<input type='hidden' name="rent_mng_id" 		value="<%=m_id%>">
<input type='hidden' name="rent_l_cd" 		value="<%=l_cd%>">
<input type='hidden' name='rent_start_dt' value='<%=base.get("RENT_START_DT")%>'>
<input type='hidden' name='rent_end_dt' value='<%=base.get("RENT_END_DT")%>'>
<input type='hidden' name='car_no' value='<%=base.get("CAR_NO")%>'>
<input type='hidden' name='con_mon' value='<%=base.get("CON_MON")%>'>
<input type='hidden' name='nfee_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("FEE_S_AMT")))%>'>
<input type='hidden' name='pp_s_amt' value='<%=base.get("PP_S_AMT")%>'>
<input type='hidden' name='ifee_s_amt' value='<%=base.get("IFEE_S_AMT")%>'>
<input type='hidden' name='fee_s_amt' value='<%=base.get("FEE_S_AMT")%>'>
<input type='hidden' name='use_s_dt' value='<%=base.get("USE_S_DT")%>'> 
<input type='hidden' name='use_e_dt' value='<%=base.get("USE_E_DT")%>'> 

<input type='hidden' name='ddly_s_dt' value='<%=base.get("DDLY_S_DT")%>'>   <!-- 연체중 가장 작은날짜 - 잔액부분 포함 안함 -->
<input type='hidden' name='dly_s_dt' value='<%=base.get("DLY_S_DT")%>'>   <!-- 연체중 가장 작은날짜 -->
<input type='hidden' name='dly_e_dt' value='<%=base.get("DLY_E_DT")%>'> <!-- 연체중 가장큰날짜 -->
<input type='hidden' name='dft_v_amt' value=''> <!--해지정산금 vat - 계산서 발행시 --> 
<input type='hidden' name='etc4_v_amt' value=''> <!--기타손해배상금 vat - 계산서 발행시 --> 
<input type='hidden' name='r_con_mon' value='<%=base.get("R_CON_MON")%>'> <!--만기일기준 경과계약기간 -->
<input type='hidden' name='ex_ip_amt' value='0'>
<input type='hidden' name='opt_chk' value='<%=ext_fee.getOpt_chk()%>'>

<input type='hidden' name='ex_di_v_amt'  value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base.get("EX_V_AMT"))+AddUtil.parseInt((String)base.get("DI_V_AMT")))%>'  >
<input type='hidden' name='nnfee_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("NFEE_S_AMT")))%>'> <!--스케쥴의 연체월대여료 -잔액아님 -->
<input type='hidden' name='di_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("DI_AMT")))%>'> <!--스케쥴의 연체월대여료 -잔액 -->
<input type='hidden' name='ex_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("EX_S_AMT")))%>'> <!--스케쥴의 선납대여료 -->
<input type='hidden' name='ex_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("EX_V_AMT")))%>'>  
<input type='hidden' name='di_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("DI_V_AMT")))%>'> 

<input type='hidden' name='s_mon' value='<%=base.get("S_MON")%>'>
<input type='hidden' name='dly_c_dt' value=''> <!-- 매입옵션 1개월전 연체이자 계산에 사용 : 대여료는 만기까지 이자는 정산시까지 -->

<input type='hidden' name='s_day' value='<%=base.get("S_DAY")%>'> 

<input type='hidden' name='lfee_mon' value='<%=base.get("LFEE_MON")%>'> <!--만기일기준 경과계약기간 -->
 
<input type='hidden' name='df_e_dt' value='<%=base.get("DF_E_DT")%>'> <!-- 해지일포함된 스케쥴 연체종료일 --> 
<input type='hidden' name='df_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("DF_S_AMT")))%>'> <!-- 해지일포함된 스케쥴 연체금액 (잔액아님) --> 
 
  <table border="0" cellspacing="0" cellpadding="0" width=630>
    <tr align="center"> 
      <td colspan="2"><font color="#006600">&lt; 장기대여  정산서 &gt;</font></td>
    </tr>
    <tr> 
      <td class='line' colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td width='11%' class='title'>계약번호</td>
            <td width="15%"><%=l_cd%></td>
            <td width='10%' class='title'>상호</td>
            <td><%=base.get("FIRM_NM")%></td>
            <td class='title' width="10%">차량번호</td>
            <td width="14%"><%=base.get("CAR_NO")%></td>
            <td class='title' width="10%">차명</td>
            <td width="15%"><%=base.get("CAR_NM")%></td>
          </tr>
          <tr> 
            <td class='title' width="11%">대여방식</td>
            <td width="15%"><%=base.get("RENT_WAY")%></td>
            <td class='title' width="10%">계약기간</td>
            <td colspan="5"><%=AddUtil.ChangeDate2((String)base.get("RENT_START_DT"))%>~<%=AddUtil.ChangeDate2((String)base.get("RENT_END_DT"))%>&nbsp;(<%=base.get("CON_MON")%> 개월)</td>
          </tr>
          <tr> 
            <td class='title' width="11%">월대여료</td>
            <td width="15%"><%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("FEE_S_AMT")))%>원</td>
            <td class='title' width="10%">선납금</td>
            <td width="15%"><%=AddUtil.parseDecimal((String)base.get("PP_S_AMT"))%>원</td>
            <td class='title' width="10%">개시대여료</td>
            <td width="14%"><%=AddUtil.parseDecimal((String)base.get("IFEE_S_AMT"))%>원</td>
            <td class='title' width="10%">보증금</td>
            <td><%=AddUtil.parseDecimal((String)base.get("GRT_AMT"))%>원</td>
          </tr>
          <tr> 
            <td class='title' width="11%"><font color="#FF0000">*</font>정산구분</td>
            <td width="15%"> 
              <select name="cls_st" onChange='javascript:cls_display()'>
			    <option value="">---선택---</option>
                <option value="1">계약만료</option>             
                <option value="2">중도해약</option>   
                <option value="8">매입옵션</option>           
              </select> </td>
                    
            </td>
            <td class='title' width="11%"><font color="#FF0000">*</font>정산기준일</td>
            <td width="15%"> 
              <input type='text' name='cls_dt' value='<%=base.get("CLS_DT")%>' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value); set_day();'>
            </td>
            <td class='title' width="10%">이용기간</td>
            <td colspan="3"> 
              <input type='text' name='r_mon' value='<%=base.get("R_MON")%>' readonly  class='text' size="2">
              개월 
              <input type='text' name='r_day' value='<%=base.get("R_DAY")%>'  class='text' size="2" onBlur='javascript:set_cls_amt1(this);'>
              일 </td>         
          </tr>
          <tr> 
            <td class='title' colspan="2"><font color="#FF0000">*</font>잔여선납금 
              매출취소여부</td>
            <td colspan="2"> 
              <input type="radio" name="cancel_yn" value="Y" checked  onclick="javascript:cancel_display();">
              매출취소 
              <input type="radio" name="cancel_yn" value="N" onclick="javascript:cancel_display();">
              매출유지</td>
             <td colspan="4"><font color="#999999">※ 매출취소시 마이너스 세금계산서 발행</font></td>  
          </tr>
        </table>
      </td>
    </tr>
    
    <%for(int i=0; i<fee_size; i++){
			ContFeeBean fees = a_db.getContFeeNew(m_id, l_cd, Integer.toString(i+1));
			if(!fees.getCon_mon().equals("")){
				
				s_opt_per = fees.getOpt_per();
				s_opt_amt = fees.getOpt_s_amt() + fees.getOpt_v_amt();
				s_opt_s_amt = fees.getOpt_s_amt();
    	  }
     }
     %> 
				
    <!-- 정산 -->
   
   <tr id=tr_opt style='display:none'> 
 	  <td colspan="2"> 
    	<table border="0" cellspacing="0" cellpadding="0" width=100%>
    	  <tr>
			    <td style='height:10'></td>
		  </tr> 
          <tr> 
 	 		 <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>매입옵션</span></td>
 	 	  </tr>
 	 	
 	 	  <tr>
 	 	  	 <td class='line' >  
		    	<table border="0" cellspacing="1" cellpadding="0" width=100%>
		          <tr> 		          	
		          	<input type='hidden' name='mopt_per' value='<%=s_opt_per%>'>
		          	<input type='hidden' name='mopt_amt' value='<%=AddUtil.parseDecimal(s_opt_amt)%>'>
		          	<input type='hidden' name='mopt_s_amt' value='<%=s_opt_s_amt%>'>
		          	
		 	 	     <td class='title'>매입옵션율</td>
		             <td>&nbsp;<input type='text' name='opt_per' value='<%=s_opt_per%>' size='5' class='num' maxlength='4'>%</td>
		             <td class='title'>매입옵션가</td>
		             <td colspan=2>&nbsp;<input type='text' name='opt_amt'size='13' class='num' value="<%=AddUtil.parseDecimal(s_opt_amt)%>" onBlur='javascript:this.value=parseDecimal(this.value); set_sui_c_amt();'> 원(VAT포함)</td> 
		             <td class='title'>등록비용</td>
		             <td>&nbsp;<input type="radio" name="sui_st" value="Y" onClick='javascript:set_sui_c_amt()'>포함
                         <input type="radio" name="sui_st" value="N" checked onClick='javascript:set_sui_c_amt()'>미포함</td>
                  </tr>	
                                
		          <tr> 
		 	 	     <td class='title' width="13%" rowspan=3>이전등록비용</td>
		             <td class='title' width="13%">등록세</td>
		             <td width="16%" >&nbsp;<input type='text' name='sui_d1_amt' value='' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'> 원</td> 
		             <td class='title' width="13%">채권할인</td>
		             <td width="16%" >&nbsp;<input type='text' name='sui_d2_amt' value='' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'> 원</td> 
		             <td class='title' width="11%">취득세</td>
		             <td>&nbsp;<input type='text' name='sui_d3_amt' value='' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'> 원</td> 
		          </tr>  
		          <tr> 
		 	 	     <td class='title'>인지대</td>
		             <td>&nbsp;<input type='text' name='sui_d4_amt' value='' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'> 원</td> 
		             <td class='title'>증지대</td>
		             <td >&nbsp;<input type='text' name='sui_d5_amt' value='' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'> 원</td> 
		             <td class='title'>번호판대</td>
		             <td>&nbsp;<input type='text' name='sui_d6_amt' value='' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'> 원</td> 
		          </tr>  
		          <tr> 
		 	 	     <td class='title'>보조번호판대</td>
		             <td>&nbsp;<input type='text' name='sui_d7_amt' value='' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'> 원</td> 
		             <td class='title'>등록대행료</td>
		             <td>&nbsp;<input type='text' name='sui_d8_amt' value='' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_sui_amt();'> 원</td> 
		             <td class='title'>계</td>
		             <td>&nbsp;<input type='text' name='sui_d_amt' readonly  value='' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> 원</td> 
		          </tr>  
		       </table>
		      </td>        
         </tr>   
     	</table>
      </td>	 
    </tr>	  	 	    
    <tr>
    <td style='height:10'></td>
    </tr> 
    <tr> 
      <td colspan="2"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
        
          <tr> 
            <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>선납금액 정산</span></td>
            <td align="right">[공급가]</td>
          </tr>
          <tr> 
            <td  colspan="2" class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                  <td class='title' align='right' colspan="3">항목</td>
                  <td class='title' width='35%' align="center">내용</td>
                  <td class='title' width="35%">비고</td>
                </tr>
                <tr> 
                  <td class='title' rowspan="7">환<br>
                    불<br>
                    금<br>
                    액</td>
                  <td class='title' colspan="2">보증금(A)</td>
                  <td width="35%" class='title' > 
                    <input type='text' name='grt_amt' readonly value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("GRT_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    원</td>
                  <td class='title'>&nbsp;</td>
                </tr>
                <tr> 
                  <td class='title' rowspan="3">개<br>
                    시<br>
                    대<br>
                    여<br>
                    료</td>
                  <td cwidth="15%" align="center" width="20%">경과기간</td>
                  <td width="35%" align="center"> 
                    <input type='text' size='3' name='ifee_mon' readonly  value='' class='num' maxlength='4' onBlur='javascript:set_cls_amt1(this);'>
                    개월&nbsp;&nbsp;&nbsp; 
                    <input type='text' size='3' name='ifee_day' readonly  value='' class='num' maxlength='4' onBlur='javascript:set_cls_amt1(this);'>
                    일</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td cwidth="15%" align="center" width="20%">경과금액</td>
                  <td width="35%" align="center"> 
                    <input type='text' name='ifee_ex_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    원</td>
                  <td align=center>=개시대여료×경과기간</td>
                </tr>
                <tr> 
                  <td class='title' align='right' width="20%">잔여 개시대여료(B)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='rifee_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    원</td>
                  <td class='title'>=개시대여료-경과금액</td>
                </tr>
                <tr> 
                  <td class='title' rowspan="3">선<br>
                    납<br>
                    금</td>
                  <td align='center' width="20%">월공제액 </td>
                  <td width='35%' align="center"> 
                    <input type='text' name='pded_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    원</td>
                  <td align=center>=선납금÷계약기간</td>
                </tr>
                <tr> 
                  <td align='center' width="20%">선납금 공제총액 </td>
                  <td width='35%' align="center"> 
                    <input type='text' name='tpded_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    원</td>
                  <td align=center>=월공제액×실이용기간</td>
                </tr>
                <tr> 
                  <td class='title' align='right' width="20%">잔여 선납금(C)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='rfee_s_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt1(this);'>
                    원</td>
                  <td class='title'>=선납금-선납금 공제총액</td>
                </tr>
                <tr> 
                  <td class='title' align='right' colspan="3">계</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='c_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    원</td>
                  <td class='title'>=(A+B+C)</td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td style='height:10'></td>
        </tr> 
          <tr> 
            <td align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>미납입금액 정산</span></td>
            <td align='right'>[공급가]</td>
          </tr>
          <tr> 
            <td colspan="2" class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                  <td class="title" colspan="4">항목</td>
                  <td class="title" width='35%'> 내용</td>
                  <td class="title" width='35%'>비고</td>
                </tr>
                <tr> 
                  <td class="title" rowspan="18" width="5%">미<br>
                    납<br>
                    입<br>
                    금<br>
                    액</td>
                  <td class="title" colspan="3">과태료/범칙금(D)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='fine_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("FINE_AMT")))%>' size='15' class='num' readonly  onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    원</td>
                  <td class='title' width='35%'><a href="javascript:move_settle()"><font color="#66CCFF"><%=base.get("FINE_CNT")%>건</font></a><font color="#66CCFF">&nbsp;</font></td>
                 </tr>
                 <tr> 
                  <td class="title" colspan="3">자기차량손해면책금(E)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='car_ja_amt' readonly  value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("CAR_JA_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    원</td>
                  <td class='title' width='35%'><a href="javascript:move_settle()"><font color="#66CCFF"><%=base.get("SERV_CNT")%>건</font></a><font color="#66CCFF">&nbsp;</font></td>
                </tr>
                 <tr>
                  <td class="title" rowspan="5" width="5%"><br>
                    대<br>
                    여<br>
                    료</td>
                  <td align="center" colspan="2">과부족</td>
                  <td class='' width='35%' align="center"> 
                    <input type='text' name='ex_di_amt' value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base.get("EX_S_AMT"))+AddUtil.parseInt((String)base.get("DI_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'>
                    원</td>
                  <td width='35%'>&nbsp; </td>
                </tr>
            
                <tr> 
                  <td rowspan="2" align="center" width="5%">미<br>
                    납<br>
                    입</td>
                  <td width='15%' align="center">기간</td>
                  <td class='' width='35%' align="center"> 
                    <input type='text' size='3' name='nfee_mon'  value='<%=AddUtil.parseInt((String)base.get("S_MON"))%>' readonly class='num' maxlength='4' >
                    개월&nbsp;&nbsp;&nbsp; 
                    <input type='text' size='3' name='nfee_day'  value='<%=AddUtil.parseInt((String)base.get("S_DAY"))%>' readonly class='num' maxlength='4' >
                    일</td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" width="15%">금액</td>
                  <td width='35%' align="center"> 
                    <input type='text' size='15' name='nfee_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("NFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'>
                    원</td>
                  <td width='35%' align=center>기발행계산서의 유지 또는 취소여부를 확인</td>
                </tr>
                <tr> 
                  <td colspan="2" align="center">연체료</td>
                  <td width='35%' align="center"> 
                    <input type='text' name='dly_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("DLY_AMT")))%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt2(this);'>
                    원</td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="title" colspan="2">대여료 계(F)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' size='15' name='d_amt' value='' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    원</td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td rowspan="6" class="title">중<br>
                    도<br>
                    해<br>
                    지<br>
                    위<br>
                    약<br>
                    금</td>
                  <td align="center" colspan="2">대여료총액</td>
                  <td class='' width='35%' align="center"> 
                    <input type='text' name='tfee_amt' size='15' value='<%=AddUtil.parseDecimal(pp_amt+AddUtil.parseInt((String)base.get("TFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt3(this);'>
                    원</td>
                  <td width='35%' align=center>=선납금+월대여료총액</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">월대여료(환산)</td>
                  <td class='' width='35%' align="center"> 
                    <input type='text' name='mfee_amt' size='15' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("MFEE_S_AMT")))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt3(this);'>
                    원</td>
                  <td width='35%' align=center>=대여료총액÷계약기간</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">잔여대여계약기간</td>
                  <td class='' width='35%' align="center"> 
                    <input type='text' name='rcon_mon' size='3' value='<%=AddUtil.parseInt((String)base.get("N_MON"))%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt3(this)'>
                    개월&nbsp;&nbsp;&nbsp; 
                    <input type='text' name='rcon_day' size='3' value='<%=AddUtil.parseInt((String)base.get("N_DAY"))%>' class='num' maxlength='4' onBlur='javascript:set_cls_amt3(this)'>
                    일</td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2">잔여기간 대여료 총액</td>
                  <td class='' width='35%' align="center"> 
                    <input type='text' name='trfee_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt3(this);'>
                    원</td>
                  <td width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td align="center" colspan="2"><font color="#FF0000">*</font>위약금 
                    적용요율</td>
                  <td class='' width='35%' align="center"> 
                    <input type='text' name='dft_int' value='<%=base.get("CLS_R_PER")%>' size='5' class='num' onBlur='javascript:set_cls_amt3(this)' maxlength='4'>
                    %</td>
                  <td width='35%' align=center>위약금 적용요율은 계약서를 확인</td>
                </tr>
                <tr> 
                  <td  class="title" colspan="2">중도해지위약금(G)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='dft_amt' size='15' class='num' value='' onBlur='javascript:set_cls_amt()'>
                    원</td>
                  <td class='title' width='35%'>&nbsp;<input type='checkbox' name='dft_tax' value='Y' onClick="javascript:set_vat_amt(this);">계산서발행</td>
                </tr>      
           
                <tr> 
                  <td class="title" rowspan="5" width="5%"><br>
                    기<br>
                    타</td> 
                  <td class="title" colspan="2">차량회수외주비용(H)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='etc_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    원</td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="title" colspan="2">차량회수부대비용(I)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='etc2_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    원</td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="title" colspan="2">잔존차량가격(J)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='etc3_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    원</td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="title" colspan="2">기타손해배상금(K)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='etc4_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    원</td>
                  <td class='title' width='35%'>&nbsp;<input type='checkbox' name='etc4_tax' value='Y' onClick="javascript:set_vat_amt(this);">계산서발행</td>
                </tr>
                <input type='hidden' name='etc5_amt'>
                <!--
                <tr> 
                  <td class="title" colspan="2">기타(L)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='etc5_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    원</td>
                  <td class='title' width='35%'>&nbsp;</td>
                </tr> -->
                <tr> 
                  <td class="title" colspan="2">부가세(L)</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='no_v_amt' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    원</td>
                  <td class='title' width='35%'> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td id=td_cancel_n style='display:block' class='title'>=(대여료 
                          미납입금액-B-C)×10% + 계산서 발행 부가세 </td>
                        <td id=td_cancel_y style='display:none' class='title'>=(대여료 
                         미납입금액-B-C)×10% + 계산서 발행 부가세 </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr> 
                  <td class="title" colspan="4">계</td>
                  <td class='title' width='35%' align="center"> 
                    <input type='text' name='fdft_amt1' value='' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                    원</td>
                  <td class='title' width='35%'>=(D+E+F+G+H+I+J+K+L)</td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td style='height:10'></td>
        </tr> 
          <tr> 
            <td  colspan="2" align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객께서 납입하실 금액</span></td>
          </tr>
          <tr> 
            <td colspan="2" class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                  <td class='title' width="30%">고객납입금액</td>
                  <td class='title' width="35%" align="center"> 
                    <input type='text' name='fdft_amt2' value='' size='15' class='num' maxlength='15'>
                    원</td>
                  <td class='title' width="35%"> =미납입금액계-환불금액계</td>
                </tr>
              </table>
            </td>
          </tr>
          
            <tr></tr><tr></tr><tr></tr>
        <tr id=tr_sale style='display:none'> 
            <td class=line  colspan="2">
                <table width=100% border=0 cellspacing=1 cellpadding=0>
       		  <tr>
                    <td class=title width=30%>매입옵션시 고객납입금액</td>
                    <td width=35% class='title' align=center>&nbsp;<input type='text' name='fdft_amt3'  size='15' class='num' readonly  > 원</td>
                    <td width=35% class='title' align=center>&nbsp;※ 고객납입금액  + 매입옵션금액 + 이전등록비용(발생한 경우)</td>
              </tr>
                       
              </table>
         </td>       
    <tr>
    <tr>
            <td style='height:10'></td>
    </tr> 
    
          <%	//이행보증보험
				ContGiInsBean gins = a_db.getContGiIns(m_id, l_cd);%>
          <tr> 
            <td  colspan="2" align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보증보험 가입</span></td>
          </tr>
          <tr> 
            <td colspan="2" class='line'> 
              <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr> 
                  <td class='title' width="30%"> 
                    <%if(car.getGi_st().equals("1")){%>가입<%}else if(car.getGi_st().equals("0")){ gins.setGi_amt(0);%>면제<%}%>
                  </td>
                  <td class='title' width="35%" align="center"> 
                    <input type='text' name='gi_amt' value='<%=AddUtil.parseDecimal(gins.getGi_amt())%>' size='15' class='num' maxlength='15'>
                    원</td>
                  <td class='title' width="35%"></td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="2">&nbsp; </td>
    </tr>
    
    <tr> 
      <td  colspan="2" align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>입금계좌</span>&nbsp;&nbsp;&nbsp;* 신한은행 140-004-023871 (주)아마존카</td>
    </tr>
    
    <tr> 
      <td>&nbsp; </td>
      <td align="right"> 
      <a href="javascript:view_cng_etc('<%=m_id%>','<%=l_cd%>');" class="btn" title='특이사항'><img src=../images/center/button_tish.gif align=absmiddle border=0></a>
     &nbsp;<a href='javascript:window.close();' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src=../images/center/button_close.gif align=absmiddle border=0></a>
      <% if ( user_id.equals("000063") ) { %>
        <a href="javascript:view_settle('<%=m_id%>','<%=l_cd%>');" class="btn" title='정산하기'><img src=/acar/images/center/button_js.gif align=absmiddle border=0></a>
      <% } %>
      </td>
    </tr>
  </table>  
</form>
<script language='javascript'>
<!--
	set_init();
	
	function set_init(){
		var fm = document.form1;
		var ifee_tm = 0;
		var pay_tm = 0;
		var v_rifee_s_amt = 0;  // 개시대여료 잔액
		var v_ifee_ex_amt = 0;  //개시대여료 경과금액
		var  re_nfee_amt = 0;  //마지막차 스케쥴에서 일수 계산한 금액이 아닌 경우 check
		
			
		//총사용일수 초기 셋팅		
		if(fm.r_day.value == '30'){
			fm.r_mon.value = toInt(fm.r_mon.value) + 1;
			fm.r_day.value = '0';			
		}		
								
		//해지일이 계약만료일보다 큰 경우 매출유지 setting
		if ( toInt(fm.rent_end_dt.value) <  toInt(replaceString("-","",fm.cls_dt.value))) { //만기이후 
			fm.cancel_yn.value = 'N';
			fm.cancel_yn[1].checked = true;
			td_cancel_n.style.display 		= 'none';  //매출유지
			td_cancel_y.style.display 		= 'block';  //매출취소
		}
								
			//매입옵션인 경우 매출유지 setting
		if ( fm.cls_st.value == '8') { //매입옵션 
			fm.cancel_yn.value = 'N';
			fm.cancel_yn[1].checked = true;
			td_cancel_n.style.display 		= 'none';  //매출유지
			td_cancel_y.style.display 		= 'block';  //매출취소
			tr_sale.style.display 		= 'block';  //차량매각시 고객납입금액
		}	
		
		//개시대여료가 있는 계약 - 경과기간 
		if(fm.ifee_s_amt.value != '0'){
			ifee_tm = parseDecimal((toInt(parseDigit(fm.ifee_s_amt.value))+ 1) / toInt(parseDigit(fm.nfee_s_amt.value))) ;
			
			//alert(ifee_tm);
			pay_tm = toInt(fm.con_mon.value)-ifee_tm;
		
			pay_tm =  parseDecimal(toInt(fm.con_mon.value)-ifee_tm) ;
			
				
			if(toInt(fm.r_mon.value) > pay_tm || (toInt(fm.r_mon.value) == pay_tm && toInt(fm.r_day.value) > 0)){
				fm.ifee_mon.value 	= Math.round(toInt(fm.r_mon.value)-pay_tm);
				fm.ifee_day.value 	= fm.r_day.value;
			}
		
			fm.ifee_ex_amt.value	= parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) );
			fm.rifee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) );
					
			v_ifee_ex_amt =  toInt(parseDigit( parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value))*toInt(fm.ifee_mon.value)) + (toInt(parseDigit(fm.nfee_s_amt.value))/30*toInt(fm.ifee_day.value)) )   )); //경과금액
			v_rifee_s_amt =  toInt(parseDigit( parseDecimal( toInt(parseDigit(fm.ifee_s_amt.value)) - toInt(parseDigit(fm.ifee_ex_amt.value)) )  ));														  //잔액
			
			if (v_rifee_s_amt == -1 || v_rifee_s_amt == 1 ) v_rifee_s_amt = 0;  //끝전
				
			//개시대여료가 다 경과한 경우 잔여개시대여료는 미납대여료에서 처리	
			if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //만기이후 
	    		fm.ifee_ex_amt.value = '0';
	    		fm.rifee_s_amt.value = '0'; 
	    		v_rifee_s_amt = 0;	  
	    	}	
					
		}
	
		//개시대여료가 있음에도 대여료를 별도 납부한 경우 처리 - 20100924 추가
		if(fm.ifee_s_amt.value != '0'){
			if ( toInt(fm.rent_end_dt.value) == toInt(fm.use_e_dt.value) ) {
		   		   if ( toInt(fm.rent_end_dt.value) <= toInt(fm.dly_s_dt.value) ) { //만기일 이전에 미납분이 없는 경우
		   		   		fm.ifee_mon.value 	= '';
						fm.ifee_day.value 	= '';	
		   		   		fm.ifee_ex_amt.value = '0';
		   		   		fm.rifee_s_amt.value = parseDecimal(fm.ifee_s_amt.value) ; 
		   		   }
		   	} 
	    }
	    
		//잔여선납금?
		if(fm.pp_s_amt.value != '0'){
			fm.pded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) / toInt(fm.con_mon.value) );
			fm.tpded_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pded_s_amt.value)) * (toInt(fm.r_mon.value)+toInt(fm.r_day.value)/30) );
			fm.rfee_s_amt.value 	= parseDecimal( toInt(parseDigit(fm.pp_s_amt.value)) - toInt(parseDigit(fm.tpded_s_amt.value)) );//+ toInt(parseDigit(fm.ifee_s_amt.value)) 
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
		
		// 선납금액이 경과한 경우
		if (toInt(parseDigit(fm.rfee_s_amt.value))  <= 0 ) { 
			fm.pded_s_amt.value 	= 0;
			fm.tpded_s_amt.value 	= 0;
			fm.rfee_s_amt.value 	= 0;		
		} 
		
	   	
		//선납금액	
		fm.c_amt.value 				= parseDecimal( toInt(parseDigit(fm.grt_amt.value)) + toInt(parseDigit(fm.rifee_s_amt.value)) + toInt(parseDigit(fm.rfee_s_amt.value))  );
		    
		//미납입금액 정산 초기 셋팅		
		if(fm.nfee_day.value == '31'){
			fm.nfee_mon.value = toInt(fm.nfee_mon.value) + 1;
			fm.nfee_day.value = '0';			
		}		
		
				   
	    if(fm.ifee_s_amt.value == '0' ) {
	  		//대여 스케쥴이 생성안되고, 미납이 없는 경우 scd_fee가 없어서 nfee_mon, nfee_day 구할수 없음.
		   if ( toInt(fm.rent_end_dt.value) >= toInt(fm.use_s_dt.value)) { //만기이후 대여료 스케쥴이 생성이 안된 경우 
			 						 
			 if ( toInt(fm.rent_end_dt.value) <= toInt(fm.dly_s_dt.value) ) { //만기일 이전에 미납분이 없는 경우
			   	 //alert(" 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이 없는 경우");
			   	   if (toInt(fm.r_con_mon.value) > 0) {  
			   	  	  	 fm.nfee_mon.value 	= 	toInt(fm.r_con_mon.value);  //해지일 - 만기일의 개월 수 (실사용월수)
			   	   } else {  
			   	  	  	 fm.nfee_mon.value = '0';			   	  	  	 
			   	   } 
			   	      	   
			   	   
	   	  	  	  //선납이 있으면	   	  	  	 	  	
		   	      if (  toInt(parseDigit(fm.ex_s_amt.value)) > 0 ){
		   	    	     	fm.nfee_day.value = 0;
		   	       } else {
		   	  	  	   if ( toInt(fm.rent_end_dt.value) >= toInt(fm.use_e_dt.value) ) { // 만기일과 스케쥴 만기일 비교	   	  	  	    	  	   
			  	   	     fm.nfee_day.value 	= 	fm.r_day.value;
			  	   	   }
		  	   	   }
		  	   			  	   	   
		  	   	   if ( toInt(fm.rent_end_dt.value) < toInt(fm.use_e_dt.value) ) {	  	   	      	     
			  	   	   var s1_str = fm.use_e_dt.value;
					   var e1_str = fm.cls_dt.value;
					   var  count1 = 0;
						
					   var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1 , s1_str.substring(6,8) );
					   var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1, e1_str.substring(8,10) );				
			
					   var diff1_date = e1_date.getTime() - s1_date.getTime();
			
					   count1 = Math.floor(diff1_date/(24*60*60*1000));
						
			  	   	   if ( count1 >= 0 ) { // 대여료만기일과 정산일 비교 (실제연체일수 계산)	   	  	  	    	  	   
			  	   	     	fm.nfee_day.value 	= 	count1;
			  	   	   } 
			  	   }	   
		  	   	    
			 } else { //만기일 이전에 미납분이 있는 경우 		
		   	        //  alert(" 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이 있는 경우");			   	 		   	    			   	    	
		   	    	//미납잔액이 있는 경우  			   			   	   
		   	    	if  ( toInt(parseDigit(fm.di_amt.value)) > 0  ) {		   	    		
		   	    	 //    fm.nfee_mon.value 	= 	toInt(fm.s_mon.value) - 1;  // 잔액이 발생되었기에 1달 빼줌 
		   	    	  
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
		   	    	         //스케쥴내 일부선납이 있다면 해당분만큼 공제 계산
		   	    	   if (  toInt(parseDigit(fm.ex_s_amt.value)) > 0 ){   
		   	    		  if (	toInt(fm.s_day.value) == 0 ) {  //미납일자가 없다
		   	    		 	  fm.nfee_day.value = 0;
		   	    		  } else {	 //미납일자가 있다 
		   	    		   
		   	    		  	 fm.ex_di_amt.value  =   parseDecimal( (toInt(parseDigit(fm.nfee_s_amt.value)) / 30  *  toInt(fm.s_day.value)) -  toInt(parseDigit(fm.ex_s_amt.value)) );
							 fm.ex_di_v_amt.value  =   parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) * 0.1 );		
							 fm.nfee_day.value = 0;						
		   	    		  }		   	       	   
		   	    	   } else {  	   	  
		   	    	 	
			   	    	   if  ( fm.nnfee_s_amt.value  == '0' && fm.r_con_mon.value == '0') {
				   	              fm.nfee_mon.value 	= 	toInt(fm.r_mon.value) - toInt(fm.con_mon.value);  //경과일수 표시
				   	       		  fm.nfee_day.value 	= 	fm.r_day.value;
			   	    	   }
			   	   		
			   	   	   if  ( fm.nnfee_s_amt.value  != '0'  ) {
			   	   		   			   	   		   		
			   	   		   		if ( toInt(fm.use_e_dt.value) == toInt(replaceString("-","",fm.cls_dt.value)) ) { //스케쥴만기일과 해지일이 같다면	  	    	  	   
					   	  	  	 	re_nfee_amt  = toInt(parseDigit(fm.nnfee_s_amt.value)) ;
					   	  	  	} else if  ( toInt(fm.use_e_dt.value) < toInt(replaceString("-","",fm.cls_dt.value)) ) { 				   	   		   					   	   		   					   	   		   			   	   		  
							   	   		  // 대여료만기일이후 연체금액 (실제연체일수 계산)	
										var s1_str = fm.use_e_dt.value;
										var e1_str = fm.cls_dt.value;
										var  count1 = 0;
																	 							
										var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1 , s1_str.substring(6,8) );
										var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1, e1_str.substring(8,10) );				
											
										var diff1_date = e1_date.getTime() - s1_date.getTime();
														
										count1 = Math.floor(diff1_date/(24*60*60*1000));
																		
										re_nfee_amt  = toInt(parseDigit(fm.nnfee_s_amt.value))  +  (toInt(parseDigit(fm.nfee_s_amt.value))*count1 /30);
								} else if  ( toInt(fm.use_e_dt.value) > toInt(replaceString("-","",fm.cls_dt.value)) ) { 	
								    //연체스케쥴중 에서 마직막회차연체인 경우 대여료금액이 대여기간과 틀리는 경우 발생
									if ( toInt(fm.use_e_dt.value)  == toInt(fm.dly_e_dt.value) ) {
										 //30일 이전만 가능
										if (  fm.nfee_mon.value == '0' ) {
											var s2_str = fm.dly_s_dt.value;
											var e2_str = fm.dly_e_dt.value;
											var  count2 = 0;
																		 							
											var s2_date =  new Date (s2_str.substring(0,4), s2_str.substring(4,6) -1, s2_str.substring(6,8) );
											var e2_date =  new Date (e2_str.substring(0,4), e2_str.substring(4,6) -1, e2_str.substring(6,8) );				
												
											var diff2_date = e2_date.getTime() - s2_date.getTime();
															
											count2 = Math.floor(diff2_date/(24*60*60*1000)) + 1;								
										
										    re_nfee_amt  = (toInt(parseDigit(fm.nnfee_s_amt.value))* toInt(fm.nfee_day.value)/count2);
										 //   alert(count2);
										 //   alert(re_nfee_amt) ;												  									
											   
										}	
									}	 
			   	   	   	   		 }  	   
			   	       		}
			   		}    	
			   		   	    	
		   	    	} 		   	      	 
			 }			 
			 
		  } else { //만기이후 스케쥴 생성이 된 경우
		   		    
		      if ( toInt(fm.rent_end_dt.value) <= toInt(fm.dly_s_dt.value) ) { //만기일 이전에 미납분이 없는 경우
			   	    //     alert(" 만기후 대여료스케쥴이 생성 됨, 만기일 이전 미납분이 없는 경우");			   	     			   	 
					   
			   	    //선납이 있으면	   	  	  	 	  	
		   	       if (  toInt(parseDigit(fm.ex_s_amt.value)) > 0 ){
		   	    	     	fm.nfee_day.value = 0;
		   	       } else {
		   	       	   if ( toInt(fm.rent_end_dt.value) < toInt(fm.use_e_dt.value) ) { // 만기일과 스케쥴 만기일 비교
			   	  	  	    
			   	  	  	    if  ( fm.nnfee_s_amt.value  == '0' ) {   				   	  	  	     
			   	  	  	      	if ( toInt(fm.use_e_dt.value) == toInt(replaceString("-","",fm.cls_dt.value)) ) { //스케쥴만기일과 해지일이 같다면	  	    	  	   
			   	  	  	      		fm.nfee_day.value = 0;
			   	  	  	      	} else {	
			   	  	  	      	
				   	       		  // 대여료만기일과 정산일 비교 (실제연체일수 계산)	
					  	          var s1_str = fm.use_e_dt.value;
						   		  var e1_str = fm.cls_dt.value;
								  var  count1 = 0;
									
								  var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1 , s1_str.substring(6,8) );
								  var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1, e1_str.substring(8,10) );				
						
								  var diff1_date = e1_date.getTime() - s1_date.getTime();
						
								  count1 = Math.floor(diff1_date/(24*60*60*1000));
							    					 
						  	   	  if ( count1 >= 0 ) {							  	   	      	  	  	    	  	   
						  	   	     fm.nfee_day.value 	= 	count1  ;
						  	   	 
						  	   	     if (count1 == 31 &&  fm.r_day.value == '0' && toInt(fm.nfee_mon.value) == 0 ){
						  	   	        fm.nfee_mon.value 	= "1";  //경과일수 표시
					   	       		    fm.nfee_day.value 	=  "0";
			   	    	   			 }
						  	   	     						  	   	    
						  	   	  }	
			   	  	  	      				   	  	  	      	 			  	   	        
				  	   	       //   fm.nfee_day.value 	= 	fm.r_day.value;				
				  	   	        
				  	   	        }	
				  	   	    }
				  	   	    
				  	   	    if  ( toInt(parseDigit(fm.di_amt.value)) > 0 ) {		   	    		
				   	    	//     fm.nfee_mon.value 	= 	toInt(fm.s_mon.value) - 1;  // 잔액이 발생되었기에 1달 빼줌 
				   	    	  
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
				  	   	    }
				  	       
				  	   }	   
			  	   }	  	   	   		
	   	  	 		  	   	 		   
		      } else {
		      	//   alert(" 만기후 대여료스케쥴이 생성 됨, 만기일 이전 미납분이 있는 경우");			   	 		   	    			   	    	
		   	    	//미납잔액이 있는 경우      	
		   	    	if  ( toInt(parseDigit(fm.di_amt.value)) > 0  ) {		   	    		
		   	    	 //    fm.nfee_mon.value 	= 	toInt(fm.s_mon.value) - 1;  // 잔액이 발생되었기에 1달 빼줌 
		   	    	  
		   	    	      //선납이 있다면 
		   	    	     if (  toInt(parseDigit(fm.ex_s_amt.value)) > 0 ){
		   	    	     	fm.nfee_day.value = 0;
		   	    	     } else {
		   	    	      
			   	    	  	 if ( toInt(fm.rent_end_dt.value) <= toInt(replaceString("-","",fm.cls_dt.value)) ) {
			   	    	  		 if  ( fm.nnfee_s_amt.value  == '0' ) {
			   	    	  	 		fm.nfee_day.value 	= 	fm.r_day.value;
			   	    	  	 	 }	
			   	    	  	 	 
		   	    	  	 	 	 //임의연장 전 마지막회차가 잔액이 있고 일수계산이 되는 경우				   	    	  	 	 
			   	    	  	 	 if  ( fm.nnfee_s_amt.value  != '0'  ) {		   	   		   			   	   		
				   	   		   		if  ( toInt(fm.use_e_dt.value) > toInt(replaceString("-","",fm.cls_dt.value)) ) { 	
									   	if (  fm.nfee_mon.value == '0' ) {
												var s2_str = fm.ddly_s_dt.value;														
												var e2_str = fm.cls_dt.value;
												var  count2 = 0;
																			 							
												var s2_date =  new Date (s2_str.substring(0,4), s2_str.substring(4,6) -1, s2_str.substring(6,8) );
												var e2_date =  new Date (e2_str.substring(0,4), e2_str.substring(5,7) -1, e2_str.substring(8,10) );	
													
												var diff2_date = e2_date.getTime() - s2_date.getTime();
																
												count2 = Math.floor(diff2_date/(24*60*60*1000)) + 1;	
																																		
												fm.nfee_day.value 	= 	count2;																									
										}
									
				   	   	   	   		} 
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
			   	    	   }
			   	       }	   	
		   	    	
		   	    	} 	
		      }
		   }	
	    }  //개시대여료가 없는 경우
	       			
		//미납금액  - 개시대여료가 있는 경우 개시대여료만큼 스케쥴이 미생성, 만기일 이후 스케쥴이 생성된 건이라면 생성된 스케쥴로 미납금액 계산하고,
		//            스케쥴 생성하지 않은 경우는 경과개시대료를 계산하여 미납금액을 계산함
		//스케줄생성안된 경과일수 인 경우
		//대애료가 100이하인 경우 별도 처리 - 2011-01-24.	
		if ( toInt(parseDigit(fm.nfee_s_amt.value)) < 100 ) {
		  if ( toInt(fm.rent_end_dt.value) >= toInt(replaceString("-","",fm.cls_dt.value)) ) {
		   		fm.nfee_day.value = '0';
		  } 
		  fm.nfee_amt.value 			= parseDecimal( ( toInt(parseDigit(fm.pp_s_amt.value))/toInt(parseDigit(fm.lfee_mon.value)) )  * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );	
		} else {
		  fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );	
	    }
							
		//선납이 일부되면서 해당 스케쥴 기간내 해지인 경우???
	//	if (  toInt(parseDigit(fm.ex_s_amt.value)) > 0 && toInt(parseDigit(fm.di_amt.value)) > 0 && fm.nfee_mon.value == '0' ) {
	//		 fm.ex_di_amt.value  =   parseDecimal( toInt(parseDigit(fm.nfee_amt.value))  -  toInt(parseDigit(fm.ex_s_amt.value)) );
	//		 fm.ex_di_v_amt.value  =   parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) * 0.1 );		
	//		 fm.nfee_amt.value  = '0';
	//	     alert("일부 선납이 있습니다. 전산팀에 문의해주세요!!!." );
	//	}			
		
		//마지막회차인경우(일수 계산을 한경우)는 스케쥴에 남아있는 금액으로 처리 ..
		//매입옵션인 경우는 틀림.
		if ( fm.cls_st.value == '8') { //매입옵션 
			    
			if (fm.ifee_s_amt.value == '0' ) {	
				  if ( toInt(fm.rent_end_dt.value) >= toInt(replaceString("-","",fm.cls_dt.value)) ) {
				     if  ( fm.nfee_amt.value  != '0' ) {
					     if ( fm.nfee_amt.value  != fm.nnfee_s_amt.value ) {
					 		fm.nfee_amt.value = fm.nnfee_s_amt.value;
					 		
					 	 }	
					 }	 
				  }				  
				  if ( toInt(fm.rent_end_dt.value) < toInt(replaceString("-","",fm.cls_dt.value)) ) {					  
				      if  ( fm.nfee_amt.value  != '0' ) {				      	 
				          if ( re_nfee_amt > 0 ) {	 
					 		if  ( toInt(fm.use_e_dt.value) < toInt(replaceString("-","",fm.cls_dt.value)) ) { 	 //만기스케쥴보다 해지일이 큰경우 - 20110413
			           			 fm.nfee_amt.value = parseDecimal(re_nfee_amt);	
			           		} else {	 			 
					 			if ( 	toInt(parseDigit(fm.nfee_amt.value))  <  re_nfee_amt) {
					 				fm.nfee_amt.value = parseDecimal(re_nfee_amt);
					 			}	
					 		}					  	    	
						  }
					  }	 
			      } 		  		  
				  
			}  
		} else {
		
			if (fm.ifee_s_amt.value == '0' ) {	
			  	if ( toInt(fm.rent_end_dt.value) == toInt(replaceString("-","",fm.cls_dt.value)) ) {
			      if  ( fm.nfee_amt.value  != '0' ) {
				     if ( fm.nfee_amt.value  != fm.nnfee_s_amt.value ) {
			 	    	fm.nfee_amt.value = fm.nnfee_s_amt.value;
				 	 }	
				  }	 
			    }
			    
			    if ( toInt(fm.rent_end_dt.value) < toInt(replaceString("-","",fm.cls_dt.value)) ) {
			      if  ( fm.nfee_amt.value  != '0' ) {
			          if ( re_nfee_amt > 0 ) {  
			            if  ( toInt(fm.use_e_dt.value) < toInt(replaceString("-","",fm.cls_dt.value)) ) { 	 //만기스케쥴보다 해지일이 큰경우 20110413
			           		 fm.nfee_amt.value = parseDecimal(re_nfee_amt);	
			           	} else {	 			 
					 		if ( 	toInt(parseDigit(fm.nfee_amt.value))  <  re_nfee_amt) {
					 			fm.nfee_amt.value = parseDecimal(re_nfee_amt);
					 		}	
					 	}				  	    	
					  }
				  }	 
			    }
			    
			    if ( toInt(fm.rent_end_dt.value) > toInt(replaceString("-","",fm.cls_dt.value)) ) {
			      if  ( fm.nfee_amt.value  != '0' ) {
			          if ( re_nfee_amt > 0 ) {	 
				 		if ( 	toInt(parseDigit(fm.nfee_amt.value))  <  re_nfee_amt) {
				 			fm.nfee_amt.value = parseDecimal(re_nfee_amt);
				 		}				  	    	
					  }
				  }	 
			    }
			}  			
		}			
	
		// 개시대여료 있는 경우에 한함. (해지일이 대여기간을 경과한 경우에 한함 )
	   	if(fm.ifee_s_amt.value != '0' ) {
	 	  	
	   		if (v_rifee_s_amt <= 0) {  //개시대여료를 다 소진한 경우
	   	    	fm.ifee_mon.value 	= '0';
		  		fm.ifee_day.value 	= '0';
								
		   	    if ( toInt(fm.rent_end_dt.value) <  toInt(fm.use_s_dt.value)) { //만기이후 대여료 스케쥴이 생성된 경우 
		   	   
		   	       if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //만기일 이전에 미납분이 있는 경우  
		   	      //     alert(" 개시대여료 소진, 만기후 대여료스케쥴이 생성, 만기일 이전 미납분이 있는 경우");
		   	       	   fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - toInt(fm.ifee_s_amt.value));	// 총미납료에서 - 개시대여료 공제
		   	       }else {
		   	        //   alert(" 만기후 대여료스케쥴이 생성, 만기일 이전 미납분이 없는 경우");	
		   	          		   	        
			   	          	//미납잔액이 있는 경우      	
			   	    	if  ( toInt(parseDigit(fm.di_amt.value)) > 0  ) {		   	    		
			   	    	 //    fm.nfee_mon.value 	= 	toInt(fm.s_mon.value) - 1;  // 잔액이 발생되었기에 1달 빼줌 
			   	    	  
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
									
								 var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1 , s1_str.substring(6,8) );
								 var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1, e1_str.substring(8,10) );				
						
								 var diff1_date = e1_date.getTime() - s1_date.getTime();
						
								 count1 = Math.floor(diff1_date/(24*60*60*1000));
							    						 
						  	   	 if ( count1 >= 0 ) { 
						  	   	      	  	  	    	  	   
						  	   	     fm.nfee_day.value 	= 	count1;
						  	   	  }					  	    	
					  	    }	   
				  	   }
				  	    */	   	        
		   	        	   	         		   	        	
		   	       	   fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ); 
		   	       }
		   	    } else { //만기이후 대여료 스케쥴이 생성이 안된 경우 - 경과 개시대여료 계산하여 미납분 표시 
		   	      if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //만기일 이전에 미납분이 있는 경우
		   	     //  alert(" 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이 있는 경우");
		   	  		 var r_tm = 0; 		   	  		 
					 if  ( toInt(parseDigit(fm.di_amt.value)) > 0 &&  toInt(fm.s_mon.value) > 0 ) {	
					 
				   	 	r_tm 			    = 	toInt(fm.s_mon.value)   - ifee_tm ;	// 총미납료에서 - 개시대여료 공제  , 잔액이 발생되었기에 1달 빼줌 
				   	 } else {
				   	 	r_tm 			    = 	toInt(fm.s_mon.value)  - ifee_tm ;	// 총미납료에서 - 개시대여료 공제   
				   	 }	
				   	 fm.nfee_mon.value 	= r_tm;
												     
				   	 fm.nfee_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30)) ;	// 총미납료에서 - 개시대여료 공제   
				   	 
				    // fm.nfee_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - toInt(fm.ifee_s_amt.value));	// 총미납료에서 - 개시대여료 공제   	   
			   	           
		   	         
		   	      }else {
		   	     //     alert(" 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이 없는 경우");
		   	           //alert(v_rifee_s_amt);
		   	    //   	   fm.nfee_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - v_rifee_s_amt ) ; 
		   	      	    if ( toInt(fm.r_mon.value)  > 0  || toInt(fm.r_day.value)  > 0 ) {
		   	      		   fm.nfee_mon.value 	= 	toInt(fm.r_mon.value) - toInt(fm.con_mon.value);  //경과일수 표시
		   	      	   	   fm.nfee_day.value 	= 	fm.r_day.value;
		   	      	       fm.nfee_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30)  ) ; 
		   	            }
		   	       
		   	       }
		   	   }
		    } else {  //개시대여료가 남아있는 경우
		        if ( toInt(fm.rent_end_dt.value) <  toInt(fm.use_s_dt.value)) { //만기이후 대여료 스케쥴이 생성된 경우 
		   	       if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //만기일 이전에 미납분이 있는 경우  
		   	    //   	  alert(" 개시대여료 잔액있음, 만기후 대여료스케쥴이 생성, 만기일 이전 미납분이 있는 경우");
		   	       	   fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - v_ifee_ex_amt);	// 총미납료에서 - 개시대여료 공제
		   	       }else {
		   	     //      alert(" 개시대여료 잔액있음, 만기후 대여료스케쥴이 생성, 만기일 이전 미납분이 없는 경우");
		   	       	   fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ); 
		   	       }
		   	    } else { //만기이후 대여료 스케쥴이 생성이 안된 경우 - 경과 개시대여료 계산하여 미납분 표시 
		   	      if ( toInt(fm.rent_end_dt.value) >  toInt(fm.dly_s_dt.value) ) { //만기일 이전에 미납분이 있는 경우
		   	        //   alert(" 개시대여료 잔액있음, 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이 있는 경우");
		   	     	     if  ( toInt(parseDigit(fm.di_amt.value)) > 0  ) {		   	     	     	  
			   	    		//	fm.nfee_mon.value 	= 	toInt(fm.s_mon.value) - 1;  // 잔액이 발생되었기에 1달 빼줌 
			   	    			
			   	    		//	if ( toInt(fm.r_con_mon.value) == 0 ) { //중도해지인 경우
			   	    	    // 		fm.nfee_day.value 	= 	fm.r_day.value;
			   	    	   //	} 
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
			   	    	      if  ( fm.nnfee_s_amt.value  == '0' && fm.r_con_mon.value == '0') {	
			   	    	          if (	toInt(parseDigit(fm.di_amt.value)) > 0 ){	//미납 잔액이 있으면					  				   	    	      
				   	              	fm.nfee_mon.value 	= 	toInt(fm.r_mon.value) - toInt(fm.con_mon.value);  //경과일수 표시
				   	       		  	fm.nfee_day.value 	= 	fm.r_day.value;
				   	       		  }	
			   	    		   }		   	    	
			   	    	 }   	   	
		   	             fm.nfee_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) - v_ifee_ex_amt);	// 총미납료에서 - 개시대여료 공제   	   
		   	      }else {
		   	     //      alert(" 개시대여료 잔액있음, 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이없는 경우");
		   	       	   fm.nfee_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) ) ; 
		   	
		   	      }
		   	   }
		    }   
	   	}  	
	   	  		 
	   	
	   	fm.d_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
		
		//잔여대여기간
		//
		if(fm.r_day.value != '0'){
			if ( toInt(fm.rent_end_dt.value) <=  toInt(replaceString("-","",fm.cls_dt.value))) { //만기이후
					
			} else {  //대여개월수가 일자가 있더라.. 잔여대여기간계산 수정2010-07-06  - 30일기준으로 계산
				  if (	toInt(fm.r_day.value) + toInt(fm.rcon_day.value) == 31 ) {
				    	fm.rcon_day.value 		= 30-toInt(fm.r_day.value);	
				  }
				//	fm.rcon_mon.value 		= toInt(fm.con_mon.value) - toInt(fm.r_mon.value) - 1;						   	
				//	fm.rcon_day.value 		= 30-toInt(fm.r_day.value);			
			}
				
		}else{
			fm.rcon_mon.value = toInt(fm.con_mon.value) - toInt(fm.r_mon.value);
			fm.rcon_day.value = fm.r_day.value;			
		}	
			
	
		if(toInt(parseDigit(fm.pp_s_amt.value)) > 0){
			fm.mfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.tfee_amt.value)) / toInt(fm.con_mon.value) );		
		}
		fm.trfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );
				
		 
		if(toInt(parseDigit(fm.trfee_amt.value)) < 0){
			fm.rcon_mon.value = "0";
			fm.rcon_day.value = "0";		
			fm.trfee_amt.value = "0";					
		}		
		
		if(fm.dft_int.value == '')	fm.dft_int.value 			= 30;				
		fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toInt(fm.dft_int.value)/100) );
		
		var no_v_amt = 0;		
	
		no_v_amt 				= toInt(parseDigit(fm.ex_di_v_amt.value)) + ( toInt(parseDigit(fm.nfee_amt.value)) * 0.1)  -  (toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  (toInt(parseDigit(fm.rifee_s_amt.value)) *0.1);
			
		var no_v_amt2 	 = no_v_amt;
	
		fm.no_v_amt.value 			= parseDecimal( toInt(no_v_amt2) );		
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value)) + toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.no_v_amt.value)) + toInt(parseDigit(fm.fine_amt.value)));
		
		//고객이 납입할 금액 초기 셋팅	
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value)) - toInt(parseDigit(fm.c_amt.value)));			
		
		if (fm.cls_st.value  == '8' ) {	//매입옵션
			fm.fdft_amt3.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) + toInt(parseDigit(fm.opt_amt.value))  + toInt(parseDigit(fm.sui_d_amt.value)));			
			
		}
		
		if(toInt(parseDigit(fm.fee_s_amt.value)) < toInt(parseDigit(fm.mfee_amt.value))){
			alert("월대여료와 중도해지위약금 월대여료(환산)이 틀립니다. 확인하시기 바랍니다.");
		}
		
	}	
	
	var msg = " 일할계산 ==> 대여료스케줄 확인 필!!";
	var cnt = 0;
	
	function stat(){
		if(cnt==0){
			window.status = msg;
			cnt++;
		}else{
			window.status = '';		
			cnt--;			
		}
		setTimeout("stat()",500);	
	}
	document.onload = stat();
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
