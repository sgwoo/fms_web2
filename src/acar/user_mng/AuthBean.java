/*
 * 권한
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.user_mng;

import java.util.*;

public class AuthBean {
    //Table : MENU M_CD 대메뉴 : 00
    private String user_id;					//사용자ID
    private String m_st;					//대메뉴 구분
    private String m_st2;					//중메뉴 구분
    private String m_cd;					//소메뉴 구분
    private String m_nm;					//메뉴명
	private String m_gu;					//메뉴구분2
    private String url;						//메뉴명
    private String auth_rw;					//권한
    private String auth;					//권한등록
        
    // CONSTRCTOR            
    public AuthBean() {  
    	this.user_id = "";					//사용자ID
	    this.m_st = "";					//대메뉴 구분
	    this.m_st2 = "";				//중메뉴 구분
	    this.m_cd = "";					//소메뉴 구분
	    this.m_nm = "";					//메뉴명
		this.m_gu = "";				
	    this.url = "";					//메뉴명
	    this.auth_rw = "";					//권한
	    this.auth = "";					//권한등록
	}

	// get Method
	public void setUser_id(String val){
		if(val==null) val="";
		this.user_id = val;
	}
	public void setM_st(String val){
		if(val==null) val="";
		this.m_st = val;
	}
	public void setM_st2(String val){
		if(val==null) val="";
		this.m_st2 = val;
	}
	public void setM_cd(String val){
		if(val==null) val="";
		this.m_cd = val;
	}
	public void setM_nm(String val){
		if(val==null) val="";
		this.m_nm = val;
	}
	public void setM_gu(String val){
		if(val==null) val="";
		this.m_gu = val;
	}
	public void setUrl(String val){
		if(val==null) val="";
		this.url = val;
	}
	public void setAuth_rw(String val){
		if(val==null) val="";
		this.auth_rw = val;
	}
	public void setAuth(String val){
		if(val==null) val="";
		this.auth = val;
	}
	
		
	//Get Method
	
	public String getUser_id(){
		return user_id;
	}
	public String getM_st(){
		return m_st;
	}
	public String getM_st2(){
		return m_st2;
	}
	public String getM_cd(){
		return m_cd;
	}
	public String getM_nm(){
		return m_nm;
	}
	public String getM_gu(){
		return m_gu;
	}
	public String getUrl(){
		return url;
	}
	public String getAuth_rw(){
		return auth_rw;
	}
	public String getAuth(){
		return auth;
	}
	
	
}