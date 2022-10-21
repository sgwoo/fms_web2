package acar.biz_partner;

import java.util.*;

public class ErpShbTransferBean {

    //Table : erp_shb_transfer 당행 이체내역 전송

	private String	user_id;				//사용자                   
	private String	list_no;				//목록번호                 
	private String	data_seq;				//목록번호의상세번호       
	private String	trans_dt;				//거래일                   
	private String	trans_tm;				//거래시간                 
	private String	insert_dt;				//ERP등록일                
	private String	err_msg;				//에러내용                 
	private String	err_cd;					//에러코드                 
	private String	pay_acct_no;			//출금통장                 
	private String	bank_name;				//입금은행                 
	private String	receip_bank_cd;			//입금은행코드             
	private String	receip_acct_no;			//입금계좌번호             
	private String	receip_owner_nm;		//입금계좌주               
	private int   	trans_amt;				//거래금액                 
	private int   	trans_fee;				//거래수수료               
	private int   	error_amt;				//오류금액                 
	private String	pay_acct_memo;			//입금통장표시             
	private String	receipt_acct_memo;		//출금통장표시             
	private String	cms_cd;					//cms_cd                   
	private String	trans_memo;				//적요                     
	private String	regster_fg;				//거래종류코드             
	private String	regster_fg_nm;			//거래종류명               
	

	public ErpShbTransferBean() {  
		user_id            = "";
		list_no            = "";
		data_seq           = "";
		trans_dt           = "";
		trans_tm           = "";
		insert_dt          = "";
		err_msg            = "";
		err_cd             = "";
		pay_acct_no        = "";
		bank_name          = "";
		receip_bank_cd     = "";
		receip_acct_no     = "";
		receip_owner_nm    = "";
		trans_amt          = 0;
		trans_fee          = 0;
		error_amt          = 0;
		pay_acct_memo      = "";
		receipt_acct_memo  = "";
		cms_cd             = "";
		trans_memo         = "";
		regster_fg         = "";
		regster_fg_nm      = "";

	}

	// set Method
	public void setUser_id				(String var){	user_id            = var;	}
	public void setList_no				(String var){	list_no            = var;	}
	public void setData_seq				(String var){	data_seq           = var;	}
	public void setTrans_dt				(String var){	trans_dt           = var;	}
	public void setTrans_tm				(String var){	trans_tm           = var;	}
	public void setInsert_dt			(String var){	insert_dt          = var;	}
	public void setErr_msg				(String var){	err_msg            = var;	}
	public void setErr_cd				(String var){	err_cd             = var;	}
	public void setPay_acct_no			(String var){	pay_acct_no        = var;	}
	public void setBank_name			(String var){	bank_name          = var;	}
	public void setReceip_bank_cd		(String var){	receip_bank_cd     = var;	}
	public void setReceip_acct_no		(String var){	receip_acct_no     = var;	}
	public void setReceip_owner_nm		(String var){	receip_owner_nm    = var;	}
	public void setTrans_amt			(int    var){	trans_amt          = var;	}
	public void setTrans_fee			(int    var){	trans_fee          = var;	}
	public void setError_amt			(int    var){	error_amt          = var;	}
	public void setPay_acct_memo		(String var){	pay_acct_memo      = var;	}
	public void setReceipt_acct_memo	(String var){	receipt_acct_memo  = var;	}
	public void setCms_cd				(String var){	cms_cd             = var;	}
	public void setTrans_memo			(String var){	trans_memo         = var;	}
	public void setRegster_fg			(String var){	regster_fg         = var;	}
	public void setRegster_fg_nm		(String var){	regster_fg_nm      = var;	}

	//Get Method
	public String getUser_id            (){				return user_id;				}
	public String getList_no            (){				return list_no;				}
	public String getData_seq           (){				return data_seq;			}
	public String getTrans_dt           (){				return trans_dt;			}
	public String getTrans_tm           (){				return trans_tm;			}
	public String getInsert_dt          (){				return insert_dt;			}
	public String getErr_msg            (){				return err_msg;				}
	public String getErr_cd             (){				return err_cd;				}
	public String getPay_acct_no        (){				return pay_acct_no;			}
	public String getBank_name          (){				return bank_name;			}
	public String getReceip_bank_cd     (){				return receip_bank_cd;		}
	public String getReceip_acct_no     (){				return receip_acct_no;		}
	public String getReceip_owner_nm    (){				return receip_owner_nm;		}
	public int    getTrans_amt          (){				return trans_amt;			}
	public int    getTrans_fee          (){				return trans_fee;			}
	public int    getError_amt          (){				return error_amt;			}
	public String getPay_acct_memo      (){				return pay_acct_memo;		}
	public String getReceipt_acct_memo  (){				return receipt_acct_memo;	}
	public String getCms_cd             (){				return cms_cd;				}
	public String getTrans_memo         (){				return trans_memo;			}
	public String getRegster_fg         (){				return regster_fg;			}
	public String getRegster_fg_nm      (){				return regster_fg_nm;		}

}
