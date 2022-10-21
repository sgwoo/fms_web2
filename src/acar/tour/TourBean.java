/**
 * 포상입력
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2010. 06. 09
 * @ last modify date : 
 */
package acar.tour;

import java.util.*;

public class TourBean {
    //Table : insa_sb
    private String user_id;				//사용자 아이디
	private int seq;					//글번호
  	private String ps_dt;			//년월일
	private String ps_count;
	private String ps_gubun;			//구분
	private String ps_content;		//내용
	private String ps_str_dt;		//징계시작일
	private String ps_end_dt;		//징계종료일
	private String ps_amt;
	private String jigub;
		
	
    // CONSTRCTOR            
    public TourBean() {  
		this.user_id = "";
    	this.seq =  0;	
		this.ps_dt = "";
		this.ps_count= "";
		this.ps_gubun = "";
		this.ps_content = "";
		this.ps_str_dt = "";
		this.ps_end_dt = "";
		this.ps_amt = "";
		this.jigub = "";
	}

	// set Method
	public void setUser_id(String val){
		if(val==null) val="";
		this.user_id = val;
	}
	public void setSeq(int val){
		this.seq = val;
	}
	public void setPs_dt(String val){
		if(val==null) val="";
		this.ps_dt = val;
	}
	public void setPs_gubun(String val){
		if(val==null) val="";
		this.ps_gubun = val;
	}

	public void setPs_count(String val){
		if(val==null) val="";
		this.ps_count = val;
	}
	public void setPs_content(String val){
		if(val==null) val="";
		this.ps_content = val;
	}
	public void setPs_str_dt(String val){
		if(val==null) val="";
		this.ps_str_dt = val;
	}
	public void setPs_end_dt(String val){
		if(val==null) val="";
		this.ps_end_dt = val;
	}
	public void setPs_amt(String val){
		if(val==null) val="";
		this.ps_amt = val;
	}
	public void setJigub(String val){
		if(val==null) val="";
		this.jigub = val;
	}

				
	//Get Method
	public String 	getUser_id(){			return user_id;	}
	public int	  	getSeq(){				return seq;	}
	public String	getPs_dt(){				return ps_dt;	}
	public String	getPs_gubun(){			return ps_gubun;	}
	public String	getPs_count(){			return ps_count;	}
	public String	getPs_content(){		return ps_content;	}
	public String	getPs_str_dt(){			return ps_str_dt;	}
	public String	getPs_end_dt(){			return ps_end_dt;	}
	public String	getPs_amt(){			return ps_amt;	}
	public String	getJigub(){			return jigub;	}

	
}