/**
 * IP °ü¸®
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.ip_mng;

import java.util.*;

public class IPLogBean {
    //Table : IP
    private String ip;
    private String id;
    private String user_id;
    private String user_nm;
    private String login_dt;
    private String logout_dt;
     
    // CONSTRCTOR            
    public IPLogBean() {  
    	this.user_id = "";
    	this.user_nm = "";
	    this.ip = "";
	    this.id = "";
	    this.login_dt = "";
	    this.logout_dt = "";
	    
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
	public void setId(String val){
		if(val==null) val="";
		this.id = val;
	}
    public void setIp(String val){
		if(val==null) val="";
		this.ip = val;
	}
    
    public void setLogin_dt(String val){
		if(val==null) val="";
		this.login_dt = val;
	}
    public void setLogout_dt(String val){
		if(val==null) val="";
		this.logout_dt = val;
	}
    
	
	//Get Method
	public String getUser_id(){
		return user_id;
	}
	public String getUser_nm(){
		return user_nm;
	}
	public String getId(){
		return id;
	}
	public String getIp(){
		return ip;
	}
    
    public String getLogin_dt(){
		return login_dt;
	}
    public String getLogout_dt(){
		return logout_dt;
	}
    
	
}