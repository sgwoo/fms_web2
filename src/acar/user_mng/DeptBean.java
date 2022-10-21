/*
 * �μ�
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.user_mng;

import java.util.*;

public class DeptBean {
    //Table : CDDE C_ST  �μ��� : 0002
    private String c_st;					//�ڵ�з�
    private String code;					//�ڵ�(����������)
    private String nm_cd;					//����ڵ��
    private String nm;						//�μ��̸�
    
        
    // CONSTRCTOR            
    public DeptBean() {  
    	this.c_st = "";					//�ڵ�з�
	    this.code = "";					//�ڵ�(����������)
	    this.nm_cd = "";					//����ڵ��
	    this.nm = "";						//�μ��̸�
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