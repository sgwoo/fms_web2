/**
 * 견적서관리
 */
package acar.estimate_mng;

import java.util.*;

public class EstiMBean {
    //Table : ESTI_M
    private String est_id;
    private String user_id;
    private int seq_no;
    private String sub;
    private String note;
    private String reg_dt;
    private String gubun;    
        
    // CONSTRCTOR            
    public EstiMBean() {  
    	this.est_id = "";
	    this.user_id = "";
	    this.seq_no = 0;
	    this.sub = "";
	    this.note = "";
	    this.reg_dt = "";
	    this.gubun = "";
	}

	// get Method
	public void setEst_id(String val){
		if(val==null) val="";
		this.est_id = val;
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
	public void setGubun(String val){
		if(val==null) val="";
		this.gubun = val;
	}
		
	//Get Method
	public String getEst_id(){
		return est_id;
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
	public String getGubun(){
		return gubun;
	}
}