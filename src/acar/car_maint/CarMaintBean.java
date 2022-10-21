/**
 * 정기검사
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.car_maint;

import java.util.*;

public class CarMaintBean {
    //Table :

	private String rent_mng_id;
	private String rent_l_cd;
	private String brch_id;
	private String mng_id;
	private String car_mng_id;
	private String car_no;
	private String init_reg_dt;
	private String maint_st_dt;
	private String maint_end_dt;
	private String client_nm;
	private String firm_nm;
	private String user_nm;
	private String reg_id;
	private String reg_dt;
	
        
    // CONSTRCTOR            
    public CarMaintBean() {  
		this.rent_mng_id	= "";
		this.rent_l_cd		= "";
		this.brch_id		= "";
		this.mng_id			= "";
		this.car_mng_id		= "";
		this.car_no			= "";
		this.init_reg_dt	= "";
		this.maint_st_dt	= "";
		this.maint_end_dt	= "";
		this.client_nm		= "";
		this.firm_nm		= "";
		this.user_nm		= "";
		this.reg_id			= "";
		this.reg_dt			= "";
	}

	// get Method
	public void setRent_mng_id	(String val){		if(val==null) val="";		this.rent_mng_id	= val;	}
	public void setRent_l_cd	(String val){		if(val==null) val="";		this.rent_l_cd		= val;	}
	public void setBrch_id		(String val){		if(val==null) val="";		this.brch_id		= val;	}
	public void setMng_id		(String val){		if(val==null) val="";		this.mng_id			= val;	}
	public void setCar_mng_id	(String val){		if(val==null) val="";		this.car_mng_id		= val;	}
	public void setCar_no		(String val){		if(val==null) val="";		this.car_no			= val;	}
	public void setInit_reg_dt	(String val){		if(val==null) val="";		this.init_reg_dt	= val;	}
	public void setMaint_st_dt	(String val){		if(val==null) val="";		this.maint_st_dt	= val;	}
	public void setMaint_end_dt	(String val){		if(val==null) val="";		this.maint_end_dt	= val;	}
	public void setClient_nm	(String val){		if(val==null) val="";		this.client_nm		= val;	}
	public void setFirm_nm		(String val){		if(val==null) val="";		this.firm_nm		= val;	}
	public void setUser_nm		(String val){		if(val==null) val="";		this.user_nm		= val;	}
	public void setReg_id		(String val){		if(val==null) val="";		this.reg_id			= val;	}
	public void setReg_dt		(String val){		if(val==null) val="";		this.reg_dt			= val;	}
	
	//Get Method
	public String getRent_mng_id	(){		return rent_mng_id;		}
	public String getRent_l_cd		(){		return rent_l_cd;		}
	public String getBrch_id		(){		return brch_id;			}
	public String getMng_id			(){		return mng_id;			}
	public String getCar_mng_id		(){		return car_mng_id;		}
	public String getCar_no			(){		return car_no;			}
	public String getInit_reg_dt	(){		return init_reg_dt;		}
	public String getMaint_st_dt	(){		return maint_st_dt;		}
	public String getMaint_end_dt	(){		return maint_end_dt;	}
	public String getClient_nm		(){		return client_nm;		}
	public String getFirm_nm		(){		return firm_nm;			}
	public String getUser_nm		(){		return user_nm;			}
	public String getReg_id			(){		return reg_id;			}
	public String getReg_dt			(){		return reg_dt;			}
	
}