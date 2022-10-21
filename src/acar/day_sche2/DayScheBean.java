/**
 * 관리담당
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.day_sche2;

import java.util.*;

public class DayScheBean {
    //Table : DAY_SCHE
	private String seq;
	private String year;
	private String mon;
	private String day;
	private String user_id;
	private String title;
	private String content;
	private String pr_dt;
	private String pr_id;
	private String status;
        
    // CONSTRCTOR            
    public DayScheBean() {
		this.seq = "";
		this.year = "";
		this.mon = "";
		this.day = "";
		this.user_id = "";
		this.title = "";
		this.content = "";
		this.pr_dt = "";
		this.pr_id = "";
		this.status = "";
	}

	// Set Method
	public void setSeq(String val){	if(val==null) val=""; this.seq = val; }
	public void setYear(String val){ if(val==null) val=""; this.year = val; }
	public void setMon(String val){	if(val==null) val=""; this.mon = val; }
	public void setDay(String val){	if(val==null) val=""; this.day = val; }
	public void setUser_id(String val){	if(val==null) val=""; this.user_id = val; }
	public void setTitle(String val){ if(val==null) val="";	this.title = val; }
	public void setContent(String val){	if(val==null) val=""; this.content = val; }
	public void setPr_dt(String val){ if(val==null) val=""; this.pr_dt = val; }
	public void setPr_id(String val){ if(val==null) val="";	this.pr_id = val; }
	public void setStatus(String val){ if(val==null) val=""; this.status = val; }
	
	// Get Method
	public String getSeq(){ return seq;	}
	public String getYear(){ return year; }
	public String getMon(){ return mon; }
	public String getDay(){ return day; }
	public String getUser_id(){ return user_id; }
	public String getTitle(){ return title; }
	public String getContent(){	return content;	}
	public String getPr_dt(){ return pr_dt; }
	public String getPr_id(){ return pr_id; }
	public String getStatus(){ return status; }
}