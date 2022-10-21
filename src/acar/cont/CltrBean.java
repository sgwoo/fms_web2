package acar.cont;

public class CltrBean
{
	private String rent_mng_id;		//계약관리번호  
	private String rent_l_cd;		//계약번호      
	private String cltr_id;			//일련번호      
	private int    cltr_amt;		//근저당설정금액
	private String cltr_per_loan;   //대출금액대비율
	private String cltr_exp_dt;		//말소일자  
	private String cltr_set_dt;		//설정일자    
	private int    reg_tax;			//수수료        
	private int    cltr_fee;		//설정등록세    
	private String cltr_pay_dt;		//지출일    
	private String cltr_docs_dt;	//설정서류작성일자
	private int	   cltr_f_amt;		//설정가액
	private String cltr_exp_cau;	//말소사유
	private String mort_lank;		//저당권순위
	private String cltr_user;		//근저당권자
	private String clrr_office;		//등록관청
	private String clrr_offi_man;	//담당자
	private String cltr_offi_tel;	//전화번호
	private String cltr_offi_fax;	//팩스
	private int    set_stp_fee;		//설정인지대
	private int    exp_tax;			//말소등록대
	private int    exp_stp_fee;		//말소인지대
	private String cltr_st;			//근저당설정 체크
	private String cltr_num;		//을부번호

	public CltrBean()
	{
		rent_mng_id 	= ""; 
		rent_l_cd 		= ""; 
		cltr_id		 	= ""; 
		cltr_amt		= 0;  
		cltr_per_loan 	= ""; 
		cltr_exp_dt	 	= ""; 
		cltr_set_dt	 	= ""; 
		reg_tax		 	= 0;  
		cltr_fee		= 0;  
		cltr_pay_dt		= ""; 
		cltr_docs_dt	= "";
		cltr_f_amt		= 0;
		cltr_exp_cau	= "";
		mort_lank		= "";
		cltr_user		= "";
		clrr_office		= "";
		clrr_offi_man	= "";
		cltr_offi_tel	= "";
		cltr_offi_fax	= "";
		set_stp_fee		= 0;
		exp_tax			= 0;
		exp_stp_fee		= 0;
		cltr_st			= "";
		cltr_num		= "";
	}
	
	public void setRent_mng_id(String str)	{ rent_mng_id 	= str;	}
	public void setRent_l_cd(String str)	{ rent_l_cd 	= str;	} 	
	public void setCltr_id(String str)		{ cltr_id 		= str;	}		
	public void setCltr_amt(int i)			{ cltr_amt 		= i;	}		
	public void setCltr_per_loan(String str){ cltr_per_loan = str;	} 
	public void setCltr_exp_dt(String str)	{ cltr_exp_dt 	= str;	}	
	public void setCltr_set_dt(String str)	{ cltr_set_dt 	= str;	}	
	public void setReg_tax(int i)			{ reg_tax	 	= i;	}		
	public void setCltr_fee(int i)			{ cltr_fee 		= i;	}		
	public void setCltr_pay_dt(String str)	{ cltr_pay_dt 	= str;	}	
	public void setCltr_docs_dt(String str)	{ cltr_docs_dt 	= str;	}	
	public void setCltr_f_amt(int i)		{ cltr_f_amt	= i;	}		
	public void setCltr_exp_cau(String str)	{ cltr_exp_cau 	= str;	}	
	public void setMort_lank(String str)	{ mort_lank 	= str;	}	
	public void setCltr_user(String str)	{ cltr_user 	= str;	}	
	public void setCltr_office(String str)	{ clrr_office 	= str;	}	
	public void setCltr_offi_man(String str){ clrr_offi_man	= str;	}	
	public void setCltr_offi_tel(String str){ cltr_offi_tel	= str;	}	
	public void setCltr_offi_fax(String str){ cltr_offi_fax	= str;	}	
	public void setSet_stp_fee(int i)		{ set_stp_fee	= i;	}		
	public void setExp_tax(int i)			{ exp_tax		= i;	}		
	public void setExp_stp_fee(int i)		{ exp_stp_fee	= i;	}		
	public void setCltr_st(String str)		{ cltr_st		= str;	}	
	public void setCltr_num(String str)		{ cltr_num		= str;	}	
	
	public String getRent_mng_id()	{ return rent_mng_id;	}
	public String getRent_l_cd()	{ return rent_l_cd;		}
	public String getCltr_id()		{ return cltr_id;		}
	public int    getCltr_amt()		{ return cltr_amt;		}
	public String getCltr_per_loan(){ return cltr_per_loan; }
	public String getCltr_exp_dt()	{ return cltr_exp_dt;	}
	public String getCltr_set_dt()	{ return cltr_set_dt;	}
	public int    getReg_tax()		{ return reg_tax;		}
	public int    getCltr_fee()		{ return cltr_fee;		}
	public String getCltr_pay_dt()	{ return cltr_pay_dt;	}
	public String getCltr_docs_dt()	{ return cltr_docs_dt;	}
	public int    getCltr_f_amt()	{ return cltr_f_amt;	}
	public String getCltr_exp_cau()	{ return cltr_exp_cau;	}
	public String getMort_lank()	{ return mort_lank;		}
	public String getCltr_user()	{ return cltr_user;		}
	public String getCltr_office()	{ return clrr_office;	}
	public String getCltr_offi_man(){ return clrr_offi_man; }
	public String getCltr_offi_tel(){ return cltr_offi_tel; }
	public String getCltr_offi_fax(){ return cltr_offi_fax; }
	public int    getSet_stp_fee()	{ return set_stp_fee;	}
	public int    getExp_tax()		{ return exp_tax;		}
	public int    getExp_stp_fee()	{ return exp_stp_fee;	}
	public String getCltr_st()		{ return cltr_st;		}
	public String getCltr_num()		{ return cltr_num;		}

}