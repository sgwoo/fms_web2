// Mobile  ȸ������


package cust.member;

public class MobileMemberBean
{
	private int seq;			//�Ϸù�ȣ
	private String email;		//����ȣ
	private String passwd;			//��뺻������ȣ
	private String fms_id;		//�α��ξ��̵�
	private String client_id;		//fms client
	private String r_site;		//fms r_site
	private String first_access;				//�α��κ�й�ȣ
	private String use_yn;			//��뿩��(Y/N)
	private String reg_dt;			//�����
	private String upd_dt;		//������
	private String c_name;		//�̸�
	private String birth;		//�������
	private String tel;		//����ó
	private String regid;		//������ȣ
	private String provider;		//provider
	
			
	public MobileMemberBean()
	{
		seq	= 0;        
		email	= "";    
		passwd = "";    
		fms_id = "";
		client_id = "";
		r_site = "";
		first_access = "";
		use_yn = "";
		email = "";
		reg_dt = "";
		upd_dt = "";	
		c_name = "";	
		birth = "";	
		tel = "";	
		regid = "";	
		provider = "";	
	}
	
	public void setSeq(int    str)			{seq			= str;	}
	public void setEmail(String str)			{ email		= str; }    
	public void setPasswd(String str) 	{ passwd		= str; }
	public void setFms_id(String str)		{ fms_id		= str; }    	
	public void setClient_id		(String str){		if(str==null) str="";		this.client_id		= str;	}
	public void setR_site		(String str){		if(str==null) str="";		this.r_site		= str;	}
	public void setFirst_access(String str)	{ first_access	= str; }    	
	public void setUse_yn(String str)		{ use_yn		= str; }   
	public void setReg_dt(String str)		{ reg_dt		= str; }    
	public void setUpd_dt(String str)	{ upd_dt		= str; }    
	public void setC_name		(String str){		if(str==null) str="";		this.c_name		= str;	}
	public void setBirth		(String str){		if(str==null) str="";		this.birth		= str;	}
	public void setTel		(String str){		if(str==null) str="";		this.tel		= str;	}
	public void setRegid(String str)	{ regid		= str; }    
	public void setProvider(String str)	{ provider		= str; }    

	public int	  getSeq		(){		return seq;		}
	public String getEmail() 	{ return email;		}
	public String getPasswd()		{ return passwd;		}
	public String getFms_id()	{ return fms_id;		}
	public String getClient_id()	{ return client_id;		}
	public String getR_site()	{ return r_site;		}
	public String getFirst_access()			{ return first_access;			}
	public String getUse_yn()		{ return use_yn;		}	
	public String getReg_dt()		{ return reg_dt;		}
	public String getUpd_dt()		{ return upd_dt;		}
	public String getC_name()		{ return c_name;		}
	public String getBirth()		{ return birth;		}
	public String getTel()		{ return tel;		}
	public String getRegid()		{ return regid;		}
	public String getProvider()		{ return provider;		}


}