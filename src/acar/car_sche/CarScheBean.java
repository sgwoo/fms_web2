/**
 * Ω∫ƒ…¡Ï
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.car_sche;

import java.util.*;

public class CarScheBean {
    //Table : CAR_REG
	private String user_id;
	private String user_nm;
	private int seq;
	private String start_year;
	private String start_mon;
	private String start_day;
	private String title;
	private String content;
	private String reg_dt;
	private String sch_kd;
	private String sch_st;
	private String sch_chk;
	private String work_id;
	private String if_force;
	private String ov_yn;
	private String gj_ck;
	private String count;
	private String doc_no;	
	private String iwol;	
        
    // CONSTRCTOR            
    public CarScheBean() {  
		this.user_id = "";
		this.user_nm = "";
		this.seq = 0;
		this.start_year = "";
		this.start_mon = "";
		this.start_day = "";
		this.title = "";
		this.content = "";
		this.reg_dt = "";
		this.sch_kd = "";
		this.sch_st = "";
		this.sch_chk="";
		this.work_id="";
		this.if_force="";
		this.ov_yn="";
		this.gj_ck="";
		this.count="";
		this.doc_no="";
		this.iwol = "";
	}

	// get Method
	public void setUser_id		(String val){		if(val==null) val="";		this.user_id 	= val;	}
	public void setUser_nm		(String val){		if(val==null) val="";		this.user_nm 	= val;	}
	public void setSeq			(int val)   {		                            this.seq 		= val;	}
	public void setStart_year	(String val){		if(val==null) val="";		this.start_year = val;	}
	public void setStart_mon	(String val){		if(val==null) val="";		this.start_mon 	= val;	}
	public void setStart_day	(String val){		if(val==null) val="";		this.start_day 	= val;	}
	public void setTitle		(String val){		if(val==null) val="";		this.title 		= val;	}
	public void setContent		(String val){		if(val==null) val="";		this.content 	= val;	}
	public void setReg_dt		(String val){		if(val==null) val="";		this.reg_dt 	= val;	}
	public void setSch_kd		(String val){		if(val==null) val="";		this.sch_kd 	= val;	}
	public void setSch_st		(String val){		if(val==null) val="";		this.sch_st 	= val;	}
	public void setSch_chk		(String val){		if(val==null) val="";		this.sch_chk 	= val;	}
	public void setWork_id		(String val){		if(val==null) val="";		this.work_id 	= val;	}
	public void setIf_force		(String val){		if(val==null) val="";		this.if_force 	= val;	}
	public void setOv_yn		(String val){		if(val==null) val="";		this.ov_yn 		= val;	}
	public void setGj_ck		(String val){		if(val==null) val="";		this.gj_ck 		= val;	}
	public void setCount		(String val){		if(val==null) val="";		this.count 		= val;	}
	public void setDoc_no		(String val){		if(val==null) val="";		this.doc_no		= val;	}
	public void setIwol			(String val){		if(val==null) val="";		this.iwol		= val;	}
	
	//Get Method
	public String getUser_id	(){		return user_id;		}
	public String getUser_nm	(){		return user_nm;		}
	public int    getSeq		(){		return seq;			}
	public String getStart_year	(){		return start_year;	}
	public String getStart_mon	(){		return start_mon;	}
	public String getStart_day	(){		return start_day;	}
	public String getTitle		(){		return title;		}
	public String getContent	(){		return content;		}
	public String getReg_dt		(){		return reg_dt;		}
	public String getSch_kd		(){		return sch_kd;		}
	public String getSch_st		(){		return sch_st;		}
	public String getSch_chk	(){		return sch_chk;		}
	public String getWork_id	(){		return work_id;		}
	public String getIf_force	(){		return if_force;	}
	public String getOv_yn		(){		return ov_yn;		}
	public String getGj_ck		(){		return gj_ck;		}
	public String getCount		(){		return count;		}
	public String getDoc_no		(){		return doc_no;		}
	public String getIwol		(){		return iwol;		}
	
}