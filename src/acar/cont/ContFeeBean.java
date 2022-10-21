package acar.cont;

public class ContFeeBean
{
	
	private String rent_mng_id;		// 계약관리번호             
	private String rent_l_cd;		// 계약번호                 
	private String rent_st;			// 구분                     
	private String rent_way;		// 대여방식                 
	private String car_st;			// 차량구분                 
	private String con_mon;			// 대여개월                 
	private String rent_start_dt;	// 대여개시일               
	private String rent_end_dt;		// 대여종료일               
	private String prv_dlv_yn;		// 출고전대차여부           
	private String prv_car_mng_id;	// 출고전대차_자동차관리번호
	private String prv_start_dt;	// 출고전대차_시작일        
	private String prv_end_dt;		// 출고전대차_종료일        
	private int    grt_amt_s;		// 보증금_금액              
	private String grt_etc;			// 보증금_특이사항          
	private String grt_est_dt;		// 보증금_입금예정일        
	private String grt_pay_yn;		// 보증금_입금여부          
	private String grt_suc_yn;		// 보증금_입금여부          
	private int    pp_s_amt;		// 선납금_공급가            
	private int    pp_v_amt;		// 선납금_부가세            
	private String pp_etc;			// 선납금_특이사항          
	private String pp_est_dt;		// 선납금_입금예정일        
	private String pp_pay_yn;		// 선납금_입금여부          
	private int    ifee_s_amt;		// 초기대여료_공급가        
	private int    ifee_v_amt;		// 초기대여료_부가세        
	private String ifee_etc;		// 초기대여료_특이사항      
	private String ifee_est_dt;		// 초기대여료_입금예정일    
	private String ifee_pay_yn;		// 초기대여료_입금여부      
	private String ifee_suc_yn;		// 보증금_입금여부          
	private int    inv_s_amt;		// 견적대여료_공급가        
	private int    inv_v_amt;		// 견적대여료_부가세        
	private String inv_etc;			// 견적대여료_특이사항      
	private int    opt_s_amt;		// 매입옵션_공급가          
	private int    opt_v_amt;		// 매입옵션_부가세          
	private String opt_etc;			// 매입옵션_특이사항        
	private String opt_yn;			// 매입옵션_포함여부        
	private int    fee_s_amt;		// 대여료_공급가            
	private int    fee_v_amt;		// 대여료_부가세            
	private String fee_etc;			// 대여료_특이사항          
	private String fee_st;			// 대여료_구분              
	private String fee_req_day;		// 대여료_청구일            
	private String fee_est_day;		// 대여료_납입기준일        
	private String fee_bank;		// 대여료_납입은행          
	private String fee_pay_st;		// 대여료_납입방법          
	private String fee_pay_tm;		// 대여료_납입횟수          
	private String fee_pay_start_dt;//   대여료_납입기간_시작     
	private String fee_pay_end_dt;	//   대여료_납입기간_종료   
	private String fee_fst_dt;		//  대여료_1회차납입일
	private int    fee_fst_amt;		//   대여료_1회차납입금    
	private String fee_cdt;	        // 대여료_조건              
	private String ext_agnt;		// 연장계약담당자           
	/*4/10추가*/	
	private String br_id;			// 지점코드   
	private String rc_day;			// 영수일자 - 1일~31일(말일:99)   
	private String next_yn;			// 익월여부  (default:N , Y:익월)   
	/*10/2추가*/	
	private String opt_chk;			// 매입옵션 체크 (0-없음,1-있음)
	private String fee_sh;			// 납부방식 (0-후불,1-선불)
	/*10/10추가*/
	private String prv_mon_yn;		// 출고전대차기간포함여부
	private String fee_chk;			// 월대여료 납입방식 구분
	//5/16추가
	private String opt_per;			// 매입옵션%
	//2004-01-12 추가
	private String rent_dt;			// 계약일자
	private String rent_est_dt;			// 계약일자
	//20051013추가
	private String leave_day;		// 거치기간
	//20051124추가
	private String cls_per;			// 중도해지위약율%
	//20070710추가
	private float  gur_per;
	private float  gur_p_per;
	private float  pere_per;
	private float  pere_r_per;
	private int    pere_mth;
	private int    pere_r_mth;
	private float  max_ja;
	private float  app_ja;
	private String opt_st;
	private float  dc_ra;
	private String bas_dt;
	private String fee_sac_id;
	private String def_st;
	private String def_remark;
	private String def_sac_id;
	private float  cls_r_per;
	private int    ja_s_amt;
	private int    ja_v_amt;
	private int    ja_r_s_amt;
	private int    ja_r_v_amt;
	private float  credit_per;
	private float  credit_r_per;
	private int    credit_amt;
	private int    credit_r_amt;
	private String rtn_st;
	private float  cls_n_per;
	private String brch_id;
	private float  b_max_ja;
	//20160715
	private String f_opt_per;			//신차대비 매입옵션%
	private String f_gur_p_per;			//신차대비 보증금%
	private String f_pere_r_per;		//신차대비 선납금%
	//20180223
	private int ins_s_amt;			//원보험료
	private int ins_v_amt;			//원보험료 보증금
	private int ins_total_amt;			//원보험료 보증금
	//20180312
	private String pp_chk;			// 선납금 계산서 발행구분


