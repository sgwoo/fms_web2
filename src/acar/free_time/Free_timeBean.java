/**
 * 년차신청
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2009. 03. 27
 * @ last modify date : 
 */
package acar.free_time;

import java.util.*;

public class Free_timeBean {
    //Table : 	Free_timeBean;
	private String user_id;
	private String doc_no;
	private String start_date;
	private String title;
	private String content;
	private String reg_dt;
	private String sch_kd;
	private String sch_st;
	private String sch_chk;
	private String work_id;
	private String sch_file;
	private String end_date;
	
	private String s_check;
	private String s_check_dt;
	private String s_check_id;

	private String cm_check;
	private String cm_check_dt;
	private String cm_check_id;

	private String cancel;

	private int    re_day;		//연차미사용일수 - 등록시점    
	private int    ov_day;		//연차over일수     
	private String ov_yn;       //무급처리 여부
        
    // CONSTRCTOR            
    public Free_timeBean() {  
		this.user_id = "";
		this.doc_no = "";
		this.start_date = "";
		this.title = "";
		this.content = "";
		this.reg_dt = "";
		this.sch_kd = "";
		this.sch_st = "";
		this.sch_chk = "";
		this.work_id = "";
		this.sch_file = "";
		this.end_date = "";

		this.s_check = "";
		this.s_check_dt = "";
		this.s_check_id = "";

		this.cm_check = "";
		this.cm_check_dt = "";
		this.cm_check_id = "";

		this.cancel = "";

		this.re_day	= 0;  
		this.ov_day	= 0;  
		this.ov_yn = "";
	}

	// get Method
	public void setUser_id(String val){
		if(val==null) val="";
		this.user_id = val;
	}
	public void setDoc_no(String val){
		if(val==null) val="";
		this.doc_no = val;
	}
	public void setStart_date(String val){
		if(val==null) val="";
		this.start_date = val;
	}
	public void setTitle(String val){
		if(val==null) val="";
		this.title = val;
	}
	public void setContent(String val){
		if(val==null) val="";
		this.content = val;
	}
	public void setReg_dt(String val){
		if(val==null) val="";
		this.reg_dt = val;
	}
	public void setSch_kd(String val){
		if(val==null) val="";
		this.sch_kd = val;
	}
	public void setSch_st(String val){
		if(val==null) val="";
		this.sch_st = val;
	}
	public void setSch_chk(String val){
		if(val==null) val="";
		this.sch_chk = val;
	}
	public void setWork_id(String val){
		if(val==null) val="";
		this.work_id = val;
	}
	public void setSch_file(String val){
		if(val==null) val="";
		this.sch_file = val;
	}
	public void setEnd_date(String val){
		if(val==null) val="";
		this.end_date = val;
	}
	public void setS_check(String val){
		if(val==null) val="";
		this.s_check = val;
	}
	public void setS_check_dt(String val){
		if(val==null) val="";
		this.s_check_dt = val;
	}
	public void setS_check_id(String val){
		if(val==null) val="";
		this.s_check_id = val;
	}
	public void setCm_check(String val){
		if(val==null) val="";
		this.cm_check = val;
	}
	public void setCm_check_dt(String val){
		if(val==null) val="";
		this.cm_check_dt = val;
	}
	public void setCm_check_id(String val){
		if(val==null) val="";
		this.cm_check_id = val;
	}
	public void setCancel(String val){
		if(val==null) val="";
		this.cancel = val;
	}

	public void setRe_day(int val){										this.re_day = val;	}
	public void setOv_day(int val){										this.ov_day = val;	}
	public void setOv_yn(String val){			if(val==null) val="";	this.ov_yn = val;		}			

	//Get Method
	public String getUser_id(){
		return user_id;
	}
	public String getDoc_no(){
		return doc_no;
	}
	public String getStart_date(){
		return start_date;
	}
	public String getTitle(){
		return title;
	}
	public String getContent(){
		return content;
	}
	public String getReg_dt(){
		return reg_dt;
	}
	public String getSch_kd(){
		return sch_kd;
	}
	public String getSch_st(){
		return sch_st;
	}
	public String getSch_chk(){
		return sch_chk;
	}
	public String getWork_id(){
		return work_id;
	}
	public String getSch_file(){
		return sch_file;
	}
	public String getEnd_date(){
		return end_date;
	}
	public String getS_check(){
		return s_check;
	}
	public String getS_check_dt(){
		return s_check_dt;
	}
	public String getS_check_id(){
		return s_check_id;
	}
	public String getCm_check(){
		return cm_check;
	}
	public String getCm_check_dt(){
		return cm_check_dt;
	}
	public String getCm_check_id(){
		return cm_check_id;
	}
	public String getCancel(){
		return cancel;
	}

	public int getRe_day(){
		return re_day;
	}
	public int getOv_day(){
		return ov_day;
	}
	public String getOv_yn(){
		return ov_yn;
	}
	
}