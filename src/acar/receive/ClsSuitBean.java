package acar.receive;

public class ClsSuitBean
{
	
	private String rent_mng_id;	// 계약관리번호
	private String rent_l_cd;	// 계약번호    
	private String req_dt; //소송일(청구일)
	private String req_rem; 
	private String s_type; 
	private String suit_dt;  //접수일 
	private String suit_no; 
	private int suit_amt; 
	private String mean_dt; //판결일 
	private String suit_rem; //처리의견 / 처리지시/ 의견  
	private int amt1; 
	private int amt2; 
	private String reg_dt; 
	private String reg_id; 
	private String upd_dt; 
	private String upd_id; 
						
	
	public ClsSuitBean()
	{
		rent_mng_id = "";
		rent_l_cd   = ""; 	
		req_dt = "";		
		req_rem = ""; 
		s_type = ""; 
		suit_dt = ""; 
		suit_no = ""; 
		suit_amt = 0; 	
		mean_dt = ""; 
		suit_rem = ""; 
		amt1 = 0; 	
		amt2 = 0; 			
		reg_dt = ""; 
		reg_id = ""; 
		upd_dt = ""; 
		upd_id = ""; 	
		
	}		

	public void setRent_mng_id(String str)	{ rent_mng_id	= str; } 
	public void setRent_l_cd(String str)		{ rent_l_cd		= str; } 	
	public void setReq_dt(String str)	{ req_dt	= str; } 
	public void setReq_rem(String str)		{ req_rem		= str; } 
	public void setS_type(String str)		{ s_type	= str; } 
	public void setSuit_dt(String str)		{ suit_dt	= str; }
	public void setSuit_no(String str)		{ suit_no		= str; } 
	public void setSuit_amt(int i)		{ suit_amt		=i;   } 	
	public void setMean_dt(String str)		{ mean_dt	= str; }
	public void setSuit_rem(String str)		{ suit_rem	= str; }
	public void setAmt1(int i)		{ amt1		=i;   } 	
	public void setAmt2(int i)		{ amt2		=i;   } 		
	public void setReg_dt(String str)		{ reg_dt	= str; }
	public void setReg_id(String str)		{ reg_id = str; }	
	public void setUpd_dt(String str)		{ upd_dt = str; }	
	public void setUpd_id(String str)		{ upd_id = str; }	
			
	public String getRent_mng_id()	{ return rent_mng_id;	} 
	public String getRent_l_cd()		{ return rent_l_cd;		} 	
	public String getReq_dt()			{ return req_dt;		} 
	public String getReq_rem()		{ return req_rem;		} 
	public String getS_type()		{ return s_type;	} 
	public String getSuit_dt()			{ return suit_dt; }  
	public String getSuit_no()			{ return suit_no; }  
	public int 	  getSuit_amt()			{ return suit_amt;		}  	
	public String getMean_dt()			{ return mean_dt; }  
	public String getSuit_rem()			{ return suit_rem; }  
	public int 	getAmt1()			{ return amt1;		}
	public int 	getAmt2()			{ return amt2;		}
	public String getReg_dt()			{ return reg_dt; }  
	public String getReg_id()		{ return reg_id; }  
	public String getUpd_dt()		{ return upd_dt; }  
	public String getUpd_id()		{ return upd_id; }  
	
}