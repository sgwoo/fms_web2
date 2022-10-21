/**
 * 관리담당
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.car_mng;

import java.util.*;

public class CarMngBean {
    //Table : CONT
    private String rent_mng_id;
    private String rent_l_cd;
    private String mng_id;
	private String mng_id2;
    private String mng_nm;
	private String mng_nm2;
	private String note;	
        
    // CONSTRCTOR            
    public CarMngBean() {  
    	this.rent_mng_id = "";
	    this.rent_l_cd = "";
	    this.mng_id = "";
		this.mng_id2 = "";
	    this.mng_nm = "";
		this.mng_nm2 = "";
	    this. note = "";	
	}

	// get Method
	public void setRent_mng_id(String val){
		if(val==null) val="";
		this.rent_mng_id = val;
	}
	public void setRent_l_cd(String val){
		if(val==null) val="";
		this.rent_l_cd = val;
	}
	public void setMng_id(String val){
		if(val==null) val="";
		this.mng_id = val;
	}

	public void setMng_id2(String val){
		if(val==null) val="";
		this.mng_id2 = val;
	}

	public void setMng_nm(String val){
		if(val==null) val="";
		this.mng_nm = val;
	}
	public void setMng_nm2(String val){
		if(val==null) val="";
		this.mng_nm2 = val;
	}
	public void setNote(String val){
		if(val==null) val="";
		this.note = val;
	}
	
	//Get Method
	public String getRent_mng_id(){
		return rent_mng_id;
	}
	public String getRent_l_cd(){
		return rent_l_cd;
	}
	public String getMng_id(){
		return mng_id;
	}

	public String getMng_id2(){
		return mng_id2;
	}

	public String getMng_nm(){
		return mng_nm;
	}
	public String getMng_nm2(){
		return mng_nm2;
	}

	public String getNote(){
		return note;
	}
	
}