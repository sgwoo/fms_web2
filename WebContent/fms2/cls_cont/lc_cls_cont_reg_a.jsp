<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.credit.*, acar.cont.*, acar.user_mng.*, acar.cls.*, acar.coolmsg.* , acar.estimate_mng.*"%>
<%@ page import="acar.insur.*, acar.car_sche.*, acar.res_search.*, acar.common.*,   acar.im_email.*,  acar.memo.*, acar.client.* , tax.*,acar.offls_sui.* "%>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<jsp:useBean id="sui_db" scope="page" class="acar.offls_sui.Offls_suiDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>

<jsp:useBean id="code_bean" class="acar.common.CodeBean" scope="page"/>

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
	
	//String match 	= request.getParameter("match")==null?"":request.getParameter("match"); //만기매칭 :Y
	
	String car_st 	= request.getParameter("car_st")==null?"":request.getParameter("car_st"); // 업무대여 :5
					
	String reco_st 	= request.getParameter("reco_st")==null?"":request.getParameter("reco_st"); // 미회수:N
					
	boolean flag1 = true;
	boolean flag2 = true;
	 	
	int	flag = 0;	
	int	count = 0;	
		
	String from_page 	= "";	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();	
	CarSchDatabase csd = CarSchDatabase.getInstance();
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
	String match 	=clsEtc.getMatch();
		
	if (cls_st.equals("8") ) {
		from_page = "/fms2/cls_cont/lc_cls_off_d_frame.jsp";
	} else if (cls_st.equals("14") ) {
		from_page = "/fms2/cls_cont/lc_cls_rm_d_frame.jsp";	
	} else {
		from_page = "/fms2/cls_cont/lc_cls_d_frame.jsp";	
	}
			
	String car_mng_id = "";
	
	String bus_id2 = "";
	
	String mng_id = "";
	
	//계약기본정보
	ContBaseBean base = a_db.getContBase(rent_mng_id, rent_l_cd);
	car_mng_id = base.getCar_mng_id();
	
	//차량정보 
	
	bus_id2 = base.getBus_id2();

	String bus_nm = c_db.getNameById(bus_id2,"USER");
	 
			//거래처정보
	ClientBean client       = al_db.getClient(base.getClient_id());
				
		//선수금 입금일
	String opt_ip_dt1 = request.getParameter("opt_ip_dt1")==null?"":request.getParameter("opt_ip_dt1");
	String opt_ip_dt2 = request.getParameter("opt_ip_dt2")==null?"":request.getParameter("opt_ip_dt2");
	
	String real_date = "";
	String r_add_date = "";  //해지부터 1달 후 -> 해지부터 1주일 후 --> 해지부터 3일 후
		
	real_date = cls_dt;
	r_add_date =  c_db.addDay(real_date, 3);  
			
	if (cls_st.equals("8") ) {
	   if ( !opt_ip_dt1.equals("") ) {	    		    	    	
				if ( !cls_dt.equals(opt_ip_dt1) ) {
				 //  real_date = opt_ip_dt1;
				   real_date = cls_dt;
				} else {
				   real_date = cls_dt;
				}		   		
		}	
	}
		
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
	
	if(cls_st.equals("8")){//매입옵션인경우 
		cls.setOpt_per(request.getParameter("opt_per")==null?"":		request.getParameter("opt_per"));
		cls.setOpt_amt(request.getParameter("opt_amt")==null?0:			AddUtil.parseDigit(request.getParameter("opt_amt")));	
		cls.setFdft_amt3(request.getParameter("fdft_amt3")==null?0:			AddUtil.parseDigit(request.getParameter("fdft_amt3")));	  //매입옵션시 고객납입액
	
	} else {
	 
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
	}
			
	//계약해지등록  - 정산구분 : 1-> 합산정산 , 2->구분정산 , 3->카드정산 
	String jung_st = request.getParameter("jung_st")==null?"1":request.getParameter("jung_st");	
	int    h5_amt	= request.getParameter("h5_amt")==null?0:AddUtil.parseDigit(request.getParameter("h5_amt"));
	int    h7_amt	= request.getParameter("h7_amt")==null?0:AddUtil.parseDigit(request.getParameter("h7_amt"));
	String r_date = request.getParameter("r_date")==null?"":request.getParameter("r_date");	
	h5_amt = h5_amt * (-1);
	h7_amt = h7_amt;
	
//카드 취소인 경우 
	if ( jung_st.equals("3") ) {		
			
		//담당자에게 메세지 전송------------------------------------------------------------------------------------------							
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
				
		String sub 		= " 해지정산 카드 취소건 확인";
		String cont 	= "▣  해지관련 카드 취소 및 재 결재건 확인요청 :: "+ rent_l_cd + ", " +  car_no + ", 해지일:"+ real_date + ", 취소금액:" + AddUtil.parseDecimal(h5_amt)  + " , 재결재금액:" + AddUtil.parseDecimal(h7_amt) ;  	
									
		String url 		= "";				
		
		url 		= "/fms2/cls_cont/lc_cls_rm_u3.jsp?rent_mng_id="+rent_mng_id+"|rent_l_cd="+rent_l_cd;	
	
			
	//	String url 		= "";				
	//	url 		= "/acar/menu/emp_frame.jsp";	
	
						
		String target_id = nm_db.getWorkAuthUser("CMS관리"); 
				
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
		xml_data += "    <TARGET>2008003</TARGET>";
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
			
		System.out.println("쿨메신저(카드취소 확인요청의뢰)"+car_no+", 해지일 :"+ real_date +" ---------------------"+target_bean.getUser_nm());	
		
	}
					

   if ( car_st.equals("5") ) { //업무대여 
		if(!as_db.insertCls(cls))	flag += 1;   
    
	} else {
		if ( jung_st.equals("2")  || jung_st.equals("3") ) { 
		
			if(!as_db.insertCls2(cls, h5_amt, h7_amt, jung_st ))	flag += 1;	
		} else {
			if(!as_db.insertCls2(cls))	flag += 1;
		}
	}
	
   
   if ( car_st.equals("5") ) { //업무대여 
   
		//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------	
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
		
		String sub 		= "직원 업무차량 해지 통보";
		String cont 	= " 업무차량이 해지 되었습니다. : " + bus_nm  + ",  차량번호  : "+ car_no +" , 해지일 :   "+ cls_dt + " 업무에 참고 바랍니다.!!!";
	
		String target_id = nm_db.getWorkAuthUser("본사관리팀장");  //보유차 관리자 "000144"; 
				
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
		xml_data += "    <TARGET>2010006</TARGET>";	
		xml_data += "    <TARGET>2010004</TARGET>";	
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
		System.out.println("쿨메신저[업무용차량 해지 ] "+rent_l_cd+"-----------------------"+target_bean.getUser_nm());		

   }
	
