// �ܱ������

// �ۼ��� : 2003.12.11 (������)

package acar.res_search;

public class RentCustBean
{
	private String cust_id;		//�ܱ��������ȣ
	private String client_id;	//����������ȣ(����)
	private String cust_st;		//������:����,����,..
	private String cust_nm;		//����
	private String firm_nm;		//��ȣ
	private String ssn;			//�ֹε�Ϲ�ȣ
	private String enp_no;		//����ڵ�Ϲ�ȣ
	private String zip;			//�����ȣ
	private String addr;		//�ּ�
	private String lic_no;		//�����ȣ
	private String lic_st;		//��������
	private String tel;			//��ȭ��ȣ
	private String m_tel;		//�޴���
	private String email;		//�̸���
	private String etc;			//��Ÿ,Ư�̻���
	private String rank;		//���:�Ϲ�,���,�ҷ�
	private String reg_id;			//�����
	private String reg_dt;			//�����
	private String update_id;		//������
	private String update_dt;		//������

	private String dept_nm;
	private String brch_nm;
	private String car_no = "";
	private String car_nm = "";
	
	public RentCustBean()
	{
		cust_id	= "";    
		client_id = "";
		cust_st	= "";    
		cust_nm	= "";        
		firm_nm = "";    
		ssn = "";
		enp_no = "";    
		zip = "";    
		addr = "";    
		lic_no = "";
		lic_st = "";
		tel = "";    
		m_tel = "";    
		email = "";
		etc = "";
		rank = "";    
		reg_id = "";
		reg_dt = "";
		update_id = "";
		update_dt = "";
		dept_nm = "";
		brch_nm = "";
		car_no = "";
		car_nm = "";
	}
	
	public void setCust_id(String str) 		{ cust_id	= str; }
	public void setClient_id(String str)	{ client_id	= str; }    
	public void setCust_st(String str)		{ cust_st	= str; }
	public void setCust_nm(String str)		{ cust_nm	= str; }
	public void setFirm_nm(String str)		{ firm_nm	= str; }		
	public void setSsn(String str)			{ ssn		= str; }		
	public void setEnp_no(String str)		{ enp_no	= str; }    
	public void setZip(String str)			{ zip		= str; }
	public void setAddr(String str)			{ addr		= str; }
	public void setLic_no(String str)		{ lic_no	= str; }    	
	public void setLic_st(String str)		{ lic_st	= str; }    	
	public void setTel(String str)			{ tel		= str; }		
	public void setM_tel(String str)		{ m_tel		= str; }		
	public void setEmail(String str)		{ email		= str; }			
	public void setEtc(String str)			{ etc		= str; }		
	public void setRank(String str)			{ rank		= str; }    
	public void setReg_id(String str)		{ reg_id		= str; }    
	public void setReg_dt(String str)		{ reg_dt		= str; }    
	public void setUpdate_id(String str)	{ update_id		= str; }    
	public void setUpdate_dt(String str)	{ update_dt		= str; }    
	public void setDept_nm(String str)		{ dept_nm		= str; }    
	public void setBrch_nm(String str)		{ brch_nm		= str; }    
	public void setCar_no(String str)		{ car_no		= str; }
	public void setCar_nm(String str)		{ car_nm		= str; }
	
	public String getCust_id() 		{ return cust_id;	}
	public String getClient_id() 	{ return client_id;	}
	public String getCust_st()		{ return cust_st;	}
	public String getCust_nm()		{ return cust_nm;	}
	public String getFirm_nm()		{ return firm_nm;	}
	public String getSsn()			{ return ssn;		}
	public String getEnp_no()		{ return enp_no;	}
	public String getZip()			{ return zip;		}
	public String getAddr()			{ return addr;		}
	public String getLic_no()		{ return lic_no;	}
	public String getLic_st()		{ return lic_st;	}
	public String getTel()			{ return tel;		}
	public String getM_tel()		{ return m_tel;		}
	public String getEmail()		{ return email;		}
	public String getEtc()			{ return etc;		}
	public String getRank()			{ return rank;		}
	public String getReg_id()		{ return reg_id;		}
	public String getReg_dt()		{ return reg_dt;		}
	public String getUpdate_id()	{ return update_id;		}
	public String getUpdate_dt()	{ return update_dt;		}
	public String getDept_nm()		{ return dept_nm;		}
	public String getBrch_nm()		{ return brch_nm;		}
	public String getCar_no()		{ return car_no;		}
	public String getCar_nm()		{ return car_nm;		}

}