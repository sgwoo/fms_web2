/**
 * Â÷Á¾
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 11. 26. ¼ö.
 * @ last modify date : 
 */
package acar.cus0402;

import java.util.*;

public class Cycle_vstBean {
	
	private String client_id;
	private String seq;
	private String vst_dt;
	private String visiter;
	private String vst_title;
	private String vst_cont;
	private String vst_est_dt;
	private String vst_est_cont;
	private String update_id;
	private String update_dt;
	private String vst_pur;
	private String sangdamja;
	       
    // CONSTRCTOR            
    public Cycle_vstBean() { 
		this.client_id = "";
		this.seq = "";
		this.vst_dt = "";
		this.visiter = "";
		this.vst_title = "";
		this.vst_cont = "";
		this.vst_est_dt = "";
		this.vst_est_cont = "";
		this.update_id = "";
		this.update_dt = "";
		this.vst_pur		= "";
		this.sangdamja		= "";
	}

	// get Method
	public void setClient_id(String val){ if(val==null) val=""; this.client_id = val;	}
	public void setSeq(String val){ if(val==null) val=""; this.seq = val; }
	public void setVst_dt(String val){ if(val==null) val=""; this.vst_dt = val;	}
	public void setVisiter(String val){ if(val==null) val=""; this.visiter = val;	}
	public void setVst_title(String val){ if(val==null) val=""; this.vst_title = val;	}
	public void setVst_cont(String val){ if(val==null) val=""; this.vst_cont = val;	}
	public void setVst_est_dt(String val){ if(val==null) val=""; this.vst_est_dt = val;	}
	public void setVst_est_cont(String val){ if(val==null) val=""; this.vst_est_cont = val;	}
	public void setUpdate_id(String val){ if(val==null) val=""; this.update_id = val;	}
	public void setUpdate_dt(String val){ if(val==null) val=""; this.update_dt = val;	}
	public void setVst_pur			(String val){ if(val==null) val=""; this.vst_pur		= val;  }
	public void setSangdamja		(String val){ if(val==null) val=""; this.sangdamja		= val;	}
		
	//Get Method
	public String getClient_id(){ return client_id;	}
	public String getSeq(){ return seq; }
	public String getVst_dt(){	return vst_dt;	}
	public String getVisiter(){	return visiter;	}
	public String getVst_title(){	return vst_title;	}
	public String getVst_cont(){	return vst_cont;	}
	public String getVst_est_dt(){	return vst_est_dt;	}
	public String getVst_est_cont(){	return vst_est_cont;	}
	public String getUpdate_id(){	return update_id;	}
	public String getUpdate_dt(){	return update_dt;	}
	public String getVst_pur		(){		return vst_pur;			}
	public String getSangdamja		(){		return sangdamja;		}
}