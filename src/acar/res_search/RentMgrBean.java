//단기계약 관리자 관리

// 작성일 : 2003.12.11 (정현미)

package acar.res_search;

public class RentMgrBean
{
	private String rent_s_cd;	//단기계약관리번호
	private String mgr_st;		//구분:실운전자, 비상연락자, 연대보증인
	private String mgr_nm;		//성명
	private String ssn;			//주민등록번호
	private String zip;			//주소
	private String addr;		//우편번호
	private String lic_no;		//면허번호
	private String tel;			//전화번호
	private String etc;			//기타:관계...
	private String reg_id;			//등록자
	private String reg_dt;			//등록일
	private String update_id;		//수정자
	private String update_dt;		//수정일
	private String lic_st;		//면허번호종류
	
	public RentMgrBean()
	{
		rent_s_cd = "";    
		mgr_st = "";    
		mgr_nm = "";        
		ssn = "";
		zip = "";    
		addr = "";    
		lic_no = "";
		tel = "";    
		etc = "";
		reg_id = "";
		reg_dt = "";
		update_id = "";
		update_dt = "";
		lic_st = "";
	}
	
	public void setRent_s_cd(String str) 	{ rent_s_cd	= str; }
	public void setMgr_st(String str)		{ mgr_st	= str; }    
	public void setMgr_nm(String str)		{ mgr_nm	= str; }
	public void setSsn(String str)			{ ssn		= str; }		
	public void setZip(String str)			{ zip		= str; }
	public void setAddr(String str)			{ addr		= str; }
	public void setLic_no(String str)		{ lic_no	= str; }    	
	public void setTel(String str)			{ tel		= str; }		
	public void setEtc(String str)			{ etc		= str; }		
	public void setReg_id(String str)		{ reg_id	= str; }    
	public void setReg_dt(String str)		{ reg_dt	= str; }    
	public void setUpdate_id(String str)	{ update_id	= str; }    
	public void setUpdate_dt(String str)	{ update_dt	= str; }    
	public void setLic_st(String str)		{ lic_st	= str; }    	
	
	public String getRent_s_cd() 	{ return rent_s_cd;	}
	public String getMgr_st()		{ return mgr_st;	}
	public String getMgr_nm()		{ return mgr_nm;	}
	public String getSsn()			{ return ssn;		}
	public String getZip()			{ return zip;		}
	public String getAddr()			{ return addr;		}
	public String getLic_no()		{ return lic_no;	}
	public String getTel()			{ return tel;		}
	public String getEtc()			{ return etc;		}
	public String getReg_id()		{ return reg_id;	}
	public String getReg_dt()		{ return reg_dt;	}
	public String getUpdate_id()	{ return update_id;	}
	public String getUpdate_dt()	{ return update_dt;	}
	public String getLic_st()		{ return lic_st;	}

}