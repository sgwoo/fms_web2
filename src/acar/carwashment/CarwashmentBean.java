package acar.carwashment;

import java.util.*;

public class CarwashmentBean {
    //Table : carwashment
    private String wash_no;     
    private int    seq;         
    private String off_id;   
    private String off_nm;   
	private String car_mng_id;    
	private String rent_mng_id; 
    private String rent_l_cd;       
    private String client_id;    
    private String car_no;      
    private String car_nm;  
    private String cost_st;    
    private String pay_st;    
    private String driver_nm;   
    private String driver_m_tel;
	private String wash_yn;    
    private String oil_yn;    
    private int    oil_liter;
    private int    oil_amt;
    private String etc;       
    private String reg_id;
    private String reg_dt;
    private String conf_dt;
    private int    wash_amt;   
    private String pay_dt;      
    private String req_dt;      
    private String req_code;      
    private String chk1;         
    private String chk_input1;
    private String chk2;         
    private String chk_input2;
    private String chk3;         
    private String chk_input3;
    private String chk4;         
    private String chk_input4;
    private String chk5;         
    private String chk_input5;
    private String chk6;         
    private String chk_input6;
    private String chk7;         
    private String chk_input7;
    private String chk8;         
    private String chk_input8;
    private String chk9;         
    private String chk_input9;
    private String chk10;         
    private String chk_input10;
    private String chk11;         
    private String chk_input11;
    private String chk12;         
    private String chk_input12;


    // CONSTRCTOR            
    public CarwashmentBean () {  
    	this.wash_no		= "";
	    this.seq			= 0;
	    this.off_id			= "";
	    this.off_nm			= "";
		this.car_mng_id		= "";
		this.rent_mng_id	= "";
    	this.rent_l_cd		= "";
	    this.client_id		= "";
	    this.car_no			= "";
    	this.car_nm			= "";
	    this.cost_st		= "";
	    this.pay_st			= "";
    	this.driver_nm		= "";
	    this.driver_m_tel	= "";
    	this.wash_yn		= "";
    	this.oil_yn			= "";
    	this.oil_liter		= 0;
    	this.oil_amt		= 0;
	    this.etc			= "";
		this.reg_id			= "";
		this.reg_dt			= "";
		this.conf_dt		= "";
	    this.wash_amt		= 0;
    	this.pay_dt			= "";
    	this.req_dt			= "";
    	this.req_code		= "";
	 
		this.chk1		= "";
	    this.chk_input1		= "";
		this.chk2		= "";
	    this.chk_input2		= "";
		this.chk3		= "";
	    this.chk_input3		= "";
		this.chk4		= "";
	    this.chk_input4		= "";
		this.chk5		= "";
	    this.chk_input5		= "";
		this.chk6		= "";
	    this.chk_input6		= "";
		this.chk7		= "";
	    this.chk_input7		= "";
		this.chk8		= "";
	    this.chk_input8		= "";
		this.chk9		= "";
	    this.chk_input9		= "";
		this.chk10		= "";
	    this.chk_input10		= "";
		this.chk11		= "";
	    this.chk_input11		= "";
		this.chk12		= "";
	    this.chk_input12	= "";
		

	}


	// get Method
	public void setWash_no			(String val){		if(val==null) val="";		this.wash_no		= val;	}
	public void setSeq				(int    val){									this.seq			= val;	}
	public void setOff_id			(String val){		if(val==null) val="";		this.off_id			= val;	}
	public void setOff_nm			(String val){		if(val==null) val="";		this.off_nm			= val;	}
	public void setCar_mng_id		(String val){		if(val==null) val="";		this.car_mng_id		= val;	}
	public void setRent_mng_id		(String val){		if(val==null) val="";		this.rent_mng_id	= val;	}
	public void setRent_l_cd		(String val){		if(val==null) val="";		this.rent_l_cd		= val;	}
	public void setClient_id		(String val){		if(val==null) val="";		this.client_id		= val;	}
	public void setCar_no			(String val){		if(val==null) val="";		this.car_no			= val;	}
	public void setCar_nm			(String val){		if(val==null) val="";		this.car_nm			= val;	}
	public void setCost_st			(String val){		if(val==null) val="";		this.cost_st		= val;	}
	public void setPay_st			(String val){		if(val==null) val="";		this.pay_st			= val;	}
	public void setDriver_nm		(String val){		if(val==null) val="";		this.driver_nm		= val;	}
	public void setDriver_m_tel		(String val){		if(val==null) val="";		this.driver_m_tel	= val;	}
	public void setWash_yn    		(String val){		if(val==null) val="";		this.wash_yn		= val;	}
	public void setOil_yn     		(String val){		if(val==null) val="";		this.oil_yn			= val;	}
	public void setOil_liter  		(int    val){									this.oil_liter		= val;	}
	public void setOil_amt			(int    val){									this.oil_amt		= val;	}
	public void setEtc				(String val){		if(val==null) val="";		this.etc			= val;	}
	public void setReg_id			(String val){		if(val==null) val="";		this.reg_id			= val;	}
	public void setReg_dt			(String val){		if(val==null) val="";		this.reg_dt			= val;	}
	public void setConf_dt			(String val){		if(val==null) val="";		this.conf_dt		= val;	}
	public void setWash_amt			(int    val){									this.wash_amt		= val;	}
	public void setPay_dt			(String val){		if(val==null) val="";		this.pay_dt			= val;	}
	public void setReq_dt			(String val){		if(val==null) val="";		this.req_dt			= val;	}
	public void setReq_code			(String val){		if(val==null) val="";		this.req_code		= val;	}

