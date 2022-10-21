/**
 * 과태료,범칙금 통화기록
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.forfeit_mng;

import java.util.*;
import java.text.*;


public class FineCallBean {
    //Table : FINE_CALL
    private String car_mng_id;			//자동차관리번호
    private String car_no;			//차량번호
    private String rent_mng_id;			//계약관리번호
    private String rent_l_cd;			//계약번호
    private String call_dt;			//통화일
    private String call_dt_yr;
    private String call_dt_mth;
    private String call_dt_day;
    private String call_cont;			//통화기록
    private String reg_nm;			//등록자
    
    // CONSTRCTOR            
    public FineCallBean() {  
	    this.car_mng_id = "";			
	    this.car_no = "";			
	    this.rent_mng_id = "";			
	    this.rent_l_cd = "";			
	    this.call_dt = "";
	    this.call_dt_yr = "";
	    this.call_dt_mth = "";
	    this.call_dt_day = "";			
	    this.call_cont = "";			
	    this.reg_nm = "";
	    try{
    		TimeZone tz = new SimpleTimeZone( 9 * 60 * 60 * 1000, "KST" );
    		TimeZone.setDefault(tz);
    		java.util.Date d = new java.util.Date();
    		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd'");
    		call_dt = sdf.format(d);
    	}catch(Exception dfdf){}
		
	}

	// get Method
	public void setCar_mng_id(String val){
		if(val==null) val="";
		this.car_mng_id = val;
	}
	public void setCar_no(String val){
		if(val==null) val="";
		this.car_no = val;
	}
	public void setRent_mng_id(String val){
		if(val==null) val="";
		this.rent_mng_id = val;
	}
	public void setRent_l_cd(String val){
		if(val==null) val="";
		this.rent_l_cd = val;
	}
	public void setCall_dt(String val){
		if(val==null) val="";
		this.call_dt = val;
	}
	public void setCall_cont(String val){
		if(val==null) val="";
		this.call_cont = val;
	}
	public void setReg_nm(String val){
		if(val==null) val="";
		this.reg_nm = val;
	}
	
	//Get Method
	public String getCar_mng_id(){
		return car_mng_id;
	}
	public String getCar_no(){
		return car_no;
	}
	public String getRent_mng_id(){
		return rent_mng_id;
	}
	public String getRent_l_cd(){
		return rent_l_cd;
	}
	public String getCall_dt(){
		return call_dt;
	}
	public String getCall_dt_yr(){
		call_dt_yr = call_dt.substring(0,4);
		return call_dt_yr;
	}
	public String getCall_dt_mth(){
		call_dt_mth = call_dt.substring(4,6);
		return call_dt_mth;
	}
	public String getCall_dt_day(){
		call_dt_day = call_dt.substring(6,8);
		return call_dt_day;
	}
	public String getCall_cont(){
		return call_cont;
	}
	public String getReg_nm(){
		return reg_nm;
	}
	
}