package acar.tint;

import java.util.*;

public class TintBean {
    //Table : tint
    private String tint_no;     
    private String tint_st;     
    private String off_id;   
    private String off_nm;   
	private String car_mng_id;    
	private String rent_mng_id; 
    private String rent_l_cd;       
    private String client_id;    
    private String car_no;      
    private String car_nm;  
    private String car_num;  
    private String film_st;
    private int    sun_per;	
    private String cleaner_st;    
    private String cleaner_add;    
    private String navi_nm;    
    private int    navi_est_amt;	
	private String other;   
	private String etc;       
    private int    tint_amt;    
    private int    cleaner_amt;    
	private int    navi_amt;          
	private int    other_amt;   
    private int    tot_amt;   
	private String sup_est_dt;  
    private String sup_dt;  
    private String conf_dt;      
    private String req_dt;      
	private String pay_dt;      
	private String req_code;    	
    private String reg_id;
    private String reg_dt;
    private int    a_amt;   
    private int    e_amt;   
    private int    c_amt;   
    private int    e_sub_amt1;
    private int    e_sub_amt2;
    private int    c_sub_amt1;
    private int    c_sub_amt2;
    private int    a_tint_amt;    
    private int    a_cleaner_amt;    
	private int    a_navi_amt;          
	private int    a_other_amt;   
    private int    e_tint_amt;    
    private int    e_cleaner_amt;    
	private int    e_navi_amt;          
	private int    e_other_amt;   
    private int    c_tint_amt;    
    private int    c_cleaner_amt;    
	private int    c_navi_amt;          
	private int    c_other_amt;   
	private String tint_cau;     
	private String blackbox_yn;
	private String blackbox_nm;
	private int    blackbox_amt;   
	private String blackbox_img;
	private String blackbox_img2;
	private String blackbox_num;
	//20150717 신버전 용품관리 새로운 칼럼
	private String tint_yn;
	private String model_st;
	private String channel_st;
	private String com_nm;
	private String model_nm;
	private String serial_no;
	private String cost_st;
	private String est_st;
	private int    est_m_amt;
	private int    tint_su;
	private String doc_code;    	
	private int    r_tint_amt;    
	private String model_id;
	private String reg_st;
	private int    b_tint_amt;




	// CONSTRCTOR            
    public TintBean () {  
    	this.tint_no		= "";
    	this.tint_st		= "";
	    this.off_id			= "";
	    this.off_nm			= "";
	    this.car_mng_id		= "";
	    this.rent_mng_id	= "";
	    this.rent_l_cd		= "";
	    this.client_id		= "";
		this.car_no			= "";
		this.car_nm			= "";
    	this.car_num		= "";
	    this.film_st		= "";
	    this.sun_per		= 0;
    	this.cleaner_st		= "";
	    this.cleaner_add	= "";
	    this.navi_nm		= "";
	    this.navi_est_amt	= 0;
	    this.other			= "";
	    this.etc			= "";
	    this.tint_amt		= 0;
	    this.cleaner_amt	= 0;
	    this.navi_amt		= 0;
	    this.other_amt		= 0;
	    this.tot_amt		= 0;
	    this.sup_est_dt		= "";
	    this.sup_dt			= "";
    	this.conf_dt		= "";
    	this.req_dt			= "";
		this.pay_dt			= "";
    	this.req_code		= "";
		this.reg_id			= "";
		this.reg_dt			= "";
	    this.a_amt			= 0;
	    this.e_amt			= 0;
	    this.c_amt			= 0;
	    this.e_sub_amt1		= 0;
	    this.e_sub_amt2		= 0;
	    this.c_sub_amt1		= 0;
	    this.c_sub_amt2		= 0;
	    this.a_tint_amt		= 0;
	    this.a_cleaner_amt	= 0;
	    this.a_navi_amt		= 0;
	    this.a_other_amt	= 0;
	    this.e_tint_amt		= 0;
	    this.e_cleaner_amt	= 0;
	    this.e_navi_amt		= 0;
	    this.e_other_amt	= 0;
	    this.c_tint_amt		= 0;
	    this.c_cleaner_amt	= 0;
	    this.c_navi_amt		= 0;
	    this.c_other_amt	= 0;
		this.tint_cau		= "";
	    this.blackbox_yn	= "";
	    this.blackbox_nm	= "";
	    this.blackbox_amt	= 0;
	    this.blackbox_img	= "";
	    this.blackbox_img2	= "";
	    this.blackbox_num	= "";		
		this.tint_yn   		= "";    
		this.model_st  		= "";    
		this.channel_st		= "";    
		this.com_nm    		= "";    
		this.model_nm  		= "";    
		this.serial_no 		= "";    
		this.cost_st   		= "";    
		this.est_st    		= "";    
		this.est_m_amt 		= 0;     
		this.tint_su 		= 0; 
		this.doc_code		= "";
		this.r_tint_amt		= 0;
		this.model_id  		= "";   
		this.reg_st			= "";
		this.b_tint_amt		= 0;



	}

