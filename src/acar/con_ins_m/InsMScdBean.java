package acar.con_ins_m;

public class InsMScdBean
{
	private String rent_mng_id;	// 계약관리번호
	private String rent_l_cd;	// 계약번호    
	private String car_mng_id;	// 차량관리번호        
	private String accid_id;    // 사고관리번호
	private String serv_id;     // 정비관리번호
	private String gubun; 
	private String accid_dt;
	private String serv_st;
	private String off_id;
	private String off_nm; 
	private int rep_amt; 
	private int sup_amt; 
	private int add_amt; 
	private int tot_amt; 
	private int cust_amt; 
	private int ext_v_amt; 
	private int ext_s_amt; 
	private int dly_amt; 
	private int pay_amt; 
	private String cust_req_dt; 
	private String cust_plan_dt; 
	private String cust_pay_dt;
	private String dly_days;
	//추가
	private String ext_dt;		//세금계산서 발행일
	private String ext_id;		//세금계산서 발행자
	private String update_dt;	//수정자
	private String update_id;	//수정일
	private String ext_tm;	//납입회차
	private String bill_doc_yn;	//0:미발행 1:발행 - 계산서 
	private String seqid;		//전자입금표일련번호
	private String pubcode;		//전자입금표일련코드
	private String saleebill_yn;	//0:미발행 1:발행 - 계산서 
	private String rent_st; 
	private String agnt_email; 

	public InsMScdBean()
	{
		rent_mng_id = "";
		rent_l_cd   = ""; 
		car_mng_id	= "";
		accid_id	= "";
		serv_id		= "";
		gubun       = "";
		accid_dt    = "";
		this.serv_st     = "";
		off_id      = "";
		off_nm		= "";
		rep_amt		= 0;
		sup_amt		= 0;
		add_amt     = 0;
		tot_amt     = 0;
		cust_amt    = 0;
		dly_amt     = 0;
		pay_amt     = 0;
		ext_v_amt     = 0;
		ext_s_amt     = 0;
		cust_req_dt = "";
		cust_plan_dt= "";
		cust_pay_dt = "";
		this.dly_days	= "";
		ext_dt = "";
		ext_id = "";
		update_dt = "";
		update_id = "";
		ext_tm = "";
		bill_doc_yn = "";
		seqid		= "";
		pubcode		= "";
		saleebill_yn = "";
		rent_st = "";
		agnt_email = "";

	}
	
	public void setRent_mng_id(String str)	{ rent_mng_id	= str; } 
	public void setRent_l_cd(String str)	{ rent_l_cd		= str; } 
	public void setCar_mng_id(String str)	{ car_mng_id	= str; }    
	public void setAccid_id(String str)		{ accid_id		= str; } 
	public void setServ_id(String str)		{ serv_id		= str; } 
	public void setGubun(String str)		{ gubun			= str; } 
	public void setAccid_dt(String str)		{ accid_dt		= str; } 
	public void setServ_st(String val){ if(val==null) val=""; this.serv_st = val; }
	public void setOff_id(String val){ if(val==null) val=""; this.off_id = val; }
	public void setOff_nm(String val){ if(val==null) val=""; this.off_nm = val; }
	public void setRep_amt(int i)			{ rep_amt		= i;   } 
	public void setSup_amt(int i)			{ sup_amt		= i;   } 
	public void setAdd_amt(int i)			{ add_amt		= i;   } 
	public void setTot_amt(int i)			{ tot_amt		= i;   } 
	public void setCust_amt(int i)			{ cust_amt		= i;   } 
	public void setDly_amt(int i)			{ dly_amt		= i;   } 
	public void setPay_amt(int i)			{ pay_amt		= i;   } 
	public void setExt_v_amt(int i)			{ ext_v_amt		= i;   } 
	public void setExt_s_amt(int i)			{ ext_s_amt		= i;   } 
	public void setDly_days(String val){ if(val==null) val=""; this.dly_days = val; }
	public void setCust_req_dt(String str)	{ cust_req_dt	= str; } 
	public void setCust_plan_dt(String str)	{ cust_plan_dt	= str; } 
	public void setCust_pay_dt(String str)	{ cust_pay_dt	= str; } 
	public void setExt_dt(String str)		{ ext_dt	= str; }
	public void setExt_id(String str)		{ ext_id	= str; }
	public void setUpdate_dt(String str)	{ update_dt = str; }
	public void setUpdate_id(String str)	{ update_id = str; }
	public void setExt_tm(String str)	{ ext_tm = str; }
	public void setBill_doc_yn(String str)	{ bill_doc_yn = str; }
	public void setSeqId(String str)		{	seqid		= str; }
	public void setPubCode(String str)		{	pubcode		= str; }
	public void setSaleebill_yn(String str)	{ saleebill_yn = str; }
	public void setRent_st(String str)	{ rent_st = str; }
	public void setAgnt_email(String str)	{ agnt_email = str; }
	
	
	public String getRent_mng_id()	{ return rent_mng_id;	} 
	public String getRent_l_cd()	{ return rent_l_cd;		} 
	public String getCar_mng_id()	{ return car_mng_id; 	}    
	public String getAccid_id()		{ return accid_id; 		} 
	public String getServ_id()		{ return serv_id; 		} 
	public String getGubun()		{ return gubun; 		} 
	public String getAccid_dt()		{ return accid_dt;		} 
	public String getServ_st()		{ return serv_st;		} 
	public String getOff_id()		{ return off_id;		} 
	public String getOff_nm()		{ return off_nm;		} 
	public int    getRep_amt()		{ return rep_amt;		} 
	public int    getSup_amt()		{ return sup_amt;		} 
	public int    getAdd_amt()		{ return add_amt;		} 
	public int    getTot_amt()		{ return tot_amt;		} 
	public int    getCust_amt()		{ return cust_amt;		} 
	public int    getDly_amt()		{ return dly_amt;		} 
	public int    getPay_amt()		{ return pay_amt;		} 
	public int    getExt_v_amt()	{ return ext_v_amt;		} 
	public int    getExt_s_amt()	{ return ext_s_amt;		} 
	public String getDly_days()		{ return dly_days;		} 
	public String getCust_req_dt()	{ return cust_req_dt;	} 
	public String getCust_plan_dt()	{ return cust_plan_dt;	}
	public String getCust_pay_dt()	{ return cust_pay_dt;	}  
	public String getExt_dt()		{ return ext_dt; }  
	public String getExt_id()		{ return ext_id; }  
	public String getUpdate_dt()	{ return update_dt; }  
	public String getUpdate_id()	{ return update_id; }  
	public String getExt_tm()		{ return ext_tm; }  
	public String getBill_doc_yn()		{ return bill_doc_yn; }  
	public String getSeqId()		{	return seqid;		}  
	public String getPubCode()		{	return pubcode;		}  
	public String getSaleebill_yn()		{	return saleebill_yn;		}  
	public String getRent_st()		{	return rent_st;		}  
	public String getAgnt_email()		{	return agnt_email;		}  

}