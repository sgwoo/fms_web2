/**
 * 주차관리 - 차량입고
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2008. 9. 2
 * @ last modify date : 
 */
package acar.parking;

import java.util.*;

public class ParkingBean {
	
    //Table : parking
    private String car_mng_id;	//차량관리번호
    private int serv_seq;
    private String serv_dt;    //점검일
	private String park_id;
	private int car_km;

	private String e_oil;
	private String cool_wt;
	private String ws_wt;
	private String e_clean;
	private String out_clean;
	private String tire_air;
	private String tire_mamo;
	private String lamp;
	private String in_clean;
	private String wiper;
	private String panel;
	private String front_bp;
	private String back_bp;
	private String lh_fhd;
	private String lh_bhd;
	private String lh_fdoor;
	private String lh_bdoor;
	private String rh_fhd;
	private String rh_bhd;
	private String rh_fdoor;
	private String rh_bdoor;
	private String energy;
	private String car_sound;
	private String goods1;
	private String goods2;
	private String goods3;
	private String goods4;
	private String goods5;
	private String goods6;
	private String goods7;
	private String goods8;
	private String goods9;
	private String goods10;
	private String goods11;
	private String goods12;
	private String goods13;
	private String e_oil_ny;
	private String cool_wt_ny;
	private String ws_wt_ny;
	private String e_clean_ny;
	private String out_clean_ny;
	private String tire_air_ny;
	private String tire_mamo_ny;
	private String lamp_ny;
	private String in_clean_ny;
	private String wiper_ny;
	private String panel_ny;
	private String front_bp_ny;
	private String back_bp_ny;
	private String lh_fhd_ny;
	private String lh_bhd_ny;
	private String lh_fdoor_ny;
	private String lh_bdoor_ny;
	private String rh_fhd_ny;
	private String rh_bhd_ny;
	private String rh_fdoor_ny;
	private String rh_bdoor_ny;
	private String energy_ny;
	private String car_sound_ny;
	private String gita;
	
	private String reg_id;
	private String reg_dt;
	private String gubun;
	private int  park_seq;
	private String area;

	private String car_key;
	private String car_key_cau;	
	
    // CONSTRCTOR            
    public ParkingBean() {  
    	this.car_mng_id ="";
    	this.serv_seq = 0;		
    	this.serv_dt = "";
		this.park_id = "";
		this.car_km = 0;
			
		this.e_oil = "";
		this.cool_wt = "";
		this.ws_wt = "";
		this.e_clean = "";
		this.out_clean = "";
		this.tire_air = "";
		this.tire_mamo = "";
		this.lamp = "";
		this.in_clean = "";
		this.wiper = "";
		this.panel = "";
		this.front_bp = "";
		this.back_bp = "";
		this.lh_fhd = "";
		this.lh_bhd = "";
		this.lh_fdoor = "";
		this.lh_bdoor = "";
		this.rh_fhd = "";
		this.rh_bhd = "";
		this.rh_fdoor = "";
		this.rh_bdoor = "";
		this.energy = "";
		this.car_sound = "";
		this.goods1 = "";
		this.goods2 = "";
		this.goods3 = "";
		this.goods4 = "";
		this.goods5 = "";
		this.goods6 = "";
		this.goods7 = "";
		this.goods8 = "";
		this.goods9 = "";
		this.goods10 = "";
		this.goods11 = "";
		this.goods12 = "";
		this.goods13 = "";
		this.e_oil_ny = "";
		this.cool_wt_ny = "";
		this.ws_wt_ny = "";
		this.e_clean_ny = "";
		this.out_clean_ny = "";
		this.tire_air_ny = "";
		this.tire_mamo_ny = "";
		this.lamp_ny = "";
		this.in_clean_ny = "";
		this.wiper_ny = "";
		this.panel_ny = "";
		this.front_bp_ny = "";
		this.back_bp_ny = "";
		this.lh_fhd_ny = "";
		this.lh_bhd_ny = "";
		this.lh_fdoor_ny = "";
		this.lh_bdoor_ny = "";
		this.rh_fhd_ny = "";
		this.rh_bhd_ny = "";
		this.rh_fdoor_ny = "";
		this.rh_bdoor_ny = "";
		this.energy_ny = "";
		this.car_sound_ny = "";
		this.gita = "";

		this.reg_id ="";
		this.reg_dt = "";
		this.gubun = "";
		this.park_seq = 0;
		this.area = "";

		this.car_key = "";
		this.car_key_cau ="";
	
	}

