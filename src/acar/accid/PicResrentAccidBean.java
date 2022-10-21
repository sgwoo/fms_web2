/**
 * 사고기록-대차계약서
 */
package acar.accid;

import java.util.*;

public class PicResrentAccidBean {
    //Table : PicResrentAccidBean
	private String car_mng_id; 					
	private String accid_id;
	private String seq;
	private String filename;
	private String reg_dt;
	private String reg_id;

        
    // CONSTRCTOR            
    public PicResrentAccidBean() {  
		this.car_mng_id = ""; 					
		this.accid_id = "";
		this.seq = "";
		this.filename = "";
		this.reg_dt = "";
		this.reg_id = "";

	}

	// get Method
	public void setCar_mng_id(String val){	if(val==null) val="";	this.car_mng_id = val;	}
	public void setAccid_id(String val){	if(val==null) val="";	this.accid_id = val;	}
	public void setSeq(String val){			if(val==null) val="";	this.seq = val;			}	
	public void setFilename(String val){	if(val==null) val="";	this.filename = val;	}	
	public void setReg_dt(String val){		if(val==null) val="";	this.reg_dt = val;		}	
	public void setReg_id(String val){		if(val==null) val="";	this.reg_id = val;		}	

	//Get Method
	public String getCar_mng_id(){		return car_mng_id;	}
	public String getAccid_id(){		return accid_id;	}
	public String getSeq(){				return seq;	}	
	public String getFilename(){		return filename;	}	
	public String getReg_dt(){			return reg_dt;		}	
	public String getReg_id(){			return reg_id;		}	

	
}