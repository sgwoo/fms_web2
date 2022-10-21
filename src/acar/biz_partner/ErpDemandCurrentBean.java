package acar.biz_partner;

import java.util.*;

public class ErpDemandCurrentBean {

    //Table : erp_demand_current 대량이체
	private String	biz_reg_no;          	//계좌주 사업자번호
	private String	bank_id;				//은행코드         
	private String	comp_name;           	//계좌주 사업체명  
	private String	bank_name;				//은행명           
	private String	acct_num;				//계좌번호         
	private String	tran_data;           	//거래일           
	private String	tran_date_seq;       	//거래일 일련번호  
	private String	tran_clsfy;          	//거래구분         
	private String	tran_content;        	//예금주           
	private int	  	tran_amt;            	//거래금액         
	private int	  	tran_remain;         	//거래후 잔액      
	private String	tran_branch;         	//거래지점         
	private String	remark;              	//적요             
	private int		basic_price;         	//기준가격         
	private String	tran_memo;           	//메모             
	private int	  	tran_cnt;            	//거래수           
	private String	erp_transfer_yn;     	//ERP 전송 여부    
	private String	erp_transfer_date;   	//ERP 전송 시각    
	private String	tran_time;           	//거래시간         
	private String	cms_code;            	//CMS코드          
	private String	tran_veri_yn;        	//거래검증결과     
	private String	erp_tran_veri_yn;    	//ERP거래검증결과  

	
	public ErpDemandCurrentBean() {  
		biz_reg_no           = "";
		bank_id              = "";
		comp_name            = "";
		bank_name            = "";
		acct_num             = "";
		tran_data            = "";
		tran_date_seq        = "";
		tran_clsfy           = "";
		tran_content         = "";
		tran_amt             = 0;
		tran_remain          = 0;
		tran_branch          = "";
		remark               = "";
		basic_price          = 0;
		tran_memo            = "";
		tran_cnt             = 0;
		erp_transfer_yn      = "";
		erp_transfer_date    = "";
		tran_time            = "";
		cms_code             = "";
		tran_veri_yn         = "";
		erp_tran_veri_yn     = "";

	}

	// set Method
	public void setBiz_reg_no          (String var){	biz_reg_no           = var;	}
	public void setBank_id             (String var){	bank_id              = var;	}
	public void setComp_name           (String var){	comp_name            = var;	}
	public void setBank_name           (String var){	bank_name            = var;	}
	public void setAcct_num            (String var){	acct_num             = var;	}
	public void setTran_data           (String var){	tran_data            = var;	}
	public void setTran_date_seq       (String var){	tran_date_seq        = var;	}
	public void setTran_clsfy          (String var){	tran_clsfy           = var;	}
	public void setTran_content        (String var){	tran_content         = var;	}
	public void setTran_amt            (int	   var){	tran_amt             = var;	}
	public void setTran_remain         (int	   var){	tran_remain          = var;	}
	public void setTran_branch         (String var){	tran_branch          = var;	}
	public void setRemark              (String var){	remark               = var;	}
	public void setBasic_price         (int	   var){	basic_price          = var;	}
	public void setTran_memo           (String var){	tran_memo            = var;	}
	public void setTran_cnt            (int	   var){	tran_cnt             = var;	}
	public void setErp_transfer_yn     (String var){	erp_transfer_yn      = var;	}
	public void setErp_transfer_date   (String var){	erp_transfer_date    = var;	}
	public void setTran_time           (String var){	tran_time            = var;	}
	public void setCms_code            (String var){	cms_code             = var;	}
	public void setTran_veri_yn        (String var){	tran_veri_yn         = var;	}
	public void setErp_tran_veri_yn    (String var){	erp_tran_veri_yn     = var;	}

	//Get Method
	public String getBiz_reg_no          (){		return biz_reg_no;			}
	public String getBank_id             (){		return bank_id;				}
	public String getComp_name           (){		return comp_name;			}
	public String getBank_name           (){		return bank_name;			}
	public String getAcct_num            (){		return acct_num;			}
	public String getTran_data           (){		return tran_data;			}
	public String getTran_date_seq       (){		return tran_date_seq;		}
	public String getTran_clsfy          (){		return tran_clsfy;			}
	public String getTran_content        (){		return tran_content;		}
	public int	  getTran_amt            (){		return tran_amt;			}
	public int	  getTran_remain         (){		return tran_remain;			}
	public String getTran_branch         (){		return tran_branch;			}
	public String getRemark              (){		return remark;				}
	public int	  getBasic_price         (){		return basic_price;			}
	public String getTran_memo           (){		return tran_memo;			}
	public int	  getTran_cnt            (){		return tran_cnt;			}
	public String getErp_transfer_yn     (){		return erp_transfer_yn;		}
	public String getErp_transfer_date   (){		return erp_transfer_date;	}
	public String getTran_time           (){		return tran_time;			}
	public String getCms_code            (){		return cms_code;			}
	public String getTran_veri_yn        (){		return tran_veri_yn;		}
	public String getErp_tran_veri_yn    (){		return erp_tran_veri_yn;	}

}





















