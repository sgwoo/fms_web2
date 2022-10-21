package acar.consignment;

import java.util.*;

public class ConsignmentBean {
    //Table : consignment
    private String cons_no;     
    private int     seq;         
    private String cons_st;
    private int     cons_su;
    private String reg_code;
    private String off_id;   
    private String off_nm;   
	private String car_mng_id;    
	private String rent_mng_id; 
    private String rent_l_cd;       
    private String client_id;    
    private String car_no;      
    private String car_nm;  
    private String cons_cau;    
    private String cons_cau_etc;    
    private String cost_st;    
    private String pay_st;    
    private String from_st;  
	private String from_place;  
    private String from_comp;  
	private String from_title;  
    private String from_man;  
	private String from_tel;  
    private String from_m_tel;  
	private String from_req_dt;
	private String from_est_dt;  
    private String from_dt;     
    private String to_st;  
	private String to_place;  
    private String to_comp;  
	private String to_title;  
    private String to_man;  
	private String to_tel;  
    private String to_m_tel;  
	private String to_req_dt;  
	private String to_est_dt;  
    private String to_dt;     
    private String driver_nm;   
    private String driver_m_tel;
	private String wash_yn;    
    private String oil_yn;    
    private int     oil_liter;
    private int     oil_est_amt;
    private String etc;       
    private int     cons_amt;    
    private int     wash_amt;    
	private int     oil_amt;     
    private String other;       
	private int     other_amt;   
    private int     tot_amt;   
    private String pay_dt;      
    private String req_dt;      
    private String req_code;      
    private int     cust_amt;   
    private String cust_pay_dt;      
    private String conf_dt;      
    private String cons_copy;         
    private String reg_id;
    private String reg_dt;
    private String out_ok;
    private String cmp_app;
    private String after_yn;
    private int     tot_dist;   
    private String req_id;
	private String f_man;
	private String d_man;
	private String mm_seq;
	private String mm_content;
	private String mm_car_no1;
	private String mm_car_no2;
	private String mm_req_nm;
	private String mm_cons_dt;
    private String hipass_yn;    
    private int     hipass_amt;
    private String m_doc_code;    
    private int     m_amt;
    private String cancel_id;    
    private String cancel_dt;    
    private String dlv_dt;    
    private String udt_yn;    
    private String udt_dt;    
    private String udt_id;    
    private String cng_st;    
    private String cng_cont;    
	private String udt_mng_id	;
	private String udt_mng_nm	;
	private String udt_mng_tel	;
	private String udt_firm		;
	private String udt_addr		;
	private String driver_ssn	;   
	private String settle_id	;
	private String settle_dt	;
    private String driver_nm2;   
    private String driver_m_tel2;
	private int     oil_card_amt;     	//20140826 주유카드 사용 금액
	private String parking_file;
	private String psoilamt_file;
	private String agent_emp_id;
	private int     wash_fee;				//20190509 세차수수료
	//배달탁송 반품탁송
    private String return_dt;   
    private String return_id;
	private int    return_amt;
	private String rt_com_con_no;
	private String sub_l_cd;
	
	private int     wash_card_amt;     	//20220630 주유카드 사용 금액 (세차)
	
	private int     cons_other_amt;     //202207 외부탁송  - 아마존카  - 기타 
	
	private int     etc1_amt;     //202208 보증수리대행
	private int     etc2_amt;     //202208 검사대행
	

