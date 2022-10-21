/**
 * Code
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.common;

import java.util.*;

public class NaviBean {
    //Table : CDDE
    private int seqidx;					//serial
    private String serial_no;				//
    private String model;					//
    private String gubun;					//
    private String remark;
    private String reg_dt;                  // 
        
    // CONSTRCTOR            
    public NaviBean() {  
             this.seqidx =0;					
	    this.serial_no = "";					
	    this.model = "";					
	    this.gubun = "";						
	    this.remark = "";
	    this.reg_dt = "";
	}

	// get Method
	public void setSeqidx		(int val) {	
		this.seqidx	= val;
	}
		
	public void setSerial_no(String val){
		if(val==null) val="";
		this.serial_no = val;
	}
	public void setModel(String val){
		if(val==null) val="";
		this.model = val;
	}
	public void setGubun(String val){
		if(val==null) val="";
		this.gubun = val;
	}
	public void setRemark(String val){
		if(val==null) val="";
		this.remark = val;
	}
	public void setReg_dt(String val){
		if(val==null) val="";
		this.reg_dt = val;
	}
	
	//Get Method
	public int getSeqidx(){
		return seqidx;
	}
	public String getSerial_no(){
		return serial_no;
	}
	public String getModel(){
		return model;
	}
	public String getGubun(){
		return gubun;
	}
	public String getRemark(){
		return remark;
	}	
	public String getReg_dt(){
		return reg_dt;
	}	
}