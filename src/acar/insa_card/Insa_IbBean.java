/**
 * �λ�ī�� - �λ�߷����̺�
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2008. 11. 25
 * @ last modify date : 
 */
package acar.insa_card;

import java.util.*;

public class Insa_IbBean {
    //Table : insa_ib
    private String user_id;				//����� ���̵�
	private int seq;					//�۹�ȣ
  	private String ib_dt;			//�����
	private String ib_gubun;			//����
	private String ib_content;		//����
	private String ib_job;		//����
	private String ib_type;		//�׸�  1;����, 2:�μ� 
	private String ib_dept;		//�μ� 
		
	
    // CONSTRCTOR            
    public Insa_IbBean() {  
		this.user_id = "";
    	this.seq =  0;	
		this.ib_dt = "";
		this.ib_gubun = "";
		this.ib_content = "";
		this.ib_job = "";
		this.ib_type = "";
		this.ib_dept = "";
	}

	// set Method
	public void setUser_id(String val){
		if(val==null) val="";
		this.user_id = val;
	}
	public void setSeq(int val){
		this.seq = val;
	}
	public void setIb_dt(String val){
		if(val==null) val="";
		this.ib_dt = val;
	}
	public void setIb_gubun(String val){
		if(val==null) val="";
		this.ib_gubun = val;
	}
	public void setIb_content(String val){
		if(val==null) val="";
		this.ib_content = val;
	}
	public void setIb_job(String val){
		if(val==null) val="";
		this.ib_job = val;
	}
	public void setIb_type(String val){
		if(val==null) val="";
		this.ib_type = val;
	}
	public void setIb_dept(String val){
		if(val==null) val="";
		this.ib_dept = val;
	}
				
	//Get Method
	public String 	getUser_id(){			return user_id;	}
	public int	  	getSeq(){				return seq;	}
	public String	getIb_dt(){				return ib_dt;	}
	public String	getIb_gubun(){			return ib_gubun;	}
	public String	getIb_content(){		return ib_content;	}
	public String	getIb_job(){		return ib_job;	}
	public String	getIb_type(){		return ib_type;	}
	public String	getIb_dept(){		return ib_dept;	}


	
}