	public ContFeeBean()
	{
		rent_mng_id 	= "";
		rent_l_cd		= "";
		rent_st			= "";
		rent_way		= "";
		car_st			= "";
		con_mon			= "";
		rent_start_dt 	= "";
		rent_end_dt 	= "";
		prv_dlv_yn 		= "";
		prv_car_mng_id 	= "";
		prv_start_dt 	= "";
		prv_end_dt		= "";
		grt_amt_s		= 0;
		grt_etc			= "";
		grt_est_dt		= "";
		grt_pay_yn		= "";
		grt_suc_yn		= "";
		pp_s_amt		= 0;
		pp_v_amt		= 0;
		pp_etc			= "";
		pp_est_dt		= "";
		pp_pay_yn		= "";
		ifee_s_amt		= 0;
		ifee_v_amt		= 0;
		ifee_etc		= "";
		ifee_est_dt 	= "";
		ifee_pay_yn 	= "";
		ifee_suc_yn 	= "";
		inv_s_amt		= 0;
		inv_v_amt		= 0;
		inv_etc			= "";
		opt_s_amt		= 0;
		opt_v_amt		= 0;
		opt_etc			= "";
		opt_yn			= "";
		fee_s_amt		= 0;
		fee_v_amt		= 0;
		fee_etc			= "";
		fee_st			= "";
		fee_req_day 	= "";
		fee_est_day		= "";
		fee_bank		= "";
		fee_pay_st		= "";
		fee_pay_tm		= "";
		fee_pay_start_dt= "";
		fee_pay_end_dt 	= "";	
		fee_fst_dt		= "";
		fee_fst_amt		= 0;
		fee_cdt			= "";
		ext_agnt		= "";
		br_id			= "";	
		rc_day			= "";
		next_yn			= "";
		opt_chk			= "";
		fee_sh			= "";
		prv_mon_yn		= "";
		fee_chk			= "";
		opt_per			= "";
		rent_dt			= "";
		rent_est_dt		= "";
		leave_day		= "";
		cls_per			= "";
		gur_per			= 0;
		gur_p_per		= 0;
		pere_per		= 0;
		pere_r_per		= 0;
		pere_mth		= 0;
		pere_r_mth		= 0;
		max_ja			= 0;
		app_ja			= 0;
		opt_st			= "";
		dc_ra			= 0;
		bas_dt			= "";
		fee_sac_id		= "";
		def_st			= "";
		def_remark		= "";
		def_sac_id		= "";
		cls_r_per		= 0;
		ja_s_amt		= 0;
		ja_v_amt		= 0;
		ja_r_s_amt		= 0;
		ja_r_v_amt		= 0;
		credit_per  	= 0;
		credit_r_per	= 0;
		credit_amt  	= 0;
		credit_r_amt	= 0;
		rtn_st			= "";
		cls_n_per		= 0;
		brch_id			= "";
		b_max_ja		= 0;
		f_opt_per		= "";
		f_gur_p_per		= "";
		f_pere_r_per	= "";
		
		ins_s_amt		= 0;
		ins_v_amt		= 0;
		ins_total_amt		= 0;
		pp_chk			= "";
	}
	

