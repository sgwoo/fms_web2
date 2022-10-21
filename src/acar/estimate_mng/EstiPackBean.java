/**
 * °ßÀû¼­¹­À½
 */
package acar.estimate_mng;

import java.util.*;

public class EstiPackBean {
    //Table : ESTI_PACK
	private String pack_id;
	private int    seq;
	private String est_id;
	private String est_table;
	private String pack_st;
    private String reg_id;
    private String reg_dt;
	private String memo;
        
    // CONSTRCTOR            
    public EstiPackBean() {  
    	this.pack_id	= "";
	    this.seq		= 0;
		this.est_id		= "";
	    this.est_table	= "";
	    this.pack_st	= "";
	    this.reg_id		= "";
	    this.reg_dt		= "";
		this.memo		= "";
	}

	// get Method
    public void setPack_id		(String val){		if(val==null) val="";		this.pack_id	= val;	}
	public void setSeq			(int    val){									this.seq		= val;	}    
	public void setEst_id		(String val){		if(val==null) val="";		this.est_id		= val;	}
	public void setEst_table	(String val){		if(val==null) val="";		this.est_table	= val;	}
    public void setPack_st		(String val){		if(val==null) val="";		this.pack_st	= val;	}
    public void setReg_id		(String val){		if(val==null) val="";		this.reg_id		= val;	}
	public void setReg_dt		(String val){		if(val==null) val="";		this.reg_dt		= val;	}
	public void setMemo			(String val){		if(val==null) val="";		this.memo		= val;	}
		
	//Get Method
	public String getPack_id	(){		return pack_id;   }
	public int    getSeq		(){		return seq;       }
	public String getEst_id		(){		return est_id;    }
    public String getEst_table	(){		return est_table; }
    public String getPack_st	(){		return pack_st;   }
    public String getReg_id		(){		return reg_id;    }
	public String getReg_dt		(){		return reg_dt;    }
	public String getMemo		(){		return memo;	  }
}
