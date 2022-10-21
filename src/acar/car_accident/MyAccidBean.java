/**
 * 사고기록-보험금 청구내역 (휴차료/대차료)
 */
package acar.car_accident;

import java.util.*;

public class MyAccidBean {
    //Table : CAR_REG
	private String car_mng_id; 					
	private String accid_id;
	private String ins_req_gu;
	private String ins_req_st;
	private String ins_car_nm;
	private String ins_car_no;
	private int ins_day_amt;
	private String ins_use_st;
	private String ins_use_et;
	private String ins_nm;
	private String ins_tel;
	private String ins_tel2;
	private String ins_fax;
	private String ins_addr;
	private int ins_req_amt;
	private String ins_req_dt;
	private int ins_pay_amt;
	private String ins_pay_dt;
	private String ins_use_day;
	
        
    // CONSTRCTOR            
    public MyAccidBean() {  
		this.car_mng_id = ""; 					
		this.accid_id = "";
		this.ins_req_gu = "";
		this.ins_req_st = "";
		this.ins_car_nm = "";
		this.ins_car_no = "";
		this.ins_day_amt =0;
		this.ins_use_st = "";
		this.ins_use_et = "";
		this.ins_nm = "";
		this.ins_tel = "";
		this.ins_tel2 = "";
		this.ins_fax = "";
		this.ins_addr = "";
		this.ins_req_amt = 0;
		this.ins_req_dt = "";
		this.ins_pay_amt = 0;
		this.ins_pay_dt = "";
		this.ins_use_day = "";
	}

	// get Method
	public void setCar_mng_id(String val){
		if(val==null) val="";
		this.car_mng_id = val;
	}
	public void setAccid_id(String val){
		if(val==null) val="";
		this.accid_id = val;
	}
	public void setIns_req_gu(String val){		if(val==null) val="";	this.ins_req_gu = val;	}	
	public void setIns_req_st(String val){		if(val==null) val="";	this.ins_req_st = val;	}	
	public void setIns_car_nm(String val){		if(val==null) val="";	this.ins_car_nm = val;	}	
	public void setIns_car_no(String val){		if(val==null) val="";	this.ins_car_no = val;	}	
	public void setIns_day_amt(int val){								this.ins_day_amt = val;	}
	public void setIns_use_st(String val){		if(val==null) val="";	this.ins_use_st = val;	}	
	public void setIns_use_et(String val){		if(val==null) val="";	this.ins_use_et = val;	}	
	public void setIns_nm(String val){			if(val==null) val="";	this.ins_nm = val;		}	
	public void setIns_tel(String val){			if(val==null) val="";	this.ins_tel = val;		}	
	public void setIns_tel2(String val){		if(val==null) val="";	this.ins_tel2 = val;	}	
	public void setIns_fax(String val){			if(val==null) val="";	this.ins_fax = val;		}	
	public void setIns_addr(String val){		if(val==null) val="";	this.ins_addr = val;	}	
	public void setIns_req_amt(int val){								this.ins_req_amt = val;	}
	public void setIns_req_dt(String val){		if(val==null) val="";	this.ins_req_dt = val;	}	
	public void setIns_pay_amt(int val){								this.ins_pay_amt = val;	}
	public void setIns_pay_dt(String val){		if(val==null) val="";	this.ins_pay_dt = val;	}	
	public void setIns_use_day(String val){		if(val==null) val="";	this.ins_use_day = val;	}	
		
	//Get Method
	public String getCar_mng_id(){
		return car_mng_id;
	}
	public String getAccid_id(){
		return accid_id;
	}
	public String getIns_req_gu(){		return ins_req_gu;	}	
	public String getIns_req_st(){		return ins_req_st;	}	
	public String getIns_car_nm(){		return ins_car_nm;	}	
	public String getIns_car_no(){		return ins_car_no;	}	
	public int getIns_day_amt(){		return ins_day_amt;	}
	public String getIns_use_st(){		return ins_use_st;	}	
	public String getIns_use_et(){		return ins_use_et;	}	
	public String getIns_nm(){			return ins_nm;		}	
	public String getIns_tel(){			return ins_tel;		}	
	public String getIns_tel2(){		return ins_tel2;	}	
	public String getIns_fax(){			return ins_fax;		}	
	public String getIns_addr(){		return ins_addr;	}	
	public int getIns_req_amt(){		return ins_req_amt;	}
	public String getIns_req_dt(){		return ins_req_dt;	}	
	public int getIns_pay_amt(){		return ins_pay_amt;	}
	public String getIns_pay_dt(){		return ins_pay_dt;	}	
	public String getIns_use_day(){		return ins_use_day;	}	
	
}