	public void setRent_mng_id		(String str)	{ rent_mng_id		= str;	}
	public void setRent_l_cd		(String str)	{ rent_l_cd			= str;	}
	public void setRent_st			(String str)	{ rent_st			= str;	}
	public void setRent_way			(String str)	{ rent_way			= str;	}
	public void setCar_st			(String str)	{ car_st			= str;	}
	public void setCon_mon			(String str)	{ con_mon			= str;	}
	public void setRent_start_dt	(String str)	{ rent_start_dt		= str;	}
	public void setRent_end_dt		(String str)	{ rent_end_dt		= str;	}
	public void setPrv_dlv_yn		(String str)	{ prv_dlv_yn		= str;	}
	public void setPrv_car_mng_id	(String str)	{ prv_car_mng_id	= str;	}
	public void setPrv_start_dt		(String str)	{ prv_start_dt		= str;	}
	public void setPrv_end_dt		(String str)	{ prv_end_dt		= str;	}
	public void setGrt_amt_s		(int i)			{ grt_amt_s			= i;	}
	public void setGrt_etc			(String str)	{ grt_etc			= str;	}
	public void setGrt_est_dt		(String str)	{ grt_est_dt		= str;	}
	public void setGrt_pay_yn		(String str)	{ grt_pay_yn		= str;	}
	public void setGrt_suc_yn		(String str)	{ grt_suc_yn		= str;	}
	public void setPp_s_amt			(int i)			{ pp_s_amt			= i;	}
	public void setPp_v_amt			(int i)			{ pp_v_amt			= i;	}
	public void setPp_etc			(String str)	{ pp_etc			= str;	}
	public void setPp_est_dt		(String str)	{ pp_est_dt			= str;	}
	public void setPp_pay_yn		(String str)	{ pp_pay_yn			= str;	}
	public void setIfee_s_amt		(int i)			{ ifee_s_amt		= i;	}
	public void setIfee_v_amt		(int i)			{ ifee_v_amt		= i;	}
	public void setIfee_etc			(String str)	{ ifee_etc			= str;	}
	public void setIfee_est_dt		(String str)	{ ifee_est_dt		= str;	}
	public void setIfee_pay_yn		(String str)	{ ifee_pay_yn		= str;	}
	public void setIfee_suc_yn		(String str)	{ ifee_suc_yn		= str;	}
	public void setInv_s_amt		(int i)			{ inv_s_amt			= i;	}
	public void setInv_v_amt		(int i)			{ inv_v_amt			= i;	}
	public void setInv_etc			(String str)	{ inv_etc			= str;	}
	public void setOpt_s_amt		(int i)			{ opt_s_amt			= i;	}
	public void setOpt_v_amt		(int i)			{ opt_v_amt			= i;	}
	public void setOpt_etc			(String str)	{ opt_etc			= str;	}
	public void setOpt_yn			(String str)	{ opt_yn			= str;	}
	public void setFee_s_amt		(int i)			{ fee_s_amt			= i;	}
	public void setFee_v_amt		(int i)			{ fee_v_amt			= i;	}
	public void setFee_etc			(String str)	{ fee_etc			= str;	}
	public void setFee_st			(String str)	{ fee_st			= str;	}
	public void setFee_req_day		(String str)	{ fee_req_day		= str;	}
	public void setFee_est_day		(String str)	{ fee_est_day		= str;	}
	public void setFee_bank			(String str)	{ fee_bank			= str;	}
	public void setFee_pay_st		(String str)	{ fee_pay_st		= str;	}
	public void setFee_pay_tm		(String str)	{ fee_pay_tm		= str;	}
	public void setFee_pay_start_dt	(String str)	{ fee_pay_start_dt	= str;	}
	public void setFee_pay_end_dt	(String str)	{ fee_pay_end_dt	= str;	}
	public void setFee_fst_dt		(String str)	{ fee_fst_dt		= str;	}
	public void setFee_fst_amt		(int i)			{ fee_fst_amt		= i;	}
	public void setFee_cdt			(String str)	{ fee_cdt			= str;	}
	public void setExt_agnt			(String str)	{ ext_agnt			= str;	}
	public void setBr_id			(String str)	{ br_id				= str;	}
	public void setRc_day			(String str)	{ rc_day			= str;	}
	public void setNext_yn			(String str)	{ next_yn			= str;	}
	public void setOpt_chk			(String str)	{ opt_chk			= str;	}
	public void setFee_sh			(String str)	{ fee_sh			= str;	}
	public void setPrv_mon_yn		(String str)	{ prv_mon_yn		= str;	}
	public void setFee_chk			(String str)	{ fee_chk			= str;	}
	public void setOpt_per			(String str)	{ if(str==null) str="";	opt_per		= str;	}
//	public void setOpt_per			(String str)	{ opt_per			= str;	}
	public void setRent_dt			(String str)	{ rent_dt			= str;	}	
	public void setRent_est_dt		(String str)	{ rent_est_dt		= str;	}	
	public void setLeave_day		(String str)	{ leave_day			= str;	}	
	public void setCls_per			(String str)	{ cls_per			= str;	}	
	public void setGur_per			(float i)		{   gur_per			= i;	}
	public void setGur_p_per		(float i)		{   gur_p_per		= i;	}
	public void setPere_per			(float i)		{   pere_per		= i;	}
	public void setPere_r_per		(float i)		{   pere_r_per		= i;	}
	public void setPere_mth			(int i)			{   pere_mth		= i;	}
	public void setPere_r_mth		(int i)			{   pere_r_mth		= i;	}
	public void setMax_ja			(float i)		{   max_ja			= i;	}
	public void setApp_ja			(float i)		{   app_ja			= i;	}
	public void setOpt_st			(String str)	{   opt_st			= str;	}
	public void setDc_ra			(float i)		{	dc_ra			= i;	}
	public void setBas_dt			(String str)	{	bas_dt			= str;	}
	public void setFee_sac_id		(String str)	{	fee_sac_id		= str;	}
	public void setDef_st			(String str)	{	def_st			= str;	}
	public void setDef_remark		(String str)	{	def_remark		= str;	}
	public void setDef_sac_id		(String str)	{	def_sac_id		= str;	}
	public void setCls_r_per		(float i)		{	cls_r_per		= i;	}
	public void setJa_s_amt			(int i)			{	ja_s_amt		= i;	}
	public void setJa_v_amt			(int i)			{	ja_v_amt		= i;	}
	public void setJa_r_s_amt		(int i)			{	ja_r_s_amt		= i;	}
	public void setJa_r_v_amt		(int i)			{	ja_r_v_amt		= i;	}
	public void setCredit_per  		(float i)		{	credit_per  	= i;	}
	public void setCredit_r_per		(float i)		{	credit_r_per	= i;	}
	public void setCredit_amt  		(int i)			{	credit_amt  	= i;	}
	public void setCredit_r_amt		(int i)			{	credit_r_amt	= i;	}
	public void setRtn_st			(String str)	{	rtn_st			= str;	}
	public void setCls_n_per		(float i)		{	cls_n_per		= i;	}
	public void setBrch_id			(String str)	{	brch_id			= str;	}
	public void setB_max_ja			(float i)		{   b_max_ja		= i;	}
	public void setF_opt_per		(String str)	{ if(str==null) str="";	f_opt_per		= str;	}
	public void setF_gur_p_per		(String str)	{ if(str==null) str="";	f_gur_p_per		= str;	}
	public void setF_pere_r_per		(String str)	{ if(str==null) str="";	f_pere_r_per	= str;	}
	public void setIns_s_amt		(int i)			{ 	ins_s_amt		= i;	}
	public void setIns_v_amt		(int i)			{ 	ins_v_amt		= i;	}
	public void setIns_total_amt	(int i)			{ 	ins_total_amt	= i;	}
	public void setPp_chk			(String str)	{	pp_chk			= str;	}	


