package acar.receive;

public class ClsBandBean
{
	private int seq;                //순번 
	private String rent_mng_id;	// 계약관리번호
	private String rent_l_cd;	// 계약번호    
	private String req_dt; 
	private String n_ven_code; 
	private String n_ven_name; 
	private int re_rate; 
	private String re_dept; 
	private String re_nm; 
	private String re_fax; 
	private String re_tel; 
	private String re_phone; 
	private String re_mail; 
	private String bank_cd; 
	private String bank_nm; 
	private String bank_no; 
	private String re_bank_cd; 
	private String re_bank_nm; 
	private String re_bank_no; 
	private int band_amt;         //채권
	private String basic_dt;     //기준일
	private int no_re_amt;    //미회수자동차 
	private int car_jan_amt;    //잔가
	private int tot_amt;    //채권계 
	private String re_st; 
	private String settle_dt;  //종료일 
	private String reg_dt; 
	private String reg_id; 
	private String upd_dt; 
	private String upd_id; 
	private String remarks; 
	private String seize_dt; //압류일 
	private int seize_amt;  //압류비용 
	
	public ClsBandBean()
	{
		seq	= 0;		
		req_dt = "";
		rent_mng_id = "";
		rent_l_cd   = ""; 	
		n_ven_code = ""; 
		n_ven_name = ""; 
		re_rate = 0; 
		re_dept = ""; 
		re_nm = ""; 
		re_fax = ""; 
		re_tel = ""; 
		re_phone = ""; 
		re_mail = ""; 
		bank_cd = ""; 
		bank_nm = ""; 
		bank_no = ""; 
		re_bank_cd = ""; 
		re_bank_nm = ""; 
		re_bank_no = ""; 
		band_amt = 0;         //채권
		basic_dt = "";     //기준일
		no_re_amt = 0;    //미회수자동차 
		car_jan_amt = 0;    //잔가 
		tot_amt = 0;         //채권계 
		re_st = ""; 
		reg_dt = ""; 
		reg_id = ""; 
		upd_dt = ""; 
		upd_id = ""; 
		settle_dt = "";
		remarks = "";
		seize_dt = "";     
		seize_amt = 0;     
		
	}	
	
	public void setSeq(int i)			{ seq		= i;   } 
	public void setRent_mng_id(String str)	{ rent_mng_id	= str; } 
	public void setRent_l_cd(String str)		{ rent_l_cd		= str; } 	
	public void setReq_dt(String str)	{ req_dt	= str; } 
	public void setN_ven_code(String str)		{ n_ven_code		= str; } 
	public void setN_ven_name(String str)		{ n_ven_name	= str; } 
	public void setRe_rate(int i)		{ re_rate		=i;   } 
	public void setRe_dept(String str)		{ re_dept	= str; }
	public void setRe_nm(String str)		{ re_nm		= str; } 
	public void setRe_fax(String str)		{ re_fax	= str; }
	public void setRe_tel(String str)		{ re_tel	= str; }
	public void setRe_phone(String str)		{ re_phone = str; }	
	public void setRe_mail(String str)		{ re_mail = str; }	
	public void setBank_cd(String str)		{ bank_cd	= str; } 
	public void setBank_nm(String str)		{ bank_nm		= str; } 
	public void setBank_no(String str)		{ bank_no	= str; }
	public void setRe_bank_cd(String str)		{ re_bank_cd		= str; } 
	public void setRe_bank_nm(String str)		{ re_bank_nm	= str; }   //예금주
	public void setRe_bank_no(String str)		{ re_bank_no	= str; }    //계좌번호
	public void setBand_amt(int i)		{ band_amt = i; }	
	public void setBasic_dt(String str)		{ basic_dt = str; }	
	public void setNo_re_amt(int i)		{ no_re_amt	= i; }
	public void setCar_jan_amt(int i)		{ car_jan_amt	= i; } 
	public void setTot_amt(int i)		{ tot_amt	= i; } 
	public void setRe_st(String str)		{ re_st	= str; }
	public void setReg_dt(String str)		{ reg_dt	= str; }
	public void setReg_id(String str)		{ reg_id = str; }	
	public void setUpd_dt(String str)		{ upd_dt = str; }	
	public void setUpd_id(String str)		{ upd_id = str; }	
	public void setSettle_dt(String str)	{ settle_dt	= str; } 
	public void setRemarks(String str)	{ remarks	= str; } 
	public void setSeize_dt(String str)		{ seize_dt = str; }	
	public void setSeize_amt(int i)		{ seize_amt	= i; }
		
	public int       getSeq()			{ return seq;		} 		
	public String getRent_mng_id()	{ return rent_mng_id;	} 
	public String getRent_l_cd()		{ return rent_l_cd;		} 	
	public String getReq_dt()			{ return req_dt;		} 
	public String getN_ven_code()		{ return n_ven_code;		} 
	public String getN_ven_name()		{ return n_ven_name;	} 
	public int 	getRe_rate()			{ return re_rate;		}  
	public String getRe_dept()			{ return re_dept; }  
	public String getRe_nm()			{ return re_nm; }  
	public String getRe_fax()			{ return re_fax; }  
	public String getRe_tel()			{ return re_tel; }  
	public String getRe_phone()		{ return re_phone; }  
	public String getRe_mail()		{ return re_mail; }  
	public String getBank_cd()			{ return bank_cd; }  
	public String getBank_nm()			{ return bank_nm; }  
	public String getBank_no()			{ return bank_no; }  
	public String getRe_bank_cd()			{ return re_bank_cd; }  
	public String getRe_bank_nm()		{ return re_bank_nm; }  
	public String getRe_bank_no()		{ return re_bank_no; }  
	public int getBand_amt()		{ return band_amt; }  
	public String getBasic_dt()		{ return basic_dt; }  
	public int getNo_re_amt()			{ return no_re_amt; }  
	public int getCar_jan_amt()			{ return car_jan_amt; }  
	public int getTot_amt()			{ return tot_amt; }  
	public String getRe_st()			{ return re_st; }  
	public String getReg_dt()			{ return reg_dt; }  
	public String getReg_id()		{ return reg_id; }  
	public String getUpd_dt()		{ return upd_dt; }  
	public String getUpd_id()		{ return upd_id; }  
	public String getSettle_dt()		{ return settle_dt; }  
	public String getRemarks()		{ return remarks; }
	public String getSeize_dt()		{ return seize_dt; }  
	public int getSeize_amt()			{ return seize_amt; }  

}