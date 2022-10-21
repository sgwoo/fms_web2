<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.credit.*, acar.user_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String cls_st = request.getParameter("cls_st")==null?"":request.getParameter("cls_st");
	String cls_doc_yn = request.getParameter("cls_doc_yn")==null?"":request.getParameter("cls_doc_yn");
	int    scd_size 	= request.getParameter("vt_size8")		==null?0 :AddUtil.parseInt(request.getParameter("vt_size8"));  //중도매입옵션시 잔여대여료 스케쥴 갯수 
	
	String add_saction_id =  request.getParameter("add_saction_id")==null?"":	request.getParameter("add_saction_id"); //중도매입옵션인경우 담당자 결재	
	int    old_opt_amt 	= request.getParameter("old_opt_amt")		==null?0 :AddUtil.parseInt(request.getParameter("old_opt_amt"));  //중도매입옵션시 원래 매입옵션 금액 
	int    b_old_opt_amt 	= request.getParameter("fee_size_1_opt_amt")		==null?0 :AddUtil.parseInt(request.getParameter("fee_size_1_opt_amt"));  //연장직전 매입옵션 금액
	int    m_r_fee_amt 	= request.getParameter("m_r_fee_amt")		==null?0 :AddUtil.parseInt(request.getParameter("m_r_fee_amt"));  //중도매입옵션시 대여료 반영분
	int    count1 	= request.getParameter("count1")		==null?0 :AddUtil.parseInt(request.getParameter("count1"));  // 
	int    count2 	= request.getParameter("count2")		==null?0 :AddUtil.parseInt(request.getParameter("count2"));  // 
	float   rc_rate 	= request.getParameter("rc_rate")	==null?0 :AddUtil.parseFloat(request.getParameter("rc_rate"));  //중도매입옵션시 현재가치율
	String mt = request.getParameter("mt")==null?"":request.getParameter("mt");  //매입옵션 구분  1:중도매입옵션, 2:연장매입옵션
			
	int flag = 0;	
	
	boolean flag1 = true;
	boolean flag2 = true;
				
	ClsEstBean cls = new ClsEstBean();
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	
	cls.setRent_mng_id(rent_mng_id);
	cls.setRent_l_cd(rent_l_cd);
	cls.setTerm_yn("0");  //의뢰등록
	cls.setCls_st(cls_st); 
	cls.setCls_dt(request.getParameter("cls_dt"));
	cls.setR_mon(request.getParameter("r_mon")==null?"":	request.getParameter("r_mon"));//실이용기간 월
	cls.setR_day(request.getParameter("r_day")==null?"":	request.getParameter("r_day"));//실이용기간 일
	cls.setCls_cau(request.getParameter("cls_cau")==null?"":request.getParameter("cls_cau"));//해지내역
	
	cls.setCls_doc_yn(cls_doc_yn);
	cls.setReg_id(reg_id); //담당자id
	
	//중도해지, 매입옵션, 만기해지 해지의뢰 등록
	
	cls.setCancel_yn(request.getParameter("cancel_yn")==null?"":request.getParameter("cancel_yn"));
	cls.setGrt_amt(request.getParameter("grt_amt")==null?0:			AddUtil.parseDigit(request.getParameter("grt_amt")));
	cls.setIfee_s_amt(request.getParameter("ifee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("ifee_s_amt")));
	cls.setIfee_mon(request.getParameter("ifee_mon")==null?"":		request.getParameter("ifee_mon"));
	cls.setIfee_day(request.getParameter("ifee_day")==null?"":		request.getParameter("ifee_day"));
	cls.setIfee_ex_amt(request.getParameter("ifee_ex_amt")==null?0:	AddUtil.parseDigit(request.getParameter("ifee_ex_amt")));
	cls.setRifee_s_amt(request.getParameter("rifee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rifee_s_amt")));
	
	cls.setPp_s_amt(request.getParameter("pp_s_amt")==null?0:		AddUtil.parseDigit(request.getParameter("pp_s_amt")));
	cls.setPded_s_amt(request.getParameter("pded_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("pded_s_amt")));
	cls.setTpded_s_amt(request.getParameter("tpded_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("tpded_s_amt")));
	cls.setRfee_s_amt(request.getParameter("rfee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rfee_s_amt")));

	cls.setNfee_s_amt(request.getParameter("nfee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("nfee_s_amt")));
	cls.setNfee_mon(request.getParameter("nfee_mon")==null?"":		request.getParameter("nfee_mon"));
	cls.setNfee_day(request.getParameter("nfee_day")==null?"":		request.getParameter("nfee_day"));
	cls.setNfee_amt(request.getParameter("nfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("nfee_amt"))); //미납대여료 당초금액
	cls.setEx_di_amt(request.getParameter("ex_di_amt")==null?0:		AddUtil.parseDigit(request.getParameter("ex_di_amt"))); //과부족 대여료 금액 (선납 또는 잔액)
	cls.setTfee_amt(request.getParameter("tfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("tfee_amt"))); //대여료 총액
	cls.setMfee_amt(request.getParameter("mfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("mfee_amt"))); //월평균대여료
	cls.setRcon_mon(request.getParameter("rcon_mon")==null?"":		request.getParameter("rcon_mon"));  //잔여기간
	cls.setRcon_day(request.getParameter("rcon_day")==null?"":		request.getParameter("rcon_day"));   //잔여기간
	cls.setTrfee_amt(request.getParameter("trfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("trfee_amt"))); //잔여기간총대여료
	cls.setDft_int(request.getParameter("dft_int")==null?"":		request.getParameter("dft_int")); //중도해지 위약율
	cls.setDft_int_1(request.getParameter("dft_int_1")==null?"":		request.getParameter("dft_int_1")); //중도해지 위약율 확정
	cls.setDft_amt(request.getParameter("dft_amt")==null?0:			AddUtil.parseDigit(request.getParameter("dft_amt")));   //중도해지위약금 당초금액
	cls.setCar_ja_amt(request.getParameter("car_ja_amt")==null?0:	AddUtil.parseDigit(request.getParameter("car_ja_amt"))); //면책금 당초금액
	cls.setDly_amt(request.getParameter("dly_amt")==null?0:			AddUtil.parseDigit(request.getParameter("dly_amt")));   //연체료 당초금액
	cls.setEtc_amt(request.getParameter("etc_amt")==null?0:			AddUtil.parseDigit(request.getParameter("etc_amt")));  //차량회수외주비 당초금액
	cls.setEtc2_amt(request.getParameter("etc2_amt")==null?0:		AddUtil.parseDigit(request.getParameter("etc2_amt"))); //차량회수부대비 당초금액
	cls.setEtc3_amt(request.getParameter("etc3_amt")==null?0:		AddUtil.parseDigit(request.getParameter("etc3_amt"))); //잔존차량가격 당초금액
	cls.setEtc4_amt(request.getParameter("etc4_amt")==null?0:		AddUtil.parseDigit(request.getParameter("etc4_amt"))); //기타손해배상금 당초금액

	cls.setFine_amt(request.getParameter("fine_amt")==null?0:		AddUtil.parseDigit(request.getParameter("fine_amt"))); //과태료 당초금액
	cls.setNo_v_amt(request.getParameter("no_v_amt")==null?0:		AddUtil.parseDigit(request.getParameter("no_v_amt")));   //부가세 당초금액
	cls.setFdft_amt1(request.getParameter("fdft_amt1")==null?0:		AddUtil.parseDigit(request.getParameter("fdft_amt1")));//합계 당초금액
	cls.setFdft_amt2(request.getParameter("fdft_amt2")==null?0:		AddUtil.parseDigit(request.getParameter("fdft_amt2")));//고객납입금액
	
	cls.setDfee_amt(request.getParameter("dfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_amt")));   //과부족+미납대여료 당초금액			
	cls.setFine_amt_1(request.getParameter("fine_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("fine_amt_1"))); //과태료 확정금액
	cls.setCar_ja_amt_1(request.getParameter("car_ja_amt_1")==null?0:	AddUtil.parseDigit(request.getParameter("car_ja_amt_1"))); //면책금 확정금액
	cls.setDly_amt_1(request.getParameter("dly_amt_1")==null?0:			AddUtil.parseDigit(request.getParameter("dly_amt_1")));   //연체료 확정금액
	cls.setEtc_amt_1(request.getParameter("etc_amt_1")==null?0:			AddUtil.parseDigit(request.getParameter("etc_amt_1")));  //차량회수외주비 확정금액
	cls.setEtc2_amt_1(request.getParameter("etc2_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc2_amt_1"))); //차량회수부대비 확정금액
	cls.setDft_amt_1(request.getParameter("dft_amt_1")==null?0:			AddUtil.parseDigit(request.getParameter("dft_amt_1")));   //중도해지위약금 확정금액
	cls.setEx_di_amt_1(request.getParameter("ex_di_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("ex_di_amt_1")));   //과부족 확정금액
	cls.setNfee_amt_1(request.getParameter("nfee_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("nfee_amt_1")));   //대여료 확정금액
	cls.setEtc3_amt_1(request.getParameter("etc3_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc3_amt_1"))); //잔존차량가격 확정금액
	cls.setEtc4_amt_1(request.getParameter("etc4_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc4_amt_1"))); //기타손해배상금 확정금액

	cls.setNo_v_amt_1(request.getParameter("no_v_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("no_v_amt_1")));   //부가세 확정금액
	cls.setFdft_amt1_1(request.getParameter("fdft_amt1_1")==null?0:		AddUtil.parseDigit(request.getParameter("fdft_amt1_1")));//합계 당초금액
	cls.setDfee_amt_1(request.getParameter("dfee_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_amt_1")));   //과부족+미납대여료 확정금액
		
	cls.setCls_s_amt(request.getParameter("cls_s_amt")==null?0:			AddUtil.parseDigit(request.getParameter("cls_s_amt")));   //해지정산금 공급가
	cls.setCls_v_amt(request.getParameter("cls_v_amt")==null?0:			AddUtil.parseDigit(request.getParameter("cls_v_amt")));   //해지정산금 부가세
					
//	if(1==1)return;
	
	cls.setDiv_st(request.getParameter("div_st")==null?"":				request.getParameter("div_st")); 						   //구분 1:완납, 2:분납  
	cls.setDiv_cnt(request.getParameter("div_cnt")==null?1:				AddUtil.parseDigit(request.getParameter("div_cnt")));     //분납횟수  
	cls.setEst_dt(request.getParameter("est_dt")==null?"":				request.getParameter("est_dt"));  						   //입금예정일
	cls.setEst_amt(request.getParameter("est_amt")==null?0:				AddUtil.parseDigit(request.getParameter("est_amt")));	   //채권약정금액 
	cls.setEst_nm(request.getParameter("est_nm")==null?"":				request.getParameter("est_nm"));  				   //입금약정자
	cls.setGur_nm(request.getParameter("gur_nm")==null?"":				request.getParameter("gur_nm")); 				   //대위변제자
	cls.setGur_rel_tel(request.getParameter("gur_rel_tel")==null?"":	request.getParameter("gur_rel_tel"));      //확정금액 사유
	cls.setGur_rel(request.getParameter("gur_rel")==null?"":			request.getParameter("gur_rel")); 		   //확정금액 결재자
	cls.setRemark(request.getParameter("remark")==null?"":				request.getParameter("remark"));           //처리의견

	if(cls_st.equals("8")){//매입옵션인경우 
		cls.setOpt_per(request.getParameter("opt_per")==null?"":		request.getParameter("opt_per"));
		cls.setOpt_amt(request.getParameter("opt_amt")==null?0:			AddUtil.parseDigit(request.getParameter("opt_amt")));			 
	}	
				
	//세금계산서 발행의뢰건 등록 : 의뢰했더라도 실제세금계산서가 발행안될 수 있음 :장기연체인 경우 (수금시 세금계산서 발행처리)
	cls.setTax_chk0(request.getParameter("tax_chk0")==null?"N":request.getParameter("tax_chk0"));  //중도해지위약금
	cls.setTax_chk1(request.getParameter("tax_chk1")==null?"N":request.getParameter("tax_chk1"));  //차량외주비용
	cls.setTax_chk2(request.getParameter("tax_chk2")==null?"N":request.getParameter("tax_chk2"));  //차량부대비용
	cls.setTax_chk3(request.getParameter("tax_chk3")==null?"N":request.getParameter("tax_chk3"));  //기타손해배상금
	cls.setTax_chk4(request.getParameter("tax_chk4")==null?"N":request.getParameter("tax_chk4"));  // 초과운행
		
	String tax_supply[] = request.getParameterValues("tax_supply");
  	String tax_value[] = request.getParameterValues("tax_value");
	String tax_g[] = request.getParameterValues("tax_g");
	
	int tax_size = tax_g.length;
	for(int i = 0; i<tax_size; i++){
    		String tax_chk = request.getParameter("tax_chk"+i)==null?"N":	request.getParameter("tax_chk"+i);
		//	out.println(tax_chk);
  			if(tax_chk.equals("Y")){
    	//		out.println("선택"+i+"=<br><br>");
	    //		out.println("tax_g="+tax_g[i]+"<br>");
       //		out.println("tax_supply="+tax_supply[i]+"<br>");
        		
        		if (i == 0) {
        			cls.setDft_amt_s(AddUtil.parseDigit(tax_supply[i]));
	       	 		cls.setDft_amt_v(AddUtil.parseDigit(tax_value[i]));
       	 		} else if ( i == 1 ){
	       	 		cls.setEtc_amt_s(AddUtil.parseDigit(tax_supply[i]));
	       	 		cls.setEtc_amt_v(AddUtil.parseDigit(tax_value[i]));
	       	 	} else if ( i == 2 ){
	       	 		cls.setEtc2_amt_s(AddUtil.parseDigit(tax_supply[i]));
	       	 		cls.setEtc2_amt_v(AddUtil.parseDigit(tax_value[i]));
	       	 	} else if ( i == 3 ){
	       	 		cls.setEtc4_amt_s(AddUtil.parseDigit(tax_supply[i]));
	       	 		cls.setEtc4_amt_v(AddUtil.parseDigit(tax_value[i]));       	
	       	 	} else if ( i == 4 ){
	       	 		cls.setOver_amt_s(AddUtil.parseDigit(tax_supply[i]));
	       	 		cls.setOver_amt_v(AddUtil.parseDigit(tax_value[i]));       		
	       	 	}	
   		//	tax_cnt++;
  			
  			} else {
  			
  				if (i == 0) {
        				cls.setDft_amt_s(0);
	       	 		cls.setDft_amt_v(0);
       	 		} else if ( i == 1 ){
	       	 		cls.setEtc_amt_s(0);
	       	 		cls.setEtc_amt_v(0);
	       	 	} else if ( i == 2 ){
	       	 		cls.setEtc2_amt_s(0);
	       	 		cls.setEtc2_amt_v(0);
	       	 	} else if ( i == 3 ){
	       	 		cls.setEtc4_amt_s(0);
	       	 		cls.setEtc4_amt_v(0);       	
	       	 	} else if ( i == 4 ){
	       	 		cls.setOver_amt_s(0);
	       	 		cls.setOver_amt_v(0);       		
	       	 	}	  			
  			}
	}				
	
	cls.setCar_ja_no_amt(request.getParameter("car_ja_no_amt")==null?0:			AddUtil.parseDigit(request.getParameter("car_ja_no_amt")));   //미입금된 면책금중 계산서 미청구분
	cls.setFdft_amt3(request.getParameter("fdft_amt3")==null?0:					AddUtil.parseDigit(request.getParameter("fdft_amt3")));   //차량매각시 고객 납입금액
	cls.setTot_dist(request.getParameter("tot_dist")==null?0:					AddUtil.parseDigit(request.getParameter("tot_dist")));   //차량주행거리
	
	//초과운행거리
	cls.setOver_amt(request.getParameter("over_amt")==null?0:			AddUtil.parseDigit(request.getParameter("over_amt")));  //초과운행 예정금액
	cls.setOver_amt_1(request.getParameter("over_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("over_amt_1"))); //초과운행 확정금액
		
	if(!ac_db.insertClsEst(cls))	flag += 1;
	
		//중도매입옵션관련 추가 - 20161028	
	if ( old_opt_amt > 0 ) { 

		ClsEtcAddBean clsa = new ClsEtcAddBean();
		clsa.setRent_mng_id(rent_mng_id);
		clsa.setRent_l_cd(rent_l_cd);
		clsa.setA_f(request.getParameter("a_f")==null?0:		AddUtil.parseFloat(request.getParameter("a_f"))); //이자율 
		clsa.setOld_opt_amt(request.getParameter("old_opt_amt")==null?0:	AddUtil.parseDigit(request.getParameter("old_opt_amt"))); //계약서상 매입옵션 금액
		clsa.setAdd_saction_id(request.getParameter("add_saction_id")==null?"":	request.getParameter("add_saction_id")); //중도매입담당자 
		
		clsa.setMt(request.getParameter("mt")==null?"":	request.getParameter("mt")); //매입옵션 1:중도매입 2:연장중도매입
		clsa.setRc_rate(request.getParameter("rc_rate")==null?0:		AddUtil.parseFloat(request.getParameter("rc_rate"))); //현재가치율
		clsa.setB_old_opt_amt(request.getParameter("fee_size_1_opt_amt")==null?0:	AddUtil.parseDigit(request.getParameter("fee_size_1_opt_amt"))); //연장직전  매입옵션 금액
		clsa.setCount1(request.getParameter("count1")==null?0:	AddUtil.parseDigit(request.getParameter("count1"))); // 
		clsa.setCount2(request.getParameter("count2")==null?0:	AddUtil.parseDigit(request.getParameter("count2"))); // 
		clsa.setM_r_fee_amt(request.getParameter("m_r_fee_amt")==null?0:	AddUtil.parseDigit(request.getParameter("m_r_fee_amt"))); //중도매입옵션시 대여료 반영분
			
		//해지의뢰 추가내역 저장	
		if(!ac_db.insertClsEstAdd(clsa))	flag += 1;
		
		String value0[]  = request.getParameterValues("s_fee_tm");
		String value1[]  = request.getParameterValues("s_r_fee_est_dt");
		String value2[]  = request.getParameterValues("s_fee_s_amt");
		String value3[]  = request.getParameterValues("s_tax_amt");
		String value4[]  = request.getParameterValues("s_is_amt");
		String value5[]  = request.getParameterValues("s_cal_amt");
		String value6[]  = request.getParameterValues("s_r_fee_s_amt");
		String value7[]  = request.getParameterValues("s_r_fee_v_amt");
		String value8[]  = request.getParameterValues("s_r_fee_amt");
		String value9[]  = request.getParameterValues("s_rc_rate");
		String value10[]  = request.getParameterValues("s_cal_days");		
		String value11[]  = request.getParameterValues("s_grt_amt");	
		String value12[]  = request.getParameterValues("s_g_fee_amt");							
		
		for(int i=0 ; i < scd_size ; i++){
			
			int s_fee_tm = value0[i]	==null?0 :AddUtil.parseDigit(value0[i]);   //회차 
			int s_fee_s_amt = value2[i]	==null?0 :AddUtil.parseDigit(value2[i]);  //월대여료 
			int s_tax_amt = value3[i]	==null?0 :AddUtil.parseDigit(value3[i]); //자동차세  
			int s_is_amt = value4[i]	==null?0 :AddUtil.parseDigit(value4[i]); // 보험료 + 정비비용 
			int s_cal_amt = value5[i]	==null?0 :AddUtil.parseDigit(value5[i]);  // 제외요금 
			int s_r_fee_s_amt = value6[i]	==null?0 :AddUtil.parseDigit(value6[i]); //현재가치 공급가 
			int s_r_fee_v_amt = value7[i]	==null?0 :AddUtil.parseDigit(value7[i]); //현재가치 부가세 
			int s_r_fee_amt = value8[i]	==null?0 :AddUtil.parseDigit(value8[i]);   //현재가치 금액 
			float s_rc_rate = value9[i]	==null?0 :AddUtil.parseFloat(value9[i]);   //현재가치율 
			int s_cal_days = value10[i]	==null?0 :AddUtil.parseDigit(value10[i]);	//경과일수 	  	
			int s_grt_amt = value11[i]	==null?0 :AddUtil.parseDigit(value11[i]); //보증금 이자효과  
			int s_g_fee_amt = value12[i]	==null?0 :AddUtil.parseDigit(value12[i]); //보증금 이자반영 대여료   	
				
			if(s_fee_tm > 0){
						
						//중도매입옵션 중도정산서저장
						ClsEtcDetailBean clsd = new ClsEtcDetailBean();
		
						clsd.setRent_mng_id(rent_mng_id);
						clsd.setRent_l_cd(rent_l_cd);
						clsd.setS_fee_tm(s_fee_tm); //회차
						clsd.setS_r_fee_est_dt(value1[i]); //납입할날짜 			
						clsd.setS_fee_s_amt(s_fee_s_amt); //월대여료
						clsd.setS_tax_amt(s_tax_amt);   //자동차세
						clsd.setS_is_amt(s_is_amt);  //보험료 + 정비비용 
						clsd.setS_cal_amt(s_cal_amt); //계산금액
						clsd.setS_r_fee_s_amt(s_r_fee_s_amt);   //현재가치율 반영 공급가 
						clsd.setS_r_fee_v_amt(s_r_fee_v_amt);   //현재가치율 반영 부가세 
						clsd.setS_r_fee_amt(s_r_fee_amt); //현재가치율 합계 
						clsd.setS_rc_rate(s_rc_rate); //현재가치율
						clsd.setS_cal_days(s_cal_days); //경과일수
						
						clsd.setS_grt_amt(s_grt_amt); //보증금 이자효과  
						clsd.setS_g_fee_amt(s_g_fee_amt); //보증금 이자반영 대여료   	
																
						//해지의뢰서브내역 저장	
						if(!ac_db.insertClsEstDetail(clsd))	flag += 1;									
		   }
		}	
	}
	
	
	if(flag == 0){ 	
		
			  //r_over_amt가 있다면 - 산출금액이 있다면	      
	   	if ( AddUtil.parseDigit(request.getParameter("r_over_amt")) !=0 ) {
	        		
	        		//초과운행부담금 
			ClsEtcOverBean cco = new ClsEtcOverBean();        	
		
			cco.setRent_mng_id(rent_mng_id);
		 	cco.setRent_l_cd(rent_l_cd);
			cco.setRent_days(request.getParameter("rent_days")==null?0:	AddUtil.parseDigit(request.getParameter("rent_days"))); //이용일
			cco.setCal_dist(request.getParameter("cal_dist")==null?0:	AddUtil.parseDigit(request.getParameter("cal_dist"))); //약정거리
			cco.setFirst_dist(request.getParameter("first_dist")==null?0:	AddUtil.parseDigit(request.getParameter("first_dist"))); //최초주행거리
			cco.setLast_dist(request.getParameter("last_dist")==null?0:	AddUtil.parseDigit(request.getParameter("last_dist"))); //최종주행거리
			cco.setReal_dist(request.getParameter("real_dist")==null?0:	AddUtil.parseDigit(request.getParameter("real_dist"))); //실운행거리
			cco.setOver_dist(request.getParameter("over_dist")==null?0:	AddUtil.parseDigit(request.getParameter("over_dist"))); //초과운행거리
			cco.setAdd_dist(request.getParameter("add_dist")==null?0:	AddUtil.parseDigit(request.getParameter("add_dist"))); //서비스마일리지
			cco.setJung_dist(request.getParameter("jung_dist")==null?0:	AddUtil.parseDigit(request.getParameter("jung_dist"))); //정산기준운행거리
			cco.setR_over_amt(request.getParameter("r_over_amt")==null?0:	AddUtil.parseDigit(request.getParameter("r_over_amt"))); //산출금액
			cco.setM_over_amt(request.getParameter("m_over_amt")==null?0:	AddUtil.parseDigit(request.getParameter("m_over_amt"))); //감액
			cco.setJ_over_amt(request.getParameter("j_over_amt")==null?0:	AddUtil.parseDigit(request.getParameter("j_over_amt"))); //정산금액		
			cco.setM_saction_id(request.getParameter("m_saction_id")==null?"":	request.getParameter("m_saction_id")); //결재자
			cco.setM_reason(request.getParameter("m_reason")==null?"":request.getParameter("m_reason")); //사유

			boolean cr3_flag = ac_db.insertClsEstOver(cco);	
	   	}
			
	}
		

	//출고전.후 해약 구분
	String car_no = request.getParameter("car_no")==null?"":request.getParameter("car_no");
	
	//권한
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); 
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String b_lst = request.getParameter("b_lst")==null?"":request.getParameter("b_lst");
%>
<form name='form1' action='' target='d_content' method="POST">
<input type='hidden' name='rent_mng_id' value='<%=cls.getRent_mng_id()%>'>
<input type='hidden' name='rent_l_cd' value='<%=cls.getRent_l_cd()%>'>
<input type='hidden' name='cls_st' value='<%=cls.getCls_st()%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='cont_st' value=''>
<input type='hidden' name='user_id' value='<%=user_id%>'>
</form>

<script language='javascript'>
	var fm = document.form1;

<%	if(flag != 0){ 	//해지테이블에 저장 실패%>

	alert('등록 오류발생!');

<%	}else{ 			//해지테이블에 저장 성공.. %>
	
    alert('처리되었습니다');				
	fm.s_kd.value = '5';
    fm.action='/fms2/cls_cont/lc_cls_est_frame.jsp';
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>
