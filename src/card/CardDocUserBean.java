package card;

import java.util.*;

public class CardDocUserBean {

	//Table : ī����ǥ�����
	private String cardno;		//ī���ȣ	
	private String buy_id;		//��ǥ��ȣ		
	private String seq;			//�Ϸù�ȣ	
	private String user_st;		//����ڱ���
	private String firm_nm;		//�ŷ�ó��
	private String doc_user;	//�����ڸ�
	private int    doc_amt;		//�����ڱݾ�

	// CONSTRCTOR            
	public CardDocUserBean() {  
		cardno			= "";
		buy_id			= "";
		seq				= "";
		firm_nm			= "";
		user_st			= "";
		doc_user		= "";
		doc_amt			= 0;
	}

	//Set Method
	public void setCardno				(String val){	if(val==null) val="";		cardno			= val;		}
	public void setBuy_id				(String val){	if(val==null) val="";		buy_id			= val;		}
	public void setSeq					(String val){	if(val==null) val="";		seq				= val;		}
	public void setUser_st				(String val){	if(val==null) val="";		user_st			= val;		}
	public void setFirm_nm				(String val){	if(val==null) val="";		firm_nm			= val;		}
	public void setDoc_user				(String val){	if(val==null) val="";		doc_user		= val;		}
	public void setDoc_amt				(int val){									doc_amt			= val;		}


	//Get Method
	public String getCardno				(){		return		cardno;			}
	public String getBuy_id				(){		return		buy_id;			}
	public String getSeq				(){		return		seq;			}
	public String getUser_st			(){		return		user_st;		}
	public String getFirm_nm			(){		return		firm_nm;		}
	public String getDoc_user			(){		return		doc_user;		}
	public int    getDoc_amt			(){		return		doc_amt;        }

}
