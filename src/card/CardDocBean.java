package card;

import java.util.*;

public class CardDocBean {

	//Table : 카드매입전표
	private String cardno;			
	private String buy_id;			
	private String buy_dt;			
	private int    buy_s_amt;
	private int    buy_v_amt;
	private int    buy_amt;
	private String ven_code;				
	private String ven_name;			
	private String acct_code;
	private String acct_code_g;
	private String acct_code_g2;
	private String item_code;
	private String item_name;
	private String acct_cont;
	private String user_su;
	private String user_cont;
	private String reg_id;				
	private String reg_dt;			
	private String app_id;			
	private String app_dt;				
	private String app_code;
	private String autodocu_write_date;
	private String autodocu_data_no;
	private String buy_user_id;			
	private String rent_l_cd;		
	private String chief_id;			
	private String tax_yn;
	private String ven_st;
//추가
	private String cgs_ok; //청구서(1. 체크박스, 2. 예정, 3. 수령, 4. 미정)
	private String cd_reg_id; //확인자
	private String o_cau; //유류대인 경우 사유
	
	private String call_t_nm; //차량이용자
	private String call_t_tel; //연락처
	private String call_t_chk; //재리스 개시전 정비
	
	private String serv_id; //정비 id

    private String m_doc_code;    
    private int    m_amt;

	private String card_file;
	private String file_path;
	private float  oil_liter;

	private int    tot_dist;	//주행거리

	private String siokno;	//현금영수증카드 승인번호
	private String cons_no;	//탁송번호
	private String r_buy_dt;
	private int    doc_amt;	//아이템별금액

	// CONSTRCTOR            
	public CardDocBean() {  
		cardno				= "";
		buy_id				= "";
		buy_dt				= "";
		buy_s_amt			= 0;
		buy_v_amt			= 0;
		buy_amt				= 0;
		ven_code			= "";
		ven_name			= "";
		acct_code			= "";
		acct_code_g			= "";
		acct_code_g2		= "";
		item_code			= "";
		item_name			= "";
		acct_cont			= "";
		user_su				= "";
		user_cont			= "";
		reg_id				= "";
		reg_dt				= "";
		app_id				= "";
		app_dt				= "";
		app_code			= "";
		autodocu_write_date	= "";
		autodocu_data_no	= "";
		buy_user_id			= "";
		rent_l_cd			= "";
		chief_id			= "";
		tax_yn				= "";
		ven_st				= "";
	//추가
		cgs_ok				= "";
		cd_reg_id			= "";	
		o_cau				= "";	
		
		call_t_nm			= "";	
		call_t_tel			= "";	
		call_t_chk			= "";	
		
		serv_id				= "";	
	    m_doc_code			= "";
		m_amt				= 0;

		card_file			= "";
		file_path			= "";
		oil_liter			= 0.0f; //주유량

		tot_dist			= 0;

		siokno			= "";
		cons_no			= "";
		r_buy_dt			= "";
		
		doc_amt			= 0;
	}

	//Set Method
	public void setCardno				(String val){	if(val==null) val="";		cardno				= val;		}
	public void setBuy_id				(String val){	if(val==null) val="";		buy_id				= val;		}
	public void setBuy_dt				(String val){	if(val==null) val="";		buy_dt				= val;		}
	public void setBuy_s_amt			(int val){									buy_s_amt			= val;		}
	public void setBuy_v_amt			(int val){									buy_v_amt			= val;		}
	public void setBuy_amt				(int val){									buy_amt				= val;		}
	public void setVen_code				(String val){	if(val==null) val="";		ven_code			= val;		}
	public void setVen_name				(String val){	if(val==null) val="";		ven_name			= val;		}	
	public void setAcct_code			(String val){	if(val==null) val="";		acct_code			= val;		}	
	public void setAcct_code_g			(String val){	if(val==null) val="";		acct_code_g			= val;		}	
	public void setAcct_code_g2			(String val){	if(val==null) val="";		acct_code_g2		= val;		}	
	public void setItem_code			(String val){	if(val==null) val="";		item_code			= val;		}
	public void setItem_name			(String val){	if(val==null) val="";		item_name			= val;		}
	public void setAcct_cont			(String val){	if(val==null) val="";		acct_cont			= val;		}
	public void setUser_su				(String val){	if(val==null) val="";		user_su				= val;		}
	public void setUser_cont			(String val){	if(val==null) val="";		user_cont			= val;		}
	public void setReg_id				(String val){	if(val==null) val="";		reg_id				= val;		}
	public void setReg_dt				(String val){	if(val==null) val="";		reg_dt				= val;		}
	public void setApp_id				(String val){	if(val==null) val="";		app_id				= val;		}
	public void setApp_dt				(String val){	if(val==null) val="";		app_dt				= val;		}
	public void setApp_code				(String val){	if(val==null) val="";		app_code			= val;		}
	public void setAutodocu_write_date	(String val){	if(val==null) val="";		autodocu_write_date	= val;		}
	public void setAutodocu_data_no		(String val){	if(val==null) val="";		autodocu_data_no	= val;		}
	public void setBuy_user_id			(String val){	if(val==null) val="";		buy_user_id			= val;		}	
	public void setRent_l_cd			(String val){	if(val==null) val="";		rent_l_cd			= val;		}	
	public void setChief_id				(String val){	if(val==null) val="";		chief_id			= val;		}	
	public void setTax_yn				(String val){	if(val==null) val="";		tax_yn				= val;		}
	public void setVen_st				(String val){	if(val==null) val="";		ven_st				= val;		}
//추가
	public void setCgs_ok				(String val){	if(val==null) val="";		cgs_ok				= val;		}
	public void setCd_reg_id			(String val){	if(val==null) val="";		cd_reg_id			= val;		}
	public void setO_cau				(String val){	if(val==null) val="";		o_cau				= val;		}
	
