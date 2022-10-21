package acar.cont;

public class ContGiInsBean
{
	private String rent_mng_id; 
	private String rent_l_cd;
	private String gi_no;
	private int    gi_amt;
	private int    gi_fee;
	private String gi_start_dt; 
	private String gi_end_dt; 
	private String gi_day; 
	private String gi_dt; 
	private String gi_reason; 
	private String gi_sac_id; 
	private String gi_jijum; 
	private String gi_est_dt; 
	private String gi_etc; 
	private String rent_st; 
	private String gi_st;
	private String gi_month;	//보증보험 가입기간(개월수) (2018.03.16)
	                                    
	public ContGiInsBean()
	{
		rent_mng_id = "";   
		rent_l_cd 	= "";   
		gi_no 		= "0";   
		gi_amt 		= 0;
		gi_fee 		= 0;   
		gi_start_dt = "";   
		gi_end_dt 	= "";   
		gi_day	 	= "";   
		gi_dt 		= "";   
		gi_reason 	= "";   
		gi_sac_id	= "";   
		gi_jijum 	= "";   
		gi_est_dt 	= "";   
		gi_etc	 	= "";   
		rent_st	 	= "";   
		gi_st	 	= "";
		gi_month 	= ""; 	//보증보험 가입기간(개월수) (2018.03.16)

	}
	
	public void setRent_mng_id	(String str)	{									rent_mng_id	= str; }
	public void setRent_l_cd	(String str)	{									rent_l_cd 	= str; } 	
	public void setGi_no		(String str)	{									gi_no 		= str; } 		
	public void setGi_amt		(int i)			{									gi_amt 		= i;   } 	
	public void setGi_fee		(int i)			{									gi_fee 		= i;   } 	
	public void setGi_start_dt	(String str)	{									gi_start_dt = str; } 
	public void setGi_end_dt	(String str)	{									gi_end_dt	= str; } 
	public void setGi_day		(String str)	{									gi_day		= str; } 
	public void setGi_dt		(String str)	{									gi_dt		= str; } 
	public void setGi_reason	(String str)	{									gi_reason	= str; } 
	public void setGi_sac_id	(String str)	{									gi_sac_id	= str; } 
	public void setGi_jijum 	(String str)	{									gi_jijum 	= str; } 
	public void setGi_est_dt	(String str)	{									gi_est_dt	= str; } 
	public void setGi_etc	 	(String str)	{									gi_etc 		= str; } 
	public void setRent_st		(String str)	{		if(str==null) str="1";		rent_st		= str; }
	public void setGi_st	 	(String str)	{									gi_st 		= str; }
	public void setGi_month	 	(String str)	{									gi_month 	= str; }	//보증보험 가입기간(개월수) (2018.03.16)


	public String getRent_mng_id()				{ return rent_mng_id;	}
	public String getRent_l_cd	()				{ return rent_l_cd;		}
	public String getGi_no		()				{ return gi_no;			}
	public int    getGi_amt		()				{ return gi_amt;		}
	public int    getGi_fee		()				{ return gi_fee;		}
	public String getGi_start_dt()				{ return gi_start_dt;	}
	public String getGi_end_dt	()				{ return gi_end_dt;		}
	public String getGi_day		()				{ return gi_day;		}
	public String getGi_dt		()				{ return gi_dt;			}
	public String getGi_reason	()				{ return gi_reason;  	}
	public String getGi_sac_id	()				{ return gi_sac_id;  	}
	public String getGi_jijum 	()				{ return gi_jijum;   	}
	public String getGi_est_dt	()				{ return gi_est_dt;  	}
	public String getGi_etc 	()				{ return gi_etc;	   	}
	public String getRent_st 	()				{ return rent_st;	   	}
	public String getGi_st	 	()				{ return gi_st;		   	}
	public String getGi_month 	()				{ return gi_month;	  	}		//보증보험 가입기간(개월수) (2018.03.16)
	
}
