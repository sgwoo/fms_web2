package acar.receive;

public class ClsBandEtcBean
{
	private String rent_mng_id;	// 계약관리번호
	private String rent_l_cd;	// 계약번호  
	private int seq;                //순번   
	private String band_st; 
	private String band_ip_dt; 
	private int draw_amt;    //회수금액
	private int ip_amt;    //실입금액
	private int rate_amt;  //수수료
	private String rate_jp_dt;  //수수료 지급일 
	private String reg_dt; 
	private String reg_id; 
	private String upd_dt; 
	private String upd_id; 
	private String user_dt1; 
	private String user_id1; 
	private String user_dt2; // 총무팀장 
	private String user_id2; 
						
	
	public ClsBandEtcBean()
	{	
		rent_mng_id = "";
		rent_l_cd   = ""; 	
		seq	= 0;		
		band_st = ""; 
		band_ip_dt = ""; 
		draw_amt = 0; 
		ip_amt = 0; 
		rate_amt = 0; 
		rate_jp_dt = ""; 	
		reg_dt = ""; 
		reg_id = ""; 
		upd_dt = ""; 
		upd_id = ""; 
		user_dt1 = ""; 
		user_id1 = ""; 
		user_dt2 = ""; 
		user_id2 = ""; 
		
	}	
	
	
	public void setRent_mng_id(String str)	{ rent_mng_id	= str; } 
	public void setRent_l_cd(String str)		{ rent_l_cd		= str; } 	
	public void setSeq(int i)			{ seq		= i;   } 
	public void setBand_st(String str)	{ band_st	= str; } 
	public void setBand_ip_dt(String str)	{ band_ip_dt	= str; } 
	public void setDraw_amt(int i)		{ draw_amt		=i;   } 
	public void setIp_amt(int i)		{ ip_amt		=i;   } 
	public void setRate_amt(int i)		{ rate_amt		=i;   } 				
	public void setRate_jp_dt(String str)	{ rate_jp_dt	= str; } 
	public void setReg_dt(String str)		{ reg_dt	= str; }
	public void setReg_id(String str)		{ reg_id = str; }	
	public void setUpd_dt(String str)		{ upd_dt = str; }	
	public void setUpd_id(String str)		{ upd_id = str; }	
	public void setUser_dt1(String str)		{ user_dt1 = str; }	
	public void setUser_id1(String str)		{ user_id1 = str; }	
	public void setUser_dt2(String str)		{ user_dt2 = str; }	
	public void setUser_id2(String str)		{ user_id2 = str; }	
		

	public String getRent_mng_id()	{ return rent_mng_id;	} 
	public String getRent_l_cd()		{ return rent_l_cd;		} 	
	public int       getSeq()			{ return seq;		} 		
	public String getBand_st()			{ return band_st;		} 
	public String getBand_ip_dt()		{ return band_ip_dt;		} 
	public int 	getDraw_amt()			{ return draw_amt;		}  
	public int 	getIp_amt()			{ return ip_amt;		}  
	public int 	getRate_amt()			{ return rate_amt;		}  
	public String getRate_jp_dt()			{ return rate_jp_dt; }  
	public String getReg_dt()			{ return reg_dt; }  
	public String getReg_id()		{ return reg_id; }  
	public String getUpd_dt()		{ return upd_dt; }  
	public String getUpd_id()		{ return upd_id; }  
	public String getUser_dt1()		{ return user_dt1; }  
	public String getUser_id1()		{ return user_id1; }  
	public String getUser_dt2()		{ return user_dt2; }  
	public String getUser_id2()		{ return user_id2; }  


}