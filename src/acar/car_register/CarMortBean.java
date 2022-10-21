/**
 * 저당권 등록
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.car_register;

import java.util.*;

public class CarMortBean {
    //Table : CAR_CHA
    private String car_mng_id;			//자동차관리번호
	private int seq_no;					//SEQ_NO
	private String mort_st;			//저당권구분
	private String mort_dt;			//일자
	
        
    // CONSTRCTOR            
    public CarMortBean() {  
	    this.car_mng_id = "";			//자동차관리번호
		this.seq_no = 0;					//SEQ_NO
		this.mort_st = "";			//저당권구분
		this.mort_dt = "";			//일자
	}

	// get Method
	public void setCar_mng_id(String val){
		if(val==null) val="";
		this.car_mng_id = val;
	}
	public void setSeq_no(int val){
		this.seq_no = val;
	}
	public void setMort_st(String val){
		if(val==null) val="";
		this.mort_st = val;
	}
	public void setMort_dt(String val){
		if(val==null) val="";
		this.mort_dt = val;
	}
		
	//Get Method
	public String getCar_mng_id(){
		return car_mng_id;
	}
	public int getSeq_no(){
		return seq_no;
	}
	public String getMort_st(){
		return mort_st;
	}
	public String getMort_dt(){
		return mort_dt;
	}
	
}