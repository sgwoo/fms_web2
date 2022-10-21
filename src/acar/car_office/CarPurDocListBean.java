package acar.car_office;

public class CarPurDocListBean {
    //Table : car_pur_doc_list (자동차납품요청공문 리스트) + 협력업체계출관리
	private String doc_id; 					
	private String rent_mng_id;
	private String rent_l_cd;
	private String agnt_st;
	private String car_nm;
	private String opt;
	private String colo;
	private String purc_gu;
	private String req_dt;
	private String bus_nm;
	private String reg_id;
	private String reg_dt;
	private String upd_id;
	private String upd_dt;
	private String dlv_dt;
	private String auto;
	private String car_off_nm;
	private String car_amt;
	private String rent_l_cd1;
	private String rent_l_cd2;
	private String firm_nm;
	private String doc_st;
	private String cng_code;
	private String cng_cau;
	private String udt_st;
	private String com_con_no	;
	private int    car_c_amt	;
	private int    car_f_amt	;
	private int    dc_amt		;
	private int    add_dc_amt	;
	private int    car_d_amt	;
	private int    car_g_amt	;
	private int    cons_amt		;
	private String dlv_st		;
	private String dlv_est_dt	;
	private String dlv_con_dt	;
	private String dlv_ext		;
	private String dlv_mng_id	;
	private String udt_mng_id	;
	private String udt_firm		;
	private String udt_addr		;
	private String con_id		;
	private String con_dt		;
	private String use_yn		;
	private String cng_st		;
	private String cng_cont		;
	private String cng_id		;
	private String cng_dt		;
	private String cng_yn		;
	private String udt_mng_nm	;
	private String udt_mng_tel	;
	private int    seq   		;
	private String bigo			;
	private String settle_id	;
	private String settle_dt	;
	private String car_comp_id	;
	private String dest_id		;
	private String send_id  	;
	private String msg      	;
	private String stock_yn		;
	private String stock_st		;
	private String car_off_id	;
	private String cons_off_nm	;
	private String cons_off_tel	;
	private String order_car	;
	private String order_req_id	;
	private String order_req_dt	;
	private String order_chk_id	;
	private String order_chk_dt	;
	private String suc_yn	    ;
	


	
    // CONSTRCTOR            
    public CarPurDocListBean() {  
		this.doc_id 		= ""; 					
		this.rent_mng_id	= "";
		this.rent_l_cd		= "";
		this.agnt_st		= "";
		this.car_nm			= "";
		this.opt			= "";
		this.colo			= "";
		this.purc_gu		= "";
		this.req_dt			= "";
		this.bus_nm			= "";
		this.reg_id			= "";
		this.reg_dt			= "";
		this.upd_id			= "";
		this.upd_dt			= "";
		this.dlv_dt			= "";
		this.auto			= "";
		this.car_off_nm		= "";
		this.car_amt		= "";
		this.rent_l_cd1		= "";
		this.rent_l_cd2		= "";
		this.firm_nm		= "";
		this.doc_st			= "";
		this.cng_code		= "";
		this.cng_cau		= "";
		this.udt_st			= "";
		this.com_con_no		= "";
		this.car_c_amt		= 0;
		this.car_f_amt		= 0;
		this.dc_amt			= 0;
		this.add_dc_amt		= 0;
		this.car_d_amt		= 0;
		this.car_g_amt		= 0;
		this.cons_amt		= 0;
		this.dlv_st			= "";
		this.dlv_est_dt		= "";
		this.dlv_con_dt		= "";
		this.dlv_ext		= "";
		this.dlv_mng_id		= "";
		this.udt_mng_id		= "";
		this.udt_firm		= "";
		this.udt_addr		= "";
		this.con_id			= "";
		this.con_dt			= "";
		this.use_yn			= "";
		this.cng_st			= "";
		this.cng_cont		= "";
		this.cng_id			= "";
		this.cng_dt			= "";
		this.cng_yn			= "";
		this.udt_mng_nm		= "";
		this.udt_mng_tel	= "";
		this.seq			= 0;
		this.bigo			= "";
		this.settle_id		= "";
		this.settle_dt		= "";
		this.car_comp_id	= "";
		this.dest_id		= "";
		this.send_id  		= "";
		this.msg      		= "";
		this.stock_yn		= "";
		this.stock_st		= "";
		this.car_off_id		= "";
		this.cons_off_nm	= "";
		this.cons_off_tel	= "";
		this.order_car		= "";
		this.order_req_id	= "";
		this.order_req_dt	= "";
		this.order_chk_id	= "";
		this.order_chk_dt	= "";
		this.suc_yn			= "";	
	
	}

