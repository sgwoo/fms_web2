/**
 * 고객지원 차량정보 빈
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 10. 21. Tue.
 * @ last modify date : - 2004.2.13.금. car_jnm 차종명 추가.
 */
package acar.cus0401;

import java.util.*;

public class Cus0401_carinfoBean {
	//car_reg 자동차관리
	private String car_mng_id;
	private String car_no;
	private String car_num;
	private String init_reg_dt;
	private String car_kd;
	private String car_use;
	private String car_form;
	private String car_y_form;
	private String mot_form;	
	private String dpm;	
	private String fuel_kd;
	private String conti_rat;
	//cont 계약
	private String rent_mng_id;
	private String rent_l_cd;
	//car_nm 자동차명
	private String car_jnm;		//차종명
	private String car_nm;
	//car_etc 차량기본사항
	private String colo;
	//insur	보험
	private String ins_com_nm;
	private String ins_start_dt;
	private String ins_exp_dt;
	private String agnt_imgn_tel;
	private String acc_tel;
	private String age_scp;
	private String vins_cacdt_amt;
	private String vins_spe;
	//car_maint 정기검사
	private String che_st_dt;
	private String che_end_dt;
	
    public Cus0401_carinfoBean() {
		this.car_mng_id = "";	//car_reg
		this.car_no = "";
		this.car_num = "";
		this.init_reg_dt = "";
		this.car_kd = "";
		this.car_use = "";
		this.car_form = "";
		this.car_y_form = "";
		this.mot_form = "";
		this.dpm = "";
		this.fuel_kd = "";
		this.rent_mng_id = "";	//cont
		this.rent_l_cd = "";
		this.car_jnm = "";
		this.car_nm = "";		//car_nm
		this.colo = "";
		this.conti_rat = "";
		this.age_scp = "";
		this.ins_com_nm = "";
		this.ins_start_dt = "";
		this.ins_exp_dt = "";
		this.agnt_imgn_tel = "";
		this.acc_tel = "";
		this.vins_spe = "";
		this.vins_cacdt_amt = "";
		this.che_st_dt = "";
		this.che_end_dt = "";
	}

	public void setCar_mng_id(String val){if(val==null) val="";	this.car_mng_id = val;}
	public void setCar_no(String val){if(val==null) val="";	this.car_no = val;}
	public void setCar_num(String val){if(val==null) val="";	this.car_num = val;}
	public void setInit_reg_dt(String val){if(val==null) val="";	this.init_reg_dt = val;}
	public void setCar_kd(String val){if(val==null) val="";	this.car_kd = val;}
	public void setCar_use(String val){if(val==null) val="";	this.car_use = val;}
	public void setCar_form(String val){if(val==null) val="";	this.car_form = val;}
	public void setCar_y_form(String val){if(val==null) val="";	this.car_y_form = val;}
	public void setMot_form(String val){if(val==null) val="";	this.mot_form = val;}
	public void setDpm(String val){if(val==null) val="";	this.dpm = val;}
	public void setFuel_kd(String val){if(val==null) val="";	this.fuel_kd = val;}
	public void setRent_mng_id(String val){ if (val==null) val=""; this.rent_mng_id = val; }
	public void setRent_l_cd(String val){ if(val==null) val=""; this.rent_l_cd = val; }
	public void setCar_jnm(String val){ if(val==null) val=""; this.car_jnm = val; }
	public void setCar_nm(String val){ if(val==null) val=""; this.car_nm = val; }
	public void setColo(String val){if(val==null) val="";	this.colo = val;}
	public void setConti_rat(String val){if(val==null) val="";	this.conti_rat = val;}
	public void setAge_scp(String val){if(val==null) val="";	this.age_scp = val;}
	public void setIns_com_nm(String val){if(val==null) val="";	this.ins_com_nm = val;}
	public void setIns_start_dt(String val){if(val==null) val="";	this.ins_start_dt = val;}
	public void setIns_exp_dt(String val){if(val==null) val="";	this.ins_exp_dt = val;}
	public void setAgnt_imgn_tel(String val){if(val==null) val="";	this.agnt_imgn_tel = val;}
	public void setAcc_tel(String val){if(val==null) val="";	this.acc_tel = val;}
	public void setVins_spe(String val){if(val==null) val="";	this.vins_spe = val;}
	public void setVins_cacdt_amt(String val){if(val==null) val="";	this.vins_cacdt_amt = val;}
	public void setChe_st_dt(String val){ if(val==null) val=""; this.che_st_dt = val; }
	public void setChe_end_dt(String val){ if(val==null) val=""; this.che_end_dt = val; }
	
	public String getCar_mng_id(){return car_mng_id; }
	public String getCar_no(){return car_no; }
	public String getCar_num(){return car_num; }
	public String getInit_reg_dt(){return init_reg_dt; }
	public String getCar_kd(){return car_kd; }
	public String getCar_use(){return car_use; }
	public String getCar_form(){return car_form; }
	public String getCar_y_form(){return car_y_form; }
	public String getMot_form(){return mot_form; }
	public String getDpm(){return dpm; }
	public String getFuel_kd(){return fuel_kd; }
	public String getRent_mng_id(){ return rent_mng_id; }
	public String getRent_l_cd(){ return rent_l_cd; }
	public String getCar_jnm(){ return car_jnm; }
	public String getCar_nm(){ return car_nm; }
	public String getColo(){return colo; }
	public String getConti_rat(){return conti_rat; }
	public String getAge_scp(){return age_scp; }
	public String getIns_com_nm(){return ins_com_nm; }
	public String getIns_start_dt(){return ins_start_dt; }
	public String getIns_exp_dt(){return ins_exp_dt; }
	public String getAgnt_imgn_tel(){return agnt_imgn_tel; }
	public String getAcc_tel(){return acc_tel; }
	public String getVins_spe(){return vins_spe; }
	public String getVins_cacdt_amt(){return vins_cacdt_amt; }
	public String getChe_st_dt(){ return che_st_dt; }
	public String getChe_end_dt(){ return che_end_dt; }
}
