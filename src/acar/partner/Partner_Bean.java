/**
 * �λ�ī�� - ���¾�ü ��� ���̺� Partner_office
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2009. 1. 9
 * @ last modify date : 
 */
package acar.partner;

import java.util.*;

public class Partner_Bean {
    //Table : Partner_Bean
    private String po_id;				//��ü ���̵�
  	private String br_id;				//�������
	private String reg_dt;				//�����
	private String user_id;				//����ѻ��
	private String upd_dt;				//������
	private String upd_id;				//�����ѻ��
	private String po_gubun;			//����(1-�ڵ���ȸ��, 2-�����ü, 3-Ź�۾�ü, 4-��Ÿ)
	private String po_nm;				//��ȣ/��ü��
	private String po_own;				//��ǥ
	private String po_no;				//����ڹ�ȣ
	private String po_sta;				//����
	private String po_item;				//����
	private String po_o_tel;			//��ȭ��ȣ
	private String po_m_tel;			//�ڵ�����ȣ
	private String po_fax;				//�ѽ�
	private String po_post;				//�����ȣ
	private String po_addr;				//�ּ�
	private String po_web;				//Ȩ������ �ּ�
	private String po_note;				//��Ÿ Ư�̻���
	private String po_agnt_nm;			//�����
	private String po_agnt_m_tel;		//�����
	private String po_agnt_o_tel;		//�����
	private String po_login_id;			//id
	private String po_login_ps;			//pass
	private String po_email;			//������̸����ּ�

    // CONSTRCTOR            
public Partner_Bean() {  
	this.po_id = "";				//��ü ���̵�
  	this.br_id = "";				//�������
	this.reg_dt = "";				//�����
	this.user_id = "";				//����ѻ��
	this.upd_dt = "";				//������
	this.upd_id = "";				//�����ѻ��
	this.po_gubun = "";				//����(1-�ڵ���ȸ��, 2-�����ü, 3-Ź�۾�ü, 4-��Ÿ)
	this.po_nm = "";				//��ȣ/��ü��
	this.po_own = "";				//��ǥ
	this.po_no = "";				//����ڹ�ȣ
	this.po_sta = "";				//����
	this.po_item = "";				//����
	this.po_o_tel = "";				//��ȭ��ȣ
	this.po_m_tel = "";				//�ڵ�����ȣ
	this.po_fax = "";				//�ѽ�
	this.po_post = "";				//�����ȣ
	this.po_addr = "";				//�ּ�
	this.po_web = "";				//Ȩ������ �ּ�
	this.po_note = "";				//��Ÿ Ư�̻���
	this.po_agnt_nm = "";			
	this.po_agnt_m_tel = "";			
	this.po_agnt_o_tel = "";		
	this.po_login_id = "";			//id
	this.po_login_ps = "";			//pass
	this.po_email = "";				//������̸����ּ�
	}

	// set Method
	public void setPo_id(String val){		if(val==null) val="";		this.po_id = val;	}	
	public void setBr_id(String val){		if(val==null) val="";		this.br_id = val;	}
	public void setReg_dt(String val){		if(val==null) val="";		this.reg_dt = val;	}
	public void setUser_id(String val){		if(val==null) val="";		this.user_id = val;	}
	public void setUpd_dt(String val){		if(val==null) val="";		this.upd_dt = val;	}
	public void setUpd_id(String val){		if(val==null) val="";		this.upd_id = val;	}
	public void setPo_gubun(String val){	if(val==null) val="";		this.po_gubun = val;}
	public void setPo_nm(String val){		if(val==null)val = "";		this.po_nm = val;	}
	public void setPo_own(String val){		if(val==null)val = "";		this.po_own = val;	}
	public void setPo_no(String val){		if(val==null)val = "";		this.po_no = val;	}
	public void setPo_sta(String val){		if(val==null)val = "";		this.po_sta = val;	}
	public void setPo_item(String val){		if(val==null)val = "";		this.po_item = val;	}
	public void setPo_o_tel(String val){	if(val==null)val = "";		this.po_o_tel = val;}
	public void setPo_m_tel(String val){	if(val==null)val = "";		this.po_m_tel = val;}
	public void setPo_fax(String val){		if(val==null)val = "";		this.po_fax = val;	}
	public void setPo_post(String val){		if(val==null)val = "";		this.po_post = val;	}
	public void setPo_addr(String val){		if(val==null)val = "";		this.po_addr = val;	}
	public void setPo_web(String val){		if(val==null)val = "";		this.po_web = val;	}
	public void setPo_note(String val){		if(val==null)val = "";		this.po_note = val;	}
	public void setPo_agnt_nm	(String val){	if(val==null)val = "";		this.po_agnt_nm = val;	}
	public void setPo_agnt_m_tel(String val){	if(val==null)val = "";		this.po_agnt_m_tel = val;	}
	public void setPo_agnt_o_tel(String val){	if(val==null)val = "";		this.po_agnt_o_tel = val;	}
	public void setPo_login_id(String val){		if(val==null)val = "";		this.po_login_id = val;	}
	public void setPo_login_ps(String val){		if(val==null)val = "";		this.po_login_ps = val;	}
	public void setPo_email(String val){		if(val==null)val = "";		this.po_email = val;	}
				
	//Get Method
	public String 	getPo_id(){			return po_id;	}
	public String	getBr_id(){			return br_id;	}
	public String	getReg_dt(){		return reg_dt;	}
	public String	getUser_id(){		return user_id;	}
	public String	getUpd_dt(){		return upd_dt;}
	public String	getUpd_id(){		return upd_id;}
	public String	getPo_gubun(){		return po_gubun;}
	public String	getPo_nm(){			return po_nm;}
	public String	getPo_own(){		return po_own;}
	public String	getPo_no(){			return po_no;}
	public String	getPo_sta(){		return po_sta;}
	public String	getPo_item(){		return po_item;}
	public String	getPo_o_tel(){		return po_o_tel;}
	public String	getPo_m_tel(){		return po_m_tel;}
	public String	getPo_fax(){		return po_fax;}
	public String	getPo_post(){		return po_post;	}
	public String	getPo_addr(){		return po_addr;	}
	public String	getPo_web(){		return po_web;	}
	public String	getPo_note(){		return po_note;	}
	public String	getPo_agnt_nm	(){		return po_agnt_nm;	}
	public String	getPo_agnt_m_tel(){		return po_agnt_m_tel;	}
	public String	getPo_agnt_o_tel(){		return po_agnt_o_tel;	}
	public String	getPo_login_id(){		return po_login_id;	}
	public String	getPo_login_ps(){		return po_login_ps;	}
	public String	getPo_email(){			return po_email;	}


}