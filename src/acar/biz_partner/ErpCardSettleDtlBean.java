package acar.biz_partner;

import java.util.*;

public class ErpCardSettleDtlBean {

    //Table : erp_card_settle_dtl 카드청구내역
	private String	biz_reg_no;         	//사업자번호                    
	private String	comp_name;          	//사업자명                      
	private String	card_inst_id;       	//카드회사코드                  
	private String	card_inst_name;     	//카드회사명                    
	private String	card_no;            	//카드번호                      
	private String	settle_pay_month;   	//청구년월                      
	private String	check_date;			 	//거래일자         
	private String	check_date_seq;		 	//거래일자일련번호 
	private int   	check_amount;		 	//이용금액         
	private String	check_member;		 	//가맹점명         
	private String	check_type;			 	//구분             
	private int   	check_pay_amount;	 	//당월결제액       
	private int   	check_pay_fee;		 	//당월수수료       
	private int   	check_allot_month;	 	//할부기간         
	private String	erp_transfer_yn;    	//ERP 전송 여부                 
	private String	erp_transfer_date;  	//ERP 전송 시각                 

	
	public ErpCardSettleDtlBean() {  
		biz_reg_no				= "";
		comp_name				= "";
		card_inst_id			= "";
		card_inst_name			= "";
		card_no					= "";
		settle_pay_month		= "";
		check_date				= "";
		check_date_seq			= "";
		check_amount			= 0;
		check_member			= "";
		check_type				= "";
		check_pay_amount		= 0;
		check_pay_fee			= 0;
		check_allot_month		= 0;
		erp_transfer_yn    		= "";
		erp_transfer_date  		= "";

	}

	// set Method
	public void setBiz_reg_no				(String var){	biz_reg_no				= var;	}
	public void setComp_name				(String var){	comp_name				= var;	}
	public void setCard_inst_id				(String var){	card_inst_id			= var;	}
	public void setCard_inst_name			(String var){	card_inst_name			= var;	}
	public void setCard_no					(String var){	card_no					= var;	}
	public void setSettle_pay_month			(String var){	settle_pay_month		= var;	}
	public void setCheck_date				(String var){	check_date				= var;	}
	public void setCheck_date_seq			(String var){	check_date_seq			= var;	}
	public void setCheck_amount				(int    var){	check_amount			= var;	}
	public void setCheck_member				(String var){	check_member			= var;	}
	public void setCheck_type				(String var){	check_type				= var;	}
	public void setCheck_pay_amount			(int    var){	check_pay_amount		= var;	}
	public void setCheck_pay_fee			(int    var){	check_pay_fee			= var;	}
	public void setCheck_allot_month		(int    var){	check_allot_month		= var;	}
	public void setErp_transfer_yn			(String var){	erp_transfer_yn			= var;	}
	public void setErp_transfer_date		(String var){	erp_transfer_date		= var;	}

	//Get Method
	public String getBiz_reg_no				(){				return biz_reg_no;				}
	public String getComp_name				(){				return comp_name;				}
	public String getCard_inst_id			(){				return card_inst_id;			}
	public String getCard_inst_name			(){				return card_inst_name;			}
	public String getCard_no				(){				return card_no;					}
	public String getSettle_pay_month		(){				return settle_pay_month;		}
	public String getCheck_date				(){				return check_date;				}
	public String getCheck_date_seq			(){				return check_date_seq;			}
	public int    getCheck_amount			(){				return check_amount;			}
	public String getCheck_member			(){				return check_member;			}
	public String getCheck_type				(){				return check_type;				}
	public int    getCheck_pay_amount		(){				return check_pay_amount;		}
	public int    getCheck_pay_fee			(){				return check_pay_fee;			}
	public int    getCheck_allot_month		(){				return check_allot_month;		}
	public String getErp_transfer_yn		(){				return erp_transfer_yn;			}
	public String getErp_transfer_date		(){				return erp_transfer_date;		}

}
