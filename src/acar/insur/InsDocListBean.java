package acar.insur;

import java.util.*;

public class InsDocListBean {
    //Table : ins_doc_list (보험해지요청공문 리스트)
	private String doc_id; 					
	private String car_mng_id;
	private String ins_st;
	private String exp_st;
	private String exp_dt;
	private String car_no_b;
	private String car_no_a;
	private String car_nm;
	private String app_st;
	private String reg_id;
	private String reg_dt;
	private String upd_id;
	private String upd_dt;
	private String ins_con_no;
	
    // CONSTRCTOR            
    public InsDocListBean() {  
		this.doc_id 		= ""; 					
		this.car_mng_id		= "";
		this.ins_st			= "";
		this.exp_st			= "";
		this.exp_dt			= "";
		this.car_no_b		= "";
		this.car_no_a		= "";
		this.car_nm			= "";
		this.app_st			= "";
		this.reg_id			= "";
		this.reg_dt			= "";
		this.upd_id			= "";
		this.upd_dt			= "";
		this.ins_con_no		= "";
	}
	// get Method
	public void setDoc_id 			(String val){		if(val==null) val="";	this.doc_id 		= val;	}
	public void setCar_mng_id		(String val){		if(val==null) val="";	this.car_mng_id		= val;	}
	public void setIns_st			(String val){		if(val==null) val="";	this.ins_st			= val;	}	
	public void setExp_st			(String val){		if(val==null) val="";	this.exp_st			= val;	}
	public void setExp_dt			(String val){		if(val==null) val="";	this.exp_dt			= val;	}	
	public void setCar_no_b			(String val){		if(val==null) val="";	this.car_no_b		= val;	}	
	public void setCar_no_a			(String val){		if(val==null) val="";	this.car_no_a		= val;	}	
	public void setCar_nm			(String val){		if(val==null) val="";	this.car_nm			= val;	}	
	public void setApp_st			(String val){		if(val==null) val="";	this.app_st			= val;	}	
	public void setReg_id			(String val){		if(val==null) val="";	this.reg_id			= val;	}	
	public void setReg_dt			(String val){		if(val==null) val="";	this.reg_dt			= val;	}	
	public void setUpd_id			(String val){		if(val==null) val="";	this.upd_id			= val;	}	
	public void setUpd_dt			(String val){		if(val==null) val="";	this.upd_dt			= val;	}	
	public void setIns_con_no		(String val){		if(val==null) val="";	this.ins_con_no		= val;	}	
		
	//Get Method
	public String getDoc_id 	(){		return doc_id; 		}
	public String getCar_mng_id	(){		return car_mng_id; 	}
	public String getIns_st		(){		return ins_st;      }
	public String getExp_st		(){		return exp_st;     	}	
	public String getExp_dt		(){		return exp_dt;     	}	
	public String getCar_no_b	(){		return car_no_b;   	}	
	public String getCar_no_a	(){		return car_no_a;   	}	
	public String getCar_nm		(){		return car_nm;     	}	
	public String getApp_st		(){		return app_st;     	}	
	public String getReg_id		(){		return reg_id;     	}		
	public String getReg_dt		(){		return reg_dt;     	}	
	public String getUpd_id		(){		return upd_id;     	}	
	public String getUpd_dt		(){		return upd_dt;     	}	
	public String getIns_con_no	(){		return ins_con_no; 	}	
}