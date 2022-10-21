/*
 * ����
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.user_mng;

import java.util.*;

public class AuthBean {
    //Table : MENU M_CD ��޴� : 00
    private String user_id;					//�����ID
    private String m_st;					//��޴� ����
    private String m_st2;					//�߸޴� ����
    private String m_cd;					//�Ҹ޴� ����
    private String m_nm;					//�޴���
	private String m_gu;					//�޴�����2
    private String url;						//�޴���
    private String auth_rw;					//����
    private String auth;					//���ѵ��
        
    // CONSTRCTOR            
    public AuthBean() {  
    	this.user_id = "";					//�����ID
	    this.m_st = "";					//��޴� ����
	    this.m_st2 = "";				//�߸޴� ����
	    this.m_cd = "";					//�Ҹ޴� ����
	    this.m_nm = "";					//�޴���
		this.m_gu = "";				
	    this.url = "";					//�޴���
	    this.auth_rw = "";					//����
	    this.auth = "";					//���ѵ��
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