    // CONSTRCTOR            
    public ConsignmentBean () {  
    	this.cons_no				= "";
	    this.seq					= 0;
	    this.cons_st				= "";
	    this.cons_su				= 0;
	    this.reg_code			= "";
	    this.off_id					= "";
	    this.off_nm				= "";
		this.car_mng_id		= "";
		this.rent_mng_id		= "";
    	this.rent_l_cd			= "";
	    this.client_id			= "";
	    this.car_no				= "";
    	this.car_nm				= "";
	    this.cons_cau			= "";
	    this.cons_cau_etc		= "";
	    this.cost_st				= "";
	    this.pay_st				= "";
	    this.from_st				= "";
	    this.from_place		= "";
	    this.from_comp		= "";
	    this.from_title			= "";
	    this.from_man			= "";
	    this.from_tel			= "";
	    this.from_m_tel		= "";
	    this.from_req_dt		= "";
	    this.from_est_dt		= "";
    	this.from_dt				= "";
	    this.to_st					= "";
	    this.to_place			= "";
	    this.to_comp			= "";
	    this.to_title				= "";
	    this.to_man				= "";
	    this.to_tel				= "";
	    this.to_m_tel			= "";
	    this.to_req_dt			= "";
	    this.to_est_dt			= "";
    	this.to_dt					= "";
    	this.driver_nm			= "";
	    this.driver_m_tel		= "";
    	this.wash_yn			= "";
    	this.oil_yn				= "";
    	this.oil_liter				= 0;
    	this.oil_est_amt		= 0;
	    this.etc					= "";
    	this.cons_amt			= 0;
	    this.wash_amt			= 0;
		this.oil_amt				= 0;
	    this.other					= "";
		this.other_amt			= 0;
	    this.tot_amt				= 0;
    	this.pay_dt				= "";
    	this.req_dt				= "";
    	this.req_code			= "";
	    this.cust_amt			= 0;
    	this.cust_pay_dt		= "";
    	this.conf_dt				= "";
	    this.cons_copy			= "";
		this.reg_id				= "";
		this.reg_dt				= "";
		this.out_ok				= "";
		this.cmp_app			= "";
		this.after_yn			= "";
		this.tot_dist				= 0;
		this.req_id				= "";
		this.f_man				= "";
		this.d_man				= "";
		this.mm_seq			= "";
		this.mm_content		= "";
		this.mm_car_no1		= "";
		this.mm_car_no2		= "";
		this.mm_req_nm		= "";
		this.mm_cons_dt		= "";
	    this.hipass_yn			= "";
		this.hipass_amt		= 0;
	    this.m_doc_code		= "";
		this.m_amt				= 0;
		this.cancel_id			= "";
		this.cancel_dt			= "";
		this.dlv_dt				= "";
		this.udt_yn				= "";
		this.udt_dt				= "";
		this.udt_id				= "";
		this.cng_st				= "";
		this.cng_cont			= "";
		this.udt_mng_id		= "";
		this.udt_mng_nm		= "";
		this.udt_mng_tel		= "";
		this.udt_firm			= "";
		this.udt_addr			= "";
		this.driver_ssn			= "";
		this.settle_id			= "";
		this.settle_dt			= "";
    	this.driver_nm2		= "";
	    this.driver_m_tel2	= "";
		this.oil_card_amt		= 0;
		this.parking_file		= "";
		this.psoilamt_file		= "";
		this.agent_emp_id   = "";
		this.wash_fee   		= 0;		
		this.return_dt		= "";
		this.return_id   	= "";
		this.return_amt 	= 0;
		this.rt_com_con_no = "";
		this.sub_l_cd = "";
		this.wash_card_amt   		= 0;		
		this.cons_other_amt   		= 0;		
		this.etc1_amt   		= 0;		
		this.etc2_amt   		= 0;		

	}


