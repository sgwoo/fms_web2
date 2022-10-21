package acar.forfeit_mng;

import java.util.*;

public class FineGovBean {
    //Table : fine_gov (과태료 청구기관)
	private String	gov_id; 					
	private String	gov_nm;
	private String	mng_dept;
	private String	tel;
	private String	fax;
	private String	zip;
	private String	addr;
	private String	gov_st;
	private String	mng_nm;
	private String	mng_pos;
	private String	bank_nm;	
	private String	bank_no;	
	private String	ven_code;	
	private String	ven_name;
	private String  use_yn;
	private String	gov_nm2;
	private String	gov_dept_code;

        
    // CONSTRCTOR            
    public FineGovBean() {  
		this.gov_id		= ""; 					
		this.gov_nm		= "";
		this.mng_dept	= "";
		this.tel		= "";
		this.fax		= "";
		this.zip		= "";
		this.addr		= "";
		this.gov_st		= "";
		this.mng_nm		= "";
		this.mng_pos	= "";
		this.bank_nm	= "";
		this.bank_no	= "";
		this.ven_code	= "";
		this.ven_name	= "";
		this.use_yn		= "";
		this.gov_nm2		= "";
		this.gov_dept_code = "";
	}

	// get Method
	public void setGov_id		(String val){		if(val==null) val="";	this.gov_id		= val;	}
	public void setGov_nm		(String val){		if(val==null) val="";	this.gov_nm		= val;	}
	public void setMng_dept		(String val){		if(val==null) val="";	this.mng_dept	= val;	}	
	public void setTel			(String val){		if(val==null) val="";	this.tel		= val;	}	
	public void setFax			(String val){		if(val==null) val="";	this.fax		= val;	}	
	public void setZip			(String val){		if(val==null) val="";	this.zip		= val;	}	
	public void setAddr			(String val){		if(val==null) val="";	this.addr		= val;	}	
	public void setGov_st		(String val){		if(val==null) val="";	this.gov_st		= val;	}	
	public void setMng_nm		(String val){		if(val==null) val="";	this.mng_nm		= val;	}	
	public void setMng_pos		(String val){		if(val==null) val="";	this.mng_pos	= val;	}	
	public void setBank_nm		(String val){		if(val==null) val="";	this.bank_nm	= val;	}
	public void setBank_no		(String val){		if(val==null) val="";	this.bank_no	= val;	}
	public void setVen_code		(String val){		if(val==null) val="";	this.ven_code	= val;	}
	public void setVen_name		(String val){		if(val==null) val="";	this.ven_name	= val;	}
	public void setUse_yn		(String val){		if(val==null) val="";	this.use_yn		= val;	}
	public void setGov_nm2		(String val){		if(val==null) val="";	this.gov_nm2	= val;	}
	public void setGov_dept_code(String val){		if(val==null) val="";	this.gov_dept_code	= val;	}
		
	//Get Method
	public String getGov_id		(){		return gov_id;		}
	public String getGov_nm		(){		return gov_nm;		}
	public String getMng_dept	(){		return mng_dept;	}	
	public String getTel		(){		return tel;			}	
	public String getFax		(){		return fax;			}	
	public String getZip		(){		return zip;			}	
	public String getAddr		(){		return addr;		}	
	public String getGov_st		(){		return gov_st;		}
	public String getMng_nm		(){		return mng_nm;		}	
	public String getMng_pos	(){		return mng_pos;		}
	public String getBank_nm	(){		return bank_nm;		}
	public String getBank_no	(){		return bank_no;		}
	public String getVen_code	(){		return ven_code;	}
	public String getVen_name	(){		return ven_name;	}
	public String getUse_yn		(){		return use_yn;		}
	public String getGov_nm2	(){		return gov_nm2;		}
	public String getGov_dept_code(){	return gov_dept_code;	}
	
}