//	System.out.println(" 계약해지 flag 1=" + flag);
		
	//상계금액 중 과태료, 면책금,  연체료 처리 (과태료,면책금은 일부상계 불가)  - 일부상계금액은 가수금처리로.
	// 과태료 상계
	 if ( AddUtil.parseDigit(request.getParameter("fine_amt_2"))  > 0) {
	 
	     if ( AddUtil.parseDigit(request.getParameter("fine_amt_2"))   == AddUtil.parseDigit(request.getParameter("fine_amt_1"))  ) {  //일부상계처리가 아니면 처리.
	 			   		
		   		Vector vt1 = ac_db.getForfeitDetailCls(rent_mng_id, rent_l_cd);  //미납된 과태료 
				int vt1_size = vt1.size();
				
				int seq_no = 0;
				String f_car_mng_id = "";
				String f_vio_dt = "";
				String f_vio_pla = "";
				String f_proxy_dt = "";
											
				for(int i = 0 ; i < vt1_size ; i++){
					Hashtable ht = (Hashtable)vt1.elementAt(i);
								
					seq_no 	 = 	 Util.parseDigit(String.valueOf(ht.get("SEQ_NO")));  //연번
					f_car_mng_id = 	 String.valueOf(ht.get("CAR_MNG_ID"));  //차량관리번호
					f_vio_dt 	 = 	 String.valueOf(ht.get("VIO_DT"));  //위반일
					f_vio_pla 	 = 	 String.valueOf(ht.get("VIO_PLA"));  //위반내용
					f_proxy_dt 	 = 	 String.valueOf(ht.get("PROXY_DT"));  //납부일
					
					if (!ac_db.updateForfeitDetailCls(rent_mng_id, rent_l_cd, seq_no, real_date, user_id) )	flag += 1; //미납된 과태료  정산시 입금처리
					
					//선납한 경우 제외		
					if ( f_proxy_dt.equals("") ) {		
							
						//담당자에게 메세지 전송------------------------------------------------------------------------------------------							
						UsersBean sender_bean 	= umd.getUsersBean(user_id);
								
						String sub 		= "과태료 납입요청";
						String cont 	= "▣ 과태료 납입요청 :: "+ car_no + ", 해지일:"+ real_date + ", 위반장소:" + f_vio_pla + ", 위반일:"+ f_vio_dt;  	
													
						String url 		= "";				
											
						url 		= "/acar/fine_mng/fine_mng_frame.jsp?c_id="+f_car_mng_id+"|m_id="+rent_mng_id+"|l_cd="+rent_l_cd+"|seq_no="+seq_no;		 
									
						//	UsersBean h_user = u_db.getUsersBean(nm_db.getWorkAuthUser("본사고객지원팀출납"));
				
						String target_id = nm_db.getWorkAuthUser("출금담당");  //  "000048";  //매입옵션 담당자		
						
				//		String target_id =   "000128"; //과태료 담당자 000058->000114->000130-> 000128(박휘영)		
								
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
						
						flag2 = cm_db.insertCoolMsg(msg);
							
						System.out.println("쿨메신저(과태료납입요청의뢰)"+car_no+", 위반일:"+ f_vio_dt +" ---------------------"+target_bean.getUser_nm());	
						
					}
							
	//				System.out.println(" 과태료 flag 2=" + flag);
								
				}  //end for	
			}	
	 }
	 	 
	 //면책금 상계
	 if ( AddUtil.parseDigit(request.getParameter("car_ja_amt_2") ) > 0 ) {
	 	
	 	   if ( AddUtil.parseDigit(request.getParameter("car_ja_amt_2") )  == AddUtil.parseDigit(request.getParameter("car_ja_amt_1") ) ) {  //일부상계처리가 아니면 처리 .	
	 			   		
		   		Vector vt2 = ac_db.getServiceDetailCls(rent_mng_id, rent_l_cd);  //미납된 면책금
				int vt2_size = vt2.size();			
				
				String serv_id = "";
				String ext_tm = "";
				int  car_ja_amt = 0;
					
				for(int i = 0 ; i < vt2_size ; i++){
					Hashtable ht2 = (Hashtable)vt2.elementAt(i);
								
					serv_id	 	 = 	 String.valueOf(ht2.get("EXT_ID")); //정비id
					ext_tm	 	 = 	 String.valueOf(ht2.get("EXT_TM")); //연번
					car_ja_amt 	 = 	 Util.parseDigit(String.valueOf(ht2.get("CAR_JA_AMT")));  //면책금액
					
					if (!ac_db.updateServiceDetailCls(rent_mng_id, rent_l_cd, serv_id, car_ja_amt, ext_tm, real_date, user_id) )	flag += 1;	//미납된 면책금 입금 처리
	//				System.out.println("면책금 상계 flag 3=" + flag);
				}  //end for	
	 	}
	 }
	 
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
	 			 
	 //연체료 상계
	 if ( AddUtil.parseDigit(request.getParameter("dly_amt_2"))  > 0 ){
	 		int dly_amt = AddUtil.parseDigit(request.getParameter("dly_amt_2"));
	 		//연체료 상계
	 		if(!ac_db.insertScdDlyCls(rent_mng_id, rent_l_cd, dly_amt, real_date, user_id, "2"))	flag += 1;	//미납된 면책금 입금 처리	 
//	 		System.out.println("연체료 flag 4=" + flag);		
	 }	
	 
	 	 //대여료 대손 - 해지시점에 정산금에 포함  - 만기매칭인경우는 제외 - 스케쥴 이관등.
	 if(!match.equals("Y")){// 
		 if(!ac_db.updateScdFeeCls(rent_mng_id, rent_l_cd, real_date, user_id))	flag += 1;	//미납된 대여료 대손처리	
	 }	  
