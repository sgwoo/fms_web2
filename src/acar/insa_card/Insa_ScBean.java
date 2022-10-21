/**
 * �λ�ī�� - �з����̺�
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2008. 11. 25
 * @ last modify date : 
 */
package acar.insa_card;

import java.util.*;

public class Insa_ScBean {
    //Table : insa_school
    private String user_id;				//����� ���̵�
	private int seq;					//�۹�ȣ
  	private String sc_gubun;			//�б�����(1-����б�, 2-���б�, 3-���п�, 4-��Ÿ)
	private String sc_ed_dt;			//���������
	private String sc_name;				//�б���
	private String sc_study;			//������
	private String sc_st;				//����(1-����, 2-����, 3-����, 4-����, 5-����, 6-����, 7-����)
	
		
	
    // CONSTRCTOR            
    public Insa_ScBean() {  
		this.user_id = "";
    	this.seq =  0;	
		this.sc_gubun = "";
		this.sc_ed_dt = "";
		this.sc_name = "";
		this.sc_study = "";
		this.sc_st = "";
	}

	// set Method
	public void setUser_id(String val){
		if(val==null) val="";
		this.user_id = val;
	}
	public void setSeq(int val){
		this.seq = val;
	}
	public void setSc_gubun(String val){
		if(val==null) val="";
		this.sc_gubun = val;
	}
	public void setSc_ed_dt(String val){
		if(val==null) val="";
		this.sc_ed_dt = val;
	}
	public void setSc_name(String val){
		if(val==null) val="";
		this.sc_name = val;
	}
	public void setSc_study(String val){
		if(val==null) val="";
		this.sc_study = val;
	}
	public void setSc_st(String val){
		if(val==null) val="";
		this.sc_st = val;
	}
				
	//Get Method
	public String 	getUser_id(){		return user_id;	}
	public int	  	getSeq(){			return seq;	}
	public String	getSc_gubun(){		return sc_gubun;	}
	public String	getSc_ed_dt(){		return sc_ed_dt;	}
	public String	getSc_name(){		return sc_name;	}
	public String	getSc_study(){		return sc_study;	}
	public String	getSc_st(){			return sc_st;	}


	
}