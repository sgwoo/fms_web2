
package acar.mrent_bbs;

import java.util.*;

public class MrentBean {
    //Table : MRENT_BBS
    private int bbs_id;
    private String reg_nm;
    private String reg_dt;
	private String tel;
    private String title;
    private String content;	
	private String bbs_st;
	private String car_nm;
		
	
    // CONSTRCTOR            
    public MrentBean() {  
    	this.bbs_id = 0;
    	this.reg_nm = "";
    	this.tel = "";
	    this.reg_dt = "";
	    this.title = "";
	    this.content = "";		
		this.bbs_st = "";
		this.car_nm ="";

	}

	// set Method
	public void setBbs_id(int val){
		this.bbs_id = val;
	}
	public void setReg_nm(String val){
		if(val==null) val="";
		this.reg_nm = val;
	}
	public void setTel(String val){
		if(val==null) val="";
		this.tel = val;
	}
	public void setReg_dt(String val){
		if(val==null) val="";
		this.reg_dt = val;
	}
	public void setTitle(String val){
		if(val==null) val="";
		this.title = val;
	}
	public void setContent(String val){
		if(val==null) val="";
		this.content = val;
	}
	public void setBbs_st(String val){
		if(val==null) val="";
		this.bbs_st = val;
	}
	public void setCar_nm(String val){
		if(val==null) val="";
		this.car_nm = val;
	}
	
	//Get Method
	public int getBbs_id(){			return bbs_id;	}
	public String getReg_nm(){		return reg_nm;	}
	public String getTel(){		return tel;	}
	public String getReg_dt(){		return reg_dt;	}
	public String getTitle(){		return title;	}
	public String getContent(){		return content;	}
	public String getBbs_st(){		return bbs_st;	}
	public String getCar_nm(){		return car_nm;	}
	
}