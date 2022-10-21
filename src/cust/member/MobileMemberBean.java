// Mobile  회원관리


package cust.member;

public class MobileMemberBean
{
	private int seq;			//일련번호
	private String email;		//고객번호
	private String passwd;			//사용본거지번호
	private String fms_id;		//로그인아이디
	private String client_id;		//fms client
	private String r_site;		//fms r_site
	private String first_access;				//로그인비밀번호
	private String use_yn;			//사용여부(Y/N)
	private String reg_dt;			//등록일
	private String upd_dt;		//수정일
	private String c_name;		//이름
	private String birth;		//생년월일
	private String tel;		//연락처
	private String regid;		//고유번호
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