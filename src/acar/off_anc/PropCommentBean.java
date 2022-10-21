package acar.off_anc;

import java.util.*;

public class PropCommentBean {
    //Table : PROP_COMMENT
    private int prop_id;
    private int seq;
    private String user_nm;
    private String reg_dt;
    private String reg_id;
	private String content;
	private String com_st;
    private String com_yn;
    private String user_pos;
	private int yn; 
	private int cnt1;
	private int cnt2;
	private int cnt3;
	private int cnt4;
	private int cnt5;
	private String open_yn;
	private int re_seq;

    // CONSTRCTOR            
    public PropCommentBean() {  
    	this.prop_id = 0;
    	this.seq = 0;
    	this.user_nm = "";
    	this.reg_dt = "";
    	this.reg_id = "";
    	this.content = "";
		this.com_st = "";
		this.com_yn = "";
		this.user_pos = "";
		this.yn = 0;  //추가
		this.cnt1 = 0;
		this.cnt2 = 0;
		this.cnt3 = 0;
		this.cnt4 = 0;
		this.cnt5 = 0;
		this.open_yn = "";
		this.re_seq = 0;
	}

	// set Method 
	public void setProp_id(int val){									this.prop_id = val;	}
	public void setSeq(int val){										this.seq = val;		}
	public void setUser_nm(String val){		if(val==null) val="";		this.user_nm = val;	}
	public void setUser_pos(String val){	if(val==null) val="";		this.user_pos = val;}
	public void setReg_dt(String val){		if(val==null) val="";		this.reg_dt = val;	}
	public void setReg_id(String val){		if(val==null) val="";		this.reg_id = val;	}
	public void setContent(String val){		if(val==null) val="";		this.content = val;	}
	public void setCom_st(String val){		if(val==null) val="";		this.com_st = val;	}
	public void setCom_yn(String val){		if(val==null) val="";		this.com_yn = val;	}
	public void setYn(int val)		{									this.yn = val;		}	//추가
	public void setCnt1(int val){										this.cnt1 = val;		}
	public void setCnt2(int val){										this.cnt2 = val;		}
	public void setCnt3(int val){										this.cnt3 = val;		}
	public void setCnt4(int val){										this.cnt4 = val;		}
	public void setCnt5(int val){										this.cnt5 = val;		}
	public void setOpen_yn(String val){		if(val==null) val="";		this.open_yn = val;	}
	public void setRe_seq(int val){										this.re_seq = val;		}

	//Get Method
	public int getProp_id(){		return prop_id;		}
	public int getSeq(){			return seq;			}
	public String getUser_nm(){		return user_nm;		}
	public String getUser_pos(){	return user_pos;	}
	public String getReg_dt(){		return reg_dt;		}
	public String getReg_id(){		return reg_id;		}
	public String getContent(){		return content;		}
	public String getCom_st(){		return com_st;		}
	public String getCom_yn(){		return com_yn;		}
	public int getYn(){				return yn;			}	//추가
	public int getCnt1(){			return cnt1;		}
	public int getCnt2(){			return cnt2;		}
	public int getCnt3(){			return cnt3;		}
	public int getCnt4(){			return cnt4;		}
	public int getCnt5(){			return cnt5;		}
	public String getOpen_yn(){		return open_yn;		}
	public int getRe_seq(){			return re_seq;		}
	
}
