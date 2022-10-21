/*
 * 근무지
 */
package acar.user_mng;

import java.util.*;

public class AreaBean {
    //Table : CDDE C_ST  근무지값 : 0024
    private String c_st;					//코드분류
    private String code;					//코드(순차적증가)
    private String nm_cd;					//사용코드명
    private String nm;						//부서이름
    
        
    // CONSTRCTOR            
    public AreaBean() {  
    	this.c_st = "";					//코드분류
	    this.code = "";					//코드(순차적증가)
	    this.nm_cd = "";					//사용코드명
	    this.nm = "";						//부서이름
	}

	// get Method
	public void setC_st(String val){
		if(val==null) val="";
		this.c_st = val;
	}
	public void setCode(String val){
		if(val==null) val="";
		this.code = val;
	}
	public void setNm_cd(String val){
		if(val==null) val="";
		this.nm_cd = val;
	}
	public void setNm(String val){
		if(val==null) val="";
		this.nm = val;
	}
		
	//Get Method
	public String getC_st(){
		return c_st;
	}
	public String getCode(){
		return code;
	}
	public String getNm_cd(){
		return nm_cd;
	}
	public String getNm(){
		return nm;
	}
	
}