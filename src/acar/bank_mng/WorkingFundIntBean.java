package acar.bank_mng;

public class WorkingFundIntBean
{
	//금리	
	private String fund_id;
	private int    seq;      
	private String reg_id;         
	private String reg_dt;         
	private String fund_int;          
	private String validity_s_dt;     
	private String validity_e_dt;     
	private String int_st;       
	private String spread;            
	private String spread_int;        
	private String app_b_st;          
	private String app_b_dt;          
	private String note;   
	//갱신
	private String renew_dt;       
	private long   a_cont_amt;      
	private long   b_cont_amt;      
	private String a_cls_est_dt;     
	private String b_cls_est_dt;     
	private String a_fund_int;          
	private String b_fund_int;          
	private int    int_seq;      
	
	
	public WorkingFundIntBean()
	{
		fund_id			= "";
		seq				= 0;
		reg_id			= "";
		reg_dt			= "";
		fund_int		= "";
		validity_s_dt	= "";
		validity_e_dt	= "";
		int_st			= "";
		spread			= "";
		spread_int		= "";
		app_b_st		= "";
		app_b_dt		= "";
		note			= "";
		renew_dt		= "";   
		a_cont_amt		= 0;  
		b_cont_amt		= 0;  
		a_cls_est_dt    = "";
		b_cls_est_dt    = "";
		a_fund_int		= ""; 
		b_fund_int		= "";  
		int_seq			= 0;   
	}
	
	public void setFund_id			(String str)	{	fund_id			= str;	}
	public void setSeq				(int    i  )	{	seq				= i;  	}
	public void setReg_id			(String str)	{	reg_id			= str;	}
	public void setReg_dt			(String str)	{	reg_dt			= str;	}
	public void setFund_int			(String str)	{	fund_int		= str;	}
	public void setValidity_s_dt	(String str)	{	validity_s_dt	= str;	}
	public void setValidity_e_dt	(String str)	{	validity_e_dt	= str;	}
	public void setInt_st			(String str)	{	int_st			= str;	}
	public void setSpread			(String str)	{	spread			= str;	}
	public void setSpread_int		(String str)	{	spread_int		= str;	}
	public void setApp_b_st			(String str)	{	app_b_st		= str;	}
	public void setApp_b_dt			(String str)	{	app_b_dt		= str;	}
	public void setNote				(String str)	{	note			= str;	}
	public void setRenew_dt			(String str)	{	renew_dt		= str;	}
	public void setA_cont_amt		(long   i  )	{	a_cont_amt      = i;  	}
	public void setB_cont_amt		(long   i  )	{	b_cont_amt      = i;  	}
	public void setA_cls_est_dt		(String str)	{	a_cls_est_dt    = str;	}
	public void setB_cls_est_dt		(String str)	{	b_cls_est_dt    = str;	}
	public void setA_fund_int		(String str)	{	a_fund_int		= str;	}
	public void setB_fund_int		(String str)	{	b_fund_int		= str;	}
	public void setInt_seq			(int    i  )	{	int_seq			= i;  	}

	
	public String getFund_id		()				{	return	fund_id;        }
	public int    getSeq			()				{	return	seq;			}
	public String getReg_id			()				{	return	reg_id;         }
	public String getReg_dt			()				{	return	reg_dt;         }
	public String getFund_int		()				{	return	fund_int;		}
	public String getValidity_s_dt	()				{	return	validity_s_dt;	}
	public String getValidity_e_dt	()				{	return	validity_e_dt;	}
	public String getInt_st			()				{	return	int_st;			}
	public String getSpread			()				{	return	spread;			}
	public String getSpread_int		()				{	return	spread_int;		}
	public String getApp_b_st		()				{	return	app_b_st;		}
	public String getApp_b_dt		()				{	return	app_b_dt;		}
	public String getNote			()				{	return	note;			}
	public String getRenew_dt		()				{	return	renew_dt;		}
	public long   getA_cont_amt		()				{	return	a_cont_amt;		}
	public long   getB_cont_amt		()				{	return	b_cont_amt;		}
	public String getA_cls_est_dt	()				{	return	a_cls_est_dt;	}
	public String getB_cls_est_dt	()				{	return	b_cls_est_dt;	}
	public String getA_fund_int		()				{	return	a_fund_int;		}
	public String getB_fund_int		()				{	return	b_fund_int;		}
	public int    getInt_seq		()				{	return	int_seq;		}


}