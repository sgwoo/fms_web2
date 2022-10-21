<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.fee.*, acar.cls.*, acar.cont.*, acar.common.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	if(m_id.equals(""))	m_id = as_db.getRent_mng_id(l_cd);

	//기본정보
	Hashtable base = as_db.getSettleBaseRm(m_id, l_cd, "", "");
	
	int pp_amt = AddUtil.parseInt((String)base.get("PP_S_AMT"));
//	int pp_amt = AddUtil.parseInt((String)base.get("PP_S_AMT"))+AddUtil.parseInt((String)base.get("IFEE_S_AMT"));
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(m_id, l_cd);
	
		//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(m_id, l_cd);
	
	ContFeeBean ext_fee = a_db.getContFeeNew(m_id, l_cd, Integer.toString(fee_size));
	
		//월렌트정보
	ContFeeRmBean f_fee_rm = a_db.getContFeeRm(m_id, l_cd, "1");
	
        //
   	String per = f_fee_rm.getAmt_per();
			
	//월대여료대부 적용율
	Hashtable day_pers = c_db.getEstiRmDayPers(per);

	int add_amt_d = 0;  //1달미만 사용인 경우 위약금 ( 환불금액: 대여료 - 위약금)
	int r_day_per = 0;
	
	int day_per[] = new int[30];

	//적용율값 카운트
	int day_cnt = 0;

	//이용기간
	int tot_months = AddUtil.parseInt((String)base.get("R_MON"));  
	int tot_days = AddUtil.parseInt((String)base.get("R_DAY"));  							
								
	for (int j = 0 ; j < 30 ; j++){
		day_per[j] = AddUtil.parseInt((String)day_pers.get("PER_"+(j+1)));
		
		if(j+1 == 30){
			if(day_per[j]>100) 	day_per[j] = 0;
		}else{
			if(day_per[j]>99) 	day_per[j] = 0;
		}
			
		if(day_per[j]>0) 	day_cnt++;	

		if(tot_months == 0){
			//적용일
			if(j+1 == tot_days)	r_day_per = 	day_per[j];	
		}		
	}			
			
	//실사용기간 1개월미만
								
	if(tot_months == 0  ){		
	           if ( day_cnt >  tot_days ) {	
			add_amt_d = (new Double(AddUtil.parseInt((String)base.get("FEE_S_AMT"))	)).intValue() * r_day_per / 100;
		}	

	}else if(tot_months > 0){				

	}
						
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
											
		set_init();
	  	   		
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
			
		fm.action='./lc_cls_rm_c_nodisplay.jsp';		
					
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
	
			
		//월렌트 관련 추가	
		//1달미만 해지된 경우. 날짜별 요금정산에 따름.
	   	//총사용일수 초기 셋팅		
		if(fm.r_mon.value  == '0' )  {
		          if ( toInt(parseDigit(fm.nfee_amt.value))  > 0 ) {  //미납이 있다면  (선납인데 예외로 후납됨)
			 	   fm.nfee_amt.value 	=   parseDecimal(  toInt(parseDigit(fm.add_amt_d.value)) ) ; 	    
			 }           	
			 //월렌트는 선납임 
			   if (  toInt(parseDigit(fm.ex_s_amt.value)) < 0 ){
			   	    fm.ex_di_amt.value       =   parseDecimal( ( toInt(parseDigit(fm.fee_s_amt.value))  -  toInt(parseDigit(fm.add_amt_d.value))) * (-1)  ) ; 	        
			   } 			 
		}	
							
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
		
		 //월렌트 관련 추가		
	          //1달미만 해지된 경우. 날짜별 요금정산에 따름.
	   	//총사용일수 초기 셋팅	- 월렌트인경우 1개월 미만인 경우 별도 정산 - 1개월 이후 사용시 중도해지 위약금 발생		
		if(fm.r_mon.value  == '0' )  {
			fm.dft_amt.value 	= '0';
		          if ( toInt(parseDigit(fm.nfee_amt.value))  > 0 ) {
			 	   fm.nfee_amt.value 	= 	parseDecimal( toInt(parseDigit(fm.add_amt_d.value)) ) ; 	         
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
			if (  toInt(parseDigit(fm.etc4_amt.value))  < 1   &&  obj.checked == true ) {
			     alert ("금액이 없습니다. 확인하세요!!!");
			     obj.checked = false;
			}    
			
			
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
	
		//확정금액 셋팅
	function set_cls_s_amt(){
		var fm = document.form1;	
					
		fm.d_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
	 			
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value)) +  toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.fine_amt.value)) + toInt(parseDigit(fm.etc_amt.value)) + toInt(parseDigit(fm.etc2_amt.value)) + toInt(parseDigit(fm.etc3_amt.value)) + toInt(parseDigit(fm.etc4_amt.value))  + toInt(parseDigit(fm.no_v_amt.value)));		
	
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value)) - toInt(parseDigit(fm.c_amt.value)) - toInt(parseDigit(fm.ex_ip_amt.value)) );			
	 			
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

