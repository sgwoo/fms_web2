/**
 * 오프리스 수의매각대금 수금 스케쥴
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 05. 23. Fri.
 * @ last modify date : 
 */
package acar.offls_sui;

import java.util.*;

public class Scd_suiBean {
    //Table : SCD_SUI
	private String sui_id;
	private String tm;
	private int s_amt;
	private int v_amt;
	private String est_dt;
	private int pay_amt;
	private String pay_dt;
        
    // CONSTRCTOR
    public Scd_suiBean() {
		this.sui_id = "";
		this.tm = "";
		this.s_amt = 0;
		this.v_amt = 0;
		this.est_dt = "";
		this.pay_amt = 0;
		this.pay_dt = "";
	}

	// set Method
	public void setSui_id(String val){ if(val==null) val=""; this.sui_id = val; }
	public void setTm(String val){ if(val==null) val=""; this.tm = val; }
	public void setS_amt(int val){ this.s_amt = val; }
	public void setV_amt(int val){ this.v_amt = val; }
	public void setEst_dt(String val){ if(val==null) val=""; this.est_dt = val; }
	public void setPay_amt(int val){ this.pay_amt = val; }
	public void setPay_dt(String val){ if(val==null) val=""; this.pay_dt = val; }

	//get Method
	public String getSui_id(){ return sui_id; }
	public String getTm(){ return tm; }
	public int getS_amt(){ return s_amt; }
	public int getV_amt(){ return v_amt; }
	public String est_dt(){ return est_dt; }
	public int pay_amt(){ return pay_amt; }
	public String pay_dt(){ return pay_dt; }
}