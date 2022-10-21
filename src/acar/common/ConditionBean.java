/**
 * 고객지원 조회 조건항목
 * @ author : 
 * @ e-mail : 
 * @ create date : 
 * @ last modify date : 
 */
package acar.common;

import java.util.*;

public class ConditionBean {

	private String auth_rw;
	private String user_id;
	private String br_id;
	private String gubun1;
	private String gubun2;
	private String gubun3;
	private String gubun4;
	private String st_dt;
	private String end_dt;
	private String s_kd;
	private String t_wd;
	private String s_bus;
	private String s_brch;
	private String sort_gubun;
	private String asc;
	private String idx;
	//
	private String rent_mng_id;
	private String rent_l_cd;
	private String car_mng_id;

	public ConditionBean() {  
		this.auth_rw = "";
		this.user_id = "";
		this.br_id = "";
		this.gubun1 = "";
		this.gubun2 = "";
		this.gubun3 = "";
		this.gubun4 = "";
		this.st_dt = "";
		this.end_dt = "";
		this.s_kd = "";
		this.t_wd = "";
		this.s_bus = "";
		this.s_brch = "";
		this.sort_gubun = "";
		this.asc = "";
		this.idx = "";
		this.rent_mng_id = "";
		this.rent_l_cd = "";
		this.car_mng_id = "";
	}

	// get Method
	public void setAuth_rw(String val){		if(val==null) val="";	this.auth_rw = val;		}
	public void setUser_id(String val){		if(val==null) val="";	this.user_id = val;		}
	public void setBr_id(String val){		if(val==null) val="";	this.br_id = val;		}
	public void setGubun1(String val){		if(val==null) val="";	this.gubun1 = val;		}
	public void setGubun2(String val){		if(val==null) val="";	this.gubun2 = val;		}
	public void setGubun3(String val){		if(val==null) val="";	this.gubun3 = val;		}
	public void setGubun4(String val){		if(val==null) val="";	this.gubun4 = val;		}
	public void setSt_dt(String val){		if(val==null) val="";	this.st_dt = val;		}
	public void setEnd_dt(String val){		if(val==null) val="";	this.end_dt = val;		}
	public void setS_kd(String val){		if(val==null) val="";	this.s_kd = val;		}
	public void setT_wd(String val){		if(val==null) val="";	this.t_wd = val;		}
	public void setS_bus(String val){		if(val==null) val="";	this.s_bus = val;		}
	public void setS_brch(String val){		if(val==null) val="";	this.s_brch = val;		}
	public void setSort_gubun(String val){	if(val==null) val="";	this.sort_gubun = val;	}
	public void setAsc(String val){			if(val==null) val="";	this.asc = val;			}
	public void setIdx(String val){			if(val==null) val="";	this.idx = val;			}
	public void setRent_mng_id(String val){	if(val==null) val="";	this.rent_mng_id = val;	}
	public void setRent_l_cd(String val){	if(val==null) val="";	this.rent_l_cd = val;	}
	public void setCar_mng_id(String val){	if(val==null) val="";	this.car_mng_id = val;	}
	
	//Get Method
	public String getAuth_rw(){		return auth_rw; 	}
	public String getUser_id(){		return user_id;		}
	public String getBr_id(){		return br_id;		}
	public String getGubun1(){		return gubun1;		}
	public String getGubun2(){		return gubun2;		}
	public String getGubun3(){		return gubun3;		}
	public String getGubun4(){		return gubun4;		}
	public String getSt_dt(){		return st_dt;		}
	public String getEnd_dt(){		return end_dt;		}
	public String getS_kd(){		return s_kd;		}
	public String getT_wd(){		return t_wd;		}
	public String getS_bus(){		return s_bus;		}
	public String getS_brch(){		return s_brch;		}
	public String getSort_gubun(){	return sort_gubun;	}
	public String getAsc(){			return asc;			}	
	public String getIdx(){			return idx;			}
	public String getRent_mng_id(){	return rent_mng_id;	}
	public String getRent_l_cd(){	return rent_l_cd;	}
	public String getCar_mng_id(){	return car_mng_id;	}
}