	public void setCall_t_nm			(String val){	if(val==null) val="";		call_t_nm			= val;		}
	public void setCall_t_tel			(String val){	if(val==null) val="";		call_t_tel			= val;		}
	public void setCall_t_chk			(String val){	if(val==null) val="";		call_t_chk			= val;		}
	
	public void setServ_id				(String val){	if(val==null) val="";		serv_id				= val;		}
	public void setM_doc_code			(String val){	if(val==null) val="";		m_doc_code			= val;		}
	public void setM_amt				(int    val){								m_amt				= val;		}
	
	public void setCard_file			(String val){	if(val==null) val="";		card_file			= val;		}
	public void setFile_path			(String val){	if(val==null) val="";		file_path			= val;		}
	public void setOil_liter			(float  val){								oil_liter			= val;		}

	public void setTot_dist				(int    val){								tot_dist			= val;		}

	public void setSiokno				(String val){	if(val==null) val="";		siokno			= val;		}
	public void setCons_no				(String val){	if(val==null) val="";		cons_no			= val;		}
	public void setR_buy_dt				(String val){	if(val==null) val="";		r_buy_dt		= val;		}
	
	public void setDoc_amt				(int    val){								doc_amt			= val;		}
	
	//Get Method
	public String getCardno				(){		return		cardno;				}
	public String getBuy_id				(){		return		buy_id;				}
	public String getBuy_dt				(){		return		buy_dt;				}
	public int    getBuy_s_amt			(){		return		buy_s_amt;          }
	public int    getBuy_v_amt			(){		return		buy_v_amt;          }
	public int    getBuy_amt			(){		return		buy_amt;            }
	public String getVen_code			(){		return		ven_code;			}
	public String getVen_name			(){		return		ven_name;			}
	public String getAcct_code			(){		return		acct_code;			}	
	public String getAcct_code_g		(){		return		acct_code_g;		}	
	public String getAcct_code_g2		(){		return		acct_code_g2;		}	
	public String getItem_code			(){		return		item_code;			}	
	public String getItem_name			(){		return		item_name;			}
	public String getAcct_cont			(){		return		acct_cont;			}
	public String getUser_su			(){		return		user_su;			}
	public String getUser_cont			(){		return		user_cont;			}
	public String getReg_id				(){		return		reg_id;				}
	public String getReg_dt				(){		return		reg_dt;				}
	public String getApp_id				(){		return		app_id;				}
	public String getApp_dt				(){		return		app_dt;				}	
	public String getApp_code			(){		return		app_code;           }
	public String getAutodocu_write_date(){		return		autodocu_write_date;}
	public String getAutodocu_data_no	(){		return		autodocu_data_no;   }
	public String getBuy_user_id		(){		return		buy_user_id;		}	
	public String getRent_l_cd			(){		return		rent_l_cd;			}	
	public String getChief_id			(){		return		chief_id;			}	
	public String getTax_yn				(){		return		tax_yn;				}
	public String getVen_st				(){		return		ven_st;				}
	//추가
	public String getCgs_ok				(){		return		cgs_ok;				}
	public String getCd_reg_id			(){		return		cd_reg_id;			}
	public String getO_cau				(){		return		o_cau;				}
	
	public String getCall_t_nm			(){		return		call_t_nm;			}
	public String getCall_t_tel			(){		return		call_t_tel;			}
	public String getCall_t_chk			(){		return		call_t_chk;			}
	public String getServ_id			(){		return		serv_id;			}

	public String getM_doc_code			(){		return		m_doc_code;			}
	public int    getM_amt				(){		return		m_amt;				}
	
	public String getCard_file			(){		return		card_file;			}
	public String getFile_path			(){		return		file_path;			}
	public float  getOil_liter			(){		return		oil_liter;			}

	public int    getTot_dist			(){		return		tot_dist;			}

	public String getSiokno				(){		return		siokno;				}
	public String getCons_no			(){		return		cons_no;			}
	public String getR_buy_dt			(){		return		r_buy_dt;			}
	
	public int    getDoc_amt			(){		return		doc_amt;			}

}
