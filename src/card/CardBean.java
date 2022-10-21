package card;

import java.util.*;

public class CardBean {

	//Table : 카드관리
	private String cardno;	
	private String card_st;	
	private String card_kind;
	private String card_name;
	private String com_code;
	private String com_name;
	private String card_sdate;
	private String card_edate;
	private String limit_st;			
	private long    limit_amt;			
	private String pay_day;
	private String use_s_m;
	private String use_s_day;
	private String use_e_m;
	private String use_e_day;
	private String user_id;
	private String etc;
	private String use_yn;
	private String cls_dt;
	private String cls_cau;
	private String receive_dt;
	private String card_mng_id;
	private String doc_mng_id;
	private String user_seq;
	private String mile_st;
	private String mile_per;
	private int    mile_amt;			
	private String card_chk;
	private String acc_no;
	private String card_type;	
	private String card_paid;	
	private String card_kind_cd;
	
	// CONSTRCTOR            
	public CardBean() {  
		cardno		= "";
		card_st		= "";
		card_kind	= "";
		card_name	= "";
		com_code	= "";
		com_name	= "";
		card_sdate	= "";
		card_edate	= "";
		limit_st	= "";
		limit_amt	= 0;
		pay_day		= "";
		use_s_m		= "";
		use_s_day	= "";
		use_e_m		= "";
		use_e_day	= "";
		user_id		= "";
		etc			= "";
		use_yn		= "";
		cls_dt		= "";
		cls_cau		= "";
		receive_dt	= "";
		card_mng_id	= "";
		doc_mng_id	= "";
		user_seq	= "";
		mile_st		= "";
		mile_per	= "";
		mile_amt	= 0;
		card_chk	= ""; //공용카드 상세용도
		acc_no		= "";
		card_type	= "";
		card_paid	= "";
		card_kind_cd= "";
		
}

	//Set Method
	public void setCardno		(String val){	if(val==null) val="";		cardno		= val;		}
	public void setCard_st		(String val){	if(val==null) val="";		card_st		= val;		}
	public void setCard_kind	(String val){	if(val==null) val="";		card_kind	= val;		}
	public void setCard_name	(String val){	if(val==null) val="";		card_name	= val;		}
	public void setCom_code		(String val){	if(val==null) val="";		com_code	= val;		}
	public void setCom_name		(String val){	if(val==null) val="";		com_name	= val;		}
	public void setCard_sdate	(String val){	if(val==null) val="";		card_sdate	= val;		}
	public void setCard_edate	(String val){	if(val==null) val="";		card_edate	= val;		}
	public void setLimit_st		(String val){	if(val==null) val="";		limit_st	= val;		}
	public void setLimit_amt	(long val)	{								limit_amt	= val;		}
	public void setPay_day		(String val){	if(val==null) val="";		pay_day		= val;		}	
	public void setUse_s_m		(String val){	if(val==null) val="";		use_s_m		= val;		}	
	public void setUse_s_day	(String val){	if(val==null) val="";		use_s_day	= val;		}
	public void setUse_e_m		(String val){	if(val==null) val="";		use_e_m		= val;		}
	public void setUse_e_day	(String val){	if(val==null) val="";		use_e_day	= val;		}	
	public void setUser_id		(String val){	if(val==null) val="";		user_id		= val;		}	
	public void setEtc			(String val){	if(val==null) val="";		etc			= val;		}
	public void setUse_yn		(String val){	if(val==null) val="";		use_yn		= val;		}	
	public void setCls_dt		(String val){	if(val==null) val="";		cls_dt		= val;		}	
	public void setCls_cau		(String val){	if(val==null) val="";		cls_cau		= val;		}
	public void setReceive_dt	(String val){	if(val==null) val="";		receive_dt	= val;		}	
	public void setCard_mng_id	(String val){	if(val==null) val="";		card_mng_id	= val;		}	
	public void setDoc_mng_id	(String val){	if(val==null) val="";		doc_mng_id	= val;		}
	public void setUser_seq		(String val){	if(val==null) val="";		user_seq	= val;		}
	public void setMile_st		(String val){	if(val==null) val="";		mile_st		= val;		}
	public void setMile_per		(String val){	if(val==null) val="";		mile_per	= val;		}
	public void setMile_amt		(int val)	{								mile_amt	= val;		}
	public void setCard_chk		(String val){	if(val==null) val="";		card_chk	= val;		}
	public void setAcc_no		(String val){	if(val==null) val="";		acc_no		= val;		}
	public void setCard_type	(String val){	if(val==null) val="";		card_type	= val;		}
	public void setCard_paid	(String val){	if(val==null) val="";		card_paid	= val;		}
	public void setCard_kind_cd	(String val){	if(val==null) val="";		card_kind_cd= val;		}

	//Get Method
	public String getCardno		(){		return		cardno;			}
	public String getCard_st	(){		return		card_st;		}
	public String getCard_kind	(){		return		card_kind;		}
	public String getCard_name	(){		return		card_name;		}
	public String getCom_code	(){		return		com_code;		}
	public String getCom_name	(){		return		com_name;		}
	public String getCard_sdate	(){		return		card_sdate;		}
	public String getCard_edate	(){		return		card_edate;		}
	public String getLimit_st	(){		return		limit_st;		}
	public long   getLimit_amt	(){		return		limit_amt;		}
	public String getPay_day	(){		return		pay_day;		}	
	public String getUse_s_m	(){		return		use_s_m;		}	
	public String getUse_s_day	(){		return		use_s_day;		}
	public String getUse_e_m	(){		return		use_e_m;		}
	public String getUse_e_day	(){		return		use_e_day;		}
	public String getUser_id	(){		return		user_id;		}
	public String getEtc		(){		return		etc;			}
	public String getUse_yn		(){		return		use_yn;			}
	public String getCls_dt		(){		return		cls_dt;			}
	public String getCls_cau	(){		return		cls_cau;		}
	public String getReceive_dt	(){		return		receive_dt;		}
	public String getCard_mng_id(){		return		card_mng_id;	}
	public String getDoc_mng_id	(){		return		doc_mng_id;		}
	public String getUser_seq	(){		return		user_seq;		}
	public String getMile_st	(){		return		mile_st;		}
	public String getMile_per	(){		return		mile_per;		}
	public int    getMile_amt	(){		return		mile_amt;		}
	public String getCard_chk	(){		return		card_chk;		}
	public String getAcc_no		(){		return		acc_no;			}
	public String getCard_type	(){		return		card_type;		}
	public String getCard_paid	(){		return		card_paid;		}
	public String getCard_kind_cd(){	return		card_kind_cd;	}

}
