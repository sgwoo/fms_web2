/**
 * 당일업무 스케쥴
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2004.03.05.
 * @ last modify date : 
 */
package acar.car_sche;

import java.util.*;

public class TodayScheBean {
	private String car_mng_id;
	private String serv_id;
	private String car_no;
	private String car_name;
	private String firm_nm;
	private String off_nm;
	private String serv_dt;
	private String serv_st;
	private String serv_st_nm;
	private String rep_cont;
        
    // CONSTRCTOR            
    public TodayScheBean() {  
		this.car_mng_id = "";
		this.serv_id = "";
		this.car_no = "";
		this.car_name = "";
		this.firm_nm = "";
		this.off_nm = "";
		this.serv_dt = "";
		this.serv_st = "";
		this.serv_st_nm = "";
		this.rep_cont = "";
	}

	// set Method
	public void setCar_mng_id(String val){	if(val==null) val=""; this.car_mng_id = val; }
	public void setServ_id(String val){		if(val==null) val=""; this.serv_id = val; }
	public void setCar_no(String val){		if(val==null) val=""; this.car_no = val; }
	public void setCar_name(String val){	if(val==null) val=""; this.car_name = val;	}
	public void setFirm_nm(String val){		if(val==null) val=""; this.firm_nm = val; }
	public void setOff_nm(String val){		if(val==null) val=""; this.off_nm = val;	}
	public void setServ_dt(String val){		if(val==null) val=""; this.serv_dt = val;	}
	public void setServ_st(String val){		if(val==null) val=""; this.serv_st = val;	}
	public void setServ_st_nm(String val){
		if(val=="1")	this.serv_st_nm = "순회점검"; 
		else if(val=="2")	this.serv_st_nm = "일반수리";
		else if(val=="3")	this.serv_st_nm = "보증수리";
		else if(val=="4")	this.serv_st_nm = "운행자차";
		else if(val=="5")	this.serv_st_nm = "사고자차";
		else if(val=="6")	this.serv_st_nm = "수해";
		else if(val=="7")	this.serv_st_nm = "재리스정비";
		else				this.serv_st_nm = "";
	}
	public void setRep_cont(String val){	if(val==null) val=""; this.rep_cont = val;	}

	//Get Method
	public String getCar_mng_id(){	return car_mng_id;	}
	public String getServ_id(){		return serv_id;		}
	public String getCar_no(){		return car_no;		}
	public String getCar_name(){	return car_name;	}
	public String getFirm_nm(){		return firm_nm;		}
	public String getOff_nm(){		return off_nm;		}
	public String getServ_dt(){		return serv_dt;		}
	public String getServ_st(){		return serv_st;		}
	public String getServ_st_nm(){	return serv_st_nm;	}
	public String getRep_cont(){	return rep_cont;	}
}