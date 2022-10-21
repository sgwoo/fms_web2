/**
 * 인사카드 - 전직경력사항테이블
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2008. 11. 25
 * @ last modify date : 
 */
package acar.insa_card;

import java.util.*;

public class Insa_WkBean {
    //Table : insa_wk
    private String user_id;				//사용자 아이디
	private int seq;					//글번호
  	private String wk_st_dt;			//업무기간(시작날짜)
	private String wk_ed_dt;			//업무기간(끝날짜)
	private String wk_name;				//근무처
	private String wk_pos;				//직위
	private String wk_work;				//담당업무
	private String wk_emp;				//고용형태(1-상용직, 2-계약직, 3-임시직)
	private String wk_title;				//상호/단체명
	
    // CONSTRCTOR            
    public Insa_WkBean() {  
		this.user_id = "";
    	this.seq =  0;	
		this.wk_st_dt = "";
		this.wk_ed_dt = "";
		this.wk_name = "";
		this.wk_pos = "";
		this.wk_work = "";
		this.wk_emp = "";
		this.wk_title = "";

	}

	// set Method
	public void setUser_id(String val){
		if(val==null) val="";
		this.user_id = val;
	}
	public void setSeq(int val){
		this.seq = val;
	}
	public void setWk_st_dt(String val){
		if(val==null) val="";
		this.wk_st_dt = val;
	}
	public void setWk_ed_dt(String val){
		if(val==null) val="";
		this.wk_ed_dt = val;
	}
	public void setWk_name(String val){
		if(val==null) val="";
		this.wk_name = val;
	}
	public void setWk_pos(String val){
		if(val==null) val="";
		this.wk_pos = val;
	}
	public void setWk_work(String val){
		if(val==null) val="";
		this.wk_work = val;
	}
	public void setWk_emp(String val){
		if(val==null) val="";
		this.wk_emp = val;
	}
	public void setWk_title(String val){
		if(val==null)val = "";
		this.wk_title = val;
	}

				
	//Get Method
	public String 	getUser_id(){			return user_id;	}
	public int	  	getSeq(){				return seq;	}
	public String	getWk_st_dt(){			return wk_st_dt;	}
	public String	getWk_ed_dt(){			return wk_ed_dt;	}
	public String	getWk_name(){			return wk_name;	}
	public String	getWk_pos(){			return wk_pos;}
	public String	getWk_work(){			return wk_work;}
	public String	getWk_emp(){			return wk_emp;}
	public String	getWk_title(){			return wk_title;}
}