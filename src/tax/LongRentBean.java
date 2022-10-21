package tax;

import java.util.*;

public class LongRentBean {
	//Table : 계약별 상단 정보
	private String rent_mng_id;			
	private String rent_l_cd;			
	private String car_mng_id;			
	private String client_id;			
	private String site_id;				
	private String car_type;			
	private String rent_st;				
	private String car_st;				
	private String bus_st;				
	private String rent_dt;				
	private String br_id;				
	private String bus_id;				
	private String bus_id2;				
	private String mng_id;				
	private String mng_id2;				
	private String p_zip;				
	private String p_addr;				
	private String driving_ext;			
	private String driving_age;			
	private String loan_ext;			
	private int    imm_amt;				
	private String imm_cau;				
	private String imm_nm;				
	private String gcp_kd;				
	private String bacdt_kd;			
	private String ins_spe_chk;			
	private String ins_spe_cont;		
	private String gi_st;				
	private String gi_cau;				
	private String gi_nm;				
	private String prv_dlv_yn;			
	private String prv_mon_yn;			
	private String opt_add;				
	private String lpg_yn;				
	private String lpg_setter;			
	private String lpg_fee;				
	private int lpg_price;				
	private String note;				
	private String use_yn;				
	private String reg_id;				
	private String reg_dt;				
	private String upd_id;				
	private String upd_dt;	

	private String tax_agnt;		
	private String tax_type;	
	private String car_no;		
	private String car_nm;	
	private String car_name;	
	private String init_reg_dt;
	private String firm_nm;	
	private String client_nm;		
	private String site_nm;	
	private String ven_code;	
	private String print_st;	
	private String rent_way;
	private String con_mon;
	private String leave_day;	
	private String rent_start_dt;
	private String rent_end_dt;
	private String br_nm;
	private String cms_bank;
	private String cms_start_dt;
	private String cms_end_dt;
	private String cms_day;
	private int fee_amt;				
	private String car_use;		
	private String jg_code;		
	private String s_st;		
	private String m_tel;		

	// CONSTRCTOR            
	public LongRentBean() {  
		rent_mng_id	= "";
		rent_l_cd	= "";
		car_mng_id	= "";
		client_id	= "";
		site_id		= "";
		car_type	= "";
		rent_st		= "";
		car_st		= "";
		bus_st		= "";
		rent_dt		= "";
		br_id		= "";
		bus_id		= "";
		bus_id2		= "";
		mng_id		= "";
		mng_id2		= "";
		p_zip		= "";
		p_addr		= "";
		driving_ext	= "";
		driving_age	= "";
		loan_ext	= "";
		imm_amt		= 0;
		imm_cau		= "";
		imm_nm		= "";
		gcp_kd		= "";
		bacdt_kd	= "";
		ins_spe_chk	= "";
		ins_spe_cont	= "";
		gi_st		= "";
		gi_cau		= "";
		gi_nm		= "";
		prv_dlv_yn	= "";
		prv_mon_yn	= "";
		opt_add		= "";
		lpg_yn		= "";
		lpg_setter	= "";
		lpg_fee		= "";
		lpg_price	= 0;
		note		= "";
		use_yn		= "";
		reg_id		= "";
		reg_dt		= "";
		upd_id		= "";
		upd_dt		= "";
		tax_agnt	= "";
		tax_type	= "";
		car_no		= "";
		car_nm	    = "";
		car_name	= "";
		init_reg_dt = "";
		firm_nm	    = "";
		client_nm	= "";
		site_nm	    = "";
		ven_code    = "";
		print_st	= "";
		rent_way    = "";
		con_mon     = "";
		leave_day   = "";
		rent_start_dt= "";
		rent_end_dt = "";
		br_nm       = "";
		cms_bank    = "";
		cms_start_dt= "";
		cms_end_dt  = "";
		cms_day     = "";
		fee_amt	= 0;
		car_use		= "";
		jg_code		= "";
		s_st		= "";
		m_tel		= "";

	}