	// set Method
	public void setCar_mng_id(String val){
		if(val==null) val="";
		this.car_mng_id = val;
	}
	public void setServ_seq(int val){
		this.serv_seq = val;
	}
	public void setServ_dt(String val){
		if(val==null) val="";
		this.serv_dt = val;
	}
	public void setPark_id(String val){
		if(val==null) val="";
		this.park_id = val;
	}
	public void setCar_km(int val){
		this.car_km = val;
	}
			
	public void setE_oil(String val){
		if(val==null) val="";
		this.e_oil = val;
	}
	public void setCool_wt(String val){
		if(val==null) val="";
		this.cool_wt = val;
	}
	public void setWs_wt(String val){
		if(val==null) val="";
		this.ws_wt = val;
	}
	public void setE_clean(String val){
		if(val==null) val="";
		this.e_clean = val;
	}
	public void setOut_clean(String val){
		if(val==null) val="";
		this.out_clean = val;
	}
	public void setTire_air(String val){
		if(val==null) val="";
		this.tire_air = val;
	}
	public void setTire_mamo(String val){
		if(val==null) val="";
		this.tire_mamo = val;
	}
	public void setLamp(String val){
		if(val==null) val="";
		this.lamp = val;
	}
	public void setIn_clean(String val){
		if(val==null) val="";
		this.in_clean = val;
	}
	public void setWiper(String val){
		if(val==null) val="";
		this.wiper = val;
	}
	public void setPanel(String val){
		if(val==null) val="";
		this.panel = val;
	}
	public void setFront_bp(String val){
		if(val==null) val="";
		this.front_bp = val;
	}
	public void setBack_bp(String val){
		if(val==null) val="";
		this.back_bp = val;
	}
	public void setLh_fhd(String val){
		if(val==null) val="";
		this.lh_fhd = val;
	}
	public void setLh_bhd(String val){
		if(val==null) val="";
		this.lh_bhd = val;
	}
	public void setLh_fdoor(String val){
		if(val==null) val="";
		this.lh_fdoor = val;
	}
	public void setLh_bdoor(String val){
		if(val==null) val="";
		this.lh_bdoor = val;
	}
	public void setRh_fhd(String val){
		if(val==null) val="";
		this.rh_fhd = val;
	}
	public void setRh_bhd(String val){
		if(val==null) val="";
		this.rh_bhd = val;
	}
	public void setRh_fdoor(String val){
		if(val==null) val="";
		this.rh_fdoor = val;
	}
	public void setRh_bdoor(String val){
		if(val==null) val="";
		this.rh_bdoor = val;
	}
	public void setEnergy(String val){
		if(val==null) val="";
		this.energy = val;
	}
	public void setCar_sound(String val){
		if(val==null) val="";
		this.car_sound = val;
	}
	public void setGoods1(String val){
		if(val==null) val="";
		this.goods1 = val;
	}
	public void setGoods2(String val){
		if(val==null) val="";
		this.goods2 = val;
	}
	public void setGoods3(String val){
		if(val==null) val="";
		this.goods3 = val;
	}
	public void setGoods4(String val){
		if(val==null) val="";
		this.goods4 = val;
	}
	public void setGoods5(String val){
		if(val==null) val="";
		this.goods5 = val;
	}
	public void setGoods6(String val){
		if(val==null) val="";
		this.goods6 = val;
	}
	public void setGoods7(String val){
		if(val==null) val="";
		this.goods7 = val;
	}
	public void setGoods8(String val){
		if(val==null) val="";
		this.goods8 = val;
	}
	public void setGoods9(String val){
		if(val==null) val="";
		this.goods9 = val;
	}
	public void setGoods10(String val){
		if(val==null) val="";
		this.goods10 = val;
	}
	public void setGoods11(String val){
		if(val==null) val="";
		this.goods11 = val;
	}
	public void setGoods12(String val){
		if(val==null) val="";
		this.goods12 = val;
	}
	public void setGoods13(String val){
		if(val==null) val="";
		this.goods13 = val;
	}
	public void setE_oil_ny(String val){
		if(val==null) val="";
		this.e_oil_ny = val;
	}
	public void setCool_wt_ny(String val){
		if(val==null) val="";
		this.cool_wt_ny = val;
	}
	public void setWs_wt_ny(String val){
		if(val==null) val="";
		this.ws_wt_ny = val;
	}
	public void setE_clean_ny(String val){
		if(val==null) val="";
		this.e_clean_ny = val;
	}
	public void setOut_clean_ny(String val){
		if(val==null) val="";
		this.out_clean_ny = val;
	}
	public void setTire_air_ny(String val){
		if(val==null) val="";
		this.tire_air_ny = val;
	}
	public void setTire_mamo_ny(String val){
		if(val==null) val="";
		this.tire_mamo_ny = val;
	}
	public void setLamp_ny(String val){
		if(val==null) val="";
		this.lamp_ny = val;
	}
	public void setIn_clean_ny(String val){
		if(val==null) val="";
		this.in_clean_ny = val;
	}
	public void setWiper_ny(String val){
		if(val==null) val="";
		this.wiper_ny = val;
	}
	public void setPanel_ny(String val){
		if(val==null) val="";
		this.panel_ny = val;
	}
	public void setFront_bp_ny(String val){
		if(val==null) val="";
		this.front_bp_ny = val;
	}
	public void setBack_bp_ny(String val){
		if(val==null) val="";
		this.back_bp_ny = val;
	}
	public void setLh_fhd_ny(String val){
		if(val==null) val="";
		this.lh_fhd_ny = val;
	}
	public void setLh_bhd_ny(String val){
		if(val==null) val="";
		this.lh_bhd_ny = val;
	}
	public void setLh_fdoor_ny(String val){
		if(val==null) val="";
		this.lh_fdoor_ny = val;
	}
	public void setLh_bdoor_ny(String val){
		if(val==null) val="";
		this.lh_bdoor_ny = val;
	}
	public void setRh_fhd_ny(String val){
		if(val==null) val="";
		this.rh_fhd_ny = val;
	}
	public void setRh_bhd_ny(String val){
		if(val==null) val="";
		this.rh_bhd_ny = val;
	}
	public void setRh_fdoor_ny(String val){
		if(val==null) val="";
		this.rh_fdoor_ny = val;
	}
	public void setRh_bdoor_ny(String val){
		if(val==null) val="";
		this.rh_bdoor_ny = val;
	}
	public void setEnergy_ny(String val){
		if(val==null) val="";
		this.energy_ny = val;
	}
	public void setCar_sound_ny(String val){
		if(val==null) val="";
		this.car_sound_ny = val;
	}
	public void setGita(String val){
		if(val==null) val="";
		this.gita = val;
	}

