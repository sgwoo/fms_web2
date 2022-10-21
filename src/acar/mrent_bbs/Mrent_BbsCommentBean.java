package acar.mrent_bbs;

import java.util.*;

public class Mrent_BbsCommentBean {
    //Table : MRENT_BBS_comment
    private int bbs_id;
    private int seq;
    private String content;
    private String reg_dt;
    private String reg_id;
    private String bbs_st;
    private String com_st;

    // CONSTRCTOR            
    public Mrent_BbsCommentBean() {  
    	this.bbs_id = 0;
    	this.seq = 0;
    	this.content = "";
    	this.reg_dt = "";
    	this.reg_id = "";
    	this.bbs_st = "";
    	this.com_st = "";
	}

	// set Method
	public void setBbs_id(int val){										this.bbs_id = val;	}
	public void setSeq(int val){										this.seq = val;		}
	public void setContent(String val){		if(val==null) val="";		this.content = val;	}
	public void setReg_dt(String val){		if(val==null) val="";		this.reg_dt = val;	}
	public void setReg_id(String val){		if(val==null) val="";		this.reg_id = val;	}
	public void setBbs_st(String val){		if(val==null) val="";		this.bbs_st = val;	}
	public void setCom_st(String val){		if(val==null) val="";		this.com_st = val;	}

	//Get Method
	public int getBbs_id(){			return bbs_id;	}
	public int getSeq(){			return seq;		}
	public String getContent(){		return content;	}
	public String getReg_dt(){		return reg_dt;	}
	public String getReg_id(){		return reg_id;	}
	public String getBbs_st(){		return bbs_st;	}
	public String getCom_st(){		return com_st;	}

}
