/**
 * �������� �������� ���� ����
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ cbanate date : 2003. 04. 14. Mon.
 * @ last modify date : 
 */
package acar.offls_actn;

import java.util.*;

public class Offls_auction_banBean {
	//Table : AUCTION_BAN �������
	private String	car_mng_id;		//�ڵ���������ȣ
	private String	actn_cnt;			//����
	private String	ban_nm;			//�������̸�
	private String	ban_tel;		//�����ڿ���ó
	private String	ban_dt;			//��������
	private String	ban_reason;		//�������
	private String	ban_car_st;		//�������������
	private int		js_chul;		//����_��ǰ������
	private int		js_tak;			//����_Ź�۷�
	private int		js_in_amt;		//����_�Աݾ�
	private String	js_dt;			//��������
	private String	tak_up;			//Ź�۾�ü
	private String	tak_nm;			//Ź�����̸�
	private String	tak_tel;		//Ź���ڿ���ó
	private String	insu_id;		//���������μ���
	private String	modify_id;		//����������
	private String	ban_chk;		//�������üũ

	public Offls_auction_banBean(){
		this.car_mng_id = "";
		this.actn_cnt = "";
		this.ban_nm = "";
		this.ban_tel = "";
		this.ban_dt = "";
		this.ban_reason = "";
		this.ban_car_st = "";
		this.js_chul = 0;
		this.js_tak = 0;
		this.js_in_amt = 0;
		this.js_dt = "";
		this.tak_up = "";
		this.tak_nm = "";
		this.tak_tel = "";
		this.insu_id = "";
		this.modify_id = "";
		this.ban_chk = "";
	}

	//set
	public void setCar_mng_id(String val){if(val==null) val="";	this.car_mng_id = val;}
	public void setActn_cnt(String val){ if(val==null) val=""; this.actn_cnt = val; }
	public void setBan_nm(String val){ if(val==null) val=""; this.ban_nm = val; }
	public void setBan_tel(String val){ if(val==null) val=""; this.ban_tel = val; }
	public void setBan_dt(String val){ if(val==null) val=""; this.ban_dt = val; }
	public void setBan_reason(String val){ if(val==null) val=""; this.ban_reason = val; }
	public void setBan_car_st(String val){ if(val==null) val=""; this.ban_car_st = val; }
	public void setJs_chul(int val){ this.js_chul = val; }
	public void setJs_tak(int val){ this.js_tak = val; }
	public void setJs_in_amt(int val){ this.js_in_amt = val; }
	public void setJs_dt(String val){ if(val==null) val=""; this.js_dt = val; }
	public void setTak_up(String val){ if(val==null) val=""; this.tak_up = val; }
	public void setTak_nm(String val){ if(val==null) val=""; this.tak_nm = val; }
	public void setTak_tel(String val){ if(val==null) val=""; this.tak_tel = val; }
	public void setInsu_id(String val){ if(val==null) val=""; this.insu_id = val; }
	public void setModify_id(String val){ if(val==null) val=""; this.modify_id = val; }
	public void setBan_chk(String val){ if(val==null) val=""; this.ban_chk = val; }

	//get
	public String getCar_mng_id(){ return car_mng_id; }
	public String getActn_cnt(){ return actn_cnt; }
	public String getBan_nm(){ return ban_nm; }
	public String getBan_tel(){ return ban_tel; }
	public String getBan_dt(){ return ban_dt; }
	public String getBan_reason(){ return ban_reason; }
	public String getBan_car_st(){ return ban_car_st; }
	public int getJs_chul(){ return js_chul; }
	public int getJs_tak(){ return js_tak; }
	public int getJs_in_amt(){ return js_in_amt; }
	public String getJs_dt(){ return js_dt; }
	public String getTak_up(){ return tak_up; }
	public String getTak_nm(){ return tak_nm; }
	public String getTak_tel(){ return tak_tel; }
	public String getInsu_id(){ return insu_id; }
	public String getModify_id(){ return modify_id; }
	public String getBan_chk(){ return ban_chk; }
}