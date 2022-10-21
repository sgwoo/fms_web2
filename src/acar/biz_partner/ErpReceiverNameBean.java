package acar.biz_partner;

import java.util.*;

public class ErpReceiverNameBean {

    //Table : erp_receiver_name 수취인명 내역

	private int   	tran_count;             	//회차               
	private String	biz_reg_no;             	//사업자번호                 
	private String	tran_dt;                	//일자               
	private int   	tran_dt_seq;            	//일련번호           
	private String	in_bank_id;                	//입금은행코드       
	private String	in_acct_no;                	//입금계좌           
	private String	in_acct_name;              	//입금인             
	private String	receiver_yn;               	//일치여부,             
	private String	receiver_result;           	//성명조회결과          
	private String	error_code;                	//오류코드              
	private String	remark;                    	//적요               
	
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
