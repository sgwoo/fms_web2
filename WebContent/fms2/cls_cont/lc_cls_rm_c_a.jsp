<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*,  acar.credit.*, acar.user_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String cls_st = request.getParameter("cls_st")==null?"14":request.getParameter("cls_st");
	String cls_doc_yn = request.getParameter("cls_doc_yn")==null?"":request.getParameter("cls_doc_yn");
	
	String dft_saction_id =  request.getParameter("dft_saction_id")==null?"":	request.getParameter("dft_saction_id"); //중도해지 위약금 결재
	
	String sb_saction_id =  request.getParameter("sb_saction_id")==null?"":	request.getParameter("sb_saction_id"); //출고전해지(신차), 개시전해지(재리스) 인 경우 지점장 결재
			
	int flag = 0;
	int count = 1;	
	
	boolean flag1 = true;
	boolean flag2 = true;
	
	String c_id = "";
	
	
	//기존에 등록되어 있는지 여부	
			
	ClsEtcBean cls = new ClsEtcBean();
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	
	cls.setRent_mng_id(rent_mng_id);
	cls.setRent_l_cd(rent_l_cd);
	cls.setTerm_yn("0");  //의뢰등록
	cls.setCls_st("14"); //월렌트
	//cls.setCls_st(cls_st);
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
	cls.setRifee_v_amt(request.getParameter("rifee_v_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rifee_v_amt")));  //개시대여료부가세  -2022-04-20 추가 
	cls.setPp_s_amt(request.getParameter("pp_s_amt")==null?0:		AddUtil.parseDigit(request.getParameter("pp_s_amt")));
	cls.setPded_s_amt(request.getParameter("pded_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("pded_s_amt")));
	cls.setTpded_s_amt(request.getParameter("tpded_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("tpded_s_amt")));
	cls.setRfee_s_amt(request.getParameter("rfee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rfee_s_amt")));
	cls.setRfee_v_amt(request.getParameter("rfee_v_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rfee_v_amt")));  //선납금부가세  -2022-04-20 추가 
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
	cls.setDfee_v_amt(request.getParameter("dfee_v_amt")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_v_amt")));   //과부족+미납대여료 당초금액 부가세 - 2022-04 추가 		
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
	cls.setDfee_v_amt_1(request.getParameter("dfee_v_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_v_amt_1")));   //과부족+미납대여료 확정금액 - 2022-04 추가 			
	cls.setCls_s_amt(request.getParameter("cls_s_amt")==null?0:			AddUtil.parseDigit(request.getParameter("cls_s_amt")));   //해지정산금 공급가
	cls.setCls_v_amt(request.getParameter("cls_v_amt")==null?0:			AddUtil.parseDigit(request.getParameter("cls_v_amt")));   //해지정산금 부가세
	
	cls.setD_saction_id(request.getParameter("d_saction_id")==null?"":	request.getParameter("d_saction_id")); //확정금액 결재자
	cls.setD_reason(request.getParameter("d_reason")==null?"":	request.getParameter("d_reason"));             //확정금액 사유
	cls.setDly_saction_id(request.getParameter("dly_saction_id")==null?"":	request.getParameter("dly_saction_id")); //연체료감액 결재자
	cls.setDly_reason(request.getParameter("dly_reason")==null?"":	request.getParameter("dly_reason"));       //연체료감액 사유
	cls.setDft_saction_id(request.getParameter("dft_saction_id")==null?"":	request.getParameter("dft_saction_id")); //중도해지위약금감액 결재자
	cls.setDft_reason(request.getParameter("dft_reason")==null?"":	request.getParameter("dft_reason"));       //중도해지위약금감액 사유
	
	cls.setDiv_st(request.getParameter("div_st")==null?"":				request.getParameter("div_st")); 						   //구분 1:완납, 2:분납  
	cls.setDiv_cnt(request.getParameter("div_cnt")==null?1:				AddUtil.parseDigit(request.getParameter("div_cnt")));     //분납횟수  
	cls.setEst_dt(request.getParameter("est_dt")==null?"":				request.getParameter("est_dt"));  						   //입금예정일
	cls.setEst_amt(request.getParameter("est_amt")==null?0:				AddUtil.parseDigit(request.getParameter("est_amt")));	   //채권약정금액 
	cls.setEst_nm(request.getParameter("est_nm")==null?"":				request.getParameter("est_nm"));  				   //입금약정자
	cls.setGur_nm(request.getParameter("gur_nm")==null?"":				request.getParameter("gur_nm")); 				   //대위변제자
	cls.setGur_rel_tel(request.getParameter("gur_rel_tel")==null?"":	request.getParameter("gur_rel_tel"));      //확정금액 사유
	cls.setGur_rel(request.getParameter("gur_rel")==null?"":			request.getParameter("gur_rel")); 		   //확정금액 결재자
	cls.setRemark(request.getParameter("remark")==null?"":				request.getParameter("remark"));           //처리의견
			
	//세금계산서 발행의뢰건 등록 : 의뢰했더라도 실제세금계산서가 발행안될 수 있음 :장기연체인 경우 (수금시 세금계산서 발행처리)
	cls.setTax_chk0(request.getParameter("tax_chk0")==null?"N":request.getParameter("tax_chk0"));  //중도해지위약금
	cls.setTax_chk1(request.getParameter("tax_chk1")==null?"N":request.getParameter("tax_chk1"));  //차량외주비용
	cls.setTax_chk2(request.getParameter("tax_chk2")==null?"N":request.getParameter("tax_chk2"));  //차량부대비용
	cls.setTax_chk3(request.getParameter("tax_chk3")==null?"N":request.getParameter("tax_chk3"));  //기타손해배상금
	cls.setTax_chk4(request.getParameter("tax_chk4")==null?"N":request.getParameter("tax_chk4"));  //초과운행부담금 
	
	cls.setTax_reg_gu(request.getParameter("tax_reg_gu")==null?"N":request.getParameter("tax_reg_gu"));  //계산서 발행 형태
		
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
	
	//고객환불정보
	cls.setRe_bank(request.getParameter("re_bank")==null?"":request.getParameter("re_bank"));            //은행
	cls.setRe_acc_no(request.getParameter("re_acc_no")==null?"":request.getParameter("re_acc_no"));      //환불계좌번호
	cls.setRe_acc_nm(request.getParameter("re_acc_nm")==null?"":request.getParameter("re_acc_nm"));      //환불 예금주명
	
	//해지정산금 cms인출의뢰
	String cms_chk = request.getParameter("cms_chk")==null?"N":request.getParameter("cms_chk");
	
	// 어차피 마이너스는 출금의뢰 안됨.- 20171130
//	if ( cms_chk.equals("Y") &&  AddUtil.parseDigit(request.getParameter("fdft_amt2")) < 1 ) {
//			cms_chk = "N";
//	}

	if ( cms_chk.equals("Y") &&  AddUtil.parseDigit(request.getParameter("fdft_amt2")) == 0  ) {
			cms_chk = "N";
	}
	
	cls.setCms_chk(cms_chk);  //cms인출의뢰
		
	cls.setSb_saction_id(request.getParameter("sb_saction_id")==null?"":	request.getParameter("sb_saction_id")); //출고전해지(신차), 개시전해지(재리스)인 경우 지점장 결재자
	
	cls.setDft_cost_id(request.getParameter("dft_cost_id")==null?"":	request.getParameter("dft_cost_id")); //영업효율 귀속대상자
	
	cls.setServ_st(request.getParameter("serv_st")==null?"":	request.getParameter("serv_st")); //예비차 사용가능 여부
	cls.setServ_gubun(request.getParameter("serv_gubun")==null?"":	request.getParameter("serv_gubun")); //예비차 적용 
	
	//초과운행거리
	cls.setOver_amt(request.getParameter("over_amt")==null?0:			AddUtil.parseDigit(request.getParameter("over_amt")));  //초과운행 예정금액
	cls.setOver_amt_1(request.getParameter("over_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("over_amt_1"))); //초과운행 확정금액
	cls.setOver_v_amt(request.getParameter("over_v_amt")==null?0:		AddUtil.parseDigit(request.getParameter("over_v_amt"))); //초과운행 예정금액 부가세 - 2022-04 추가 
	cls.setOver_v_amt_1(request.getParameter("over_v_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("over_v_amt_1"))); //초과운행 확정금액 부가세 - 2022-04 추가
	
	cls.setInput_id(ck_acar_id); //입력자 						
	if(!ac_db.insertClsEtc(cls))	flag += 1;
	
	
		//해지의뢰내역 추가 항목 - 20180907 cls_etc field가 너무 많아서 cls_etc_more에 추가 	
	ClsEtcMoreBean clsm = new ClsEtcMoreBean();	
	clsm.setRent_mng_id(rent_mng_id);
	clsm.setRent_l_cd(rent_l_cd);
			//추가입금액이 있을 경우 - 정산서 작성시점에
	clsm.setEx_ip_dt(request.getParameter("ex_ip_dt")==null?"":			request.getParameter("ex_ip_dt"));  		 //추가입금일
	clsm.setEx_ip_amt(request.getParameter("ex_ip_amt")==null?0:			AddUtil.parseDigit(request.getParameter("ex_ip_amt")));	  //추가입금액 	
	clsm.setEx_ip_bank(request.getParameter("bank_code2")==null?"":		request.getParameter("bank_code2"));           //입금은행
	clsm.setEx_ip_bank_no(request.getParameter("deposit_no2")==null?"":request.getParameter("deposit_no2"));            //입금구좌
	
	clsm.setCms_after(request.getParameter("cms_after")==null?"":request.getParameter("cms_after"));            //자동이체 익일처리 	

	if(!ac_db.insertClsEtcMore(clsm))	flag += 1;
	
	
	//해지의뢰내역 저장
	ClsEtcSubBean clss = new ClsEtcSubBean();
	clss.setRent_mng_id(rent_mng_id);
	clss.setRent_l_cd(rent_l_cd);
	clss.setFine_amt_1(request.getParameter("fine_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("fine_amt_1"))); //과태료 확정금액
	clss.setCar_ja_amt_1(request.getParameter("car_ja_amt_1")==null?0:	AddUtil.parseDigit(request.getParameter("car_ja_amt_1"))); //면책금 확정금액
	clss.setDly_amt_1(request.getParameter("dly_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dly_amt_1")));   //연체료 확정금액
	clss.setEtc_amt_1(request.getParameter("etc_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc_amt_1")));  //차량회수외주비 확정금액
	clss.setEtc2_amt_1(request.getParameter("etc2_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc2_amt_1"))); //차량회수부대비 확정금액
	clss.setDft_amt_1(request.getParameter("dft_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dft_amt_1")));   //중도해지위약금 확정금액
	clss.setDfee_amt_1(request.getParameter("dfee_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_amt_1")));   //중도해지위약금 확정금액
	clss.setEtc3_amt_1(request.getParameter("etc3_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc3_amt_1"))); //잔존차량가격 확정금액
	clss.setEtc4_amt_1(request.getParameter("etc4_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc4_amt_1"))); //기타손해배상금 확정금액
	clss.setOver_amt_1(request.getParameter("over_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("over_amt_1"))); //초과운행 확정금액
	
	clss.setNo_v_amt_1(request.getParameter("no_v_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("no_v_amt_1")));   //부가세 확정금액
	clss.setFdft_amt1_1(request.getParameter("fdft_amt1_1")==null?0:	AddUtil.parseDigit(request.getParameter("fdft_amt1_1")));//합계 당초금액
	clss.setReg_id(reg_id);
	
	//해지의뢰서브내역 저장	
	if(!ac_db.insertClsEtcSub(clss))	flag += 1;
		
	//해지의뢰세금계산서내역 저장
	ClsEtcTaxBean ct = new ClsEtcTaxBean();
	ct.setRent_mng_id(rent_mng_id);
	ct.setRent_l_cd(rent_l_cd);
	ct.setSeq_no(1);
	ct.setReg_id(reg_id);
	
	//해지의뢰서브내역 저장	
	if(!ac_db.insertClsEtcTax(ct))	flag += 1;
		
		
	//계약해지등록  - 정산구분 : 1-> 합산정산 , 2->구분정산 , 3->카드정산 
	String jung_st = request.getParameter("jung_st")==null?"":request.getParameter("jung_st");	
	
	//카드정산인경우 처리할것 
	 System.out.println("해지 카드 정산 =" + jung_st + " : " + rent_l_cd  );
	//jung_st 가 3인 경우 : 카드정산, 원승인금액 취소, 카드 재출금의뢰로 처리 
	if (   jung_st.equals("3")   ) { 
	   
	 	  	ClsContEtcBean cct = new ClsContEtcBean();
			cct.setRent_mng_id(rent_mng_id);
			cct.setRent_l_cd	(rent_l_cd);
			cct.setJung_st(request.getParameter("jung_st")==null?"":			request.getParameter("jung_st"));  //정산구분
			cct.setH1_amt(request.getParameter("h1_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h1_amt"))); //선납금액
			cct.setH2_amt(request.getParameter("h2_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h2_amt"))); //미납입금액
			cct.setH3_amt(request.getParameter("h3_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h3_amt"))); //정산금액(합산정산시)
			cct.setH4_amt(request.getParameter("h4_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h4_amt"))); //환불
			cct.setH5_amt(request.getParameter("h5_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h5_amt"))); //환불정산금액
			cct.setH6_amt(request.getParameter("h6_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h6_amt"))); //청구
			cct.setH7_amt(request.getParameter("h7_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h7_amt"))); //청구정산금액						
			
			cct.setR_date(request.getParameter("r_date")==null?"":		request.getParameter("r_date"));  //카드 취소관련 - 취소할 카드 승인일							
		
			if(!ac_db.insertClsContEtc(cct))	flag += 1;
	
	}
	
		
	if(flag == 0){ 	
						
			//차량회수		
		CarRecoBean cr = new CarRecoBean();
		cr.setRent_mng_id(rent_mng_id);
		cr.setRent_l_cd	(rent_l_cd);
		cr.setReco_st(request.getParameter("reco_st")==null?"":			request.getParameter("reco_st"));  //차량회수여부
		cr.setReco_d1_st(request.getParameter("reco_d1_st")==null?"":	request.getParameter("reco_d1_st"));  //차량회수구분
		cr.setReco_d2_st(request.getParameter("reco_d2_st")==null?"":	request.getParameter("reco_d2_st"));  //차량미회수구분
		cr.setReco_cau(request.getParameter("reco_cau")==null?"":		request.getParameter("reco_cau"));  //사유
		cr.setReco_dt(request.getParameter("reco_dt")==null?"":			request.getParameter("reco_dt"));  //회수일
		cr.setReco_id(request.getParameter("reco_id")==null?"":			request.getParameter("reco_id")); //회수담당자
		cr.setIp_dt(request.getParameter("ip_dt")==null?"":				request.getParameter("ip_dt"));  //입고일	
		cr.setEtc2_d1_amt(request.getParameter("etc2_d1_amt")==null?0:	AddUtil.parseDigit(request.getParameter("etc2_d1_amt"))); //부대비용
		cr.setEtc_d1_amt(request.getParameter("etc_d1_amt")==null?0:	AddUtil.parseDigit(request.getParameter("etc_d1_amt")));  //외주비용
		cr.setReg_id(reg_id);	
		cr.setPark(request.getParameter("park")==null?"":				request.getParameter("park"));  //주차장	
		cr.setPark_cont(request.getParameter("park_cont")==null?"":		request.getParameter("park_cont"));  //주차 특이사항

		boolean cr_flag = ac_db.insertCarReco(cr);	
		
		//채권관계, 잔존채권의 처리의견/지시사항
		CarCreditBean cc = new CarCreditBean();
		cc.setRent_mng_id(rent_mng_id);
		cc.setRent_l_cd	(rent_l_cd);
		cc.setGi_amt(request.getParameter("gi_amt")==null?0:				AddUtil.parseDigit(request.getParameter("gi_amt"))); //보증보험금액
		cc.setGi_c_amt(request.getParameter("gi_c_amt")==null?0:			AddUtil.parseDigit(request.getParameter("gi_c_amt"))); //청구금액
		cc.setGi_j_amt(request.getParameter("gi_j_amt")==null?0:			AddUtil.parseDigit(request.getParameter("gi_j_amt"))); //잔존채권금액
		cc.setC_ins(request.getParameter("c_ins")==null?"":					request.getParameter("c_ins"));  //손해보험사 
		cc.setC_ins_d_nm(request.getParameter("c_ins_d_nm")==null?"":		request.getParameter("c_ins_d_nm"));  //담당자
		cc.setC_ins_tel(request.getParameter("c_ins_tel")==null?"":			request.getParameter("c_ins_tel"));  //전화번호
		cc.setCrd_reg_gu1(request.getParameter("crd_reg_gu1")==null?"":		request.getParameter("crd_reg_gu1"));  //보증보험청구여부
		cc.setCrd_reg_gu2(request.getParameter("crd_reg_gu2")==null?"":		request.getParameter("crd_reg_gu2"));  //연대보증구상여부
		cc.setCrd_reg_gu3(request.getParameter("crd_reg_gu3")==null?"":		request.getParameter("crd_reg_gu3"));  //채권추심외주
		cc.setCrd_reg_gu4(request.getParameter("crd_reg_gu4")==null?"":		request.getParameter("crd_reg_gu4"));  //자동차손해보험
		cc.setCrd_reg_gu5(request.getParameter("crd_reg_gu5")==null?"":		request.getParameter("crd_reg_gu5"));  //면제
		cc.setCrd_reg_gu6(request.getParameter("crd_reg_gu6")==null?"":		request.getParameter("crd_reg_gu6"));  //대손처리
		cc.setCrd_remark1(request.getParameter("crd_remark1")==null?"":		request.getParameter("crd_remark1"));  //보증보험청구 의견
		cc.setCrd_remark2(request.getParameter("crd_remark2")==null?"":		request.getParameter("crd_remark2"));  //연대보증인구상 의견
		cc.setCrd_remark3(request.getParameter("crd_remark3")==null?"":		request.getParameter("crd_remark3"));  //채권추심외주 의견
		cc.setCrd_remark4(request.getParameter("crd_remark4")==null?"":		request.getParameter("crd_remark4"));  //자동차손해보험 의견
		cc.setCrd_remark5(request.getParameter("crd_remark5")==null?"":		request.getParameter("crd_remark5"));  //면제 의견
		cc.setCrd_remark6(request.getParameter("crd_remark6")==null?"":		request.getParameter("crd_remark6"));  //대손처리 의견
		cc.setCrd_id(request.getParameter("crd_id")==null?"":				request.getParameter("crd_id"));  // 결재자
		cc.setCrd_reason(request.getParameter("crd_reason")==null?"":		request.getParameter("crd_reason"));  //사유
		cc.setReg_id(reg_id);
		boolean cr1_flag = ac_db.insertCarCredit(cc);
		
				  //r_over_amt가 있다면 - 산출금액이 있다면	      
	    	if ( AddUtil.parseDigit(request.getParameter("r_over_amt")) > 0 ) {
	        		
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

			boolean cr3_flag = ac_db.insertClsEtcOver(cco);	
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
	fm.s_kd.value = '2';
//	fm.t_wd.value = fm.rent_l_cd.value;
    fm.action='/fms2/cls_cont/lc_cls_rm_d_frame.jsp';
 
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>
