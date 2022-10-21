package acar.cont;

public class CltrBean
{
	private String rent_mng_id;		//��������ȣ  
	private String rent_l_cd;		//����ȣ      
	private String cltr_id;			//�Ϸù�ȣ      
	private int    cltr_amt;		//�����缳���ݾ�
	private String cltr_per_loan;   //����ݾ״����
	private String cltr_exp_dt;		//��������  
	private String cltr_set_dt;		//��������    
	private int    reg_tax;			//������        
	private int    cltr_fee;		//������ϼ�    
	private String cltr_pay_dt;		//������    
	private String cltr_docs_dt;	//���������ۼ�����
	private int	   cltr_f_amt;		//��������
	private String cltr_exp_cau;	//���һ���
	private String mort_lank;		//����Ǽ���
	private String cltr_user;		//���������
	private String clrr_office;		//��ϰ�û
	private String clrr_offi_man;	//�����
	private String cltr_offi_tel;	//��ȭ��ȣ
	private String cltr_offi_fax;	//�ѽ�
	private int    set_stp_fee;		//����������
	private int    exp_tax;			//���ҵ�ϴ�
	private int    exp_stp_fee;		//����������
	private String cltr_st;			//�����缳�� üũ
	private String cltr_num;		//���ι�ȣ

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