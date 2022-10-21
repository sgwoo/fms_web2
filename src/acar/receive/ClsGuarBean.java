package acar.receive;

public class ClsGuarBean
{
	private String rent_mng_id;	// 계약관리번호
	private String rent_l_cd;	// 계약번호    
	private String req_dt; 
	private String n_ven_code;   //보증보험사
	private String n_ven_name;  //
	private int req_amt; 
	private String guar_nm; 
	private String guar_tel; 
	private String damdang_id; 
	private String bank_cd; 
	private String bank_nm; 
	private String bank_no; 
	private int ip_amt;         //입금액
	private String ip_dt;     //입금일
	private String remark; 
	private String reg_dt; 
	private String reg_id; 
	private String upd_dt; 
	private String upd_id; 
	private String  p_st;  //1:청구 2:입금 3:완료 
							
	public ClsGuarBean()
	{	
		rent_mng_id = "";
		rent_l_cd   = ""; 	
		req_dt = "";
		n_ven_code = ""; 
		n_ven_name = ""; 
		req_amt = 0; 	
		guar_nm = ""; 	
		guar_tel = ""; 
		damdang_id = ""; 	
		bank_cd = ""; 
		bank_nm = ""; 
		bank_no = ""; 	
		ip_amt = 0;         //입금액
		ip_dt = "";     //기준일
		remark = ""; 
		reg_dt = ""; 
		reg_id = ""; 
		upd_dt = ""; 
		upd_id = ""; 		
		p_st = ""; 		
	}	
	
	public void setRent_mng_id(String str)	{ rent_mng_id	= str; } 
	public void setRent_l_cd(String str)		{ rent_l_cd		= str; } 	
	public void setReq_dt(String str)	{ req_dt	= str; } 
	public void setN_ven_code(String str)		{ n_ven_code		= str; } 
	public void setN_ven_name(String str)		{ n_ven_name	= str; } 
	public void setReq_amt(int i)		{ req_amt		=i;   } 
	public void setGuar_nm(String str)		{ guar_nm		= str; } 	
	public void setGuar_tel(String str)		{ guar_tel	= str; }
	public void setDamdang_id(String str)		{ damdang_id = str; }	
	public void setBank_cd(String str)		{ bank_cd	= str; } 
	public void setBank_nm(String str)		{ bank_nm		= str; } 
	public void setBank_no(String str)		{ bank_no	= str; }
	public void setIp_amt(int i)		{ ip_amt = i; }	
	public void setIp_dt(String str)		{ ip_dt = str; }		
	public void setRemark(String str)		{ remark	= str; }
	public void setReg_dt(String str)		{ reg_dt	= str; }
	public void setReg_id(String str)		{ reg_id = str; }	
	public void setUpd_dt(String str)		{ upd_dt = str; }	
	public void setUpd_id(String str)		{ upd_id = str; }	
	public void setP_st(String str)			{ p_st = str; }	

	public String getRent_mng_id()	{ return rent_mng_id;	} 
	public String getRent_l_cd()		{ return rent_l_cd;		} 	
	public String getReq_dt()			{ return req_dt;		} 
	public String getN_ven_code()		{ return n_ven_code;		} 
	public String getN_ven_name()		{ return n_ven_name;	} 
	public int 	getReq_amt()			{ return req_amt;		}  
	public String getGuar_nm()			{ return guar_nm; }  
	public String getGuar_tel()			{ return guar_tel; }  
	public String getDamdang_id()		{ return damdang_id; }  
	public String getBank_cd()			{ return bank_cd; }  
	public String getBank_nm()			{ return bank_nm; }  
	public String getBank_no()			{ return bank_no; }  
	public int getIp_amt()				{ return ip_amt; }  
	public String getIp_dt()				{ return ip_dt; }  
	public String getRemark()			{ return remark; }  
	public String getReg_dt()				{ return reg_dt; }  
	public String getReg_id()		{ return reg_id; }  
	public String getUpd_dt()		{ return upd_dt; }  
	public String getUpd_id()		{ return upd_id; }  
	public String getP_st()		{ return p_st; }  

}