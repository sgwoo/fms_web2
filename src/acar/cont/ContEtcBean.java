package acar.cont;

public class ContEtcBean
{

	private String rent_mng_id			= "";    
	private String rent_l_cd			= "";
	private String mng_br_id			= "";
	private String bus_agnt_id			= "";    
	private String rec_st				= "";    
	private String ele_tax_st			= "";    
	private String tax_extra			= "";    
	private String sanction_st			= "";    
	private String assest_seq			= "";
	private String fin_seq				= "";
	private String client_guar_st		= "";
	private String guar_st				= "";
	private String guar_con				= "";
	private String guar_sac_id			= "";
	private String dec_gr				= "";
	private String dec_f_id				= "";
	private String dec_f_dt				= "";    
	private String dec_m_id				= "";
	private String dec_l_id				= "";
	private String dec_l_dt				= "";
	private String insur_per			= "";    
	private String canoisr_yn			= "";    
	private String cacdt_yn				= "";    
	private String eme_yn				= "";    
	private String ja_reason			= "";    
	private String rea_appr_id			= "";
	private String air_ds_yn			= "";
	private String air_as_yn			= "";
	private String air_cu_yn			= "";
	private String auto_yn				= "";
	private String abs_yn				= "";
	private String rob_yn				= "";    
	private String sp_car_yn			= "";
	private String ac_dae_yn			= "";
	private String pro_yn				= "";
	private String cyc_yn				= "";
	private String main_yn				= "";
	private String ma_dae_yn			= "";
	private String ip_insur				= "";
	private String ip_agent				= "";
	private String ip_dam				= "";
	private String ip_tel				= "";
	private String dec_etc				= "";
	private String guar_est_dt			= "";
	private String guar_etc				= "";
	private String guar_end_st			= "";
	//계약승계관련
	public  int    rent_suc_commi		= 0;
	private String rent_suc_dt			= "";
	private String car_deli_dt			= "";
	private String rent_suc_grt_yn		= "";
	//20100309 대차계약 기존계약보증금 승계관련
	private String grt_suc_m_id			= "";	
	private String grt_suc_l_cd			= "";	
	private String grt_suc_c_no			= "";	
	private int    grt_suc_o_amt		= 0;	
	private int    grt_suc_r_amt		= 0;
	//20101028 승계계약 기존계약관련
	private String rent_suc_m_id		= "";	
	private String rent_suc_l_cd		= "";	
	private String rent_suc_fee_tm		= "";	
	//20110117 차량이용지역
	private String est_area				= "";	
	//20110217 차량손해 정율 관련
	private int    cacdt_me_amt			= 0;	
	private int    cacdt_memin_amt		= 0;	
	private int    cacdt_mebase_amt		= 0;	
	//20110414 계약승계수수료부담자구분
	private String rent_suc_commi_pay_st= "";
	//20111219 계약승계일자계산기준일
	private String rent_suc_fee_tm_b_dt	= "";	
	//20130107 개시전차종변경여부
	private String car_cng_yn			= "";	
	//20130718 수입차캐쉬백입금일자
	private String cash_back_pay_dt		= "";	
	private int    cash_back_pay_amt	= 0;	
	//20140217 차량이용지역(구군)
	private String county				= "";	
	//계약승계 당시 계약구분
	private String suc_rent_st			= "";	
	//20140530 블랙박스여부
	private String blackbox_yn			= "";	
	//20150224 승계수수료감면여부
	private String rent_suc_exem_cau	= "";	
	private String rent_suc_exem_id		= "";	
	//20150625 보험계약자여부
	private String insurant				= "";    
	//20150914 승계루트
	private String rent_suc_route		= "";
	//20160113 승계시점주행거리
	public  int    rent_suc_dist		= 0;
	//20160215 대표 공동임차
	private String client_share_st		= "";
	//20160222 신용평가 적요
	private String eval_etc				= "";
	//20160323 임직원운전한정특약
	private String com_emp_yn			= "";
	//20160426 임직원운전한정특약 미가입 승인자
	private String com_emp_sac_id		= "";
	private String com_emp_sac_dt		= "";
	//20161111 스마트견적관리번호
	private String spe_est_id			= "";
	//20171110 차선이탈(제어형)
	private String lkas_yn				= "";
	//20171110 차선이탈(경고형)
	private String ldws_yn				= "";
	//20171110 긴급제동(제어형)	
	private String aeb_yn				= "";
	//20171110 긴급제동(경고형)
	private String fcw_yn				= "";
	//20200331 가니쉬
	private String garnish_yn			= "";
	//20200602 견인고리
	private String hook_yn				= "";
	//20200706 버률비용지원금
	private String legal_yn				= "";
	//20171110 전기자동차(이동형충전기 사용여부)
	private String ev_yn				= "";
	//20171204 출고보전수당 지급여부
	private String dlv_con_commi_yn		= "";
	//20180309 차량이용지역 주소
	private String car_use_addr			= "";
	//20180724 담당자배정방식
	private String mng_type 			= "";
	//20180823 해지비고
	private String cls_etc 				= "";
	//20190308 수입차금융비용 일자
	private String im_bank_pay_dt		= "";	
	//20190603 특판출고 실적이관가능여부 
	private String dir_pur_commi_yn		= "";
	//20190911 계약서상 제조사 할인후 차량가격 표기 
	private int view_car_dc				= 0;
	public String others_device			="";		//20191202 기타장치 
	private String car_deli_est_dt		= ""; //20200414 차량인도예정일(재리스)
	//20200519
	private String rent_suc_pp_yn		= "";
	private int    pp_suc_o_amt			= 0;	
	private int    pp_suc_r_amt			= 0;
	private String rent_suc_ifee_yn		= "";
	private int    ifee_suc_o_amt		= 0;	
	private int    ifee_suc_r_amt		= 0;
	private String n_mon				= "";
	private String n_day				= "";
	private String top_cng_yn			= "";		//20220922 탑차(구조변경)

	
	// CONSTRCTOR   	
	public ContEtcBean()
	{
			rent_mng_id					= "";    
			rent_l_cd					= "";
			mng_br_id					= "";
			bus_agnt_id					= "";    
			rec_st						= "";    
			ele_tax_st					= "";    
			tax_extra					= "";    
			sanction_st					= "";    
			assest_seq					= "";
			fin_seq						= "";
			client_guar_st				= "";
			guar_st						= "";
			guar_con					= "";
			guar_sac_id					= "";
			dec_gr						= "";
			dec_f_id					= "";
			dec_f_dt					= "";    
			dec_m_id					= "";
			dec_l_id					= "";
			dec_l_dt					= "";
			insur_per					= "";    
			canoisr_yn					= "";    
			cacdt_yn					= "";    
			eme_yn						= "";    
			ja_reason					= "";    
			rea_appr_id					= "";
			air_ds_yn					= "";
			air_as_yn					= "";
			air_cu_yn					= "";
			auto_yn						= "";
			abs_yn						= "";
			rob_yn						= "";    
			sp_car_yn					= "";
			ac_dae_yn					= "";
			pro_yn						= "";
			cyc_yn						= "";
			main_yn						= "";
			ma_dae_yn					= "";
			ip_insur					= "";
			ip_agent					= "";
			ip_dam						= "";
			ip_tel						= "";
			dec_etc						= "";
			guar_est_dt					= "";
			guar_etc					= "";
			guar_end_st					= "";
			rent_suc_commi				= 0; 
			rent_suc_dt					= ""; 		
			grt_suc_m_id				= "";
			grt_suc_l_cd				= "";
			grt_suc_c_no				= "";
			grt_suc_o_amt				= 0;
			grt_suc_r_amt				= 0;
			car_deli_dt					= "";
			rent_suc_grt_yn				= "";
			rent_suc_m_id				= "";
			rent_suc_l_cd				= "";
			rent_suc_fee_tm				= "";
			est_area					= "";
			cacdt_me_amt				= 0;
			cacdt_memin_amt				= 0;
			cacdt_mebase_amt			= 0;
			rent_suc_commi_pay_st		= "";
			rent_suc_fee_tm_b_dt		= "";
			car_cng_yn					= "";
			cash_back_pay_dt			= "";
			cash_back_pay_amt			= 0;
			county						= "";
			suc_rent_st					= "";
			blackbox_yn					= "";
			rent_suc_exem_cau			= "";
			rent_suc_exem_id			= "";
			insurant					= "";
			rent_suc_route				= "";
			rent_suc_dist				= 0; 
			client_share_st				= "";
			eval_etc					= "";
			com_emp_yn					= "";
			com_emp_sac_id				= "";
			com_emp_sac_dt				= "";
			spe_est_id					= "";
			lkas_yn						= "";
			ldws_yn						= "";
			aeb_yn						= "";
			fcw_yn						= "";
			garnish_yn					= "";
			hook_yn						= "";
			legal_yn					= "";
			ev_yn						= "";
			dlv_con_commi_yn			= "";
			car_use_addr				= "";
			mng_type					= "";
			cls_etc						= "";
			im_bank_pay_dt				= "";
			dir_pur_commi_yn			= "";
			view_car_dc 				= 0;
			others_device				="";
			car_deli_est_dt				= "";
			rent_suc_pp_yn				= "";
			pp_suc_o_amt				= 0;	
			pp_suc_r_amt				= 0;
			rent_suc_ifee_yn			= "";
			ifee_suc_o_amt				= 0;	
			ifee_suc_r_amt				= 0;
			n_mon						= "";
			n_day						= "";
			top_cng_yn 					= "";
	}
		
