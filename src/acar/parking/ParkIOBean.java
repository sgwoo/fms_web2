/**
 * �������� - �����԰�
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2008. 9. 2
 * @ last modify date : 
 */
package acar.parking;

import java.util.*;

public class ParkIOBean {
    //Table : park_IO
    private String car_mng_id;		//����������ȣ/�����ȣ
	private int park_seq;
  	private String park_id;		//������ġ
	private String reg_id;			//�����
	private String io_gubun;		//����� ���� (1. �԰�, 2. ���)
	private String car_st;		// ���� ����(1. �԰���, 2. �԰�Ϸ�, 3. ��Ÿ)
	private String car_no;		//������ȣ
	private String car_nm;		//����      
	private int car_km;		//������Ÿ�      
	private String io_dt;		//������Ͻ�    
	private String io_sau;		//��������  (1. �ܱ�뿩, 2. �������, 3. ��������, 4. �������, 5. ������, 6. �����뿩, 7. �����, 8. ����, 9. ��������, 10. ������)
	
	private String users_comp;		//�����(��)
	private String start_place;		//������ 
	private String end_place;		//������� 
	private String driver_nm;		//Ź�۱�� 
		
	private String br_id;		    //����
	private String park_mng;		//����� 
	private String car_gita;		//��������(1. ��������, 2. ������) 
	private String use_yn;	
	private String mng_id;	 //�����
	
	private String total_cnt;	 //��Ȳ��
	private String total_pay;	 //�ջ�ݾ�
	
	private String rent_l_cd;

	private String car_key_cau;		// ��Ű, ����Ÿ� ����


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