<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*,  acar.receive.*,  acar.credit.*, acar.user_mng.*, acar.coolmsg.*,acar.car_sche.*, acar.car_office.*, acar.car_mst.*, acar.cont.*, acar.client.* "%>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="r_db" scope="page" class="acar.receive.ReceiveDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String guar_st		 	= request.getParameter("guar_st")==null?"":request.getParameter("guar_st"); //보증인유무
	
	String cls_st = request.getParameter("cls_st")==null?"":request.getParameter("cls_st");
	String cls_doc_yn = request.getParameter("cls_doc_yn")==null?"":request.getParameter("cls_doc_yn");
	
	String dft_saction_id =  request.getParameter("dft_saction_id")==null?"":	request.getParameter("dft_saction_id"); //중도해지 위약금 결재
	
//	String sb_saction_id =  request.getParameter("sb_saction_id")==null?"":	request.getParameter("sb_saction_id"); //출고전해지(신차), 개시전해지(재리스) 인 경우 지점장 결재
			
	String car_st = request.getParameter("car_st")==null?"":request.getParameter("car_st"); //업무대여 
	
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id"); //  
	
	String match = request.getParameter("match")==null?"N":request.getParameter("match"); //  
	
	
	//위약금 결재관련     
	int    dft_amt 	= request.getParameter("dft_amt")		==null?0 :AddUtil.parseDigit(request.getParameter("dft_amt"));  //위약금 원래
	int    dft_amt_1 	= request.getParameter("dft_amt_1")		==null?0 :AddUtil.parseDigit(request.getParameter("dft_amt_1"));  //위약금 확정 
	
	int flag = 0;
	int count = 1;	
	
	boolean flag1 = true;
	boolean flag2 = true;
	
	String c_id = "";
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();	
	
	//기존에 등록되어 있는지 여부
	ClsEtcBean cls = new ClsEtcBean();
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
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

//	cls.setDfee_amt_v(request.getParameter("dfee_amt_v")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_amt_v")));   //대여료 부가세 ( 과입금(과부적) + 미납 대여료 ) 
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
	
	cls.setEst_dt(request.getParameter("est_dt")==null?request.getParameter("cls_dt"):	request.getParameter("est_dt"));  						   //입금예정일 ( 없으면 해지일)
	
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
	cls.setB_tot_dist(request.getParameter("b_tot_dist")==null?0:					AddUtil.parseDigit(request.getParameter("b_tot_dist")));   //차량주행거리
	
	//고객환불정보
	cls.setRe_bank(request.getParameter("re_bank")==null?"":request.getParameter("re_bank"));            //은행
	cls.setRe_acc_no(request.getParameter("re_acc_no")==null?"":request.getParameter("re_acc_no"));      //환불계좌번호
	cls.setRe_acc_nm(request.getParameter("re_acc_nm")==null?"":request.getParameter("re_acc_nm"));      //환불 예금주명
	
	//해지정산금 cms인출의뢰
	String cms_chk = request.getParameter("cms_chk")==null?"N":request.getParameter("cms_chk");
	//구분정산인경우는 인출의뢰가능 
	
	//계약해지등록  - 정산구분 : 1-> 합산정산 , 2->구분정산
	String jung_st = request.getParameter("jung_st")==null?"":request.getParameter("jung_st");	
	
	if ( cms_chk.equals("Y") )  {
	    if (!jung_st.equals("2")  &&  AddUtil.parseDigit(request.getParameter("fdft_amt2")) < 1 )   {
		cms_chk = "N";
	    }
	}    
				
	cls.setCms_chk(cms_chk);  //cms인출의뢰
		
