/**
 * 보험스케쥴
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.car_register;

import java.util.*;

public class ScdInsBean {
    //Table : CAR_CHA
    private String car_mng_id;			//자동차관리번호
	private String ins_st;			//보험구분
	private String ins_tm;			//회차
	private String ins_est_dt;			//납부예정일
	private String pay_amt;			//납부금액
	private String pay_yn;			//납부여부
	private String pay_yn_nm;
	private String pay_dt;			//실납부일
        
    // CONSTRCTOR            
    public ScdInsBean() {  
	    this.car_mng_id = "";			//자동차관리번호
		this.ins_st = "";			//보험구분
		this.ins_tm = "";			//회차
		this.ins_est_dt = "";			//납부예정일
		this.pay_amt = "";			//납부금액
		this.pay_yn = "";			//납부여부
		this.pay_yn_nm = "";
		this.pay_dt = "";			//실납부일
	}

	// get Method
	public void setCar_mng_id(String val){
		if(val==null) val="";
		this.car_mng_id = val;
	}
	public void setIns_st(String val){
		if(val==null) val="";
		this.ins_st = val;
	}
	public void setIns_tm(String val){
		if(val==null) val="";
		this.ins_tm = val;
	}
	public void setIns_est_dt(String val){
		if(val==null) val="";
		this.ins_est_dt = val;
	}
	public void setPay_amt(String val){
		if(val==null) val="";
		this.pay_amt = val;
	}
	public void setPay_yn(String val){
		if(val==null) val="";
		this.pay_yn = val;
	}
	public void setPay_dt(String val){
		if(val==null) val="";
		this.pay_dt = val;
	}
	
	//Get Method
	public String getCar_mng_id(){
		return car_mng_id;
	}
	public String getIns_st(){
		return ins_st;
	}
	public String getIns_tm(){
		return ins_tm;
	}
	public String getIns_est_dt(){
		return ins_est_dt;
	}
	public String getPay_amt(){
		return pay_amt;
	}
	public String getPay_yn(){
		return pay_yn;
	}
	public String getPay_yn_nm(){
		if(pay_yn.equals("1"))
		{
			pay_yn_nm = pay_dt;
		}else{
			pay_yn_nm = "미지출";
		}
		return pay_yn_nm;
	}
	public String getPay_dt(){
		return pay_dt;
	}
	
}