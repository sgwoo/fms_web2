/**
 * 매각대상선별조건 변수
 */
package acar.res_search;

import java.util.*;

public class SuiSortVarBean {

    //Table : sui_sort_var
    private String sort_code;
    private int    seq;
    private String reg_dt;
    private String sort_gubun;
    private int    b_mon;
    private int    b_dist;
    private float  b_use_per;
    private String b_s_st;
    private int    b_min_dpm;
    private int    b_max_dpm;
    private int    b_day;
    private int    b_mon_only;
    private int    b_dist_only;
        
    // CONSTRCTOR            
    public SuiSortVarBean() {  
    	this.sort_code	= "";
	    this.seq		= 0;
	    this.reg_dt		= "";
	    this.sort_gubun	= "";
	    this.b_mon		= 0;
	    this.b_dist		= 0;
	    this.b_use_per	= 0.0f;
	    this.b_s_st		= "";
	    this.b_min_dpm	= 0;
	    this.b_max_dpm	= 0;
		this.b_day		= 0;
	    this.b_mon_only	= 0;
	    this.b_dist_only= 0;
	}

	// get Method
	public void setSort_code	(String val){		if(val==null) val="";		this.sort_code	= val;	}
	public void setSeq			(int    val){		                            this.seq		= val;	}    
    public void setReg_dt		(String val){		if(val==null) val="";		this.reg_dt		= val;	}
	public void setSort_gubun	(String val){		if(val==null) val="";		this.sort_gubun	= val;	}
    public void setB_mon		(int    val){		                            this.b_mon		= val;	}
    public void setB_dist		(int    val){		                            this.b_dist		= val;	}
    public void setB_use_per	(float  val){		                            this.b_use_per	= val;	}
	public void setB_s_st		(String val){		if(val==null) val="";		this.b_s_st		= val;	}
    public void setB_min_dpm	(int    val){		                            this.b_min_dpm	= val;	}
    public void setB_max_dpm	(int    val){		                            this.b_max_dpm	= val;	}
	public void setB_day		(int    val){		                            this.b_day		= val;	}
    public void setB_mon_only	(int    val){		                            this.b_mon_only	= val;	}
    public void setB_dist_only	(int    val){		                            this.b_dist_only= val;	}
		
	//Get Method
	public String getSort_code	(){		return sort_code;  }
	public int    getSeq		(){		return seq;        }
	public String getReg_dt		(){		return reg_dt;     }
    public String getSort_gubun	(){		return sort_gubun; }
    public int    getB_mon		(){		return b_mon;      }
    public int    getB_dist		(){		return b_dist;     }
	public float  getB_use_per	(){		return b_use_per;  }
    public String getB_s_st		(){		return b_s_st;     }
    public int    getB_min_dpm	(){		return b_min_dpm;  }
    public int    getB_max_dpm	(){		return b_max_dpm;  }
	public int    getB_day		(){		return b_day;      }
    public int    getB_mon_only	(){		return b_mon_only; }
    public int    getB_dist_only(){		return b_dist_only;}

}