	//Set Method
	public void setRent_mng_id	(String val){	if(val==null) val="";		rent_mng_id		= val;		}
	public void setRent_l_cd	(String val){	if(val==null) val="";		rent_l_cd		= val;		}
	public void setCar_mng_id	(String val){	if(val==null) val="";		car_mng_id		= val;		}
	public void setClient_id	(String val){	if(val==null) val="";		client_id		= val;		}
	public void setSite_id		(String val){	if(val==null) val="";		site_id			= val;		}	
	public void setCar_type		(String val){	if(val==null) val="";		car_type		= val;		}	
	public void setRent_st		(String val){	if(val==null) val="";		rent_st			= val;		}
	public void setCar_st		(String val){	if(val==null) val="";		car_st			= val;		}
	public void setBus_st		(String val){	if(val==null) val="";		bus_st			= val;		}
	public void setRent_dt		(String val){	if(val==null) val="";		rent_dt			= val;		}
	public void setBr_id		(String val){	if(val==null) val="";		br_id			= val;		}
	public void setBus_id		(String val){	if(val==null) val="";		bus_id			= val;		}
	public void setBus_id2		(String val){	if(val==null) val="";		bus_id2			= val;		}
	public void setMng_id		(String val){	if(val==null) val="";		mng_id			= val;		}
	public void setMng_id2		(String val){	if(val==null) val="";		mng_id2			= val;		}
	public void setP_zip		(String val){	if(val==null) val="";		p_zip			= val;		}
	public void setP_addr		(String val){	if(val==null) val="";		p_addr			= val;		}
	public void setDriving_ext	(String val){	if(val==null) val="";		driving_ext		= val;		}
	public void setDriving_age	(String val){	if(val==null) val="";		driving_age		= val;		}
	public void setLoan_ext		(String val){	if(val==null) val="";		loan_ext		= val;		}
	public void setImm_amt		(int i){									imm_amt			= i;		}
	public void setImm_cau		(String val){	if(val==null) val="";		imm_cau			= val;		}
	public void setImm_nm		(String val){	if(val==null) val="";		imm_nm			= val;		}
	public void setGcp_kd		(String val){	if(val==null) val="";		gcp_kd			= val;		}
	public void setBacdt_kd		(String val){	if(val==null) val="";		bacdt_kd		= val;		}
	public void setIns_spe_chk	(String val){	if(val==null) val="";		ins_spe_chk		= val;		}
	public void setIns_spe_cont	(String val){	if(val==null) val="";		ins_spe_cont	= val;		}
	public void setGi_st		(String val){	if(val==null) val="";		gi_st			= val;		}
	public void setGi_cau		(String val){	if(val==null) val="";		gi_cau			= val;		}
	public void setGi_nm		(String val){	if(val==null) val="";		gi_nm			= val;		}
	public void setPrv_dlv_yn	(String val){	if(val==null) val="";		prv_dlv_yn		= val;		}
	public void setPrv_mon_yn	(String val){	if(val==null) val="";		prv_mon_yn		= val;		}
	public void setOpt_add		(String val){	if(val==null) val="";		opt_add			= val;		}
	public void setLpg_yn		(String val){	if(val==null) val="";		lpg_yn			= val;		}
	public void setLpg_setter	(String val){	if(val==null) val="";		lpg_setter		= val;		}
	public void setLpg_fee		(String val){	if(val==null) val="";		lpg_fee			= val;		}
	public void setLpg_price	(int i){									lpg_price		= i;		}
	public void setNote			(String val){	if(val==null) val="";		note			= val;		}
	public void setUse_yn		(String val){	if(val==null) val="";		use_yn			= val;		}
	public void setReg_id		(String val){	if(val==null) val="";		reg_id			= val;		}
	public void setReg_dt		(String val){	if(val==null) val="";		reg_dt			= val;		}
	public void setUpd_id		(String val){	if(val==null) val="";		upd_id			= val;		}
	public void setUpd_dt		(String val){	if(val==null) val="";		upd_dt			= val;		}
	public void setTax_agnt		(String val){	if(val==null) val="";		tax_agnt		=  val;		}
	public void setTax_type		(String val){	if(val==null) val="";		tax_type		=  val;		}
	public void setCar_no		(String val){	if(val==null) val="";		car_no			=  val;		}
	public void setCar_nm	    (String val){	if(val==null) val="";		car_nm			=  val;		}
	public void setCar_name		(String val){	if(val==null) val="";		car_name		=  val;		}	
	public void setInit_reg_dt	(String val){	if(val==null) val="";		init_reg_dt		=  val;		}	
	public void setFirm_nm	    (String val){	if(val==null) val="";		firm_nm			=  val;		}
	public void setClient_nm	(String val){	if(val==null) val="";		client_nm		=  val;		}
	public void setSite_nm	    (String val){	if(val==null) val="";		site_nm			=  val;		}
	public void setVen_code	    (String val){	if(val==null) val="";		ven_code		=  val;		}
	public void setPrint_st		(String val){	if(val==null) val="";		print_st		=  val;		}
	public void setRent_way		(String val){	if(val==null) val="";		rent_way		=  val;		}
	public void setCon_mon		(String val){	if(val==null) val="";		con_mon			=  val;		}
	public void setLeave_day	(String val){	if(val==null) val="";		leave_day		=  val;		}
	public void setRent_start_dt(String val){	if(val==null) val="";		rent_start_dt	=  val;		}
	public void setRent_end_dt	(String val){	if(val==null) val="";		rent_end_dt		=  val;		}
	public void setBr_nm		(String val){	if(val==null) val="";		br_nm			=  val;		}
	public void setCms_bank		(String val){	if(val==null) val="";		cms_bank		=  val;		}
	public void setCms_start_dt	(String val){	if(val==null) val="";		cms_start_dt	=  val;		}
	public void setCms_end_dt	(String val){	if(val==null) val="";		cms_end_dt		=  val;		}
	public void setCms_day		(String val){	if(val==null) val="";		cms_day			=  val;		}
	public void setFee_amt		(int i){									fee_amt			= i;		}
	public void setCar_use		(String val){	if(val==null) val="";		car_use			=  val;		}	
	public void setJg_code		(String val){	if(val==null) val="";		jg_code			=  val;		}	
	public void setS_st			(String val){	if(val==null) val="";		s_st			=  val;		}	
	public void setM_tel		(String val){	if(val==null) val="";		m_tel			=  val;		}	