	public void setReg_id(String val){
		if(val==null) val="";
		this.reg_id = val;
	}
	public void setReg_dt(String val){
		if(val==null) val="";
		this.reg_dt = val;
	}
	public void setGubun(String val){
		if(val==null) val="";
		this.gubun = val;
	}
	public void setPark_seq(int val){
		this.park_seq = val;
	}
	public void setArea(String val){
		if(val==null) val="";
		this.area = val;
	}

	public void setCar_key(String val){	if(val==null) val="";		this.car_key	= val;	}
	public void setCar_key_cau(String val){	if(val==null) val="";		this.car_key_cau	= val;	}
	
	//Get Method
	public String getCar_mng_id(){	return car_mng_id;}
	public int	  getServ_seq(){	return serv_seq;		}
	public String getServ_dt(){	return serv_dt;}
	public String getPark_id(){	return park_id;}
	public int	  getCar_km(){	return car_km;}

	public String getE_oil(){	return e_oil;}
	public String getCool_wt(){	return cool_wt;}
	public String getWs_wt(){	return ws_wt;}
	public String getE_clean(){	return e_clean;}
	public String getOut_clean(){	return out_clean;}
	public String getTire_air(){	return tire_air;}
	public String getTire_mamo(){	return tire_mamo;}
	public String getLamp(){	return lamp;}
	public String getIn_clean(){	return in_clean ;}
	public String getWiper(){	return wiper;}
	public String getPanel(){	return panel;}
	public String getFront_bp(){	return front_bp;}
	public String getBack_bp(){	return back_bp;}
	public String getLh_fhd(){	return lh_fhd;}
	public String getLh_bhd(){	return lh_bhd;}
	public String getLh_fdoor(){	return lh_fdoor;}
	public String getLh_bdoor(){	return lh_bdoor;}
	public String getRh_fhd(){	return rh_fhd;}
	public String getRh_bhd(){	return rh_bhd;}
	public String getRh_fdoor(){	return rh_fdoor;}
	public String getRh_bdoor(){	return rh_bdoor;}
	public String getEnergy(){	return energy;}
	public String getCar_sound(){	return car_sound;}
	public String getGoods1(){	return goods1;}
	public String getGoods2(){	return goods2;}
	public String getGoods3(){	return goods3;}
	public String getGoods4(){	return goods4;}
	public String getGoods5(){	return goods5;}
	public String getGoods6(){	return goods6;}
	public String getGoods7(){	return goods7;}
	public String getGoods8(){	return goods8;}
	public String getGoods9(){	return goods9;}
	public String getGoods10(){	return goods10;}
	public String getGoods11(){	return goods11;}
	public String getGoods12(){	return goods12;}
	public String getGoods13(){	return goods13;}
	public String getE_oil_ny(){	return e_oil_ny;}
	public String getCool_wt_ny(){	return cool_wt_ny;}
	public String getWs_wt_ny(){	return ws_wt_ny;}
	public String getE_clean_ny(){	return e_clean_ny;}
	public String getOut_clean_ny(){	return out_clean_ny;}
	public String getTire_air_ny(){	return tire_air_ny;}
	public String getTire_mamo_ny(){	return tire_mamo_ny;}
	public String getLamp_ny(){		return lamp_ny;}
	public String getIn_clean_ny(){	return in_clean_ny;}
	public String getWiper_ny(){	return wiper_ny;}
	public String getPanel_ny(){	return panel_ny;}
	public String getFront_bp_ny(){	return front_bp_ny;}
	public String getBack_bp_ny(){	return back_bp_ny;}
	public String getLh_fhd_ny(){	return lh_fhd_ny;}
	public String getLh_bhd_ny(){	return lh_bhd_ny;}
	public String getLh_fdoor_ny(){	return lh_fdoor_ny;}
	public String getLh_bdoor_ny(){	return lh_bdoor_ny;}
	public String getRh_fhd_ny(){	return rh_fhd_ny;}
	public String getRh_bhd_ny(){	return rh_bhd_ny;}
	public String getRh_fdoor_ny(){	return rh_fdoor_ny;}
	public String getRh_bdoor_ny(){	return rh_bdoor_ny;}
	public String getEnergy_ny(){	return energy_ny;}
	public String getCar_sound_ny(){	return car_sound_ny;}
	public String getGita(){	return gita;}

	public String getReg_id(){	return reg_id;}
	public String getReg_dt(){	return reg_dt;}
	public String getGubun(){	return gubun;}
	public int getPark_seq(){	return park_seq;}
	public String getArea(){	return area;}

	public String 	getCar_key(){		return car_key;	}
	public String 	getCar_key_cau(){	return car_key_cau;	}

}