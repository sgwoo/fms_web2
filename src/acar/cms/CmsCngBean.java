package acar.cms;

import java.util.*;

public class CmsCngBean {
    //Table : comp
    private String rent_mng_id;     
    private String rent_l_cd;   
    private String req_id;       
    private String req_dt;    
    private String cms_bank;      
    private String cms_acc_no;  
    private String cms_dep_nm;    
    private String cms_dep_ssn;    
    private String app_dt;   
    private String app_id;
	 private String app_st;
	 private String bank_cd;
	 private String old_cms_bank;      
    private String old_cms_acc_no;  
    private String est_dt;  
    

    // CONSTRCTOR            
    public CmsCngBean () {  
    	this.rent_mng_id		= "";	  
	    this.rent_l_cd			= "";
	    this.req_id			= "";
		this.req_dt		= "";
		this.cms_bank	= "";
    	this.cms_acc_no		= "";
	    this.cms_dep_nm		= "";
	    this.cms_dep_ssn			= "";
    	this.app_dt			= "";
	    this.app_id		= "";
	    this.app_st			= "";
	    this.bank_cd			= "";
	   	this.old_cms_bank	= "";
    	this.old_cms_acc_no		= "";
    	this.est_dt		= "";
       
	}


	// get Method
	public void setRent_mng_id			(String val){		if(val==null) val="";		this.rent_mng_id		= val;	}
	public void setRent_l_cd			(String val){		if(val==null) val="";		this.rent_l_cd			= val;	}
	public void setReq_id			(String val){		if(val==null) val="";		this.req_id			= val;	}
	public void setReq_dt		(String val){		if(val==null) val="";		this.req_dt		= val;	}
	public void setCms_bank		(String val){		if(val==null) val="";		this.cms_bank	= val;	}
	public void setCms_acc_no		(String val){		if(val==null) val="";		this.cms_acc_no		= val;	}
	public void setOld_cms_bank		(String val){		if(val==null) val="";		this.old_cms_bank	= val;	}
	public void setOld_cms_acc_no		(String val){		if(val==null) val="";		this.old_cms_acc_no		= val;	}
	public void setCms_dep_nm		(String val){		if(val==null) val="";		this.cms_dep_nm		= val;	}
	public void setCms_dep_ssn			(String val){		if(val==null) val="";		this.cms_dep_ssn			= val;	}
	public void setApp_dt			(String val){		if(val==null) val="";		this.app_dt			= val;	}
	public void setApp_id			(String val){		if(val==null) val="";		this.app_id		= val;	}
	public void setApp_st			(String val){		if(val==null) val="";		this.app_st			= val;	}
	public void setBank_cd		(String val){		if(val==null) val="";		this.bank_cd			= val;	}
	public void setEst_dt		(String val){		if(val==null) val="";		this.est_dt			= val;	}
	
	//Get Method
	public String getRent_mng_id		(){		return rent_mng_id;			}
	public String getRent_l_cd			(){		return rent_l_cd;			}
	public String getReq_id			(){		return req_id;			}
	public String getReq_dt		(){		return req_dt;		}
	public String getCms_bank	(){		return cms_bank;		}
	public String getCms_acc_no		(){		return cms_acc_no;		}
	public String getCms_dep_nm		(){		return cms_dep_nm;		}
	public String getCms_dep_ssn			(){		return cms_dep_ssn;			}
	public String getApp_dt			(){		return app_dt;			}
	public String getApp_id		(){		return app_id;			}
	public String getApp_st		(){		return app_st;			}
	public String getBank_cd	(){		return bank_cd;			}
	public String getOld_cms_bank	(){		return old_cms_bank;		}
	public String getOld_cms_acc_no		(){		return old_cms_acc_no;		}
	public String getEst_dt		(){		return est_dt;		}
	
}