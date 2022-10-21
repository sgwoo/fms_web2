package acar.incom;

import java.util.*;

public class IncomEtcBean {
    //Table : incom_etc :��Ÿ �Ա�
	private String incom_dt;		//�ŷ�����
	private int incom_seq;			//�ŷ�����
	private int seq_id;			//�Ϸù�ȣ
	private String n_ven_code;	 //�ŷ�ó	
	private String n_ven_name;	 //�ŷ�ó	
    private String ip_acct;	 //����	
    private long ip_acct_amt;	 //�ݾ�
    private String remark;	 //Ư�̻���	
    private String neom;	 //��ǥ����	
    private String acct_gubun;	 // ��/�� ���� ����:D, �뺯: C	
  
	
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