	// get Method
	public void setCons_no			(String val){		if(val==null) val="";		this.cons_no			= val;	}
	public void setSeq					(int     val){									this.seq			= val;					}
	public void setCons_st				(String val){		if(val==null) val="";		this.cons_st			= val;	}
	public void setCons_su			(int     val){									this.cons_su		= val;					}
	public void setReg_code			(String val){		if(val==null) val="";		this.reg_code		= val;	}
	public void setOff_id				(String val){		if(val==null) val="";		this.off_id				= val;	}
	public void setOff_nm				(String val){		if(val==null) val="";		this.off_nm			= val;	}
	public void setCar_mng_id		(String val){		if(val==null) val="";		this.car_mng_id	= val;	}
	public void setRent_mng_id		(String val){		if(val==null) val="";		this.rent_mng_id	= val;	}
	public void setRent_l_cd			(String val){		if(val==null) val="";		this.rent_l_cd		= val;	}
	public void setClient_id			(String val){		if(val==null) val="";		this.client_id		= val;	}
	public void setCar_no				(String val){		if(val==null) val="";		this.car_no			= val;	}
	public void setCar_nm				(String val){		if(val==null) val="";		this.car_nm			= val;	}
	public void setCons_cau			(String val){		if(val==null) val="";		this.cons_cau		= val;	}
	public void setCons_cau_etc	(String val){		if(val==null) val="";		this.cons_cau_etc	= val;	}
	public void setCost_st				(String val){		if(val==null) val="";		this.cost_st			= val;	}
	public void setPay_st				(String val){		if(val==null) val="";		this.pay_st			= val;	}
	public void setFrom_st      		(String val){		if(val==null) val="";		this.from_st			= val;	}
	public void setFrom_place   	(String val){		if(val==null) val="";		this.from_place	= val;	}
	public void setFrom_comp    	(String val){		if(val==null) val="";		this.from_comp	= val;	}
	public void setFrom_title   		(String val){		if(val==null) val="";		this.from_title		= val;	}
	public void setFrom_man     	(String val){		if(val==null) val="";		this.from_man		= val;	}
	public void setFrom_tel	  		(String val){		if(val==null) val="";		this.from_tel		= val;	}
	public void setFrom_m_tel   	(String val){		if(val==null) val="";		this.from_m_tel	= val;	}
	public void setFrom_req_dt  	(String val){		if(val==null) val="";		this.from_req_dt	= val;	}
	public void setFrom_est_dt  	(String val){		if(val==null) val="";		this.from_est_dt	= val;	}
	public void setFrom_dt      		(String val){		if(val==null) val="";		this.from_dt			= val;	}
	public void setTo_st		  			(String val){		if(val==null) val="";		this.to_st				= val;	}
	public void setTo_place     		(String val){		if(val==null) val="";		this.to_place		= val;	}
	public void setTo_comp      		(String val){		if(val==null) val="";		this.to_comp		= val;	}
	public void setTo_title     		(String val){		if(val==null) val="";		this.to_title			= val;	}
	public void setTo_man       		(String val){		if(val==null) val="";		this.to_man			= val;	}
	public void setTo_tel	      		(String val){		if(val==null) val="";		this.to_tel			= val;	}
	public void setTo_m_tel     		(String val){		if(val==null) val="";		this.to_m_tel		= val;	}
	public void setTo_req_dt    		(String val){		if(val==null) val="";		this.to_req_dt		= val;	}
	public void setTo_est_dt    		(String val){		if(val==null) val="";		this.to_est_dt		= val;	}
	public void setTo_dt        		(String val){		if(val==null) val="";		this.to_dt				= val;	}
	public void setDriver_nm			(String val){		if(val==null) val="";		this.driver_nm		= val;	}
	public void setDriver_m_tel		(String val){		if(val==null) val="";		this.driver_m_tel	= val;	}
	public void setWash_yn    		(String val){		if(val==null) val="";		this.wash_yn		= val;	}
	public void setOil_yn     			(String val){		if(val==null) val="";		this.oil_yn			= val;	}
	public void setOil_liter  			(int     val){									this.oil_liter			= val;				}
	public void setOil_est_amt		(int     val){									this.oil_est_amt	= val;				}
	public void setEtc					(String val){		if(val==null) val="";		this.etc				= val;	}
	public void setCons_amt			(int     val){									this.cons_amt		= val;				}
	public void setOil_amt				(int     val){									this.oil_amt			= val;				}
	public void setWash_amt			(int     val){									this.wash_amt		= val;				}
	public void setOther				(String val){		if(val==null) val="";		this.other				= val;	}
	public void setOther_amt		(int     val){									this.other_amt		= val;				}
	public void setTot_amt			(int     val){									this.tot_amt			= val;				}
	public void setPay_dt				(String val){		if(val==null) val="";		this.pay_dt			= val;	}
	public void setReq_dt				(String val){		if(val==null) val="";		this.req_dt			= val;	}
	public void setReq_code			(String val){		if(val==null) val="";		this.req_code		= val;	}
	public void setCust_amt			(int     val){									this.cust_amt		= val;				}
	public void setCust_pay_dt		(String val){		if(val==null) val="";		this.cust_pay_dt	= val;	}
	public void setConf_dt				(String val){		if(val==null) val="";		this.conf_dt			= val;	}
	public void setCons_copy		(String val){		if(val==null) val="";		this.cons_copy		= val;	}
	public void setReg_id				(String val){		if(val==null) val="";		this.reg_id			= val;	}
	public void setReg_dt				(String val){		if(val==null) val="";		this.reg_dt			= val;	}
	public void setOut_ok				(String val){		if(val==null) val="";		this.out_ok			= val;	}
	public void setCmp_app			(String val){		if(val==null) val="";		this.cmp_app		= val;	}
	public void setAfter_yn			(String val){		if(val==null) val="";		this.after_yn		= val;	}
	public void setTot_dist				(int     val){									this.tot_dist			= val;				}
	public void setReq_id				(String val){		if(val==null) val="";		this.req_id			= val;	}
	public void setF_man				(String val){		if(val==null) val="";		this.f_man			= val;	}
	public void setD_man				(String val){		if(val==null) val="";		this.d_man			= val;	}		
	public void setMm_seq			(String val){		if(val==null) val="";		this.mm_seq		= val;	}
	public void setMm_content		(String val){		if(val==null) val="";		this.mm_content	= val;	}
	public void setMm_car_no1		(String val){		if(val==null) val="";		this.mm_car_no1	= val;	}
	public void setMm_car_no2		(String val){		if(val==null) val="";		this.mm_car_no2	= val;	}
	public void setMm_req_nm		(String val){		if(val==null) val="";		this.mm_req_nm	= val;	}
	public void setMm_cons_dt		(String val){		if(val==null) val="";		this.mm_cons_dt	= val;	}
	public void setHipass_yn			(String val){		if(val==null) val="";		this.hipass_yn      = val;	}
	public void setHipass_amt		(int     val){									this.hipass_amt		= val;			}
	public void setM_doc_code		(String val){		if(val==null) val="";		this.m_doc_code  = val;	}
	public void setM_amt				(int     val){									this.m_amt				= val;			}
	public void setCancel_id			(String val){		if(val==null) val="";		this.cancel_id		= val;	}
	public void setCancel_dt			(String val){		if(val==null) val="";		this.cancel_dt		= val;	}
	public void setDlv_dt				(String val){		if(val==null) val="";		this.dlv_dt			= val;	}
	public void setUdt_yn				(String val){		if(val==null) val="";		this.udt_yn			= val;	}
	public void setUdt_dt				(String val){		if(val==null) val="";		this.udt_dt			= val;	}
	public void setUdt_id				(String val){		if(val==null) val="";		this.udt_id			= val;	}
	public void setCng_st				(String val){		if(val==null) val="";		this.cng_st			= val;	}
	public void setCng_cont			(String val){		if(val==null) val="";		this.cng_cont		= val;	}
	public void setUdt_mng_id		(String val){		if(val==null) val="";		this.udt_mng_id	= val;	}	
	public void setUdt_mng_nm	(String val){		if(val==null) val="";		this.udt_mng_nm	= val;	}	
	public void setUdt_mng_tel		(String val){		if(val==null) val="";		this.udt_mng_tel	= val;	}	
	public void setUdt_firm			(String val){		if(val==null) val="";		this.udt_firm		= val;	}	
	public void setUdt_addr			(String val){		if(val==null) val="";		this.udt_addr		= val;	}	
	public void setDriver_ssn		(String val){		if(val==null) val="";		this.driver_ssn		= val;	}
	public void setSettle_id			(String val){		if(val==null) val="";		this.settle_id		= val;	}	
	public void setSettle_dt			(String val){		if(val==null) val="";		this.settle_dt		= val;	}	
	public void setDriver_nm2		(String val){		if(val==null) val="";		this.driver_nm2	= val;	}
	public void setDriver_m_tel2	(String val){		if(val==null) val="";		this.driver_m_tel2= val;	}
	public void setOil_card_amt	(int     val){									this.oil_card_amt		= val;			}
	public void setParking_file		(String val){		if(val==null) val="";		this.parking_file	 = val;	}
	public void setPsoilamt_file		(String val){		if(val==null) val="";		this.psoilamt_file	 = val;	}
	public void setAgent_emp_id	(String val){		if(val==null) val="";		this.agent_emp_id= val;	}
	public void setWash_fee			(int     val){									this.wash_fee			= val;			}
	public void setReturn_dt	(String val){		if(val==null) val="";		this.return_dt	= val;	}
	public void setReturn_id	(String val){		if(val==null) val="";		this.return_id	= val;	}
	public void setReturn_amt	(int     val){									this.return_amt	= val;	}
	public void setRt_com_con_no(String val){		if(val==null) val="";		this.rt_com_con_no	= val;	}
	public void setSub_l_cd(String val){		if(val==null) val="";		this.sub_l_cd	= val;	}
	public void setWash_card_amt		(int     val){									this.wash_card_amt			= val;			}
	public void setCons_other_amt		(int     val){									this.cons_other_amt			= val;			}
	public void setEtc1_amt		(int     val){									this.etc1_amt			= val;			}
	public void setEtc2_amt		(int     val){									this.etc2_amt			= val;			}
	
	
	//Get Method
	public String getCons_no				(){		return cons_no;					}
	public int     getSeq						(){		return seq;							}
	public String getCons_st				(){		return cons_st;					}
	public int     getCons_su				(){		return cons_su;					}
	public String getReg_code			(){		return reg_code;					}
	public String getOff_id					(){		return off_id;						}
	public String getOff_nm				(){		return off_nm;						}
	public String getCar_mng_id		(){		return car_mng_id;				}
	public String getRent_mng_id		(){		return rent_mng_id;			}
	public String getRent_l_cd			(){		return rent_l_cd;					}
	public String getClient_id				(){		return client_id;					}
	public String getCar_no				(){		return car_no;						}
	public String getCar_nm				(){		return car_nm;					}
	public String getCons_cau			(){		return cons_cau;					}
	public String getCons_cau_etc		(){		return cons_cau_etc;			}
	public String getCost_st				(){		return cost_st;						}
	public String getPay_st					(){		return pay_st;						}
	public String getFrom_st      		(){		return from_st;					}
	public String getFrom_place   		(){		return from_place;				}
	public String getFrom_comp    		(){		return from_comp;				}
	public String getFrom_title   		(){		return from_title;					}
	public String getFrom_man     		(){		return from_man;				}
	public String getFrom_tel	  			(){		return from_tel;					}
	public String getFrom_m_tel   		(){		return from_m_tel;				}
	public String getFrom_req_dt  		(){		return from_req_dt;				}
	public String getFrom_est_dt  		(){		return from_est_dt;				}
	public String getFrom_dt      		(){		return from_dt;					}
	public String getTo_st		  			(){		return to_st;						}
	public String getTo_place     		(){		return to_place;					}
	public String getTo_comp      		(){		return to_comp;					}
	public String getTo_title     			(){		return to_title;						}
	public String getTo_man       		(){		return to_man;					}
	public String getTo_tel	      			(){		return to_tel;						}
	public String getTo_m_tel     		(){		return to_m_tel;					}
	public String getTo_req_dt    		(){		return to_req_dt;					}
	public String getTo_est_dt    		(){		return to_est_dt;					}
	public String getTo_dt        			(){		return to_dt;						}
	public String getDriver_nm			(){		return driver_nm;				}
	public String getDriver_m_tel		(){		return driver_m_tel;			}
	public String getWash_yn    			(){		return wash_yn;     				}
	public String getOil_yn     			(){		return oil_yn;      				}
	public int     getOil_liter  				(){		return oil_liter;   					}
	public int     getOil_est_amt			(){		return oil_est_amt; 				}
	public String getEtc						(){		return etc;         					}
	public int     getCons_amt			(){		return cons_amt;					}
	public int     getOil_amt				(){		return oil_amt;					}
	public int     getWash_amt			(){		return wash_amt;				}
	public String getOther					(){		return other;						}
	public int     getOther_amt			(){		return other_amt;				}
	public int     getTot_amt				(){		return tot_amt;					}
	public String getPay_dt				(){		return pay_dt;						}
	public String getReq_dt				(){		return req_dt;						}
	public String getReq_code			(){		return req_code;					}
	public int     getCust_amt			(){		return cust_amt;					}
	public String getCust_pay_dt		(){		return cust_pay_dt;				}
	public String getConf_dt				(){		return conf_dt;					}
	public String getCons_copy			(){		return cons_copy;				}
	public String getReg_id				(){		return reg_id;						}
	public String getReg_dt				(){		return reg_dt;						}
	public String getOut_ok				(){		return out_ok;						}
	public String getCmp_app			(){		return cmp_app;					}
	public String getAfter_yn				(){		return after_yn;					}
	public int     getTot_dist				(){		return tot_dist;					}
	public String getReq_id				(){		return req_id;						}
	public String getF_man				(){		return f_man;						}
	public String getD_man				(){		return d_man;						}
	public String getMm_seq				(){		return mm_seq;					}
	public String getMm_content		(){		return mm_content;				}
	public String getMm_car_no1		(){		return mm_car_no1;			}
	public String getMm_car_no2		(){		return mm_car_no2;			}
	public String getMm_req_nm		(){		return mm_req_nm;			}
	public String getMm_cons_dt		(){		return mm_cons_dt;			}
	public String getHipass_yn			(){		return hipass_yn;				}
	public int     getHipass_amt			(){		return hipass_amt;				}
	public String getM_doc_code		(){		return m_doc_code;			}
	public int     getM_amt					(){		return m_amt;						}
	public String getCancel_id			(){		return cancel_id;					}
	public String getCancel_dt			(){		return cancel_dt;					}
	public String getDlv_dt					(){		return dlv_dt;						}
	public String getUdt_yn				(){		return udt_yn;						}
	public String getUdt_dt				(){		return udt_dt;						}
	public String getUdt_id					(){		return udt_id;						}
	public String getCng_st				(){		return cng_st;						}
	public String getCng_cont			(){		return cng_cont;					}
	public String getUdt_mng_id		(){		return udt_mng_id	;			}
	public String getUdt_mng_nm		(){		return udt_mng_nm	;			}
	public String getUdt_mng_tel		(){		return udt_mng_tel	;			}
	public String getUdt_firm				(){		return udt_firm		;			}
	public String getUdt_addr				(){		return udt_addr		;			}
	public String getDriver_ssn			(){		return driver_ssn;				}
	public String getSettle_id				(){		return settle_id	;				}
	public String getSettle_dt				(){		return settle_dt	;				}	
	public String getDriver_nm2			(){		return driver_nm2;				}
	public String getDriver_m_tel2		(){		return driver_m_tel2;			}
	public int    	 getOil_card_amt		(){		return oil_card_amt;			}
	public String getParking_file			(){		return parking_file;				}
	public String getPsoilamt_file		(){		return psoilamt_file;			}
	public String getAgent_emp_id		(){		return agent_emp_id;			}
	public int 	 getWash_fee			(){		return wash_fee;					}	
	public String getReturn_dt		(){		return return_dt;			}
	public String getReturn_id		(){		return return_id;			}
	public int 	  getReturn_amt		(){		return return_amt;			}
	public String getRt_com_con_no		(){		return rt_com_con_no;			}
	public String getSub_l_cd		(){		return sub_l_cd;			}
	public int    	 getWash_card_amt		(){		return wash_card_amt;			}
	public int    	 getCons_other_amt		(){		return cons_other_amt;			}	
	
	public int    	 getEtc1_amt		(){		return etc1_amt;			}
	public int    	 getEtc2_amt		(){		return etc2_amt;			}

}