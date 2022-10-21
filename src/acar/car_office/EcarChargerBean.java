package acar.car_office;

import java.util.*;

public class EcarChargerBean {
	private String rent_l_cd;
	private String rent_mng_id;
	private String client_id; 					
	private String car_mng_id;
	private String reg_id;
	private String reg_dt;
	private String chg_type;
	private String inst_off;
	private String inst_zip;
	private String inst_loc;
	private String pay_way;
	private String chg_prop;
	private String subsi_form_yn;
	private String doc_yn;
	private String use_yn;
	private String etc_inst_off;

	
    // CONSTRCTOR            
    public EcarChargerBean() {  
		this.rent_l_cd			= ""; 					
		this.rent_mng_id		= "";
		this.client_id			= "";
		this.car_mng_id		= "";
		this.reg_id				= "";
		this.reg_dt				= "";
		this.chg_type			= "";
		this.inst_off				= "";
		this.inst_zip				= "";
		this.inst_loc				= "";
		this.pay_way			= "";
		this.chg_prop			= "";
		this.subsi_form_yn	= "";
		this.doc_yn				= "";
		this.use_yn				= "";
		this.etc_inst_off		= "";
	}

	// get Method
	public void setRent_l_cd			(String val){		if(val==null) val="";	this.rent_l_cd			= val;	}
	public void setRent_mng_id		(String val){		if(val==null) val="";	this.rent_mng_id		= val;	}
	public void setClient_id			(String val){		if(val==null) val="";	this.client_id			= val;	}	
	public void setCar_mng_id		(String val){		if(val==null) val="";	this.car_mng_id		= val;	}
	public void setReg_id				(String val){		if(val==null) val="";	this.reg_id				= val;	}
	public void setReg_dt				(String val){		if(val==null) val="";	this.reg_dt				= val;	}	
	public void setChg_type			(String val){		if(val==null) val="";	this.chg_type			= val;	}	
	public void setInst_off				(String val){		if(val==null) val="";	this.inst_off				= val;	}
	public void setInst_zip				(String val){		if(val==null) val="";	this.inst_zip				= val;	}
	public void setInst_loc				(String val){		if(val==null) val="";	this.inst_loc				= val;	}
	public void setPay_way			(String val){		if(val==null) val="";	this.pay_way			= val;	}
	public void setChg_prop			(String val){		if(val==null) val="";	this.chg_prop			= val;	}	
	public void setSubsi_form_yn	(String val){		if(val==null) val="";	this.subsi_form_yn	= val;	}	
	public void setDoc_yn				(String val){		if(val==null) val="";	this.doc_yn				= val;	}
	public void setUse_yn				(String val){		if(val==null) val="";	this.use_yn				= val;	}
	public void setEtc_inst_off		(String val){		if(val==null) val="";	this.etc_inst_off		= val;	}
	

	//Get Method
	public String getRent_l_cd			(){		return rent_l_cd;	  			}
	public String getRent_mng_id		(){		return rent_mng_id;    	}
	public String getClient_id				(){		return client_id;        		}
	public String getCar_mng_id		(){		return car_mng_id;     		}
	public String getReg_id				(){		return reg_id;     				}	
	public String getReg_dt				(){		return reg_dt;         			}
	public String getChg_type			(){		return chg_type;    			}		
	public String getInst_off				(){		return inst_off;    			}	
	public String getInst_zip				(){		return inst_zip;        		}	
	public String getInst_loc				(){		return inst_loc;        		}	
	public String getPay_way				(){		return pay_way;          	}		
	public String getChg_prop			(){		return chg_prop;         	}		
	public String getSubsi_form_yn	(){		return subsi_form_yn; 	}	
	public String getDoc_yn				(){		return doc_yn;      			}		
	public String getUse_yn				(){		return use_yn;       			}
	public String getEtc_inst_off			(){		return etc_inst_off;  		}
	
}