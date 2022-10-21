/**
 * 인사카드 - 인사발령테이블
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2008. 11. 25
 * @ last modify date : 
 */
package acar.insa_card;

import java.util.*;

public class Insa_IbBean {
    //Table : insa_ib
    private String user_id;				//사용자 아이디
	private int seq;					//글번호
  	private String ib_dt;			//년월일
	private String ib_gubun;			//구분
	private String ib_content;		//내용
	private String ib_job;		//직군
	private String ib_type;		//항목  1;직군, 2:부서 
	private String ib_dept;		//부서 
		
	
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