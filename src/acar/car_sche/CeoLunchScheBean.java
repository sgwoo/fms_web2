/**
 * Ω∫ƒ…¡Ï
 */
package acar.car_sche;

import java.util.*;

public class CeoLunchScheBean {
    //Table : CEO_LUNCH
	private String start_year;
	private String start_mon;
	private String start_day;
	private String reg_dt;
	private String time_st;
	private String member_id1;
	private String member_id2;
	private String member_id3;
	private String member_id4;
	private String member_id5;
	private String member_dt1;
	private String member_dt2;
	private String member_dt3;
	private String member_dt4;
	private String member_dt5;
	private String member_nm1;
	private String member_nm2;
	private String member_nm3;
	private String member_nm4;
	private String member_nm5;
        
    // CONSTRCTOR            
    public CeoLunchScheBean() {  
		this.start_year = "";
		this.start_mon	= "";
		this.start_day	= "";
		this.reg_dt		= "";
		this.time_st	= "";
		this.member_id1 = "";
		this.member_id2 = "";
		this.member_id3	= "";
		this.member_id4 = "";
		this.member_id5	= "";
		this.member_dt1	= "";
		this.member_dt2	= "";
		this.member_dt3	= "";
		this.member_dt4	= "";
		this.member_dt5	= "";
		this.member_nm1	= "";
		this.member_nm2	= "";
		this.member_nm3	= "";
		this.member_nm4	= "";
		this.member_nm5	= "";
	}

	// get Method
	public void setStart_year	(String val){		if(val==null) val="";		this.start_year = val;	}
	public void setStart_mon	(String val){		if(val==null) val="";		this.start_mon	= val;	}	
	public void setStart_day	(String val){		if(val==null) val="";		this.start_day	= val;	}
	public void setReg_dt		(String val){		if(val==null) val="";		this.reg_dt		= val;	}
	public void setTime_st		(String val){		if(val==null) val="";		this.time_st	= val;	}
	public void setMember_id1	(String val){		if(val==null) val="";		this.member_id1 = val;	}
	public void setMember_id2	(String val){		if(val==null) val="";		this.member_id2 = val;	}
	public void setMember_id3	(String val){		if(val==null) val="";		this.member_id3 = val;	}
	public void setMember_id4	(String val){		if(val==null) val="";		this.member_id4 = val;	}
	public void setMember_id5	(String val){		if(val==null) val="";		this.member_id5 = val;	}
	public void setMember_dt1	(String val){		if(val==null) val="";		this.member_dt1 = val;	}
	public void setMember_dt2	(String val){		if(val==null) val="";		this.member_dt2 = val;	}
	public void setMember_dt3	(String val){		if(val==null) val="";		this.member_dt3 = val;	}
	public void setMember_dt4	(String val){		if(val==null) val="";		this.member_dt4 = val;	}
	public void setMember_dt5	(String val){		if(val==null) val="";		this.member_dt5 = val;	}
	public void setMember_nm1	(String val){		if(val==null) val="";		this.member_nm1 = val;	}
	public void setMember_nm2	(String val){		if(val==null) val="";		this.member_nm2 = val;	}
	public void setMember_nm3	(String val){		if(val==null) val="";		this.member_nm3 = val;	}
	public void setMember_nm4	(String val){		if(val==null) val="";		this.member_nm4 = val;	}
	public void setMember_nm5	(String val){		if(val==null) val="";		this.member_nm5 = val;	}

	//Get Method
	public String getStart_year	(){		return start_year;	}
	public String getStart_mon	(){		return start_mon;	}
	public String getStart_day	(){		return start_day;	}
	public String getReg_dt		(){		return reg_dt;		}
	public String getTime_st	(){		return time_st;		}
	public String getMember_id1	(){		return member_id1;	}
	public String getMember_id2	(){		return member_id2;	}
	public String getMember_id3	(){		return member_id3;	}
	public String getMember_id4	(){		return member_id4;	}
	public String getMember_id5	(){		return member_id5;	}
	public String getMember_dt1	(){		return member_dt1;	}
	public String getMember_dt2	(){		return member_dt2;	}
	public String getMember_dt3	(){		return member_dt3;	}
	public String getMember_dt4	(){		return member_dt4;	}
	public String getMember_dt5	(){		return member_dt5;	}
	public String getMember_nm1	(){		return member_nm1;	}
	public String getMember_nm2	(){		return member_nm2;	}
	public String getMember_nm3	(){		return member_nm3;	}
	public String getMember_nm4	(){		return member_nm4;	}
	public String getMember_nm5	(){		return member_nm5;	}
}