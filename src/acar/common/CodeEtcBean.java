/**
 * Code
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.common;

import java.util.*;

public class CodeEtcBean {
    //Table : CDDE_ETC
    private String c_st;					//코드분류
    private String code;					//코드(순차적증가)  
    private String nm;						//명칭
    private String zip;
    private String addr;                  // cms용 은행코드
    private String gubun;   
    private String ven_code;
        
    // CONSTRCTOR            
    public CodeEtcBean() {  
    	    this.c_st = "";					//코드분류
	    this.code = "";					//코드(순차적증가)	   
	    this.nm = "";						//명칭
	    this.zip = "";
	    this.addr = "";
	    this.gubun = "";
	    this.ven_code = "";
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

	public void setNm(String val){
		if(val==null) val="";
		this.nm = val;
	}
	public void setZip(String val){
		if(val==null) val="";
		this.zip = val;
	}
	public void setAddr(String val){
		if(val==null) val="";
		this.addr = val;
	}	
	public void setGubun(String val){
		if(val==null) val="";
		this.gubun = val;
	}
	public void setVen_code(String val){
		if(val==null) val="";
		this.ven_code = val;
	}
	
	//Get Method
	public String getC_st(){
		return c_st;
	}
	public String getCode(){
		return code;
	}

	public String getNm(){
		return nm;
	}
	public String getZip(){
		return zip;
	}	
	public String getAddr(){
		return addr;
	}	
	public String getGubun(){
		return gubun;
	}	
	public String getVen_code(){
		return ven_code;
	}	
}