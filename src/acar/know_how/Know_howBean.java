/**
 * 아마존카 지식IN
 * @ author : Gill Sun	Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2009. 07. 07
 * @ last modify date : 
 */
package acar.know_how;

import java.util.*;

public class Know_howBean {
    //Table : BBS
    private int know_how_id;
    private String user_id;
    private String reg_dt;
    private String title;
    private String content;	
	private String read_chk;
	private String know_how_st;
	private String p_view; //공개범위
	
	
    // CONSTRCTOR            
    public Know_howBean() {  
    	this.know_how_id = 0;
    	this.user_id = "";
	    this.reg_dt = "";
	    this.title = "";
	    this.content = "";		
		this.read_chk = "";
		this.know_how_st = "";
		this.p_view = "";	

	}

	// set Method
	public void setKnow_how_id(int val){
		this.know_how_id = val;
	}
	public void setUser_id(String val){
		if(val==null) val="";
		this.user_id = val;
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
	public void setRead_chk(String val){
		if(val==null) val="";
		this.read_chk = val;
	}
	public void setKnow_how_st(String val){
		if(val==null) val="";
		this.know_how_st = val;
	}
	public void setP_view(String val){
		if(val==null) val="";
		this.p_view = val;
	}
	
	//Get Method
	public int getKnow_how_id(){		return know_how_id;	}
	public String getUser_id(){			return user_id;	}
	public String getReg_dt(){			return reg_dt;	}
	public String getTitle(){			return title;	}
	public String getContent(){			return content;	}
	public String getRead_chk(){		return read_chk;	}
	public String getKnow_how_st(){		return know_how_st;	}
	public String getP_view(){			return p_view;	}
	
}