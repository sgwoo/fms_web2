/**
 * 고객지원 차량리스트 빈
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 10. 15. Wed.
 * @ last modify date : - 2004.2.13.금. car_jnm 차종명 추가.
 */
package acar.cus0401;

import java.util.*;

public class Cus0401_scBean {
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
	private String firm_nm;
	//car_nm 자동차명
	private String car_jnm;		//차종명
	private String car_nm;
	//fee 대여료
	private String rent_start_dt;
	private String rent_end_dt;
	//service 정비이력
	private String serv_id;
	private String serv_dt;
	private String next_serv_dt;
	private String tot_dist;
	private String average_dist;
	private String today_dist;
	private String rent_way;
	        
    public Cus0401_scBean() {
		this.car_mng_id = "";
		this.rent_mng_id = "";
		this.rent_l_cd = "";
		this.firm_nm = "";
		this.car_no = "";
		this.car_jnm = "";
		this.car_nm = "";
		this.brch_id = "";
		this.mng_id = "";
		this.init_reg_dt = "";
		this.rent_start_dt = "";
		this.rent_end_dt = "";
		this.serv_id = "";
		this.serv_dt = "";
		this.next_serv_dt = "";
		this.tot_dist = "";
		this.average_dist = "";
		this.today_dist = "";
		this.rent_way = "";
	}

	public void setCar_mng_id(String val){ if(val==null) val=""; this.car_mng_id = val; }
	public void setRent_mng_id(String val){ if (val==null) val=""; this.rent_mng_id = val; }
	public void setRent_l_cd(String val){ if(val==null) val=""; this.rent_l_cd = val; }
	public void setFirm_nm(String val){ if(val==null) val=""; this.firm_nm = val; }
	public void setCar_no(String val){ if(val==null) val=""; this.car_no = val; }
	public void setCar_jnm(String val){ if(val==null) val=""; this.car_jnm = val; }
	public void setCar_nm(String val){ if(val==null) val=""; this.car_nm = val; }
	public void setBrch_id(String val){ if(val==null) val=""; this.brch_id = val; }
	public void setMng_id(String val){ if(val==null) val=""; this.mng_id = val; }
	public void setInit_reg_dt(String val){ if(val==null) val=""; this.init_reg_dt = val; }
	public void setRent_start_dt(String val){ if(val==null) val=""; this.rent_start_dt = val; }
	public void setRent_end_dt(String val){ if(val==null) val=""; this.rent_end_dt = val; }
	public void setServ_id(String val){ if(val==null) val=""; this.serv_id = val; }
	public void setServ_dt(String val){ if(val==null) val=""; this.serv_dt = val; }
	public void setNext_serv_dt(String val){ if(val==null) val=""; this.next_serv_dt = val; }
	public void setTot_dist(String val){ if(val==null) val=""; this.tot_dist = val; }
	public void setAverage_dist(String val){ if(val==null) val=""; this.average_dist = val; }
	public void setToday_dist(String val){ if(val==null) val=""; this.today_dist = val; }
	public void setRent_way(String val){ if(val==null) val=""; this.rent_way = val; }
	
	public String getCar_mng_id(){return car_mng_id; }
	public String getRent_mng_id(){ return rent_mng_id; }
	public String getRent_l_cd(){ return rent_l_cd; }
	public String getFirm_nm(){ return firm_nm; }
	public String getCar_no(){return car_no; }
	public String getCar_jnm(){ return car_jnm; }
	public String getCar_nm(){ return car_nm; }
	public String getBrch_id(){ return brch_id; }
	public String getMng_id(){ return mng_id; }
	public String getInit_reg_dt(){ return init_reg_dt; }
	public String getRent_start_dt(){ return rent_start_dt; }
	public String getRent_end_dt(){ return rent_end_dt; }
	public String getServ_id(){ return serv_id; }
	public String getServ_dt(){ return serv_dt; }
	public String getNext_serv_dt(){ return next_serv_dt; }
	public String getTot_dist(){ return tot_dist; }
	public String getAverage_dist(){ return average_dist; }
	public String getToday_dist(){ return today_dist; }
	public String getRent_way(){ return rent_way; }
}
