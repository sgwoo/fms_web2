package acar.car_office;

import java.util.*;

public class CarOffPreBean {
	private int	   seq;
	private int	   r_seq;
	private String car_off_nm; 					
	private String com_con_no;
	private String car_nm;
	private String opt;
	private String colo;
	private int	   car_amt;
	private int	   con_amt;
	private String con_pay_dt;
	private String dlv_est_dt;
	private String reg_id;
	private String reg_dt;
	private String etc;
	private String use_yn;
	private String cls_dt;
	private String bus_nm;
	private String firm_nm;
	private String addr;
	private String res_cls_dt;
	private String rent_l_cd;
	private String in_col;
	private String req_dt;	//요청일자 추가(20181108)
	private String cust_tel;
	private String memo;
	private String pre_out_yn;	//즉시출고여부
	private String eco_yn;	//친환경차여부
	private String garnish_col;
	private String confirm_dt;
	private String agent_view_yn;
	private String bus_tel;
	private String bus_self_yn;
	private String q_reg_dt;
	private String cust_q;
	private String con_bank	;
	private String con_acc_no;
	private String con_acc_nm;
	private String con_est_dt;
	private String trf_st0;
	private String acc_st0;
	private String car_off_id;

	
    // CONSTRCTOR            
    public CarOffPreBean() {  
		this.seq			= 0; 					
		this.r_seq			= 0;
		this.car_off_nm		= "";
		this.com_con_no		= "";
		this.car_nm			= "";
		this.opt			= "";
		this.colo			= "";
		this.car_amt		= 0;
		this.con_amt		= 0;
		this.con_pay_dt		= "";
		this.dlv_est_dt		= "";
		this.reg_id			= "";
		this.reg_dt			= "";
		this.etc			= "";
		this.use_yn			= "";
		this.cls_dt			= "";
		this.bus_nm			= "";
		this.firm_nm		= "";
		this.addr			= "";
		this.res_cls_dt		= "";		
		this.rent_l_cd		= "";	
		this.in_col			= "";
		this.req_dt			= "";	//요청일자 추가(20181108)
		this.cust_tel		= "";
		this.memo			= "";
		this.pre_out_yn		= "";	//즉시출고여부
		this.eco_yn			= "";	//친환경차여부
		this.garnish_col	= "";
		this.confirm_dt 	= "";
		this.agent_view_yn	= "";
		this.bus_tel		= "";
		this.bus_self_yn    = "";
		this.q_reg_dt       = "";
		this.cust_q			= "";
		this.con_bank		= "";
		this.con_acc_no		= "";
		this.con_acc_nm		= "";
		this.con_est_dt		= "";
		this.trf_st0		= "";
		this.acc_st0		= "";
		this.car_off_id		= "";
	}

