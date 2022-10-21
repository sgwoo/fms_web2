/**
 * 단기대여통화관리
 */
package acar.res_search;

import java.util.*;

public class RentMBean {
    //Table : RENT_M
    private String rent_s_cd;
    private String user_id;
    private int seq_no;
    private String sub;
    private String note;
    private String reg_dt;
        
    // CONSTRCTOR            
    public RentMBean() {  
    	this.rent_s_cd = "";
	    this.user_id = "";
	    this.seq_no = 0;
	    this.sub = "";
	    this.note = "";
	    this.reg_dt = "";
	}

	// get Method
	public void setRent_s_cd(String val){
		if(val==null) val="";
		this.rent_s_cd = val;
	}
    public void setUser_id(String val){
		if(val==null) val="";
		this.user_id = val;
	}
	public void setSeq_no(int val){
		this.seq_no = val;
	}
    public void setSub(String val){
		if(val==null) val="";
		this.sub = val;
	}
    public void setNote(String val){
		if(val==null) val="";
		this.note = val;
	}
    public void setReg_dt(String val){
		if(val==null) val="";
		this.reg_dt = val;
	}
		
	//Get Method
	public String getRent_s_cd(){
		return rent_s_cd;
	}
	public String getUser_id(){
		return user_id;
	}
	public int getSeq_no(){
		return seq_no;
	}
    public String getSub(){
		return sub;
	}
    public String getNote(){
		return note;
	}
    public String getReg_dt(){
		return reg_dt;
	}
}