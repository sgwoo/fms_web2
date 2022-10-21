/**
 * 서비스
 * @ author : 
 * @ e-mail : 
 * @ create date : 2003. 10. 8.
 * @ last modify date : -추가 2004.01.08. bpm
						-추가 2004.07.26. item_st,item_id
 */
package acar.cus_reg;

import java.util.*;

public class Serv_ItemBean {
    //Table : 
	private String car_mng_id;		//자동차관리번호
	private String serv_id;
	private int seq_no;
	private String item_st;			//구분 1:주작업,2:부수작업,3:부품
	private String item_id;			//    wm_id,ws_id,wp_id
	private String item;
	private String wk_st;
	private int count;
	private int price;
	private int amt;
	private int labor;
	private String bpm;				//부품공급처
	private String item_cd;
	private String reg_dt;
	private String reg_id;
	
    // CONSTRCTOR            
    public Serv_ItemBean() {  
		this.car_mng_id = "";
		this.serv_id	= "";
		this.seq_no		= 0;
		this.item_st	= "";
		this.item_id	= "";
		this.item		= "";
		this.wk_st		= "";
		this.count		= 0;
		this.price		= 0;
		this.amt		= 0;
		this.labor		= 0;
		this.bpm		= "";
		this.item_cd	= "";
		this.reg_dt		= "";
		this.reg_id		= "";
	}

	// get Method
	public void setCar_mng_id	(String val){ if(val==null) val=""; this.car_mng_id = val;	}
	public void setServ_id		(String val){ if(val==null) val=""; this.serv_id	= val;	}
	public void setSeq_no		(int    val){                       this.seq_no		= val;	}
	public void setItem_st		(String val){ if(val==null) val=""; this.item_st	= val;	} 
	public void setItem_id		(String val){ if(val==null) val=""; this.item_id	= val;	} 
	public void setItem			(String val){ if(val==null) val=""; this.item		= val;	} 
	public void setWk_st		(String val){ if(val==null) val=""; this.wk_st		= val;	}
	public void setCount		(int    val){                       this.count		= val;	} 
	public void setPrice		(int    val){                       this.price		= val;	}
	public void setAmt			(int    val){                       this.amt		= val;	}
	public void setLabor		(int    val){                       this.labor		= val;	}
	public void setBpm			(String val){ if(val==null) val=""; this.bpm		= val;	}
	public void setItem_cd		(String val){ if(val==null) val=""; this.item_cd	= val;	} 
	public void setReg_dt		(String val){ if(val==null) val="";	this.reg_dt		= val;	}	
	public void setReg_id		(String val){ if(val==null) val="";	this.reg_id		= val;	}	
			
	//Get Method
	public String getCar_mng_id	(){		return car_mng_id;	}
	public String getServ_id	(){		return serv_id;		}
	public int    getSeq_no		(){		return seq_no;		}
	public String getItem_st	(){		return item_st;		}
	public String getItem_id	(){		return item_id;		} 
	public String getItem		(){		return item;		} 
	public String getWk_st		(){		return wk_st;		}
	public int    getCount		(){		return count;		} 
	public int    getPrice		(){		return price;		}
	public int    getAmt		(){		return amt;			}
	public int    getLabor		(){		return labor;		}
	public String getBpm		(){		return bpm;			}
	public String getItem_cd	(){		return item_cd;		} 
	public String getReg_dt		(){		return reg_dt;		}	
	public String getReg_id		(){		return reg_id;		}	
}