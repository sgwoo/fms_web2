<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.cont.*, acar.car_office.*, acar.res_search.*,  acar.ext.*,  acar.fee.*"%>
<%@ page import="acar.user_mng.*, acar.car_sche.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	//if(1==1)return;
	
	String auth_rw 		= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	
	String car_gu 		= request.getParameter("car_gu")==null?"1":request.getParameter("car_gu");//신차1,기존0
	String car_st 		= request.getParameter("car_st")==null?"":request.getParameter("car_st");	
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag7 = true;
	boolean flag8 = true;
	boolean flag9 = true;
	boolean flag10 = true;
	boolean flag11 = true;
	boolean flag12 = true;
	int i_flag4 = 0;
	int flag = 0;
	
	
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	
	//신차대여정보
	ContFeeBean f_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");


	//System.out.println(rent_l_cd+" 연장 납입횟수 : "+request.getParameter("fee_pay_tm"));
	

	
	//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);


	//계약기본정보-----------------------------------------------------------------------------------------------
	
	//cont
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	base.setRent_end_dt	(request.getParameter("rent_end_dt")		==null?"":request.getParameter("rent_end_dt"));
	base.setSanction_type("연장등록");
	
	
	//=====[cont] update=====
	flag2 = a_db.updateContBaseNew(base);


	//대여기타정보-------------------------------------------------------------------------------------------
	
	//fee_etc
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, rent_st);
	fee_etc.setSh_car_amt		(request.getParameter("sh_car_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("sh_car_amt")));
	fee_etc.setSh_year		(request.getParameter("sh_year")		==null?"":request.getParameter("sh_year"));
	fee_etc.setSh_month		(request.getParameter("sh_month")		==null?"":request.getParameter("sh_month"));
	fee_etc.setSh_day		(request.getParameter("sh_day")			==null?"":request.getParameter("sh_day"));
	fee_etc.setSh_day_bas_dt	(request.getParameter("sh_day_bas_dt")		==null?"":request.getParameter("sh_day_bas_dt"));
	fee_etc.setSh_amt		(request.getParameter("sh_amt")			==null? 0:AddUtil.parseDigit(request.getParameter("sh_amt")));
	fee_etc.setSh_ja		(request.getParameter("sh_ja")			==null? 0:AddUtil.parseFloat(request.getParameter("sh_ja")));
	fee_etc.setSh_km		(request.getParameter("sh_km")			==null? 0:AddUtil.parseDigit(request.getParameter("sh_km")));
	fee_etc.setSh_km_bas_dt		(request.getParameter("sh_km_bas_dt")		==null?"":request.getParameter("sh_km_bas_dt"));
	fee_etc.setBus_agnt_id		(request.getParameter("bus_agnt_id")		==null?"":request.getParameter("bus_agnt_id"));
	fee_etc.setSh_tot_km		(request.getParameter("sh_tot_km")		==null? 0:AddUtil.parseDigit(request.getParameter("sh_tot_km")));
	fee_etc.setSh_init_reg_dt	(request.getParameter("sh_init_reg_dt")		==null?"":request.getParameter("sh_init_reg_dt"));
	fee_etc.setCon_day		(request.getParameter("con_day")		==null?"":request.getParameter("con_day"));
	
	if(fee_etc.getRent_l_cd().equals("")){
		fee_etc.setRent_mng_id		(rent_mng_id);
		fee_etc.setRent_l_cd		(rent_l_cd);
		fee_etc.setRent_st		(rent_st);
		//=====[fee_etc] insert=====
		flag1 = a_db.insertFeeEtc(fee_etc);
	}else{
		//=====[fee_etc] update=====
		flag1 = a_db.updateFeeEtc(fee_etc);
	}
	
	flag1 = a_db.updateFeeEtcCngCheckInit(rent_mng_id, rent_l_cd, rent_st, nm_db.getWorkAuthUser("연장/승계담당자"), "계약연장");





	//대여정보-------------------------------------------------------------------------------------------
	
	
	//fee
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	fee.setRent_st			(rent_st);//연장 일련번호
	fee.setExt_agnt			(request.getParameter("ext_agnt")	==null? "":request.getParameter("ext_agnt"));
	fee.setRent_dt			(request.getParameter("rent_dt")	==null? "":request.getParameter("rent_dt"));
	fee.setCon_mon			(request.getParameter("con_mon")		==null?"0":request.getParameter("con_mon"));
	fee.setRent_start_dt		(request.getParameter("rent_start_dt")	==null?"":request.getParameter("rent_start_dt"));
	fee.setRent_end_dt		(request.getParameter("rent_end_dt")	==null?"":request.getParameter("rent_end_dt"));
	
	fee.setGrt_amt_s		(request.getParameter("grt_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("grt_s_amt")));
	fee.setGur_per			(request.getParameter("gur_per")		==null? 0:AddUtil.parseFloat(request.getParameter("gur_per")));
	fee.setGur_p_per		(request.getParameter("gur_p_per")		==null? 0:AddUtil.parseFloat(request.getParameter("gur_p_per")));
	fee.setGrt_suc_yn		(request.getParameter("grt_suc_yn")		==null?"":request.getParameter("grt_suc_yn"));
	
	if(!fee.getGrt_suc_yn().equals("1") && fee.getGrt_amt_s()>0){
		fee.setGrt_suc_yn("0");
	}
	
	fee.setFee_s_amt		(request.getParameter("fee_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("fee_s_amt")));
	fee.setFee_v_amt		(request.getParameter("fee_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("fee_v_amt")));
	fee.setInv_s_amt		(request.getParameter("fee_s_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("fee_s_amt")));
	fee.setInv_v_amt		(request.getParameter("fee_v_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("fee_v_amt")));
	//fee.setDc_ra			(request.getParameter("dc_ra")			==null? 0:AddUtil.parseFloat(request.getParameter("dc_ra")));
		
	fee.setCls_per			(request.getParameter("cls_per")		==null?"":request.getParameter("cls_per"));
	fee.setCls_r_per		(request.getParameter("cls_r_per")		==null? 0:AddUtil.parseFloat(request.getParameter("cls_r_per")));
	fee.setCls_n_per		(0);
	
	fee.setFee_sac_id		(request.getParameter("fee_sac_id")		==null?"":request.getParameter("fee_sac_id"));
	fee.setFee_pay_tm		(request.getParameter("fee_pay_tm")		==null?"":request.getParameter("fee_pay_tm"));
	fee.setFee_est_day		(request.getParameter("fee_est_day")		==null?"":request.getParameter("fee_est_day"));
	fee.setFee_pay_start_dt		(request.getParameter("fee_pay_start_dt")	==null?"":request.getParameter("fee_pay_start_dt"));
	fee.setFee_pay_end_dt		(request.getParameter("fee_pay_end_dt")		==null?"":request.getParameter("fee_pay_end_dt"));
	fee.setFee_cdt			(request.getParameter("fee_cdt")		==null?"":request.getParameter("fee_cdt"));	
	
	fee.setFee_fst_dt		(request.getParameter("fee_fst_dt")		==null?"":request.getParameter("fee_fst_dt"));
	fee.setFee_fst_amt		(request.getParameter("fee_fst_amt")		==null? 0:AddUtil.parseDigit(request.getParameter("fee_fst_amt")));
	
	//사용자 정보 조회
	UsersBean sender_bean 	= umd.getUsersBean(fee.getExt_agnt());
	fee.setBrch_id			(sender_bean.getBr_id());	
	
	
//	if(fee.getRent_l_cd().equals("")){
		fee.setRent_mng_id		(rent_mng_id);
		fee.setRent_l_cd		(rent_l_cd);
		//=====[fee] insert=====
		flag5 = a_db.insertContFee(fee);
//	}
	
	//=====[fee] update=====
	flag5 = a_db.updateContFeeNew(fee);
	
		
	
	//선수금 스케줄 생성
	
	/*보증금 table에 insert해준다*/
	ExtScdBean grt = new ExtScdBean();
	grt.setRent_mng_id	(rent_mng_id);
	grt.setRent_l_cd	(rent_l_cd);
	grt.setRent_st		(rent_st);
	grt.setRent_seq		("1");
	grt.setExt_id		("0");
	grt.setExt_st		("0");					//0:보증금
	grt.setExt_tm		("1");
	grt.setExt_est_dt	(fee.getGrt_est_dt());
	grt.setExt_s_amt	(0);  //초기화 (20071224 :승계인 경우는 0로)
	grt.setExt_v_amt	(0);  //초기화 
	//금액 별도일때(위 대여에 대한 승계가 아님)
	if(fee.getGrt_suc_yn().equals("1")){
		grt.setExt_s_amt	(fee.getGrt_amt_s());	//보증금은 부가세 없다
		grt.setExt_v_amt	(0);
	}
	grt.setUpdate_id	(user_id);
	if(!ae_db.insertGrt(grt))		flag += 1;
	
	

	//fee_rm
	ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, rent_st);
		
	fee_rm.setDc_s_amt	(request.getParameter("dc_s_amt")==null?0:Util.parseDigit(request.getParameter("dc_s_amt")));
	fee_rm.setDc_v_amt	(request.getParameter("dc_v_amt")==null?0:Util.parseDigit(request.getParameter("dc_v_amt")));
	fee_rm.setNavi_s_amt	(request.getParameter("navi_s_amt")==null?0:Util.parseDigit(request.getParameter("navi_s_amt")));
	fee_rm.setNavi_v_amt	(request.getParameter("navi_v_amt")==null?0:Util.parseDigit(request.getParameter("navi_v_amt")));
	fee_rm.setEtc_s_amt	(request.getParameter("etc_s_amt")==null?0:Util.parseDigit(request.getParameter("etc_s_amt")));
	fee_rm.setEtc_v_amt	(request.getParameter("etc_v_amt")==null?0:Util.parseDigit(request.getParameter("etc_v_amt")));
	fee_rm.setT_fee_s_amt	(request.getParameter("t_fee_s_amt")==null?0:Util.parseDigit(request.getParameter("t_fee_s_amt")));
	fee_rm.setT_fee_v_amt	(request.getParameter("t_fee_v_amt")==null?0:Util.parseDigit(request.getParameter("t_fee_v_amt")));
	fee_rm.setCons1_s_amt	(request.getParameter("cons1_s_amt")==null?0:Util.parseDigit(request.getParameter("cons1_s_amt")));
	fee_rm.setCons1_v_amt	(request.getParameter("cons1_v_amt")==null?0:Util.parseDigit(request.getParameter("cons1_v_amt")));
	fee_rm.setCons2_s_amt	(request.getParameter("cons2_s_amt")==null?0:Util.parseDigit(request.getParameter("cons2_s_amt")));
	fee_rm.setCons2_v_amt	(request.getParameter("cons2_v_amt")==null?0:Util.parseDigit(request.getParameter("cons2_v_amt")));
	fee_rm.setReg_id	(user_id);
	fee_rm.setUpdate_id	(user_id);
	fee_rm.setNavi_yn	(request.getParameter("navi_yn")==null?"":request.getParameter("navi_yn"));
	fee_rm.setCons1_yn	(request.getParameter("cons1_yn")==null?"":request.getParameter("cons1_yn"));
	fee_rm.setCons2_yn	(request.getParameter("cons2_yn")==null?"":request.getParameter("cons2_yn"));
	fee_rm.setEtc_cont	(request.getParameter("etc_cont")==null?"":request.getParameter("etc_cont"));
		
	if(!fee_rm.getCons1_yn().equals("Y") && fee_rm.getCons1_s_amt()>0)	fee_rm.setCons1_yn("Y");
	if(!fee_rm.getCons1_yn().equals("N") && fee_rm.getCons1_s_amt()==0)	fee_rm.setCons1_yn("N");
	if(!fee_rm.getCons2_yn().equals("Y") && fee_rm.getCons2_s_amt()>0)	fee_rm.setCons2_yn("Y");
	if(!fee_rm.getCons2_yn().equals("Y") && fee_rm.getCons2_s_amt()==0)	fee_rm.setCons2_yn("N");
		
		
	if(fee_rm.getRent_mng_id().equals("")){			
		fee_rm.setRent_mng_id		(rent_mng_id);
		fee_rm.setRent_l_cd		(rent_l_cd);
		fee_rm.setRent_st		(rent_st);
		//=====[fee_etc] insert=====
		flag6 = a_db.insertFeeRm(fee_rm);
	}else{
		//=====[fee_etc] update=====
		flag6 = a_db.updateFeeRm(fee_rm);
	}		
	
	
	
	//스케줄생성여부 선택시 월렌트 스케줄 생성한다.-------------------------------------------------------
	
	
	String scd_reg_yn 	= request.getParameter("scd_reg_yn")==null?"":request.getParameter("scd_reg_yn");	
	
	
	//기존대여스케줄 대여횟수 최대값
	int max_fee_tm = a_db.getMax_fee_tm(rent_mng_id, rent_l_cd);	
	
	FeeScdBean cms_fee_scd = new FeeScdBean();
	
	if(scd_reg_yn.equals("Y")){
	
	
		//생성회차
		int i_fee_pay_tm = AddUtil.parseInt(fee.getFee_pay_tm());
		
		if(i_fee_pay_tm ==0){
			if(AddUtil.parseInt(fee.getCon_mon())==0 && AddUtil.parseInt(fee_etc.getCon_day()) > 0){
				i_fee_pay_tm = 1;
			}
		}
	
		//변경이력 등록------------------------------------------------------------------------
		FeeScdCngBean cng = new FeeScdCngBean();
		cng.setRent_mng_id	(rent_mng_id);
		cng.setRent_l_cd	(rent_l_cd);
		cng.setFee_tm		(rent_st);
		cng.setAll_st		("");
		cng.setGubun		("월렌트 연장생성");
		cng.setB_value		("");
		cng.setA_value		(fee.getFee_pay_tm()+"회차");
		cng.setCng_id		(user_id);
		cng.setCng_cau		("월렌트 연장생성 등록");
		
		if(!af_db.insertFeeScdCng(cng)) flag += 1;
			
		//1회차사용기간
		String f_use_start_dt 	= fee.getRent_start_dt();
		String f_use_end_dt 	= fee.getRent_end_dt();
		String f_fee_est_dt 	= fee.getFee_fst_dt();
		
		//1회차인것
		if(i_fee_pay_tm == 1){
				
			FeeScdBean fee_scd = new FeeScdBean();
				
			fee_scd.setRent_mng_id		(rent_mng_id);
			fee_scd.setRent_l_cd		(rent_l_cd);
			fee_scd.setFee_tm		(String.valueOf(max_fee_tm+1));			
			fee_scd.setRent_st		(rent_st);					//신차/연장
			fee_scd.setTm_st2		("0");						//0-일반대여료 (1-회차연장)						
			fee_scd.setRent_seq		("1");			
			fee_scd.setTm_st1		("0");						//0-월대여료 (1~잔액)
			fee_scd.setRc_yn		("0");						//0-미수금
			fee_scd.setUpdate_id		(user_id);				
			fee_scd.setUse_s_dt		(f_use_start_dt);				//1회차 사용기간 시작일
			fee_scd.setUse_e_dt		(f_use_end_dt);					//1회차 사용기간 종료일
			fee_scd.setFee_est_dt		(f_fee_est_dt);					//1회차 납입일								
			fee_scd.setFee_s_amt		(fee_rm.getT_fee_s_amt());	//1회차 대여료
			fee_scd.setFee_v_amt		(fee_rm.getT_fee_v_amt());	//1회차 대여료													
			fee_scd.setTax_out_dt		(fee_scd.getFee_est_dt());
			fee_scd.setR_fee_est_dt		(af_db.getValidDt(fee_scd.getFee_est_dt()));
			fee_scd.setReq_dt		(fee_scd.getFee_est_dt());
			fee_scd.setR_req_dt		(fee_scd.getFee_est_dt());
			
				
			if(!af_db.insertFeeScd(fee_scd)) i_flag4 += 1;
			
			
			cms_fee_scd = fee_scd;
								
				
				
		//최초결제방식-1개월치이거나 여러회차일때
		}else{		
		
			f_use_end_dt = c_db.addMonth(f_use_start_dt, 1);				
			f_use_end_dt = c_db.addDay(f_use_end_dt, -1);
				
			String r_use_end_dt 	= "";
			int count1 = 0;
				
			int r_t_fee_s_amt = 0;
			int r_t_fee_v_amt = 0;				
	
			for(int i = max_fee_tm ; i < i_fee_pay_tm+max_fee_tm ; i++){
				
				FeeScdBean fee_scd = new FeeScdBean();
					
				
				fee_scd.setRent_mng_id		(rent_mng_id);
				fee_scd.setRent_l_cd		(rent_l_cd);
				fee_scd.setFee_tm		(String.valueOf(i+1));			
				fee_scd.setRent_st		(rent_st);					//신차/연장
				fee_scd.setTm_st2		("0");						//0-일반대여료 (1-회차연장)						
				fee_scd.setRent_seq		("1");			
				fee_scd.setTm_st1		("0");						//0-월대여료 (1~잔액)
				fee_scd.setRc_yn		("0");						//0-미수금
				fee_scd.setUpdate_id		(user_id);
					
				
				//1회차---------------------------------------------------------------------------------------------
				if(i == max_fee_tm){				
			
					fee_scd.setUse_s_dt		(f_use_start_dt);			//1회차 사용기간 시작일
					fee_scd.setUse_e_dt		(f_use_end_dt);				//1회차 사용기간 종료일
					fee_scd.setFee_est_dt		(f_fee_est_dt);				//1회차 납입일								
					fee_scd.setFee_s_amt		(fee.getFee_s_amt());			//1회차 대여료
					fee_scd.setFee_v_amt		(fee.getFee_v_amt());			//1회차 대여료													
										
				}else{
					
					//2회차 기간시작일은 전회차 다음날로 한다.
					fee_scd.setUse_s_dt		(c_db.addDay(r_use_end_dt, 1));				
					fee_scd.setUse_e_dt		(c_db.addMonth(f_use_end_dt, count1));
					fee_scd.setFee_est_dt		(c_db.addMonth(f_fee_est_dt, count1));
					fee_scd.setFee_s_amt		(fee.getFee_s_amt());
					fee_scd.setFee_v_amt		(fee.getFee_v_amt());
					
					//마지막회차이면
					if(i == (i_fee_pay_tm+max_fee_tm-1)){
						fee_scd.setUse_e_dt		(fee.getRent_end_dt());
												
						if(AddUtil.parseInt(AddUtil.replace(fee_scd.getUse_e_dt(),"-","")) <= AddUtil.parseInt(AddUtil.replace(fee_scd.getFee_est_dt(),"-",""))){
							fee_scd.setFee_est_dt		(fee_scd.getUse_s_dt());								
						}
						
						fee_scd.setFee_s_amt		(fee_rm.getT_fee_s_amt()-r_t_fee_s_amt);
						fee_scd.setFee_v_amt		(fee_rm.getT_fee_v_amt()-r_t_fee_v_amt);
							
					}
				}

				fee_scd.setTax_out_dt		(fee_scd.getFee_est_dt());
				fee_scd.setR_fee_est_dt		(af_db.getValidDt(fee_scd.getFee_est_dt()));
				fee_scd.setReq_dt		(fee_scd.getFee_est_dt());
				fee_scd.setR_req_dt		(fee_scd.getFee_est_dt());
					
					
				if(!af_db.insertFeeScd(fee_scd)) i_flag4 += 1;
					
					
				r_use_end_dt 		= fee_scd.getUse_e_dt();
				count1++;
					
				r_t_fee_s_amt 		= r_t_fee_s_amt + fee_scd.getFee_s_amt();
				r_t_fee_v_amt 		= r_t_fee_v_amt + fee_scd.getFee_v_amt();					
				
				
				cms_fee_scd = fee_scd;
					
					
			}
		}
		
	}
	
	
	
	//20151201 자동이체 미신청상태라면 자동이체 신청 처리해야함.
	
	//cms_mng
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	
	//무통장제외하고 자동이체
	if(max_fee_tm ==1 && !f_fee.getFee_pay_st().equals("2")){
	
		if(!cms.getCms_acc_no().equals("") && cms.getApp_dt().equals("")){
			
			if(cms.getCms_start_dt().equals("")){								
				cms.setCms_start_dt	(cms_fee_scd.getFee_est_dt());	
				if(cms.getCms_start_dt().length()==8)	 	cms.setCms_day(cms.getCms_start_dt().substring(6,8));
				if(cms.getCms_start_dt().length()==10) 		cms.setCms_day(cms.getCms_start_dt().substring(8,10));

			}
						
			cms.setApp_dt(AddUtil.getDate());
			cms.setApp_id(user_id);
			cms.setUpdate_id(user_id);
			//=====[cms_mng] update=====
			flag7 = a_db.updateContCmsMng(cms);
				
		}
			

		if(!cms.getCms_acc_no().equals("") && !cms.getApp_dt().equals("") && cms.getCms_start_dt().equals("") && !cms_fee_scd.getFee_est_dt().equals("")){
												
			cms.setCms_start_dt	(cms_fee_scd.getFee_est_dt());	
			if(cms.getCms_start_dt().length()==8)	 	cms.setCms_day(cms.getCms_start_dt().substring(6,8));
			if(cms.getCms_start_dt().length()==10) 		cms.setCms_day(cms.getCms_start_dt().substring(8,10));

			cms.setUpdate_id(user_id);
			//=====[cms_mng] update=====
			flag7 = a_db.updateContCmsMng(cms);

		}		
	}
	

	
%>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type="hidden" name="rent_st" 			value="<%=rent_st%>">    
  <input type="hidden" name="c_st" 			value="fee">
  <input type="hidden" name="now_stat" 			value="연장">      
</form>
<script language='javascript'>
	var fm = document.form1;

	
<%		if(!flag2){	%>
		alert('계약기본정보 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag5){	%>
		alert('대여정보 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag6){	%>
		alert('선수금스케줄 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

<%		if(!flag1){	%>
		alert('대여기타정보 등록 에러입니다.\n\n확인하십시오');
<%		}	%>		

	fm.action = 'lc_c_frame.jsp';	
	fm.target = 'd_content';
	fm.submit();

</script>
</body>
</html>