//	cls.setSb_saction_id(request.getParameter("sb_saction_id")==null?"":	request.getParameter("sb_saction_id")); //출고전해지(신차), 개시전해지(재리스)인 경우 지점장 결재자
	
	cls.setDft_cost_id(request.getParameter("dft_cost_id")==null?"":	request.getParameter("dft_cost_id")); //영업효율 귀속대상자
	
	cls.setServ_st(request.getParameter("serv_st")==null?"":	request.getParameter("serv_st")); //예비차 사용가능 여부
	cls.setServ_gubun(request.getParameter("serv_gubun")==null?"":	request.getParameter("serv_gubun")); //예비차 적용 
	
	//초과운행거리
	cls.setOver_amt(request.getParameter("over_amt")==null?0:			AddUtil.parseDigit(request.getParameter("over_amt")));  //초과운행 예정금액
	cls.setOver_amt_1(request.getParameter("over_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("over_amt_1"))); //초과운행 확정금액
	cls.setOver_v_amt(request.getParameter("over_v_amt")==null?0:		AddUtil.parseDigit(request.getParameter("over_v_amt"))); //초과운행 예정금액 부가세 - 2022-04 추가 
	cls.setOver_v_amt_1(request.getParameter("over_v_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("over_v_amt_1"))); //초과운행 확정금액 부가세 - 2022-04 추가
	
	cls.setMatch(request.getParameter("match")==null?"N":request.getParameter("match"));      //만기매칭
	//선수금정산
	cls.setExt_saction_id(request.getParameter("ext_saction_id")==null?"":	request.getParameter("ext_saction_id")); //선수금 후불처리 결재
	cls.setExt_reason(request.getParameter("ext_reason")==null?"":	request.getParameter("ext_reason"));       //선수금 후불처리 사유
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
	clsm.setCms_amt(request.getParameter("cms_amt")==null?0:			AddUtil.parseDigit(request.getParameter("cms_amt")));	  //cms 부분인출금액 	
	
	if (  match.equals("Y")) {
		clsm.setMatch_l_cd(request.getParameter("match_l_cd")==null?"":request.getParameter("match_l_cd"));            //만기매칭계약번호 
	}
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
		
		cc.setCrd_req_gu1(request.getParameter("crd_req_gu1")==null?"":		request.getParameter("crd_req_gu1"));  //보증보험청구여부 권리분석
		cc.setCrd_req_gu2(request.getParameter("crd_req_gu2")==null?"":		request.getParameter("crd_req_gu2"));  //연대보증구상여부
		cc.setCrd_req_gu3(request.getParameter("crd_req_gu3")==null?"":		request.getParameter("crd_req_gu3"));  //채권추심외주
		cc.setCrd_req_gu4(request.getParameter("crd_req_gu4")==null?"":		request.getParameter("crd_req_gu4"));  //자동차손해보험
		cc.setCrd_req_gu5(request.getParameter("crd_req_gu5")==null?"":		request.getParameter("crd_req_gu5"));  //면제
		cc.setCrd_req_gu6(request.getParameter("crd_req_gu6")==null?"":		request.getParameter("crd_req_gu6"));  //대손처리
		
		cc.setCrd_pri1(request.getParameter("crd_pri1")==null?"":		request.getParameter("crd_pri1"));  //보증보험청구 우선순위
		cc.setCrd_pri2(request.getParameter("crd_pri2")==null?"":		request.getParameter("crd_pri2"));  //연대보증구상여부
		cc.setCrd_pri3(request.getParameter("crd_pri3")==null?"":		request.getParameter("crd_pri3"));  //채권추심외주
		cc.setCrd_pri4(request.getParameter("crd_pri4")==null?"":		request.getParameter("crd_pri4"));  //자동차손해보험
		cc.setCrd_pri5(request.getParameter("crd_pri5")==null?"":		request.getParameter("crd_pri5"));  //면제
		cc.setCrd_pri6(request.getParameter("crd_pri6")==null?"":		request.getParameter("crd_pri6"));  //대손처리
		
		cc.setGuar_st(guar_st);  //보증인 유무 - 대표포함				
						
		boolean cr1_flag = ac_db.insertCarCredit(cc);
		
		//계약해지등록  - 정산구분 : 1-> 합산정산 , 2->구분정산
		//선수금정산관련
		if (  jung_st.equals("1") ||  jung_st.equals("2")  ) { 
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
							
			cct.setH_st(request.getParameter("h_st")==null?"":			request.getParameter("h_st"));  //선택
			cct.setH_ip_dt(request.getParameter("h_ip_dt")==null?"":		request.getParameter("h_ip_dt"));  //입금(예정)일자
	//		cct.setPay_st(request.getParameter("pay_st")==null?"":			request.getParameter("pay_st"));  //환불인경우 지급형식: 2->현금 . 증빙필요
			
			cct.setSuc_gubun(request.getParameter("suc_gubun")==null?"":		request.getParameter("suc_gubun"));  //승계
			cct.setSuc_l_cd(request.getParameter("suc_l_cd")==null?"":		request.getParameter("suc_l_cd"));  //승계받을 계약번호 
			
			cct.setDelay_st(request.getParameter("delay_st")==null?"":		request.getParameter("delay_st"));  //유보여부 
			cct.setDelay_type(request.getParameter("delay_type")==null?"":		request.getParameter("delay_type"));  //유보종류 
			cct.setDelay_desc(request.getParameter("delay_desc")==null?"":		request.getParameter("delay_desc"));  //유보사유 
			cct.setRefund_st(request.getParameter("refund_st")==null?"":		request.getParameter("refund_st"));  //환불구분 						
			boolean cr5_flag = ac_db.insertClsContEtc(cct);
		}
		
		if ( !car_st.equals("5") )  {
			if(cls_st.equals("1") ||cls_st.equals("2") ){   // 무조건 등록 - 20160202		
			  //r_over_amt가 있다면 - 산출금액이 있다면	      
		    //    	if ( AddUtil.parseDigit(request.getParameter("r_over_amt")) != 0 ) {
					        		
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
							
			//사업장 조사 
			ClsCarExamBean cce = new ClsCarExamBean();
			cce.setRent_mng_id(rent_mng_id);
			cce.setRent_l_cd	(rent_l_cd);
			cce.setS_seq(1); //순번	
			cce.setExam_dt(request.getParameter("exam_dt")==null?"":		request.getParameter("exam_dt"));  //조사일 
			cce.setExam_id(request.getParameter("exam_id")==null?"":		request.getParameter("exam_id"));  //담당자
			cce.setS_gu1(request.getParameter("s_gu1")==null?"":			request.getParameter("s_gu1"));  //
			cce.setS_gu2(request.getParameter("s_gu2")==null?"":			request.getParameter("s_gu2"));  //
			cce.setS_gu3(request.getParameter("s_gu3")==null?"":			request.getParameter("s_gu3"));  //
			cce.setS_gu4(request.getParameter("s_gu4")==null?"":			request.getParameter("s_gu4"));  //		
			cce.setS_remark(request.getParameter("s_remark")==null?"":		request.getParameter("s_remark"));  //
			cce.setS_result(request.getParameter("s_result")==null?"":		request.getParameter("s_result"));  //결과
			
			boolean cr2_flag = r_db.insertClsCarExam(cce);	
		  	  	
		    if ( guar_st.equals("1") ) {  //보증인이 있다면 
				
				//보증인 정보		
				String gu_seq[] 	= request.getParameterValues("gu_seq");
				String gu_nm[] 	= request.getParameterValues("gu_nm");
				String gu_addr[] 	= request.getParameterValues("gu_addr");
				String gu_zip[] 	= request.getParameterValues("gu_zip");
				String gu_tel[] 	= request.getParameterValues("gu_tel");
				String gu_rel[] 	= request.getParameterValues("gu_rel");
		//		String plan_st[] 	= request.getParameterValues("plan_st");
		//		String eff_st[] 	= request.getParameterValues("eff_st");
				String plan_rem[] 	= request.getParameterValues("plan_rem");
				String eff_rem[] 	= request.getParameterValues("eff_rem");
				
				int gu_size = gu_nm.length;
				
				String plan_st_n = "";
				String eff_st_n = "";
							
		//		System.out.println("해지 보증인=" + gu_size + ":" + rent_l_cd);
							
					for(int i = 0 ; i < gu_size ; i++){
					//	System.out.println("gu_nm[i] 1 =" + gu_nm[i] );
						if(!gu_nm[i].equals("") ){
							ClsCarGurBean ccc = new ClsCarGurBean();
								
							ccc.setRent_mng_id(rent_mng_id);
							ccc.setRent_l_cd	(rent_l_cd);
						//	System.out.println("gu_nm[i] 2 =" + rent_l_cd );	
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
																
							boolean cr3_flag = r_db.insertClsCarGur(ccc);	
							
						}
					}	
			  }	
		}	  	
		
	}
	
    if ( !match.equals("Y")) {  //만기매칭이 아니면 
    	
    	if (  dft_amt != dft_amt_1 ) {	
    		System.out.println("쿨메신저(계약해지관리 위약금 감액건 메신저 등록확인용 )"+rent_l_cd);	
    	}
	//중도해지중 위약금면제 관련 메시지 전달	
		if(dft_saction_id.equals("000005") ||  dft_saction_id.equals("000028") ||  dft_saction_id.equals("000026") ){
		
			// ------------------------------------------------------------------------------------------
			
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
								
			String sub 		= "중도해지 위약금 감액관련 결재 처리 요망";
			String cont 	= "[계약번호:"+rent_l_cd+"]  중도해지 위약금 감액관련 결재 요청합니다.";	
			
			String url = 	"/fms2/cls_cont/lc_cls_u.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd+"|dft=Y";
			
			
			String target_id = "";
			if (  dft_saction_id.equals("000026") ) {
					target_id =dft_saction_id;   
			} else{		
				target_id = "000028";  //중도해지 위약금 감액		
				CarScheBean cs_bean2 = csd.getCarScheTodayBean(target_id); 
			   if(!cs_bean2.getWork_id().equals("")) target_id =  cs_bean2.getWork_id();    // cs_bean3.getWork_id();		
			
		//	String target_id =dft_saction_id;     //중도해지 위약금 면제		
			}
		
							
			//사용자 정보 조회
			UsersBean target_bean 	= umd.getUsersBean(target_id);
			
			String xml_data = "";
			xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
		  				"    <BACKIMG>4</BACKIMG>"+
		  				"    <MSGTYPE>104</MSGTYPE>"+
		  				"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
		 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
			
			xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		//	xml_data += "    <TARGET>2006007</TARGET>";	
			
			xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
		  				"    <MSGICON>10</MSGICON>"+
		  				"    <MSGSAVE>1</MSGSAVE>"+
		  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
		  				"  </ALERTMSG>"+
		  				"</COOLMSG>";
			
			CdAlertBean msg = new CdAlertBean();
			msg.setFlddata(xml_data);
			msg.setFldtype("1");		
				
			flag2 = cm_db.insertCoolMsg(msg);
				
			System.out.println("쿨메신저(계약해지관리 위약금 감액 요청 )"+rent_l_cd+"---------------------"+target_bean.getUser_nm());	
		}
    }
    
		
	//차종코드를 관리해 등록된 차종코드는 메세지발송(20190930)
	//전기차 출고전해지 메세지 전송 
	int elec_cnt = 0;
	elec_cnt= ac_db.getElecCnt(rent_l_cd );	
	
//	if(cls_st.equals("7")){	//출고전해지뿐만아니라 모든 해지 메세지 발송.(20191021)
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	CommonEtcBean ce_bean	= c_db.getCommonEtc("set_msg", "jg_code", "사전계약관리메세지수신코드설정", "", "", "", "", "", "");	
	String c_content = ce_bean.getEtc_content();
	String [] c_content_arr = c_content.split(",");
	boolean result =false;
	for(int i=0;i<c_content_arr.length;i++){
		if(cm_bean.getJg_code().equals(c_content_arr[i])){	result = true;	}
	}
	
	if(elec_cnt > 0){		result = true;		}	//전기차, 수소차는 차종코드등록안해도 메세지발송
	
	if(result){
		//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------	
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
		
		String sub 	= "사전예약관리 > 관리대상차량 해지 통보";
		String cont 	= "사전예약관리 > 관리대상차량이 해지 되었습니다. 상호명 : "+client.getFirm_nm()+" 계약번호 : "+rent_l_cd +" , 해지 업무에 참고 바랍니다.";
	
		String target_id = nm_db.getWorkAuthUser("전기차담당");  //보유차 관리자 "000144"; 
					
		//사용자 정보 조회
		UsersBean target_bean 	= umd.getUsersBean(target_id);
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
						"    <BACKIMG>4</BACKIMG>"+
						"    <MSGTYPE>104</MSGTYPE>"+
						"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont+"</CONT>"+
						"    <URL></URL>";
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
		xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
						"    <MSGICON>10</MSGICON>"+
						"    <MSGSAVE>1</MSGSAVE>"+
						"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
						"  </ALERTMSG>"+
						"</COOLMSG>";
		
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
		
		flag2 = cm_db.insertCoolMsg(msg);
	}
	//} 
		
	//혼다/볼보  관련 보상 메세지 S617HAHR00003 S617HACR00021 S517HAHR00004 S517HAHR00005 S119VX6R00002 S218VX6R00002  - 20210115 
	if ( rent_l_cd.equals("S617HAHR00003") || rent_l_cd.equals("S617HACR00021") || rent_l_cd.equals("S517HAHR00004") || rent_l_cd.equals("S517HAHR00005") || rent_l_cd.equals("S119VX6R00002") || rent_l_cd.equals("S218VX6R00002") ) {
	
		//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------	
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
		
		String sub 		= "혼다/볼보 보상 관련 ";
		String cont 	= " 혼다/볼보 보상 관련 . 계약번호 : "+rent_l_cd +" , 해지 업무에 참고 바랍니다.!!!";
	
							
		//사용자 정보 조회
		UsersBean target_bean 	= umd.getUsersBean("000063");
		
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
	  				"<ALERTMSG>"+
  					"    <BACKIMG>4</BACKIMG>"+
  					"    <MSGTYPE>104</MSGTYPE>"+
  					"    <SUB>"+sub+"</SUB>"+
	  				"    <CONT>"+cont+"</CONT>"+
 					"    <URL></URL>";
		xml_data += "    <TARGET>2006007</TARGET>";	
		xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
  					"    <MSGICON>10</MSGICON>"+
  					"    <MSGSAVE>1</MSGSAVE>"+
  					"    <LEAVEDMSG>1</LEAVEDMSG>"+
	  				"    <FLDTYPE>1</FLDTYPE>"+
  					"  </ALERTMSG>"+
  					"</COOLMSG>";
		
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
		
		flag2 = cm_db.insertCoolMsg(msg);
		System.out.println("쿨메신저[혼다/볼보 보상 ] "+rent_l_cd+"-----------------------"+target_bean.getUser_nm());		
	
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
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	
	//주행거리 입력시 오입력체크 프로시저  ghcnf -20190122
	if(cls_st.equals("1") ||cls_st.equals("2") || cls_st.equals("10")  ){   // 무조건 등록 - 20160202		
		String  d_flag3 =  ad_db.call_sp_dist_case_ck(car_mng_id, user_id);
  }

	//전기차 충전기 신청 여부 확인 (20190611)
	CarOffPreDatabase cop_db 	= CarOffPreDatabase.getInstance();
	EcarChargerBean ec_bean	= cop_db.getEcarChargerOne(cls.getRent_l_cd(), cls.getRent_mng_id());
	
	//전기차 충전기 신청 차량이면 담당자, 전기차담당자 에게 메세지	(20190611)
	if(!ec_bean.getRent_l_cd().equals("")){
		String sub4 		= "전기차 충전기 신청내역 안내";
		String cont4 		= "[ "+ec_bean.getRent_l_cd()+" ] 해지처리 되었습니다. 전기차 충전기 신청내역이 있으니 확인하세요.";
		String target_id4 	= nm_db.getWorkAuthUser("전기차담당");						//함윤원 과장님
		String target_id5 	= ec_bean.getReg_id();	//담당자(충전기신청등록자)
								
		//사용자 정보 조회
		UsersBean target_bean4 	= umd.getUsersBean(target_id4);
		UsersBean target_bean5 	= umd.getUsersBean(target_id5);

		String xml_data4 = "";
		xml_data4 =  "<COOLMSG>"+
							 "<ALERTMSG>"+
 								 "    <BACKIMG>4</BACKIMG>"+
							 "    <MSGTYPE>104</MSGTYPE>"+
							 "    <SUB>"+sub4+"</SUB>"+
	  						 "    <CONT>"+cont4+"</CONT>"+
							 "    <URL></URL>";
		xml_data4 += "    <TARGET>"+target_bean4.getId()+"</TARGET>";
		xml_data4 += "    <TARGET>"+target_bean5.getId()+"</TARGET>";
		xml_data4 += "    <SENDER></SENDER>"+
 								 "    <MSGICON>10</MSGICON>"+
							 "    <MSGSAVE>1</MSGSAVE>"+
 								 "    <LEAVEDMSG>1</LEAVEDMSG>"+
							 "    <FLDTYPE>1</FLDTYPE>"+
 								 "  </ALERTMSG>"+
							 "</COOLMSG>";
		CdAlertBean msg4 = new CdAlertBean();
		msg4.setFlddata(xml_data4);
		msg4.setFldtype("1");

		boolean flag7 = cm_db.insertCoolMsg(msg4);
	}
	
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
<input type='hidden' name='andor'	 	value='<%=andor%>'>
</form>

<script language='javascript'>
	var fm = document.form1;

<%	if(flag != 0){ 	//해지테이블에 저장 실패%>

	alert('등록 오류발생!');

<%	}else{ 			//해지테이블에 저장 성공.. %>
	
    alert('처리되었습니다');				
	fm.s_kd.value = '2';
//	fm.t_wd.value = fm.rent_l_cd.value;
   fm.action ='/fms2/cls_cont/lc_cls_u.jsp';
 //  fm.action ='/fms2/cls_cont/lc_cls_d_frame.jsp';
 
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>
