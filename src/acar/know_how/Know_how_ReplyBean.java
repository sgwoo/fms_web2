/**
 * 아마존카 지식IN 리플
 * @ author : Gill Sun	Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2009. 07. 07
 * @ last modify date : 
 */
package acar.know_how;

import java.util.*;

public class Know_how_ReplyBean {
    //Table : BBS
    private int know_how_id;
	private int know_how_seq;
    private String user_id;
    private String reg_dt;
    private String reply_content;	


		
	
    // CONSTRCTOR            
    public Know_how_ReplyBean() {  
    	this.know_how_id = 0;
    	this.know_how_seq = 0;
    	this.user_id = "";
	    this.reg_dt = "";
	    this.reply_content = "";		
	

	}

	// set Method
	public void setKnow_how_id(int val){
		this.know_how_id = val;
	}
	public void setKnow_how_seq(int val){
		this.know_how_seq = val;
	}
	public void setUser_id(String val){
		if(val==null) val="";
		this.user_id = val;
	}
	public void setReg_dt(String val){
		if(val==null) val="";
		this.reg_dt = val;
	}
	public void setReply_content(String val){
		if(val==null) val="";
		this.reply_content = val;
	}

	
	
	//Get Method
	public int getKnow_how_id(){		return know_how_id;	}
	public int getKnow_how_seq(){		return know_how_seq;	}
	public String getUser_id(){			return user_id;	}
	public String getReg_dt(){			return reg_dt;	}
	public String getReply_content(){			return reply_content;	}
	
}