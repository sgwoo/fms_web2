<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*, acar.coolmsg.*, acar.user_mng.*, acar.car_sche.*, acar.cont.*, acar.client.*, acar.fee.*, acar.car_service.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");		
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");	
	String s_cc = request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"a.car_nm":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String mode = request.getParameter("mode")==null?"i":request.getParameter("mode");
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String use_st = request.getParameter("use_st")==null?"":request.getParameter("use_st");
	String sub_c_id = request.getParameter("sub_c_id")==null?"":request.getParameter("sub_c_id");
	String section = request.getParameter("section")==null?"":request.getParameter("section");
	
	int count = 1;
	int count_cust = 0;
	boolean flag3 = true;
	boolean flag4 = true;
	String cms_cls_msg = "";
	String pay_cls_msg = "";


	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	AddCarServDatabase a_csd = AddCarServDatabase.getInstance();
	
	
	//미수과태료
	Vector settle_fine = rs_db.getFineSettleList(s_cd);
	int settle_fine_size = settle_fine.size();
    	int settle_fine_amt = 0;
	if(settle_fine_size > 0){
		for(int i = 0 ; i < settle_fine_size ; i++){
    			Hashtable ht = (Hashtable)settle_fine.elementAt(i);    			
			settle_fine_amt = settle_fine_amt + AddUtil.parseInt(String.valueOf(ht.get("PAID_AMT")));
    		}
    	}		
	
	
	
	//단기대여관리 계약상태=종료 수정
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
	rc_bean.setUse_st("4");
	count = rs_db.updateRentCont(rc_bean);
	
	
	//월렌트 자동이체일 경우 입금담당자에게 반차통보
	if(rc_bean.getRent_st().equals("12")){
		
		String rm_rent_mng_id = c_id;
		String rm_rent_l_cd   = "RM00000"+s_cd;
			
		//cms_mng
		ContCmsBean cms = a_db.getCmsMng(rm_rent_mng_id, rm_rent_l_cd);
		
		if(cms.getCbit().equals("1") || cms.getCbit().equals("2")){
			//cms_cls_msg = "Y";	
		}
			
			
	}	


	//단기대여 정산 등록	
	RentSettleBean rs_bean = rs_db.getRentSettleCase(s_cd);
		
	rs_bean.setSett_dt		(request.getParameter("sett_dt")==null?"":request.getParameter("sett_dt"));
	rs_bean.setRun_km		(request.getParameter("run_km")==null?"":AddUtil.parseDigit3(request.getParameter("run_km")));
	rs_bean.setAgree_hour		(request.getParameter("rent_hour")==null?"":request.getParameter("rent_hour"));
	rs_bean.setAgree_days		(request.getParameter("rent_days")==null?"":request.getParameter("rent_days"));
	rs_bean.setAgree_months		(request.getParameter("rent_months")==null?"":request.getParameter("rent_months"));
	rs_bean.setAdd_hour		(request.getParameter("add_hour")==null?"":request.getParameter("add_hour"));
	rs_bean.setAdd_days		(request.getParameter("add_days")==null?"":request.getParameter("add_days"));
	rs_bean.setAdd_months		(request.getParameter("add_months")==null?"":request.getParameter("add_months"));
	rs_bean.setTot_hour		(request.getParameter("tot_hour")==null?"":request.getParameter("tot_hour"));
	rs_bean.setTot_days		(request.getParameter("tot_days")==null?"":request.getParameter("tot_days"));
	rs_bean.setTot_months		(request.getParameter("tot_months")==null?"":request.getParameter("tot_months"));
	rs_bean.setEtc			(request.getParameter("etc")==null?"":request.getParameter("etc"));
	rs_bean.setAdd_fee_s_amt	(request.getParameter("add_fee_s_amt")==null?0:Util.parseDigit(request.getParameter("add_fee_s_amt")));
	rs_bean.setAdd_fee_v_amt	(request.getParameter("add_fee_v_amt")==null?0:Util.parseDigit(request.getParameter("add_fee_v_amt")));	
	rs_bean.setAdd_ins_s_amt	(request.getParameter("add_ins_s_amt")==null?0:Util.parseDigit(request.getParameter("add_ins_s_amt")));
	rs_bean.setAdd_ins_v_amt	(request.getParameter("add_ins_v_amt")==null?0:Util.parseDigit(request.getParameter("add_ins_v_amt")));	
	rs_bean.setAdd_etc_s_amt	(request.getParameter("add_etc_s_amt")==null?0:Util.parseDigit(request.getParameter("add_etc_s_amt")));
	rs_bean.setAdd_etc_v_amt	(request.getParameter("add_etc_v_amt")==null?0:Util.parseDigit(request.getParameter("add_etc_v_amt")));	
	rs_bean.setIns_m_s_amt		(request.getParameter("ins_m_s_amt")==null?0:Util.parseDigit(request.getParameter("ins_m_s_amt")));
	rs_bean.setIns_m_v_amt		(request.getParameter("ins_m_v_amt")==null?0:Util.parseDigit(request.getParameter("ins_m_v_amt")));	
	rs_bean.setIns_h_s_amt		(request.getParameter("ins_h_s_amt")==null?0:Util.parseDigit(request.getParameter("ins_h_s_amt")));
	rs_bean.setIns_h_v_amt		(request.getParameter("ins_h_v_amt")==null?0:Util.parseDigit(request.getParameter("ins_h_v_amt")));	
	rs_bean.setOil_s_amt		(request.getParameter("oil_s_amt")==null?0:Util.parseDigit(request.getParameter("oil_s_amt")));
	rs_bean.setOil_v_amt		(request.getParameter("oil_v_amt")==null?0:Util.parseDigit(request.getParameter("oil_v_amt")));	
	rs_bean.setRent_tot_amt		(request.getParameter("rent_tot_amt")==null?0:Util.parseDigit(request.getParameter("rent_tot_amt")));
	rs_bean.setDriv_serv_st		(request.getParameter("driv_serv_st")==null?"":request.getParameter("driv_serv_st"));
	rs_bean.setDriv_serv_etc	(request.getParameter("driv_serv_etc")==null?"":request.getParameter("driv_serv_etc"));
	rs_bean.setRent_sett_amt	(request.getParameter("rent_sett_amt")==null?0:Util.parseDigit(request.getParameter("rent_sett_amt")));
	rs_bean.setReg_id		(user_id);	
	rs_bean.setAdd_navi_s_amt	(request.getParameter("add_navi_s_amt")		==null?0:Util.parseDigit(request.getParameter("add_navi_s_amt")));
	rs_bean.setAdd_navi_v_amt	(request.getParameter("add_navi_v_amt")		==null?0:Util.parseDigit(request.getParameter("add_navi_v_amt")));
	rs_bean.setAdd_cons1_s_amt	(request.getParameter("add_cons1_s_amt")	==null?0:Util.parseDigit(request.getParameter("add_cons1_s_amt")));
	rs_bean.setAdd_cons1_v_amt	(request.getParameter("add_cons1_v_amt")	==null?0:Util.parseDigit(request.getParameter("add_cons1_v_amt")));
	rs_bean.setAdd_cons2_s_amt	(request.getParameter("add_cons2_s_amt")	==null?0:Util.parseDigit(request.getParameter("add_cons2_s_amt")));
	rs_bean.setAdd_cons2_v_amt	(request.getParameter("add_cons2_v_amt")	==null?0:Util.parseDigit(request.getParameter("add_cons2_v_amt")));
	rs_bean.setCls_s_amt		(request.getParameter("cls_s_amt")		==null?0:Util.parseDigit(request.getParameter("cls_s_amt")));
	rs_bean.setCls_v_amt		(request.getParameter("cls_v_amt")		==null?0:Util.parseDigit(request.getParameter("cls_v_amt")));	
	rs_bean.setKm_s_amt		(request.getParameter("km_s_amt")		==null?0:Util.parseDigit(request.getParameter("km_s_amt")));
	rs_bean.setKm_v_amt		(request.getParameter("km_v_amt")		==null?0:Util.parseDigit(request.getParameter("km_v_amt")));	
	rs_bean.setAdd_inv_s_amt	(request.getParameter("add_inv_s_amt")		==null?0:Util.parseDigit(request.getParameter("add_inv_s_amt")));
	rs_bean.setAdd_inv_v_amt	(request.getParameter("add_inv_v_amt")		==null?0:Util.parseDigit(request.getParameter("add_inv_v_amt")));	
	rs_bean.setFine_s_amt		(request.getParameter("fine_s_amt")		==null?0:Util.parseDigit(request.getParameter("fine_s_amt")));
	
	
	if(rs_bean.getRent_s_cd().equals("")){
		rs_bean.setRent_s_cd		(s_cd);
		count = rs_db.insertRentSettle(rs_bean);
	}else{
		count = rs_db.updateRentSettle(rs_bean);
	}
	
	//주행거리 입력점검
	String  d_flag3 =  ad_db.call_sp_dist_etc_ck(c_id, "settle", rs_bean.getRun_km(), rs_bean.getSett_dt(), ck_acar_id);
	


	//단기대여 대여정보 등록
	RentFeeBean rf_bean = rs_db.getRentFeeCase(s_cd);
	rf_bean.setCms_acc_no	(request.getParameter("cms_acc_no")	==null?"":request.getParameter("cms_acc_no"));
	rf_bean.setCms_bank	(request.getParameter("cms_bank")	==null?"":request.getParameter("cms_bank"));
	rf_bean.setCms_dep_nm	(request.getParameter("cms_dep_nm")	==null?"":request.getParameter("cms_dep_nm"));
	
	
	//기본식 정비대차 청구정보
	if(rent_st.equals("2") && rf_bean.getRent_tot_amt() > 0){
		rf_bean.setFee_s_amt	(request.getParameter("fee_s_amt")==null?0:Util.parseDigit(request.getParameter("fee_s_amt")));
		rf_bean.setFee_v_amt	(request.getParameter("fee_v_amt")==null?0:Util.parseDigit(request.getParameter("fee_v_amt")));
		rf_bean.setRent_tot_amt	(request.getParameter("rent_tot_amt")==null?0:Util.parseDigit(request.getParameter("rent_tot_amt")));
		rf_bean.setReg_id	(user_id);
		rf_bean.setCons_yn	(request.getParameter("cons_yn")==null?"":request.getParameter("cons_yn"));
		rf_bean.setPaid_st	(request.getParameter("paid_st")==null?"":request.getParameter("paid_st"));
		rf_bean.setCons1_s_amt	(request.getParameter("cons1_s_amt")==null?0:Util.parseDigit(request.getParameter("cons1_s_amt")));
		rf_bean.setCons1_v_amt	(request.getParameter("cons1_v_amt")==null?0:Util.parseDigit(request.getParameter("cons1_v_amt")));
		rf_bean.setCons2_s_amt	(request.getParameter("cons2_s_amt")==null?0:Util.parseDigit(request.getParameter("cons2_s_amt")));
		rf_bean.setCons2_v_amt	(request.getParameter("cons2_v_amt")==null?0:Util.parseDigit(request.getParameter("cons2_v_amt")));
		rf_bean.setFee_etc	(request.getParameter("fee_etc")==null?"":request.getParameter("fee_etc"));	
	}

	count = rs_db.updateRentFee(rf_bean);


	if(rent_st.equals("1") && rs_bean.getDriv_serv_st().equals("2")){
		//용역비용 등록
		for(int i=1; i<3; i++){
			ScdDrivBean sd_bean = new ScdDrivBean();
			sd_bean.setRent_s_cd	(s_cd);
			sd_bean.setRent_st	(request.getParameter("d_rent_st"+i)==null?"":request.getParameter("d_rent_st"+i));
			sd_bean.setTm		("1");
			sd_bean.setPaid_st	(request.getParameter("d_paid_st"+i)==null?"":request.getParameter("d_paid_st"+i));
			sd_bean.setPay_amt	(request.getParameter("d_pay_amt"+i)==null?0:Util.parseDigit(request.getParameter("d_pay_amt"+i)));
			sd_bean.setPay_dt	(request.getParameter("d_pay_dt"+i)==null?"":request.getParameter("d_pay_dt"+i));
			sd_bean.setReg_id	(user_id);
			count = rs_db.insertScdDriv(sd_bean);
		}
	}
	
	
	if(rent_st.equals("12")){
		//연체료 셋팅
    		boolean dly_flag = rs_db.calDelay(s_cd);
    			
		//계산서 미발행인 미수금스케줄이 있으면 미청구처리
		Vector conts = rs_db.getScdRentList(s_cd, "");
		int cont_size = conts.size();	
	
		if(cont_size > 0){
			for(int i = 0 ; i < cont_size ; i++){
				Hashtable sr = (Hashtable)conts.elementAt(i);    				
				if(Util.parseDigit(String.valueOf(sr.get("RENT_S_AMT"))) > 0 && String.valueOf(sr.get("PAY_DT")).equals("") && String.valueOf(sr.get("TAX_DT")).equals("")){//Util.parseDigit(String.valueOf(sr.get("DLY_AMT"))) == 0 && 
 					ScdRentBean scd_bean = rs_db.getScdRentCase(s_cd, String.valueOf(sr.get("RENT_ST")), String.valueOf(sr.get("TM")));
    					scd_bean.setBill_yn("N");
    					int scd_count = rs_db.updateScdRent(scd_bean);    					
    				}
    			}
		}
	}
			
	if(rs_bean.getRent_sett_amt() > 0 || rs_bean.getRent_sett_amt() < 0){
	

		//정산금스케줄 추가
		ScdRentBean sr_bean = rs_db.getScdRentCase(s_cd, "4");				
		
		sr_bean.setPaid_st	(request.getParameter("paid_st")	==null?"":request.getParameter("paid_st"));
		sr_bean.setRent_s_amt	(request.getParameter("rent_sett_s_amt")==null?0:Util.parseDigit(request.getParameter("rent_sett_s_amt")));
		sr_bean.setRent_v_amt	(request.getParameter("rent_sett_v_amt")==null?0:Util.parseDigit(request.getParameter("rent_sett_v_amt")));
		sr_bean.setPay_amt	(0);
		sr_bean.setRest_amt	(0);
		sr_bean.setPay_dt	("");
		sr_bean.setEst_dt	(rs_bean.getSett_dt());
		sr_bean.setDly_days	("");
		sr_bean.setDly_amt	(0);
		sr_bean.setBill_yn	("Y");
		sr_bean.setReg_id	(user_id);
		
		
		
		sr_bean.setEst_dt	(af_db.getValidDt(sr_bean.getEst_dt()));
		
		if(sr_bean.getRent_s_cd().equals("")){
			sr_bean.setRent_s_cd	(s_cd);
			sr_bean.setRent_st	("4");
			sr_bean.setTm		("1");
			count = rs_db.insertScdRent(sr_bean);
		}
		
		
		
		
		//자동이체를 위한 cont 빈통 만들기
		String rm_rent_mng_id = c_id;
		String rm_rent_l_cd   = "RM00000"+s_cd;
	
		//cms_mng
		ContCmsBean cms = a_db.getCmsMng(rm_rent_mng_id, rm_rent_l_cd);
	
		//자동이체신청
		if(rs_bean.getRent_sett_amt() > 0 && sr_bean.getPaid_st().equals("3") && cms.getSeq().equals("")){
			ContBaseBean base = a_db.getCont(rm_rent_mng_id, rm_rent_l_cd);
			if(base.getRent_mng_id().equals("")){
				//=====[cont] update=====
				base.setRent_mng_id	(rm_rent_mng_id);
				base.setRent_l_cd	(rm_rent_l_cd);
				base.setCar_st		("4");
				base.setCar_gu		("3");
				base.setUse_yn		("Y");
				base.setCar_mng_id	(c_id);
				base.setClient_id	(rc_bean.getCust_id());
				base.setBrch_id		(rc_bean.getBrch_id());
				base.setRent_dt		(rc_bean.getRent_dt());
				base.setBus_id		(rc_bean.getBus_id());
				base.setBus_id2		(rc_bean.getMng_id());
				base.setMng_id		(rc_bean.getMng_id());
				//base = a_db.insertContBaseNew(base);
			}
						
					
			//고객정보
			ClientBean client = al_db.getNewClient(base.getClient_id());
			
			
		}
		
		
		
		
		//미수과태료 정리
		if(settle_fine_amt==rs_bean.getFine_s_amt()){
			
			int seq_no = 0;
			String f_car_mng_id = "";
			String f_vio_dt = "";
			String f_vio_pla = "";
			String f_proxy_dt = "";
			String rent_mng_id = "";
			String rent_l_cd = "";
			int f_flag = 0;
										
			for(int i = 0 ; i < settle_fine_size ; i++){
				Hashtable ht = (Hashtable)settle_fine.elementAt(i);    	
							
				seq_no 	 	= 	 Util.parseDigit(String.valueOf(ht.get("SEQ_NO")));  //연번
				f_car_mng_id 	= 	 String.valueOf(ht.get("CAR_MNG_ID"));  //차량관리번호
				f_vio_dt  	= 	 String.valueOf(ht.get("VIO_DT"));  //위반일
				f_vio_pla 	= 	 String.valueOf(ht.get("VIO_PLA"));  //위반내용
				f_proxy_dt 	= 	 String.valueOf(ht.get("PROXY_DT"));  //납부일
				rent_mng_id 	= 	 String.valueOf(ht.get("RENT_MNG_ID")); 
				rent_l_cd 	= 	 String.valueOf(ht.get("RENT_L_CD")); 

				// 월렌트 정산시 과태료 포함 처리			
				if (!ac_db.updateForfeitDetailRentCls(rent_mng_id, rent_l_cd, seq_no,  user_id) )	f_flag += 1; //미납된 과태료  정산시 입금처리
				
				//선납한 경우 제외		
				if ( f_proxy_dt.equals("") ) {		
						
					//담당자에게 메세지 전송------------------------------------------------------------------------------------------							
					UsersBean sender_bean5 	= umd.getUsersBean(user_id);
							
					String sub5 	= "과태료 납입요청";
					String cont5 	= "▣ 과태료 납입요청  &lt;br&gt; &lt;br&gt;  "+ request.getParameter("car_no") + " &lt;br&gt; &lt;br&gt;  해지일:"+ rs_bean.getSett_dt() + " &lt;br&gt; &lt;br&gt; 위반장소:" + f_vio_pla + " &lt;br&gt; &lt;br&gt; 위반일:"+ f_vio_dt;  													
					String url5 	= "/acar/fine_mng/fine_mng_frame.jsp?c_id="+f_car_mng_id+"|m_id="+rent_mng_id+"|l_cd="+rent_l_cd+"|seq_no="+seq_no;		 
											
			
					String target_id5 =   nm_db.getWorkAuthUser("출금담당");
							
					//사용자 정보 조회
					UsersBean target_bean5 	= umd.getUsersBean(target_id5);
					
					String xml_data5 = "";
					xml_data5 =  "<COOLMSG>"+
				  				"<ALERTMSG>"+
				  				"    <BACKIMG>4</BACKIMG>"+
				  				"    <MSGTYPE>104</MSGTYPE>"+
				  				"    <SUB>"+sub5+"</SUB>"+
				  				"    <CONT>"+cont5+"</CONT>"+
				 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url5+"</URL>";
					
					xml_data5 += "    <TARGET>"+target_bean5.getId()+"</TARGET>";
					
					xml_data5 += "    <SENDER>"+sender_bean5.getId()+"</SENDER>"+
				  				"    <MSGICON>10</MSGICON>"+
				  				"    <MSGSAVE>1</MSGSAVE>"+
				  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
				  				"    <FLDTYPE>1</FLDTYPE>"+
				  				"  </ALERTMSG>"+
				  				"</COOLMSG>";
					
					CdAlertBean msg5 = new CdAlertBean();
					msg5.setFlddata(xml_data5);
					msg5.setFldtype("1");
					
					flag4 = cm_db.insertCoolMsg(msg5);
						
					System.out.println("쿨메신저(과태료납입요청의뢰)"+request.getParameter("car_no")+", 위반일:"+ f_vio_dt +" ---------------------"+target_bean5.getUser_nm());	
					
				}
						
							
			} 			
			
		}
		
		
		
	}
	
	//기본식 정비대차 청구정보
	if(rent_st.equals("2") && rf_bean.getRent_tot_amt() > 0){
	
			String 	fee_r_yn =  request.getParameter("fee_r_yn")==null?"":request.getParameter("fee_r_yn"); //대여료 출금일에 맞춤요청
			
			ScdRentBean sr_bean = rs_db.getScdRentCase(s_cd, "3", "1");
			
			
			//반차일시로 스케줄 생성
			if(rf_bean.getRent_tot_amt() > 0){
								
									
				sr_bean.setRent_s_amt	(request.getParameter("rent_tot_s_amt")==null?0:Util.parseDigit(request.getParameter("rent_tot_s_amt")));
				sr_bean.setRent_v_amt	(request.getParameter("rent_tot_v_amt")==null?0:Util.parseDigit(request.getParameter("rent_tot_v_amt")));					
				sr_bean.setDly_days	("");
				sr_bean.setDly_amt	(0);
				sr_bean.setBill_yn	("Y");
				sr_bean.setReg_id	(user_id);					
					
					
				if(sr_bean.getRent_s_amt()>0){
				
					Hashtable h_cont = a_db.getContCase(rc_bean.getSub_l_cd());
				
					if(sr_bean.getRent_s_cd().equals("")){
						sr_bean.setRent_s_cd	(s_cd);
						sr_bean.setRent_st	("3");			
						sr_bean.setTm		("1");
						sr_bean.setPaid_st	(request.getParameter("paid_st")==null?"":request.getParameter("paid_st"));						
						sr_bean.setRest_amt	(0);
						sr_bean.setPay_dt	("");
						sr_bean.setEst_dt	(request.getParameter("sett_dt")==null?"":request.getParameter("sett_dt"));
												
						//기본 +15일						
						sr_bean.setEst_dt	(rs_db.addDay(sr_bean.getEst_dt(), 15));
						sr_bean.setEst_dt	(af_db.getValidDt(sr_bean.getEst_dt()));
						
						//대여료 출금일에 맞춤
						if (fee_r_yn.equals("Y")) {  
							sr_bean.setEst_dt(a_csd.getCustPlanDtBSD(String.valueOf(h_cont.get("RENT_MNG_ID")), String.valueOf(h_cont.get("RENT_L_CD"))));
						}													
							
						count = rs_db.insertScdRent(sr_bean);
					}else{
						if(sr_bean.getPay_dt().equals("")){						
							count = rs_db.updateScdRent(sr_bean);	
						}
					}
				}
			}		
	
	
	}
	
	
	String memo_title 	= "월렌트-";
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String c_firm_nm 	= request.getParameter("c_firm_nm")==null?"":request.getParameter("c_firm_nm");
	String c_cust_nm 	= request.getParameter("c_cust_nm")==null?"":request.getParameter("c_cust_nm");
	String coolmsg_cont 	= request.getParameter("coolmsg_cont")==null?"":request.getParameter("coolmsg_cont");

	memo_title += car_no+" "+c_firm_nm+" "+c_cust_nm+" "+AddUtil.getTimeHMS();
	
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
	//기본식 정비대차 청구정보
	if(rent_st.equals("2") && rf_bean.getRent_tot_amt() > 0){
	
			memo_title = 	car_no+" "+c_firm_nm+" "+c_cust_nm;
	
			String sub4 	= "기본식 정비대차 [정산]";
			String cont4 	= "기본식 정비대차 [정산] 되었습니다. ("+memo_title+") 세금계산서를 발행하시기 바랍니다.";
			String url4	= "/acar/rent_end/rent_settle_u.jsp?s_cd="+s_cd+"|c_id="+c_id;
						
						
			UsersBean target_bean4 	= umd.getUsersBean(nm_db.getWorkAuthUser("세금계산서담당자"));
			
			CarScheBean cs_bean4 = csd.getCarScheTodayBean(target_bean4.getUser_id());
			if(!cs_bean4.getUser_id().equals("")){
				if(cs_bean4.getTitle().equals("오전반휴")){
					//등록시간이 오전(12시전)이라면 대체자
					if(AddUtil.getTimeAM().equals("오전")){
						String target_id4 = cs_bean4.getWork_id();
						target_bean4 	= umd.getUsersBean(target_id4);
					}								
				}else if(cs_bean4.getTitle().equals("오후반휴")){
					//등록시간이 오후(12시이후)라면 대체자
					if(AddUtil.getTimeAM().equals("오후")){				
						String target_id4 = cs_bean4.getWork_id();
						target_bean4 	= umd.getUsersBean(target_id4);
					}
				}else{//연차
					String target_id4 = cs_bean4.getWork_id();
					target_bean4 	= umd.getUsersBean(target_id4);
				}
			}	
		
			String xml_data4 = "";
			xml_data4 =  "<COOLMSG>"+
	  					 "<ALERTMSG>"+
  						 "    <BACKIMG>4</BACKIMG>"+
  						 "    <MSGTYPE>104</MSGTYPE>"+
  						 "    <SUB>"+sub4+"</SUB>"+
	  					 "    <CONT>"+cont4+"</CONT>"+
 						 "    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url4+"</URL>"; 						 
			xml_data4 += "    <TARGET>"+target_bean4.getId()+"</TARGET>";
			xml_data4 += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
  						 "    <MSGICON>10</MSGICON>"+
  						 "    <MSGSAVE>1</MSGSAVE>"+
  						 "    <LEAVEDMSG>1</LEAVEDMSG>"+
	  					 "    <FLDTYPE>1</FLDTYPE>"+
  						 "  </ALERTMSG>"+
  						 "</COOLMSG>";
			
			CdAlertBean msg4 = new CdAlertBean();
			msg4.setFlddata(xml_data4);
			msg4.setFldtype("1");
			
			flag4 = cm_db.insertCoolMsg(msg4);
	}
	
	
		
%>
<script language='javascript'>
<%	if(count == 1){%>
			alert('정상적으로 처리되었습니다');
						
			parent.location='/acar/rent_settle/rent_se_frame_s.jsp?s_cd=<%=s_cd%>&c_id=<%=c_id%>&mode=<%=mode%>&auth_rw=<%=rs_db.getAuthRw(user_id, "02", "01", "02")%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&brch_id=<%=brch_id%>&start_dt=<%=start_dt%>&end_dt=<%=end_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&car_comp_id=<%=car_comp_id%>&code=<%=code%>&s_cc=<%=s_cc%>&s_year=<%=s_year%>&asc=<%=asc%>&sort_gubun=<%=sort_gubun%>';		

<%	}else{ //에러%>
			alert('처리되지 않았습니다\n\n에러발생!');
<%	}%>
</script>
</body>
</html>
