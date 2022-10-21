/**
 * 서비스
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.car_service;

import java.util.*;

public class ServItemBean {
    //Table : CAR_REG
	private String car_mng_id; 					//자동차관리번호
	private String serv_id;
	private int seq_no; 
	private String item; 
	private String std; 
	private String unit; 
	private int count; 
	private int price; 
	private int sup_amt; 
	private int tax; 
		
        
    // CONSTRCTOR            
    public ServItemBean() {  
		this.car_mng_id = ""; 					//자동차관리번호
		this.serv_id = "";
		this.seq_no = 0; 
		this.item = ""; 
		this.std = ""; 
		this.unit = ""; 
		this.count = 0; 
		this.price = 0; 
		this.sup_amt = 0; 
		this.tax = 0; 
	}

	// get Method
	public void setCar_mng_id(String val){
		if(val==null) val="";
		this.car_mng_id = val;
	}
	public void setServ_id(String val){
		if(val==null) val="";
		this.serv_id = val;
	}
	public void setSeq_no(int val){
		this.seq_no = val;
	} 
	public void setItem(String val){
		if(val==null) val="";
		this.item = val;
	} 
	public void setStd(String val){
		if(val==null) val="";
		this.std = val;
	} 
	public void setUnit(String val){
		if(val==null) val="";
		this.unit = val;
	} 
	public void setCount(int val){
		this.count = val;
	} 
	public void setPrice(int val){
		this.price = val;
	}
	public void setSup_amt(int val){
		this.sup_amt = val;
	}
	public void setTax(int val){
		this.tax = val;
	}
	
		
	//Get Method
	public String getCar_mng_id(){
		return car_mng_id;
	}
	public String getServ_id(){
		return serv_id;
	}
	public int getSeq_no(){
		return seq_no;
	} 
	public String getItem(){
		return item;
	} 
	public String getStd(){
		return std;
	} 
	public String getUnit(){
		return unit;
	} 
	public int getCount(){
		return count;
	} 
	public int getPrice(){
		return price;
	}
	public int getSup_amt(){
		return sup_amt;
	}
	public int getTax(){
		return tax;
	}
}