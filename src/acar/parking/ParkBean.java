/**
 * 주차관리 - 주차현황마감
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2011. 7. 15
 * @ last modify date : 
 */
package acar.parking;

import java.util.*;

public class ParkBean {
    //Table : PARK_CONDITION
	private String save_dt;
	private String rent_l_cd;
	private String rent_mng_id;
    private String car_mng_id;		//차량관리번호/차대번호
	private String car_no;		//차량번호
	private String car_nm;		//차종      
	private String init_reg_dt;
	private String car_num;
	private String car_ext;
	private String car_kd;
	private String car_use;		//차량구분(1. 보유차량, 2. 고객차량) 
	private String park_id;		//주차위치
	private String reg_id;		//등록자
	private String io_gubun;	//입출고 구분 (1. 입고, 2. 출고)
	private String car_st;		// 차량 상태(1. 입고예정, 2. 입고완료, 3. 기타)
	private int car_km;		//실주행거리      
	private String io_dt;		//입출고일시    
	private String io_sau;		//입출고사유  (1. 단기대여, 2. 보험대차, 3. 지연대차, 4. 정비대차, 5. 사고대차, 6. 업무대여, 7. 장기대기, 8. 예약, 9. 차량정비, 10. 사고수리)
	private String mng_id;		//사용자(고객)
	private String driver_nm;		//탁송기사 
	private String reg_dt;		    //지점
	private String use_yn;	
	private String car_key;	
	private String car_key_cau;	
	private String area;
	
	private String user_nm;
	private String firm_nm;
	private String user_id;
	private String wash_etc;
	private String start_dt;
	private String start_h;
	private String start_m;
	private String gubun_st;
	private String users_comp;
	private String user_m_tel;
	private String wash_pay;
	private String inclean_pay;
	private String wash_st;
	private String inclean_st;
	private String park_mng;
	private int park_seq;
	private String wash_dt;
	
	
    // CONSTRCTOR            
    public ParkBean() {  
		this.save_dt ="";
		this.rent_l_cd ="";
		this.car_mng_id ="";	//차량관리번호/차대번호
		this.rent_mng_id = "";
		this.car_no ="";//차량번호
		this.car_nm ="";	//차종      
		this.init_reg_dt ="";
		this.car_num ="";
		this.car_ext ="";
		this.car_kd ="";
		this.car_use ="";
		this.park_id ="";	//주차위치
		this.reg_id ="";		//등록자
		this.io_gubun ="";	//입출고 구분 (1. 입고, 2. 출고)
		this.car_st ="";		// 차량 상태(1. 입고예정, 2. 입고완료, 3. 기타)
		this.car_km =0;		//실주행거리      
		this.io_dt ="";	//입출고일시    
		this.io_sau ="";		//입출고사유  (1. 단기대여, 2. 보험대차, 3. 지연대차, 4. 정비대차, 5. 사고대차, 6. 업무대여, 7. 장기대기, 8. 예약, 9. 차량정비, 10. 사고수리)
		this.mng_id ="";		//사용자(고객)
		this.driver_nm ="";		//탁송기사 
		this.reg_dt ="";		    //지점
		this.use_yn ="";
		this.car_key_cau ="";		    //
		this.car_key="";
		this.area="";
		
		this.user_nm="";
		this.firm_nm="";
		this.user_id="";
		this.wash_etc="";
		this.start_dt="";
		this.start_h="";
		this.start_m="";
		this.gubun_st="";
		this.users_comp="";
		this.user_m_tel="";
		this.wash_pay="";
		this.inclean_pay="";
		this.wash_st="";
		this.inclean_st="";
		this.park_mng="";
		this.park_seq=0;
		this.wash_dt="";
		
	}

	// set Method
	public void setSave_dt(String val){		if(val==null) val="";		this.save_dt	= val;	}
	public void setRent_l_cd(String val){	if(val==null) val="";		this.rent_l_cd	= val;	}
	public void setRent_mng_id(String val){	if(val==null) val="";		this.rent_mng_id = val;	}
	public void setCar_mng_id(String val){	if(val==null) val="";		this.car_mng_id = val;	}
	public void setCar_no(String val){		if(val==null) val="";		this.car_no = val;		}
	public void setCar_nm(String val){		if(val==null) val="";		this.car_nm = val;		}
	public void setInit_reg_dt(String val){ if(val==null) val="";		this.init_reg_dt = val;		}
	public void setCar_num(String val){		if(val==null) val="";		this.car_num = val;		}
	public void setCar_ext(String val){		if(val==null) val="";		this.car_ext = val;		}
	public void setCar_kd(String val){		if(val==null) val="";		this.car_kd = val;		}
	public void setCar_use(String val){		if(val==null) val="";		this.car_use = val;		}
	public void setPark_id(String val){		if(val==null) val="";		this.park_id = val;		}
	public void setReg_id(String val){		if(val==null) val="";		this.reg_id = val;		}
	public void setIo_gubun(String val){	if(val==null) val="";		this.io_gubun = val;	}
	public void setCar_st(String val){		if(val==null) val="";		this.car_st = val;		}
	public void setCar_km(int val){
		this.car_km = val;
	}
	public void setIo_dt(String val){		if(val==null) val="";		this.io_dt = val;		}
	public void setIo_sau(String val){		if(val==null) val="";		this.io_sau = val;		}
	public void setMng_id(String val){		if(val==null) val="";		this.mng_id = val;		}
	public void setDriver_nm(String val){	if(val==null) val="";		this.driver_nm = val;	}
	public void setReg_dt(String val){		if(val==null) val="";		this.reg_dt = val;		}
	public void setUse_yn(String val){		if(val==null) val="";		this.use_yn = val;		}
	
