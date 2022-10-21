package acar.biz_partner;

import java.util.*;

public class ErpTransBean {

    //Table : erp_trans �뷮��ü
	private String	tran_dt;				//��ü����
	private int		tran_cnt;				//��üȸ��
	private int		tran_dt_seq;			//��ü���ں��Ϸù�ȣ
	private String	biz_reg_no;				//����ڹ�ȣ
	private String	out_bank_id;			//��������ڵ�
	private String	out_acct_no;			//���ް��¹�ȣ
	private String	comp_name;				//�迭���
	private String	user_id;				//�����ID
	private String	user_name;				//����ڸ�
	private String	out_bank_name;			//��������
	private String	in_bank_id;				//�Ա������ڵ�
	private String	in_bank_name;			//�Ա������
	private String	in_acct_no;				//�Աݰ��¹�ȣ
	private String	receip_owner_name;		//�����μ���
	private int		tran_amt;				//��ü�ݾ�
	private int		tran_fee;				//��ü������
	private int		tran_remain;			//��ü���ܾ�
	private String	tran_tm;				//��ü�Ͻ�
	private String	remark;					//����
	private String	out_acct_memo;			//�������ǥ��
	private String	in_acct_memo;			//�̱�����ǥ��
	private String	cms_code;				//�Ա���-CMS�ڵ�
	private String	err_code;				//�����ڵ�
	private String	err_reason;				//�Ҵɻ���
	private String	actseq;					//�Ϸù�ȣ

	
	public ErpTransBean() {  
		tran_dt					= "";
		tran_cnt				= 0;
		tran_dt_seq				= 0;
		biz_reg_no				= "";
		out_bank_id				= "";
		out_acct_no				= "";
		comp_name				= "";
		user_id					= "";
		user_name				= "";
		out_bank_name			= "";
		in_bank_id				= "";
		in_bank_name			= "";
		in_acct_no				= "";
		receip_owner_name		= "";
		tran_amt				= 0;
		tran_fee				= 0;
		tran_remain				= 0;
		tran_tm					= "";
		remark					= "";
		out_acct_memo			= "";
		in_acct_memo			= "";
		cms_code				= "";
		err_code				= "";
		err_reason				= "";
		actseq					= "";

	}

	// set Method
	public void setTran_dt					(String str){	tran_dt					= str;	}
	public void setTran_cnt					(int      i){	tran_cnt				= i;	}
	public void setTran_dt_seq				(int      i){	tran_dt_seq				= i;	}
	public void setBiz_reg_no				(String str){	biz_reg_no				= str;	}
	public void setOut_bank_id				(String str){	out_bank_id				= str;	}
	public void setOut_acct_no				(String str){	out_acct_no				= str;	}
	public void setComp_name				(String str){	comp_name				= str;	}
	public void setUser_id					(String str){	user_id					= str;	}
	public void setUser_name				(String str){	user_name				= str;	}
	public void setOut_bank_name			(String str){	out_bank_name			= str;	}
	public void setIn_bank_id				(String str){	in_bank_id				= str;	}
	public void setIn_bank_name				(String str){	in_bank_name			= str;	}
	public void setIn_acct_no				(String str){	in_acct_no				= str;	}
	public void setReceip_owner_name		(String str){	receip_owner_name		= str;	}
	public void setTran_amt					(int      i){	tran_amt				= i;	}
	public void setTran_fee					(int      i){	tran_fee				= i;	}
	public void setTran_remain				(int      i){	tran_remain				= i;	}
	public void setTran_tm					(String str){	tran_tm					= str;	}
	public void setRemark					(String str){	remark					= str;	}
	public void setOut_acct_memo			(String str){	out_acct_memo			= str;	}
	public void setIn_acct_memo				(String str){	in_acct_memo			= str;	}
	public void setCms_code					(String str){	cms_code				= str;	}
	public void setErr_code					(String str){	err_code				= str;	}
	public void setErr_reason				(String str){	err_reason				= str;	}
	public void setActseq					(String str){	actseq					= str;	}

	//Get Method
	public String getTran_dt				(){		return tran_dt;				}
	public int    getTran_cnt				(){		return tran_cnt;			}
	public int    getTran_dt_seq			(){		return tran_dt_seq;			}
	public String getBiz_reg_no				(){		return biz_reg_no;			}
	public String getOut_bank_id			(){		return out_bank_id;			}
	public String getOut_acct_no			(){		return out_acct_no;			}
	public String getComp_name				(){		return comp_name;			}
	public String getUser_id				(){		return user_id;				}
	public String getUser_name				(){		return user_name;			}
	public String getOut_bank_name			(){		return out_bank_name;		}
	public String getIn_bank_id				(){		return in_bank_id;			}
	public String getIn_bank_name			(){		return in_bank_name;		}
	public String getIn_acct_no				(){		return in_acct_no;			}
	public String getReceip_owner_name		(){		return receip_owner_name;	}
	public int    getTran_amt				(){		return tran_amt;			}
	public int    getTran_fee				(){		return tran_fee;			}
	public int    getTran_remain			(){		return tran_remain;			}
	public String getTran_tm				(){		return tran_tm;				}
	public String getRemark					(){		return remark;				}
	public String getOut_acct_memo			(){		return out_acct_memo;		}
	public String getIn_acct_memo			(){		return in_acct_memo;		}
	public String getCms_code				(){		return cms_code;			}
	public String getErr_code				(){		return err_code;			}
	public String getErr_reason				(){		return err_reason;			}
	public String getActseq					(){		return actseq;				}

}
