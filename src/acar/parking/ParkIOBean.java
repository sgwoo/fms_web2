/**
 * 주차관리 - 차량입고
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2008. 9. 2
 * @ last modify date : 
 */
package acar.parking;

import java.util.*;

public class ParkIOBean {
    //Table : park_IO
    private String car_mng_id;		//차량관리번호/차대번호
	private int park_seq;
  	private String park_id;		//주차위치
	private String reg_id;			//등록자
	private String io_gubun;		//입출고 구분 (1. 입고, 2. 출고)
	private String car_st;		// 차량 상태(1. 입고예정, 2. 입고완료, 3. 기타)
	private String car_no;		//차량번호
	private String car_nm;		//차종      
	private int car_km;		//실주행거리      
	private String io_dt;		//입출고일시    
	private String io_sau;		//입출고사유  (1. 단기대여, 2. 보험대차, 3. 지연대차, 4. 정비대차, 5. 사고대차, 6. 업무대여, 7. 장기대기, 8. 예약, 9. 차량정비, 10. 사고수리)
	
	private String users_comp;		//사용자(고객)
	private String start_place;		//출발장소 
	private String end_place;		//도착장소 
	private String driver_nm;		//탁송기사 
		
	private String br_id;		    //지점
	private String park_mng;		//담당자 
	private String car_gita;		//차량구분(1. 보유차량, 2. 고객차량) 
	private String use_yn;	
	private String mng_id;	 //담당자
	
	private String total_cnt;	 //현황수
	private String total_pay;	 //합산금액
	
	private String rent_l_cd;

	private String car_key_cau;		// 차키, 주행거리 사유


    // CONSTRCTOR            
    public ParkIOBean() {  
		this.car_mng_id = "";
    	this.park_seq =  0;	
    	this.park_id = "";	
    	this.reg_id = "";
     	this.io_gubun = "";	
    	this.car_st = "";
    	this.car_no = "";
    	this.car_nm = "";
    	this.car_km = 0;
    	this.io_dt = "";
    	this.io_sau = "";
    	this.users_comp = "";
		this.start_place = "";
		this.end_place= "";
		this.driver_nm = "";
		this.br_id ="";
		this.park_mng = "";
		this.car_gita = "";
		this.use_yn = "";
		this.mng_id = "";
		this.total_cnt = "";
		this.total_pay = "";
		this.rent_l_cd = "";
		this.car_key_cau = "";
	}

    
	// set Method
	public void setCar_mng_id(String val){
		this.car_mng_id = val;
	}
	public void setPark_seq(int val){
		this.park_seq = val;
	}
	public void setPark_id(String val){
		this.park_id = val;
	}
	public void setReg_id(String val){
		if(val==null) val="";
		this.reg_id = val;
	}
	public void setIo_gubun(String val){
		if(val==null) val="";
		this.io_gubun = val;
	}
	public void setCar_st(String val){
		if(val==null) val="";
		this.car_st = val;
	}
	public void setCar_no(String val){
		if(val==null) val="";
		this.car_no = val;
	}
	public void setCar_nm(String val){
		if(val==null) val="";
		this.car_nm = val;
	}
	public void setCar_km(int val){
		this.car_km = val;
	}
	
	public void setIo_dt(String val){
		if(val==null) val="";
		this.io_dt = val;
	}
	public void setIo_sau(String val){
		if(val==null) val="";
		this.io_sau = val;
	}
	public void setUsers_comp(String val){
		if(val==null) val="";
		this.users_comp = val;
	}
	public void setStart_place(String val){
		if(val==null) val="";
		this.start_place = val;
	}
	public void setEnd_place(String val){
		if(val==null) val="";
		this.end_place = val;
	}
	public void setDriver_nm(String val){
		if(val==null) val="";
		this.driver_nm = val;
	}
	public void setBr_id(String val){
		if(val==null) val="";
		this.br_id = val;
	}
	public void setPark_mng(String val){
		if(val==null) val="";
		this.park_mng = val;
	}
	public void setCar_gita(String val){
		if(val==null) val="";
		this.car_gita = val;
	}
	public void setUse_yn(String val){
		if(val==null) val="";
		this.use_yn = val;
	}
		
	public void setMng_id(String val){
		if(val==null) val="";
		this.mng_id = val;

	}			
	
	public void setTotal_cnt(String val){
		if(val==null) val="";
		this.total_cnt = val;
		
	}			
	public void setTotal_pay(String val){
		if(val==null) val="0";
		this.total_pay = val;
		
	}			

	public void setRent_l_cd(String val){	if(val==null) val="";		this.rent_l_cd	= val;	}

    public void setCar_key_cau(String val) {
    	this.car_key_cau = val;
    }


	//Get Method
	public String 	getCar_mng_id(){	return car_mng_id;	}
	public int	  	getPark_seq(){		return park_seq;	}
	public String   getPark_id(){		return park_id;		}
	public String 	getReg_id(){		return reg_id;		}
	public String 	getIo_gubun(){		return io_gubun;	}
	public String 	getCar_st(){		return car_st;		}
	public String 	getCar_no(){		return car_no;		}
	public String 	getCar_nm(){		return car_nm;		}
	public int   	getCar_km(){		return car_km;		}
	public String 	getIo_dt(){			return io_dt;		}
	public String 	getIo_sau(){		return io_sau;		}
		
	public String getUsers_comp(){		return users_comp;	}
	public String getStart_place(){		return start_place;	}
	public String getEnd_place(){		return end_place;	}
	public String getDriver_nm(){		return driver_nm;	}
	public String getBr_id(){			return br_id;		}
	public String getPark_mng(){		return park_mng;	}
	public String getCar_gita(){		return car_gita;	}
	public String getUse_yn(){			return use_yn;	}
	public String getMng_id(){			return mng_id;	}
	
	public String getTotal_cnt(){			return total_cnt;	}
	public String getTotal_pay(){			return total_pay;	}

	public String 	getRent_l_cd(){		return rent_l_cd;	}
	public String 	getCar_key_cau(){		return car_key_cau;	}

	
}