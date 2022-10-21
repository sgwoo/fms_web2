<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.credit.*, acar.doc_settle.*, acar.cont.*, acar.user_mng.*, acar.cls.*, acar.coolmsg.*,  acar.estimate_mng.*"%>
<%@ page import="acar.insur.*, acar.car_sche.*, acar.res_search.*, acar.common.*, acar.memo.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String cls_doc_yn = request.getParameter("cls_doc_yn")==null?"Y":request.getParameter("cls_doc_yn");
	String car_no 	= request.getParameter("car_no")==null?"":request.getParameter("car_no");
		
	boolean flag1 = true;
	boolean flag2 = true;
	 	
	int	flag = 0;	
	int	count = 0;	
		
	String from_page 	=  "/fms2/cls_cont/lc_cls_rm_d_frame.jsp";	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();	
	CommonDataBase c_db = CommonDataBase.getInstance();		
	EstiDatabase e_db = EstiDatabase.getInstance();
			
	ClsBean cls = new ClsBean();
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	String cls_dt = request.getParameter("cls_dt")==null?"":request.getParameter("cls_dt");
	//해지의뢰정보
	ClsEtcBean clsEtc = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);
	String cls_st = clsEtc.getCls_st_r();
			
	String car_mng_id = "";
	
	String bus_id2 = "";
	
	String mng_id = "";
	
	//계약기본정보
	ContBaseBean base = a_db.getContBase(rent_mng_id, rent_l_cd);
	car_mng_id = base.getCar_mng_id();
	