//	 System.out.println(" 대여료 대손 flag 5=" + flag); 	
	 
	 //월렌트인경우 - 기존 스케쥴  bill_yn = 'N'으로 - 20151022
	 if (cls_st.equals("14") ) {	 
	  	if(!ac_db.updateScdFeeClsBill(rent_mng_id, rent_l_cd, real_date, user_id))	flag += 1;	//미납된 대여료 대손처리	
	 }
	 
//	 if ( AddUtil.parseDigit(request.getParameter("dfee_amt_1"))  > 0 ){
//	 		int fee_amt = AddUtil.parseDigit(request.getParameter("dfee_amt_2")) + AddUtil.parseDigit(request.getParameter("dfee_amt_2_v"));
	 	
	 		//대여료 대손
//	 		if(!ac_db.updateScdFeeCls(rent_mng_id, rent_l_cd, real_date, user_id))	flag += 1;	//미납된 대여료 대손처리	
//	 		System.out.println(" 대여료 대손 flag 5=" + flag); 		
//	 }	
	 
	  		
	//남아있는 데이타는 정리 및 해지정산관련 스케쥴 생성
	 String dl_amt = "";
	 if ( AddUtil.parseDigit(request.getParameter("dly_amt_2"))  > 0 ){
	   dl_amt =  Integer.toString(AddUtil.parseDigit(request.getParameter("dly_amt_2")));
	 
	 }	 
	 
	//차량회수된 상태라면 -- 차량회수 정보 수정  - 차량회수 및 반납(계약해지를 위해서)
	if(!ac_db.updateCarCallIn(rent_mng_id, rent_l_cd, real_date)) flag += 1;	
//	System.out.println(" 차량회수(반납) 처리 flag 6_1=" + flag);
	 	 
		   
	if(!as_db.closeCont(rent_mng_id, rent_l_cd, cls_st, "", dl_amt, car_no, real_date ))	flag += 1;	
