/**
 * 오프리스 진행현황
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 05. 29. Thu.
 * @ last modify date : 
 */
package acar.offls_sui;

import java.util.*;

public class Sui_etcBean {
    //Table : SUI_ETC  //매입옵션 진행 현황 
	private String car_mng_id;
	private String est_dt;
	private String conj_dt;
        
    // CONSTRCTOR
    public Sui_etcBean() {
		this.car_mng_id = "";	
		this.est_dt = "";
		this.conj_dt = "";
	}

	// set Method
	public void setCar_mng_id(String val){ if(val==null) val=""; this.car_mng_id = val; }	
	public void setEst_dt(String val){ if(val==null) val=""; this.est_dt = val; }
	public void setConj_dt(String val){ if(val==null) val=""; this.conj_dt = val; }

	//get Method
	public String getCar_mng_id(){ return car_mng_id; }
	public String getEst_dt(){ return est_dt; }
	public String getConj_dt(){ return conj_dt; }
}