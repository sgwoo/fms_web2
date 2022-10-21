/**
 * �λ�ī�� - ����������̺�
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2008. 11. 25
 * @ last modify date : 
 */
package acar.insa_card;

import java.util.*;

public class Insa_JGBean {
    //Table : insa_sb
    private String user_id;				//����� ���̵�
	private int seq;					//�۹�ȣ
  	private String jg_dt;			//��������
	private String br_dt;			//�߷�����
	private String pos;		//����
	private String note;
		
	
    // CONSTRCTOR            
    public Insa_JGBean() {  
		this.user_id = "";
    	this.seq =  0;	
		this.jg_dt = "";
		this.br_dt = "";
		this.pos = "";
		this.note = "";
	}

	// set Method
	public void setUser_id(String val){
		if(val==null) val="";
		this.user_id = val;
	}
	public void setSeq(int val){
		this.seq = val;
	}
	public void setJg_dt(String val){
		if(val==null) val="";
		this.jg_dt = val;
	}
	public void setBr_dt(String val){
		if(val==null) val="";
		this.br_dt = val;
	}
	public void setPos(String val){
		if(val==null) val="";
		this.pos = val;
	}
	public void setNote(String val){
		if(val==null) val="";
		this.note = val;
	}

				
	//Get Method
	public String 	getUser_id(){			return user_id;	}
	public int	  	getSeq(){				return seq;	}
	public String	getJg_dt(){				return jg_dt;	}
	public String	getBr_dt(){				return br_dt;	}
	public String	getPos(){				return pos;	}
	public String	getNote(){				return note;	}


	
}