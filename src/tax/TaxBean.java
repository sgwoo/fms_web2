package tax;

import java.util.*;

public class TaxBean {

	//Table : 세금계산서
	private String rent_l_cd;			
	private String client_id;			
	private String tax_dt;			
	private String fee_tm;			
	private String car_mng_id;				
	private String unity_chk;			
	private String branch_g;				
	private String tax_g;				
	private int    tax_supply;				
	private int    tax_value;				
	private String tax_id;				
	private String item_id;				
	private String tax_bigo;				
	private String seq;				
	private String tax_no;				
	private String car_nm;				
	private String car_no;				
	private String reg_dt;			
	private String reg_id;			
	private String print_dt;
	private String print_id;
	private String autodocu_write_date;
	private String autodocu_data_no;
	private String tax_st;
	private String m_tax_no;
	private String tax_type;
	private String gubun;	
	private String resseq;	
	private String mail_dt;
	private String con_agnt_nm;
	private String con_agnt_m_tel;
	private String con_agnt_email;
	private String con_agnt_dept;
	private String con_agnt_title;
	private String app_yn;
	private String branch_g2;				
	private String RecTel;       
	private String RecCoRegNo;   
	private String RecCoName;    
	private String RecCoCeo;     
	private String RecCoAddr;    
	private String RecCoBizType; 
	private String RecCoBizSub;  
	private String RecCoSsn;   

	//2010 법인 의무발행 전자계산서 개편
	private String taxregno;				
	private String reccoregnotype;				
	private String doctype;				
	private String cust_st;				
	private String PubForm;	
	private String RecCoTaxRegNo;   
	//20110708 계산서 품목다중표시여부
	private String etax_item_st	= "";	
	//20140101 수정계산서는 당초승인번호 넣을것
	private String org_nts_issueid	= "";	
	//20141101
	private String ven_code	= "";	
	//20170710 계산서 추가수신자	
	private String con_agnt_nm2;
	private String con_agnt_m_tel2;
	private String con_agnt_email2;
	private String con_agnt_dept2;
	private String con_agnt_title2;

	// CONSTRCTOR            
	public TaxBean() {  
		rent_l_cd			= "";
		client_id			= "";
		tax_dt				= "";
		fee_tm				= "";
		car_mng_id			= "";
		unity_chk			= "";
		branch_g			= "";
		tax_g				= "";
		tax_supply			= 0;
		tax_value			= 0;
		tax_id				= "";
		item_id				= "";
		tax_bigo			= "";
		seq					= "";
		tax_no				= "";
		car_nm				= "";
		car_no				= "";
		reg_dt				= "";
		reg_id				= "";
		print_dt			= "";
		print_id			= "";
		autodocu_write_date	= "";
		autodocu_data_no	= "";
		tax_st				= "";
		m_tax_no			= "";
		tax_type			= "";
		gubun				= "";
		resseq				= "";
		mail_dt				= "";
		con_agnt_nm			= "";
		con_agnt_m_tel		= "";
		con_agnt_email		= "";
		con_agnt_dept		= "";
		con_agnt_title		= "";
		app_yn				= "";
		branch_g2			= "";
		RecTel				= "";
		RecCoRegNo			= "";
		RecCoName			= "";
		RecCoCeo			= "";
		RecCoAddr			= "";
		RecCoBizType		= "";
		RecCoBizSub			= "";
		RecCoSsn			= "";
		taxregno			= "";
		reccoregnotype		= "";
		doctype				= "";
		cust_st				= "";
		PubForm				= "";
		RecCoTaxRegNo		= "";
		etax_item_st		= "";
		org_nts_issueid		= "";
		ven_code			= "";
		con_agnt_nm2		= "";
		con_agnt_m_tel2		= "";
		con_agnt_email2		= "";
		con_agnt_dept2		= "";
		con_agnt_title2		= "";

	}

