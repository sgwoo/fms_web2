/**
 * °í°´Á¦¾ÈÇÔ
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2010. 06. 01
 * @ last modify date : 
 */

package acar.m_bbs;

import java.util.*;

public class M_bbs_ReplyBean {
    //Table : BBS
    private int bbs_id;
	private int bbs_seq;
    private String reg_id;
    private String reg_dt;
    private String reply_content;	


		
	
    // CONSTRCTOR            
    public M_bbs_ReplyBean() {  
    	this.bbs_id = 0;
    	this.bbs_seq = 0;
    	this.reg_id = "";
	    this.reg_dt = "";
	    this.reply_content = "";		
	

	}

	// set Method
	public void setBbs_id(int val){
		this.bbs_id = val;
	}
	public void setBbs_seq(int val){
		this.bbs_seq = val;
	}
	public void setReg_id(String val){
		if(val==null) val="";
		this.reg_id = val;
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
	public int getBbs_id(){		return bbs_id;	}
	public int getBbs_seq(){		return bbs_seq;	}
	public String getReg_id(){			return reg_id;	}
	public String getReg_dt(){			return reg_dt;	}
	public String getReply_content(){			return reply_content;	}
	
}