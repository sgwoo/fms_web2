package acar.forfeit_mng;

import java.util.*;

public class FineDocListBean {
    //Table : fine_doc_list (과태료 이의신청공문 과태료 리스트)
	private String doc_id; 					
	private String car_mng_id;
	private int	   seq_no;
	private String rent_s_cd;
	private String firm_nm;
	private String ssn;
	private String enp_no;
	private String rent_start_dt;
	private String rent_end_dt;
	private String paid_no;
	private String reg_id;
	private String reg_dt;
	private String upd_id;
	private String upd_dt;
	private String car_no;
	private String scan_file;
	private String rent_mng_id;
	private String rent_l_cd;
	private String vio_dt;
	private String car_st;
	private int	   amt1;
	private int	   amt2;
	private int	   amt3;
	private int	   amt4;
	private int	   amt5;
	private int	   amt6;
	private int	   amt7;
	private int	   amt8;
	private int	   amt9;
	private String file_name;
	private String file_type;
	private String var1;
	private String var2;
	private String var3;

	private String client_id;
	private String chk;
	private String checker_st;
	private String serv_dt;
	private String rep_cont;
	private String serv_off_nm;
	
	private String ho_zip;			//과태료 공문에 고지서 발송주소용 우편번호
	private String ho_addr;			//과태료 공문에 고지서 발송주소용 주소
	private String fee_st;
	private String r_s_dt;
	private String r_e_dt;

	private String rent_st;

	private String sub_rent_mng_id;
	private String sub_rent_l_cd;
	private String lic_no;				//운전면허번호(20180629)
	private String client_st;			//고객 구분(20180704)
	private String vio_st;				//위반내용 구분(20190621)
	
	private String end_dt;
	private String cardno;
	private String card_dt;
	private String note;
	
    // CONSTRCTOR            
    public FineDocListBean() {  
    	
		this.doc_id 				= ""; 					
		this.car_mng_id				= "";
		this.seq_no					= 0;
		this.rent_s_cd				= "";
		this.firm_nm				= "";
		this.ssn						= "";
		this.enp_no					= "";
		this.rent_start_dt			= "";
		this.rent_end_dt			= "";
		this.paid_no					= "";
		this.reg_id					= "";
		this.reg_dt					= "";
		this.upd_id					= "";
		this.upd_dt					= "";
		this.car_no					= "";
		this.scan_file				= "";
		this.rent_mng_id			= "";
		this.rent_l_cd				= "";
		this.vio_dt					= "";
		this.car_st					= "";
		this.amt1						= 0;
		this.amt2						= 0;
		this.amt3						= 0;
		this.amt4						= 0;
		this.amt5						= 0;
		this.amt6						= 0;
		this.amt7						= 0;
		this.amt8						= 0;
		this.amt9						= 0;
		this.file_name				= "";
		this.file_type				= "";
		this.var1						= "";
		this.var2						= "";
		this.var3						= "";

		this.client_id				= "";
		this.chk						= "";
		this.checker_st				= "";
		this.serv_dt					= "";
		this.rep_cont				= "";
		this.serv_off_nm			= "";

		this.ho_zip 					= "";
		this.ho_addr 				= "";
		this.fee_st 					= "";
		this.r_s_dt					= "";
		this.r_e_dt					= "";

		this.rent_st 					= "";

		this.sub_rent_mng_id	= "";
		this.sub_rent_l_cd 		= "";
		this.lic_no 					= "";		//운전면허번호(20180629)
		this.client_st 				= "";		//고객 구분(20180704)
		this.vio_st 					= "";
		
		this.end_dt 				= "";
    	this.cardno 				= "";
    	this.card_dt 				= "";
    	this.note 					= "";
		
	}
	// get Method
    
