/**
 * 인사카드 - 가족사항테이블
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2008. 11. 25
 * @ last modify date : 
 */
package acar.insa_card;

import java.util.*;

public class Insa_FyBean {
    //Table : insa_fy
    private String user_id;				//사용자 아이디
	private int seq;					//글번호
  	private String fy_gubun;			//관계
	private String fy_name;			//성명
	private String fy_birth;		//생년월일
	private String fy_age;			//나이(연령)
		
	
    // CONSTRCTOR            
    public Insa_FyBean() {  
		this.user_id = "";
    	this.seq =  0;	
		this.fy_gubun = "";
		this.fy_name = "";
		this.fy_birth = "";
		this.fy_age = "";
	}

	// set Method
	public void setUser_id(String val){
		if(val==null) val="";
		this.user_id = val;
	}
	public void setSeq(int val){
		this.seq = val;
	}
	public void setFy_gubun(String val){
		if(val==null) val="";
		this.fy_gubun = val;
	}
	public void setFy_name(String val){
		if(val==null) val="";
		this.fy_name = val;
	}
	public void setFy_birth(String val){
		if(val==null) val="";
		this.fy_birth = val;
	}
	public void setFy_age(String val){
		if(val==null) val="";
		this.fy_age = val;
	}

				
	//Get Method
	public String 	getUser_id(){			return user_id;	}
	public int	  	getSeq(){				return seq;	}
	public String	getFy_gubun(){			return fy_gubun;	}
	public String	getFy_name(){			return fy_name;	}
	public String	getFy_birth(){			return fy_birth;	}
	public String	getFy_age(){			return fy_age;}


	
}