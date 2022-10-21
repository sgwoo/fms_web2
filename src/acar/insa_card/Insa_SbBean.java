/**
 * 인사카드 - 상벌사항테이블
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2008. 11. 25
 * @ last modify date : 
 */
package acar.insa_card;

import java.util.*;

public class Insa_SbBean {
    //Table : insa_sb
    private String user_id;				//사용자 아이디
	private int seq;					//글번호
  	private String sb_dt;			//년월일
	private String sb_gubun;			//구분
	private String sb_content;		//내용
	private String sb_js_dt;		//징계시작일
	private String sb_je_dt;		//징계종료일

		
	
    // CONSTRCTOR            
    public Insa_SbBean() {  
		this.user_id = "";
    	this.seq =  0;	
		this.sb_dt = "";
		this.sb_gubun = "";
		this.sb_content = "";
		this.sb_js_dt = "";
		this.sb_je_dt = "";
	}

	// set Method
	public void setUser_id(String val){
		if(val==null) val="";
		this.user_id = val;
	}
	public void setSeq(int val){
		this.seq = val;
	}
	public void setSb_dt(String val){
		if(val==null) val="";
		this.sb_dt = val;
	}
	public void setSb_gubun(String val){
		if(val==null) val="";
		this.sb_gubun = val;
	}
	public void setSb_content(String val){
		if(val==null) val="";
		this.sb_content = val;
	}
	public void setSb_js_dt(String val){
		if(val==null) val="";
		this.sb_js_dt = val;
	}
	public void setSb_je_dt(String val){
		if(val==null) val="";
		this.sb_je_dt = val;
	}

				
	//Get Method
	public String 	getUser_id(){			return user_id;	}
	public int	  	getSeq(){				return seq;	}
	public String	getSb_dt(){				return sb_dt;	}
	public String	getSb_gubun(){			return sb_gubun;	}
	public String	getSb_content(){		return sb_content;	}
	public String	getSb_js_dt(){		return sb_js_dt;	}
	public String	getSb_je_dt(){		return sb_je_dt;	}


	
}