	public void setChk1				(String val){		if(val==null) val="";		this.chk1			= val;	}
	public void setChk_input1		(String val){		if(val==null) val="";		this.chk_input1		= val;	}
	public void setChk2				(String val){		if(val==null) val="";		this.chk2			= val;	}
	public void setChk_input2		(String val){		if(val==null) val="";		this.chk_input2		= val;	}
	public void setChk3				(String val){		if(val==null) val="";		this.chk3			= val;	}
	public void setChk_input3		(String val){		if(val==null) val="";		this.chk_input3		= val;	}
	public void setChk4				(String val){		if(val==null) val="";		this.chk4			= val;	}
	public void setChk_input4		(String val){		if(val==null) val="";		this.chk_input4		= val;	}
	public void setChk5				(String val){		if(val==null) val="";		this.chk5			= val;	}
	public void setChk_input5		(String val){		if(val==null) val="";		this.chk_input5		= val;	}
	public void setChk6				(String val){		if(val==null) val="";		this.chk6			= val;	}
	public void setChk_input6		(String val){		if(val==null) val="";		this.chk_input6		= val;	}
	public void setChk7				(String val){		if(val==null) val="";		this.chk7			= val;	}
	public void setChk_input7		(String val){		if(val==null) val="";		this.chk_input7		= val;	}
	public void setChk8				(String val){		if(val==null) val="";		this.chk8			= val;	}
	public void setChk_input8		(String val){		if(val==null) val="";		this.chk_input8		= val;	}
	public void setChk9				(String val){		if(val==null) val="";		this.chk9			= val;	}
	public void setChk_input9		(String val){		if(val==null) val="";		this.chk_input9		= val;	}
	public void setChk10			(String val){		if(val==null) val="";		this.chk10			= val;	}
	public void setChk_input10		(String val){		if(val==null) val="";		this.chk_input10	= val;	}
	public void setChk11			(String val){		if(val==null) val="";		this.chk11			= val;	}
	public void setChk_input11		(String val){		if(val==null) val="";		this.chk_input11	= val;	}
	public void setChk12			(String val){		if(val==null) val="";		this.chk12			= val;	}
	public void setChk_input12		(String val){		if(val==null) val="";		this.chk_input12	= val;	}	

	//Get Method
	public String getWash_no		(){		return wash_no;			}
	public int    getSeq			(){		return seq;				}
	public String getOff_id			(){		return off_id;			}
	public String getOff_nm			(){		return off_nm;			}
	public String getCar_mng_id		(){		return car_mng_id;		}
	public String getRent_mng_id	(){		return rent_mng_id;		}
	public String getRent_l_cd		(){		return rent_l_cd;		}
	public String getClient_id		(){		return client_id;		}
	public String getCar_no			(){		return car_no;			}
	public String getCar_nm			(){		return car_nm;			}
	public String getCost_st		(){		return cost_st;			}
	public String getPay_st			(){		return pay_st;			}
	public String getDriver_nm		(){		return driver_nm;		}
	public String getDriver_m_tel	(){		return driver_m_tel;	}
	public String getWash_yn    	(){		return wash_yn;     	}
	public String getOil_yn     	(){		return oil_yn;      	}
	public int    getOil_liter  	(){		return oil_liter;   	}
	public int    getOil_amt		(){		return oil_amt;			}
	public String getEtc			(){		return etc;         	}
	public String getReg_id			(){		return reg_id;			}
	public String getReg_dt			(){		return reg_dt;			}
	public String getConf_dt		(){		return conf_dt;			}
	public int    getWash_amt		(){		return wash_amt;		}
	public String getPay_dt			(){		return pay_dt;			}
	public String getReq_dt			(){		return req_dt;			}
	public String getReq_code		(){		return req_code;		}
	
	public String getChk1			(){		return chk1;			}
	public String getChk_input1		(){		return chk_input1;		}
	public String getChk2			(){		return chk2;			}
	public String getChk_input2		(){		return chk_input2;		}
	public String getChk3			(){		return chk3;			}
	public String getChk_input3		(){		return chk_input3;		}
	public String getChk4			(){		return chk4;			}
	public String getChk_input4		(){		return chk_input4;		}
	public String getChk5			(){		return chk5;			}
	public String getChk_input5		(){		return chk_input5;		}
	public String getChk6			(){		return chk6;			}
	public String getChk_input6		(){		return chk_input6;		}
	public String getChk7			(){		return chk7;			}
	public String getChk_input7		(){		return chk_input7;		}
	public String getChk8			(){		return chk8;			}
	public String getChk_input8		(){		return chk_input8;		}
	public String getChk9			(){		return chk9;			}
	public String getChk_input9		(){		return chk_input9;		}
	public String getChk10			(){		return chk10;			}
	public String getChk_input10	(){		return chk_input10;		}
	public String getChk11			(){		return chk11;			}
	public String getChk_input11	(){		return chk_input11;		}
	public String getChk12			(){		return chk12;			}
	public String getChk_input12	(){		return chk_input12;		}

}