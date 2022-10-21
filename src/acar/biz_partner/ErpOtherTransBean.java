package acar.biz_partner;

import java.util.*;

public class ErpOtherTransBean {

    //Table : erp_other_trans Ÿ�� �Ǻ���ü ����

	private String	tran_dt;                     //��ü����               
	private int   	tran_dt_seq;                 //��ü���ں��Ϸù�ȣ     
	private String	biz_reg_no;                  //����ڹ�ȣ             
	private String	out_bank_id;                 //���������ڵ�           
	private String	out_acct_no;                 //���ް��¹�ȣ           
	private String	out_bank_name;               //���������             
	private String	out_acct_pwd;                //���ް��º�й�ȣ       
	private String	in_bank_id;                  //�Ա������ڵ�           
	private String	in_acct_no;                  //�Աݰ��¹�ȣ           
	private String	in_bank_name;                //�Ա������             
	private String	receip_owner_name;           //�����μ���             
	private int   	tran_amt;                    //��ü�ݾ�               
	private String	remark;                      //����                   
	private String	out_acct_memo;               //�������ǥ��           
	private String	in_acct_memo;                //�Ա�����ǥ��           
	private String	cms_code;                    //�Ա���_CMS�ڵ�         
	private int   	tran_fee;                    //��ü������             
	private int   	tran_remain;                 //��ü���ܾ�             
	private String	status_code;                 //�����ڵ�               
	private String	err_msg;                     //�Ҵɻ���               


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
