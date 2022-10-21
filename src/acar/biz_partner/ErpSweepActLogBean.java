package acar.biz_partner;

import java.util.*;

public class ErpSweepActLogBean {

    //Table : erp_sweep_act_log 자금집금 상세

	private String	biz_reg_no;				//사업자번호                    
	private String	user_id;				//집금자ID             
	private String	sweep_no;				//목록번호             
	private int   	execut_seq;				//실행일련번호         
	private int   	retry_seq;				//재처리회차           
	private int   	set_type_seq;       	//집금세트타입일련번호     
	private String	set_type;           	//집금세트타입          
	private int   	order_seq;          	//집금세트타입처리번호  
	private String	sweep_cd;           	//집금방법              
	private int   	insert_amt;         	//입력액                
	private int   	trans_amt;          	//이체금액                 
	private int   	free_amt;           	//수수료                   
	private int   	remainder_amt;      	//잔고                     
	private int   	pay_amt;            	//이체가능금액          
	private String	result_cd;          	//결과코드              
	private String	error_nm;           	//결과내용              
	private String	execut_dt;          	//집금이체일자          
	private String	execut_tm;          	//집금이체시간             
	private String	in_acct_num;        	//입금계좌번호             
	private String	out_acct_num;       	//출금계좌번호             
	private String	in_bank_id;         	//입금은행코드          
	private String	out_bank_id;        	//출금은행코드          
	private String	insert_dt;          	//등록일자              
	private String	in_acct_seq;        	//입금계좌일련번호      
	private String	out_acct_seq;       	//출금계좌일련번호      
	
	public ErpSweepActLogBean() {  
		biz_reg_no			= "";
		user_id				= "";
		sweep_no			= "";
		execut_seq			= 0;
		retry_seq			= 0;
		set_type_seq      	= 0;
		set_type          	= "";
		order_seq         	= 0;
		sweep_cd          	= "";
		insert_amt        	= 0;
		trans_amt         	= 0;
		free_amt          	= 0;
		remainder_amt     	= 0;
		pay_amt           	= 0;
		result_cd         	= "";
		error_nm          	= "";
		execut_dt         	= "";
		execut_tm         	= "";
		in_acct_num       	= "";
		out_acct_num      	= "";
		in_bank_id        	= "";
		out_bank_id       	= "";
		insert_dt         	= "";
		in_acct_seq       	= "";
		out_acct_seq      	= "";

	}

	// set Method
	public void setBiz_reg_no				(String var){	biz_reg_no			= var;	}
	public void setUser_id					(String var){	user_id				= var;	}
	public void setSweep_no					(String var){	sweep_no			= var;	}
	public void setExecut_seq				(int    var){	execut_seq			= var;	}
	public void setRetry_seq				(int    var){	retry_seq			= var;	}
	public void setSet_type_seq				(int    var){	set_type_seq      	= var;	}
	public void setSet_type					(String var){	set_type          	= var;	}
	public void setOrder_seq				(int    var){	order_seq         	= var;	}
	public void setSweep_cd					(String var){	sweep_cd          	= var;	}
	public void setInsert_amt				(int    var){	insert_amt        	= var;	}
	public void setTrans_amt				(int    var){	trans_amt         	= var;	}
	public void setFree_amt					(int    var){	free_amt          	= var;	}
	public void setRemainder_amt			(int    var){	remainder_amt     	= var;	}
	public void setPay_amt					(int    var){	pay_amt           	= var;	}
	public void setResult_cd				(String var){	result_cd         	= var;	}
	public void setError_nm					(String var){	error_nm          	= var;	}
	public void setExecut_dt				(String var){	execut_dt         	= var;	}
	public void setExecut_tm				(String var){	execut_tm         	= var;	}
	public void setIn_acct_num				(String var){	in_acct_num       	= var;	}
	public void setOut_acct_num				(String var){	out_acct_num      	= var;	}
	public void setIn_bank_id				(String var){	in_bank_id        	= var;	}
	public void setOut_bank_id				(String var){	out_bank_id       	= var;	}
	public void setInsert_dt				(String var){	insert_dt         	= var;	}
	public void setIn_acct_seq				(String var){	in_acct_seq       	= var;	}
	public void setOut_acct_seq				(String var){	out_acct_seq      	= var;	}

	//Get Method
	public String getBiz_reg_no				(){				return biz_reg_no;			}
	public String getUser_id				(){				return user_id;				}
	public String getSweep_no				(){				return sweep_no;			}
	public int    getExecut_seq				(){				return execut_seq;			}
	public int    getRetry_seq				(){				return retry_seq;			}
	public int    getSet_type_seq        	(){				return set_type_seq;      	}
	public String getSet_type            	(){				return set_type;          	}
	public int    getOrder_seq           	(){				return order_seq;         	}
	public String getSweep_cd            	(){				return sweep_cd;          	}
	public int    getInsert_amt          	(){				return insert_amt;        	}
	public int    getTrans_amt           	(){				return trans_amt;         	}
	public int    getFree_amt            	(){				return free_amt;          	}
	public int    getRemainder_amt       	(){				return remainder_amt;     	}
	public int    getPay_amt             	(){				return pay_amt;           	}
	public String getResult_cd           	(){				return result_cd;         	}
	public String getError_nm            	(){				return error_nm;          	}
	public String getExecut_dt           	(){				return execut_dt;         	}
	public String getExecut_tm           	(){				return execut_tm;         	}
	public String getIn_acct_num         	(){				return in_acct_num;       	}
	public String getOut_acct_num        	(){				return out_acct_num;      	}
	public String getIn_bank_id          	(){				return in_bank_id;        	}
	public String getOut_bank_id         	(){				return out_bank_id;       	}
	public String getInsert_dt           	(){				return insert_dt;         	}
	public String getIn_acct_seq         	(){				return in_acct_seq;       	}
	public String getOut_acct_seq        	(){				return out_acct_seq;      	}

}
