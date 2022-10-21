<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,  acar.user_mng.*, acar.util.*,  acar.credit.*, acar.receive.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="r_db" scope="page" class="acar.receive.ReceiveDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String b_lst = request.getParameter("b_lst")==null?"":request.getParameter("b_lst");
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");

	String job = request.getParameter("job")==null?"3":request.getParameter("job");
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	if ( from_page.equals("") ) from_page = "/fms2/cls_cont/lc_cls_u1.jsp";
	
	int flag = 0;
	boolean flag2 = true;
	
	ClsEtcBean cls = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);	
	String cls_st = cls.getCls_st_r();
				
	/* if (cls_st.equals("8") ) {
		from_page = "/fms2/cls_cont/lc_cls_u1.jsp";
//		from_page = "/fms2/cls_cont/lc_cls_off_d_frame.jsp";
	} else if (cls_st.equals("14") ) {	
		from_page = "/fms2/cls_cont/lc_cls_rm_d_frame.jsp";	
	} else {
		from_page = "/fms2/cls_cont/lc_cls_u1.jsp";
//		from_page = "/fms2/cls_cont/lc_cls_d_frame.jsp";	
	}
	*/
	if (cls_st.equals("14") ) from_page = "/fms2/cls_cont/lc_cls_rm_d_frame.jsp";	
			
	cls.setCls_st	(cls_st);
	cls.setCls_dt	(request.getParameter("cls_dt"));
	cls.setR_mon(request.getParameter("r_mon")==null?"":	request.getParameter("r_mon"));//실이용기간 월
	cls.setR_day(request.getParameter("r_day")==null?"":	request.getParameter("r_day"));//실이용기간 일
	cls.setCls_cau(request.getParameter("cls_cau")==null?"":request.getParameter("cls_cau"));//해지내역
	cls.setUpd_id	(user_id);	
	
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
	cls.setDft_int_1(request.getParameter("dft_int_1")==null?"":	request.getParameter("dft_int_1")); //중도해지 위약율
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
	cls.setRemark(request.getParameter("remark")==null?"":				request.getParameter("remark"));           //확정금액 사유
	
	//추가입금액이 있을 경우 - 정산서 작성시점에