	public void setDoc_id 					(String val){		if(val==null) val="";	this.doc_id 					= val;	}
	public void setCar_mng_id			(String val){		if(val==null) val="";	this.car_mng_id			= val;	}
	public void setSeq_no					(int val){												this.seq_no					= val;	}	
	public void setRent_s_cd				(String val){		if(val==null) val="";	this.rent_s_cd				= val;	}
	public void setFirm_nm				(String val){		if(val==null) val="";	this.firm_nm				= val;	}	
	public void setSsn						(String val){		if(val==null) val="";	this.ssn						= val;	}	
	public void setEnp_no					(String val){		if(val==null) val="";	this.enp_no					= val;	}	
	public void setRent_start_dt		(String val){		if(val==null) val="";	this.rent_start_dt			= val;	}	
	public void setRent_end_dt			(String val){		if(val==null) val="";	this.rent_end_dt			= val;	}	
	public void setPaid_no					(String val){		if(val==null) val="";	this.paid_no					= val;	}	
	public void setReg_id					(String val){		if(val==null) val="";	this.reg_id					= val;	}	
	public void setReg_dt					(String val){		if(val==null) val="";	this.reg_dt					= val;	}	
	public void setUpd_id					(String val){		if(val==null) val="";	this.upd_id					= val;	}	
	public void setUpd_dt					(String val){		if(val==null) val="";	this.upd_dt					= val;	}	
	public void setCar_no					(String val){		if(val==null) val="";	this.car_no					= val;	}	
	public void setScan_file				(String val){		if(val==null) val="";	this.scan_file				= val;	}	
	public void setRent_mng_id			(String val){		if(val==null) val="";	this.rent_mng_id			= val;	}	
	public void setRent_l_cd				(String val){		if(val==null) val="";	this.rent_l_cd				= val;	}	
	public void setVio_dt					(String val){		if(val==null) val="";	this.vio_dt					= val;	}	
	public void setCar_st					(String val){		if(val==null) val="";	this.car_st					= val;	}	
	public void setAmt1						(int val){												this.amt1						= val;	}	
	public void setAmt2						(int val){												this.amt2						= val;	}	
	public void setAmt3						(int val){												this.amt3						= val;	}	
	public void setAmt4						(int val){												this.amt4						= val;	}	
	public void setAmt5						(int val){												this.amt5						= val;	}	
	public void setAmt6						(int val){												this.amt6						= val;	}	
	public void setAmt7						(int val){												this.amt7						= val;	}	
	public void setAmt8						(int val){												this.amt8						= val;	}	
	public void setAmt9						(int val){												this.amt9						= val;	}	
	public void setFile_name				(String val){		if(val==null) val="";	this.file_name				= val;	}	
	public void setFile_type				(String val){		if(val==null) val="";	this.file_type				= val;	}	
	public void setVar1						(String val){		if(val==null) val="";	this.var1						= val;	}	
	public void setVar2						(String val){		if(val==null) val="";	this.var2						= val;	}	
	public void setVar3						(String val){		if(val==null) val="";	this.var3						= val;	}	

	public void setClient_id				(String val){		if(val==null) val="";	this.client_id				= val;	}	
	public void setChk						(String val){		if(val==null) val="";	this.chk						= val;	}	
	public void setChecker_st			(String val){		if(val==null) val="";	this.checker_st				= val;	}	
	public void setServ_dt					(String val){		if(val==null) val="";	this.serv_dt					= val;	}	
	public void setRep_cont				(String val){		if(val==null) val="";	this.rep_cont				= val;	}	
	public void setServ_off_nm			(String val){		if(val==null) val="";	this.serv_off_nm			= val;	}	

	public void setHo_zip					(String val){		if(val==null) val="";	this.ho_zip					= val;	}	
	public void setHo_addr				(String val){		if(val==null) val="";	this.ho_addr					= val;	}		
	public void setFee_st					(String val){		if(val==null) val="";	this.fee_st					= val;	}		
	public void setR_s_dt					(String val){		if(val==null) val="";	this.r_s_dt					= val;	}	
	public void setR_e_dt					(String val){		if(val==null) val="";	this.r_e_dt					= val;	}	
	public void setNote					(String val){		if(val==null) val=""; 	this.note 					= val;	}

	public void setRent_st					(String val){		if(val==null) val=""; 	this.rent_st 					= val;	}
	public void setSub_rent_mng_id	(String val){		if(val==null) val="";	this.sub_rent_mng_id	= val;	}
	public void setSub_rent_l_cd		(String val){		if(val==null) val=""; 	this.sub_rent_l_cd 		= val;	}
	public void setLic_no					(String val){		if(val==null) val=""; 	this.lic_no 					= val;	}	//운전면허번호(20180629)
	public void setClient_st				(String val){		if(val==null) val=""; 	this.client_st 				= val;	}	//고객 구분(20180704)
	public void setVio_st					(String val){		if(val==null) val=""; 	this.vio_st 					= val;	}	//고객 구분(20180704)