	//Get Method
	public String getRent_mng_id	(){		return		rent_mng_id;	}
	public String getRent_l_cd		(){		return		rent_l_cd;		}
	public String getCar_mng_id		(){		return		car_mng_id;		}
	public String getClient_id		(){		return		client_id;		}
	public String getSite_id		(){		return		site_id;		}	
	public String getCar_type		(){		return		car_type;		}	
	public String getRent_st		(){		return		rent_st;		}
	public String getCar_st			(){		return		car_st;			}
	public String getBus_st			(){		return		bus_st;			}
	public String getRent_dt		(){		return		rent_dt;		}
	public String getBr_id			(){		return		br_id;			}
	public String getBus_id			(){		return		bus_id;			}
	public String getBus_id2		(){		return		bus_id2;		}
	public String getMng_id			(){		return		mng_id;			}
	public String getMng_id2		(){		return		mng_id2;		}
	public String getP_zip			(){		return		p_zip;			}
	public String getP_addr			(){		return		p_addr;			}
	public String getDriving_ext	(){		return		driving_ext;	}
	public String getDriving_age	(){		return		driving_age;	}
	public String getLoan_ext		(){		return		loan_ext;		}
	public int getImm_amt			(){		return		imm_amt;		}
	public String getImm_cau		(){		return		imm_cau;		}
	public String getImm_nm			(){		return		imm_nm;			}
	public String getGcp_kd			(){		return		gcp_kd;			}
	public String getBacdt_kd		(){		return		bacdt_kd;		}
	public String getIns_spe_chk	(){		return		ins_spe_chk;	}
	public String getIns_spe_cont	(){		return		ins_spe_cont;	}
	public String getGi_st			(){		return		gi_st;			}
	public String getGi_cau			(){		return		gi_cau;			}
	public String getGi_nm			(){		return		gi_nm;			}
	public String getPrv_dlv_yn		(){		return		prv_dlv_yn;		}
	public String getPrv_mon_yn		(){		return		prv_mon_yn;		}
	public String getOpt_add		(){		return		opt_add;		}
	public String getLpg_yn			(){		return		lpg_yn;			}
	public String getLpg_setter		(){		return		lpg_setter;		}
	public String getLpg_fee		(){		return		lpg_fee;		}
	public int getLpg_price			(){		return		lpg_price;		}
	public String getNote			(){		return		note;			}
	public String getUse_yn			(){		return		use_yn;			}
	public String getReg_id			(){		return		reg_id;			}
	public String getReg_dt			(){		return		reg_dt;			}
	public String getUpd_id			(){		return		upd_id;			}
	public String getUpd_dt			(){		return		upd_dt;			}

	public String getTax_agnt		(){		return		tax_agnt;		}
	public String getTax_type		(){		return		tax_type;	 	}
	public String getCar_no			(){		return		car_no;		 	}
	public String getCar_nm			(){		return		car_nm;	     	}
	public String getCar_name		(){		return		car_name;	 	}	
	public String getInit_reg_dt	(){		return		init_reg_dt;  	}	
	public String getFirm_nm	    (){		return		firm_nm;	   	}
	public String getClient_nm		(){		return		client_nm;		}
	public String getSite_nm	    (){		return		site_nm;	   	}
	public String getVen_code	    (){		return		ven_code;	   	}
	public String getPrint_st		(){		return		print_st;	 	}
	public String getRent_way		(){		return		rent_way;     	}
	public String getCon_mon		(){		return		con_mon;      	}
	public String getLeave_day		(){		return		leave_day;     	}
	public String getRent_start_dt	(){		return		rent_start_dt;	}
	public String getRent_end_dt	(){		return		rent_end_dt;  	}
	public String getBr_nm			(){		return		br_nm;        	}
	public String getCms_bank		(){		return		cms_bank;     	}
	public String getCms_start_dt	(){		return		cms_start_dt; 	}
	public String getCms_end_dt		(){		return		cms_end_dt;   	}
	public String getCms_day		(){		return		cms_day;      	}
	public int	  getFee_amt		(){		return		fee_amt;		}
	public String getCar_use		(){		return		car_use;	 	}	
	public String getJg_code		(){		return		jg_code;	 	}	
	public String getS_st			(){		return		s_st;		 	}	
	public String getM_tel			(){		return		m_tel;		 	}	

}