//	cls.setEx_ip_dt(request.getParameter("ex_ip_dt")==null?"":			request.getParameter("ex_ip_dt"));  		 //추가입금일
//	cls.setEx_ip_amt(request.getParameter("ex_ip_amt")==null?0:			AddUtil.parseDigit(request.getParameter("ex_ip_amt")));	  //추가입금액 	
//	cls.setEx_ip_bank(request.getParameter("bank_code2")==null?"":		request.getParameter("bank_code2"));           //입금은행
//	cls.setEx_ip_bank_no(request.getParameter("deposit_no2")==null?"":request.getParameter("deposit_no2"));            //입금구좌
		
	if(cls_st.equals("8")){//매입옵션인경우 
		cls.setOpt_per(request.getParameter("opt_per")==null?"":		request.getParameter("opt_per"));
		cls.setOpt_amt(request.getParameter("opt_amt")==null?0:			AddUtil.parseDigit(request.getParameter("opt_amt")));
	/*	cls.setSui_st(request.getParameter("sui_st")==null?"N":			request.getParameter("sui_st"));
		cls.setSui_d1_amt(request.getParameter("sui_d1_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d1_amt")));
		cls.setSui_d2_amt(request.getParameter("sui_d2_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d2_amt")));
		cls.setSui_d3_amt(request.getParameter("sui_d3_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d3_amt")));
		cls.setSui_d4_amt(request.getParameter("sui_d4_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d4_amt")));
		cls.setSui_d5_amt(request.getParameter("sui_d5_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d5_amt")));
		cls.setSui_d6_amt(request.getParameter("sui_d6_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d6_amt")));
		cls.setSui_d7_amt(request.getParameter("sui_d7_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d7_amt")));
		cls.setSui_d8_amt(request.getParameter("sui_d8_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d8_amt")));
		cls.setSui_d_amt(request.getParameter("sui_d_amt")==null?0:		AddUtil.parseDigit(request.getParameter("sui_d_amt"))); */
		
		//매입옵션 입금 1 - 정산서 작성시점에
		cls.setOpt_ip_dt1(request.getParameter("opt_ip_dt1")==null?"":			request.getParameter("opt_ip_dt1"));  		 //추가입금일
		cls.setOpt_ip_amt1(request.getParameter("opt_ip_amt1")==null?0:			AddUtil.parseDigit(request.getParameter("opt_ip_amt1")));	  //추가입금액 	
		cls.setOpt_ip_bank1(request.getParameter("opt_bank_code1_2")==null?"":		request.getParameter("opt_bank_code1_2"));           //입금은행
		cls.setOpt_ip_bank_no1(request.getParameter("opt_deposit_no1_2")==null?"":request.getParameter("opt_deposit_no1_2"));            //입금구좌
		
		//매입옵션 입금 2 - 정산서 작성시점에
		cls.setOpt_ip_dt2(request.getParameter("opt_ip_dt2")==null?"":			request.getParameter("opt_ip_dt2"));  		 //추가입금일
		cls.setOpt_ip_amt2(request.getParameter("opt_ip_amt2")==null?0:			AddUtil.parseDigit(request.getParameter("opt_ip_amt2")));	  //추가입금액 	
		cls.setOpt_ip_bank2(request.getParameter("opt_bank_code2_2")==null?"":		request.getParameter("opt_bank_code2_2"));           //입금은행
		cls.setOpt_ip_bank_no2(request.getParameter("opt_deposit_no2_2")==null?"":request.getParameter("opt_deposit_no2_2"));            //입금구좌		
		cls.setExt_st(request.getParameter("ext_st")==null?"":request.getParameter("ext_st"));
	
	}
	
	cls.setCar_ja_no_amt(request.getParameter("car_ja_no_amt")==null?0:			AddUtil.parseDigit(request.getParameter("car_ja_no_amt")));   //미입금된 면책금중 계산서 미청구분
	
	cls.setOver_amt(request.getParameter("over_amt")==null?0:			AddUtil.parseDigit(request.getParameter("over_amt")));  //초과운행 예정금액
	cls.setOver_amt_1(request.getParameter("over_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("over_amt_1"))); //초과운행 확정금액	
	
	cls.setMatch(request.getParameter("match")==null?"":request.getParameter("match"));      //만기매칭
					
//	if(!ac_db.updateClsEtc(cls))	flag += 1;
		
   int  ex_ip_amt 		= request.getParameter("ex_ip_amt")	==null? 0:AddUtil.parseDigit(request.getParameter("ex_ip_amt"));	//추가입금액 	
        
    	//추가입금액이 있는 경우 
   	if (ex_ip_amt > 0 ) {
		if(!ac_db.updateClsEtcIp(cls))	flag += 1;			
	}
    				
	//매입옵션인 경우 매입옵션 입금확인 
	if (cls_st.equals("8")) {
		if(!ac_db.updateClsEtcOpt(cls))	flag += 1;			
	}
	

	//계약해지등록  - 정산구분 : 1-> 합산정산 , 2->구분정산 , 3->카드정산 
	String jung_st = request.getParameter("jung_st")==null?"":request.getParameter("jung_st");		
	
	//금액확정여부					
	if(!ac_db.updateClsEtcTerm(rent_mng_id, rent_l_cd, "2", user_id))	flag += 1;	
	
	//해지의뢰내역 추가 항목 - 20180907 cls_etc field가 너무 많아서 cls_etc_more에 추가 			
	ClsEtcMoreBean clsm = ac_db.getClsEtcMore(rent_mng_id, rent_l_cd);		

	clsm.setRent_mng_id(rent_mng_id);
	clsm.setRent_l_cd(rent_l_cd);
		
	clsm.setRe_file_name(request.getParameter("re_file_name")==null?"":			request.getParameter("re_file_name"));  //
	clsm.setEtc4_file_name(request.getParameter("etc4_file_name")==null?"":	request.getParameter("etc4_file_name"));  //
	clsm.setRemark_file_name(request.getParameter("remark_file_name")==null?"":	request.getParameter("remark_file_name"));  //
	//추가입금액이 있을 경우 - 정산서 작성시점에
	clsm.setEx_ip_dt(request.getParameter("ex_ip_dt")==null?"":			request.getParameter("ex_ip_dt"));  		 //추가입금일
	clsm.setEx_ip_amt(ex_ip_amt);	  //추가입금액 	
	clsm.setEx_ip_bank(request.getParameter("bank_code2")==null?"":		request.getParameter("bank_code2"));           //입금은행
	clsm.setEx_ip_bank_no(request.getParameter("deposit_no2")==null?"":request.getParameter("deposit_no2"));            //입금구좌
	clsm.setDes_zip(request.getParameter("des_zip")==null?"":			request.getParameter("des_zip"));    //매입옵션 서류
	clsm.setDes_addr(request.getParameter("des_addr")==null?"":			request.getParameter("des_addr"));
	clsm.setDes_nm(request.getParameter("des_nm")==null?"":			request.getParameter("des_nm"));
	clsm.setDes_tel(request.getParameter("des_tel")==null?"":			request.getParameter("des_tel"));
	clsm.setCms_after(request.getParameter("cms_after")==null?"":	request.getParameter("cms_after"));  //					
	clsm.setM_dae_amt(request.getParameter("m_dae_amt")==null?0:			AddUtil.parseDigit(request.getParameter("m_dae_amt")));	  //대체입금액 	
	clsm.setExt_amt(request.getParameter("ext_amt")==null?0:			AddUtil.parseDigit(request.getParameter("ext_amt")));	  //환불/잡이익 	
	clsm.setStatus("1");	  //status 	
	clsm.setCms_amt(request.getParameter("cms_amt")==null?0:			AddUtil.parseDigit(request.getParameter("cms_amt")));	  //부분인출 	
	
	clsm.setE_serv_rem(request.getParameter("e_serv_rem")==null?"":	request.getParameter("e_serv_rem"));  //					
	clsm.setE_serv_amt(request.getParameter("e_serv_amt")==null?0:			AddUtil.parseDigit(request.getParameter("e_serv_amt")));	  //사전수리비
	
	if(cls_st.equals("8")){//매입옵션인경우 	
		clsm.setSui_st(request.getParameter("sui_st")==null?"N":			request.getParameter("sui_st"));
		clsm.setSui_d1_amt(request.getParameter("sui_d1_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d1_amt")));
		clsm.setSui_d2_amt(request.getParameter("sui_d2_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d2_amt")));
		clsm.setSui_d3_amt(request.getParameter("sui_d3_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d3_amt")));
		clsm.setSui_d4_amt(request.getParameter("sui_d4_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d4_amt")));
		clsm.setSui_d5_amt(request.getParameter("sui_d5_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d5_amt")));
		clsm.setSui_d6_amt(request.getParameter("sui_d6_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d6_amt")));
		clsm.setSui_d7_amt(request.getParameter("sui_d7_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d7_amt")));
		clsm.setSui_d8_amt(request.getParameter("sui_d8_amt")==null?0:	AddUtil.parseDigit(request.getParameter("sui_d8_amt")));
		clsm.setSui_d_amt(request.getParameter("sui_d_amt")==null?0:		AddUtil.parseDigit(request.getParameter("sui_d_amt"))); 
	}
	
	///해지의뢰내역 추가 항목 저장	
	if(!ac_db.updateClsEtcMore(clsm))	flag += 1;	
			
	//해지의뢰상세내역 - 상계금액 지정용 (계산서와는 상관 없음)		
	ClsEtcSubBean clss = ac_db.getClsEtcSubCase(rent_mng_id, rent_l_cd, 1);		

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
	clss.setNo_v_amt_1(request.getParameter("no_v_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("no_v_amt_1")));   //부가세 확정금액
	clss.setFdft_amt1_1(request.getParameter("fdft_amt1_1")==null?0:	AddUtil.parseDigit(request.getParameter("fdft_amt1_1")));//합계 당초금액
	
	clss.setFine_amt_2(request.getParameter("fine_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("fine_amt_2"))); //과태료 상계금액
	clss.setCar_ja_amt_2(request.getParameter("car_ja_amt_2")==null?0:	AddUtil.parseDigit(request.getParameter("car_ja_amt_2"))); //면책금 상계금액
	clss.setDly_amt_2(request.getParameter("dly_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("dly_amt_2")));   //연체료 상계금액
	clss.setEtc_amt_2(request.getParameter("etc_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("etc_amt_2")));  //차량회수외주비 상계금액
	clss.setEtc2_amt_2(request.getParameter("etc2_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("etc2_amt_2"))); //차량회수부대비 상계금액
	clss.setDft_amt_2(request.getParameter("dft_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("dft_amt_2")));   //중도해지위약금 상계금액
	clss.setDfee_amt_2(request.getParameter("dfee_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_amt_2")));   //미납대여료 상계금액
	clss.setEtc3_amt_2(request.getParameter("etc3_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("etc3_amt_2"))); //잔존차량가격 상계금액
	clss.setEtc4_amt_2(request.getParameter("etc4_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("etc4_amt_2"))); //기타손해배상금 상계금액
	clss.setNo_v_amt_2(request.getParameter("no_v_amt_2")==null?0:		AddUtil.parseDigit(request.getParameter("no_v_amt_2")));   //부가세 상계금액
	clss.setFdft_amt1_2(request.getParameter("fdft_amt1_2")==null?0:	AddUtil.parseDigit(request.getParameter("fdft_amt1_2")));//합계 상계금액
	
	clss.setRifee_amt_2_v(request.getParameter("rifee_amt_2_v")==null?0:	AddUtil.parseDigit(request.getParameter("rifee_amt_2_v")));   //미납대여료 상계금액 vat
	clss.setRfee_amt_2_v(request.getParameter("rfee_amt_2_v")==null?0:		AddUtil.parseDigit(request.getParameter("rfee_amt_2_v")));   //미납대여료 상계금액 vat
	clss.setDfee_amt_2_v(request.getParameter("dfee_amt_2_v")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_amt_2_v")));   //미납대여료 상계금액 vat
	clss.setDft_amt_2_v(request.getParameter("dft_amt_2_v")==null?0:		AddUtil.parseDigit(request.getParameter("dft_amt_2_v")));   //위약금 상계금액 vat
	clss.setEtc_amt_2_v(request.getParameter("etc_amt_2_v")==null?0:		AddUtil.parseDigit(request.getParameter("etc_amt_2_v")));   //외주비용 상계금액 vat
	clss.setEtc2_amt_2_v(request.getParameter("etc2_amt_2_v")==null?0:		AddUtil.parseDigit(request.getParameter("etc2_amt_2_v")));   //부대비용 상계금액 vat
	clss.setEtc4_amt_2_v(request.getParameter("etc4_amt_2_v")==null?0:		AddUtil.parseDigit(request.getParameter("etc4_amt_2_v")));   //손해배상금 상계금액 vat
	
	clss.setUpd_id(user_id);		
	
	clss.setOver_amt_1(request.getParameter("over_amt_1")==null?0:	AddUtil.parseDigit(request.getParameter("over_amt_1")));//초과운행 확정금액
	clss.setOver_amt_2(request.getParameter("over_amt_2")==null?0:	AddUtil.parseDigit(request.getParameter("over_amt_2")));//초과운행상계금액
	clss.setOver_amt_2_v(request.getParameter("over_amt_2_v")==null?0:		AddUtil.parseDigit(request.getParameter("over_amt_2_v")));   //초과운행 상계금액 vat
	
	//해지의뢰서브내역 저장	
	if(!ac_db.updateClsEtcSub(clss))	flag += 1;
							
		//차량회수		
	CarRecoBean cr = ac_db.getCarReco(rent_mng_id, rent_l_cd);		
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
	cr.setUpd_id(user_id);		
	cr.setPark(request.getParameter("park")==null?"":				request.getParameter("park"));  //주차장	
	cr.setPark_cont(request.getParameter("park_cont")==null?"":		request.getParameter("park_cont"));  //주차 특이사항
//	boolean cr_flag = ac_db.updateCarReco(cr);
	
	
	//채권관계, 잔존채권의 처리의견/지시사항
	CarCreditBean cc = ac_db.getCarCredit(rent_mng_id, rent_l_cd);		
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
	cc.setUpd_id(user_id);	
	cc.setCrd_req_gu1(request.getParameter("crd_req_gu1")==null?"":		request.getParameter("crd_req_gu1"));  //보증보험청구여부
	cc.setCrd_req_gu2(request.getParameter("crd_req_gu2")==null?"":		request.getParameter("crd_req_gu2"));  //연대보증구상여부
	cc.setCrd_req_gu3(request.getParameter("crd_req_gu3")==null?"":		request.getParameter("crd_req_gu3"));  //채권추심외주
	cc.setCrd_req_gu4(request.getParameter("crd_req_gu4")==null?"":		request.getParameter("crd_req_gu4"));  //자동차손해보험
	cc.setCrd_req_gu5(request.getParameter("crd_req_gu5")==null?"":		request.getParameter("crd_req_gu5"));  //면제
	cc.setCrd_req_gu6(request.getParameter("crd_req_gu6")==null?"":		request.getParameter("crd_req_gu6"));  //대손처리
	cc.setCrd_pri1(request.getParameter("crd_pri1")==null?"":		request.getParameter("crd_pri1"));  //보증보험청구 의견 우선순위
	cc.setCrd_pri2(request.getParameter("crd_pri2")==null?"":		request.getParameter("crd_pri2"));  //연대보증인구상 의견
	cc.setCrd_pri3(request.getParameter("crd_pri3")==null?"":		request.getParameter("crd_pri3"));  //채권추심외주 의견
	cc.setCrd_pri4(request.getParameter("crd_pri4")==null?"":		request.getParameter("crd_pri4"));  //자동차손해보험 의견
	cc.setCrd_pri5(request.getParameter("crd_pri5")==null?"":		request.getParameter("crd_pri5"));  //면제 의견
	cc.setCrd_pri6(request.getParameter("crd_pri6")==null?"":		request.getParameter("crd_pri6"));  //대손처리 의견
	boolean cr1_flag = ac_db.updateCarCredit(cc);
	
	if (  jung_st.equals("1") ||  jung_st.equals("2")    ) { 	
		//선수금정산관련
		ClsContEtcBean cct = ac_db.getClsContEtc(rent_mng_id, rent_l_cd);		
		cct.setRent_mng_id(rent_mng_id);
		cct.setRent_l_cd	(rent_l_cd);
		cct.setJung_st(request.getParameter("jung_st")==null?"":			request.getParameter("jung_st"));  //정산구분
		cct.setH1_amt(request.getParameter("h1_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h1_amt"))); //선납금액
		cct.setH2_amt(request.getParameter("h2_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h2_amt"))); //미납입금액
		cct.setH3_amt(request.getParameter("h3_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h3_amt"))); //정산금액(합산정산시)
		cct.setH4_amt(request.getParameter("h4_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h4_amt"))); //환불
		cct.setH5_amt(request.getParameter("h5_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h5_amt"))); //환불정산금액 (카드인경우 취소금액)
		cct.setH6_amt(request.getParameter("h6_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h6_amt"))); //청구
		cct.setH7_amt(request.getParameter("h7_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h7_amt"))); //청구정산금액 (카드인경우 정산후 재승인금액)
						
		cct.setH_st(request.getParameter("h_st")==null?"":			request.getParameter("h_st"));  //선택
		cct.setH_ip_dt(request.getParameter("h_ip_dt")==null?"":		request.getParameter("h_ip_dt"));  //입금일자
		cct.setPay_st(request.getParameter("pay_st")==null?"":			request.getParameter("pay_st"));  //환불인경우 지급형식: 2->현금 . 증빙필요
		
		cct.setSuc_gubun(request.getParameter("suc_gubun")==null?"":		request.getParameter("suc_gubun"));  //승계
		cct.setSuc_l_cd(request.getParameter("suc_l_cd")==null?"":		request.getParameter("suc_l_cd"));  //승계받을 계약번호 
			
		cct.setDelay_st(request.getParameter("delay_st")==null?"":		request.getParameter("delay_st"));  //유보여부 
		cct.setDelay_type(request.getParameter("delay_type")==null?"":		request.getParameter("delay_type"));  //유보종류 
		cct.setDelay_desc(request.getParameter("delay_desc")==null?"":		request.getParameter("delay_desc"));  //유보사유 
		cct.setRefund_st(request.getParameter("refund_st")==null?"":		request.getParameter("refund_st"));  //환불구분 						
	
		if(!ac_db.updateClsContEtc(cct))	flag += 1;
	}
	
	if (cls_st.equals("14") ) {
	   //카드재결재가 결재중이 변경되는 경우
	   	if (  jung_st.equals("1") ||  jung_st.equals("2")  ) { 	
	   	  		if(!ac_db.deleteInfo(rent_mng_id, rent_l_cd, "cls_cont_etc"))	flag += 1; //선수금정산	   	    
	   	}	   
				//jung_st 가 3인 경우 : 카드정산, 원승인금액 취소, 카드 재출금의뢰로 처리 
		if (   jung_st.equals("3")   ) { 
		
		   int cce_cnt =  ac_db.getCntClsContEtc	(rent_mng_id, rent_l_cd);		
		   
		   if ( cce_cnt  < 1) {
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
			} else {	
		   	   
				//선수금정산관련
				ClsContEtcBean cct = ac_db.getClsContEtc(rent_mng_id, rent_l_cd);		
				cct.setRent_mng_id(rent_mng_id);
				cct.setRent_l_cd	(rent_l_cd);
				cct.setJung_st(request.getParameter("jung_st")==null?"":			request.getParameter("jung_st"));  //정산구분
				cct.setH1_amt(request.getParameter("h1_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h1_amt"))); //선납금액
				cct.setH2_amt(request.getParameter("h2_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h2_amt"))); //미납입금액
				cct.setH3_amt(request.getParameter("h3_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h3_amt"))); //정산금액(합산정산시)
				cct.setH4_amt(request.getParameter("h4_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h4_amt"))); //환불
				cct.setH5_amt(request.getParameter("h5_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h5_amt"))); //환불정산금액 (카드인경우 취소금액)
				cct.setH6_amt(request.getParameter("h6_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h6_amt"))); //청구
				cct.setH7_amt(request.getParameter("h7_amt")==null?0:			AddUtil.parseDigit(request.getParameter("h7_amt"))); //청구정산금액 (카드인경우 정산후 재승인금액)							
				
				cct.setR_date(request.getParameter("r_date")==null?"":		request.getParameter("r_date"));  //카드 취소관련 - 취소할 카드 승인일					
				
				if(!ac_db.updateClsContEtc(cct))	flag += 1;
			}
		}	
	}
			
		//사업장의 계속		
	ClsCarExamBean cce = r_db.getClsCarExam(rent_mng_id, rent_l_cd, 1);		
	cce.setRent_mng_id(rent_mng_id);
	cce.setRent_l_cd	(rent_l_cd);
	cce.setExam_dt(request.getParameter("exam_dt")==null?"":		request.getParameter("exam_dt")); 
	cce.setExam_id(request.getParameter("exam_id")==null?"":		request.getParameter("exam_id")); 
	cce.setS_gu1(request.getParameter("s_gu1")==null?"":			request.getParameter("s_gu1")); 
	cce.setS_gu2(request.getParameter("s_gu2")==null?"":			request.getParameter("s_gu2")); 
	cce.setS_gu3(request.getParameter("s_gu3")==null?"":			request.getParameter("s_gu3")); 
	cce.setS_gu4(request.getParameter("s_gu4")==null?"":			request.getParameter("s_gu4")); 
	cce.setS_remark(request.getParameter("s_remark")==null?"":	request.getParameter("s_remark"));  //
	cce.setS_result(request.getParameter("s_result")==null?"":	request.getParameter("s_result"));  //
		
	boolean cr2_flag =r_db.updateClsCarExam(cce);
		
	
	//채권 - 보증인
	Vector gurs = r_db.getClsCarGurList(rent_mng_id, rent_l_cd);
	int gur_size = gurs.size();
		
	//보증인 정보		
	String gu_seq[] 	= request.getParameterValues("gu_seq");
	String gu_nm[] 	= request.getParameterValues("gu_nm");
	String gu_addr[] 	= request.getParameterValues("gu_addr");
	String gu_zip[] 	= request.getParameterValues("gu_zip");
	String gu_tel[] 	= request.getParameterValues("gu_tel");
	String gu_rel[] 	= request.getParameterValues("gu_rel");
	String plan_st[] 	= request.getParameterValues("plan_st");
	String eff_st[] 	= request.getParameterValues("eff_st");
	String plan_rem[] 	= request.getParameterValues("plan_rem");
	String eff_rem[] 	= request.getParameterValues("eff_rem");
			
	int gu_size = 0;
	
	if ( gur_size < 1) {			
		gu_size =gur_size;
	} else {
		gu_size = gu_nm.length;
	}
	
//	System.out.println("해지 보증인 수정=" + gu_size + ":" + rent_l_cd);
	
	String plan_st_n = "";
	String eff_st_n = "";
			
	for(int i = 0 ; i < gu_size ; i++){
		
		if(!gu_nm[i].equals("") ){
			ClsCarGurBean ccc = r_db.getClsCarGurList(rent_mng_id, rent_l_cd, gu_nm[i]);
													
		//	ccc.setRent_mng_id(rent_mng_id);
		//	ccc.setRent_l_cd	(rent_l_cd);
			ccc.setGu_seq(AddUtil.parseInt(gu_seq[i]) ); //순번
			ccc.setGu_nm(gu_nm[i]);
			ccc.setGu_addr(gu_addr[i] ==null?"":gu_addr[i]);
			ccc.setGu_zip(gu_zip[i] ==null?"":gu_zip[i]);
			ccc.setGu_tel(gu_tel[i] ==null?"":gu_tel[i]);
			ccc.setGu_rel(gu_rel[i] ==null?"":gu_rel[i]);	
							
			plan_st_n= request.getParameter("plan_st" + i)==null?"":request.getParameter("plan_st" + i);  
			eff_st_n= request.getParameter("eff_st" + i)==null?"":request.getParameter("eff_st" + i);  
			ccc.setPlan_st	(plan_st_n);
			ccc.setEff_st	(eff_st_n);						
			ccc.setPlan_rem(plan_rem[i] ==null?"":plan_rem[i]);
			ccc.setEff_rem(eff_rem[i] ==null?"":eff_rem[i]);					
					
			//=====[CAR_MGR] update=====
			flag2 = r_db.updateClsCarGur(ccc);
					
		}
	}			
			
	//해지의뢰 세금계산서관련 
	//세금계산서 발행의뢰건 등록 : 의뢰했더라도 실제세금계산서가 발행안될 수 있음 :장기연체인 경우 (수금시 세금계산서 발행처리)
	ClsEtcTaxBean ct = ac_db.getClsEtcTax(rent_mng_id, rent_l_cd, 1);
	ct.setRent_mng_id(rent_mng_id);
	ct.setRent_l_cd	(rent_l_cd);		
	ct.setSeq_no	(1);
	ct.setTax_r_chk0(request.getParameter("tax_r_chk0")==null?"N":request.getParameter("tax_r_chk0"));  //잔여개시대여료
	ct.setTax_r_chk1(request.getParameter("tax_r_chk1")==null?"N":request.getParameter("tax_r_chk1"));  //잔여선납금
	ct.setTax_r_chk2(request.getParameter("tax_r_chk2")==null?"N":request.getParameter("tax_r_chk2"));  //취소대여료
	ct.setTax_r_chk3(request.getParameter("tax_r_chk3")==null?"N":request.getParameter("tax_r_chk3"));  //해지대여료
	ct.setTax_r_chk4(request.getParameter("tax_r_chk4")==null?"N":request.getParameter("tax_r_chk4"));  //해지위약금
	ct.setTax_r_chk5(request.getParameter("tax_r_chk5")==null?"N":request.getParameter("tax_r_chk5"));  //회수외주비용
	ct.setTax_r_chk6(request.getParameter("tax_r_chk6")==null?"N":request.getParameter("tax_r_chk6"));  //회수부대비용
	ct.setTax_r_chk7(request.getParameter("tax_r_chk7")==null?"N":request.getParameter("tax_r_chk7"));  //손해배상금
	ct.setTax_r_chk8(request.getParameter("tax_r_chk8")==null?"N":request.getParameter("tax_r_chk8"));  //초과운행부담금
		
	String tax_r_supply[] = request.getParameterValues("tax_r_supply"); // 발행예정분
    String tax_r_value[] = request.getParameterValues("tax_r_value");
 
 	String tax_rr_supply[] = request.getParameterValues("tax_rr_supply"); // 발행분
    String tax_rr_value[] = request.getParameterValues("tax_rr_value");
    
    String tax_rr_hap[] = request.getParameterValues("tax_rr_hap");  //실제발행분
    
	String tax_r_g[] = request.getParameterValues("tax_r_g");
	String tax_r_bigo[] = request.getParameterValues("tax_r_bigo");	
	
	String tax_reg_gu = request.getParameter("tax_reg_gu")==null?"":	request.getParameter("tax_reg_gu");
	 	
	int tax_size = tax_r_g.length;
	for(int i = 0; i<tax_size; i++){
    	    
    	    String tax_chk = request.getParameter("tax_r_chk"+i)==null?"N":	request.getParameter("tax_r_chk"+i);
    	    if(tax_chk.equals("Y")){
    	        		
	    		if (i == 0) {
	    			ct.setRifee_s_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //잔여개시대여료 예정
	       	 		ct.setRifee_s_amt_v(AddUtil.parseDigit(tax_r_value[i]));
	       	 		ct.setR_rifee_s_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));  //잔여개시대여료 발행
	       	 		ct.setR_rifee_s_amt_v(AddUtil.parseDigit(tax_rr_value[i]));
	       	 		ct.setRifee_etc(tax_r_g[i]);  //실제 발행할 품목
	   	 		} else if ( i == 1 ){
	       	 		ct.setRfee_s_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //잔여선납금 예정
	       	 		ct.setRfee_s_amt_v(AddUtil.parseDigit(tax_r_value[i]));
	       	 		ct.setR_rfee_s_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));  //잔여선납금 발행
	       	 		ct.setR_rfee_s_amt_v(AddUtil.parseDigit(tax_rr_value[i]));
	       	 		ct.setRfee_etc(tax_r_g[i]);  //실제 발행할 품목
	       	 	} else if ( i == 2 ){
	       	 		ct.setDfee_c_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //취소대여료 예정
	       	 		ct.setDfee_c_amt_v(AddUtil.parseDigit(tax_r_value[i]));
	       	 		ct.setR_dfee_c_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));  //취소대여료 발행
	       	 		ct.setR_dfee_c_amt_v(AddUtil.parseDigit(tax_rr_value[i]));
	       	 		ct.setDfee_c_etc(tax_r_g[i]);  //실제 발행할 품목	
	       	 	} else if ( i == 3 ){
	       	 		ct.setDfee_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //미납대여료 예정
	       	 		ct.setDfee_amt_v(AddUtil.parseDigit(tax_r_value[i]));
	       	 		ct.setR_dfee_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));  //미납대여료 발행
	       	 		ct.setR_dfee_amt_v(AddUtil.parseDigit(tax_rr_value[i]));
	       	 		ct.setDfee_etc(tax_r_g[i]);  //실제 발행할 품목
	       	 	} else if ( i == 4 ){
	       	 		ct.setDft_amt_s(AddUtil.parseDigit(tax_r_supply[i]));   //중도해지위약금 예정
	       	 		ct.setDft_amt_v(AddUtil.parseDigit(tax_r_value[i]));       
	       	 		ct.setR_dft_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));   //중도해지위약금 발행
	       	 		ct.setR_dft_amt_v(AddUtil.parseDigit(tax_rr_value[i])); 
	       	 		ct.setDft_etc(tax_r_g[i]);  //실제 발행할 품목    		
	       	 	} else if ( i == 5 ){
	       	 		ct.setEtc_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //외주비용 예정
	       	 		ct.setEtc_amt_v(AddUtil.parseDigit(tax_r_value[i])); 
	       	 		ct.setR_etc_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));  //외주비용 발행
	       	 		ct.setR_etc_amt_v(AddUtil.parseDigit(tax_rr_value[i])); 
	       	 		ct.setEtc_etc(tax_r_g[i]);  //실제 발행할 품목
	       	 	} else if ( i == 6 ){
	       	 		ct.setEtc2_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //부대비용 예정
	       	 		ct.setEtc2_amt_v(AddUtil.parseDigit(tax_r_value[i]));     
	       	 		ct.setR_etc2_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));  //부대비용 발행
	       	 		ct.setR_etc2_amt_v(AddUtil.parseDigit(tax_rr_value[i]));     
	       	 		ct.setEtc2_etc(tax_r_g[i]);  //실제 발행할 품목      	
	       	 	} else if ( i == 7 ){
	       	 		ct.setEtc4_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //손해배상금 예정
	       	 		ct.setEtc4_amt_v(AddUtil.parseDigit(tax_r_value[i]));   
	       	 		ct.setR_etc4_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));  //손해배상금 발행
	       	 		ct.setR_etc4_amt_v(AddUtil.parseDigit(tax_rr_value[i]));  
	       	 		ct.setEtc4_etc(tax_r_g[i]);  //실제 발행할 품목
	       	 	} else if ( i == 8 ){
	       	 		ct.setOver_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //초과운행부담금 예정
	       	 		ct.setOver_amt_v(AddUtil.parseDigit(tax_r_value[i]));   
	       	 		ct.setR_over_amt_s(AddUtil.parseDigit(tax_rr_supply[i]));  //초과운행부담금 발행
	       	 		ct.setR_over_amt_v(AddUtil.parseDigit(tax_rr_value[i]));  
	       	 		ct.setOver_etc(tax_r_g[i]);  //실제 발행할 품목	
	       	 	}	
	       	 	
	       	 } else {
	       	 
	       		 if (i == 0) {
	    			ct.setRifee_s_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //잔여개시대여료 예정
	       	 		ct.setRifee_s_amt_v(AddUtil.parseDigit(tax_r_value[i]));
	       	 		ct.setR_rifee_s_amt_s(0);  //잔여개시대여료 발행
	       	 		ct.setR_rifee_s_amt_v(0);
	       	 		ct.setRifee_etc(tax_r_g[i]);  //실제 발행할 품목
	   	 		} else if ( i == 1 ){
	       	 		ct.setRfee_s_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //잔여선납금 예정
	       	 		ct.setRfee_s_amt_v(AddUtil.parseDigit(tax_r_value[i]));
	       	 		ct.setR_rfee_s_amt_s(0);  //잔여선납금 발행
	       	 		ct.setR_rfee_s_amt_v(0);
	       	 		ct.setRfee_etc(tax_r_g[i]);  //실제 발행할 품목
	       	 	} else if ( i == 2 ){
	       	 		ct.setDfee_c_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //취소대여료 예정
	       	 		ct.setDfee_c_amt_v(AddUtil.parseDigit(tax_r_value[i]));
	       	 		ct.setR_dfee_c_amt_s(0);  //취소대여료 발행
	       	 		ct.setR_dfee_c_amt_v(0);
	       	 		ct.setDfee_c_etc(tax_r_g[i]);  //실제 발행할 품목	
	       	 	} else if ( i == 3 ){
	       	 		ct.setDfee_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //미납대여료 예정
	       	 		ct.setDfee_amt_v(AddUtil.parseDigit(tax_r_value[i]));
	       	 		ct.setR_dfee_amt_s(0);  //미납대여료 발행
	       	 		ct.setR_dfee_amt_v(0);
	       	 		ct.setDfee_etc(tax_r_g[i]);  //실제 발행할 품목
	       	 	} else if ( i == 4 ){
	       	 		ct.setDft_amt_s(AddUtil.parseDigit(tax_r_supply[i]));   //중도해지위약금 예정
	       	 		ct.setDft_amt_v(AddUtil.parseDigit(tax_r_value[i]));       
	       	 		ct.setR_dft_amt_s(0);   //중도해지위약금 발행
	       	 		ct.setR_dft_amt_v(0);   
	       	 		ct.setDft_etc(tax_r_g[i]);  //실제 발행할 품목    		
	       	 	} else if ( i == 5 ){
	       	 		ct.setEtc_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //외주비용 예정
	       	 		ct.setEtc_amt_v(AddUtil.parseDigit(tax_r_value[i])); 
	       	 		ct.setR_etc_amt_s(0);  //외주비용 발행
	       	 		ct.setR_etc_amt_v(0); 
	       	 		ct.setEtc_etc(tax_r_g[i]);  //실제 발행할 품목
	       	 	} else if ( i == 6 ){
	       	 		ct.setEtc2_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //부대비용 예정
	       	 		ct.setEtc2_amt_v(AddUtil.parseDigit(tax_r_value[i]));     
	       	 		ct.setR_etc2_amt_s(0);  //부대비용 발행
	       	 		ct.setR_etc2_amt_v(0); 
	       	 		ct.setEtc2_etc(tax_r_g[i]);  //실제 발행할 품목      	
	       	 	} else if ( i == 7 ){
	       	 		ct.setEtc4_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //손해배상금 예정
	       	 		ct.setEtc4_amt_v(AddUtil.parseDigit(tax_r_value[i]));   
	       	 		ct.setR_etc4_amt_s(0);  //손해배상금 발행
	       	 		ct.setR_etc4_amt_v(0);   	       	 	     
	       	 		ct.setEtc4_etc(tax_r_g[i]);  //실제 발행할 품목
	       	 	} else if ( i ==8 ){
	       	 		ct.setOver_amt_s(AddUtil.parseDigit(tax_r_supply[i]));  //초과운행부담 예정
	       	 		ct.setOver_amt_v(AddUtil.parseDigit(tax_r_value[i]));   
	       	 		ct.setR_over_amt_s(0);  //초과운행부담금 발행
	       	 		ct.setR_over_amt_v(0);   	       	 	     
	       	 		ct.setOver_etc(tax_r_g[i]);  //실제 발행할 품목	
	       	 	}	
	       	 	       	 
	       	 }			
  			
	}				
	
	if(!ac_db.updateClsEtcTax(ct))	flag += 1;	
	
	//세금계산서통합발행여부					
	if(!ac_db.updateClsEtcTaxGu(rent_mng_id, rent_l_cd, tax_reg_gu ))	flag += 1;
				
%>
<form name='form1' action='' target='d_content' method="POST">
<input type='hidden' name='rent_mng_id' value='<%=cls.getRent_mng_id()%>'>
<input type='hidden' name='rent_l_cd' value='<%=cls.getRent_l_cd()%>'>
<input type='hidden' name='cls_st' value='<%=cls_st%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='bit' value='확정'>
<input type='hidden' name='cont_st' value=''>
</form>

<script language='javascript'>
	var fm = document.form1;
	
<%	if(flag != 0){ 	//해지테이블에 수정 실패%>

	alert('등록 오류발생!');

<%	}else{ 			//해지테이블에 수정 성공.. %>
	
    alert('처리되었습니다');				
	
//	fm.t_wd.value = fm.rent_l_cd.value;
    fm.action ='<%=from_page%>';
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>

