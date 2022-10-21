/**
 * 계약정보
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.car_service;

import java.util.*;

public class ContInfoBean {
    //Table : CAR_REG
	private String rent_mng_id;
	private String rent_l_cd;
	private String client_id;
	private String car_mng_id;
	private String init_reg_dt;
	private String car_no;
	private String car_num;
	private String fuel_kd;
	private String client_nm;
	private String firm_nm;
	private String rent_way;
	private String con_mon;
	private String rent_start_dt;
	private String car_id;
	private String car_name;
	private String car_form;
	private String off_id;
	private String off_nm;
	private String off_tel;
	private String tot_dist;
	private String average_dist;
	private String today_dist;
	private String ins_com_nm;
	private String ins_exp_dt;
	private String agnt_imgn_tel;
	
        
    // CONSTRCTOR            
    public ContInfoBean() {  
		this.rent_mng_id = "";
		this.rent_l_cd = "";
		this.client_id = "";
		this.car_mng_id = "";
		this.init_reg_dt = "";
		this.car_no = "";
		this.car_num = "";
		this.fuel_kd = "";
		this.client_nm = "";
		this.firm_nm = "";
		this.rent_way = "";
		this.con_mon = "";
		this.rent_start_dt = "";
		this.car_id = "";
		this.car_name = "";
		this.car_form= "";
		this.off_id = "";
		this.off_nm = "";
		this.off_tel = "";
		this.tot_dist = "";
		this.average_dist = "";
		this.today_dist = "";
		this.ins_com_nm = "";
		this.ins_exp_dt = "";
		this.agnt_imgn_tel = "";
	}

	// SET Method
	public void setRent_mng_id(String val){
		if(val==null) val="";
		this.rent_mng_id = val;
	}
	public void setRent_l_cd(String val){
		if(val==null) val="";
		this.rent_l_cd = val;
	}
	public void setClient_id(String val){
		if(val==null) val="";
		this.client_id = val;
	}
	public void setCar_mng_id(String val){
		if(val==null) val="";
		this.car_mng_id = val;
	}
	public void setInit_reg_dt(String val){
		if(val==null) val="";
		this.init_reg_dt = val;
	}
	public void setCar_no(String val){
		if(val==null) val="";
		this.car_no = val;
	}
	public void setCar_num(String val){
		if(val==null) val="";
		this.car_num = val;
	}
	public void setFuel_kd(String val){
		if(val==null) val="";
		this.fuel_kd = val;
	}
	public void setClient_nm(String val){
		if(val==null) val="";
		this.client_nm = val;
	}
	public void setFirm_nm(String val){
		if(val==null) val="";
		this.firm_nm = val;
	}
	public void setRent_way(String val){
		if(val==null) val="";
		this.rent_way = val;
	}
	public void setCon_mon(String val){
		if(val==null) val="";
		this.con_mon = val;
	}
	public void setRent_start_dt(String val){
		if(val==null) val="";
		this.rent_start_dt = val;
	}
	public void setCar_id(String val){
		if(val==null) val="";
		this.car_id = val;
	}
	public void setCar_name(String val){
		if(val==null) val="";
		this.car_name = val;
	}
	public void setCar_form(String val){
		if(val==null) val="";
		this.car_form = val;
	}
	public void setOff_id(String val){
		if(val==null) val="";
		this.off_id = val;
	}
	public void setOff_nm(String val){
		if(val==null) val="";
		this.off_nm = val;
	}
	public void setOff_tel(String val){
		if(val==null) val="";
		this.off_tel = val;
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
	public void setIns_com_nm(String val){
		if(val==null) val="";
		this.ins_com_nm = val;
	}
	public void setIns_exp_dt(String val){
		if(val==null) val="";
		this.ins_exp_dt = val;
	}
	public void setAgnt_imgn_tel(String val){
		if(val==null) val="";
		this.agnt_imgn_tel = val;
	}
		
	//Get Method
	
	public String getRent_mng_id(){
		return rent_mng_id;
	}
	public String getRent_l_cd(){
		return rent_l_cd;
	}
	public String getClient_id(){
		return client_id;
	}
	public String getCar_mng_id(){
		return car_mng_id;
	}
	public String getInit_reg_dt(){
		return init_reg_dt;
	}
	public String getCar_no(){
		return car_no;
	}
	public String getCar_num(){
		return car_num;
	}
	public String getFuel_kd(){
		return fuel_kd;
	}
	public String getClient_nm(){
		return client_nm;
	}
	public String getFirm_nm(){
		return firm_nm;
	}
	public String getRent_way(){
		return rent_way;
	}
	public String getCon_mon(){
		return con_mon;
	}
	public String getRent_start_dt(){
		return rent_start_dt;
	}
	public String getCar_id(){
		return car_id;
	}
	public String getCar_name(){
		return car_name;
	}
	public String getCar_form(){
		return car_form;
	}
	public String getOff_id(){
		return off_id;
	}
	public String getOff_nm(){
		return off_nm;
	}
	public String getOff_tel(){
		return off_tel;
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
	public String getIns_com_nm(){
		return ins_com_nm;
	}
	public String getIns_exp_dt(){
		return ins_exp_dt;
	}
	public String getAgnt_imgn_tel(){
		return agnt_imgn_tel;
	}
}