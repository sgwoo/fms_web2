package acar.bank_mng;

public class WorkingFundBean
{
	private String fund_id;
	private String reg_id;         
	private String reg_dt;         
	private String fund_type;      
	private String cont_st;        
	private String cont_bn_st;     
	private String cont_bn;
	private String bn_br;          
	private String bn_tel;         
	private String bn_fax;         
	private String ba_agnt;        
	private String ba_title;       
	private long   cont_amt;      
	private String cont_dt;        
	private String renew_dt;       
	private String cls_est_dt;     
	private String cls_dt;         
	private long   rest_amt;       
	private String rest_b_dt;      
	private String bank_code;
	private String deposit_no;     
	private String pay_st;         
	private String security_st1;   
	private String security_st2;  
	private String security_st3;   
	private String note;           
	private String gua_org;        
	private String gua_s_dt;       
	private String gua_e_dt;      
	private String gua_int;        
	private long   gua_amt;        
	private long   gua_fee;        
	private String gua_agnt;       
	private String gua_title;      
	private String gua_tel;        
	private String gua_est_dt;     
	private String gua_docs;       
	private String realty_nm;      
	private String realty_zip;     
	private String realty_addr;    
	private long   cltr_amt;       
	private String cltr_dt;        
	private String cltr_st;       
	private String cltr_user;      
	private String cltr_lank;  
	private String fund_no;     
	private String lend_id;     
	private String revolving;     
	
	

	public WorkingFundBean()
	{
		fund_id       = "";
		reg_id        = "";
		reg_dt        = "";
		fund_type     = "";
		cont_st       = "";
		cont_bn_st    = "";
		cont_bn       = "";
		bn_br         = "";
		bn_tel        = "";
		bn_fax        = "";
		ba_agnt       = "";
		ba_title      = "";
		cont_amt      = 0;
		cont_dt       = "";
		renew_dt      = "";
		cls_est_dt    = "";
		cls_dt        = "";
		rest_amt      = 0;
		rest_b_dt     = "";
		bank_code     = "";
		deposit_no    = "";
		pay_st        = "";
		security_st1  = "";
		security_st2  = "";
		security_st3  = "";
		note          = "";
		gua_org       = "";
		gua_s_dt      = "";
		gua_e_dt      = "";
		gua_int       = "";
		gua_amt       = 0;
		gua_fee       = 0;
		gua_agnt      = "";
		gua_title     = "";
		gua_tel       = "";
		gua_est_dt    = "";
		gua_docs      = "";
		realty_nm     = "";
		realty_zip    = "";
		realty_addr   = "";
		cltr_amt      = 0;
		cltr_dt       = "";
		cltr_st       = "";
		cltr_user     = "";
		cltr_lank     = "";
		fund_no	      = "";
		lend_id	      = "";
		revolving	  = "";	


	}
	
