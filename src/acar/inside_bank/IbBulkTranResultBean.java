package acar.inside_bank;

import java.util.*;

public class IbBulkTranResultBean {

    //Table : IB_BULK_TRAN_RESULT  대량이체처리결과
	private String	list_nb;        	//목록일련번호
	private String	list_nb_seq;        //목록별일련번호(데이터순번)
	private String	tr_date;        	//거래일자
	private String	tr_time;        	//거래시간
	private String	tran_ji_acct_nb; 	//지급계좌번호
	private String	tran_ip_bank_id; 	//입금계좌금융기관코드
	private String	tran_ip_acct_nb; 	//입금계좌번호
	private String	tran_amt_req;       //이체의뢰금액
	private String	tran_amt;        	//정상이체금액
	private String	tran_amt_err;       //오류금액
	private String	tran_fee;        	//수수료금액
	private String	tran_remittee_nm;	//수취인명
	private String	tran_ji_naeyong; 	//지급통장표시내용
	private String	tran_ip_naeyong; 	//입금통장표시내용
	private String	tran_cms_cd;     	//cms코드
	private String	tran_memo;       	//거래메모
	private String	upche_key;       	//업체사용key
	private String	tran_reg_date;     	//등록일자
	private String	tran_reg_time;     	//등록시간
	private String	tran_status;     	//상태구분코드
	private String	tran_type_cd;     	//이체종류코드
	private String	tran_result_cd;    	//이체결과코드
	

	public IbBulkTranResultBean() {  
		list_nb        		= "";
		list_nb_seq			= "";
		tr_date        		= "";
		tr_time        		= "";
		tran_ji_acct_nb 	= "";
		tran_ip_bank_id 	= "";
		tran_ip_acct_nb 	= "";
		tran_amt_req		= "";
		tran_amt        	= "";
		tran_amt_err		= "";
		tran_fee        	= "";
		tran_remittee_nm	= "";
		tran_ji_naeyong 	= "";
		tran_ip_naeyong 	= "";
		tran_cms_cd     	= "";
		tran_memo       	= "";
		upche_key       	= "";
		tran_reg_date		= "";
		tran_reg_time		= "";
		tran_status     	= "";
		tran_type_cd		= "";
		tran_result_cd		= "";
	}

	// set Method
	public void setList_nb				(String str){	list_nb        		= str;	}
	public void setList_nb_seq			(String str){	list_nb_seq			= str;	}
	public void setTr_date				(String str){	tr_date        		= str;	}
	public void setTr_time				(String str){	tr_time        		= str;	}
	public void setTran_ji_acct_nb		(String str){	tran_ji_acct_nb 	= str;	}
	public void setTran_ip_bank_id		(String str){	tran_ip_bank_id 	= str;	}
	public void setTran_ip_acct_nb		(String str){	tran_ip_acct_nb 	= str;	}
	public void setTran_amt_req			(String str){	tran_amt_req		= str;	}
	public void setTran_amt				(String str){	tran_amt        	= str;	}
	public void setTran_amt_err			(String str){	tran_amt_err		= str;	}
	public void setTran_fee				(String str){	tran_fee        	= str;	}
	public void setTran_remittee_nm		(String str){	tran_remittee_nm	= str;	}
	public void setTran_ji_naeyong		(String str){	tran_ji_naeyong 	= str;	}
	public void setTran_ip_naeyong		(String str){	tran_ip_naeyong 	= str;	}
	public void setTran_cms_cd			(String str){	tran_cms_cd     	= str;	}
	public void setTran_memo			(String str){	tran_memo       	= str;	}
	public void setUpche_key			(String str){	upche_key       	= str;	}
	public void setTran_reg_date		(String str){	tran_reg_date		= str;	}
	public void setTran_reg_time		(String str){	tran_reg_time		= str;	}
	public void setTran_status			(String str){	tran_status     	= str;	}
	public void setTran_type_cd			(String str){	tran_type_cd		= str;	}
	public void setTran_result_cd		(String str){	tran_result_cd		= str;	}


	//Get Method
	public String getList_nb        	(){				return list_nb;        		}
	public String getList_nb_seq		(){				return list_nb_seq;			}
	public String getTr_date        	(){				return tr_date;        		}
	public String getTr_time        	(){				return tr_time;        		}
	public String getTran_ji_acct_nb 	(){				return tran_ji_acct_nb; 	}
	public String getTran_ip_bank_id 	(){				return tran_ip_bank_id; 	}
	public String getTran_ip_acct_nb 	(){				return tran_ip_acct_nb; 	}
	public String getTran_amt_req		(){				return tran_amt_req;       	}
	public String getTran_amt        	(){				return tran_amt;        	}
	public String getTran_amt_err		(){				return tran_amt_err;       	}
	public String getTran_fee        	(){				return tran_fee;        	}
	public String getTran_remittee_nm	(){				return tran_remittee_nm;	}
	public String getTran_ji_naeyong 	(){				return tran_ji_naeyong; 	}
	public String getTran_ip_naeyong 	(){				return tran_ip_naeyong; 	}
	public String getTran_cms_cd     	(){				return tran_cms_cd;     	}
	public String getTran_memo       	(){				return tran_memo;       	}
	public String getUpche_key       	(){				return upche_key;       	}
	public String getTran_reg_date		(){				return tran_reg_date;     	}
	public String getTran_reg_time		(){				return tran_reg_time;     	}
	public String getTran_status     	(){				return tran_status;     	}
	public String getTran_type_cd		(){				return tran_type_cd;     	}
	public String getTran_result_cd		(){				return tran_result_cd;    	}

}