/**
 * ������ȭ�����
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2010. 11. 22
 * @ last modify date : 
 */
package acar.biz_tel_mng;

import java.util.*;

public class Biztel_Bean {
    //Table : Biztel_Bean
    private String tel_mng_id;			//��ü ���̵�
	private String reg_id;				//����ѻ��
	private String reg_dt;				//�����
	private String tel_gubun;			//��㱸��
	private String tel_time;			//���ð�
	private String tel_car;				//�������
	private String tel_car_gubun;		//��������
	private String tel_car_st;			//�뵵����
	private String tel_car_mng;			//��������
	private String tel_firm_nm;			//��ü��
	private String tel_firm_mng;		//�����
	private String tel_firm_tel;		//��ȭ��ȣ
	private String tel_est_yn;			//��డ�ɼ�
	private String tel_yp_gubun;		//��������
	private String tel_yp_nm;			//��������̸�
	private String tel_note;			//����� �� �޸�
	private String tel_esty_yn;			//��࿩��
	private String tel_esty_dt;			//��࿩�� �Է���

    // CONSTRCTOR            
public Biztel_Bean() {  
	this.tel_mng_id = "";
  	this.reg_id = "";
	this.reg_dt = "";
	this.tel_gubun = "";
	this.tel_time = "";
	this.tel_car = "";
	this.tel_car_gubun = "";
	this.tel_car_st = "";
	this.tel_car_mng = "";
	this.tel_firm_nm = "";
	this.tel_firm_mng = "";
	this.tel_firm_tel = "";
	this.tel_est_yn = "";
	this.tel_yp_gubun = "";
	this.tel_yp_nm = "";
	this.tel_note = "";
	this.tel_esty_yn = "";
	this.tel_esty_dt = "";
	}

	// set Method
	public void setTel_mng_id(String val){		if(val==null) val="";		this.tel_mng_id = val;	}	
	public void setReg_id(String val){			if(val==null) val="";		this.reg_id = val;	}	
	public void setReg_dt(String val){			if(val==null) val="";		this.reg_dt = val;	}	
	public void setTel_gubun(String val){		if(val==null) val="";		this.tel_gubun = val;	}	
	public void setTel_time(String val){		if(val==null) val="";		this.tel_time = val;	}	
	public void setTel_car(String val){			if(val==null) val="";		this.tel_car = val;	}	
	public void setTel_car_gubun(String val){	if(val==null) val="";		this.tel_car_gubun = val;	}	
	public void setTel_car_st(String val){		if(val==null) val="";		this.tel_car_st = val;	}	
	public void setTel_car_mng(String val){		if(val==null) val="";		this.tel_car_mng = val;	}	
	public void setTel_firm_nm(String val){		if(val==null) val="";		this.tel_firm_nm = val;	}	
	public void setTel_firm_mng(String val){	if(val==null) val="";		this.tel_firm_mng = val;	}	
	public void setTel_firm_tel(String val){	if(val==null) val="";		this.tel_firm_tel = val;	}	
	public void setTel_est_yn(String val){		if(val==null) val="";		this.tel_est_yn = val;	}	
	public void setTel_yp_gubun(String val){	if(val==null) val="";		this.tel_yp_gubun = val;	}	
	public void setTel_yp_nm(String val){		if(val==null) val="";		this.tel_yp_nm = val;	}	
	public void setTel_note(String val){		if(val==null) val="";		this.tel_note = val;	}	
	public void setTel_esty_yn(String val){		if(val==null) val="";		this.tel_esty_yn = val;	}	
	public void setTel_esty_dt(String val){		if(val==null) val="";		this.tel_esty_dt = val;	}	


				
	//Get Method
	public String 	getTel_mng_id(){			return tel_mng_id;	}
	public String	getReg_id(){				return reg_id;	}
	public String	getReg_dt(){				return reg_dt;	}
	public String	getTel_gubun(){				return tel_gubun;	}
	public String	getTel_time(){				return tel_time;}
	public String	getTel_car(){				return tel_car;}
	public String	getTel_car_gubun(){			return tel_car_gubun;}
	public String	getTel_car_st(){			return tel_car_st;}
	public String	getTel_car_mng(){			return tel_car_mng;}
	public String	getTel_firm_nm(){			return tel_firm_nm;}
	public String	getTel_firm_mng(){			return tel_firm_mng;}
	public String	getTel_firm_tel(){			return tel_firm_tel;}
	public String	getTel_est_yn(){			return tel_est_yn;}
	public String	getTel_yp_gubun(){			return tel_yp_gubun;}
	public String	getTel_yp_nm(){				return tel_yp_nm;}
	public String	getTel_note(){				return tel_note;	}
	public String	getTel_esty_yn(){			return tel_esty_yn;	}
	public String	getTel_esty_dt(){			return tel_esty_dt;	}

}