	public void setFund_id			(String str)	{	fund_id       = str;	}
	public void setReg_id			(String str)	{	reg_id        = str;	}
	public void setReg_dt			(String str)	{	reg_dt        = str;	}
	public void setFund_type		(String str)	{	fund_type     = str;	}
	public void setCont_st			(String str)	{	cont_st       = str;	}
	public void setCont_bn_st		(String str)	{	cont_bn_st    = str;	}
	public void setCont_bn			(String str)	{	cont_bn       = str;	}
	public void setBn_br			(String str)	{	bn_br         = str;	}
	public void setBn_tel			(String str)	{	bn_tel        = str;	}
	public void setBn_fax			(String str)	{	bn_fax        = str;	}
	public void setBa_agnt			(String str)	{	ba_agnt       = str;	}
	public void setBa_title			(String str)	{	ba_title      = str;	}
	public void setCont_amt			(long   i  )	{	cont_amt      = i;  	}
	public void setCont_dt			(String str)	{	cont_dt       = str;	}
	public void setRenew_dt			(String str)	{	renew_dt      = str;	}
	public void setCls_est_dt		(String str)	{	cls_est_dt    = str;	}
	public void setCls_dt			(String str)	{	cls_dt        = str;	}
	public void setRest_amt			(long   i  )	{	rest_amt      = i;  	}
	public void setRest_b_dt		(String str)	{	rest_b_dt     = str;	}
	public void setBank_code		(String str)	{	bank_code     = str;	}
	public void setDeposit_no		(String str)	{	deposit_no    = str;	}
	public void setPay_st			(String str)	{	pay_st        = str;	}
	public void setSecurity_st1		(String str)	{	security_st1  = str;	}
	public void setSecurity_st2		(String str)	{	security_st2  = str;	}
	public void setSecurity_st3		(String str)	{	security_st3  = str;	}
	public void setNote				(String str)	{	note          = str;	}
	public void setGua_org			(String str)	{	gua_org       = str;	}
	public void setGua_s_dt			(String str)	{	gua_s_dt      = str;	}
	public void setGua_e_dt			(String str)	{	gua_e_dt      = str;	}
	public void setGua_int			(String str)	{	gua_int       = str;	}
	public void setGua_amt			(long   i  )	{	gua_amt       = i;	    }
	public void setGua_fee			(long   i  )	{	gua_fee       = i;  	}
	public void setGua_agnt			(String str)	{	gua_agnt      = str;	}
	public void setGua_title		(String str)	{	gua_title     = str;	}
	public void setGua_tel			(String str)	{	gua_tel       = str;	}
	public void setGua_est_dt		(String str)	{	gua_est_dt    = str;	}
	public void setGua_docs			(String str)	{	gua_docs      = str;	}
	public void setRealty_nm		(String str)	{	realty_nm     = str;	}
	public void setRealty_zip		(String str)	{	realty_zip    = str;	}
	public void setRealty_addr		(String str)	{	realty_addr   = str;	}
	public void setCltr_amt			(long   i  )	{	cltr_amt      = i;  	}
	public void setCltr_dt			(String str)	{	cltr_dt       = str;	}
	public void setCltr_st			(String str)	{	cltr_st       = str;	}
	public void setCltr_user		(String str)	{	cltr_user     = str;	}
	public void setCltr_lank		(String str)	{	cltr_lank     = str;	}
	public void setFund_no			(String str)	{	fund_no	      = str;	}
	public void setLend_id			(String str)	{	lend_id	      = str;	}
	public void setRevolving		(String str)	{	revolving     = str;	}
	
	
	public String getFund_id		()				{	return	fund_id;        }
	public String getReg_id			()				{	return	reg_id;         }
	public String getReg_dt			()				{	return	reg_dt;         }
	public String getFund_type		()				{	return	fund_type;      }
	public String getCont_st		()				{	return	cont_st;        }
	public String getCont_bn_st		()				{	return	cont_bn_st;     }
	public String getCont_bn		()				{	return	cont_bn;        }
	public String getBn_br			()				{	return	bn_br;          }
	public String getBn_tel			()				{	return	bn_tel;         }
	public String getBn_fax			()				{	return	bn_fax;         }
	public String getBa_agnt		()				{	return	ba_agnt;        }
	public String getBa_title		()				{	return	ba_title;       }
	public long    getCont_amt		()				{	return	cont_amt;       }
	public String getCont_dt		()				{	return	cont_dt;        }
	public String getRenew_dt		()				{	return	renew_dt;       }
	public String getCls_est_dt		()				{	return	cls_est_dt;     }
	public String getCls_dt			()				{	return	cls_dt;         }
	public long   getRest_amt		()				{	return	rest_amt;       }
	public String getRest_b_dt		()				{	return	rest_b_dt;      }
	public String getBank_code		()				{	return	bank_code;      }
	public String getDeposit_no		()				{	return	deposit_no;     }
	public String getPay_st			()				{	return	pay_st;         }
	public String getSecurity_st1	()				{	return	security_st1;   }
	public String getSecurity_st2	()				{	return	security_st2;   }
	public String getSecurity_st3	()				{	return	security_st3;   }
	public String getNote			()				{	return	note;           }
	public String getGua_org		()				{	return	gua_org;        }
	public String getGua_s_dt		()				{	return	gua_s_dt;       }
	public String getGua_e_dt		()				{	return	gua_e_dt;       }
	public String getGua_int		()				{	return	gua_int;        }
	public long   getGua_amt		()				{	return	gua_amt;        }
	public long   getGua_fee		()				{	return	gua_fee;        }
	public String getGua_agnt		()				{	return	gua_agnt;       }
	public String getGua_title		()				{	return	gua_title;      }
	public String getGua_tel		()				{	return	gua_tel;        }
	public String getGua_est_dt		()				{	return	gua_est_dt;     }
	public String getGua_docs		()				{	return	gua_docs;       }
	public String getRealty_nm		()				{	return	realty_nm;      }
	public String getRealty_zip		()				{	return	realty_zip;     }
	public String getRealty_addr	()				{	return	realty_addr;    }
	public long   getCltr_amt		()				{	return	cltr_amt;       }
	public String getCltr_dt		()				{	return	cltr_dt;        }
	public String getCltr_st		()				{	return	cltr_st;        }
	public String getCltr_user		()				{	return	cltr_user;      }
	public String getCltr_lank		()				{	return	cltr_lank;      }
	public String getFund_no		()				{	return	fund_no;	    }
	public String getLend_id		()				{	return	lend_id;	    }
	public String getRevolving		()				{	return	revolving;	    }

}