<input type='hidden' name='dft_v_amt' value=''> <!--해지정산금 vat - 계산서 발행시 --> 
<input type='hidden' name='etc4_v_amt' value=''> <!--기타손해배상금 vat - 계산서 발행시 --> 
<input type='hidden' name='r_con_mon' value='<%=base.get("R_CON_MON")%>'> <!--만기일기준 경과계약기간 -->
<input type='hidden' name='ex_ip_amt' value='0'>

<input type='hidden' name='add_amt_d' value='<%=add_amt_d%>' >  <!--실이용기간에 따른 정산금액 (1개월 미만 사용인 경우) -->
 <input type='hidden' name='day_cnt' value='<%=day_cnt%>' >  <!--실이용기간에 따른  이용일수 기준표 값 구하기 -->
 
<input type='hidden' name='ex_di_v_amt'  value='<%=AddUtil.parseDecimal(-AddUtil.parseInt((String)base.get("EX_V_AMT"))+AddUtil.parseInt((String)base.get("DI_V_AMT")))%>'  >
<input type='hidden' name='nnfee_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("NFEE_S_AMT")))%>'> <!--스케쥴의 연체월대여료 -잔액아님 -->
<input type='hidden' name='di_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("DI_AMT")))%>'> <!--스케쥴의 연체월대여료 -잔액 -->
<input type='hidden' name='ex_s_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("EX_S_AMT")))%>'> <!--스케쥴의 선납대여료 -->
<input type='hidden' name='ex_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("EX_V_AMT")))%>'>  
<input type='hidden' name='di_v_amt' value='<%=AddUtil.parseDecimal(AddUtil.parseInt((String)base.get("DI_V_AMT")))%>'> 

<input type='hidden' name='s_mon' value='<%=base.get("S_MON")%>'>
<input type='hidden' name='s_day' value='<%=base.get("S_DAY")%>'> 

<input type='hidden' name='hs_mon' value='<%=base.get("HS_MON")%>'>  <!-- 잔액제외한 미납일자 -->
<input type='hidden' name='hs_day' value='<%=base.get("HS_DAY")%>'> <!-- 잔액제외한 미납일자 -->

<input type='hidden' name='dly_c_dt' value=''> <!-- 매입옵션 2개월전 연체이자 계산에 사용 : 대여료는 만기까지 이자는 정산시까지 -->

<input type='hidden' name='lfee_mon' value='<%=base.get("LFEE_MON")%>'> <!--만기일기준 경과계약기간 -->

<input type='hidden' name='rc_s_amt' value='<%=base.get("RC_S_AMT")%>'> <!--받은 금액 --> 
<input type='hidden' name='rc_v_amt' value='<%=base.get("RC_V_AMT")%>'> <!-- 받은 금액 --> 

