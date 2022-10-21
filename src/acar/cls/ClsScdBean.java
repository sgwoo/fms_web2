package acar.cls;

public class ClsScdBean
{
	private String gubun;
	private String rent_mng_id;	// 계약관리번호
	private String rent_l_cd;	// 계약번호    
	private String cls_tm;		// 차량번호        
	private int cls_s_amt; 
	private int cls_v_amt; 
	private int pay_amt; 
	private int dly_amt; 
	private String cls_est_dt; 
	private String pay_dt;
	private String dly_days;
	//추가
	private String ext_dt;		//세금계산서 발행일
	private String ext_id;		//세금계산서 발행자
	private String update_dt;	//수정자
	private String update_id;	//수정일
	private String bill_yn;		//미수채권여부


	public ClsScdBean()
	{
		gubun		= "";
		rent_mng_id = "";
		rent_l_cd   = ""; 
		cls_tm		= "";
		cls_s_amt	= 0;
		cls_v_amt	= 0;
		pay_amt		= 0;
		dly_amt     = 0;
		cls_est_dt	= "";
		pay_dt		= "";
		dly_days	= "";
		ext_dt = "";
		ext_id = "";
		update_dt = "";
		update_id = "";
		bill_yn = "";
	}
	
	public void setGubun(String str)		{ gubun			= str; } 
	public void setRent_mng_id(String str)	{ rent_mng_id	= str; } 
	public void setRent_l_cd(String str)	{ rent_l_cd		= str; } 
	public void setCls_tm(String str)		{ cls_tm		= str; }    
	public void setCls_s_amt(int i)			{ cls_s_amt		= i;   } 
	public void setCls_v_amt(int i)			{ cls_v_amt		= i;   } 
	public void setPay_amt(int i)			{ pay_amt		= i;   } 
	public void setDly_amt(int i)			{ dly_amt		= i;   } 
	public void setDly_days(String str)		{ dly_days		= str; } 
	public void setCls_est_dt(String str)	{ cls_est_dt	= str; } 
	public void setPay_dt(String str)		{ pay_dt		= str; } 
	public void setExt_dt(String str)		{ ext_dt	= str; }
	public void setExt_id(String str)		{ ext_id	= str; }
	public void setUpdate_dt(String str)	{ update_dt = str; }
	public void setUpdate_id(String str)	{ update_id = str; }
	public void setBill_yn(String str)		{ bill_yn	= str; }

	
	public String getGubun()		{ return gubun;			} 
	public String getRent_mng_id()	{ return rent_mng_id;	} 
	public String getRent_l_cd()	{ return rent_l_cd;		} 
	public String getCls_tm()		{ return cls_tm; 		}    
	public int    getCls_s_amt()	{ return cls_s_amt;		} 
	public int    getCls_v_amt()	{ return cls_v_amt;		} 
	public int    getPay_amt()		{ return pay_amt;		} 
	public int    getDly_amt()		{ return dly_amt;		} 
	public String getDly_days()		{ return dly_days;		} 
	public String getCls_est_dt()	{ return cls_est_dt;	} 
	public String getPay_dt()		{ return pay_dt;		}  
	public String getExt_dt()		{ return ext_dt; }  
	public String getExt_id()		{ return ext_id; }  
	public String getUpdate_dt()	{ return update_dt; }  
	public String getUpdate_id()	{ return update_id; }  
	public String getBill_yn()		{ return bill_yn; }  

}