/**
 * 사고기록-보험금 청구내역 (휴차료/대차료)
 */
package acar.accid;

import java.util.*;

public class MyAccidBean {
    //Table : CAR_REG
	private String car_mng_id; 					
	private String accid_id;
	private int    seq_no;
	private String ins_req_gu;
	private String ins_req_st;
	private String ins_car_nm;
	private String ins_car_no;
	private int    ins_day_amt;
	private String ins_use_st;
	private String ins_use_et;
	private String ins_nm;
	private String ins_tel;
	private String ins_tel2;
	private String ins_fax;
	private String ins_addr;
	private int    ins_req_amt;
	private String ins_req_dt;
	private int    ins_pay_amt;
	private String ins_pay_dt;
	private String ins_use_day;
	private String ins_com;
	private String re_reason;
	private String vat_yn;
	private int    mc_s_amt;
	private int    mc_v_amt;
	private String ins_num;
	private int    ot_fault_per;
	private String pay_gu;	
	private String incom_dt;		//입금원장:입금일
	private int	   incom_seq;		//입금원장:순번		
	private String bus_id2;			//휴/대차료 청구자
	private String reg_dt;
	private String reg_id;
	private String update_dt;
	private String update_id;
	private String rent_mng_id;		// 계약관리번호
	private String rent_l_cd;		// 계약번호    	
	private String ext_tm;			//납입회차
	private String ext_id;			//ext id
	private String bill_doc_yn;		//0:미발행 1:발행
	private String ins_com_id;
	private String ins_etc;
	private String use_hour;
	private String doc_req_dt;
	private String doc_reg_dt;
	private String ins_zip;
	private String app_docs;
        
    // CONSTRCTOR            
    public MyAccidBean() {  
		this.car_mng_id		= ""; 					
		this.accid_id		= "";
		this.seq_no			= 0;
		this.ins_req_gu		= "";
		this.ins_req_st		= "";
		this.ins_car_nm		= "";
		this.ins_car_no		= "";
		this.ins_day_amt	=0;
		this.ins_use_st		= "";
		this.ins_use_et		= "";
		this.ins_nm			= "";
		this.ins_tel		= "";
		this.ins_tel2		= "";
		this.ins_fax		= "";
		this.ins_addr		= "";
		this.ins_req_amt	= 0;
		this.ins_req_dt		= "";
		this.ins_pay_amt	= 0;
		this.ins_pay_dt		= "";
		this.ins_use_day	= "";
		this.ins_com		= "";
		this.re_reason		= "";
		this.vat_yn			= "";
		this.mc_s_amt		= 0;
		this.mc_v_amt		= 0;
		this.ins_num		= "";
		this.ot_fault_per	= 0;
		this.pay_gu			= "";		
		this.incom_dt		= "";
		this.incom_seq		= 0;		
		this.bus_id2		= "";
		this.reg_dt			= "";
		this.reg_id			= "";
		this.update_dt		= "";
		this.update_id		= "";
		this.rent_mng_id	= "";
		this.rent_l_cd		= ""; 		
		this.ext_tm			= "";
		this.ext_id			= "";
		this.bill_doc_yn	= ""; 
		this.ins_com_id		= "";
		this.ins_etc		= "";
		this.use_hour		= "";
		this.doc_req_dt		= "";
		this.doc_reg_dt		= "";
		this.ins_zip		= "";
		this.app_docs		= "";
		
	}