	public void setCar_key(String val){		if(val==null) val="";		this.car_key = val;		}
	public void setCar_key_cau(String val){		if(val==null) val="";		this.car_key_cau = val;		}
	public void setArea(String val){		if(val==null) val="";		this.area = val;		}
			
	public void setUser_nm(String val){		if(val==null) val="";		this.user_nm = val;		}
	public void setFirm_nm(String val){		if(val==null) val="";		this.firm_nm = val;		}			
	public void setUser_id(String val){		if(val==null) val="";		this.user_id = val;		}			
	public void setWash_etc(String val){	if(val==null) val="";		this.wash_etc = val;		}			
	public void setStart_dt(String val){	if(val==null) val="";		this.start_dt = val;		}			
	public void setStart_h(String val){		if(val==null) val="";		this.start_h = val;		}			
	public void setStart_m(String val){		if(val==null) val="";		this.start_m = val;		}			
	public void setGubun_st(String val){	if(val==null) val="";		this.gubun_st = val;		}			
	public void setUsers_comp(String val){	if(val==null) val="";		this.users_comp = val;	}			
	public void setUser_m_tel(String val){	if(val==null) val="";		this.user_m_tel = val;	}			
	public void setWash_pay(String val){	if(val==null) val="";		this.wash_pay = val;	}			
	public void setInclean_pay(String val){	if(val==null) val="";		this.inclean_pay = val;	}			
	public void setWash_st(String val){		if(val==null) val="";		this.wash_st = val;	}			
	public void setInclean_st(String val){	if(val==null) val="";		this.inclean_st = val;	}			
	public void setPark_mng(String val){	if(val==null) val="";		this.park_mng = val;	}			
	public void setPark_seq(int val){
		this.park_seq = val;
	}
	
	public void setWash_dt(String val){		if(val==null) val="";		this.wash_dt = val;	}			

	//Get Method
	public String	getSave_dt(){		return save_dt;		}
	public String 	getRent_l_cd(){		return rent_l_cd;	}
	public String 	getRent_mng_id(){	return rent_mng_id;	}
	public String 	getCar_mng_id(){	return car_mng_id;	}
	public String 	getCar_no(){		return car_no;		}
	public String 	getCar_nm(){		return car_nm;		}
	public String  	getInit_reg_dt(){	return init_reg_dt;	}
	public String	getCar_num(){		return car_num;		}
	public String	getCar_ext(){		return car_ext;		}
	public String	getCar_kd(){		return car_kd;		}
	public String	getCar_use(){		return car_use;		}
	public String   getPark_id(){		return park_id;		}
	public String 	getReg_id(){		return reg_id;		}
	public String 	getIo_gubun(){		return io_gubun;	}
	public String 	getCar_st(){		return car_st;		}
	public int  	getCar_km(){		return car_km;		}
	public String 	getIo_dt(){			return io_dt;		}
	public String 	getIo_sau(){		return io_sau;		}
	public String	getMng_id(){		return mng_id;		}
	public String	getDriver_nm(){		return driver_nm;	}
	public String	getReg_dt(){		return reg_dt;		}
	public String	getUse_yn(){		return use_yn;		}
	
	public String	getCar_key(){		return car_key;		}
	public String	getCar_key_cau(){		return car_key_cau;		}
	public String	getArea(){		return area;		}
	
	public String	getUser_nm(){		return user_nm;		}
	public String	getFirm_nm(){		return firm_nm;		}
	public String	getUser_id(){		return user_id;		}
	public String	getWash_etc(){		return wash_etc;	}
	public String	getStart_dt(){		return start_dt;	}
	public String	getStart_h(){		return start_h;		}
	public String	getStart_m(){		return start_m;		}
	public String	getGubun_st(){		return gubun_st;		}
	public String	getUsers_comp(){	return users_comp;		}
	public String	getUser_m_tel(){	return user_m_tel;		}
	public String	getWash_pay(){		return wash_pay;		}
	public String	getInclean_pay(){	return inclean_pay;		}
	public String	getWash_st(){		return wash_st;		}
	public String	getInclean_st(){	return inclean_st;		}
	public String	getPark_mng(){	return park_mng;		}
	public int	getPark_seq(){	return park_seq;		}
	public String	getWash_dt(){	return wash_dt;		}

}