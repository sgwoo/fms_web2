/**
 * 사고기록-보험금 청구내역 (휴차료/대차료)
 */
package acar.accid;

import java.util.*;

public class PicAccidBean {
    //Table : PIC_ACCID
	private String car_mng_id; 					
	private String accid_id;
	private String seq;
	private String filename;
	private String reg_dt;
	private String reg_id;
	private String update_dt;
	private String update_id;
	private String file_path;
        
    // CONSTRCTOR            
    public PicAccidBean() {  
		this.car_mng_id = ""; 					
		this.accid_id = "";
		this.seq = "";
		this.filename = "";
		this.reg_dt = "";
		this.reg_id = "";
		this.update_dt = "";
		this.update_id = "";
		this.file_path = "";
	}

	// get Method
	public void setCar_mng_id(String val){	if(val==null) val="";	this.car_mng_id = val;	}
	public void setAccid_id(String val){	if(val==null) val="";	this.accid_id = val;	}
	public void setSeq(String val){			if(val==null) val="";	this.seq = val;			}	
	public void setFilename(String val){	if(val==null) val="";	this.filename = val;	}	
	public void setReg_dt(String val){		if(val==null) val="";	this.reg_dt = val;		}	
	public void setReg_id(String val){		if(val==null) val="";	this.reg_id = val;		}	
	public void setUpdate_dt(String val){	if(val==null) val="";	this.update_dt = val;	}	
	public void setUpdate_id(String val){	if(val==null) val="";	this.update_id = val;	}	
	public void setFile_path(String val){	if(val==null) val="";	this.file_path = val;	}	
		
	//Get Method
	public String getCar_mng_id(){		return car_mng_id;	}
	public String getAccid_id(){		return accid_id;	}
	public String getSeq(){				return seq;	}	
	public String getFilename(){		return filename;	}	
	public String getReg_dt(){			return reg_dt;		}	
	public String getReg_id(){			return reg_id;		}	
	public String getUpdate_dt(){		return update_dt;	}	
	public String getUpdate_id(){		return update_id;	}	
	public String getFile_path(){		return file_path;	}	
	
}