/**
 * 서비스
 * @ author : 
 * @ e-mail : 
 * @ create date : 2003. 10. 8.
 * @ last modify date : 
 */
package acar.car_service;

import java.util.*;

public class ServItem2Bean {
    //Table : 
	private String car_mng_id; 					//자동차관리번호
	private String serv_id;
	private int seq_no; 
	private String item;
	private String bpm;			//추가 2004.01.08. 부품공급처
	private int count; 
	private int price; 
	private int amt; 
	private int labor; 
       
    // CONSTRCTOR            
    public ServItem2Bean() {  
		this.car_mng_id = ""; 					//자동차관리번호
		this.serv_id = "";
		this.seq_no = 0; 
		this.item = "";
		this.bpm = "";
		this.count = 0; 
		this.price = 0; 
		this.amt = 0; 
		this.labor = 0; 
	}

	// get Method
	public void setCar_mng_id(String val){ if(val==null) val=""; this.car_mng_id = val;	}
	public void setServ_id(String val){ if(val==null) val=""; this.serv_id = val; }
	public void setSeq_no(int val){ this.seq_no = val; } 
	public void setItem(String val){ if(val==null) val=""; this.item = val;	} 
	public void setBpm(String val){ if(val==null) val=""; this.bpm = val; }
	public void setCount(int val){ this.count = val; } 
	public void setPrice(int val){ this.price = val; }
	public void setAmt(int val){ this.amt = val; }
	public void setLabor(int val){ this.labor = val; }
			
	//Get Method
	public String getCar_mng_id(){ return car_mng_id; }
	public String getServ_id(){	return serv_id;	}
	public int getSeq_no(){	return seq_no; } 
	public String getItem(){ return item; } 
	public String getBpm(){ return bpm; }
	public int getCount(){ return count; } 
	public int getPrice(){ return price; }
	public int getAmt(){ return amt; }
	public int getLabor(){ return labor; }
}