/**
 * 인사카드 - 학력테이블
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2008. 11. 25
 * @ last modify date : 
 */
package acar.insa_card;

import java.util.*;

public class Insa_ScBean {
    //Table : insa_school
    private String user_id;				//사용자 아이디
	private int seq;					//글번호
  	private String sc_gubun;			//학교구분(1-고등학교, 2-대학교, 3-대학원, 4-기타)
	private String sc_ed_dt;			//졸업년월일
	private String sc_name;				//학교명
	private String sc_study;			//전공명
	private String sc_st;				//상태(1-입학, 2-졸업, 3-편입, 4-졸예, 5-수료, 6-재학, 7-휴학)
	
		
	
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