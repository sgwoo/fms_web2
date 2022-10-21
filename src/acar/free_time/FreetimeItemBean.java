
package acar.free_time;

import java.util.*;

public class FreetimeItemBean {
    //Table : 	Free_time_item
	private String user_id;
	private String doc_no;
	private String free_dt;
	private String reg_dt;
	private String upd_dt;
	private String ov_yn;
	private String mt_yn;
	private String count;
        
    // CONSTRCTOR            
    public FreetimeItemBean() {  
		this.user_id = "";
		this.doc_no = "";
		this.free_dt = "";
		this.reg_dt = "";
		this.upd_dt = "";
		this.ov_yn = "";
		this.mt_yn = "";	
		this.count = "";	
	}

	// Set Method

	public void setUser_id(String val){			if(val==null) val="";	this.user_id = val;		}		
	public void setDoc_no(String val){			if(val==null) val="";	this.doc_no = val;		}		
	public void setFree_dt(String val){			if(val==null) val="";	this.free_dt = val;		}		
	public void setReg_dt(String val){			if(val==null) val="";	this.reg_dt = val;		}		
	public void setUpd_dt(String val){			if(val==null) val="";	this.upd_dt = val;		}		
	public void setOv_yn(String val){			if(val==null) val="";	this.ov_yn = val;		}		
	public void setMt_yn(String val){			if(val==null) val="";	this.mt_yn = val;		}			
	public void setCount(String val){			if(val==null) val="";	this.count = val;		}			

	//Get Method
	public String getUser_id(){		return user_id;	}
	public String getDoc_no(){		return doc_no;	}	
	public String getFree_dt(){		return free_dt;	}
	public String getReg_dt(){		return reg_dt;	}
	public String getUpd_dt(){		return upd_dt;	}
	public String getOv_yn(){		return ov_yn;	}
	public String getMt_yn(){		return mt_yn;	}
	public String getCount(){		return count;	}
	
	
}