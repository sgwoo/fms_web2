package acar.attend;

import java.util.*;

public class Sch_prvBean {
    //Table : Summer
	private int seq;
	private String user_id;		//사용자ID
    private String start_year;	//년도
    private String start_mon;	//월
    private String start_day;	//일
    private String title;		//업무제목
    private String content;		//업무내용
	private String reg_dt;		//등록날짜
	private String sch_kd;		//
	private String sch_st;		//
	private String sch_chk;		//년차,휴가등등 항목 구분
	private String work_id;		//
	private String iwol;		//
	
	public Sch_prvBean() {  
		this.seq = 0;
		this.user_id = "";
		this.start_year = "";
		this.start_mon = "";
		this.start_day = "";
		this.title = "";
		this.content = "";
		this.reg_dt = "";
		this.sch_kd = "";
		this.sch_st = "";
		this.sch_chk = "";
		this.work_id = "";
		this.iwol = "";
	}

	// set Method
	public void setSeq(int val){								  this.seq = val;			}
	public void setUser_id(String val){		if(val==null) val=""; this.user_id = val;		}
	public void setStart_year(String val){	if(val==null) val=""; this.start_year = val;	}
	public void setStart_mon(String val){	if(val==null) val=""; this.start_mon = val;		}
	public void setStart_day(String val){	if(val==null) val=""; this.start_day = val;		}
	public void setTitle(String val){		if(val==null) val=""; this.title = val;			}
	public void setContent(String val){		if(val==null) val=""; this.content = val;		}
	public void setReg_dt(String val){		if(val==null) val=""; this.reg_dt = val;		}
	public void setSch_kd(String val){		if(val==null) val=""; this.sch_kd = val;		}
	public void setSch_st(String val){		if(val==null) val=""; this.sch_st = val;		}
	public void setSch_chk(String val){		if(val==null) val=""; this.sch_chk = val;		}
	public void setWork_id(String val){		if(val==null) val=""; this.work_id = val;		}
	public void setIwol(String val){		if(val==null) val=""; this.iwol = val;		}

	
	//Get Method
	public int getSeq(){			return seq;				}
	public String getUser_id(){		return user_id;			}
	public String getStart_year(){	return start_year;		}
	public String getStart_mon(){	return start_mon;		}
	public String getStart_day(){	return start_day;		}
	public String getTitle(){		return title;			}
	public String getContent(){		return content;			}
	public String getReg_dt(){		return reg_dt;			}
	public String getSch_kd(){		return sch_kd;			}
	public String getSch_st(){		return sch_st;			}
	public String getSch_chk(){		return sch_chk;			}
	public String getWork_id(){		return work_id;			}
	public String getIwol(){		return iwol;			}


}