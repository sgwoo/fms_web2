package tax;

import java.util.*;

public class TaxItemListBean {

	//Table : 거래명세서
	private String item_id;			
	private int    item_seq;			
	private String item_g;			
	private String item_car_no;			
	private String item_car_nm;				
	private String item_dt1;			
	private String item_dt2;			
	private int    item_supply;				
	private int    item_value;				
	private String rent_l_cd;				
	private String car_mng_id;				
	private String tm;				
	private String gubun;	
	private String reg_dt;			
	private String reg_id;			
	private String reg_code;				
	private String client_id;
	private String seq;
	private String tax_id;
	//20071128추가
	private String rent_st;
	private String rent_seq;
	//20080623추가
	private String car_use;
	//2010 법인 의무발행 전자계산서 개편
	private String item_dt;			
	private String r_fee_est_dt;			
	private String bill_yn;		
	//20170214 일자계산 등 비고
	private String etc;			



	// CONSTRCTOR            
	public TaxItemListBean() {  
		item_id			= "";
		item_seq		= 0;
		item_g			= "";
		item_car_no		= "";
		item_car_nm		= "";
		item_dt1		= "";
		item_dt2		= "";
		item_supply		= 0;
		item_value		= 0;
		rent_l_cd		= "";
		car_mng_id		= "";
		tm				= "";
		gubun			= "";
		reg_dt			= "";
		reg_id			= "";
		reg_code		= "";
		client_id		= "";
		seq				= "";
		tax_id			= "";
		rent_st			= "";
		rent_seq		= "";
		car_use			= "";
		item_dt			= "";
		r_fee_est_dt	= "";
		bill_yn			= "";
		etc				= "";
	}

	//Set Method
	public void setItem_id		(String val){	if(val==null) val="";		item_id			= val;		}
	public void setItem_seq		(int val){									item_seq		= val;		}
	public void setItem_g		(String val){	if(val==null) val="";		item_g			= val;		}
	public void setItem_car_no	(String val){	if(val==null) val="";		item_car_no		= val;		}
	public void setItem_car_nm	(String val){	if(val==null) val="";		item_car_nm		= val;		}	
	public void setItem_dt1		(String val){	if(val==null) val="";		item_dt1		= val;		}	
	public void setItem_dt2		(String val){	if(val==null) val="";		item_dt2		= val;		}
	public void setItem_supply	(int val){									item_supply		= val;		}
	public void setItem_value	(int val){									item_value		= val;		}
	public void setRent_l_cd	(String val){	if(val==null) val="";		rent_l_cd		= val;		}
	public void setCar_mng_id	(String val){	if(val==null) val="";		car_mng_id		= val;		}
	public void setTm			(String val){	if(val==null) val="";		tm				= val;		}
	public void setGubun		(String val){	if(val==null) val="";		gubun			= val;		}
	public void setReg_dt		(String val){	if(val==null) val="";		reg_dt			= val;		}
	public void setReg_id		(String val){	if(val==null) val="";		reg_id			= val;		}
	public void setReg_code		(String val){	if(val==null) val="";		reg_code		= val;		}
	public void setClient_id	(String val){	if(val==null) val="";		client_id		= val;		}
	public void setSeq			(String val){	if(val==null) val="";		seq				= val;		}
	public void setTax_id		(String val){	if(val==null) val="";		tax_id			= val;		}	
	public void setRent_st		(String val){	if(val==null) val="";		rent_st			= val;		}	
	public void setRent_seq		(String val){	if(val==null) val="";		rent_seq		= val;		}	
	public void setCar_use		(String val){	if(val==null) val="";		car_use			= val;		}	
	public void setItem_dt		(String val){	if(val==null) val="";		item_dt			= val;		}	
	public void setR_fee_est_dt	(String val){	if(val==null) val="";		r_fee_est_dt	= val;		}	
	public void setBill_yn		(String val){	if(val==null) val="";		bill_yn			= val;		}	
	public void setEtc			(String val){	if(val==null) val="";		etc				= val;		}	


	//Get Method
	public String getItem_id		(){		return		item_id;		}
	public int    getItem_seq		(){		return		item_seq;		}
	public String getItem_g			(){		return		item_g;			}
	public String getItem_car_no	(){		return		item_car_no;	}
	public String getItem_car_nm	(){		return		item_car_nm;	}	
	public String getItem_dt1		(){		return		item_dt1;		}	
	public String getItem_dt2		(){		return		item_dt2;		}
	public int    getItem_supply	(){		return		item_supply;	}
	public int    getItem_value		(){		return		item_value;		}
	public String getRent_l_cd		(){		return		rent_l_cd;		}
	public String getCar_mng_id		(){		return		car_mng_id;		}
	public String getTm				(){		return		tm;				}
	public String getGubun			(){		return		gubun;			}	
	public String getReg_dt			(){		return		reg_dt;			}
	public String getReg_id			(){		return		reg_id;			}
	public String getReg_code		(){		return		reg_code;		}
	public String getClient_id		(){		return		client_id;		}
	public String getSeq			(){		return		seq;			}
	public String getTax_id			(){		return		tax_id;			}	
	public String getRent_st		(){		return		rent_st;		}	
	public String getRent_seq		(){		return		rent_seq;		}	
	public String getCar_use		(){		return		car_use;		}	
	public String getItem_dt		(){		return		item_dt;		}	
	public String getR_fee_est_dt	(){		return		r_fee_est_dt;	}	
	public String getBill_yn		(){		return		bill_yn;		}	
	public String getEtc			(){		return		etc;			}	

}
