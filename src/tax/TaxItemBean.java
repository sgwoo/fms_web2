package tax;

import java.util.*;

public class TaxItemBean {

	//Table : 거래명세서
	private String item_id;			
	private String client_id;			
	private String seq;			
	private String item_dt;			
	private String tax_id;				
	private String item_hap_str;			
	private int    item_hap_num;				
	private String item_man;	
	
	//2010 법인 의무발행 전자계산서 개편
	private String tax_code;		
	private String tax_est_dt;				
	private String tax_no;				
	private String use_yn;			
	private String cancel_dt;			
	private String cancel_cont;	
	private String cust_st;			
	private String etax_item_st;	
	
	//20161223 사고 내용 메모
	private String tax_item_etc;

	// CONSTRCTOR            
	public TaxItemBean() {  
		item_id			= "";
		client_id		= "";
		seq				= "";
		item_dt			= "";
		tax_id			= "";
		item_hap_str	= "";
		item_hap_num	= 0;
		item_man		= "";

		tax_code		= "";
		tax_est_dt		= "";
		tax_no			= "";
		use_yn			= "";
		cancel_dt		= "";
		cancel_cont		= "";
		cust_st			= "";
		etax_item_st	= "";
		tax_item_etc    = "";

	}

	//Set Method
	public void setItem_id			(String val){	if(val==null) val="";		item_id			= val;		}
	public void setClient_id		(String val){	if(val==null) val="";		client_id		= val;		}
	public void setSeq				(String val){	if(val==null) val="";		seq				= val;		}
	public void setItem_dt			(String val){	if(val==null) val="";		item_dt			= val;		}
	public void setTax_id			(String val){	if(val==null) val="";		tax_id			= val;		}	
	public void setItem_hap_str		(String val){	if(val==null) val="";		item_hap_str	= val;		}	
	public void setItem_hap_num		(int val){									item_hap_num	= val;		}
	public void setItem_man			(String val){	if(val==null) val="";		item_man		= val;		}

	public void setTax_code			(String val){	if(val==null) val="";		tax_code		= val;		}
	public void setTax_est_dt		(String val){	if(val==null) val="";		tax_est_dt		= val;		}
	public void setTax_no			(String val){	if(val==null) val="";		tax_no			= val;		}
	public void setUse_yn			(String val){	if(val==null) val="";		use_yn			= val;		}
	public void setCancel_dt		(String val){	if(val==null) val="";		cancel_dt		= val;		}
	public void setCancel_cont		(String val){	if(val==null) val="";		cancel_cont		= val;		}
	public void setCust_st			(String val){	if(val==null) val="";		cust_st			= val;		}
	public void setEtax_item_st		(String val){	if(val==null) val="";		etax_item_st	= val;		}
	public void setTax_item_etc		(String val){	if(val==null) val="";		tax_item_etc	= val;		}


	//Get Method
	public String getItem_id		(){		return		item_id;		}
	public String getClient_id		(){		return		client_id;		}
	public String getSeq			(){		return		seq;			}
	public String getItem_dt		(){		return		item_dt;		}
	public String getTax_id			(){		return		tax_id;			}	
	public String getItem_hap_str	(){		return		item_hap_str;	}	
	public int	  getItem_hap_num	(){		return		item_hap_num;	}
	public String getItem_man		(){		return		item_man;		}

	public String getTax_code		(){		return		tax_code;		}
	public String getTax_est_dt		(){		return		tax_est_dt;		}
	public String getTax_no			(){		return		tax_no;			}
	public String getUse_yn			(){		return		use_yn;			}
	public String getCancel_dt		(){		return		cancel_dt;		}
	public String getCancel_cont	(){		return		cancel_cont;	}
	public String getCust_st		(){		return		cust_st;		}
	public String getEtax_item_st	(){		return		etax_item_st;	}
	public String getTax_item_etc	(){		return		tax_item_etc;	}


}