<input type='hidden' name='rr_s_amt' value='<%=base.get("RR_S_AMT")%>'> <!-- 받을 금액 --> 
<input type='hidden' name='rr_v_amt' value='<%=base.get("RR_V_AMT")%>'> <!-- 받을 금액 -->
<input type='hidden' name='rr_amt' value='<%=base.get("RR_AMT")%>'> <!-- 받을 금액 -->

  <table border="0" cellspacing="0" cellpadding="0" width=630>
    <tr align="center"> 
      <td colspan="2"><font color="#006600">&lt; 월렌트 사전 정산서 &gt;</font></td>
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
            <td colspan="5"><%=AddUtil.ChangeDate2((String)base.get("RENT_START_DT"))%>~<%=AddUtil.ChangeDate2((String)base.get("RENT_END_DT"))%>&nbsp;</td>
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
                <option value="14">월렌트해지</option>             
       <!--         <option value="2">중도해약</option> -->   
          
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
 				
    <!-- 정산 -->
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
                        <td id=td_cancel_n style="display:''" class='title'>=(대여료 
                          미납입금액-B-C)×10%  </td>
                        <td id=td_cancel_y style='display:none' class='title'>=(대여료 
                         미납입금액-B-C)×10% </td>
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
                    <%if(gins.getGi_st().equals("1")){%>가입<%}else if(gins.getGi_st().equals("0")){ gins.setGi_amt(0);%>면제<%}%>
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
      <td  colspan="2" align='left'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>입금계좌</span>&nbsp;&nbsp;&nbsp; 신한은행 140-004-023871 (주)아마존카  </td>
    </tr>
    
    <tr> 
      <td>&nbsp; </td>
      <td align="right"> 
      <a href="javascript:view_cng_etc('<%=m_id%>','<%=l_cd%>');" class="btn" title='특이사항'><img src=../images/center/button_tish.gif align=absmiddle border=0></a>
     &nbsp;<a href='javascript:window.close();' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src=../images/center/button_close.gif align=absmiddle border=0></a>
     
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
			td_cancel_y.style.display 		= '';  //매출취소
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
						
		//월렌트 환산금액 - 2개월미만인경우 원대여료로 계산
		if( toInt(fm.r_mon.value)   < 2 )  {
		     	   fm.mfee_amt.value = fm.nfee_s_amt.value;
	   } else {
	        	     fm.nfee_s_amt.value = fm.mfee_amt.value;  //2개월이상인 경우는 5% dc가 기준대여료	          
	   }	        			
			
	   //개시대여료가 없는 경우 		 -- nnfee_s_amt : 미납금액(잔액아님). di_amt :잔액미납금액  	  -- 대여개시가 된 경우     	
	   if(fm.ifee_s_amt.value == '0' ) {
		   	 // 스케쥴생성보다 해지일이 더 큰 경우 
	     if  ( toInt(fm.use_e_dt.value) < toInt(replaceString("-","",fm.cls_dt.value)) ) { 		
		   	 	//	  alert("a");
		   	 		  if  ( toInt(parseDigit(fm.nnfee_s_amt.value))   < 1 &&   toInt(parseDigit(fm.di_amt.value))   < 1    ) { //
		   	 		//    	 alert("b");
		   	 		    	var s1_str = fm.use_e_dt.value;
							var e1_str = fm.cls_dt.value;
							var  count1 = 0;
								
									   
							var s1_date =  new Date (s1_str.substring(0,4), s1_str.substring(4,6) -1 , s1_str.substring(6,8) );
							var e1_date =  new Date (e1_str.substring(0,4), e1_str.substring(5,7) -1, e1_str.substring(8,10) );				
					
							var diff1_date = e1_date.getTime() - s1_date.getTime();
					
							count1 = Math.floor(diff1_date/(24*60*60*1000));									
								
					  	   	if ( count1 >= 0 ) { // 대여료만기일과 정산일 비교 (실제연체일수 계산)					  	   	
					  	   		 fm.nfee_mon.value = parseInt(count1 / 30); 
					  	   		 fm.nfee_day.value  =  parseInt(count1 % 30); 					  	 
					  	   }
		   	 		 
		   	 		  }  else  if  ( toInt(parseDigit(fm.nnfee_s_amt.value))   < 1 &&   toInt(parseDigit(fm.di_amt.value))   > 0    ) { //
		   	 	//	     alert("c");
		   	 		     fm.nfee_mon.value 	= 	toInt(fm.s_mon.value) - 1;  // 잔액이 발생되었기에 1달 빼줌
		   	 		      if ( toInt(fm.nfee_mon.value) < 0 ) {
						  	 	   	  fm.nfee_mon.value = '0';
						  }
		   	 		     
		   	 		  } 
		   	 	
		   	} //스케쥴이 있음.  		  
		
		} //개시대여료가 없는 경우	 	   		   		
		  	
						       			
		//미납금액  - 개시대여료가 있는 경우 개시대여료만큼 스케쥴이 미생성, 만기일 이후 스케쥴이 생성된 건이라면 생성된 스케쥴로 미납금액 계산하고,
		//            스케쥴 생성하지 않은 경우는 경과개시대료를 계산하여 미납금액을 계산함
		//스케줄생성안된 경과일수 인 경우
		//대여료가 100이하인 경우 별도 처리 - 2011-01-24.				
	
		if ( toInt(parseDigit(fm.nfee_s_amt.value)) < 100 ) {
			  if ( toInt(fm.rent_end_dt.value) >= toInt(replaceString("-","",fm.cls_dt.value)) ) {
			   		fm.nfee_day.value = '0';
			  } 
			  fm.nfee_amt.value 			= parseDecimal( ( toInt(parseDigit(fm.pp_s_amt.value))/toInt(parseDigit(fm.lfee_mon.value)) )  * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );	
		} else {
			  fm.nfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.nfee_s_amt.value)) * (toInt(fm.nfee_mon.value)+toInt(fm.nfee_day.value)/30) );	
		}
	
		if (fm.ifee_s_amt.value == '0' ) {	
		  	if ( toInt(fm.rent_end_dt.value) == toInt(replaceString("-","",fm.cls_dt.value)) ) {
		      if  ( fm.nfee_amt.value  != '0' ) {
			     if ( fm.nfee_amt.value  != fm.nnfee_s_amt.value ) {
		 	    	   fm.nfee_amt.value = fm.nnfee_s_amt.value;
			 	 }	
			  }	 
		   }		  
		}  			
					
	       	  //월렌트 관련 추가		
	   	//1달미만 해지된 경우. 날짜별 요금정산에 따름.
	   	//총사용일수 초기 셋팅		
		if(fm.r_mon.value  == '0' )  {
		    if ( toInt(parseDigit(fm.nfee_amt.value))  > 0 ) {  //미납이 있다면  (선납인데 예외로 후납됨)
			 	   fm.nfee_amt.value 	=   parseDecimal(  toInt(parseDigit(fm.add_amt_d.value)) ) ; 	    
			 }      
			     							   
				       //선납대여료 - 받을돈에서 받은돈 
			   if (  toInt(parseDigit(fm.rc_s_amt.value)) +  toInt(parseDigit(fm.rc_v_amt.value))    >   toInt(parseDigit(fm.rr_amt.value))  ) {	 
			            
					   if ( toInt(parseDigit(fm.day_cnt.value)) >   toInt(parseDigit(fm.r_day.value))  ) {	  
					   	  	  fm.ex_di_amt.value       =   parseDecimal( ( toInt(parseDigit(fm.fee_s_amt.value))  -  toInt(parseDigit(fm.add_amt_d.value))) * (-1)  ) ; 					   	  	  
					   	   	 fm.ex_di_v_amt.value  =   parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) * 0.1 );		 
					   	   	 fm.nfee_mon.value = '0';
							 fm.nfee_day.value = '0';
							 fm.nfee_amt.value = '0';			            
				      }   	 
			  } 
		   	
		//	   alert(  parseDecimal( ( toInt(parseDigit(fm.fee_s_amt.value))  -  toInt(parseDigit(fm.add_amt_d.value))) * (-1)  ) );
			 
		} else {   //잔여대여료 일수로 다시 계산 ( 환불일 경우)  rcon_mon, rcon_day:잔여대여기간  r_mon, r_day :이용기간 
		 		 //월렌트는 선납임   - 해지일 이후 입금건이 있다면  
			    // 완불이 안된경우는 계산된 값으로 일단 처리 - 받은돈이 많을 경우
			       			        
				          if (  toInt(parseDigit(fm.rc_s_amt.value)) +  toInt(parseDigit(fm.rc_v_amt.value))    >   toInt(parseDigit(fm.rr_amt.value))  ) {	 
				        		      fm.ex_di_amt.value  = parseDecimal( toInt(parseDigit(fm.rr_s_amt.value))  -    toInt(parseDigit(fm.rc_s_amt.value)) );	 
				        		      fm.ex_di_v_amt.value  =   parseDecimal(  toInt(parseDigit(fm.rr_amt.value))   -  toInt(parseDigit(fm.rc_s_amt.value)) -  toInt(parseDigit(fm.rc_v_amt.value)) -   toInt(parseDigit(fm.ex_di_amt.value))  );	       
								      fm.nfee_mon.value = '0';
								      fm.nfee_day.value = '0';
								      fm.nfee_amt.value = '0';			         
				          }
			
		}	
			
	 //        alert( fm.nfee_amt.value );
	 	
	   	fm.d_amt.value 				= parseDecimal( toInt(parseDigit(fm.ex_di_amt.value)) + toInt(parseDigit(fm.nfee_amt.value)) + toInt(parseDigit(fm.dly_amt.value)));
			
		if(toInt(parseDigit(fm.pp_s_amt.value)) > 0){
			fm.mfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.tfee_amt.value)) / toInt(fm.con_mon.value) );		
		}
		
		//잔여기간 대여료 총액 
		fm.trfee_amt.value 			= parseDecimal( toInt(parseDigit(fm.mfee_amt.value)) * (toInt(fm.rcon_mon.value)+toInt(fm.rcon_day.value)/30) );
				 
		if(toInt(parseDigit(fm.trfee_amt.value)) < 0){
			fm.rcon_mon.value = "0";
			fm.rcon_day.value = "0";		
			fm.trfee_amt.value = "0";					
		}		
			
		
		if(fm.dft_int.value == '' || fm.dft_int.value == '0' )	fm.dft_int.value 			= 10;					
		
		fm.dft_amt.value 			= parseDecimal( Math.round(toInt(parseDigit(fm.trfee_amt.value)) * toInt(fm.dft_int.value)/100) );
		//월렌트-   총사용일수 초기 셋팅	- 월렌트인경우 1개월 미만인 경우 별도 정산 - 1개월 이후 사용시 중도해지 위약금 발생	
		if(fm.r_mon.value  == '0' )  {
		     if ( toInt(parseDigit(fm.day_cnt.value)) >   toInt(parseDigit(fm.r_day.value))  ) {	  
				 	fm.dft_amt.value 			= '0';
		      }
		}      
		
		var no_v_amt = 0;		
	
		no_v_amt 				= toInt(parseDigit(fm.ex_di_v_amt.value)) + ( toInt(parseDigit(fm.nfee_amt.value)) * 0.1)  -  (toInt(parseDigit(fm.rfee_s_amt.value))*0.1)  -  (toInt(parseDigit(fm.rifee_s_amt.value)) *0.1);
	//	alert(	 ( toInt(parseDigit(fm.nfee_amt.value)) * 0.1)    );	
		var no_v_amt2 	 = no_v_amt;
	
		fm.no_v_amt.value 			= parseDecimal( toInt(no_v_amt2) );	
	
		fm.fdft_amt1.value 			= parseDecimal( toInt(parseDigit(fm.d_amt.value)) + toInt(parseDigit(fm.dft_amt.value)) + toInt(parseDigit(fm.car_ja_amt.value)) + toInt(parseDigit(fm.no_v_amt.value)) + toInt(parseDigit(fm.fine_amt.value)));
		
		//고객이 납입할 금액 초기 셋팅	
		fm.fdft_amt2.value 			= parseDecimal(toInt(parseDigit(fm.fdft_amt1.value)) - toInt(parseDigit(fm.c_amt.value)));			
			
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
