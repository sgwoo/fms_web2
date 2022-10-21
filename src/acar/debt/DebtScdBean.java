package acar.debt;

public class DebtScdBean
{
	private String car_mng_id;// 자동차관리번호
	private String alt_tm;    // 회차          
	private String alt_est_dt;// 약정일        
	private int    alt_prn;   // 할부원금      
	private int    alt_int;   // 이자          
	private String pay_yn;    // 결재구분      
	private String pay_dt;    // 결재일        
	private int    alt_rest;    // 결재일       
	private String r_alt_est_dt;// 실입금예정일       
	private String cls_rtn_dt;	//중도상환일
                              
	public DebtScdBean()
	{
		car_mng_id	= "";
		alt_tm 		= "";
		alt_est_dt	= "";
		alt_prn		= 0;
		alt_int		= 0;
		pay_yn		= "";
		pay_dt		= "";
		alt_rest 	= 0;
		cls_rtn_dt	= "";
	}
	
	public void setCar_mng_id(String str)	{ car_mng_id	= str;	}
	public void setAlt_tm(String str)		{ alt_tm 		= str;	}
	public void setAlt_est_dt(String str)	{ alt_est_dt	= str;	}
	public void setAlt_prn(int i)			{ alt_prn		= i;	}
	public void setAlt_int(int i)			{ alt_int		= i;	}
	public void setPay_yn(String str)		{ pay_yn		= str;	}
	public void setPay_dt(String str)		{ pay_dt		= str;	}
	public void setAlt_rest(int i)			{ alt_rest		= i;	}
	public void setR_alt_est_dt(String str)	{ r_alt_est_dt	= str;	}
	public void setCls_rtn_dt(String str)	{ cls_rtn_dt	= str;	}
	
	public String getCar_mng_id()	{ return car_mng_id;}
	public String getAlt_tm()		{ return alt_tm; 	}
	public String getAlt_est_dt()	{ return alt_est_dt;}
	public int    getAlt_prn()		{ return alt_prn; 	}
	public int    getAlt_int()		{ return alt_int; 	}
	public String getPay_yn()		{ return pay_yn; 	}
	public String getPay_dt()		{ return pay_dt; 	}
	public int    getAlt_rest()		{ return alt_rest; 	}
	public String getR_alt_est_dt()	{ return r_alt_est_dt;}
	public String getCls_rtn_dt()	{ return cls_rtn_dt;}
}