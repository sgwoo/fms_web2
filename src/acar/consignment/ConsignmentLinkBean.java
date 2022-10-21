package acar.consignment;

import java.util.*;

public class ConsignmentLinkBean {
    //Table : Consignment_Link
    private String cons_no;    
	private String tmsg_seq;    
    private String rent_l_cd;       
	private String dept_nm;
    private String car_no;      
    private String car_nm; 
	private String reg_ymd;
	private String reg_time;
    private String cons_cau;    
    private String firm_nm;  
	private String firm_ssn;  
    private String firm_addr;  
	private String firm_tel;  
    private String firm_m_tel;  
    private String acar_mng;  
	private String acar_tel;  
    private String off_nm;   
    private String off_drv;   
    private String off_drv_tel;
	private String start_km;
	private String end_km;
	private String firm_email;
	private String cons_yn;
	
	//채권양도통지서 및 위임장 변수(20181127)
	private String b_trf_yn;				//채권양도통지서 위임장 유무
	private String ins_com_nm;			//보험사명
	private String firm_zip;				//채권자 우편번호 (채권양도통지서용)
	private String client_nm;				//채권자 이름
	private String client_ssn;				//채권자 생년월일
	private String ins_req_amt;			//대차료
	private String ins_req_amt_han;	//대차료 한글
	private String ac_car_no;			//사고차량번호
	private String ac_car_nm;			//사고차량명
	private String accid_dt;				//사고일시
	private String ins_use_st;			//수리기간(시작일시)
	private String ins_use_et;			//수리기간(종료일시)
	private String client_st;				//고객구분 
	private String client_addr;			//고객 주소 (채권양도통지서용)


    // CONSTRCTOR            
    public ConsignmentLinkBean () {  
    	this.cons_no			= "";
		this.tmsg_seq		= "";
    	this.rent_l_cd		= "";
		this.dept_nm		= "";
	    this.car_no			= "";
    	this.car_nm			= "";
	    this.reg_ymd		= "";
		this.reg_time		= "";
	    this.cons_cau		= "";
	    this.firm_nm		= "";
	    this.firm_ssn		= "";
	    this.firm_addr		= "";
	    this.firm_tel			= "";
	    this.firm_m_tel		= "";
	    this.acar_mng		= "";
	    this.acar_tel			= "";
	    this.off_nm			= "";
    	this.off_drv			= "";
	    this.off_drv_tel		= "";
		this.start_km		= "";
		this.end_km			= "";
		this.firm_email		= "";
		this.cons_yn			= "";

		//채권양도통지서 및 위임장 변수(20181127)
		this.b_trf_yn				= "";	
		this.ins_com_nm			= "";		
		this.firm_zip					= "";			
		this.client_nm				= "";			
		this.client_ssn				= "";
		this.ins_req_amt			= "";		
		this.ins_req_amt_han	= "";	
		this.ac_car_no				= "";			
		this.ac_car_nm			= "";			
		this.accid_dt				= "";			
		this.ins_use_st				= "";		
		this.ins_use_et				= "";
		this.client_st				= "";	
		this.client_addr			= "";	

	}