	// get Method
	public void setTint_no			(String val){		if(val==null) val="";		this.tint_no		= val;	}
	public void setTint_st			(String val){		if(val==null) val="";		this.tint_st		= val;	}
	public void setOff_id			(String val){		if(val==null) val="";		this.off_id			= val;	}
	public void setOff_nm			(String val){		if(val==null) val="";		this.off_nm			= val;	}
	public void setCar_mng_id		(String val){		if(val==null) val="";		this.car_mng_id		= val;	}
	public void setRent_mng_id		(String val){		if(val==null) val="";		this.rent_mng_id	= val;	}
	public void setRent_l_cd		(String val){		if(val==null) val="";		this.rent_l_cd		= val;	}
	public void setClient_id		(String val){		if(val==null) val="";		this.client_id		= val;	}
	public void setCar_no			(String val){		if(val==null) val="";		this.car_no			= val;	}
	public void setCar_nm			(String val){		if(val==null) val="";		this.car_nm			= val;	}
	public void setCar_num			(String val){		if(val==null) val="";		this.car_num		= val;	}
	public void setFilm_st			(String val){		if(val==null) val="";		this.film_st		= val;	}
	public void setSun_per			(int    val){									this.sun_per		= val;	}
	public void setCleaner_st		(String val){		if(val==null) val="";		this.cleaner_st		= val;	}
	public void setCleaner_add		(String val){		if(val==null) val="";		this.cleaner_add	= val;	}
	public void setNavi_nm			(String val){		if(val==null) val="";		this.navi_nm		= val;	}
	public void setNavi_est_amt		(int    val){									this.navi_est_amt	= val;	}
	public void setOther			(String val){		if(val==null) val="";		this.other			= val;	}
	public void setEtc				(String val){		if(val==null) val="";		this.etc			= val;	}
	public void setTint_amt			(int    val){									this.tint_amt		= val;	}
	public void setCleaner_amt		(int    val){									this.cleaner_amt	= val;	}
	public void setNavi_amt			(int    val){									this.navi_amt		= val;	}
	public void setOther_amt		(int    val){									this.other_amt		= val;	}
	public void setTot_amt			(int    val){									this.tot_amt		= val;	}
	public void setSup_est_dt		(String val){		if(val==null) val="";		this.sup_est_dt		= val;	}
	public void setSup_dt			(String val){		if(val==null) val="";		this.sup_dt			= val;	}
	public void setConf_dt			(String val){		if(val==null) val="";		this.conf_dt		= val;	}
	public void setReq_dt			(String val){		if(val==null) val="";		this.req_dt			= val;	}
	public void setPay_dt			(String val){		if(val==null) val="";		this.pay_dt			= val;	}
	public void setReq_code			(String val){		if(val==null) val="";		this.req_code		= val;	}
	public void setReg_id			(String val){		if(val==null) val="";		this.reg_id			= val;	}
	public void setReg_dt			(String val){		if(val==null) val="";		this.reg_dt			= val;	}
	public void setA_amt			(int    val){									this.a_amt			= val;	}
	public void setE_amt			(int    val){									this.e_amt			= val;	}
	public void setC_amt			(int    val){									this.c_amt			= val;	}
	public void setE_sub_amt1		(int    val){									this.e_sub_amt1		= val;	}
	public void setE_sub_amt2		(int    val){									this.e_sub_amt2		= val;	}
	public void setC_sub_amt1		(int    val){									this.c_sub_amt1		= val;	}
	public void setC_sub_amt2		(int    val){									this.c_sub_amt2		= val;	}
	public void setA_tint_amt		(int    val){									this.a_tint_amt		= val;	}
	public void setA_cleaner_amt	(int    val){									this.a_cleaner_amt	= val;	}
	public void setA_navi_amt		(int    val){									this.a_navi_amt		= val;	}
	public void setA_other_amt		(int    val){									this.a_other_amt	= val;	}
	public void setE_tint_amt		(int    val){									this.e_tint_amt		= val;	}
	public void setE_cleaner_amt	(int    val){									this.e_cleaner_amt	= val;	}
	public void setE_navi_amt		(int    val){									this.e_navi_amt		= val;	}
	public void setE_other_amt		(int    val){									this.e_other_amt	= val;	}
	public void setC_tint_amt		(int    val){									this.c_tint_amt		= val;	}
	public void setC_cleaner_amt	(int    val){									this.c_cleaner_amt	= val;	}
	public void setC_navi_amt		(int    val){									this.c_navi_amt		= val;	}
	public void setC_other_amt		(int    val){									this.c_other_amt	= val;	}
	public void setTint_cau			(String val){		if(val==null) val="";		this.tint_cau		= val;	}
	public void setBlackbox_yn		(String val){		if(val==null) val="";		this.blackbox_yn	= val;	}
	public void setBlackbox_nm		(String val){		if(val==null) val="";		this.blackbox_nm	= val;	}
	public void setBlackbox_amt		(int    val){									this.blackbox_amt	= val;	}
	public void setBlackbox_img		(String val){		if(val==null) val="";		this.blackbox_img	= val;	}
	public void setBlackbox_img2	(String val){		if(val==null) val="";		this.blackbox_img2	= val;	}
	public void setBlackbox_num		(String val){		if(val==null) val="";		this.blackbox_num	= val;	}
	public void setTint_yn   		(String val){		if(val==null) val="";		this.tint_yn   		= val;	}
	public void setModel_st  		(String val){		if(val==null) val="";		this.model_st  		= val;	}
	public void setChannel_st		(String val){		if(val==null) val="";		this.channel_st		= val;	}
	public void setCom_nm    		(String val){		if(val==null) val="";		this.com_nm    		= val;	}
	public void setModel_nm  		(String val){		if(val==null) val="";		this.model_nm  		= val;	}
	public void setSerial_no 		(String val){		if(val==null) val="";		this.serial_no 		= val;	}
	public void setCost_st   		(String val){		if(val==null) val="";		this.cost_st   		= val;	}
	public void setEst_st    		(String val){		if(val==null) val="";		this.est_st    		= val;	}
	public void setEst_m_amt 		(int    val){									this.est_m_amt 		= val;	}
	public void setTint_su	 		(int    val){									this.tint_su 		= val;	}
	public void setDoc_code			(String val){		if(val==null) val="";		this.doc_code		= val;	}
	public void setR_tint_amt		(int    val){									this.r_tint_amt		= val;	}
	public void setModel_id  		(String val){		if(val==null) val="";		this.model_id  		= val;	}
	public void setReg_st  			(String val){		if(val==null) val="";		this.reg_st  		= val;	}
	public void setB_tint_amt		(int    val){									this.b_tint_amt		= val;	}
	
	
	//Get Method
	public String getTint_no		(){		return tint_no;				}
	public String getTint_st		(){		return tint_st;				}
	public String getOff_id			(){		return off_id;				}
	public String getOff_nm			(){		return off_nm;				}
	public String getCar_mng_id		(){		return car_mng_id;			}
	public String getRent_mng_id	(){		return rent_mng_id;			}
	public String getRent_l_cd		(){		return rent_l_cd;			}
	public String getClient_id		(){		return client_id;			}
	public String getCar_no			(){		return car_no;				}
	public String getCar_nm			(){		return car_nm;				}
	public String getCar_num		(){		return car_num;				}
	public String getFilm_st		(){		return film_st;				}
	public int    getSun_per		(){		return sun_per;				}
	public String getCleaner_st		(){		return cleaner_st;			}
	public String getCleaner_add	(){		return cleaner_add;			}
	public String getNavi_nm		(){		return navi_nm;				}
	public int    getNavi_est_amt	(){		return navi_est_amt;		}
	public String getOther			(){		return other;				}
	public String getEtc			(){		return etc;					}
	public int    getTint_amt		(){		return tint_amt;			}
	public int    getCleaner_amt	(){		return cleaner_amt;			}
	public int    getNavi_amt		(){		return navi_amt;			}
	public int    getOther_amt		(){		return other_amt;			}
	public int    getTot_amt		(){		return tot_amt;				}
	public String getSup_est_dt		(){		return sup_est_dt;			}
	public String getSup_dt			(){		return sup_dt;				}
	public String getConf_dt		(){		return conf_dt;				}
	public String getReq_dt			(){		return req_dt;				}
	public String getPay_dt			(){		return pay_dt;				}
	public String getReq_code		(){		return req_code;			}
	public String getReg_id			(){		return reg_id;				}
	public String getReg_dt			(){		return reg_dt;				}
	public int    getA_amt			(){		return a_amt;				}
	public int    getE_amt			(){		return e_amt;				}
	public int    getC_amt			(){		return c_amt;				}
	public int    getE_sub_amt1		(){		return e_sub_amt1;			}
	public int    getE_sub_amt2		(){		return e_sub_amt2;			}
	public int    getC_sub_amt1		(){		return c_sub_amt1;			}
	public int    getC_sub_amt2		(){		return c_sub_amt2;			}
	public int    getA_tint_amt		(){		return a_tint_amt;			}
	public int    getA_cleaner_amt	(){		return a_cleaner_amt;		}
	public int    getA_navi_amt		(){		return a_navi_amt;			}
	public int    getA_other_amt	(){		return a_other_amt;			}
	public int    getE_tint_amt		(){		return e_tint_amt;			}
	public int    getE_cleaner_amt	(){		return e_cleaner_amt;		}
	public int    getE_navi_amt		(){		return e_navi_amt;			}
	public int    getE_other_amt	(){		return e_other_amt;			}
	public int    getC_tint_amt		(){		return c_tint_amt;			}
	public int    getC_cleaner_amt	(){		return c_cleaner_amt;		}
	public int    getC_navi_amt		(){		return c_navi_amt;			}
	public int    getC_other_amt	(){		return c_other_amt;			}
	public String getTint_cau		(){		return tint_cau;			}
	public String getBlackbox_yn	(){		return blackbox_yn;			}
	public String getBlackbox_nm	(){		return blackbox_nm;			}
	public int    getBlackbox_amt	(){		return blackbox_amt;		}
	public String getBlackbox_img	(){		return blackbox_img;		}
	public String getBlackbox_img2	(){		return blackbox_img2;		}
	public String getBlackbox_num	(){		return blackbox_num;		}
	public String getTint_yn   		(){		return tint_yn;        		}
	public String getModel_st  		(){		return model_st;       		}
	public String getChannel_st		(){		return channel_st;			}
	public String getCom_nm    		(){		return com_nm;				}
	public String getModel_nm  		(){		return model_nm;       		}
	public String getSerial_no 		(){		return serial_no;      		}
	public String getCost_st   		(){		return cost_st;        		}
	public String getEst_st    		(){		return est_st;				}
	public int    getEst_m_amt 		(){		return est_m_amt;      		}
	public int    getTint_su 		(){		return tint_su;      		}
	public String getDoc_code		(){		return doc_code;			}
	public int    getR_tint_amt		(){		return r_tint_amt;			}
	public String getModel_id  		(){		return model_id;       		}
	public String getReg_st  		(){		return reg_st;       		}
	public int    getB_tint_amt		(){		return b_tint_amt;			}

}