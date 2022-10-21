/**
 * 오프리스 수의매각대금 수금 스케쥴
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 05. 29. Thu.
 * @ last modify date : 
 */
package acar.offls_sui;

import java.util.*;

public class Scd_sui_janBean {
    //Table : SCD_SUI_JAN
	private String car_mng_id;
	private String tm;
	private int jan_amt;
	private String est_dt;
	private int pay_amt;
	private String pay_dt;
        
    // CONSTRCTOR
    public Scd_sui_janBean() {
		this.car_mng_id = "";
		this.tm = "";
		this.jan_amt = 0;
		this.est_dt = "";
		this.pay_amt = 0;
		this.pay_dt = "";
	}

	// set Method
	public void setCar_mng_id(String val){ if(val==null) val=""; this.car_mng_id = val; }
	public void setTm(String val){ if(val==null) val=""; this.tm = val; }
	public void setJan_amt(int val){ this.jan_amt = val; }
	public void setEst_dt(String val){ if(val==null) val=""; this.est_dt = val; }
	public void setPay_amt(int val){ this.pay_amt = val; }
	public void setPay_dt(String val){ if(val==null) val=""; this.pay_dt = val; }

	//get Method
	public String getCar_mng_id(){ return car_mng_id; }
	public String getTm(){ return tm; }
	public int getJan_amt(){ return jan_amt; }
	public String getEst_dt(){ return est_dt; }
	public int getPay_amt(){ return pay_amt; }
	public String getPay_dt(){ return pay_dt; }
}