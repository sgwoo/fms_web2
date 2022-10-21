package acar.incom;

import java.util.*;

public class IncomEtcBean {
    //Table : incom_etc :기타 입금
	private String incom_dt;		//거래일자
	private int incom_seq;			//거래순번
	private int seq_id;			//일련번호
	private String n_ven_code;	 //거래처	
	private String n_ven_name;	 //거래처	
    private String ip_acct;	 //구분	
    private long ip_acct_amt;	 //금액
    private String remark;	 //특이사항	
    private String neom;	 //전표발행	
    private String acct_gubun;	 // 차/대 구분 차변:D, 대변: C	
  
	
	public IncomEtcBean() {  
		incom_dt = "";
		incom_seq = 0;
		seq_id = 0;
		n_ven_code = "";
		n_ven_name = "";
		ip_acct = "";
		ip_acct_amt = 0;
		remark = "";
		neom = "";
		acct_gubun = "";
		
	}

	// set Method
	public void setIncom_dt(String str){		incom_dt = str;	}
	public void setIncom_seq(int i){			incom_seq = i;	}
	public void setSeq_id(int i){				seq_id = i;	}
	public void setN_ven_code(String str){		n_ven_code = str;	}
	public void setN_ven_name(String str){		n_ven_name = str;	}
	public void setIp_acct(String str){			ip_acct = str;	}
	public void setIp_acct_amt(long i){			ip_acct_amt = i;	}
	public void setRemark(String str){			remark = str;	}
	public void setNeom(String str){			neom = str;	}	
	public void setAcct_gubun(String str){			acct_gubun = str;	}
	
	//Get Method
	public String getIncom_dt(){		return incom_dt;	}
	public int getIncom_seq(){			return incom_seq;	}	
	public int getSeq_id(){				return seq_id;	}	
	public String getN_ven_code(){		return n_ven_code;		}
	public String getN_ven_name(){		return n_ven_name;		}
	public String getIp_acct(){			return ip_acct;		}
	public long getIp_acct_amt(){		return ip_acct_amt;	}
	public String getRemark(){			return remark;		}	
	public String getNeom(){			return neom;		}	
	public String getAcct_gubun(){			return acct_gubun;		}	
	

}