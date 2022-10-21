/**
 * 경영지원 차량현황
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 05. 06. Tue.
 * @ last modify date :
 */
package acar.con_car;

import java.util.*;

public class CarBean {

	//Member variable
	private String rent_l_cd;		//계약번호
	private String client_nm;		//상호
	private String car_no;			//차량번호
	private String init_reg_dt;		//최초등록일
	private String car_nm;			//차명
	private String con_mon;			//대여개월수
	private int fee_mon;			//월대여료
	private int allot_jan;			//할부금잔액
	private String allot_bank;		//할부금융사
	private String rent_start_dt;	//대여개시일
	private String rent_end_dt;		//대여만료일
	private String rent_st;			//연장여부
	private int pp_amt;				//선납금
	private int ifee_amt;			//개시대여료
	private int grt_amt;			//보증금
	private String bus_nm;			//영업담당자
        
    //Constructor
    public CarBean() {
		this.rent_l_cd = "";
		this.client_nm = "";
		this.car_no = "";
		this.init_reg_dt = "";
		this.car_nm = "";
		this.con_mon = "";
		this.fee_mon = 0;
		this.allot_jan = 0;
		this.allot_bank = "";
		this.rent_start_dt = "";
		this.rent_end_dt = "";
		this.rent_st = "";
		this.pp_amt = 0;
		this.ifee_amt = 0;
		this.grt_amt = 0;
		this.bus_nm = "";
	}

	//Set Method
	public void setRent_l_cd(String val){ if(val==null) val=""; this.rent_l_cd = val; }
	public void setClient_nm(String val){ if(val==null) val=""; this.client_nm = val; }
	public void setCar_no(String val){ if(val==null) val=""; this.car_no = val; }
	public void setInit_reg_dt(String val){ if(val==null) val=""; this.init_reg_dt = val; }
	public void setCar_nm(String val){ if(val==null) val=""; this.car_nm = val; }
	public void setCon_mon(String val){ if(val==null) val=""; this.con_mon = val; }
	public void setFee_mon(int val){ this.fee_mon = val; }
	public void setAllot_jan(int val){ this.allot_jan = val; }
	public void setAllot_bank(String val){ if(val==null) val=""; this.allot_bank = val; }
	public void setRent_start_dt(String val){ if(val==null) val=""; this.rent_start_dt = val; }
	public void setRent_end_dt(String val){ if(val==null) val=""; this.rent_end_dt = val; }
	public void setRent_st(String val){ if(val==null) val=""; this.rent_st = val; }
	public void setPp_amt(int val){ this.pp_amt = val; }
	public void setIfee_amt(int val){ this.ifee_amt = val; }
	public void setGrt_amt(int val){ this.grt_amt = val; }
	public void setBus_nm(String val){ if(val==null) val=""; this.bus_nm = val; }

	//Get Method
	public String getRent_l_cd(){ return rent_l_cd; }
	public String getClient_nm(){ return client_nm; }
	public String getCar_no(){ return car_no; }
	public String getInit_reg_dt(){ return init_reg_dt; }
	public String getCar_nm(){ return car_nm; }
	public String getCon_mon(){ return con_mon; }
	public int getFee_mon(){ return fee_mon; }
	public int getAllot_jan(){ return allot_jan; }
	public String getAllot_bank(){ return allot_bank; }
	public String getRent_start_dt(){ return rent_start_dt; }
	public String getRent_end_dt(){ return rent_end_dt; }
	public String getRent_st(){ return rent_st; }
	public int getPp_amt(){ return pp_amt; }
	public int getIfee_amt(){ return ifee_amt; }
	public int getGrt_amt(){ return grt_amt; }
	public String getBus_nm(){ return bus_nm; }
}