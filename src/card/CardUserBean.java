package card;

import java.util.*;

public class CardUserBean {

	//Table : ī������
	private String cardno;		//ī���ȣ		
	private String seq;			//�Ϸù�ȣ	
	private String user_id;		//������ڵ�
	private String use_s_dt;	//ī����������
	private String use_e_dt;	//ī��ȸ������
	private String reg_id;		//����(���)��
	private String back_id;		//ȸ��(���)��
	private String r_use_s_dt;	//������밳������

	// CONSTRCTOR            
	public CardUserBean() {  
		cardno			= "";
		seq				= "";
		user_id			= "";
		use_s_dt		= "";
		use_e_dt		= "";
		reg_id			= "";
		back_id			= "";
		r_use_s_dt		= "";
	}

	//Set Method
	public void setCardno				(String val){	if(val==null) val="";		cardno			= val;		}
	public void setSeq					(String val){	if(val==null) val="";		seq				= val;		}
	public void setUser_id				(String val){	if(val==null) val="";		user_id			= val;		}
	public void setUse_s_dt				(String val){	if(val==null) val="";		use_s_dt		= val;		}
	public void setUse_e_dt				(String val){	if(val==null) val="";		use_e_dt		= val;		}
	public void setReg_id				(String val){	if(val==null) val="";		reg_id			= val;		}
	public void setBack_id				(String val){	if(val==null) val="";		back_id			= val;		}
	public void setR_use_s_dt			(String val){	if(val==null) val="";		r_use_s_dt		= val;		}


	//Get Method
	public String getCardno				(){		return		cardno;			}
	public String getSeq				(){		return		seq;			}
	public String getUser_id			(){		return		user_id;		}
	public String getUse_s_dt			(){		return		use_s_dt;		}
	public String getUse_e_dt			(){		return		use_e_dt;		}
	public String getReg_id				(){		return		reg_id;			}
	public String getBack_id			(){		return		back_id;		}
	public String getR_use_s_dt			(){		return		r_use_s_dt;		}

}
