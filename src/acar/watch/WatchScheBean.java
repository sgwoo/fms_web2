/**
 * 胶纳领
 */
package acar.watch;

import java.util.*;

public class WatchScheBean {
    //Table : WatchScheBean
	private String start_year;
	private String start_mon;
	private String start_day;
	private String watch_type;
	
	private String reg_dt;
	private String time_st;
	
	private String member_id;
	private String member_id2;
	private String member_id3;
	private String member_id4;
	private String member_dt;

	private String member_id5;
	private String member_id6;

	private String member_id7;
	private String member_id8;

// 寸流老瘤 累己
	private String watch_time_st;

	private String watch_ot;
	private String watch_time_ed;

	private String watch_gtext;
	private String watch_sign;
	private String watch_ch_nm;
	private String doc_no;
	private int watch_amt;
        
    // CONSTRCTOR            
    public WatchScheBean() {  
		this.start_year = "";
		this.start_mon	= "";
		this.start_day	= "";
		this.watch_type	= "";
		this.reg_dt		= "";
		this.time_st	= "";
		
		this.member_id = "";
		this.member_id2 = "";
		this.member_id3 = "";
		this.member_id4 = "";
		this.member_dt = "";		

		this.member_id5 = "";
		this.member_id6 = "";

		this.member_id7 = "";
		this.member_id8 = "";
		
// 寸流老瘤 累己
		this.watch_time_st	= "";
	
		this.watch_ot		= "";
		this.watch_time_ed	= "";
	
		this.watch_gtext	= "";
		this.watch_sign		= "";
		this.watch_ch_nm	= "";
		this.doc_no			= "";
		this.watch_amt	 =  0;

	}

	// get Method
	public void setStart_year	(String val){		if(val==null) val="";		this.start_year = val;	}
	public void setStart_mon	(String val){		if(val==null) val="";		this.start_mon	= val;	}	
	public void setStart_day	(String val){		if(val==null) val="";		this.start_day	= val;	}
	public void setWatch_type	(String val){		if(val==null) val="";		this.watch_type	= val;	}
	
	public void setReg_dt		(String val){		if(val==null) val="";		this.reg_dt		= val;	}
	public void setTime_st		(String val){		if(val==null) val="";		this.time_st	= val;	}
	
	public void setMember_id	(String val){		if(val==null) val="";		this.member_id = val;	}
	public void setMember_id2	(String val){		if(val==null) val="";		this.member_id2 = val;	}
	public void setMember_id3	(String val){		if(val==null) val="";		this.member_id3 = val;	}
	public void setMember_id4	(String val){		if(val==null) val="";		this.member_id4 = val;	}
	public void setMember_dt	(String val){		if(val==null) val="";		this.member_dt = val;	}

	public void setMember_id5	(String val){		if(val==null) val="";		this.member_id5 = val;	}
	public void setMember_id6	(String val){		if(val==null) val="";		this.member_id6 = val;	}

	public void setMember_id7	(String val){		if(val==null) val="";		this.member_id7 = val;	}
	public void setMember_id8	(String val){		if(val==null) val="";		this.member_id8 = val;	}

// 寸流老瘤 累己
	public void setWatch_time_st	(String val){	if(val == null)	val="";	this.watch_time_st = val; }

	public void setWatch_ot			(String val){	if(val == null)	val="";	this.watch_ot = val; }
	public void setWatch_time_ed	(String val){	if(val == null)	val="";	this.watch_time_ed = val; }

	public void setWatch_gtext		(String val){	if(val == null)	val="";	this.watch_gtext	= val; }
	public void setWatch_sign		(String val){	if(val == null)	val="";	this.watch_sign		= val; }
	public void setWatch_ch_nm		(String val){	if(val == null)	val="";	this.watch_ch_nm		= val; }
	public void setDoc_no			(String val){	if(val == null)	val="";	this.doc_no			= val; }
	public void setWatch_amt(int val){	this.watch_amt = val;	}

	//Get Method
	public String getStart_year	(){		return start_year;	}
	public String getStart_mon	(){		return start_mon;	}
	public String getStart_day	(){		return start_day;	}
	public String getWatch_type	(){		return watch_type;	}
	
	public String getReg_dt		(){		return reg_dt;		}
	public String getTime_st	(){		return time_st;		}
	
	public String getMember_id	(){		return member_id;	}
	public String getMember_id2	(){		return member_id2;	}
	public String getMember_id3	(){		return member_id3;	}
	public String getMember_id4	(){		return member_id4;	}
	public String getMember_dt	(){		return member_dt;	}	

	public String getMember_id5	(){		return member_id5;	}
	public String getMember_id6	(){		return member_id6;	}

	public String getMember_id7	(){		return member_id7;	}
	public String getMember_id8	(){		return member_id8;	}

// 寸流老瘤 累己
	
	public String getWatch_time_st	(){		return watch_time_st;	}

	public String getWatch_ot		(){		return watch_ot;		}
	public String getWatch_time_ed	(){		return watch_time_ed;	}
	
	public String getWatch_gtext	(){		return watch_gtext;			}
	public String getWatch_sign		(){		return watch_sign;			}
	public String getWatch_ch_nm	(){		return watch_ch_nm;			}
	public String getDoc_no			(){		return doc_no;			}
	public int	  getWatch_amt(){				return watch_amt;	}

}