	// get Method
	public void setSeq				(int    val){		                    	this.seq			= val;	}
	public void setR_seq			(int    val){		                    	this.r_seq			= val;	}
	public void setCar_off_nm		(String val){		if(val==null) val="";	this.car_off_nm		= val;	}	
	public void setCom_con_no		(String val){		if(val==null) val="";	this.com_con_no		= val;	}
	public void setCar_nm			(String val){		if(val==null) val="";	this.car_nm			= val;	}	
	public void setOpt				(String val){		if(val==null) val="";	this.opt			= val;	}	
	public void setColo				(String val){		if(val==null) val="";	this.colo			= val;	}	
	public void setCar_amt			(int    val){		                        this.car_amt		= val;	}	
	public void setCon_amt			(int    val){		                        this.con_amt		= val;	}	
	public void setCon_pay_dt		(String val){		if(val==null) val="";	this.con_pay_dt		= val;	}	
	public void setDlv_est_dt		(String val){		if(val==null) val="";	this.dlv_est_dt		= val;	}	
	public void setReg_id			(String val){		if(val==null) val="";	this.reg_id			= val;	}	
	public void setReg_dt			(String val){		if(val==null) val="";	this.reg_dt			= val;	}	
	public void setEtc				(String val){		if(val==null) val="";	this.etc			= val;	}	
	public void setUse_yn			(String val){		if(val==null) val="";	this.use_yn			= val;	}	
	public void setCls_dt			(String val){		if(val==null) val="";	this.cls_dt			= val;	}	
	public void setBus_nm			(String val){		if(val==null) val="";	this.bus_nm			= val;	}	
	public void setFirm_nm			(String val){		if(val==null) val="";	this.firm_nm		= val;	}	
	public void setAddr				(String val){		if(val==null) val="";	this.addr			= val;	}	
	public void setRes_cls_dt		(String val){		if(val==null) val="";	this.res_cls_dt		= val;	}	
	public void setRent_l_cd		(String val){		if(val==null) val="";	this.rent_l_cd		= val;	}	
	public void setIn_col			(String val){		if(val==null) val="";	this.in_col			= val;	}
	public void setReq_dt			(String val){		if(val==null) val="";	this.req_dt			= val;	}	
	public void setCust_tel			(String val){		if(val==null) val="";	this.cust_tel		= val;	}	
	public void setMemo				(String val){		if(val==null) val="";	this.memo			= val;	}
	public void setPre_out_yn		(String val){		if(val==null) val="";	this.pre_out_yn		= val;	}	
	public void setEco_yn			(String val){		if(val==null) val="";	this.eco_yn			= val;	}
	public void setGarnish_col		(String val){		if(val==null) val="";	this.garnish_col	= val;	}
	public void setConfirm_dt		(String val){		if(val==null) val="";	this.confirm_dt		= val;	}
	public void setAgent_view_yn	(String val){		if(val==null) val="";	this.agent_view_yn	= val;	}
	public void setBus_tel			(String val){		if(val==null) val="";	this.bus_tel		= val;	}
	public void setBus_self_yn		(String val){		if(val==null) val="";	this.bus_self_yn	= val;	}
	public void setQ_reg_dt			(String val){		if(val==null) val="";	this.q_reg_dt		= val;	}
	public void setCust_q			(String val){		if(val==null) val="";	this.cust_q			= val;	}
	public void setCon_bank			(String val){		if(val==null) val="";	this.con_bank		= val;	}
	public void setCon_acc_no		(String val){		if(val==null) val="";	this.con_acc_no		= val;	}
	public void setCon_acc_nm		(String val){		if(val==null) val="";	this.con_acc_nm		= val;	}
	public void setCon_est_dt		(String val){		if(val==null) val="";	this.con_est_dt		= val;	}
	public void setTrf_st0			(String val){		if(val==null) val="";	this.trf_st0		= val;	}
	public void setAcc_st0			(String val){		if(val==null) val="";	this.acc_st0		= val;	}
	public void setCar_off_id		(String val){		if(val==null) val="";	this.car_off_id		= val;	}
	
	
	//Get Method
	public int    getSeq			(){		return seq;           }
	public int    getR_seq			(){		return r_seq;         }
	public String getCar_off_nm		(){		return car_off_nm;	  }
	public String getCom_con_no		(){		return com_con_no;    }	
	public String getCar_nm			(){		return car_nm;        }	
	public String getOpt			(){		return opt;           }	
	public String getColo			(){		return colo;          }	
	public int    getCar_amt		(){		return car_amt;       }	
	public int    getCon_amt		(){		return con_amt;       }	
	public String getCon_pay_dt		(){		return con_pay_dt;    }		
	public String getDlv_est_dt		(){		return dlv_est_dt;    }	
	public String getReg_id			(){		return reg_id;        }	
	public String getReg_dt			(){		return reg_dt;        }	
	public String getEtc			(){		return etc;           }		
	public String getUse_yn			(){		return use_yn;        }		
	public String getCls_dt			(){		return cls_dt;        }	
	public String getBus_nm			(){		return bus_nm;        }		
	public String getFirm_nm		(){		return firm_nm;       }		
	public String getAddr			(){		return addr;          }		
	public String getRes_cls_dt		(){		return res_cls_dt;    }
	public String getRent_l_cd		(){		return rent_l_cd;	  }
	public String getIn_col			(){		return in_col;        }
	public String getReq_dt			(){		return req_dt;        }	
	public String getCust_tel		(){		return cust_tel;      }	
	public String getMemo			(){		return memo;	      }
	public String getPre_out_yn		(){		return pre_out_yn;	  }	
	public String getEco_yn			(){		return eco_yn;	   	  }	
	public String getGarnish_col	(){		return garnish_col;   }
	public String getConfirm_dt		(){		return confirm_dt; 	  }
	public String getAgent_view_yn	(){		return agent_view_yn; }
	public String getBus_tel		(){		return bus_tel;  	  }
	public String getBus_self_yn	(){		return bus_self_yn;	  }
	public String getQ_reg_dt		(){		return q_reg_dt;	  }
	public String getCust_q			(){		return cust_q;        }
	public String getCon_bank		(){		return con_bank;	 }
	public String getCon_acc_no		(){		return con_acc_no;   }	
	public String getCon_acc_nm		(){		return con_acc_nm;	 }	
	public String getCon_est_dt		(){		return con_est_dt;	 }	
	public String getTrf_st0		(){		return trf_st0;	     }	
	public String getAcc_st0		(){		return acc_st0;	     }
	public String getCar_off_id		(){		return car_off_id;	  }
	
}