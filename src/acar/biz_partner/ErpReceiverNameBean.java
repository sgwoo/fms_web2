package acar.biz_partner;

import java.util.*;

public class ErpReceiverNameBean {

    //Table : erp_receiver_name �����θ� ����

	private int   	tran_count;             	//ȸ��               
	private String	biz_reg_no;             	//����ڹ�ȣ                 
	private String	tran_dt;                	//����               
	private int   	tran_dt_seq;            	//�Ϸù�ȣ           
	private String	in_bank_id;                	//�Ա������ڵ�       
	private String	in_acct_no;                	//�Աݰ���           
	private String	in_acct_name;              	//�Ա���             
	private String	receiver_yn;               	//��ġ����,             
	private String	receiver_result;           	//������ȸ���          
	private String	error_code;                	//�����ڵ�              
	private String	remark;                    	//����               
	
	public ErpReceiverNameBean() {  
		tran_count				= 0;
		biz_reg_no				= "";
		tran_dt					= "";
		tran_dt_seq				= 0;
		in_bank_id				= "";
		in_acct_no				= "";
		in_acct_name			= "";
		receiver_yn				= "";
		receiver_result      	= "";
		error_code           	= "";
		remark               	= "";

	}

	// set Method
	public void setTran_count            	(int    var){	tran_count				= var;	}
	public void setBiz_reg_no            	(String var){	biz_reg_no				= var;	}
	public void setTran_dt               	(String var){	tran_dt					= var;	}
	public void setTran_dt_seq           	(int    var){	tran_dt_seq				= var;	}
	public void setIn_bank_id            	(String var){	in_bank_id				= var;	}
	public void setIn_acct_no				(String var){	in_acct_no				= var;	}
	public void setIn_acct_name				(String var){	in_acct_name			= var;	}
	public void setReceiver_yn				(String var){	receiver_yn				= var;	}
	public void setReceiver_result			(String var){	receiver_result      	= var;	}
	public void setError_code				(String var){	error_code           	= var;	}
	public void setRemark					(String var){	remark               	= var;	}

	//Get Method
	public int    getTran_count            	(){				return tran_count;             	}
	public String getBiz_reg_no            	(){				return biz_reg_no;             	}
	public String getTran_dt               	(){				return tran_dt;                	}
	public int    getTran_dt_seq           	(){				return tran_dt_seq;            	}
	public String getIn_bank_id            	(){				return in_bank_id;              }
	public String getIn_acct_no             (){				return in_acct_no;              }
	public String getIn_acct_name           (){				return in_acct_name;            }
	public String getReceiver_yn            (){				return receiver_yn;             }
	public String getReceiver_result        (){				return receiver_result;         }
	public String getError_code             (){				return error_code;              }
	public String getRemark                 (){				return remark;                  }

}
