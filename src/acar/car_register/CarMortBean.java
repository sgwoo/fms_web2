/**
 * ����� ���
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.car_register;

import java.util.*;

public class CarMortBean {
    //Table : CAR_CHA
    private String car_mng_id;			//�ڵ���������ȣ
	private int seq_no;					//SEQ_NO
	private String mort_st;			//����Ǳ���
	private String mort_dt;			//����
	
        
    // CONSTRCTOR            
    public CarMortBean() {  
	    this.car_mng_id = "";			//�ڵ���������ȣ
		this.seq_no = 0;					//SEQ_NO
		this.mort_st = "";			//����Ǳ���
		this.mort_dt = "";			//����
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