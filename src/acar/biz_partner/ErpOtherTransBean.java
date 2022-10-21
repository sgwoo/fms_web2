package acar.biz_partner;

import java.util.*;

public class ErpOtherTransBean {

    //Table : erp_other_trans 타행 건별이체 연동

	private String	tran_dt;                     //이체일자               
	private int   	tran_dt_seq;                 //이체일자별일련번호     
	private String	biz_reg_no;                  //사업자번호             
	private String	out_bank_id;                 //지급은행코드           
	private String	out_acct_no;                 //지급계좌번호           
	private String	out_bank_name;               //지급은행명             
	private String	out_acct_pwd;                //지급계좌비밀번호       
	private String	in_bank_id;                  //입금은행코드           
	private String	in_acct_no;                  //입금계좌번호           
	private String	in_bank_name;                //입금은행명             
	private String	receip_owner_name;           //수취인성명             
	private int   	tran_amt;                    //이체금액               
	private String	remark;                      //적요                   
	private String	out_acct_memo;               //출금통장표시           
	private String	in_acct_memo;                //입금통장표시           
	private String	cms_code;                    //입금인_CMS코드         
	private int   	tran_fee;                    //이체수수료             
	private int   	tran_remain;                 //이체후잔액             
	private String	status_code;                 //상태코드               
	private String	err_msg;                     //불능사유               


	public ErpOtherTransBean() {  
		tran_dt				= "";
		tran_dt_seq			= 0;
		biz_reg_no			= "";
		out_bank_id			= "";
		out_acct_no			= "";
		out_bank_name		= "";
		out_acct_pwd		= "";
		in_bank_id			= "";
		in_acct_no			= "";
		in_bank_name		= "";
		receip_owner_name	= "";
		tran_amt			= 0;
		remark				= "";
		out_acct_memo		= "";
		in_acct_memo		= "";
		cms_code			= "";
		tran_fee			= 0;
		tran_remain			= 0;
		status_code			= "";
		err_msg				= "";

	}

	// set Method
	public void setTran_dt					(String var){	tran_dt				= var;	}
	public void setTran_dt_seq				(int    var){	tran_dt_seq			= var;	}
	public void setBiz_reg_no				(String var){	biz_reg_no			= var;	}
	public void setOut_bank_id				(String var){	out_bank_id			= var;	}
	public void setOut_acct_no				(String var){	out_acct_no			= var;	}
	public void setOut_bank_name			(String var){	out_bank_name		= var;	}
	public void setOut_acct_pwd				(String var){	out_acct_pwd		= var;	}
	public void setIn_bank_id				(String var){	in_bank_id			= var;	}
	public void setIn_acct_no				(String var){	in_acct_no			= var;	}
	public void setIn_bank_name				(String var){	in_bank_name		= var;	}
	public void setReceip_owner_name		(String var){	receip_owner_name	= var;	}
	public void setTran_amt					(int    var){	tran_amt			= var;	}
	public void setRemark					(String var){	remark				= var;	}
	public void setOut_acct_memo			(String var){	out_acct_memo		= var;	}
	public void setIn_acct_memo				(String var){	in_acct_memo		= var;	}
	public void setCms_code					(String var){	cms_code			= var;	}
	public void setTran_fee					(int    var){	tran_fee			= var;	}
	public void setTran_remain				(int    var){	tran_remain			= var;	}
	public void setStatus_code				(String var){	status_code			= var;	}
	public void setErr_msg					(String var){	err_msg				= var;	}

	//Get Method
	public String getTran_dt				(){				return tran_dt;             }
	public int    getTran_dt_seq			(){				return tran_dt_seq;         }
	public String getBiz_reg_no				(){				return biz_reg_no;          }
	public String getOut_bank_id			(){				return out_bank_id;         }
	public String getOut_acct_no			(){				return out_acct_no;         }
	public String getOut_bank_name			(){				return out_bank_name;       }
	public String getOut_acct_pwd			(){				return out_acct_pwd;        }
	public String getIn_bank_id				(){				return in_bank_id;          }
	public String getIn_acct_no				(){				return in_acct_no;          }
	public String getIn_bank_name			(){				return in_bank_name;        }
	public String getReceip_owner_name		(){				return receip_owner_name;   }
	public int    getTran_amt				(){				return tran_amt;            }
	public String getRemark					(){				return remark;              }
	public String getOut_acct_memo			(){				return out_acct_memo;       }
	public String getIn_acct_memo			(){				return in_acct_memo;        }
	public String getCms_code				(){				return cms_code;            }
	public int    getTran_fee				(){				return tran_fee;            }
	public int    getTran_remain			(){				return tran_remain;         }
	public String getStatus_code			(){				return status_code;         }
	public String getErr_msg				(){				return err_msg;             }

}
