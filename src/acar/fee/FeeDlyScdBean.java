package acar.fee;

public class FeeDlyScdBean
{
	private String rent_mng_id;
	private String rent_l_cd;
	private String seq;
	private String pay_dt;
	private int    pay_amt;
	private String reg_id;
	private String reg_dt;
	private String etc;
	private String incom_dt;   //입금원장:입금일
	private int	   incom_seq;  //입금원장:순번

	public FeeDlyScdBean()
	{
		rent_mng_id = "";
		rent_l_cd   = ""; 
		seq			= "";
		pay_dt      = "";
		pay_amt		= 0;
		reg_dt		= "";
		reg_id		= "";
		etc			= "";
		
		incom_dt = "";
		incom_seq = 0;
	}
	
	//Bean Set -----------------------------------------------------------------
	public void setRent_mng_id(String str)	{ rent_mng_id= str; } 
	public void setRent_l_cd(String str)	{ rent_l_cd  = str; } 
	public void setSeq(String str)			{ seq		 = str; }    
	public void setPay_dt(String str)		{ pay_dt     = str; } 
	public void setPay_amt(int i)			{ pay_amt    = i;	} 
	public void setReg_dt(String str)		{ reg_dt	 = str; }
	public void setReg_id(String str)		{ reg_id	 = str; }
	public void setEtc(String str)			{ etc		 = str; }
	
	public void setIncom_dt(String str)		{ incom_dt	= str; }
	public void setIncom_seq(int i)			{ incom_seq    = i; } 

	//Bean Get -----------------------------------------------------------------	
	public String getRent_mng_id()	{ return rent_mng_id;	} 
	public String getRent_l_cd()	{ return rent_l_cd;		} 
	public String getSeq()			{ return seq; 			}    
	public String getPay_dt()		{ return pay_dt; 		} 
	public int    getPay_amt()		{ return pay_amt;		} 
	public String getReg_dt()		{ return reg_dt; 		} 
	public String getReg_id()		{ return reg_id;		} 
	public String getEtc()			{ return etc;			}  
	
	public String getIncom_dt()		{ return incom_dt; }  
	public int	  getIncom_seq()	{ return incom_seq; }  

}