	// get Method
	public void setCar_mng_id	(String val){		if(val==null) val="";	this.car_mng_id		= val;	}
	public void setAccid_id		(String val){		if(val==null) val="";	this.accid_id		= val;	}
	public void setSeq_no		(int val)	{								this.seq_no			= val;	}
	public void setIns_req_gu	(String val){		if(val==null) val="";	this.ins_req_gu		= val;	}	
	public void setIns_req_st	(String val){		if(val==null) val="";	this.ins_req_st		= val;	}	
	public void setIns_car_nm	(String val){		if(val==null) val="";	this.ins_car_nm		= val;	}	
	public void setIns_car_no	(String val){		if(val==null) val="";	this.ins_car_no		= val;	}	
	public void setIns_day_amt	(int val)	{								this.ins_day_amt	= val;	}
	public void setIns_use_st	(String val){		if(val==null) val="";	this.ins_use_st		= val;	}	
	public void setIns_use_et	(String val){		if(val==null) val="";	this.ins_use_et		= val;	}	
	public void setIns_nm		(String val){		if(val==null) val="";	this.ins_nm			= val;	}	
	public void setIns_tel		(String val){		if(val==null) val="";	this.ins_tel		= val;	}	
	public void setIns_tel2		(String val){		if(val==null) val="";	this.ins_tel2		= val;	}	
	public void setIns_fax		(String val){		if(val==null) val="";	this.ins_fax		= val;	}	
	public void setIns_addr		(String val){		if(val==null) val="";	this.ins_addr		= val;	}	
	public void setIns_req_amt	(int val)	{								this.ins_req_amt	= val;	}
	public void setIns_req_dt	(String val){		if(val==null) val="";	this.ins_req_dt		= val;	}	
	public void setIns_pay_amt	(int val)	{								this.ins_pay_amt	= val;	}
	public void setIns_pay_dt	(String val){		if(val==null) val="";	this.ins_pay_dt		= val;	}	
	public void setIns_use_day	(String val){		if(val==null) val="";	this.ins_use_day	= val;	}	
	public void setIns_com		(String val){		if(val==null) val="";	this.ins_com		= val;	}	
	public void setRe_reason	(String val){		if(val==null) val="";	this.re_reason		= val;	}	
	public void setVat_yn		(String val){		if(val==null) val="";	this.vat_yn			= val;	}	
	public void setMc_s_amt		(int val)	{								this.mc_s_amt		= val;	}
	public void setMc_v_amt		(int val)	{								this.mc_v_amt		= val;	}
	public void setIns_num		(String val){		if(val==null) val="";	this.ins_num		= val;	}	
	public void setOt_fault_per	(int val)	{								this.ot_fault_per	= val;	}
	public void setPay_gu		(String val){		if(val==null) val="";	this.pay_gu			= val;	}			
	public void setIncom_dt		(String val){		if(val==null) val="";	this.incom_dt		= val;	}	
	public void setIncom_seq	(int val)	{								this.incom_seq		= val;	}	
	public void setBus_id2		(String val){		if(val==null) val="";	this.bus_id2		= val;	}	
	public void setReg_dt		(String val){		if(val==null) val="";	this.reg_dt			= val;	}	
	public void setReg_id		(String val){		if(val==null) val="";	this.reg_id			= val;	}	
	public void setUpdate_dt	(String val){		if(val==null) val="";	this.update_dt		= val;	}	
	public void setUpdate_id	(String val){		if(val==null) val="";	this.update_id		= val;	}		
	public void setRent_mng_id	(String val){		if(val==null) val="";	this.rent_mng_id	= val;	}	
	public void setRent_l_cd	(String val){		if(val==null) val="";	this.rent_l_cd		= val;	}	 	
	public void setExt_tm		(String val){		if(val==null) val="";	this.ext_tm			= val;	}	
	public void setExt_id		(String val){		if(val==null) val="";	this.ext_id			= val;	}	
	public void setBill_doc_yn	(String val){		if(val==null) val="";	this.bill_doc_yn	= val;	}	 
	public void setIns_com_id	(String val){		if(val==null) val="";	this.ins_com_id		= val;	}	
	public void setIns_etc		(String val){		if(val==null) val="";	this.ins_etc		= val;	}	
	public void setUse_hour		(String val){		if(val==null) val="";	this.use_hour		= val;	}	
	public void setDoc_req_dt	(String val){		if(val==null) val="";	this.doc_req_dt		= val;	}	
	public void setDoc_reg_dt	(String val){		if(val==null) val="";	this.doc_reg_dt		= val;	}	
	public void setIns_zip		(String val){		if(val==null) val="";	this.ins_zip		= val;	}	
	public void setApp_docs		(String val){		if(val==null) val="";	this.app_docs		= val;	}	


	//Get Method
	public String getCar_mng_id		(){		return car_mng_id;		}
	public String getAccid_id		(){		return accid_id;		}
	public int    getSeq_no			(){		return seq_no;			}
	public String getIns_req_gu		(){		return ins_req_gu;		}	
	public String getIns_req_st		(){		return ins_req_st;		}	
	public String getIns_car_nm		(){		return ins_car_nm;		}	
	public String getIns_car_no		(){		return ins_car_no;		}	
	public int    getIns_day_amt	(){		return ins_day_amt;		}
	public String getIns_use_st		(){		return ins_use_st;		}	
	public String getIns_use_et		(){		return ins_use_et;		}	
	public String getIns_nm			(){		return ins_nm;			}	
	public String getIns_tel		(){		return ins_tel;			}	
	public String getIns_tel2		(){		return ins_tel2;		}	
	public String getIns_fax		(){		return ins_fax;			}	
	public String getIns_addr		(){		return ins_addr;		}	
	public int    getIns_req_amt	(){		return ins_req_amt;		}
	public String getIns_req_dt		(){		return ins_req_dt;		}	
	public int    getIns_pay_amt	(){		return ins_pay_amt;		}
	public String getIns_pay_dt		(){		return ins_pay_dt;		}	
	public String getIns_use_day	(){		return ins_use_day;		}	
	public String getIns_com		(){		return ins_com;			}		
	public String getRe_reason		(){		return re_reason;		}	
	public String getVat_yn			(){		return vat_yn;			}	
	public int    getMc_s_amt		(){		return mc_s_amt;		}
	public int    getMc_v_amt		(){		return mc_v_amt;		}
	public String getIns_num		(){		return ins_num;			}
	public int    getOt_fault_per	(){		return ot_fault_per;	}
	public String getPay_gu			(){		return pay_gu;			}		
	public String getIncom_dt		(){		return incom_dt;		}  
	public int	  getIncom_seq		(){		return incom_seq;		}  	
	public String getBus_id2		(){		return bus_id2;			}  
	public String getReg_dt			(){		return reg_dt;			}	
	public String getReg_id			(){		return reg_id;			}	
	public String getUpdate_dt		(){		return update_dt;		}	
	public String getUpdate_id		(){		return update_id;		}			
	public String getRent_mng_id	(){		return rent_mng_id;		} 
	public String getRent_l_cd		(){		return rent_l_cd;		} 	
	public String getExt_tm			(){		return ext_tm;			} 
	public String getExt_id			(){		return ext_id;			} 
	public String getBill_doc_yn	(){		return bill_doc_yn;		} 
	public String getIns_com_id		(){		return ins_com_id;		} 
	public String getIns_etc		(){		return ins_etc;			} 
	public String getUse_hour		(){		return use_hour;		} 
	public String getDoc_req_dt		(){		return doc_req_dt;		} 
	public String getDoc_reg_dt		(){		return doc_reg_dt;		} 
	public String getIns_zip		(){		return ins_zip;			}	
	public String getApp_docs		(){		return app_docs;		}	
	
}