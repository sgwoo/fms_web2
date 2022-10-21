/**
 * 년차신청
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2009. 03. 27
 * @ last modify date : 
 */
package acar.closeday;

import java.util.*;

public class CloseDayBean {
    //Table : 	CloseDayBean;
	private String user_id;
	private String doc_no;
	private String content;
	private String reg_dt;
	private String closeday;
	private String check_dt;
	private String check_id;
        
    // CONSTRCTOR            
    public CloseDayBean() {  
		this.user_id = "";
		this.doc_no = "";
		this.content = "";
		this.reg_dt = "";
		this.closeday = "";
		this.check_dt = "";
		this.check_id = "";
	}

	// get Method
	public void setUser_id(String val){
		if(val==null) val="";
		this.user_id = val;
	}
	public void setDoc_no(String val){
		if(val==null) val="";
		this.doc_no = val;
	}
	public void setContent(String val){
		if(val==null) val="";
		this.content = val;
	}
	public void setReg_dt(String val){
		if(val==null) val="";
		this.reg_dt = val;
	}
	public void setCloseday(String val){
		if(val==null) val="";
		this.closeday = val;
	}
	public void setCheck_dt(String val){
		if(val==null) val="";
		this.check_dt = val;
	}
	public void setCheck_id(String val){
		if(val==null) val="";
		this.check_id = val;
	}

	//Get Method
	public String getUser_id(){
		return user_id;
	}
	public String getDoc_no(){
		return doc_no;
	}
	public String getContent(){
		return content;
	}
	public String getReg_dt(){
		return reg_dt;
	}
	public String getCloseday(){
		return closeday;
	}
	public String getCheck_dt(){
		return check_dt;
	}
	public String getCheck_id(){
		return check_id;
	}

	
}