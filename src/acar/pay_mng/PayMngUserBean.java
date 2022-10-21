package acar.pay_mng;

import java.util.*;

public class PayMngUserBean {

	//Table : 출금원장사용자
	private String reqseq;		//출금번호
	private int    i_seq;		//항목일련번호
	private int    u_seq;		//사용자일련번호
	private String pay_user;	//참가자명
	private int    pay_amt;		//참가자금액

	// CONSTRCTOR            
	public PayMngUserBean() {  
		reqseq			= "";
		i_seq			= 0;
		u_seq			= 0;
		pay_user		= "";
		pay_amt			= 0;
	}

	//Set Method
	public void setReqseq				(String val){	if(val==null) val="";		reqseq			= val;		}
	public void setI_seq				(int    val){								i_seq			= val;		}
	public void setU_seq				(int    val){								u_seq			= val;		}
	public void setPay_user				(String val){	if(val==null) val="";		pay_user		= val;		}
	public void setPay_amt				(int    val){								pay_amt			= val;		}


	//Get Method
	public String getReqseq				(){		return		reqseq;			}
	public int    getI_seq				(){		return		i_seq;			}
	public int    getU_seq				(){		return		u_seq;			}
	public String getPay_user			(){		return		pay_user;		}
	public int    getPay_amt			(){		return		pay_amt;        }

}
