package acar.inside_bank;

import java.util.*;

public class IbBulkTranResultBean {

    //Table : IB_BULK_TRAN_RESULT  �뷮��üó�����
	private String	list_nb;        	//����Ϸù�ȣ
	private String	list_nb_seq;        //��Ϻ��Ϸù�ȣ(�����ͼ���)
	private String	tr_date;        	//�ŷ�����
	private String	tr_time;        	//�ŷ��ð�
	private String	tran_ji_acct_nb; 	//���ް��¹�ȣ
	private String	tran_ip_bank_id; 	//�Աݰ��±�������ڵ�
	private String	tran_ip_acct_nb; 	//�Աݰ��¹�ȣ
	private String	tran_amt_req;       //��ü�Ƿڱݾ�
	private String	tran_amt;        	//������ü�ݾ�
	private String	tran_amt_err;       //�����ݾ�
	private String	tran_fee;        	//������ݾ�
	private String	tran_remittee_nm;	//�����θ�
	private String	tran_ji_naeyong; 	//��������ǥ�ó���
	private String	tran_ip_naeyong; 	//�Ա�����ǥ�ó���
	private String	tran_cms_cd;     	//cms�ڵ�
	private String	tran_memo;       	//�ŷ��޸�
	private String	upche_key;       	//��ü���key
	private String	tran_reg_date;     	//�������
	private String	tran_reg_time;     	//��Ͻð�
	private String	tran_status;     	//���±����ڵ�
	private String	tran_type_cd;     	//��ü�����ڵ�
	private String	tran_result_cd;    	//��ü����ڵ�
	

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