/**
 * Ω∫ƒ…¡Ï
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.car_sche;

import java.util.*;

public class YMScheBean {
    //Table : CAR_REG
	private int seq_no;
	private String sche_year;
	private String sche_mon;
	private String user_id;
	private String cont;
	private String reg_dt;
        
    // CONSTRCTOR            
    public YMScheBean() {  
		this.seq_no = 0;
		this.sche_year = "";
		this.sche_mon = "";
		this.user_id = "";
		this.cont = "";
		this.reg_dt = "";
	}

	// get Method
	public void setUser_id(String val){
		if(val==null) val="";
		this.user_id = val;
	}
	public void setSeq_no(int val){
		this.seq_no = val;
	}
	public void setSche_year(String val){
		if(val==null) val="";
		this.sche_year = val;
	}
	public void setSche_mon(String val){
		if(val==null) val="";
		this.sche_mon = val;
	}
	public void setCont(String val){
		if(val==null) val="";
		this.cont = val;
	}
	public void setReg_dt(String val){
		if(val==null) val="";
		this.reg_dt = val;
	}
	
	//Get Method
	public String getUser_id(){
		return user_id;
	}
	public int getSeq_no(){
		return seq_no;
	}
	public String getSche_year(){
		return sche_year;
	}
	public String getSche_mon(){
		return sche_mon;
	}
	public String getCont(){
		return cont;
	}
	public String getReg_dt(){
		return reg_dt;
	}
}