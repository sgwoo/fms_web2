/**
 * fax 상용구 등록
 * @ author : Gill Sun	Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2009. 07. 07
 * @ last modify date : 
 */
package acar.fax_word;

import java.util.*;

public class Fax_wordBean {
    //Table : fax_word
    private int seq;
    private String user_id;
    private String reg_dt;
    private String content;	


		
	
    // CONSTRCTOR            
    public Fax_wordBean() {  
    	this.seq = 0;
    	this.user_id = "";
	    this.reg_dt = "";
	    this.content = "";		

	

	}

	// set Method
	public void setSeq(int val){
		this.seq = val;
	}
	public void setUser_id(String val){
		if(val==null) val="";
		this.user_id = val;
	}
	public void setReg_dt(String val){
		if(val==null) val="";
		this.reg_dt = val;
	}
	public void setContent(String val){
		if(val==null) val="";
		this.content = val;
	}

	
	
	//Get Method
	public int getSeq(){		return seq;	}
	public String getUser_id(){			return user_id;	}
	public String getReg_dt(){			return reg_dt;	}
	public String getContent(){			return content;	}
	
}