//	System.out.println(" 해지 처리 flag 6=" + flag);
	
	if(cls_st.equals("7")){//출고전해지 경우 - 
		 	if(!ac_db.updateContEtcClear(rent_mng_id, rent_l_cd))	flag += 1;	//대차계약 보증금승계원계약 연동분 데이타 삭제
		 	
		 	//자체출고관리 정리 20220426
		 	String  d_flag3 = ec_db.call_sp_com_pre_cls_cont(rent_mng_id, rent_l_cd);	 
   }	
    
	//예비차 관리담당자 배정 문자 - 중도해지, 계약만료, 재리스개시전해지인 경우 - loan_st = '2'인 경우에 한해서, 월렌트해지인경우도 포함
	if ( cls_st.equals("1") || cls_st.equals("2") || cls_st.equals("10") ||  cls_st.equals("14") ) {
	
	 //	if ( !cls_st.equals("14") ) {	 	//월렌트인경우는 이미 담당자 변경함. 
		 	UsersBean bus_id2_bean 	= umd.getUsersBean(bus_id2);	 	
		 	if ( !bus_id2_bean.getLoan_st().equals("1") ) {
		 		if(!ac_db.sendMemo(cls_dt, car_no))	flag += 1;	
		 	
		 	}	 	 
	// 	}
	 	
	 	int count2 = 0;
	 	
	 	String park = request.getParameter("park")==null?"":request.getParameter("park"); //차량현위치
		String park_cont = request.getParameter("park_cont")==null?"":request.getParameter("park_cont"); //주차 기타			
		count = rs_db.updateCarPark(car_mng_id, park, park_cont);			
		
		code_bean = c_db.getCodeBean("0027",park);
	//	CodeBean code = c_db.getCodeBean("27",park);
		
		//	if(park.equals("1") || park.equals("3") || park.equals("7") || park.equals("8")|| park.equals("4") || park.equals("9")  || park.equals("11")  || park.equals("12")   || park.equals("13")  ){//입출고 데이터 삭제
		if ( !code_bean.getCms_bk().equals("")) {
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
		String n_user_id = nm_db.getWorkAuthUser("본사관리팀장");	
		
		if ( !code_bean.getCms_bk().equals("")) {
			n_mng_br_id = code_bean.getCms_bk();
		}
		
		
		if( n_mng_br_id.equals("S1") ){	
			n_user_id = nm_db.getWorkAuthUser("본사관리팀장");	
		}else if(n_mng_br_id.equals("B1") ){	
			n_user_id = nm_db.getWorkAuthUser("부산지점장");	
		}else if(n_mng_br_id.equals("D1") ){	
			n_user_id = nm_db.getWorkAuthUser("대전지점장");	
		}else if(n_mng_br_id.equals("J1") ){	
			n_user_id = nm_db.getWorkAuthUser("광주지점장");	
		}else if(n_mng_br_id.equals("G1") ){	
			n_user_id = nm_db.getWorkAuthUser("대구지점장");
		} else 	{	
			n_user_id = nm_db.getWorkAuthUser("본사관리팀장");		
		}
		
		Hashtable cont = a_db.getContViewUseYCarCase(car_mng_id);
		//계약기타정보
		ContEtcBean cont_etc = a_db.getContEtc(String.valueOf(cont.get("RENT_MNG_ID")), String.valueOf(cont.get("RENT_L_CD")));
		
		if(!n_mng_br_id.equals("") && cont_etc.getRent_mng_id().equals("")){
		
			cont_etc.setMng_br_id		(n_mng_br_id);
		
			//=====[cont_etc] update=====
			cont_etc.setRent_mng_id	(String.valueOf(cont.get("RENT_MNG_ID")));
			cont_etc.setRent_l_cd	(String.valueOf(cont.get("RENT_L_CD")));
			boolean flag21 = a_db.insertContEtc(cont_etc);
		}else{
		
			String o_mng_br_id = cont_etc.getMng_br_id();
			
			if(!n_mng_br_id.equals("") && !o_mng_br_id.equals(n_mng_br_id)){
				
				
				//관리지점 변경이력등록 & 관리지점 변경 적용
				LcRentCngHBean bean = new LcRentCngHBean();	
				bean.setRent_mng_id	(String.valueOf(cont.get("RENT_MNG_ID")));
				bean.setRent_l_cd	(String.valueOf(cont.get("RENT_L_CD")));
				bean.setCng_item	("mng_br_id");
				bean.setOld_value	(o_mng_br_id);
				bean.setNew_value	(n_mng_br_id);
				bean.setCng_cau		("보유차 현위치 변경");
				bean.setCng_id		(ck_acar_id);
				bean.setRent_st		(String.valueOf(cont.get("FEE_RENT_ST")));
				bean.setS_amt		(0);
				bean.setV_amt		(0);	
				boolean flag23 = a_db.updateLcRentCngH(bean);
					 
			
			}		
		}
									
	}
	
	if ( !cls_st.equals("8") ) {
		if (!a_db.updateCarStatCng(car_mng_id))	flag += 1;
//		System.out.println(" 재리스 처리 flag7=" + flag);		
   }	
	
	//매입옵션 이면 - 매입옵션 담당자에게 전달 
	
	if ( cls_st.equals("8") ) {
		//해지후 매입옵션 담당자에게 메세지 전송------------------------------------------------------------------------------------------
		
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
							
		String sub 		= "계약해지 매입옵션 관리 요망";
		String cont 	= "[차량번호:"+car_no+"] 매입옵션 관리(등록) 하세요.";	
			
		String url 		= "/acar/off_ls_after/off_ls_after_opt_frame.jsp";		 	 
		
		String target_id = nm_db.getWorkAuthUser("매입옵션관리자");  //  "000048";  //매입옵션 담당자		
		
		CarScheBean cs_bean2 = csd.getCarScheTodayBean(target_id);  
		
	//	String target_id = "000277" ;  // 임시		
	
		if(!cs_bean2.getWork_id().equals("")) target_id = cs_bean2.getWork_id(); 
						
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
		
		flag2 = cm_db.insertCoolMsg(msg);
			
//		System.out.println("쿨메신저(매입옵션관리)"+car_no+"---------------------"+target_bean.getUser_nm());	
	
	} else if ( cls_st.equals("7") ) {	
		
//	 	System.out.println("쿨메신저(출고전해지(신차))"+car_no+"---------------------");	
	
	} else if ( cls_st.equals("10") ) {	
		
//	 	System.out.println("쿨메신저(개시전해지(재리스))"+car_no+"---------------------");	   
	
	} else {
		//해지후 고객팀에 보유차관리 등록 메세지 전송------------------------------------------------------------------------------------------
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
							
		String sub 		= "계약해지 보유차 관리 요망";
		String cont 	= "[차량번호:"+car_no+"] 보유차 관리(등록) 확인하세요.";	
			
		String url 		= "/acar/rent_prepare/rent_pr_frame_s.jsp";
				
		String target_id = nm_db.getWorkAuthUser("보유차관리");  
		
				
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
			
//		System.out.println("쿨메신저(보유차관리)"+car_no+"---------------------"+target_bean.getUser_nm());	
	}  
		
	//싼타페등 연비보상
	int fuel_cnt = 0;
	fuel_cnt= ac_db.getFuelCnt(car_mng_id, "N" );		
	
	String return_remark = "";
	Hashtable  return1 =   new Hashtable();
	
    if (   fuel_cnt > 0   ) {     
	  	return1 = ac_db.getFuelAmt(base.getCar_mng_id(), "N"); 	
	   	return_remark = (String)return1.get("REMARK");
    }
  	 	
    //혼다는 매입옵션일 때만 
    if ( fuel_cnt > 0  && (  return_remark.equals("싼타페") || return_remark.equals("볼보") || return_remark.equals("혼다")  || return_remark.equals("벤츠")  ) )  {
       		//연비보상관련
	       if (    AddUtil.parseDigit(request.getParameter("etc3_amt_1")) <   0) {
	       	  	if (!ac_db.updateFuelCng(car_mng_id))	flag += 1;
	       	  	
	       	  	UsersBean sender_bean 	= umd.getUsersBean(user_id);
									
				String sub 		= "계약해지 연비 보상 관리 요망";
				String cont 	= "[차량번호:"+car_no+"]   연비보상 내역을 확인하세요.  보상금액 : " + request.getParameter("etc3_amt_1") ;	
				
				String target_id = "000197";   
				
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
				
		//		xml_data += "    <TARGET>2013002</TARGET>";
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
					
				System.out.println("쿨메신저  보상완료 "+car_no+"---------------------"+target_bean.getUser_nm());	
	   	  }
    }  	
		 	
		
	//고객이 피보험자인 경우 && 21세미만인 경우  20160901-해지건 보험안내 전체대상으로 적용 ;
	//해지후 보험담당자에게 해지 관련 보험처리 메세지 전송------------------------------------------------------------------------------------------

	//출고전해지가 아닌 경우만 	
	if ( cls_st.equals("7") || cls_st.equals("10")   ) {
	
	} else {
	
		//보험정보
		String ins_st = ai_db.getInsSt(base.getCar_mng_id());
		InsurBean ins  = ai_db.getIns(base.getCar_mng_id(), ins_st);
		Hashtable ins_info = ai_db.getInsClsCoolMsg(base.getCar_mng_id(),ins_st);
		
		//20170207 매각이나 매입옵션일 경우에는 명의이전일 등록 안되어 있으면  문구 바꾸기
		String msgGubun = "계약해지";
		if( cls_st.equals("6") || cls_st.equals("8") ){
			//명의이전일 찾기
			SuiBean sui = sui_db.getSui(base.getCar_mng_id());
			if(sui.getMigr_dt().equals("")){
				if( cls_st.equals("6")  ){ msgGubun = "매각" ; }
				if( cls_st.equals("8")  ){ msgGubun = "매입옵션" ; }
			}
		}
		
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
								
			String sub 		= "계약해지 완료후 보험 관리 체크요망";
			String cont 	=  msgGubun+" ["+car_no+","+ins_info.get("CAR_NM")+","+ins_info.get("FIRM_NM")+","+ins_info.get("ENP_NO")+","+ins_info.get("INS_START_DT")+","+ins_info.get("INS_EXP_DT")+","+ins_info.get("INS_CON_NO")+"]";	
			String  d_flag2 = "";
			//보험변경요청 프로시저 호출
			if ( !cls_st.equals("8")   ) {   //매입옵션이 아니면 	
				 d_flag2 =  ec_db.call_sp_ins_cng_req(sub, rent_mng_id, rent_l_cd, "");	 
		   }	
		   
		   System.out.println("쿨메신저(해지 보험관리)"+ String.valueOf(ins_info.get("CAR_NO"))  +"---------------------"+rent_l_cd );					
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
		
		String sub 		= "보유차 처리 통보";
		String cont 	= "[예약]차량정비 대기-"+car_no+",  "+rc_bean.getEtc() + "이 되었습니다. 정비가 끝난후  예약을 취소하여 보유차로 활용할 수 있게 하셔야 합니다.!!!";
	//	String target_id = reg_id;
		String target_id = clsEtc.getReg_id();//기안자
					
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
	
	
	//미회수차량 처리 		
	if ( cls_st.equals("10") || cls_st.equals("7") ) {
	} else {
		if ( reco_st.equals("N")   ) {
		   
			//2. 쿨메신저 메세지 전송------------------------------------------------------------------------------------------	
			UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
			String sub 		= "미회수차량해지 통보";
			String cont 	= " 미회수차량이 해지 되었습니다. 계약번호 : "+rent_l_cd +" , 해지일 :   "+ cls_dt + " 업무에 참고 바랍니다.!!!";
		
			String target_id = nm_db.getWorkAuthUser("본사관리팀장");  //보유차 관리자 "000144"; 
					
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
			System.out.println("쿨메신저[미회수차량 해지 ] "+rent_l_cd+"-----------------------"+target_bean.getUser_nm());		
		
		}
	}	
	
	//해지정산서 메일발송
	
	//[5단계] 인포메일러 발송 : d-mail 생성

	if ( cls_st.equals("1") || cls_st.equals("2")  || cls_st.equals("8") ) {   //중도해약, 계약만료
	
		//	1. d-mail 등록-------------------------------	
		String con_agnt_email = "";
		String firm_nm = "";		
		//cont_view
		Hashtable baseV = a_db.getContViewCase(rent_mng_id, rent_l_cd);			
		
		con_agnt_email = client.getCon_agnt_email();		
		firm_nm =String.valueOf( baseV.get("FIRM_NM"));	
				
		if(!con_agnt_email.equals("")){
									
				DmailBean d_bean = new DmailBean();
				        		
				d_bean.setSubject(firm_nm+"님, (주)아마존카 해지정산 내역 안내문입니다.");
			
				d_bean.setSql				("SSV:"+con_agnt_email.trim());
				d_bean.setReject_slist_idx	(0);
				d_bean.setBlock_group_idx	(0);
				d_bean.setMailfrom			("\"아마존카\"<tax@amazoncar.co.kr>");
				d_bean.setMailto			("\""+firm_nm+"\"<"+con_agnt_email.trim()+">");
				d_bean.setReplyto			("\"아마존카\"<tax@amazoncar.co.kr>");
				d_bean.setErrosto			("\"아마존카\"<tax@amazoncar.co.kr>");
				d_bean.setHtml				(1);
				d_bean.setEncoding			(0);
				d_bean.setCharset			("euc-kr");
				d_bean.setDuration_set		(1);
				d_bean.setClick_set			(0);
				d_bean.setSite_set			(0);
				d_bean.setAtc_set			(0);
				d_bean.setGubun				(rent_l_cd+"cls_info");				
				d_bean.setRname				("mail");
				d_bean.setMtype       		(0);
				d_bean.setU_idx       		(1);//admin계정
				d_bean.setG_idx				(1);//admin계정
				d_bean.setMsgflag     		(0);				
				d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/cls/cls_con_info.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&cls_st="+cls_st);
			
				if(!ImEmailDb.insertDEmail(d_bean, "4", "", "+7")) flag += 1;
		}	
	}
	
	cls.setDly_amt(request.getParameter("dly_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("dly_amt_1")));   //연체료 당초금액
	cls.setEtc_amt(request.getParameter("etc_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc_amt_1")));  //차량회수외주비 당초금액
	cls.setEtc2_amt(request.getParameter("etc2_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc2_amt_1"))); //차량회수부대비 당초금액
	cls.setEtc3_amt(request.getParameter("etc3_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc3_amt_1"))); //잔존차량가격 당초금액
	cls.setEtc4_amt(request.getParameter("etc4_amt_1")==null?0:		AddUtil.parseDigit(request.getParameter("etc4_amt_1"))); //기타손해배상금 당초금액
		
	String item_id = "";
  	String reg_code = "";	
  	String tax_chk1 = request.getParameter("tax_chk1")==null?"N":request.getParameter("tax_chk1"); //외주비용  
  	String tax_chk2 = request.getParameter("tax_chk2")==null?"N":request.getParameter("tax_chk2"); //부대비용 
  	String client_id 	= "";
	String site_id 		= "";
				
  	client_id = base.getClient_id();
  	
  	if(base.getTax_type().equals("2")){//지점
		site_id = base.getR_site();
	}else{
		site_id = "";
	}
  	
  	//거래처정보
	ClientSiteBean site = null; 
	if(!site_id.equals("")){
		//거래처지점정보
		site = al_db.getClientSite(client_id, site_id);
		if(site.getEnp_no().equals("")){
			site_id = "";
		}
	}
	
	
  	//위약금,연체이자. 잔존차량가격, 기타순해배상금이 있다면 
  	if ( AddUtil.parseDigit(request.getParameter("dft_amt_1"))  > 0   ||   AddUtil.parseDigit(request.getParameter("dly_amt_1"))  > 0  ||   AddUtil.parseDigit(request.getParameter("etc3_amt_1"))  > 0  ||   AddUtil.parseDigit(request.getParameter("etc4_amt_1"))  > 0  )   {
  		//사용할 item_id 가져오기	    
	    	item_id = IssueDb.getItemIdNext(real_date);	    	
  		   out.println("item_id="+item_id+"<br><br>");
  			//실행코드 가져오기
			reg_code  = Long.toString(System.currentTimeMillis());
			out.println("실행코드="+reg_code+"<br>");
	
	}
	int item_seq = 0;		
	  	
	 	//계산서 발행안하는 거래명세서 처리 - 201703 이후 적용
	if ( AddUtil.parseDigit(request.getParameter("dft_amt_1"))  > 0  ){
		 	 	
		 	item_seq +=1;
		 	 		
    		//[1단계] 거래명세서 리스트 생성		
			TaxItemListBean til_bean = new TaxItemListBean();			
			til_bean.setItem_id(item_id);
			til_bean.setItem_seq(item_seq);
			til_bean.setItem_g("해지정산금");
			til_bean.setItem_car_no(request.getParameter("car_no")==null?"":	request.getParameter("car_no"));
			til_bean.setItem_car_nm(request.getParameter("car_nm")==null?"":	request.getParameter("car_nm"));
			til_bean.setItem_supply( AddUtil.parseDigit(request.getParameter("dft_amt_1")) );
			til_bean.setItem_value(0);
			til_bean.setRent_l_cd(rent_l_cd);
			til_bean.setCar_mng_id(car_mng_id);
		 	til_bean.setGubun("15");   //해지정산시 관련된 건 :gubun = 1 대여료, 2 보증금, 3 선납금, 4 개시대여료, 5 위약금, 6 차량매각대금, 7 정비비, 8 과태료, 9 self, 10 보험대차, 11 대차료, 12 휴차료, 13 업무대여 15:해지정산
			til_bean.setReg_id(user_id);
			til_bean.setReg_code(reg_code);
		   til_bean.setCar_use(base.getCar_st()); //전자세금계산서 의무시행 관련 변경 - 1:렌트 3:리스
			til_bean.setItem_dt(real_date);  //전자세금계산서 의무시행 관련 변경	
			til_bean.setEtc("위약금");
			if(!IssueDb.insertTaxItemList(til_bean)) flag += 1;
   }	
    	
	//계산서 발행안하는 거래명세서 처리 - 201703 이후 적용
	if ( AddUtil.parseDigit(request.getParameter("dly_amt_1"))  > 0  ){
		 	 	
		 	 item_seq +=1;		
    		//[1단계] 거래명세서 리스트 생성		
			TaxItemListBean til_bean = new TaxItemListBean();			
			til_bean.setItem_id(item_id);
			til_bean.setItem_seq(item_seq);
			til_bean.setItem_g("해지정산금");
			til_bean.setItem_car_no(request.getParameter("car_no")==null?"":	request.getParameter("car_no"));
			til_bean.setItem_car_nm(request.getParameter("car_nm")==null?"":	request.getParameter("car_nm"));
			til_bean.setItem_supply( AddUtil.parseDigit(request.getParameter("dly_amt_1")) );
			til_bean.setItem_value(0);
			til_bean.setRent_l_cd(rent_l_cd);
			til_bean.setCar_mng_id(car_mng_id);
		 	til_bean.setGubun("15");   //해지정산시 관련된 건 :gubun = 1 대여료, 2 보증금, 3 선납금, 4 개시대여료, 5 위약금, 6 차량매각대금, 7 정비비, 8 과태료, 9 self, 10 보험대차, 11 대차료, 12 휴차료, 13 업무대여 15:해지정산
			til_bean.setReg_id(user_id);
			til_bean.setReg_code(reg_code);
		   til_bean.setCar_use(base.getCar_st()); //전자세금계산서 의무시행 관련 변경 - 1:렌트 3:리스
			til_bean.setItem_dt(real_date);  //전자세금계산서 의무시행 관련 변경	
			til_bean.setEtc("연체이자");
			
			if(!IssueDb.insertTaxItemList(til_bean)) flag += 1;
   }	
			
		//계산서 발행안하는 거래명세서 처리 - 201703 이후 적용 - 차량회수외주비용 
	if ( AddUtil.parseDigit(request.getParameter("etc_amt_1"))  > 0  && tax_chk1.equals("Y")   ){
		 	 
		  	 item_seq +=1;		 		
    		//[1단계] 거래명세서 리스트 생성		
			TaxItemListBean til_bean = new TaxItemListBean();			
			til_bean.setItem_id(item_id);
			til_bean.setItem_seq(item_seq);
			til_bean.setItem_g("해지정산금");
			til_bean.setItem_car_no(request.getParameter("car_no")==null?"":	request.getParameter("car_no"));
			til_bean.setItem_car_nm(request.getParameter("car_nm")==null?"":	request.getParameter("car_nm"));
			til_bean.setItem_supply( AddUtil.parseDigit(request.getParameter("etc_amt_1")) );
			til_bean.setItem_value(0);
			til_bean.setRent_l_cd(rent_l_cd);
			til_bean.setCar_mng_id(car_mng_id);
		 	til_bean.setGubun("15");   //해지정산시 관련된 건 :gubun = 1 대여료, 2 보증금, 3 선납금, 4 개시대여료, 5 위약금, 6 차량매각대금, 7 정비비, 8 과태료, 9 self, 10 보험대차, 11 대차료, 12 휴차료, 13 업무대여 15:해지정산
			til_bean.setReg_id(user_id);
			til_bean.setReg_code(reg_code);
		   til_bean.setCar_use(base.getCar_st()); //전자세금계산서 의무시행 관련 변경 - 1:렌트 3:리스
			til_bean.setItem_dt(real_date);  //전자세금계산서 의무시행 관련 변경	
			til_bean.setEtc("차량회수외주비용");
			if(!IssueDb.insertTaxItemList(til_bean)) flag += 1;
   }	
   	
   		//계산서 발행안하는 거래명세서 처리 - 201703 이후 적용
	if ( AddUtil.parseDigit(request.getParameter("etc2_amt_1"))  > 0  && tax_chk2.equals("Y")  ){
		 	 		
		 	   	 item_seq +=1;		 				
    		//[1단계] 거래명세서 리스트 생성		
			TaxItemListBean til_bean = new TaxItemListBean();			
			til_bean.setItem_id(item_id);
			til_bean.setItem_seq(item_seq);
			til_bean.setItem_g("해지정산금");
			til_bean.setItem_car_no(request.getParameter("car_no")==null?"":	request.getParameter("car_no"));
			til_bean.setItem_car_nm(request.getParameter("car_nm")==null?"":	request.getParameter("car_nm"));
			til_bean.setItem_supply( AddUtil.parseDigit(request.getParameter("etc2_amt_1")) );
			til_bean.setItem_value(0);
			til_bean.setRent_l_cd(rent_l_cd);
			til_bean.setCar_mng_id(car_mng_id);
		 	til_bean.setGubun("15");   //해지정산시 관련된 건 :gubun = 1 대여료, 2 보증금, 3 선납금, 4 개시대여료, 5 위약금, 6 차량매각대금, 7 정비비, 8 과태료, 9 self, 10 보험대차, 11 대차료, 12 휴차료, 13 업무대여 15:해지정산
			til_bean.setReg_id(user_id);
			til_bean.setReg_code(reg_code);
		   til_bean.setCar_use(base.getCar_st()); //전자세금계산서 의무시행 관련 변경 - 1:렌트 3:리스
			til_bean.setItem_dt(real_date);  //전자세금계산서 의무시행 관련 변경	
			til_bean.setEtc("차량회수부대비용");
			if(!IssueDb.insertTaxItemList(til_bean)) flag += 1;
   }	
   
   	//계산서 발행안하는 거래명세서 처리 - 201703 이후 적용
	if ( AddUtil.parseDigit(request.getParameter("etc3_amt_1"))  > 0  ){
		 	 	
		 	  	 item_seq +=1;		 		 		
    		//[1단계] 거래명세서 리스트 생성		
			TaxItemListBean til_bean = new TaxItemListBean();			
			til_bean.setItem_id(item_id);
			til_bean.setItem_seq(item_seq);
			til_bean.setItem_g("해지정산금");
			til_bean.setItem_car_no(request.getParameter("car_no")==null?"":	request.getParameter("car_no"));
			til_bean.setItem_car_nm(request.getParameter("car_nm")==null?"":	request.getParameter("car_nm"));
			til_bean.setItem_supply( AddUtil.parseDigit(request.getParameter("etc3_amt_1")) );
			til_bean.setItem_value(0);
			til_bean.setRent_l_cd(rent_l_cd);
			til_bean.setCar_mng_id(car_mng_id);
		 	til_bean.setGubun("15");   //해지정산시 관련된 건 :gubun = 1 대여료, 2 보증금, 3 선납금, 4 개시대여료, 5 위약금, 6 차량매각대금, 7 정비비, 8 과태료, 9 self, 10 보험대차, 11 대차료, 12 휴차료, 13 업무대여 15:해지정산
			til_bean.setReg_id(user_id);
			til_bean.setReg_code(reg_code);
		    til_bean.setCar_use(base.getCar_st()); //전자세금계산서 의무시행 관련 변경 - 1:렌트 3:리스
			til_bean.setItem_dt(real_date);  //전자세금계산서 의무시행 관련 변경	
			til_bean.setEtc("잔존차량가격");
			if(!IssueDb.insertTaxItemList(til_bean)) flag += 1;
   }	
   
   	//계산서 발행안하는 거래명세서 처리 - 201703 이후 적용
	if ( AddUtil.parseDigit(request.getParameter("etc4_amt_1"))  > 0  ){
		 	
		 	 	 item_seq +=1;		 		 		
    		//[1단계] 거래명세서 리스트 생성		
			TaxItemListBean til_bean = new TaxItemListBean();			
			til_bean.setItem_id(item_id);
			til_bean.setItem_seq(item_seq);
			til_bean.setItem_g("해지정산금");
			til_bean.setItem_car_no(request.getParameter("car_no")==null?"":	request.getParameter("car_no"));
			til_bean.setItem_car_nm(request.getParameter("car_nm")==null?"":	request.getParameter("car_nm"));
			til_bean.setItem_supply( AddUtil.parseDigit(request.getParameter("etc4_amt_1")) );
			til_bean.setItem_value(0);
			til_bean.setRent_l_cd(rent_l_cd);
			til_bean.setCar_mng_id(car_mng_id);
		 	til_bean.setGubun("15");   //해지정산시 관련된 건 :gubun = 1 대여료, 2 보증금, 3 선납금, 4 개시대여료, 5 위약금, 6 차량매각대금, 7 정비비, 8 과태료, 9 self, 10 보험대차, 11 대차료, 12 휴차료, 13 업무대여 15:해지정산
			til_bean.setReg_id(user_id);
			til_bean.setReg_code(reg_code);
		    til_bean.setCar_use(base.getCar_st()); //전자세금계산서 의무시행 관련 변경 - 1:렌트 3:리스
			til_bean.setItem_dt(real_date);  //전자세금계산서 의무시행 관련 변경	
			til_bean.setEtc("기타손해배상금");
			if(!IssueDb.insertTaxItemList(til_bean)) flag += 1;
   }	
   	
   	 	//[2단계] 거래명세서 생성
	    		
	Vector vt = IssueDb.getTaxItemListSusi(reg_code);
	int vt_size = vt.size();
	out.println("거래명세서 생성="+vt_size+"<br><br>");
		
	for(int j=0;j < vt_size;j++){
			Hashtable ht = (Hashtable)vt.elementAt(j);
			TaxItemBean ti_bean = new TaxItemBean();
			ti_bean.setClient_id(client_id);
			ti_bean.setSeq(site_id);
			ti_bean.setItem_dt(real_date);
			
			ti_bean.setTax_id("");
			ti_bean.setItem_id(String.valueOf(ht.get("ITEM_ID")));
			ti_bean.setItem_hap_str(AddUtil.parseDecimalHan(String.valueOf(ht.get("ITEM_HAP_NUM")))+"원");
			ti_bean.setItem_hap_num(AddUtil.parseInt(String.valueOf(ht.get("ITEM_HAP_NUM"))));
			ti_bean.setItem_man(String.valueOf(ht.get("ITEM_MAN")));
			
			if(!IssueDb.insertTaxItem(ti_bean)) flag += 1;
	}
	
	
	if ( vt_size > 0) {	
	
		//사용자
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
		String con_agnt_nm			= "";
		String con_agnt_email		= "";
		String con_agnt_m_tel		= "";
		
		if(!site_id.equals("")){
			con_agnt_nm			= site.getAgnt_nm();
			con_agnt_email		= site.getAgnt_email();
			con_agnt_m_tel		= site.getAgnt_m_tel();
		}else{
			con_agnt_nm			= client.getCon_agnt_nm();
			con_agnt_email		= client.getCon_agnt_email();
			con_agnt_m_tel		= client.getCon_agnt_m_tel();
		}
	
		
		//프로시저 호출
		int flag5 = 0;
		String  d_flag2 =  IssueDb.call_sp_tax_ebill_itemmail("r", sender_bean.getId(), reg_code, item_id, con_agnt_nm, con_agnt_email, con_agnt_m_tel);
		System.out.println(d_flag2);
		if (!d_flag2.equals("0")) flag5 = 1;
		System.out.println(" 해지 - 거래명세서 메일 프로시저 자동등록"+item_id + ","+ sender_bean.getUser_nm() +","+ con_agnt_nm + "," + con_agnt_email);
		
	}
	
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
   <% if (  !cls_st.equals("14")  ) {%>	
    fm.action='/fms2/cls_cont/lc_cls_u3.jsp';
    <% } else { %>
        fm.action='/fms2/cls_cont/lc_cls_rm_u3.jsp';
    <% } %>    
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>