	//Set Method
	public void setRent_l_cd			(String val){	if(val==null) val="";		rent_l_cd			= val;		}
	public void setClient_id			(String val){	if(val==null) val="";		client_id			= val;		}
	public void setTax_dt				(String val){	if(val==null) val="";		tax_dt				= val;		}
	public void setFee_tm				(String val){	if(val==null) val="";		fee_tm				= val;		}
	public void setCar_mng_id			(String val){	if(val==null) val="";		car_mng_id			= val;		}	
	public void setUnity_chk			(String val){	if(val==null) val="";		unity_chk			= val;		}	
	public void setBranch_g				(String val){	if(val==null) val="";		branch_g			= val;		}
	public void setTax_g				(String val){	if(val==null) val="";		tax_g				= val;		}
	public void setTax_supply			(int val)	{								tax_supply			= val;		}
	public void setTax_value			(int val)	{								tax_value			= val;		}
	public void setTax_id				(String val){	if(val==null) val="";		tax_id				= val;		}
	public void setItem_id				(String val){	if(val==null) val="";		item_id				= val;		}
	public void setTax_bigo				(String val){	if(val==null) val="";		tax_bigo			= val;		}
	public void setSeq					(String val){	if(val==null) val="";		seq					= val;		}
	public void setTax_no				(String val){	if(val==null) val="";		tax_no				= val;		}
	public void setCar_nm				(String val){	if(val==null) val="";		car_nm				= val;		}
	public void setCar_no				(String val){	if(val==null) val="";		car_no				= val;		}
	public void setReg_dt				(String val){	if(val==null) val="";		reg_dt				= val;		}
	public void setReg_id				(String val){	if(val==null) val="";		reg_id				= val;		}
	public void setPrint_dt				(String val){	if(val==null) val="";		print_dt			= val;		}
	public void setPrint_id				(String val){	if(val==null) val="";		print_id			= val;		}
	public void setAutodocu_write_date	(String val){	if(val==null) val="";		autodocu_write_date	= val;		}
	public void setAutodocu_data_no		(String val){	if(val==null) val="";		autodocu_data_no	= val;		}
	public void setTax_st				(String val){	if(val==null) val="";		tax_st				= val;		}
	public void setM_tax_no				(String val){	if(val==null) val="";		m_tax_no			= val;		}
	public void setTax_type				(String val){	if(val==null) val="";		tax_type			= val;		}
	public void setGubun				(String val){	if(val==null) val="";		gubun				= val;		}
	public void setResseq				(String val){	if(val==null) val="";		resseq				= val;		}
	public void setMail_dt				(String val){	if(val==null) val="";		mail_dt				= val;		}
	public void setCon_agnt_nm			(String str){	if(str==null) str="";		con_agnt_nm			= str;		}    
	public void setCon_agnt_m_tel		(String str){	if(str==null) str="";		con_agnt_m_tel		= str;		}  
	public void setCon_agnt_email		(String str){	if(str==null) str="";		con_agnt_email		= str;		}  
	public void setCon_agnt_dept		(String str){	if(str==null) str="";		con_agnt_dept		= str;		}	
	public void setCon_agnt_title		(String str){	if(str==null) str="";		con_agnt_title		= str;		} 
	public void setApp_yn				(String val){	if(val==null) val="";		app_yn				= val;		}	
	public void setBranch_g2			(String val){	if(val==null) val="";		branch_g2			= val;		}
	public void setRecTel				(String val){	if(val==null) val="";		RecTel				= val;		}	
	public void setRecCoRegNo			(String val){	if(val==null) val="";		RecCoRegNo			= val;		}
	public void setRecCoName			(String val){	if(val==null) val="";		RecCoName			= val;		}
	public void setRecCoCeo				(String val){	if(val==null) val="";		RecCoCeo			= val;		}
	public void setRecCoAddr			(String val){	if(val==null) val="";		RecCoAddr			= val;		}
	public void setRecCoBizType			(String val){	if(val==null) val="";		RecCoBizType		= val;		}
	public void setRecCoBizSub			(String val){	if(val==null) val="";		RecCoBizSub			= val;		}
	public void setRecCoSsn				(String val){	if(val==null) val="";		RecCoSsn			= val;		}
	public void setTaxregno				(String val){	if(val==null) val="";		taxregno			= val;		}
	public void setReccoregnotype		(String val){	if(val==null) val="";		reccoregnotype		= val;		}
	public void setDoctype				(String val){	if(val==null) val="";		doctype				= val;		}
	public void setCust_st				(String val){	if(val==null) val="";		cust_st				= val;		}
	public void setPubForm				(String val){	if(val==null) val="";		PubForm				= val;		}
	public void setRecCoTaxRegNo		(String val){	if(val==null) val="";		RecCoTaxRegNo		= val;		}
	public void setEtax_item_st			(String str){	if(str==null) str="";		etax_item_st		= str;		}	
	public void setOrg_nts_issueid		(String str){	if(str==null) str="";		org_nts_issueid		= str;		}
	public void setVen_code				(String val){	if(val==null) val="";		ven_code			= val;		}	
	public void setCon_agnt_nm2			(String str){	if(str==null) str="";		con_agnt_nm2		= str;		}    
	public void setCon_agnt_m_tel2		(String str){	if(str==null) str="";		con_agnt_m_tel2		= str;		}  
	public void setCon_agnt_email2		(String str){	if(str==null) str="";		con_agnt_email2		= str;		}  
	public void setCon_agnt_dept2		(String str){	if(str==null) str="";		con_agnt_dept2		= str;		}	
	public void setCon_agnt_title2		(String str){	if(str==null) str="";		con_agnt_title2		= str;		} 



