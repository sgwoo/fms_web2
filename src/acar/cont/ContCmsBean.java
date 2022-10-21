package acar.cont;

public class ContCmsBean
{
	private String rent_mng_id; 
	private String rent_l_cd;
	private String seq;
	private String cms_st;
	private int    cms_amt;
	private String cp_st;
	private String cms_start_dt; 
	private String cms_end_dt; 
	private String cms_day; 
	private String cms_bank; 
	private String cms_acc_no; 
	private String cms_dep_nm; 
	private String cms_dep_ssn; 
	private String cms_dep_post; 
	private String cms_dep_addr; 
	private String cms_etc; 
	private String cms_tel;
	private String cms_m_tel;
	private String cms_email;
	private String app_dt;
	private String reg_dt;
	private String reg_id;
	private String update_dt;
	private String update_id;
	private String reg_st;
	private String bank_cd;
	private String cbit;
	private String app_id;
	private String c_firm_nm;
	private String c_enp_no;
	private String c_mm;
	private String c_yyyy;
	private String adate;
	private String cms_bk;
										
	public ContCmsBean()
	{
		rent_mng_id = "";   
		rent_l_cd 	= "";   
		seq 		= "";   
		cms_st 		= "";
		cms_amt		= 0;   
		cp_st		= "";   
		cms_start_dt= "";   
		cms_end_dt 	= "";   
		cms_day		= "";   
		cms_bank	= "";   
		cms_acc_no	= "";   
		cms_dep_nm	= "";   
		cms_dep_ssn = "";   
		cms_dep_post= "";  
		cms_dep_addr= "";   
		cms_etc		= "";   
		cms_tel		= "";   
		cms_m_tel	= "";   
		cms_email	= "";   				
		app_dt		= "";
		reg_dt		= "";
		reg_id		= "";
		update_dt	= "";
		update_id	= "";
		reg_st		= "";
		bank_cd		= "";
		cbit		= "";
		app_id		= "";
		c_firm_nm	= "";
		c_enp_no	= "";
		c_mm		= "";
		c_yyyy		= "";
		adate		= "";
		cms_bk		= "";
	}
	
	public void setRent_mng_id(String str)	{ rent_mng_id	= str; }
	public void setRent_l_cd(String str)	{ rent_l_cd 	= str; } 	
	public void setSeq(String str)			{ seq 			= str; } 		
	public void setCms_st(String str)		{ cms_st		= str; } 
	public void setCms_amt(int i)			{ cms_amt 		= i;   } 
	public void setCp_st(String str)		{ cp_st			= str; } 	
	public void setCms_start_dt(String str)	{ cms_start_dt	= str; } 	
	public void setCms_end_dt(String str)	{ cms_end_dt    = str; } 
	public void setCms_day(String str)		{ cms_day		= str; } 
	public void setCms_bank(String str)		{ cms_bank		= str; } 
	public void setCms_acc_no(String str)	{ cms_acc_no	= str; } 
	public void setCms_dep_nm(String str)	{ cms_dep_nm	= str; } 
	public void setCms_dep_ssn(String str)	{ cms_dep_ssn	= str; } 
	public void setCms_dep_post(String str)	{ cms_dep_post	= str; } 
	public void setCms_dep_addr(String str)	{ cms_dep_addr	= str; } 
	public void setCms_etc(String str)		{ cms_etc		= str; } 
	public void setCms_tel(String str)		{ cms_tel		= str; } 
	public void setCms_m_tel(String str)	{ cms_m_tel		= str; } 
	public void setCms_email(String str)	{ cms_email		= str; } 
	public void setApp_dt(String str)		{ app_dt		= str; } 
	public void setReg_dt(String str)		{ reg_dt		= str; } 
	public void setReg_id(String str)		{ reg_id		= str; } 
	public void setUpdate_dt(String str)	{ update_dt		= str; } 
	public void setUpdate_id(String str)	{ update_id		= str; } 
	public void setReg_st(String str)		{ reg_st		= str; } 	
	public void setBank_cd(String str)		{ bank_cd		= str; } 	
	public void setCbit(String str)			{ cbit			= str; } 
	public void setApp_id(String str)		{ app_id		= str; } 
	public void setC_firm_nm(String str)	{ c_firm_nm		= str; } 
	public void setC_enp_no	(String str)	{ c_enp_no		= str; } 
	public void setC_mm		(String str)	{ c_mm			= str; } 
	public void setC_yyyy	(String str)	{ c_yyyy		= str; } 
	public void setAdate	(String str)	{ adate			= str; } 
	public void setCms_bk	(String str)	{ cms_bk		= str; } 


	public String getRent_mng_id()	{ return rent_mng_id;	}
	public String getRent_l_cd()	{ return rent_l_cd;		}
	public String getSeq()			{ return seq;			}
	public String getCms_st()		{ return cms_st;		}
	public int    getCms_amt()		{ return cms_amt;		}
	public String getCp_st()		{ return cp_st;			}
	public String getCms_start_dt()	{ return cms_start_dt;	}
	public String getCms_end_dt()	{ return cms_end_dt;	}
	public String getCms_day()		{ return cms_day;		}
	public String getCms_bank()		{ return cms_bank;		}
	public String getCms_acc_no()	{ return cms_acc_no;	}
	public String getCms_dep_nm()	{ return cms_dep_nm;	}
	public String getCms_dep_ssn()	{ return cms_dep_ssn;	}
	public String getCms_dep_post()	{ return cms_dep_post;	}
	public String getCms_dep_addr()	{ return cms_dep_addr;	}
	public String getCms_etc()		{ return cms_etc;		}
	public String getCms_tel()		{ return cms_tel;		}
	public String getCms_m_tel()	{ return cms_m_tel;		}
	public String getCms_email()	{ return cms_email;		}
	public String getApp_dt()		{ return app_dt;		}
	public String getReg_dt()		{ return reg_dt;		}
	public String getReg_id()		{ return reg_id;		}
	public String getUpdate_dt()	{ return update_dt;		}
	public String getUpdate_id()	{ return update_id;		}	
	public String getReg_st()		{ return reg_st;		}	
	public String getBank_cd()		{ return bank_cd;		}	
	public String getCbit()			{ return cbit;			}
	public String getApp_id()		{ return app_id;		}
	public String getC_firm_nm	()	{ return c_firm_nm;		}
	public String getC_enp_no	()	{ return c_enp_no;		}
	public String getC_mm		()	{ return c_mm;			}
	public String getC_yyyy		()	{ return c_yyyy;		}
	public String getAdate		()	{ return adate;			}
	public String getCms_bk		()	{ return cms_bk;		}
	
}



