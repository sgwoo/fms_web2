package acar.fee;

public class FeeScdBean
{
	private String rent_mng_id;
	private String rent_l_cd;
	private String fee_tm;
	private String rent_st;
	private String tm_st1;			// 대여료 구분 (월대여료/잔액)
	private String tm_st2;			// 대여료 구분 (일반대여료/회차연장대여료)
	private String fee_est_dt;
	private int    fee_s_amt;
	private int    fee_v_amt;
	private String rc_yn;
	private String rc_dt;
	private int    rc_amt;
	private String dly_days;
	private int    dly_fee;
	private String pay_cng_dt;
	private String pay_cng_cau;
	private String r_fee_est_dt;
	private String islast; 			//한 회차에 대해 월대여료와 잔액 n개 생성 가능. 이때 한 회차에 대한 마지막 row인지 구분하는 field
	private String tae_no;
	private String user_nm;
	private long    tot1;
	private long    tot2;
	private long    tot3;
	private long    tot4;
	private long    tot5;
	private long    tot6;
	private long    tot7;
	private int	   tot6_rate;
	private int	   tot7_rate;
	private float  f_tot2_rate;
	private float  f_tot3_rate;
	private float  f_tot4_rate;
	private float  f_tot5_rate;
	private float  f_tot6_rate;
	private float  f_tot7_rate;

	//추가
	private String ext_dt;		//세금계산서 발행일
	private String ext_id;		//세금계산서 발행자
	private String update_dt;	//수정자
	private String update_id;	//수정일
	private String bill_yn;		//미수채권여부
	private String dly_chk;		//악성채권여부
	//20051017
	private String req_dt;		//발행예정일
	private String r_req_dt;	//실발행예정일
	private String use_s_dt;	//사용기간 시작일
	private String use_e_dt;	//사용기간 종료일
	private String tax_out_dt;	//청구일자
	private String tax_dt;		//세금계산서출력일
	private String reg_dt;		//발행일자
	private String print_dt;	//출력일자
	private String cng_dt;		//변경일자
	private String cng_cau;		//변경사유

	private String ven_code;	
	private String adate;		//자동이체출금의뢰일
	private String rent_seq;
	private String pay_st;

	private String incom_dt;   //입금원장:입금일
	private int	   incom_seq;  //입금원장:순번

	//추가 
	private String use_day;
	private String etc;
	
	private String taecha_no;
	
	public FeeScdBean()
	{	
		use_day ="";
		rent_mng_id = "";
		rent_l_cd   = ""; 
		fee_tm       = "";
		rent_st      = "";
		tm_st1       = "";
		tm_st2       = "";
		fee_est_dt   = "";
		fee_s_amt    = 0;
		fee_v_amt   = 0;
		rc_yn        = "";
		rc_dt        = "";
		rc_amt      = 0;
		dly_days     = "";
		dly_fee      = 0;
		pay_cng_dt   = "";
		pay_cng_cau  = "";
		r_fee_est_dt = "";
		islast		 = "";
		tae_no		 = "";

		user_nm		 = "";
		tot1		 = 0;
		tot2		 = 0;
		tot3		 = 0;
		tot4		 = 0;
		tot5		 = 0;
		tot6		 = 0;
		tot7		 = 0;
		tot6_rate	 = 0;
		tot7_rate	 = 0;
		f_tot2_rate	 = 0;
		f_tot3_rate	 = 0;
		f_tot4_rate	 = 0;
		f_tot5_rate	 = 0;
		f_tot6_rate	 = 0;
		f_tot7_rate	 = 0;

		ext_dt = "";
		ext_id = "";
		update_dt = "";
		update_id = "";
		bill_yn = "";
		dly_chk = "";

		req_dt = "";
		r_req_dt = "";
		use_s_dt = "";
		use_e_dt = "";
		tax_out_dt = "";
		tax_dt = "";
		reg_dt = "";
		print_dt = "";
		cng_dt = "";
		cng_cau = "";
		ven_code = "";
		adate = "";
		rent_seq = "";
		pay_st = "";
		
		incom_dt = "";
		incom_seq = 0;
		etc = "";
		taecha_no = "";

	}

	
	//Bean Set -----------------------------------------------------------------
	public void setUse_day(String str)	{ use_day= str; } 