	//Get Method
	public String getRent_l_cd			(){		return		rent_l_cd;				}
	public String getClient_id			(){		return		client_id;				}
	public String getTax_dt				(){		return		tax_dt;					}
	public String getFee_tm				(){		return		fee_tm;					}
	public String getCar_mng_id			(){		return		car_mng_id;				}	
	public String getUnity_chk			(){		return		unity_chk;				}	
	public String getBranch_g			(){		return		branch_g;				}
	public String getTax_g				(){		return		tax_g;					}
	public int	  getTax_supply			(){		return		tax_supply;				}
	public int	  getTax_value			(){		return		tax_value;				}
	public String getTax_id				(){		return		tax_id;					}
	public String getItem_id			(){		return		item_id;				}
	public String getTax_bigo			(){		return		tax_bigo;				}
	public String getSeq				(){		return		seq;					}
	public String getTax_no				(){		return		tax_no;					}
	public String getCar_nm				(){		return		car_nm;					}
	public String getCar_no				(){		return		car_no;					}
	public String getReg_dt				(){		return		reg_dt;					}
	public String getReg_id				(){		return		reg_id;					}
	public String getPrint_dt			(){		return		print_dt;				}
	public String getPrint_id			(){		return		print_id;				}
	public String getAutodocu_write_date(){		return		autodocu_write_date;	}
	public String getAutodocu_data_no	(){		return		autodocu_data_no;		}
	public String getTax_st				(){		return		tax_st;					}
	public String getM_tax_no			(){		return		m_tax_no;				}
	public String getTax_type			(){		return		tax_type;				}
	public String getGubun				(){		return		gubun;					}	
	public String getResseq				(){		return		resseq;					}	
	public String getMail_dt			(){		return		mail_dt;				}	
	public String getCon_agnt_nm		(){		return		con_agnt_nm;			}
	public String getCon_agnt_m_tel		(){		return		con_agnt_m_tel;			}
	public String getCon_agnt_email		(){		return		con_agnt_email;			}
	public String getCon_agnt_dept		(){		return		con_agnt_dept;			}
	public String getCon_agnt_title		(){		return		con_agnt_title;			}
	public String getApp_yn				(){		return		app_yn;					}	
	public String getBranch_g2			(){		return		branch_g2;				}
	public String getRecTel				(){		return		RecTel;					}	
	public String getRecCoRegNo			(){		return		RecCoRegNo;				}
	public String getRecCoName			(){		return		RecCoName;				}
	public String getRecCoCeo			(){		return		RecCoCeo;				}
	public String getRecCoAddr			(){		return		RecCoAddr;				}
	public String getRecCoBizType		(){		return		RecCoBizType;			}
	public String getRecCoBizSub		(){		return		RecCoBizSub;			}
	public String getRecCoSsn			(){		return		RecCoSsn;				}
	public String getTaxregno			(){		return		taxregno;				}
	public String getReccoregnotype		(){		return		reccoregnotype;			}
	public String getDoctype			(){		return		doctype;				}
	public String getCust_st			(){		return		cust_st;				}
	public String getPubForm			(){		return		PubForm;				}
	public String getRecCoTaxRegNo		(){		return		RecCoTaxRegNo;			}
	public String getEtax_item_st		(){		return		etax_item_st;			}	
	public String getOrg_nts_issueid	(){		return		org_nts_issueid;		}
	public String getVen_code			(){		return		ven_code;				}	
	public String getCon_agnt_nm2		(){		return		con_agnt_nm2;			}
	public String getCon_agnt_m_tel2	(){		return		con_agnt_m_tel2;		}
	public String getCon_agnt_email2	(){		return		con_agnt_email2;		}
	public String getCon_agnt_dept2		(){		return		con_agnt_dept2;			}
	public String getCon_agnt_title2	(){		return		con_agnt_title2;		}

}
