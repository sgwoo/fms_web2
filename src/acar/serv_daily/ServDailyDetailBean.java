/**
 * 정기검사
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.serv_daily;

import java.util.*;

public class ServDailyDetailBean {
    //Table :

	private String rent_mng_id;
	private String rent_l_cd;
	private String car_mng_id;
	private String serv_dt;
	private String serv_id;
	private String serv_st;
	private String serv_st_nm;
	private String checker;
	private String accid_id;
	private String tot_dist;
	private String rep_cont;
	    
    // CONSTRCTOR            
    public ServDailyDetailBean() {  
		this.rent_mng_id = "";
		this.rent_l_cd = "";
		this.car_mng_id = "";
		this.serv_dt = "";
		this.serv_id = "";
		this.serv_st = "";
		this.serv_st_nm = "";
		this.checker = "";
		this.accid_id = "";
		this.tot_dist = "";
		this.rep_cont = "";
		
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
	public void setServ_dt(String val){
		if(val==null) val="";
		this.serv_dt = val;
	}
	public void setServ_id(String val){
		if(val==null) val="";
		this.serv_id = val;
	}
	public void setServ_st(String val){
		if(val==null) val="";
		this.serv_st = val;
	}
	public void setChecker(String val){
		if(val==null) val="";
		this.checker = val;
	}
	public void setAccid_id(String val){
		if(val==null) val="";
		this.accid_id = val;
	}
	public void setTot_dist(String val){
		if(val==null) val="";
		this.tot_dist = val;
	}
	public void setRep_cont(String val){
		if(val==null) val="";
		this.rep_cont = val;
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
	public String getServ_dt(){
		return serv_dt;
	}
	public String getServ_id(){
		return serv_id;
	}
	public String getServ_st(){
		return serv_st;
	}
	public String getServ_st_nm(){
		if(serv_st.equals("1"))
		{
			serv_st_nm = "순회점검";
		}else if(serv_st.equals("2")){
			serv_st_nm = "일반수리";
		}else if(serv_st.equals("3")){
			serv_st_nm = "보증수리";
		}else if(serv_st.equals("4")){
			serv_st_nm = "사고수리";
		}
		return serv_st_nm;
	}
	public String getChecker(){
		return checker;
	}
	public String getAccid_id(){
		return accid_id;
	}
	public String getTot_dist(){
		return tot_dist;
	}
	public String getRep_cont(){
		return rep_cont;
	}
}