	public String getRent_mng_id()		{ return rent_mng_id;		}
	public String getRent_l_cd()		{ return rent_l_cd;			}
	public String getRent_st()			{ return rent_st;			}
	public String getRent_way()			{ return rent_way;			}
	public String getCar_st()			{ return car_st;			}
	public String getCon_mon()			{ return con_mon;			}
	public String getRent_start_dt()	{ return rent_start_dt;		}
	public String getRent_end_dt()		{ return rent_end_dt;		}
	public String getPrv_dlv_yn()		{ return prv_dlv_yn;		}
	public String getPrv_car_mng_id()	{ return prv_car_mng_id;	}
	public String getPrv_start_dt()		{ return prv_start_dt;		}
	public String getPrv_end_dt()		{ return prv_end_dt;		}
	public int    getGrt_amt_s()		{ return grt_amt_s;			}
	public String getGrt_etc()			{ return grt_etc;			}
	public String getGrt_est_dt()		{ return grt_est_dt;		}
	public String getGrt_pay_yn()		{ return grt_pay_yn;		}
	public String getGrt_suc_yn()		{ return grt_suc_yn;		}
	public int    getPp_s_amt()			{ return pp_s_amt;			}
	public int    getPp_v_amt()			{ return pp_v_amt;			}
	public String getPp_etc()			{ return pp_etc;			}
	public String getPp_est_dt()		{ return pp_est_dt;			}
	public String getPp_pay_yn()		{ return pp_pay_yn;			}
	public int    getIfee_s_amt()		{ return ifee_s_amt;		}
	public int    getIfee_v_amt()		{ return ifee_v_amt;		}
	public String getIfee_etc()			{ return ifee_etc;			}
	public String getIfee_est_dt()		{ return ifee_est_dt;		}
	public String getIfee_pay_yn()		{ return ifee_pay_yn;		}
	public String getIfee_suc_yn()		{ return ifee_suc_yn;		}
	public int    getInv_s_amt()		{ return inv_s_amt;			}
	public int    getInv_v_amt()		{ return inv_v_amt;			}
	public String getInv_etc()			{ return inv_etc;			}
	public int    getOpt_s_amt()		{ return opt_s_amt;			}
	public int    getOpt_v_amt()		{ return opt_v_amt;			}
	public String getOpt_yn()			{ return opt_yn;			}
	public String getOpt_etc()			{ return opt_etc;			}
	public int    getFee_s_amt()		{ return fee_s_amt;			}
	public int    getFee_v_amt()		{ return fee_v_amt;			}
	public String getFee_etc()			{ return fee_etc;			}
	public String getFee_st()  			{ return fee_st;			}
	public String getFee_req_day()		{ return fee_req_day;		}
	public String getFee_est_day()		{ return fee_est_day;		}
	public String getFee_bank()			{ return fee_bank;			}
	public String getFee_pay_st()		{ return fee_pay_st;		}
	public String getFee_pay_tm()		{ return fee_pay_tm;		}
	public String getFee_pay_start_dt()	{ return fee_pay_start_dt;	}
	public String getFee_pay_end_dt()	{ return fee_pay_end_dt;	}
	public String getFee_fst_dt()		{ return fee_fst_dt;		}
	public int    getFee_fst_amt()		{ return fee_fst_amt;		}
	public String getFee_cdt()			{ return fee_cdt;			}
	public String getExt_agnt()			{ return ext_agnt;			}
	public String getBr_id()			{ return br_id;				}
	public String getRc_day()			{ return rc_day;			}
	public String getNext_yn()			{ return next_yn;			}
	public String getOpt_chk()			{ return opt_chk;			}
	public String getFee_sh()			{ return fee_sh;			}
	public String getPrv_mon_yn()		{ return prv_mon_yn;		}
	public String getFee_chk()			{ return fee_chk;			}
	public String getOpt_per()			{ return opt_per;			}
	public String getRent_dt()			{ return rent_dt;			}
	public String getRent_est_dt()		{ return rent_est_dt;		}
	public String getLeave_day()		{ return leave_day;			}
	public String getCls_per()			{ return cls_per;			}
	public float  getGur_per	()		{ return gur_per	;		}
	public float  getGur_p_per	()		{ return gur_p_per	;		}
	public float  getPere_per	()		{ return pere_per	;		}
	public float  getPere_r_per	()		{ return pere_r_per	;		}
	public int    getPere_mth	()		{ return pere_mth	;		}
	public int    getPere_r_mth	()		{ return pere_r_mth	;		}
	public float  getMax_ja		()		{ return max_ja		;		}
	public float  getApp_ja		()		{ return app_ja		;		}
	public String getOpt_st		()		{ return opt_st		;		}
	public float  getDc_ra		()		{ return dc_ra		;		}
	public String getBas_dt		()		{ return bas_dt		;		}
	public String getFee_sac_id	()		{ return fee_sac_id	;		}
	public String getDef_st		()		{ return def_st		;		}
	public String getDef_remark	()		{ return def_remark	;		}
	public String getDef_sac_id	()		{ return def_sac_id	;		}
	public float  getCls_r_per	()		{ return cls_r_per	;		}
	public int    getJa_s_amt	()		{ return ja_s_amt	;		}
	public int    getJa_v_amt	()		{ return ja_v_amt	;		}
	public int    getJa_r_s_amt	()		{ return ja_r_s_amt	;		}
	public int    getJa_r_v_amt	()		{ return ja_r_v_amt	;		}

	public float  getCredit_per  ()		{ return credit_per  ;		}
	public float  getCredit_r_per()		{ return credit_r_per;		}
	public int    getCredit_amt  ()		{ return credit_amt  ;		}
	public int    getCredit_r_amt()		{ return credit_r_amt;		}
	public String getRtn_st		()		{ return rtn_st		;		}
	public float  getCls_n_per	()		{ return cls_n_per	;		}
	public String getBrch_id	()		{ return brch_id	;		}
	public float  getB_max_ja	()		{ return b_max_ja	;		}
	public String getF_opt_per	()		{ return f_opt_per;			}
	public String getF_gur_p_per	()	{ return f_gur_p_per;		}
	public String getF_pere_r_per	()	{ return f_pere_r_per;		}
	
	public int getIns_s_amt		()		{ return ins_s_amt;			}
	public int getIns_v_amt		()		{ return ins_v_amt;			}
	public int getIns_total_amt	()		{ return ins_total_amt;		}
	public String getPp_chk()			{ return pp_chk;			}

}