	// get Method
	public void setDoc_id 			(String val){		if(val==null) val="";	this.doc_id 		= val;	}
	public void setRent_mng_id		(String val){		if(val==null) val="";	this.rent_mng_id	= val;	}
	public void setRent_l_cd		(String val){		if(val==null) val="";	this.rent_l_cd		= val;	}	
	public void setAgnt_st			(String val){		if(val==null) val="";	this.agnt_st		= val;	}
	public void setCar_nm			(String val){		if(val==null) val="";	this.car_nm			= val;	}	
	public void setOpt				(String val){		if(val==null) val="";	this.opt			= val;	}	
	public void setColo				(String val){		if(val==null) val="";	this.colo			= val;	}	
	public void setPurc_gu			(String val){		if(val==null) val="";	this.purc_gu		= val;	}	
	public void setReq_dt			(String val){		if(val==null) val="";	this.req_dt			= val;	}	
	public void setBus_nm			(String val){		if(val==null) val="";	this.bus_nm			= val;	}	
	public void setReg_id			(String val){		if(val==null) val="";	this.reg_id			= val;	}	
	public void setReg_dt			(String val){		if(val==null) val="";	this.reg_dt			= val;	}	
	public void setUpd_id			(String val){		if(val==null) val="";	this.upd_id			= val;	}	
	public void setUpd_dt			(String val){		if(val==null) val="";	this.upd_dt			= val;	}	
	public void setDlv_dt			(String val){		if(val==null) val="";	this.dlv_dt			= val;	}	
	public void setAuto				(String val){		if(val==null) val="";	this.auto			= val;	}	
	public void setCar_off_nm		(String val){		if(val==null) val="";	this.car_off_nm		= val;	}	
	public void setCar_amt			(String val){		if(val==null) val="";	this.car_amt		= val;	}	
	public void setRent_l_cd1		(String val){		if(val==null) val="";	this.rent_l_cd1		= val;	}	
	public void setRent_l_cd2		(String val){		if(val==null) val="";	this.rent_l_cd2		= val;	}	
	public void setFirm_nm			(String val){		if(val==null) val="";	this.firm_nm		= val;	}	
	public void setDoc_st			(String val){		if(val==null) val="";	this.doc_st			= val;	}	
	public void setCng_code			(String val){		if(val==null) val="";	this.cng_code		= val;	}	
	public void setCng_cau			(String val){		if(val==null) val="";	this.cng_cau		= val;	}	
	public void setUdt_st			(String val){		if(val==null) val="";	this.udt_st			= val;	}		
	public void setCom_con_no		(String val){		if(val==null) val="";	this.com_con_no		= val;	}	
	public void setCar_c_amt		(int val){									this.car_c_amt		= val;	}	
	public void setCar_f_amt		(int val){									this.car_f_amt		= val;	}	
	public void setDc_amt			(int val){									this.dc_amt			= val;	}	
	public void setAdd_dc_amt		(int val){									this.add_dc_amt		= val;	}	
	public void setCar_d_amt		(int val){									this.car_d_amt		= val;	}	
	public void setCar_g_amt		(int val){									this.car_g_amt		= val;	}	
	public void setCons_amt			(int val){									this.cons_amt		= val;	}	
	public void setDlv_st			(String val){		if(val==null) val="";	this.dlv_st			= val;	}	
	public void setDlv_est_dt		(String val){		if(val==null) val="";	this.dlv_est_dt		= val;	}	
	public void setDlv_con_dt		(String val){		if(val==null) val="";	this.dlv_con_dt		= val;	}	
	public void setDlv_ext			(String val){		if(val==null) val="";	this.dlv_ext		= val;	}	
	public void setDlv_mng_id		(String val){		if(val==null) val="";	this.dlv_mng_id		= val;	}	
	public void setUdt_mng_id		(String val){		if(val==null) val="";	this.udt_mng_id		= val;	}	
	public void setUdt_firm			(String val){		if(val==null) val="";	this.udt_firm		= val;	}	
	public void setUdt_addr			(String val){		if(val==null) val="";	this.udt_addr		= val;	}	
	public void setCon_id			(String val){		if(val==null) val="";	this.con_id			= val;	}	
	public void setCon_dt			(String val){		if(val==null) val="";	this.con_dt			= val;	}	
	public void setUse_yn			(String val){		if(val==null) val="";	this.use_yn			= val;	}	
	public void setCng_st			(String val){		if(val==null) val="";	this.cng_st			= val;	}	
	public void setCng_cont			(String val){		if(val==null) val="";	this.cng_cont		= val;	}	
	public void setCng_id			(String val){		if(val==null) val="";	this.cng_id			= val;	}	
	public void setCng_dt			(String val){		if(val==null) val="";	this.cng_dt			= val;	}	
	public void setCng_yn			(String val){		if(val==null) val="";	this.cng_yn			= val;	}	
	public void setUdt_mng_nm		(String val){		if(val==null) val="";	this.udt_mng_nm		= val;	}	
	public void setUdt_mng_tel		(String val){		if(val==null) val="";	this.udt_mng_tel	= val;	}	
	public void setSeq				(int val){									this.seq			= val;	}	
	public void setBigo				(String val){		if(val==null) val="";	this.bigo			= val;	}	
	public void setSettle_id		(String val){		if(val==null) val="";	this.settle_id		= val;	}	
	public void setSettle_dt		(String val){		if(val==null) val="";	this.settle_dt		= val;	}	
	public void setCar_comp_id		(String val){		if(val==null) val="";	this.car_comp_id	= val;	}	
	public void setDest_id			(String val){		if(val==null) val="";	this.dest_id		= val;	}	
	public void setSend_id  		(String val){		if(val==null) val="";	this.send_id  		= val;	}	
	public void setMsg      		(String val){		if(val==null) val="";	this.msg      		= val;	}	
	public void setStock_yn    		(String val){		if(val==null) val="";	this.stock_yn      	= val;	}	
	public void setStock_st    		(String val){		if(val==null) val="";	this.stock_st      	= val;	}	
	public void setCar_off_id		(String val){		if(val==null) val="";	this.car_off_id		= val;	}	
	public void setCons_off_nm		(String val){		if(val==null) val="";	this.cons_off_nm	= val;	}	
	public void setCons_off_tel		(String val){		if(val==null) val="";	this.cons_off_tel	= val;	}	
	public void setOrder_car		(String val){		if(val==null) val="";	this.order_car		= val;	}	
	public void setOrder_req_id		(String val){		if(val==null) val="";	this.order_req_id	= val;	}	
	public void setOrder_req_dt		(String val){		if(val==null) val="";	this.order_req_dt	= val;	}	
	public void setOrder_chk_id		(String val){		if(val==null) val="";	this.order_chk_id	= val;	}	
	public void setOrder_chk_dt		(String val){		if(val==null) val="";	this.order_chk_dt	= val;	}	
	public void setSuc_yn		    (String val){		if(val==null) val="";	this.suc_yn			= val;	}	
	
	

		
	//Get Method
	public String getDoc_id			(){		return doc_id; 			}
	public String getRent_mng_id	(){		return rent_mng_id; 	}
	public String getRent_l_cd		(){		return rent_l_cd;		}
	public String getAgnt_st		(){		return agnt_st;     	}	
	public String getCar_nm			(){		return car_nm;      	}	
	public String getOpt			(){		return opt;         	}	
	public String getColo			(){		return colo;        	}	
	public String getPurc_gu		(){		return purc_gu;     	}	
	public String getReq_dt			(){		return req_dt;      	}	
	public String getBus_nm			(){		return bus_nm;      	}		
	public String getReg_id			(){		return reg_id;      	}		
	public String getReg_dt			(){		return reg_dt;      	}	
	public String getUpd_id			(){		return upd_id;      	}	
	public String getUpd_dt			(){		return upd_dt;      	}	
	public String getDlv_dt			(){		return dlv_dt;      	}	
	public String getAuto			(){		return auto;			}	
	public String getCar_off_nm		(){		return car_off_nm;     	}	
	public String getCar_amt		(){		return car_amt;     	}
	public String getRent_l_cd1		(){		return rent_l_cd1;		}
	public String getRent_l_cd2		(){		return rent_l_cd2;		}
	public String getFirm_nm		(){		return firm_nm;			}
	public String getDoc_st			(){		return doc_st;			}
	public String getCng_code		(){		return cng_code;		}
	public String getCng_cau		(){		return cng_cau;			}
	public String getUdt_st			(){		return udt_st;			}
	public String getCom_con_no		(){		return com_con_no	;	}	
	public int    getCar_c_amt		(){		return car_c_amt	;	}	
	public int    getCar_f_amt		(){		return car_f_amt	;	}		
	public int    getDc_amt			(){		return dc_amt		;	}		
	public int    getAdd_dc_amt		(){		return add_dc_amt	;	}	
	public int    getCar_d_amt		(){		return car_d_amt	;	}	
	public int    getCar_g_amt		(){		return car_g_amt	;	}	
	public int    getCons_amt		(){		return cons_amt		;	}	
	public String getDlv_st			(){		return dlv_st		;	}	
	public String getDlv_est_dt		(){		return dlv_est_dt	;	}	
	public String getDlv_con_dt		(){		return dlv_con_dt	;	}	
	public String getDlv_ext		(){		return dlv_ext		;	}	
	public String getDlv_mng_id		(){		return dlv_mng_id	;	}
	public String getUdt_mng_id		(){		return udt_mng_id	;	}
	public String getUdt_firm		(){		return udt_firm		;	}
	public String getUdt_addr		(){		return udt_addr		;	}
	public String getCon_id			(){		return con_id		;	}
	public String getCon_dt			(){		return con_dt		;	}	
	public String getUse_yn			(){		return use_yn		;	}	
	public String getCng_st			(){		return cng_st		;	}	
	public String getCng_cont		(){		return cng_cont		;	}	
	public String getCng_id			(){		return cng_id		;	}
	public String getCng_dt			(){		return cng_dt		;	}
	public String getCng_yn			(){		return cng_yn		;	}
	public String getUdt_mng_nm		(){		return udt_mng_nm	;	}
	public String getUdt_mng_tel	(){		return udt_mng_tel	;	}
	public int    getSeq			(){		return seq			;	}
	public String getBigo			(){		return bigo			;	}
	public String getSettle_id		(){		return settle_id	;	}
	public String getSettle_dt		(){		return settle_dt	;	}	
	public String getCar_comp_id	(){		return car_comp_id	;	}	
	public String getDest_id		(){		return dest_id		;	}
	public String getSend_id  		(){		return send_id  	;	}	
	public String getMsg      		(){		return msg      	;	}	
	public String getStock_yn  		(){		return stock_yn    	;	}	
	public String getStock_st  		(){		return stock_st    	;	}	
	public String getCar_off_id		(){		return car_off_id	;  	}	
	public String getCons_off_nm	(){		return cons_off_nm	;  	}	
	public String getCons_off_tel	(){		return cons_off_tel	;  	}	
	public String getOrder_car		(){		return order_car	;  	}	
	public String getOrder_req_id	(){		return order_req_id	; 	}	
	public String getOrder_req_dt	(){		return order_req_dt	; 	}	
	public String getOrder_chk_id	(){		return order_chk_id	;  	}	
	public String getOrder_chk_dt	(){		return order_chk_dt	;  	}	
	public String getSuc_yn			(){		return suc_yn		;  	}	
	
	

}