	public void setRent_mng_id(String str)	{ rent_mng_id= str; } 
	public void setRent_l_cd(String str)	{ rent_l_cd  = str; } 
	public void setFee_tm(String str)		{ fee_tm     = str; }    
	public void setRent_st(String str)		{ rent_st    = str; } 
	public void setTm_st1(String str)		{ tm_st1     = str; } 
	public void setTm_st2(String str)		{ tm_st2     = str; } 
	public void setFee_est_dt(String str)	{ fee_est_dt = str; } 
	public void setFee_s_amt(int i)			{ fee_s_amt  = i; } 
	public void setFee_v_amt(int i)			{ fee_v_amt  = i; } 
	public void setRc_yn(String str)		{ rc_yn      = str; } 
	public void setRc_dt(String str)		{ rc_dt      = str; } 
	public void setRc_amt(int i)			{ rc_amt     = i; } 
	public void setDly_days(String str)		{ dly_days   = str; } 
	public void setDly_fee(int i)			{ dly_fee    = i; } 
	public void setPay_cng_dt(String str)	{ pay_cng_dt = str; } 
	public void setPay_cng_cau(String str)	{ pay_cng_cau= str; } 
	public void setR_fee_est_dt(String str)	{ r_fee_est_dt = str; } 
	public void setIslast(String str)		{ islast = str; }
	public void setTae_no(String str)		{ tae_no = str; }

	public void setUser_nm(String str)		{ user_nm = str; }
	public void setTot1(long i)				{ tot1    = i; } 
	public void setTot2(long i)				{ tot2    = i; } 
	public void setTot3(long i)				{ tot3    = i; } 
	public void setTot4(long i)				{ tot4    = i; } 
	public void setTot5(long i)				{ tot5    = i; } 
	public void setTot6(long i)				{ tot6    = i; } 
	public void setTot7(long i)				{ tot7    = i; } 
	public void setTot6_rate(int i)			{ tot6_rate    = i; } 
	public void setTot7_rate(int i)			{ tot7_rate    = i; } 
	public void setFTot2_rate(float i)		{ f_tot2_rate  = i; } 
	public void setFTot3_rate(float i)		{ f_tot3_rate  = i; } 
	public void setFTot4_rate(float i)		{ f_tot4_rate  = i; } 
	public void setFTot5_rate(float i)		{ f_tot5_rate  = i; } 
	public void setFTot6_rate(float i)		{ f_tot6_rate  = i; } 
	public void setFTot7_rate(float i)		{ f_tot7_rate  = i; } 

	public void setExt_dt(String str)		{ ext_dt	= str; }
	public void setExt_id(String str)		{ ext_id	= str; }
	public void setUpdate_dt(String str)	{ update_dt = str; }
	public void setUpdate_id(String str)	{ update_id = str; }
	public void setBill_yn(String str)		{ bill_yn	= str; }
	public void setDly_chk(String str)		{ dly_chk	= str; }

	public void setReq_dt(String str)		{ req_dt	= str; }
	public void setR_req_dt(String str)		{ r_req_dt	= str; }
	public void setUse_s_dt(String str)		{ use_s_dt	= str; }
	public void setUse_e_dt(String str)		{ use_e_dt	= str; }
	public void setTax_out_dt(String str)	{ tax_out_dt= str; }

	public void setTax_dt(String str)		{ tax_dt	= str; }
	public void setReg_dt(String str)		{ reg_dt	= str; }
	public void setPrint_dt(String str)		{ print_dt	= str; }
	public void setCng_dt(String str)		{ cng_dt	= str; }
	public void setCng_cau(String str)		{ cng_cau	= str; }
	public void setVen_code(String str)		{ ven_code	= str; }
	public void setAdate(String str)		{ adate		= str; }
	public void setPay_st(String str)		{ pay_st	= str; }
	public void setRent_seq(String val){	if(val==null) val="1";		this.rent_seq      = val;	}

