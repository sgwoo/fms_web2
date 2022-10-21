/**
 * 인사카드 - 자격/면허테이블
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2008. 11. 25
 * @ last modify date : 
 */
package acar.insa_card;

import java.util.*;

public class Insa_LsBean {
    //Table : insa_ls
    private String user_id;				//사용자 아이디
	private int seq;					//글번호
  	private String ls_dt;				//취득날짜
	private String ls_name;				//종목명
	private String ls_bmng;				//발행기관
	private String ls_num;				//종목번호
		
	
    // CONSTRCTOR            
    public Insa_LsBean() {  
		this.user_id = "";
    	this.seq =  0;	
		this.ls_dt = "";
		this.ls_name = "";
		this.ls_bmng = "";
		this.ls_num = "";
	}

	// set Method
	public void setUser_id(String val){
		if(val==null) val="";
		this.user_id = val;
	}
	public void setSeq(int val){
		this.seq = val;
	}
	public void setLs_dt(String val){
		if(val==null) val="";
		this.ls_dt = val;
	}
	public void setLs_name(String val){
		if(val==null) val="";
		this.ls_name = val;
	}
	public void setLs_bmng(String val){
		if(val==null) val="";
		this.ls_bmng = val;
	}
	public void setLs_num(String val){
		if(val==null) val="";
		this.ls_num = val;
	}


				
	//Get Method
	public String 	getUser_id(){			return user_id;	}
	public int	  	getSeq(){				return seq;	}
	public String	getLs_dt(){				return ls_dt;	}
	public String	getLs_name(){			return ls_name;	}
	public String	getLs_bmng(){			return ls_bmng;}
	public String	getLs_num(){			return ls_num;}

}