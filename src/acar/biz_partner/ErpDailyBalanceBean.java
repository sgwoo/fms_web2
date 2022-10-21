package acar.biz_partner;

import java.util.*;

public class ErpDailyBalanceBean {

    //Table : erp_daily_balance 일자별 잔액조회

	private String	acct_no;                   //계좌번호   
	private String	currency_code;             //통화코드   
	private String	balance_date;              //잔액일자   
	private String	bank_id;                   //은행코드   
	private String	biz_reg_no;                //사업자번호 
	private String	erp_tran_time;             //전송시간   
     

	public ErpDailyBalanceBean() {  
		acct_no         = "";
		currency_code   = "";
		balance_date    = "";
		bank_id         = "";
		biz_reg_no      = "";
		erp_tran_time   = "";

	}

	// set Method
	public void setAcct_no				(String var){	acct_no				= var;	}
	public void setCurrency_code		(String var){	currency_code		= var;	}
	public void setBalance_date			(String var){	balance_date		= var;	}
	public void setBank_id				(String var){	bank_id				= var;	}
	public void setBiz_reg_no			(String var){	biz_reg_no			= var;	}
	public void setErp_tran_time		(String var){	erp_tran_time		= var;	}

	//Get Method
	public String getAcct_no			(){				return acct_no;				}
	public String getCurrency_code		(){				return currency_code;		}
	public String getBalance_date		(){				return balance_date;		}
	public String getBank_id			(){				return bank_id;				}
	public String getBiz_reg_no			(){				return biz_reg_no;			}
	public String getErp_tran_time		(){				return erp_tran_time;		}


}