    public void setEnd_dt 					(String val){		if(val==null) val="";	this.end_dt 					= val;	}
    public void setCardno 					(String val){		if(val==null) val="";	this.cardno 					= val;	}
    public void setCard_dt 					(String val){		if(val==null) val="";	this.card_dt 					= val;	}
    	
	//Get Method
	public String getDoc_id 					(){		return doc_id; 					}
	public String getCar_mng_id			(){		return car_mng_id;   		}
	public int    getSeq_no						(){		return seq_no;		  			}
	public String getRent_s_cd				(){		return rent_s_cd;   			}	
	public String getFirm_nm					(){		return firm_nm;      			}	
	public String getSsn							(){		return ssn;          			}	
	public String getEnp_no					(){		return enp_no;       			}	
	public String getRent_start_dt			(){		return rent_start_dt;		}	
	public String getRent_end_dt			(){		return rent_end_dt;  		}	
	public String getPaid_no					(){		return paid_no;      			}		
	public String getReg_id					(){		return reg_id;       			}	
	public String getReg_dt					(){		return reg_dt;       			}	
	public String getUpd_id					(){		return upd_id;       			}	
	public String getUpd_dt					(){		return upd_dt;       			}		
	public String getCar_no					(){		return car_no;       			}		
	public String getScan_file					(){		return scan_file;      		}	
	public String getRent_mng_id			(){		return rent_mng_id;    	}		
	public String getRent_l_cd				(){		return rent_l_cd;      		}		
	public String getVio_dt						(){		return vio_dt;      			}		
	public String getCar_st						(){		return car_st;      			}
	public int    getAmt1						(){		return amt1;		  			}	
	public int    getAmt2						(){		return amt2;		  			}	
	public int    getAmt3						(){		return amt3;		  			}	
	public int    getAmt4						(){		return amt4;		  			}	
	public int    getAmt5						(){		return amt5;		  			}	
	public int    getAmt6						(){		return amt6;		  			}	
	public int    getAmt7						(){		return amt7;		  			}	
	public int    getAmt8						(){		return amt8;		  			}	
	public int    getAmt9						(){		return amt9;		  			}	
	public String getFile_name				(){		return file_name;      		}	
	public String getFile_type					(){		return file_type;      		}	
	public String getVar1						(){		return var1;	      				}	
	public String getVar2						(){		return var2;	      				}	
	public String getVar3						(){		return var3;	      				}	

	public String getClient_id					(){		return client_id;	   			}	
	public String getChk							(){		return chk;	   					}	
	public String getChecker_st				(){		return checker_st;	   		}	
	public String getServ_dt					(){		return serv_dt;	   			}	
	public String getRep_cont				(){		return rep_cont;	   			}	
	public String getServ_off_nm			(){		return serv_off_nm;	   		}	

	public String getHo_zip					(){		return ho_zip;		   			}	
	public String getHo_addr					(){		return ho_addr;	 	  		}	
	public String getFee_st						(){		return fee_st;	  	 			}	
	public String getR_s_dt					(){		return r_s_dt;					}	
	public String getR_e_dt					(){		return r_e_dt;  				}	

	public String getRent_st					(){		return rent_st;					}

	public String getSub_rent_mng_id	(){		return sub_rent_mng_id;	}
	public String getSub_rent_l_cd			(){		return sub_rent_l_cd;		}
	public String getLic_no						(){		return lic_no;					}	//운전면허번호(20180629)
	public String getClient_st					(){		return client_st;				}	//고객 구분(20180704)
	public String getVio_st						(){		return vio_st;				}	//고객 구분(20180704)
	
	public String getEnd_dt 				(){		return end_dt; 			}
	public String getCardno					(){		return cardno;  		}  //카드복합할부시 카드번호 
	public String getCard_dt				(){		return card_dt;			}
	public String getNote					(){		return note;				}
	
	
}