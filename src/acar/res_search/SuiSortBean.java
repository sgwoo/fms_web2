/**
 * 매각대상선별조건 변수
 */
package acar.res_search;

import java.util.*;

public class SuiSortBean {

    //Table : sui_sort
    private String car_mng_id;
    private int    seq;
    private String reg_dt;
    private String sort_code;
    private int    var_seq;
    private int    car_mon;
    private int    car_dist;
    private float  car_use_per;
	private int    car_day;
        
    // CONSTRCTOR            
    public SuiSortBean() {  
		this.car_mng_id		= "";
	    this.seq			= 0;
	    this.reg_dt			= "";
		this.sort_code		= "";
	    this.var_seq		= 0;
	    this.car_mon		= 0;
	    this.car_dist		= 0;
	    this.car_use_per	= 0.0f;
		this.car_day		= 0;
	}

	// get Method
	public void setCar_mng_id		(String val){		if(val==null) val="";		this.car_mng_id		= val;	}
	public void setSeq				(int    val){		                            this.seq			= val;	}    
    public void setReg_dt			(String val){		if(val==null) val="";		this.reg_dt			= val;	}
	public void setSort_code		(String val){		if(val==null) val="";		this.sort_code		= val;	}
	public void setVar_seq			(int    val){		                            this.var_seq		= val;	}    
    public void setCar_mon			(int    val){		                            this.car_mon		= val;	}
	public void setCar_dist			(int    val){		                            this.car_dist		= val;	}
    public void setCar_use_per		(float  val){		                            this.car_use_per	= val;	}
	public void setCar_day			(int    val){		                            this.car_day		= val;	}
		
	//Get Method
	public String getCar_mng_id		(){					return car_mng_id;  }
	public int    getSeq			(){					return seq;         }
	public String getReg_dt			(){					return reg_dt;      }
	public String getSort_code		(){					return sort_code;   }
	public int    getVar_seq		(){					return var_seq;     }
	public int    getCar_mon		(){					return car_mon;     }
    public int    getCar_dist		(){					return car_dist;    }
    public float  getCar_use_per	(){					return car_use_per; }
	public int    getCar_day		(){					return car_day;     }

}