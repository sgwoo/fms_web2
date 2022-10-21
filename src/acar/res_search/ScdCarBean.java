package acar.res_search;

public class ScdCarBean
{
	private String car_mng_id = "";
	private String rent_s_cd = "";
	private String dt	= "";
	private String time = "";
	private String reg_id = "";
	private String reg_dt = "";
	private String use_yn = "";
	private String use_st = "";
	private int tm = 0;
	
	public ScdCarBean()
	{
		car_mng_id	= "";    
		rent_s_cd	= "";        
		dt = "";    
		time = "";    
		reg_id = "";
		reg_dt = "";
		use_yn = "";    
		use_st = "";
		tm = 0;
	}
	
	public void setCar_mng_id(String str) 	{ car_mng_id	= str; }
	public void setRent_s_cd(String str)	{ rent_s_cd		= str; }
	public void setDt(String str)			{ dt			= str; }		
	public void setTime(String str)			{ time			= str; }    
	public void setReg_id(String str)		{ reg_id		= str; }    	
	public void setReg_dt(String str)		{ reg_dt		= str; }    	
	public void setUse_yn(String str)		{ use_yn		= str; }    		
	public void setUse_st(String str)		{ use_st		= str; }    	
	public void setTm(int i)				{ tm			= i;}			

	
	public String getCar_mng_id() 	{ return car_mng_id;	}
	public String getRent_s_cd()	{ return rent_s_cd;		}
	public String getDt()			{ return dt;			}
	public String getTime()			{ return time;			}
	public String getReg_id()		{ return reg_id;		}
	public String getReg_dt()		{ return reg_dt;		}
	public String getUse_yn()		{ return use_yn;		}
	public String getUse_st()		{ return use_st;		}
	public int getTm()				{ return tm;			}

}