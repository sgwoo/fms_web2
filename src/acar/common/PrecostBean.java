/**
 * 기간비용
 * @ author : JHM
 * @ create date : 2007. 12. 06
 */
package acar.common;

import java.util.*;

public class PrecostBean {
    //Table : Precost
    private String car_mng_id;		
	private String cost_st;			
	private String cost_id;			
	private String cost_tm;			
	private String cost_ym;			
	private float  cost_day;			
	private float  cost_amt;			
	private float  rest_day;			
	private float  rest_amt;			
	private String update_dt;			
	private String update_id;			
	private String reg_dt;			
	private String reg_id;			
	private String car_use;			
	private String car_no;			
	private String cost_tm2;			

        
    // CONSTRCTOR            
    public PrecostBean() {  
	    this.car_mng_id = "";		
		this.cost_st	= "";		
		this.cost_id	= "";				
		this.cost_tm	= "";				
		this.cost_ym	= "";				
	    this.cost_day	= 0;		
		this.cost_amt	= 0;		
		this.rest_day	= 0;			
		this.rest_amt	= 0;			
		this.update_dt	= "";		
		this.update_id	= "";	
		this.reg_dt		= "";		
		this.reg_id		= "";	
		this.car_use	= "";	
		this.car_no		= "";	
		this.cost_tm2	= "";				
	}

	// get Method
	public void setCar_mng_id	(String val){		if(val==null) val="";		this.car_mng_id = val;	}
	public void setCost_st		(String val){		if(val==null) val="";		this.cost_st	= val;	}
	public void setCost_id		(String val){		if(val==null) val="";		this.cost_id	= val;	}
	public void setCost_tm		(String val){		if(val==null) val="";		this.cost_tm	= val;	}
	public void setCost_ym		(String val){		if(val==null) val="";		this.cost_ym	= val;	}
	public void setCost_day		(float val) {									this.cost_day	= val;	}
	public void setCost_amt		(float val) {									this.cost_amt	= val;	}
	public void setRest_day		(float val) {									this.rest_day	= val;	}
	public void setRest_amt		(float val) {									this.rest_amt	= val;	}
	public void setUpdate_dt	(String val){		if(val==null) val="";		this.update_dt	= val;	}
	public void setUpdate_id	(String val){		if(val==null) val="";		this.update_id	= val;	}
	public void setReg_dt		(String val){		if(val==null) val="";		this.reg_dt		= val;	}
	public void setReg_id		(String val){		if(val==null) val="";		this.reg_id		= val;	}
	public void setCar_use		(String val){		if(val==null) val="";		this.car_use	= val;	}
	public void setCar_no		(String val){		if(val==null) val="";		this.car_no		= val;	}
	public void setCost_tm2		(String val){		if(val==null) val="";		this.cost_tm2	= val;	}
	
	
	//Get Method
	public String getCar_mng_id	(){		return car_mng_id;	}
	public String getCost_st	(){		return cost_st;		}
	public String getCost_id	(){		return cost_id;		}
	public String getCost_tm	(){		return cost_tm;		}
	public String getCost_ym	(){		return cost_ym;		}
	public float  getCost_day	(){		return cost_day;	}
	public float  getCost_amt	(){		return cost_amt;	}
	public float  getRest_day	(){		return rest_day;	}
	public float  getRest_amt	(){		return rest_amt;	}
	public String getUpdate_dt	(){		return update_dt;	}
	public String getUpdate_id	(){		return update_id;	}
	public String getCar_use	(){		return car_use;		}
	public String getCar_no		(){		return car_no;		}
	public String getCost_tm2	(){		return cost_tm2;	}


}