	public void setIncom_dt(String str)		{ incom_dt	= str; }
	public void setIncom_seq(int i)			{ incom_seq = i; } 
	public void setEtc(String str)			{ etc		= str; }
	public void setTaecha_no(String str)	{ taecha_no		= str; }
	

	//Bean Get -----------------------------------------------------------------
	public String getUse_day()	{ return use_day; } 	

	public String getRent_mng_id()	{ return rent_mng_id; } 
	public String getRent_l_cd()	{ return rent_l_cd; } 
	public String getFee_tm()		{ return fee_tm; 	}    
	public String getRent_st()		{ return rent_st; 	} 
	public String getTm_st1()		{ return tm_st1; 	} 
	public String getTm_st2()		{ return tm_st2; 	} 
	public String getFee_est_dt()	{ return fee_est_dt; } 
	public int    getFee_s_amt()	{ return fee_s_amt;} 
	public int    getFee_v_amt()	{ return fee_v_amt;} 
	public String getRc_yn()		{ return rc_yn; } 
	public String getRc_dt()		{ return rc_dt; } 
	public int    getRc_amt()		{ return rc_amt;} 
	public String getDly_days()		{ return dly_days; } 
	public int    getDly_fee()		{ return dly_fee;} 
	public String getPay_cng_dt()	{ return pay_cng_dt; } 
	public String getPay_cng_cau()	{ return pay_cng_cau; }
	public String getR_fee_est_dt()	{ return r_fee_est_dt; }  
	public String getIslast()		{ return islast; }  
	public String getTae_no()		{ return tae_no; }  
	public String getUser_nm()		{ return user_nm; }  
	public long    getTot1()		{ return tot1;} 
	public long    getTot2()		{ return tot2;} 
	public long    getTot3()		{ return tot3;} 
	public long    getTot4()		{ return tot4;} 
	public long    getTot5()		{ return tot5;} 
	public long    getTot6()		{ return tot6;} 
	public long    getTot7()		{ return tot7;} 
	public int    getTot6_rate()	{ return tot6_rate;} 
	public int    getTot7_rate()	{ return tot7_rate;} 
	public float  getFTot2_rate()	{ return f_tot2_rate;} 
	public float  getFTot3_rate()	{ return f_tot3_rate;} 
	public float  getFTot4_rate()	{ return f_tot4_rate;} 
	public float  getFTot5_rate()	{ return f_tot5_rate;} 
	public float  getFTot6_rate()	{ return f_tot6_rate;} 
	public float  getFTot7_rate()	{ return f_tot7_rate;} 

	public String getExt_dt()		{ return ext_dt; }  
	public String getExt_id()		{ return ext_id; }  
	public String getUpdate_dt()	{ return update_dt; }  
	public String getUpdate_id()	{ return update_id; }  
	public String getBill_yn()		{ return bill_yn; }  
	public String getDly_chk()		{ return dly_chk; }  

	public String getReq_dt()		{ return req_dt; }  
	public String getR_req_dt()		{ return r_req_dt; }  
	public String getUse_s_dt()		{ return use_s_dt; }  
	public String getUse_e_dt()		{ return use_e_dt; }  
	public String getTax_out_dt()	{ return tax_out_dt; }  
	public String getTax_dt()		{ return tax_dt; }  
	public String getReg_dt()		{ return reg_dt; }  
	public String getPrint_dt()		{ return print_dt; }  
	public String getCng_dt()		{ return cng_dt; }  
	public String getCng_cau()		{ return cng_cau; }  
	public String getVen_code()		{ return ven_code; }  
	public String getAdate()		{ return adate; }  
	public String getRent_seq()		{ return rent_seq; }  
	public String getPay_st()		{ return pay_st; }  
	
	public String getIncom_dt()		{ return incom_dt;	}  
	public int	  getIncom_seq()	{ return incom_seq; } 
	public String getEtc()			{ return etc;		}  
	public String getTaecha_no()			{ return taecha_no;		}

}
