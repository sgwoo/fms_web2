/**
 * 예방정비
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.serv_prev;

import java.util.*;

public class ServPrevBean {
    //Table :

	private String rent_mng_id;
	private String rent_l_cd;
	private String car_mng_id;
	private String car_no;
	private String init_reg_dt;
	private String client_nm;
	private String firm_nm;
	private String car_name;
	private String car_nm;
	private String tot_dist;
	private String average_dist;
	private String today_dist;
        
    // CONSTRCTOR            
    public ServPrevBean() {  
		this.rent_mng_id = "";
		this.rent_l_cd = "";
		this.car_mng_id = "";
		this.car_no = "";
		this.init_reg_dt = "";
		this.client_nm = "";
		this.firm_nm = "";
		this.car_name = "";
		this.car_nm = "";
		this.tot_dist = "";
		this.average_dist = "";
		this.today_dist = "";
		
	}

	// get Method
	public void setRent_mng_id(String val){
		if(val==null) val="";
		this.rent_mng_id = val;
	}
	public void setRent_l_cd(String val){
		if(val==null) val="";
		this.rent_l_cd = val;
	}
	public void setCar_mng_id(String val){
		if(val==null) val="";
		this.car_mng_id = val;
	}
	public void setCar_no(String val){
		if(val==null) val="";
		this.car_no = val;
	}
	public void setInit_reg_dt(String val){
		if(val==null) val="";
		this.init_reg_dt = val;
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
	public void setTot_dist(String val){
		if(val==null) val="";
		this.tot_dist = val;
	}
	public void setAverage_dist(String val){
		if(val==null) val="";
		this.average_dist = val;
	}
	public void setToday_dist(String val){
		if(val==null) val="";
		this.today_dist = val;
	}
	
	
	//Get Method
	public String getRent_mng_id(){
		return rent_mng_id;
	}
	public String getRent_l_cd(){
		return rent_l_cd;
	}
	public String getCar_mng_id(){
		return car_mng_id;
	}
	public String getCar_no(){
		return car_no;
	}
	public String getInit_reg_dt(){
		return init_reg_dt;
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
	public String getTot_dist(){
		return tot_dist;
	}
	
	public String getAverage_dist(){
		return average_dist;
	}
	public String getToday_dist(){
		return today_dist;
	}		
}