	// get Method
	public void setCons_no		(String val){		if(val==null) val="";		this.cons_no			= val;	}
	public void setTmsg_seq		(String val){		if(val==null) val="";		this.tmsg_seq		= val;	}
	public void setRent_l_cd		(String val){		if(val==null) val="";		this.rent_l_cd		= val;	}
	public void setDept_nm		(String val){		if(val==null) val="";		this.dept_nm		= val;	}
	public void setCar_no			(String val){		if(val==null) val="";		this.car_no			= val;	}
	public void setCar_nm			(String val){		if(val==null) val="";		this.car_nm			= val;	}
	public void setReg_ymd		(String val){		if(val==null) val="";		this.reg_ymd		= val;	}
	public void setReg_time		(String val){		if(val==null) val="";		this.reg_time		= val;	}
	public void setCons_cau		(String val){		if(val==null) val="";		this.cons_cau		= val;	}
	public void setFirm_nm      	(String val){		if(val==null) val="";		this.firm_nm		= val;	}
	public void setFirm_ssn		(String val){		if(val==null) val="";		this.firm_ssn		= val;	}
	public void setFirm_addr    	(String val){		if(val==null) val="";		this.firm_addr		= val;	}
	public void setFirm_tel	  	(String val){		if(val==null) val="";		this.firm_tel			= val;	}
	public void setFirm_m_tel   (String val){		if(val==null) val="";		this.firm_m_tel		= val;	}
	public void setAcar_mng     (String val){		if(val==null) val="";		this.acar_mng		= val;	}
	public void setAcar_tel	    (String val){		if(val==null) val="";		this.acar_tel			= val;	}
	public void setOff_nm			(String val){		if(val==null) val="";		this.off_nm			= val;	}
	public void setOff_drv			(String val){		if(val==null) val="";		this.off_drv			= val;	}
	public void setOff_drv_tel	(String val){		if(val==null) val="";		this.off_drv_tel		= val;	}
	public void setStart_km		(String val){		if(val==null) val="";		this.start_km		= val;	}
	public void setEnd_km			(String val){		if(val==null) val="";		this.end_km			= val;	}
	public void setFirm_email	(String val){		if(val==null) val="";		this.firm_email		= val;	}
	public void setCons_yn		(String val){		if(val==null) val="";		this.cons_yn			= val;	}
	//채권양도통지서 및 위임장 변수(20181127)
	public void setB_trf_yn				(String val){		if(val==null) val="";		this.b_trf_yn				= val;	}
	public void setIns_com_nm			(String val){		if(val==null) val="";		this.ins_com_nm			= val;	}
	public void setFirm_zip				(String val){		if(val==null) val="";		this.firm_zip					= val;	}
	public void setClient_nm				(String val){		if(val==null) val="";		this.client_nm				= val;	}
	public void setClient_ssn				(String val){		if(val==null) val="";		this.client_ssn				= val;	}
	public void setIns_req_amt			(String val){		if(val==null) val="";		this.ins_req_amt			= val;	}
	public void setIns_req_amt_han	(String val){		if(val==null) val="";		this.ins_req_amt_han	= val;	}
	public void setAc_car_no				(String val){		if(val==null) val="";		this.ac_car_no				= val;	}
	public void setAc_car_nm			(String val){		if(val==null) val="";		this.ac_car_nm			= val;	}
	public void setAccid_dt				(String val){		if(val==null) val="";		this.accid_dt				= val;	}
	public void setIns_use_st			(String val){		if(val==null) val="";		this.ins_use_st				= val;	}
	public void setIns_use_et			(String val){		if(val==null) val="";		this.ins_use_et				= val;	}
	public void setClient_st				(String val){		if(val==null) val="";		this.client_st				= val;	}
	public void setClient_addr			(String val){		if(val==null) val="";		this.client_addr			= val;	}
	

	//Get Method
	public String getCons_no		(){		return cons_no;			}
	public String getTmsg_seq	(){		return tmsg_seq;			}
	public String getRent_l_cd	(){		return rent_l_cd;			}
	public String getDept_nm		(){		return dept_nm;			}
	public String getCar_no		(){		return car_no;				}
	public String getCar_nm		(){		return car_nm;			}
	public String getReg_ymd	(){		return reg_ymd;			}
	public String getReg_time	(){		return reg_time;			}
	public String getCons_cau	(){		return cons_cau;			}
	public String getFirm_nm		(){		return firm_nm;			}
	public String getFirm_ssn    	(){		return firm_ssn;			}
	public String getFirm_addr  	(){		return firm_addr;			}
	public String getFirm_tel    	(){		return firm_tel;			}
	public String getFirm_m_tel (){		return firm_m_tel;		}
	public String getAcar_mng   (){		return acar_mng;		}
	public String getAcar_tel      (){		return acar_tel;			}
	public String getOff_nm		(){		return off_nm;				}
	public String getOff_drv		(){		return off_drv;				}
	public String getOff_drv_tel	(){		return off_drv_tel;		}
	public String getStart_km		(){		return start_km;			}
	public String getEnd_km		(){		return end_km;			}
	public String getFirm_email	(){		return firm_email;		}
	public String getCons_yn		(){		return cons_yn;			}
	//채권양도통지서 및 위임장 변수(20181127)
	public String getB_trf_yn					(){		return b_trf_yn;				}
	public String getIns_com_nm			(){		return ins_com_nm;		}
	public String getFirm_zip					(){		return firm_zip;				}
	public String getClient_nm				(){		return client_nm;				}
	public String getClient_ssn				(){		return client_ssn;			}
	public String getIns_req_amt			(){		return ins_req_amt;			}
	public String getIns_req_amt_han	(){		return ins_req_amt_han;	}
	public String getAc_car_no				(){		return ac_car_no;			}
	public String getAc_car_nm				(){		return ac_car_nm;			}
	public String getAccid_dt					(){		return accid_dt;				}
	public String getIns_use_st				(){		return ins_use_st;			}
	public String getIns_use_et				(){		return ins_use_et;			}
	public String getClient_st					(){		return client_st;				}
	public String getClient_addr				(){		return client_addr;			}
}