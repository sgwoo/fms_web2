/**
 * 당일업무 스케쥴
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2004.03.05.
 * @ last modify date : 
 */
package acar.car_sche;

import java.util.*;

public class TodaySche2Bean {
	private String client_id;
	private String firm_nm;
	private String vst_title;
	private String vst_cont;
        
    // CONSTRCTOR            
    public TodaySche2Bean() {  
		this.client_id = "";
		this.firm_nm = "";
		this.vst_title = "";
		this.vst_cont = "";
	}

	// get Method
	public void setClient_id(String val){	if(val==null) val=""; this.client_id = val; }
	public void setFirm_nm(String val){		if(val==null) val=""; this.firm_nm = val; }
	public void setVst_title(String val){		if(val==null) val=""; this.vst_title = val; }
	public void setVst_cont(String val){	if(val==null) val=""; this.vst_cont = val;	}

	//Get Method
	public String getClient_id(){	return client_id;	}
	public String getFirm_nm(){		return firm_nm;		}
	public String getVst_title(){		return vst_title;		}
	public String getVst_cont(){	return vst_cont;	}
}