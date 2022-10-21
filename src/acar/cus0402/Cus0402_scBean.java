/**
 * 고객지원 차량리스트 빈
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 11. 25. 화.
 * @ last modify date : - 
 */
package acar.cus0402;

import java.util.*;

public class Cus0402_scBean {
	//car_reg 자동차관리
	private String car_mng_id;
	private String car_no;
	private String init_reg_dt;
	//cont 계약
	private String rent_mng_id;
	private String rent_l_cd;
	private String brch_id;
	private String mng_id;
	//client 고객
	private String client_id;
	private String firm_nm;
	//car_nm 자동차명
	private String car_nm;
	//fee 대여료
	private String rent_start_dt;
	private String rent_end_dt;
	//service 정비이력
	private String serv_dt;
	private String next_serv_dt;
	private String tot_dist;
	//cycle_vst 순회방문
	private String vst_dt;
	private String vst_est_dt;

        
    public Cus0402_scBean() {
		this.car_mng_id = "";
		this.rent_mng_id = "";
		this.rent_l_cd = "";
		this.client_id = "";
		this.firm_nm = "";
		this.car_no = "";
		this.car_nm = "";
		this.brch_id = "";
		this.mng_id = "";
		this.init_reg_dt = "";
		this.rent_start_dt = "";
		this.rent_end_dt = "";
		this.serv_dt = "";
		this.next_serv_dt = "";
		this.vst_dt = "";
		this.vst_est_dt = "";
		this.tot_dist = "";
	}

	public void setCar_mng_id(String val){if(val==null) val="";	this.car_mng_id = val;}
	public void setRent_mng_id(String val){ if (val==null) val=""; this.rent_mng_id = val; }
	public void setRent_l_cd(String val){ if(val==null) val=""; this.rent_l_cd = val; }
	public void setClient_id(String val){ if(val==null) val=""; this.client_id = val; }
	public void setFirm_nm(String val){ if(val==null) val=""; this.firm_nm = val; }
	public void setCar_no(String val){ if(val==null) val=""; this.car_no = val; }
	public void setCar_nm(String val){ if(val==null) val=""; this.car_nm = val; }
	public void setBrch_id(String val){ if(val==null) val=""; this.brch_id = val; }
	public void setMng_id(String val){ if(val==null) val=""; this.mng_id = val; }
	public void setInit_reg_dt(String val){ if(val==null) val=""; this.init_reg_dt = val; }
	public void setRent_start_dt(String val){ if(val==null) val=""; this.rent_start_dt = val; }
	public void setRent_end_dt(String val){ if(val==null) val=""; this.rent_end_dt = val; }
	public void setServ_dt(String val){ if(val==null) val=""; this.serv_dt = val; }
	public void setNext_serv_dt(String val){ if(val==null) val=""; this.next_serv_dt = val; }
	public void setVst_dt(String val){ if(val==null) val=""; this.vst_dt = val; }
	public void setVst_est_dt(String val){ if(val==null) val=""; this.vst_est_dt = val; }
	public void setTot_dist(String val){ if(val==null) val=""; this.tot_dist = val; }
	
	public String getCar_mng_id(){return car_mng_id; }
	public String getRent_mng_id(){ return rent_mng_id; }
	public String getRent_l_cd(){ return rent_l_cd; }
	public String getClient_id(){ return client_id; }
	public String getFirm_nm(){ return firm_nm; }
	public String getCar_no(){return car_no; }
	public String getCar_nm(){ return car_nm; }
	public String getBrch_id(){ return brch_id; }
	public String getMng_id(){ return mng_id; }
	public String getInit_reg_dt(){ return init_reg_dt; }
	public String getRent_start_dt(){ return rent_start_dt; }
	public String getRent_end_dt(){ return rent_end_dt; }
	public String getServ_dt(){ return serv_dt; }
	public String getNext_serv_dt(){ return next_serv_dt; }
	public String getVst_dt(){ return vst_dt; }
	public String getVst_est_dt(){ return vst_est_dt; }
	public String getTot_dist(){ return tot_dist; }
}