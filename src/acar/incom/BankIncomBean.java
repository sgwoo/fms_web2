package acar.incom;

import java.util.*;

public class BankIncomBean {
    //Table : bank_incom
	private String incom_dt;		//거래일자
	private int incom_seq;			//거래순번
	private String gubun;		
    private String bank_nm;		
    private String bank_no;		
    private String remark;		
    private int in_amt;		
    private int out_amt;		
	private int jan_amt;		
 	private String bank_acct;	
	private String jung_type;	
	private String card_nm;	
	private String card_no;	
	private String card_owner;	
	private String card_get_id;	
	private String cash_area;	
	private String cash_get_id;	
	private String reg_dt;	
	private String mod_dt;	
	private String mod_id;	
	private String bank_office;	  //거래점
	
	public BankIncomBean() {  
		incom_dt = "";
		incom_seq = 0;
		gubun = "";
		bank_nm = "";
		bank_no = "";
		remark = "";
		in_amt = 0;
		out_amt = 0;
		jan_amt = 0;
		bank_acct = "";
		jung_type = "";
		card_nm = "";
		card_no = "";
		card_owner = "";
		card_get_id = "";
		cash_area = "";
		cash_get_id = "";
		reg_dt = "";
		mod_dt = "";
		mod_id = "";
		bank_office = "";
	}

	// set Method
	public void setIncom_dt(String str){		incom_dt = str;	}
	public void setIncom_seq(int i){			incom_seq = i;	}
	public void setGubun(String str){			gubun = str;	}
	public void setBank_nm(String str){			bank_nm = str;	}
	public void setBank_no(String str){			bank_no = str;	}
	public void setRemark(String str){			remark = str;	}
	public void setIn_amt(int i){				in_amt = i;	}
	public void setOut_amt(int i){				out_amt = i;	}
	public void setJan_amt(int i){				jan_amt = i;	}

	public void setBank_acct(String str){		bank_acct = str;}
	public void setJung_type(String str){		jung_type = str;}
	public void setCard_nm(String str){			card_nm = str;}
	public void setCard_no(String str){			card_no = str;}
	public void setCard_owner(String str){		card_owner = str;}
	public void setCard_get_id(String str){		card_get_id = str;}
	public void setCash_area(String str){		cash_area = str;}
	public void setCash_get_id(String str){		cash_get_id = str;}
	public void setReg_dt(String str){			reg_dt = str;}
	public void setMod_dt(String str){			mod_dt = str;}
	public void setMod_id(String str){			mod_id = str;}
	public void setBank_office(String str){			bank_office = str;}
	
	//Get Method
	public String getIncom_dt(){		return incom_dt;	}
	public int getIncom_seq(){			return incom_seq;	}	
	public String getGubun(){			return gubun;		}
	public String getBank_nm(){			return bank_nm;		}
	public String getBank_no(){			return bank_no;		}
	public String getRemark(){			return remark;		}
	public int getIn_amt(){				return in_amt;		}	
	public int getOut_amt(){			return out_amt;		}	
	public int getJan_amt(){			return jan_amt;		}		
	public String getBank_acct(){		return bank_acct;	}
	public String getJung_type(){		return jung_type;	}
	public String getCard_nm(){			return card_nm;	}
	public String getCard_no(){			return card_no;	}
	public String getCard_owner(){		return card_owner;	}
	public String getCard_get_id(){		return card_get_id;	}
	public String getCash_area(){		return cash_area;	}
	public String getCash_get_id(){		return cash_get_id;	}
	public String getReg_dt(){			return reg_dt;	}
	public String getMod_dt(){			return mod_dt;	}
	public String getMod_id(){			return mod_id;	}
	public String getBank_office(){		return bank_office;	}

}