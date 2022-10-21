/**
 * ¡ˆ√‚
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.stat_exp;

import java.util.*;
import java.text.*;
import acar.util.*;


public class StatExpBean {
    //Table : FINE_CALL
    private String name;
    private String gubun;
    private String d_gubun;
    private String rent_mng_id;
    private String rent_l_cd;
    private String client_nm;
    private String firm_nm;
    private String car_name;
    private String car_nm;
    private String car_no;
    private String car_mng_id;
    private String amt;
    private String plan_dt;
    private String coll_dt;
    
    // CONSTRCTOR            
    public StatExpBean() {  
	    this.name = "";
	    this.gubun = "";
	    this.d_gubun = "";
	    this.rent_mng_id = "";
	    this.rent_l_cd = "";
	    this.client_nm = "";
	    this.firm_nm = "";
	    this.car_nm = "";
	    this.car_name = "";
	    this.car_no = "";
	    this.car_mng_id = "";
	    this.amt = "";
	    this.plan_dt = "";
	    this.coll_dt = "";
	}

	// set Method
	public void setName(String val){
		if(val==null) val="";
		this.name = val;
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
    public void setCar_nm(String val){
		if(val==null) val="";
		this.car_nm = val;
	}	
    public void setCar_no(String val){
		if(val==null) val="";
		this.car_no = val;
	}
    public void setCar_mng_id(String val){
		if(val==null) val="";
		this.car_mng_id = val;
	}
    public void setAmt(String val){
		if(val==null) val="";
		this.amt = val;
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
    public String getCar_nm(){
		return car_nm;
	}
    public String getCar_no(){
		return car_no;
	}
    public String getCar_mng_id(){
		return car_mng_id;
	}
    public String getAmt(){
		return amt;
	}
    public String getPlan_dt(){
		return plan_dt;
	}
    public String getColl_dt(){
		return coll_dt;
	}
}