	//Set Method
	public void setRent_mng_id				(String str) 	{	if(str==null) str="";	rent_mng_id						= str;	}
	public void setRent_l_cd				(String str)	{	if(str==null) str="";	rent_l_cd						= str;	}
	public void setMng_br_id				(String str)	{	if(str==null) str="";	mng_br_id						= str;	}		
	public void setBus_agnt_id				(String str)	{	if(str==null) str="";	bus_agnt_id						= str;	}    
	public void setRec_st					(String str)	{	if(str==null) str="";	rec_st							= str;	}    	
	public void setEle_tax_st				(String str)	{	if(str==null) str="";	ele_tax_st						= str;	}    	
	public void setTax_extra				(String str)	{	if(str==null) str="";	tax_extra						= str;	}    		
	public void setSanction_st				(String str)	{	if(str==null) str="";	sanction_st						= str;	}    		
	public void setAssest_seq				(String str)	{	if(str==null) str="";	assest_seq						= str;	} 
	public void setFin_seq					(String str)	{	if(str==null) str="";	fin_seq							= str;	}    		
	public void setClient_guar_st			(String str)	{	if(str==null) str="";	client_guar_st					= str;	}		
	public void setGuar_st					(String str)	{	if(str==null) str="";	guar_st							= str;	}		
	public void setGuar_con					(String str)	{	if(str==null) str="";	guar_con						= str;	}		
	public void setGuar_sac_id				(String str)	{	if(str==null) str="";	guar_sac_id						= str;	}		
	public void setDec_gr					(String str)	{	if(str==null) str="";	dec_gr							= str;	}
	public void setDec_f_id					(String str)	{	if(str==null) str="";	dec_f_id						= str;	}    	
	public void setDec_f_dt					(String str) 	{	if(str==null) str="";	dec_f_dt						= str;	}
	public void setDec_m_id					(String str)	{	if(str==null) str="";	dec_m_id						= str;	}
	public void setDec_l_id					(String str)	{	if(str==null) str="";	dec_l_id						= str;	}	
	public void setDec_l_dt					(String str)	{	if(str==null) str="";	dec_l_dt						= str;	}		
	public void setInsur_per				(String str)	{	if(str==null) str="";	insur_per						= str;	}    
	public void setCanoisr_yn				(String str)	{	if(str==null) str="";	canoisr_yn						= str;	}    	
	public void setCacdt_yn					(String str)	{	if(str==null) str="";	cacdt_yn						= str;	}    	
	public void setEme_yn					(String str)	{	if(str==null) str="";	eme_yn							= str;	}    		
	public void setJa_reason				(String str)	{	if(str==null) str="";	ja_reason						= str;	}    		
	public void setRea_appr_id				(String str)	{	if(str==null) str="";	rea_appr_id						= str;	}    		
	public void setAir_ds_yn				(String str)	{	if(str==null) str="";	air_ds_yn						= str;	}		
	public void setAir_as_yn				(String str)	{	if(str==null) str="";	air_as_yn						= str;	}		
	public void setAir_cu_yn				(String str)	{	if(str==null) str="";	air_cu_yn						= str;	}		
	public void setAuto_yn					(String str)	{	if(str==null) str="";	auto_yn							= str;	}
	public void setAbs_yn					(String str)	{	if(str==null) str="";	abs_yn							= str;	}    	
	public void setRob_yn					(String str) 	{	if(str==null) str="";	rob_yn							= str;	}
	public void setSp_car_yn				(String str)	{	if(str==null) str="";	sp_car_yn						= str;	}
	public void setAc_dae_yn				(String str)	{	if(str==null) str="";	ac_dae_yn						= str;	}		
	public void setPro_yn					(String str)	{	if(str==null) str="";	pro_yn							= str;	}    
	public void setCyc_yn					(String str)	{	if(str==null) str="";	cyc_yn							= str;	}    	
	public void setMain_yn					(String str)	{	if(str==null) str="";	main_yn							= str;	}    	
	public void setMa_dae_yn				(String str)	{	if(str==null) str="";	ma_dae_yn						= str;	}    		
	public void setIp_insur					(String str)	{	if(str==null) str="";	ip_insur						= str;	}    		
	public void setIp_agent					(String str)	{	if(str==null) str="";	ip_agent						= str;	}    		
	public void setIp_dam					(String str)	{	if(str==null) str="";	ip_dam							= str;	}		
	public void setIp_tel					(String str)	{	if(str==null) str="";	ip_tel							= str;	}		
	public void setDec_etc					(String str)	{	if(str==null) str="";	dec_etc							= str;	}
	public void setGuar_est_dt				(String str)	{	if(str==null) str="";	guar_est_dt						= str;	}		
	public void setGuar_etc					(String str)	{	if(str==null) str="";	guar_etc						= str;	}		
	public void setGuar_end_st				(String str)	{	if(str==null) str="";	guar_end_st						= str;	}		
	public void setRent_suc_commi			(int i)			{							rent_suc_commi					= i;	}
	public void setRent_suc_dt				(String str)	{	if(str==null) str="";	rent_suc_dt						= str;	}		
	public void setGrt_suc_m_id				(String str)	{	if(str==null) str="";	grt_suc_m_id					= str;	}		
	public void setGrt_suc_l_cd				(String str)	{	if(str==null) str="";	grt_suc_l_cd					= str;	}		
	public void setGrt_suc_c_no				(String str)	{	if(str==null) str="";	grt_suc_c_no					= str;	}		
	public void setGrt_suc_o_amt			(int i)			{							grt_suc_o_amt					= i;	}
	public void setGrt_suc_r_amt			(int i)			{							grt_suc_r_amt					= i;	}
	public void setCar_deli_dt				(String str)	{	if(str==null) str="";	car_deli_dt						= str;	}		
	public void setRent_suc_grt_yn			(String str)	{	if(str==null) str="";	rent_suc_grt_yn					= str;	}		
	public void setRent_suc_m_id			(String str)	{	if(str==null) str="";	rent_suc_m_id					= str;	}		
	public void setRent_suc_l_cd			(String str)	{	if(str==null) str="";	rent_suc_l_cd					= str;	}		
	public void setRent_suc_fee_tm			(String str)	{	if(str==null) str="";	rent_suc_fee_tm					= str;	}		
	public void setEst_area					(String str)	{	if(str==null) str="";	est_area						= str;	}
	public void setCacdt_me_amt				(int i)			{							cacdt_me_amt					= i;	}
	public void setCacdt_memin_amt			(int i)			{							cacdt_memin_amt					= i;	}
	public void setCacdt_mebase_amt			(int i)			{							cacdt_mebase_amt				= i;	}
	public void setRent_suc_commi_pay_st	(String str)	{	if(str==null) str="";	rent_suc_commi_pay_st			= str;	}		
	public void setRent_suc_fee_tm_b_dt		(String str)	{	if(str==null) str="";	rent_suc_fee_tm_b_dt			= str;	}		
	public void setCar_cng_yn				(String str)	{	if(str==null) str="";	car_cng_yn						= str;	}		
	public void setCash_back_pay_dt			(String str)	{	if(str==null) str="";	cash_back_pay_dt				= str;	}
	public void setCash_back_pay_amt		(int i)			{							cash_back_pay_amt				= i;	}
	public void setCounty					(String str)	{	if(str==null) str="";	county							= str;	}
	public void setSuc_rent_st				(String str)	{	if(str==null) str="";	suc_rent_st						= str;	}
	public void setBlackbox_yn				(String str)	{	if(str==null) str="";	blackbox_yn						= str;	}
	public void setRent_suc_exem_cau		(String str)	{	if(str==null) str="";	rent_suc_exem_cau				= str;	}		
	public void setRent_suc_exem_id			(String str)	{	if(str==null) str="";	rent_suc_exem_id				= str;	}		
	public void setInsurant					(String str)	{	if(str==null) str="";	insurant						= str;	}		
	public void setRent_suc_route			(String str)	{	if(str==null) str="";	rent_suc_route					= str;	}	
	public void setRent_suc_dist			(int i)			{							rent_suc_dist					= i;	}
	public void setClient_share_st			(String str)	{	if(str==null) str="";	client_share_st					= str;	}		
	public void setEval_etc					(String str)	{	if(str==null) str="";	eval_etc						= str;	}		
	public void setCom_emp_yn				(String str)	{	if(str==null) str="";	com_emp_yn						= str;	}		
	public void setCom_emp_sac_id			(String str)	{	if(str==null) str="";	com_emp_sac_id					= str;	}		
	public void setCom_emp_sac_dt			(String str)	{	if(str==null) str="";	com_emp_sac_dt					= str;	}		
	public void setSpe_est_id				(String str)	{	if(str==null) str="";	spe_est_id						= str;	}		
	public void setLkas_yn					(String str)	{	if(str==null) str="";	lkas_yn							= str;	}		
	public void setLdws_yn					(String str)	{	if(str==null) str="";	ldws_yn							= str;	}		
	public void setAeb_yn					(String str)	{	if(str==null) str="";	aeb_yn							= str;	}		
	public void setFcw_yn					(String str)	{	if(str==null) str="";	fcw_yn							= str;	}		
	public void setGarnish_yn				(String str)	{	if(str==null) str="";	garnish_yn						= str;	}
	public void setHook_yn					(String str)	{	if(str==null) str="";	hook_yn						= str;	}
	public void setLegal_yn					(String str)	{	if(str==null) str="";	legal_yn						= str;	}
	public void setEv_yn					(String str)	{	if(str==null) str="";	ev_yn							= str;	}		
	public void setDlv_con_commi_yn			(String str)	{	if(str==null) str="";	dlv_con_commi_yn				= str;	}
	public void setCar_use_addr				(String str)	{	if(str==null) str="";	car_use_addr					= str;	}
	public void setMng_type					(String str)	{	if(str==null) str="";	mng_type						= str;	}
	public void setCls_etc					(String str)	{	if(str==null) str="";	cls_etc 						= str;	}
	public void setIm_bank_pay_dt			(String str)	{	if(str==null) str="";	im_bank_pay_dt					= str;	}
	public void setDir_pur_commi_yn			(String str)	{	if(str==null) str="";	dir_pur_commi_yn				= str;	}
	public void setView_car_dc				(int i)			{							view_car_dc						= i;	}
	public void setOthers_device			(String str)	{	if(str==null) str="";	others_device					= str;	}
	public void setCar_deli_est_dt			(String str)	{	if(str==null) str="";	car_deli_est_dt					= str;	}	
	public void setRent_suc_pp_yn			(String str)	{	if(str==null) str="";	rent_suc_pp_yn					= str;	}		
	public void setPp_suc_o_amt				(int i)			{							pp_suc_o_amt					= i;	}
	public void setPp_suc_r_amt				(int i)			{							pp_suc_r_amt					= i;	}
	public void setRent_suc_ifee_yn			(String str)	{	if(str==null) str="";	rent_suc_ifee_yn				= str;	}		
	public void setIfee_suc_o_amt			(int i)			{							ifee_suc_o_amt					= i;	}
	public void setIfee_suc_r_amt			(int i)			{							ifee_suc_r_amt					= i;	}
	public void setN_mon					(String str)	{	if(str==null) str="";	n_mon							= str;	}
	public void setN_day					(String str)	{	if(str==null) str="";	n_day							= str;	}
	public void setTop_cng_yn				(String str)	{	if(str==null) str="";	top_cng_yn						= str;	}
	
	

	
	//Get Method	
	public String getRent_mng_id					()	{	return rent_mng_id;						}
	public String getRent_l_cd						()	{	return rent_l_cd;						}
	public String getMng_br_id						()	{	return mng_br_id;						}
	public String getBus_agnt_id					()	{	return bus_agnt_id;						}
	public String getRec_st							()	{	return rec_st;							}
	public String getEle_tax_st						()	{	return ele_tax_st;						}
	public String getTax_extra						()	{	return tax_extra;						}
	public String getSanction_st					()	{	return sanction_st;						}
	public String getAssest_seq						()	{	return assest_seq;						}
	public String getFin_seq						()	{	return fin_seq;							}
	public String getClient_guar_st					()	{	return client_guar_st;					}
	public String getGuar_st						()	{	return guar_st;							}
	public String getGuar_con						()	{	return guar_con;						}
	public String getGuar_sac_id					()	{	return guar_sac_id;						}
	public String getDec_gr							()	{	return dec_gr;							}
	public String getDec_f_id						()	{	return dec_f_id;						}
	public String getDec_f_dt						()	{	return dec_f_dt;						}
	public String getDec_m_id						()	{	return dec_m_id;						}
	public String getDec_l_id						()	{	return dec_l_id;						}
	public String getDec_l_dt						()	{	return dec_l_dt;						}
	public String getInsur_per						()	{	return insur_per;						}
	public String getCanoisr_yn						()	{	return canoisr_yn;						}
	public String getCacdt_yn						()	{	return cacdt_yn;						}
	public String getEme_yn							()	{	return eme_yn;							}
	public String getJa_reason						()	{	return ja_reason;						}
	public String getRea_appr_id					()	{	return rea_appr_id;						}
	public String getAir_ds_yn						()	{	return air_ds_yn;						}
	public String getAir_as_yn						()	{	return air_as_yn;						}
	public String getAir_cu_yn						()	{	return air_cu_yn;						}
	public String getAuto_yn						()	{	return auto_yn;							}
	public String getAbs_yn							()	{	return abs_yn;							}
	public String getRob_yn							()	{	return rob_yn;							}
	public String getSp_car_yn						()	{	return sp_car_yn;						}
	public String getAc_dae_yn						()	{	return ac_dae_yn;						}
	public String getPro_yn							()	{	return pro_yn;							}	
	public String getCyc_yn							()	{	return cyc_yn;							}
	public String getMain_yn						()	{	return main_yn;							}
	public String getMa_dae_yn						()	{	return ma_dae_yn;						}
	public String getIp_insur						()	{	return ip_insur;						}
	public String getIp_agent						()	{	return ip_agent;						}
	public String getIp_dam							()	{	return ip_dam;							}
	public String getIp_tel							()	{	return ip_tel;							}
	public String getDec_etc						()	{	return dec_etc;							}
	public String getGuar_est_dt					()	{	return guar_est_dt;						}
	public String getGuar_etc						()	{	return guar_etc;						}
	public String getGuar_end_st					()	{	return guar_end_st;						}
	public int    getRent_suc_commi					()	{  return rent_suc_commi;					}
	public String getRent_suc_dt					()	{	return rent_suc_dt;						}
	public String getGrt_suc_m_id					()	{	return grt_suc_m_id;					}
	public String getGrt_suc_l_cd					()	{	return grt_suc_l_cd;					}
	public String getGrt_suc_c_no					()	{	return grt_suc_c_no;					}
	public int    getGrt_suc_o_amt					()	{  return grt_suc_o_amt;					}
	public int    getGrt_suc_r_amt					()	{  return grt_suc_r_amt;					}
	public String getCar_deli_dt					()	{	return car_deli_dt;						}
	public String getRent_suc_grt_yn				()	{	return rent_suc_grt_yn;					}
	public String getRent_suc_m_id					()	{	return rent_suc_m_id;					}
	public String getRent_suc_l_cd					()	{	return rent_suc_l_cd;					}
	public String getRent_suc_fee_tm				()	{	return rent_suc_fee_tm;					}
	public String getEst_area						()	{	return est_area;						}
	public int    getCacdt_me_amt					()	{  return cacdt_me_amt;						}
	public int    getCacdt_memin_amt				()	{  return cacdt_memin_amt;					}
	public int    getCacdt_mebase_amt				()	{  return cacdt_mebase_amt;					}
	public String getRent_suc_commi_pay_st			()	{	return rent_suc_commi_pay_st;			}
	public String getRent_suc_fee_tm_b_dt			()	{	return rent_suc_fee_tm_b_dt;			}
	public String getCar_cng_yn						()	{	return car_cng_yn;						}
	public String getCash_back_pay_dt				()	{	return cash_back_pay_dt;				}
	public int    getCash_back_pay_amt				()	{  return cash_back_pay_amt;				}
	public String getCounty							()	{	return county;							}
	public String getSuc_rent_st					()	{	return suc_rent_st;						}
	public String getBlackbox_yn					()	{	return blackbox_yn;						}
	public String getRent_suc_exem_cau				()	{	return rent_suc_exem_cau;				}
	public String getRent_suc_exem_id				()	{	return rent_suc_exem_id;				}
	public String getInsurant						()	{	return insurant;						}
	public String getRent_suc_route					()	{	return rent_suc_route;					}
	public int    getRent_suc_dist					()	{  return rent_suc_dist;					}
	public String getClient_share_st				()	{	return client_share_st;					}
	public String getEval_etc						()	{	return eval_etc;						}
	public String getCom_emp_yn						()	{	return com_emp_yn;						}
	public String getCom_emp_sac_id					()	{	return com_emp_sac_id;					}
	public String getCom_emp_sac_dt					()	{	return com_emp_sac_dt;					}
	public String getSpe_est_id						()	{	return spe_est_id;						}
	public String getLkas_yn						()	{	return lkas_yn;							}		
	public String getLdws_yn						()	{	return ldws_yn;							}		
	public String getAeb_yn							()	{	return aeb_yn;							}		
	public String getFcw_yn							()	{	return fcw_yn;							}		
	public String getGarnish_yn						()	{	return garnish_yn;						}
	public String getHook_yn						()	{	return hook_yn;							}
	public String getLegal_yn						()	{	return legal_yn;						}
	public String getEv_yn							()	{	return ev_yn;							}
	public String getDlv_con_commi_yn				()	{	return dlv_con_commi_yn;				}
	public String getCar_use_addr					()	{	return car_use_addr;					}
	public String getMng_type						()	{	return mng_type;						}
	public String getCls_etc						()	{	return cls_etc;							}
	public String getIm_bank_pay_dt					()	{	return im_bank_pay_dt;					}
	public String getDir_pur_commi_yn				()	{	return dir_pur_commi_yn;				}
	public int    getView_car_dc					()	{  return view_car_dc;						}
	public String getOthers_device					()	{	return others_device;					}
	public String getCar_deli_est_dt				()	{	return car_deli_est_dt;					}
	public String getRent_suc_pp_yn					()	{	return rent_suc_pp_yn;					}		
	public int    getPp_suc_o_amt					()	{	return pp_suc_o_amt;					}
	public int    getPp_suc_r_amt					()	{	return pp_suc_r_amt;					}
	public String getRent_suc_ifee_yn				()	{	return rent_suc_ifee_yn;				}		
	public int    getIfee_suc_o_amt					()	{	return ifee_suc_o_amt;					}
	public int    getIfee_suc_r_amt					()	{	return ifee_suc_r_amt;					}
	public String getN_mon							()	{	return n_mon;							}
	public String getN_day							()	{	return n_day;							}
	public String getTop_cng_yn						()	{	return top_cng_yn;						}
	
		
}