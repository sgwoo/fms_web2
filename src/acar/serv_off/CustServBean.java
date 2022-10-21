/**
 * 정비업체, 차량연결
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.serv_off;

import java.util.*;

public class CustServBean {
    //Table : CAR_REG
	private String off_id; 
	private int seq_no; 
	private String car_mng_id; 
	private String car_no;
	private String init_reg_dt;
	private String firm_nm;
	private String client_nm;
	private String mgr_nm;
	
	
	
    // CONSTRCTOR            
    public CustServBean() {  
		this.off_id = ""; 
		this.seq_no = 0; 
		this.car_mng_id = ""; 
		this.init_reg_dt = "";
		this.car_no = "";
		this.firm_nm = "";
		this.client_nm = "";
		this.mgr_nm = "";
	}

	// get Method

	public void setOff_id(String val){
		if(val==null) val="";
		this.off_id = val;
	}
	public void setSeq_no(int val){
		this.seq_no = val;
	}
	public void setCar_mng_id(String val){
		if(val==null) val="";
		this.car_mng_id = val;
	}
	public void setInit_reg_dt(String val){
		if(val==null) val="";
		this.init_reg_dt = val;
	}
	public void setCar_no(String val){
		if(val==null) val="";
		this.car_no = val;
	}
	public void setFirm_nm(String val){
		if(val==null) val="";
		this.firm_nm = val;
	}
	public void setClient_nm(String val){
		if(val==null) val="";
		this.client_nm = val;
	}
	public void setMgr_nm(String val){
		if(val==null) val="";
		this.mgr_nm = val;
	}
		
	//Get Method
	public String getOff_id(){
		return off_id;
	}
	public int getSeq_no(){
		return seq_no;
	}
	public String getCar_mng_id(){
		return car_mng_id;
	}
	public String getInit_reg_dt(){
		return init_reg_dt;
	}
	public String getCar_no(){
		return car_no;
	}
	public String getFirm_nm(){
		return firm_nm;
	}
	public String getClient_nm(){
		return client_nm;
	}
	public String getMgr_nm(){
		return mgr_nm;
	}
}