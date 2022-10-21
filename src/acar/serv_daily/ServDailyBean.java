/**
 * 정기검사
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.serv_daily;

import java.util.*;

public class ServDailyBean {
    //Table :

	private String rent_mng_id;
	private String rent_l_cd;
	private String car_mng_id;
	private String car_no;
	private String init_reg_dt;
	private String client_nm;
	private String firm_nm;
	private String serv_dt;
	private String serv_dt_m;
	private String serv_dt1;
	private String serv_dt1_m;
	private String serv_dt2;
	private String serv_dt2_m;
	private String serv_dt3;
	private String serv_dt3_m;
	private String serv_dt4;
	private String serv_dt4_m;
	private String serv_dt5;
	private String serv_dt5_m;
	private String serv_dt_c;
	private String serv_dt1_c;
	private String serv_dt2_c;
	private String serv_dt3_c;
	private String serv_dt4_c;
	private String serv_dt5_c;
        
    // CONSTRCTOR            
    public ServDailyBean() {  
		this.rent_mng_id = "";
		this.rent_l_cd = "";
		this.car_mng_id = "";
		this.car_no = "";
		this.init_reg_dt = "";
		this.client_nm = "";
		this.firm_nm = "";
		this.serv_dt = "";
		this.serv_dt_m = "";
		this.serv_dt1 = "";
		this.serv_dt1_m = "";
		this.serv_dt2 = "";
		this.serv_dt2_m = "";
		this.serv_dt3 = "";
		this.serv_dt3_m = "";
		this.serv_dt4 = "";
		this.serv_dt4_m = "";
		this.serv_dt5 = "";
		this.serv_dt5_m = "";
		this.serv_dt_c = "";
		this.serv_dt1_c = "";
		this.serv_dt2_c = "";
		this.serv_dt3_c = "";
		this.serv_dt4_c = "";
		this.serv_dt5_c = "";
		
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
	public void setServ_dt(String val){
		if(val==null) val="";
		this.serv_dt = val;
	}
	public void setServ_dt1(String val){
		if(val==null) val="";
		this.serv_dt1 = val;
	}
	public void setServ_dt2(String val){
		if(val==null) val="";
		this.serv_dt2 = val;
	}
	public void setServ_dt3(String val){
		if(val==null) val="";
		this.serv_dt3 = val;
	}
	public void setServ_dt4(String val){
		if(val==null) val="";
		this.serv_dt4 = val;
	}
	public void setServ_dt5(String val){
		if(val==null) val="";
		this.serv_dt5 = val;
	}
	public void setServ_dt_c(String val){
		if(val==null) val="";
		this.serv_dt_c = val;
	}
	public void setServ_dt1_c(String val){
		if(val==null) val="";
		this.serv_dt1_c = val;
	}
	public void setServ_dt2_c(String val){
		if(val==null) val="";
		this.serv_dt2_c = val;
	}
	public void setServ_dt3_c(String val){
		if(val==null) val="";
		this.serv_dt3_c = val;
	}
	public void setServ_dt4_c(String val){
		if(val==null) val="";
		this.serv_dt4_c = val;
	}
	public void setServ_dt5_c(String val){
		if(val==null) val="";
		this.serv_dt5_c = val;
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
	public String getServ_dt(){
		return serv_dt;
	}
	public String getServ_dt_m(){
		if(!serv_dt.equals(""))
		{
			serv_dt_m = serv_dt.substring(4,6)+"/"+serv_dt.substring(6,8);
		}else{
			serv_dt_m = "";
		}
		return serv_dt_m;
	}
	public String getServ_dt1(){
		return serv_dt1;
	}
	public String getServ_dt1_m(){
		if(!serv_dt1.equals(""))
		{
			serv_dt1_m = serv_dt1.substring(4,6)+"/"+serv_dt1.substring(6,8);
		}else{
			serv_dt1_m = "";
		}
		return serv_dt1_m;
	}
	public String getServ_dt2(){
		return serv_dt2;
	}
	public String getServ_dt2_m(){
		if(!serv_dt2.equals(""))
		{
			serv_dt2_m = serv_dt2.substring(4,6)+"/"+serv_dt2.substring(6,8);
		}else{
			serv_dt2_m = "";
		}
		return serv_dt2_m;
	}
	public String getServ_dt3(){
		return serv_dt3;
	}
	public String getServ_dt3_m(){
		if(!serv_dt3.equals(""))
		{
			serv_dt3_m = serv_dt3.substring(4,6)+"/"+serv_dt3.substring(6,8);
		}else{
			serv_dt3_m = "";
		}
		return serv_dt3_m;
	}
	public String getServ_dt4(){
		return serv_dt4;
	}
	public String getServ_dt4_m(){
		if(!serv_dt4.equals(""))
		{
			serv_dt4_m = serv_dt4.substring(4,6)+"/"+serv_dt4.substring(6,8);
		}else{
			serv_dt4_m = "";
		}
		return serv_dt4_m;
	}
	public String getServ_dt5(){
		return serv_dt5;
	}
	public String getServ_dt5_m(){
		if(!serv_dt5.equals(""))
		{
			serv_dt5_m = serv_dt5.substring(4,6)+"/"+serv_dt5.substring(6,8);
		}else{
			serv_dt5_m = "";
		}
		return serv_dt5_m;
	}
	public String getServ_dt_c(){
		return serv_dt_c;
	}
	public String getServ_dt1_c(){
		return serv_dt1_c;
	}
	public String getServ_dt2_c(){
		return serv_dt2_c;
	}
	public String getServ_dt3_c(){
		return serv_dt3_c;
	}
	public String getServ_dt4_c(){
		return serv_dt4_c;
	}
	public String getServ_dt5_c(){
		return serv_dt5_c;
	}		
}