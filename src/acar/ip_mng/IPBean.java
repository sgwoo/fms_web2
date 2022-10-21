/**
 * IP 관리
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.ip_mng;

import java.util.*;

public class IPBean {
    //Table : IP
    private String user_id;
    private String user_nm;
    private String iu;
    private String ip;
    private String id;
    private String ip_auth;
    private String loginout;
    private String login_dt;
    private String logout_dt;
    private String dept_id;					//부서ID
    private String dept_nm;					//부서이름
    private String user_m_tel;				//휴대폰     
    private String user_pos;				//직위   
    // CONSTRCTOR            
    public IPBean() {  
    	this.iu = "";
    	this.id = "";
    	this.user_id = "";
    	this.user_nm = "";
	    this.ip = "";
	    this.ip_auth = "";
	    this.loginout = "";
	    this.login_dt = "";
	    this.logout_dt = "";
	    this.dept_id = "";
	    this.dept_nm = "";
	    this.user_m_tel = "";
	    this.user_pos = "";
	}

	// set Method
	public void setUser_id(String val){
		if(val==null) val="";
		this.user_id = val;
	}
	public void setUser_nm(String val){
		if(val==null) val="";
		this.user_nm = val;
	}
	public void setIu(String val){
		if(val==null) val="";
		this.iu = val;
	}
	public void setId(String val){
		if(val==null) val="";
		this.id = val;
	}
    public void setIp(String val){
		if(val==null) val="";
		this.ip = val;
	}
    public void setIp_auth(String val){
		if(val==null) val="";
		this.ip_auth = val;
	}
    public void setLoginout(String val){
		if(val==null) val="";
		this.loginout = val;
	}
    public void setLogin_dt(String val){
		if(val==null) val="";
		this.login_dt = val;
	}
    public void setLogout_dt(String val){
		if(val==null) val="";
		this.logout_dt = val;
	}
    public void setDept_id(String val){
		if(val==null) val="";
		this.dept_id = val;
	}
    public void setDept_nm(String val){
		if(val==null) val="";
		this.dept_nm = val;
	}
    public void setUser_m_tel(String val){
		if(val==null) val="";
		this.user_m_tel = val;
	}
    public void setUser_pos(String val){
		if(val==null) val="";
		this.user_pos = val;
	}
	
	//Get Method
	public String getUser_id(){
		return user_id;
	}
	public String getUser_nm(){
		return user_nm;
	}
	public String getIu(){
		return iu;
	}
	public String getId(){
		return id;
	}
	public String getIp(){
		return ip;
	}
    public String getIp_auth(){
		return ip_auth;
	}
    public String getLoginout(){
		return loginout;
	}
    public String getLogin_dt(){
		return login_dt;
	}
    public String getLogout_dt(){
		return logout_dt;
	}
    public String getDept_id(){
		return dept_id;
	}
    public String getDept_nm(){
		return dept_nm;
	}
    public String getUser_m_tel(){
		return user_m_tel;
	}
    public String getUser_pos(){
		return user_pos;
	}
	
}