//	bus_id2 = base.getBus_id2();	
	bus_id2 = base.getMng_id2(); 	
		
	 //문서처리전 등록
	String sub = "";
	String cont = "";
	
	//	System.out.println(" doc_sanction doc_bit = " + doc_bit + ": doc_no = :" + doc_no + ": rent_l_cd = " + rent_l_cd);
	
	//doc_settle에 저장	
	//2. 문서처리전 등록-------------------------------------------------------------------------------------------
	sub 		= "월렌트해지 회계처리의뢰";
	cont 	= "[계약번호:"+rent_l_cd+"] 월렌트 회계처리 의뢰 합니다.";			
	
	DocSettleBean doc = new DocSettleBean();
	doc.setDoc_st("11");//해지정산의뢰 (중도해지, 계약만료, 매입옵션, 출고전해지(신차))
	doc.setDoc_id(rent_l_cd);
	doc.setSub(sub);
	doc.setCont(cont);
	doc.setEtc("");
	doc.setUser_nm1("기안자");
	doc.setUser_nm2("고객지원팀장");
	doc.setUser_nm3("회계담당자"); //채권업무도 같이 처리 -  월렌트인경우는 결재없이 회계처리함.
	doc.setUser_nm4("채권담당자");  //사용 - 20091201
	doc.setUser_nm5("총무팀장");
	
	doc.setUser_id1(reg_id);
	
	String user_id2 = "XXXXXX";
	String user_id3 = "XXXXXX";
	String user_id4 ="XXXXXX";
	String user_id5 = "XXXXXX";
		
	doc.setDoc_bit("1");//기안
	doc.setDoc_step("1");//기안		

	doc.setUser_id2(user_id2);//팀장/지점장
	doc.setUser_id3(user_id3);//회계관리자
	doc.setUser_id4(user_id4);//채권관리자
	doc.setUser_id5(user_id5);//총무팀장
				 				
	//=====[doc_settle] insert=====
	flag1 = d_db.insertDocSettle(doc);		
	doc = d_db.getDocSettleCommi("11", rent_l_cd);
	doc_no = doc.getDoc_no();
	flag1 = d_db.updateDocSettleCls(doc_no, "XXXXXX", "3",  "2"); //계산서
	flag1 = d_db.updateDocSettleCls(doc_no, "XXXXXX", "5",  "3");//팀장
	
		//선수금 입금일
	String opt_ip_dt1 = request.getParameter("opt_ip_dt1")==null?"":request.getParameter("opt_ip_dt1");
	String opt_ip_dt2 = request.getParameter("opt_ip_dt2")==null?"":request.getParameter("opt_ip_dt2");
	
	String real_date = "";
	String r_add_date = "";  //해지부터 1달 후 -> 해지부터 1주일 후 -> 3일 후
		
	real_date = cls_dt;
	r_add_date =  c_db.addDay(real_date, 3);  
		
			
	cls.setRent_mng_id(rent_mng_id);
	cls.setRent_l_cd(rent_l_cd);
	cls.setTerm_yn("Y");  //해지등록
	cls.setCls_st(cls_st);
	cls.setCls_dt(real_date);
	cls.setR_mon(request.getParameter("r_mon")==null?"":	request.getParameter("r_mon"));//실이용기간 월
	cls.setR_day(request.getParameter("r_day")==null?"":	request.getParameter("r_day"));//실이용기간 일
	cls.setCls_cau(request.getParameter("cls_cau")==null?"":request.getParameter("cls_cau"));//해지내역
	
	cls.setCls_doc_yn("Y");
	cls.setReg_id(reg_id); //담당자id
	
	 
	//중도해지, 매입옵션, 만기해지 해지의뢰 등록
	cls.setCancel_yn(request.getParameter("cancel_yn")==null?"":request.getParameter("cancel_yn"));
	cls.setGrt_amt(request.getParameter("grt_amt")==null?0:			AddUtil.parseDigit(request.getParameter("grt_amt")));
	cls.setIfee_s_amt(request.getParameter("ifee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("ifee_s_amt")));
	cls.setIfee_mon(request.getParameter("ifee_mon")==null?"":		request.getParameter("ifee_mon"));
	cls.setIfee_day(request.getParameter("ifee_day")==null?"":		request.getParameter("ifee_day"));
	cls.setIfee_ex_amt(request.getParameter("ifee_ex_amt")==null?0:	AddUtil.parseDigit(request.getParameter("ifee_ex_amt")));
	cls.setRifee_s_amt(request.getParameter("rifee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rifee_s_amt")));
	cls.setRifee_v_amt(request.getParameter("rifee_v_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rifee_v_amt")));
	cls.setPp_s_amt(request.getParameter("pp_s_amt")==null?0:		AddUtil.parseDigit(request.getParameter("pp_s_amt")));
	cls.setPded_s_amt(request.getParameter("pded_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("pded_s_amt")));
	cls.setTpded_s_amt(request.getParameter("tpded_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("tpded_s_amt")));
	cls.setRfee_s_amt(request.getParameter("rfee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rfee_s_amt")));
	cls.setRfee_v_amt(request.getParameter("rfee_v_amt")==null?0:	AddUtil.parseDigit(request.getParameter("rfee_v_amt")));
	cls.setNfee_s_amt(request.getParameter("nfee_s_amt")==null?0:	AddUtil.parseDigit(request.getParameter("nfee_s_amt")));
	cls.setNfee_mon(request.getParameter("nfee_mon")==null?"":		request.getParameter("nfee_mon"));
	cls.setNfee_day(request.getParameter("nfee_day")==null?"":		request.getParameter("nfee_day"));
	cls.setNfee_amt(request.getParameter("nfee_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("nfee_amt_1"))); //미납대여료 당초금액
	cls.setEx_di_amt(request.getParameter("ex_di_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("ex_di_amt_1"))); //과부족 대여료 금액 (선납 또는 잔액)
	cls.setTfee_amt(request.getParameter("tfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("tfee_amt"))); //대여료 총액
	cls.setMfee_amt(request.getParameter("mfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("mfee_amt"))); //월평균대여료
	cls.setRcon_mon(request.getParameter("rcon_mon")==null?"":		request.getParameter("rcon_mon"));  //잔여기간
	cls.setRcon_day(request.getParameter("rcon_day")==null?"":		request.getParameter("rcon_day"));   //잔여기간
	cls.setTrfee_amt(request.getParameter("trfee_amt")==null?0:		AddUtil.parseDigit(request.getParameter("trfee_amt"))); //잔여기간총대여료
	cls.setDft_int(request.getParameter("dft_int_1")==null?"":		request.getParameter("dft_int_1")); //중도해지 위약율
	cls.setDft_amt(request.getParameter("dft_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dft_amt_1")));   //중도해지위약금 당초금액
	cls.setCar_ja_amt(request.getParameter("car_ja_amt_1")==null?0:	AddUtil.parseDigit(request.getParameter("car_ja_amt_1"))); //면책금 당초금액
	cls.setDly_amt(request.getParameter("dly_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dly_amt_1")));   //연체료 당초금액
	cls.setEtc_amt(request.getParameter("etc_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc_amt_1")));  //차량회수외주비 당초금액
	cls.setEtc2_amt(request.getParameter("etc2_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc2_amt_1"))); //차량회수부대비 당초금액
	cls.setEtc3_amt(request.getParameter("etc3_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc3_amt_1"))); //잔존차량가격 당초금액
	cls.setEtc4_amt(request.getParameter("etc4_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc4_amt_1"))); //기타손해배상금 당초금액

	cls.setFine_amt(request.getParameter("fine_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("fine_amt_1"))); //과태료 당초금액
	cls.setNo_v_amt(request.getParameter("no_v_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("no_v_amt_1")));   //부가세 당초금액
	cls.setFdft_amt1(request.getParameter("fdft_amt1_1")==null?0:		AddUtil.parseDigit(request.getParameter("fdft_amt1_1")));//합계 당초금액
	cls.setFdft_amt2(request.getParameter("fdft_amt2")==null?0:		AddUtil.parseDigit(request.getParameter("fdft_amt2")));//고객납입금액
			
	cls.setCls_s_amt(request.getParameter("cls_s_amt")==null?0:			AddUtil.parseDigit(request.getParameter("cls_s_amt")));   //해지정산금 공급가
	cls.setCls_v_amt(request.getParameter("cls_v_amt")==null?0:			AddUtil.parseDigit(request.getParameter("cls_v_amt")));   //해지정산금 부가세
	cls.setCls_est_dt(request.getParameter("est_dt")==null?"":	request.getParameter("est_dt"));

	if(cls.getCls_est_dt().equals(""))	cls.setCls_est_dt(real_date);			

		
	//추가입금액이 있을 경우 - 정산서 작성시점에
	cls.setEx_ip_dt(request.getParameter("ex_ip_dt")==null?"":			request.getParameter("ex_ip_dt"));  		 //추가입금일
	cls.setEx_ip_amt(request.getParameter("ex_ip_amt")==null?0:			AddUtil.parseDigit(request.getParameter("ex_ip_amt")));	  //추가입금액 	
	cls.setEx_ip_bank(request.getParameter("bank_code2")==null?"":		request.getParameter("bank_code2"));           //입금은행
	cls.setEx_ip_bank_no(request.getParameter("deposit_no2")==null?"":request.getParameter("deposit_no2"));            //입금구좌
	cls.setTot_dist(request.getParameter("tot_dist")==null?0:AddUtil.parseDigit(request.getParameter("tot_dist")));   //차량주행거리
	
	cls.setCms_chk(request.getParameter("cms_chk")==null?"N":request.getParameter("cms_chk"));  //cms인출의뢰
	
	cls.setOver_amt(request.getParameter("over_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("over_amt_1"))); //초과운행 확정금액	
	cls.setOver_v_amt(request.getParameter("over_v_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("over_v_amt_1"))); //초과운행 확정금액 vat
	
	cls.setDfee_s_amt(request.getParameter("dfee_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_amt_1"))); //대여료 확정금액	
	cls.setDfee_v_amt(request.getParameter("dfee_v_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dfee_v_amt_1"))); //대여료 확정금액 vat
			
	//계약해지등록 
	if(!as_db.insertCls2(cls))	flag += 1;
//	System.out.println(" 계약해지 flag 1=" + flag);
		
		 
	 //자기차량손해면책금을 해지정산금에 포함처리 - 20100624 추가
	 if ( AddUtil.parseDigit(request.getParameter("car_ja_amt_1") ) > 0 ) {
	 			   		
	   		Vector vt3 = ac_db.getServiceDetailCls(rent_mng_id, rent_l_cd);  //미납된 면책금
			int vt3_size = vt3.size();			
			
			String serv_id = "";
			String ext_tm = "";
			int  car_ja_amt = 0;
			String bill_doc_yn = "";
				
			for(int i = 0 ; i < vt3_size ; i++){
				Hashtable ht3 = (Hashtable)vt3.elementAt(i);
							
				serv_id	 	 = 	 String.valueOf(ht3.get("EXT_ID")); //정비id
				ext_tm	 	 = 	 String.valueOf(ht3.get("EXT_TM")); //연번
				car_ja_amt 	 = 	 Util.parseDigit(String.valueOf(ht3.get("CAR_JA_AMT")));  //면책금액
				bill_doc_yn	 	 = 	 String.valueOf(ht3.get("BILL_DOC_YN")); // 1:계산서 발행 , 0:미발행
				
				if (!ac_db.updateServiceDetailCls2(rent_mng_id, rent_l_cd, serv_id, car_ja_amt, ext_tm, real_date, user_id, bill_doc_yn ) )	flag += 1;	//미납된 면책금 입금 처리
//				System.out.println("면책금 해지정산금 포함  flag 3_1=" + flag);
			}  //end for	
	 }
	 	 			
				 
	  //연체료  감면처리
	 if ( AddUtil.parseDigit(request.getParameter("dly_amt")) > 0 ){
	 		int dly_amt_0 = AddUtil.parseDigit(request.getParameter("dly_amt"));
	 		int dly_amt_1 = AddUtil.parseDigit(request.getParameter("dly_amt_1"));
	 		if ( (dly_amt_0 - dly_amt_1) > 0 ) { 
	 			int j_dly = dly_amt_0 - dly_amt_1;
		 		if(!ac_db.insertScdDlyCls(rent_mng_id, rent_l_cd, j_dly , real_date, user_id, "1"))	flag += 1;	//미납된 면책금 입금 처리	 
//		 		System.out.println("연체료 감면 flag 4=" + flag);		 		
	 		} 
	 }	
	 			 
		 	 
	 //대여료 대손 - 해지시점에 정산금에 포함
	 if(!ac_db.updateScdFeeCls(rent_mng_id, rent_l_cd, real_date, user_id))	flag += 1;	//미납된 대여료 대손처리	
//	 System.out.println(" 대여료 대손 flag 5=" + flag); 	
	
	  		
	//남아있는 데이타는 정리 및 해지정산관련 스케쥴 생성
	 String dl_amt = "";
		 
	//차량회수된 상태라면 -- 차량회수 정보 수정  - 차량회수 및 반납(계약해지를 위해서)
	if(!ac_db.updateCarCallIn(rent_mng_id, rent_l_cd, real_date)) flag += 1;	
//	System.out.println(" 차량회수(반납) 처리 flag 6_1=" + flag);
		 
	if(!as_db.closeCont(rent_mng_id, rent_l_cd, cls_st, "", dl_amt, car_no, real_date))	flag += 1;	
//	System.out.println(" 해지 처리 flag 6=" + flag);
	
		//예비차 관리담당자 배정 문자 - 중도해지, 계약만료, 재리스개시전해지인 경우 - loan_st = '2'인 경우에 한해서, 월렌트해지인경우도 포함
	if ( cls_st.equals("14") ) {
	
	 	UsersBean bus_id2_bean 	= umd.getUsersBean(bus_id2);	 	
	 	if ( !bus_id2_bean.getLoan_st().equals("1") ) {
		// 	if(!ac_db.sendMemo(cls_dt, car_no))	flag += 1;	
	 	//	System.out.println(" 예비차 관리담당자 배정처리 flag 6_2=" + flag);	 
	 	}	 	 
		
	 	int count2 = 0;
	 	
	 	String park = request.getParameter("park")==null?"":request.getParameter("park"); //차량현위치
		String park_cont = request.getParameter("park_cont")==null?"":request.getParameter("park_cont"); //주차 기타			
		count = rs_db.updateCarPark(car_mng_id, park, park_cont);			
		
		if(park.equals("1") || park.equals("3") || park.equals("7") || park.equals("8")|| park.equals("4") || park.equals("9")  || park.equals("11")  ){//입출고 데이터 삭제
			Hashtable ht6 = pk_db.getRentParkIOSearch2(car_mng_id);
			count2 = pk_db.UpdateParkIO(String.valueOf(ht6.get("CAR_MNG_ID")));	
		}	
		
		//보유차 월대여료 계산
		ac_db.call_sp_esti_reg_sh_res (real_date, car_mng_id);	
				
		//  재리스//월렌트 견적 - 영업용
		if ( base.getCar_st().equals("1") ||   base.getCar_st().equals("4")  ) {
			e_db.call_sp_esti_reg_sh(car_mng_id);
		}
					
		//실위치와 틀린 관리지점인 경우 관리지점  수정 - 2012-10-09 - 기타인경우는예외처리
		String n_mng_br_id = "";
		String n_user_id = "000026";	
		if(park.equals("1") || park.equals("5") || park.equals("2") || park.equals("10") || park.equals("15") || park.equals("16")  || park.equals("14" ){	
			n_mng_br_id = "S1";		
			n_user_id = "000026";	
		//부산지점 park_in ('3', '7', '8' )	
		}else if(park.equals("3") || park.equals("7") || park.equals("8")){	
			n_mng_br_id = "B1";	
			n_user_id = "000053";	
		//대전지점 park_in ('4', '9', '11') 
		}else if(park.equals("4") || park.equals("9") ||  park.equals("11") ){	
			n_mng_br_id = "D1";	
			n_user_id = "000052";	
		}else if(park.equals("12")  ){	
			n_mng_br_id = "J1";	 // 광주
			n_user_id = "000052";		
		}else if(park.equals("13")  ){	
			n_mng_br_id = "G1";	
			n_user_id = "000054";
		}
			
		Hashtable cont1 = a_db.getContViewUseYCarCase(car_mng_id);
		//계약기타정보
		ContEtcBean cont_etc = a_db.getContEtc(String.valueOf(cont1.get("RENT_MNG_ID")), String.valueOf(cont1.get("RENT_L_CD")));
		
	//	if(!n_mng_br_id.equals("") && cont_etc.getRent_mng_id().equals("")){
		
	//		cont_etc.setMng_br_id		(n_mng_br_id);
		
			//=====[cont_etc] update=====
	//		cont_etc.setRent_mng_id	(String.valueOf(cont1.get("RENT_MNG_ID")));
	//		cont_etc.setRent_l_cd	(String.valueOf(cont1.get("RENT_L_CD")));
	//		boolean flag21 = a_db.insertContEtc(cont_etc);
	//	}else{
		
			String o_mng_br_id = cont_etc.getMng_br_id();
			
			if(!n_mng_br_id.equals("") && !o_mng_br_id.equals(n_mng_br_id)){
				
				
				//관리지점 변경이력등록 & 관리지점 변경 적용
				LcRentCngHBean bean = new LcRentCngHBean();	
				bean.setRent_mng_id	(String.valueOf(cont1.get("RENT_MNG_ID")));
				bean.setRent_l_cd	(String.valueOf(cont1.get("RENT_L_CD")));
				bean.setCng_item	("mng_br_id");
				bean.setOld_value	(o_mng_br_id);
				bean.setNew_value	(n_mng_br_id);
				bean.setCng_cau		("보유차 현위치 변경");
				bean.setCng_id		(ck_acar_id);
				bean.setRent_st		(String.valueOf(cont1.get("FEE_RENT_ST")));
				bean.setS_amt		(0);
				bean.setV_amt		(0);	
				boolean flag23 = a_db.updateLcRentCngH(bean);
				
				String cont_memo 		= "[보유차 현위치 변경] "+car_no+" 의 현위치가 변경되었습니다. 관리지점및 관리담당자를 배정해주세요.";
				
			}		
		//}
									
	}
	
	if ( !cls_st.equals("8") ) {
		if (!a_db.updateCarStatCng(car_mng_id))	flag += 1;
//		System.out.println(" 재리스 처리 flag7=" + flag);		
        	
		
		//해지후 고객팀에 보유차관리 등록 메세지 전송------------------------------------------------------------------------------------------
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
							
		sub 		= "계약해지 보유차 관리 요망";
		cont 	= "[차량번호:"+car_no+"] 보유차 관리(등록) 확인하세요.";	
			
		String url 		= "/acar/rent_prepare/rent_pr_frame_s.jsp";
				
		String target_id = nm_db.getWorkAuthUser("보유차관리");  //보유차 관리자 "000085"; 
		
				
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
		
		//flag2 = cm_db.insertCoolMsg(msg); 20121022 김태연대리 요청으로 메시지 전송 제한 : 예비차관리전산화로 필요없어짐
			
	//	System.out.println("쿨메신저(보유차관리)"+car_no+"---------------------"+target_bean.getUser_nm());	
	}		
	
		//월렌트해지도 보험관련 보험담당자에게 메세지 보내기 - 20170223 	
	if ( cls_st.equals("14")  ) {
			
		//보험정보
		String ins_st = ai_db.getInsSt(base.getCar_mng_id());
		InsurBean ins  = ai_db.getIns(base.getCar_mng_id(), ins_st);
		Hashtable ins_info = ai_db.getInsClsCoolMsg(base.getCar_mng_id(),ins_st);
		
		//20170207 매각이나 매입옵션일 경우에는 명의이전일 등록 안되어 있으면  문구 바꾸기
		String msgGubun = "계약해지";
										
		String sub1 		= "월렌트 계약해지 완료후 보험 관리 체크요망";
		String cont1 	=  msgGubun+" ["+car_no+","+ins_info.get("CAR_NM")+","+ins_info.get("FIRM_NM")+","+ins_info.get("ENP_NO")+","+ins_info.get("INS_START_DT")+","+ins_info.get("INS_EXP_DT")+","+ins_info.get("INS_CON_NO")+"]";	
			
			//보험변경요청 프로시저 호출
		String  d_flag2 =  ec_db.call_sp_ins_cng_req(sub1, rent_mng_id, rent_l_cd, "");
	}	
					
				
	if(clsEtc.getServ_st().equals("N")) {
		
		//해지 후 차량수리필요 등록시 차량정비로 예약
		RentContBean rc_bean = new RentContBean();
		rc_bean.setCar_mng_id	(car_mng_id);
		rc_bean.setRent_st		("6");
		rc_bean.setRent_dt		(real_date);
		rc_bean.setBrch_id		("");
		rc_bean.setBus_id		(reg_id);
		rc_bean.setRent_start_dt(r_add_date+"0000");
		rc_bean.setEtc			("해지후 차량정비 자동예약 ");
		rc_bean.setDeli_plan_dt	(r_add_date+"0000");
		rc_bean.setUse_st		("1");
		rc_bean.setReg_id		(reg_id);
		rc_bean.setMng_id		(reg_id);
		rc_bean = rs_db.insertRentCont(rc_bean);	
	
	//	System.out.println("차량정비로 예약등록"+car_no);	
					
		//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------	
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
		
		sub 		= "보유차 처리 통보";
		cont 	= "[예약]차량정비 대기-"+car_no+",  "+rc_bean.getEtc() + "이 되었습니다. 정비가 끝난후  예약을 취소하여 보유차로 활용할 수 있게 하셔야 합니다.!!!";
		String target_id = reg_id;
					
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
		xml_data += "    <SENDER>system</SENDER>"+
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
		System.out.println("쿨메신저[보유차 처리 통보-해지후 차량정비 자동예약] "+car_no+"-----------------------"+target_bean.getUser_nm());	
		
	}
	
			
		//예비차 적용부분 등록 - 수리후 차량도 포함 - 20161005
	if(!clsEtc.getServ_gubun().equals("")) {	  	  
	//	  if ( clsEtc.getServ_st().equals("Y") ) {
		  	 	 count = ac_db.setCar_prepare(car_mng_id, clsEtc.getServ_gubun());
	//	   }			
	}
		
	
//	flag2 = d_db.updateDocSettleDocDt( doc_no, "5", "3") ; // 월렌트 결재완료
	flag2 = ac_db.updateClsEtcTerm(rent_mng_id, rent_l_cd, "2", reg_id);  //결재완료 
	if(!ac_db.updateClsEtcAuto(rent_mng_id, rent_l_cd, "Y")) flag += 1;
						
	System.out.println("계약해지 "+car_no+"--------"+ rent_l_cd);	
			    		
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
<input type='hidden' name='doc_no' value='<%=doc_no%>'>
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
     fm.action='/fms2/cls_cont/lc_cls_rm_u3.jsp';
     fm.target='d_content';		
     fm.submit();
<%	
	} %>
</script>
</body>
</html>
