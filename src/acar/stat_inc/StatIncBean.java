/**
 * 수금
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.stat_inc;

import java.util.*;
import java.text.*;


public class StatIncBean {
    //Table : FINE_CALL
    private String name;
    private String tm;				//회차
    private String tm_nm;			//회차
    private String gubun;			//연장구분
    private String d_gubun;			//잔액구분
    private String rent_mng_id;
    private String rent_l_cd;
    private String client_nm;
    private String firm_nm;
    private String car_name;
    private String car_no;
    private String car_mng_id;
    private String t_amt;			//공급가
    private String s_amt;			//부가세
    private String v_amt;			//입금액
    private String plan_dt;
    private String coll_dt;
    
    // CONSTRCTOR            
    public StatIncBean() {  
	    this.name = "";
	    this.tm = "";
	    this.tm_nm = "";
	    this.gubun = "";
	    this.d_gubun = "";
	    this.rent_mng_id = "";
	    this.rent_l_cd = "";
	    this.client_nm = "";
	    this.firm_nm = "";
	    this.car_name = "";
	    this.car_no = "";
	    this.t_amt = "";
	    this.s_amt = "";
	    this.v_amt = "";
	    this.plan_dt = "";
	    this.coll_dt = "";
	}

	// get Method
	public void setName(String val){
		if(val==null) val="";
		this.name = val;
	}
	public void setTm(String val){
		if(val==null) val="";
		this.tm = val;
	}
	public void setTm_nm(String val){
		if(val==null) val="";
		this.tm_nm = val;
	}
    public void setGubun(String val){
		if(val==null) val="";
		this.gubun = val;
	}
    public void setD_gubun(String val){
		if(val==null) val="";
		this.d_gubun = val;
	}
    public void setRent_mng_id(String val){
		if(val==null) val="";
		this.rent_mng_id = val;
	}
    public void setRent_l_cd(String val){
		if(val==null) val="";
		this.rent_l_cd = val;
	}
    public void setClient_nm(String val){
		if(val==null) val="";
		this.client_nm = val;
	}
    public void setFirm_nm(String val){
		if(val==null) val="";
		this.firm_nm = val;
	}
    public void setCar_name(String val){
		if(val==null) val="";
		this.car_name = val;
	}
    public void setCar_no(String val){
		if(val==null) val="";
		this.car_no = val;
	}
    public void setCar_mng_id(String val){
		if(val==null) val="";
		this.car_mng_id = val;
	}
    public void setT_amt(String val){
		if(val==null) val="";
		this.t_amt = val;
	}
	public void setS_amt(String val){
		if(val==null) val="";
		this.s_amt = val;
	}
	public void setV_amt(String val){
		if(val==null) val="";
		this.v_amt = val;
	}
    public void setPlan_dt(String val){
		if(val==null) val="";
		this.plan_dt = val;
	}
    public void setColl_dt(String val){
		if(val==null) val="";
		this.coll_dt = val;
	}
	
	//Get Method
	public String getName(){
		return name;
	}
	public String getTm(){
		return tm;
	}
	public String getTm_nm(){
		return tm_nm;
	}
    public String getGubun(){
		return gubun;
	}
    public String getD_gubun(){
		return d_gubun;
	}
    public String getRent_mng_id(){
		return rent_mng_id;
	}
    public String getRent_l_cd(){
		return rent_l_cd;
	}
    public String getClient_nm(){
		return client_nm;
	}
    public String getFirm_nm(){
		return firm_nm;
	}
    public String getCar_name(){
		return car_name;
	}
    public String getCar_no(){
		return car_no;
	}
    public String getCar_mng_id(){
		return car_mng_id;
	}
    public String getT_amt(){
		return t_amt;
	}
	public String getS_amt(){
		return s_amt;
	}
	public String getV_amt(){
		return v_amt;
	}
    public String getPlan_dt(){
		return plan_dt;
	}
    public String getColl_dt(){
		return coll_dt;
	}
}