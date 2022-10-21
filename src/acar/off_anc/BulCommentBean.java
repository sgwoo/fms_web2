package acar.off_anc;

import java.util.*;

public class BulCommentBean {
    //Table :사내 게시판 comment
    private int b_id;
    private int seq;
    private String content;
    private String reg_dt;
    private String reg_id;
    private String user_nm;

    // CONSTRCTOR            
    public BulCommentBean() {  
    	this.b_id = 0;
    	this.seq = 0;
    	this.content = "";
    	this.reg_dt = "";
    	this.reg_id = "";
    	this.user_nm = "";
	}

	// set Method
	public void setB_id(int val){										this.b_id = val;	}
	public void setSeq(int val){										this.seq = val;		}
	public void setContent(String val){		if(val==null) val="";		this.content = val;	}
	public void setReg_dt(String val){		if(val==null) val="";		this.reg_dt = val;	}
	public void setReg_id(String val){		if(val==null) val="";		this.reg_id = val;	}
	public void setUser_nm(String val){		if(val==null) val="";		this.user_nm = val;	}

	//Get Method
	public int getB_id(){			return b_id;	}
	public int getSeq(){			return seq;		}
	public String getContent(){		return content;	}
	public String getReg_dt(){		return reg_dt;	}
	public String getReg_id(){		return reg_id;	}
	public String getUser_nm(){		return user_nm;	}

}
