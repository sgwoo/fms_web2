/**
 * �λ�ī�� - �ſ��������̺�
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2008. 11. 25
 * @ last modify date : 
 */
package acar.insa_card;

import java.util.*;

public class Insa_SwBean {
    //Table : insa_sw
    private String user_id;				//����� ���̵�
	private int seq;					//�۹�ȣ
  	private String sw_gubun;			//����(1-�κ���, 2-��������)
	private String sw_name;				//����
	private String sw_ssn;				//�ֹε�Ϲ�ȣ
	private String sw_addr;				//�ּ�
	private String sw_tel;				//����ó
	private String sw_my_gubun;			//���ΰ��� ����
	private String sw_st_dt;			//������
	private String sw_ed_dt;			//������
	private String sw_up_dt;			//���ſ�����
	private String sw_insu_nm;			//������
	private String sw_insu_money;		//����ݾ�
	private String sw_insu_no;			//�������ǹ�ȣ
	private String sw_file;				//�κ��� ��ĵ ����
	private String sw_jesan;			//��� = ��/��
		
	
    // CONSTRCTOR            
    public Insa_SwBean() {  
		this.user_id = "";
    	this.seq =  0;	
		this.sw_gubun = "";
		this.sw_name = "";
		this.sw_ssn = "";
		this.sw_addr = "";
		this.sw_tel = "";
		this.sw_my_gubun = "";
		this.sw_st_dt = "";
		this.sw_ed_dt = "";
		this.sw_up_dt = "";
		this.sw_insu_nm = "";
		this.sw_insu_money = "";
		this.sw_insu_no = "";
		this.sw_file = "";
		this.sw_jesan = "";

	}

	// set Method
	public void setUser_id(String val){
		if(val==null) val="";
		this.user_id = val;
	}
	public void setSeq(int val){
		this.seq = val;
	}
	public void setSw_gubun(String val){
		if(val==null) val="";
		this.sw_gubun = val;
	}
	public void setSw_name(String val){
		if(val==null) val="";
		this.sw_name = val;
	}
	public void setSw_ssn(String val){
		if(val==null) val="";
		this.sw_ssn = val;
	}
	public void setSw_addr(String val){
		if(val==null) val="";
		this.sw_addr = val;
	}
	public void setSw_tel(String val){
		if(val==null) val="";
		this.sw_tel = val;
	}
	public void setSw_my_gubun(String val){
		if(val==null) val="";
		this.sw_my_gubun = val;
	}
	public void setSw_st_dt(String val){
		if(val==null) val="";
		this.sw_st_dt = val;
	}
	public void setSw_ed_dt(String val){
		if(val==null) val="";
		this.sw_ed_dt = val;
	}
	public void setSw_up_dt(String val){
		if(val==null) val="";
		this.sw_up_dt = val;
	}
	public void setSw_insu_nm(String val){
		if(val==null) val="";
		this.sw_insu_nm = val;
	}
	public void setSw_insu_money(String val){
		if(val==null) val="";
		this.sw_insu_money = val;
	}
	public void setSw_insu_no(String val){
		if(val==null) val="";
		this.sw_insu_no = val;
	}
	public void setSw_file(String val){
		if(val==null) val="";
		this.sw_file = val;
	}
	public void setSw_jesan(String val){
		if(val==null) val="";
		this.sw_jesan = val;
	}
				
	//Get Method
	public String 	getUser_id(){			return user_id;	}
	public int	  	getSeq(){				return seq;	}
	public String	getSw_gubun(){			return sw_gubun;	}
	public String	getSw_name(){			return sw_name;	}
	public String	getSw_ssn(){			return sw_ssn;	}
	public String	getSw_addr(){			return sw_addr;}
	public String	getSw_tel(){			return sw_tel;}
	public String	getSw_my_gubun(){		return sw_my_gubun;}
	public String	getSw_st_dt(){			return sw_st_dt;}
	public String	getSw_ed_dt(){			return sw_ed_dt;}
	public String	getSw_up_dt(){			return sw_up_dt;}
	public String	getSw_insu_nm(){		return sw_insu_nm;}
	public String	getSw_insu_money(){		return sw_insu_money;}
	public String	getSw_insu_no(){		return sw_insu_no;}
	public String	getSw_file(){			return sw_file;}
	public String	getSw_jesan(){			return sw_jesan;}
	
}