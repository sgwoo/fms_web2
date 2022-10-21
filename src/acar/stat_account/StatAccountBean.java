package acar.stat_account;

import java.util.*;

public class StatAccountBean {
    //Table : STAT_ACCOUNT
	private String save_dt;			//마감일자
	private String seq;				//일련번호
	private String st;				//수입지출구분
	private String gubun;			//항목
	private long amt;				//금액
	private String reg_id;			//등록자

	public StatAccountBean() {  
		this.save_dt = "";
		this.seq = "";
		this.st = "";
		this.gubun = "";
		this.amt = 0;
		this.reg_id = "";
	}

	// set Method
	public void setSave_dt(String val){		if(val==null) val=""; this.save_dt = val;	}
	public void setSeq(String val){			if(val==null) val=""; this.seq = val;		}
	public void setSt(String val){			if(val==null) val=""; this.st = val;		}
	public void setGubun(String val){		if(val==null) val=""; this.gubun = val;		}
	public void setAmt(long val){			this.amt = val;		}	
	public void setReg_id(String val){		if(val==null) val=""; this.reg_id = val;	}

	//Get Method
	public String getSave_dt(){			return save_dt;		}
	public String getSeq(){				return seq;			}
	public String getSt(){				return st;			}
	public String getGubun(){			return gubun;		}
    public long getAmt(){				return amt;			}	
	public String getReg_id(){			return reg_id;		}	

}