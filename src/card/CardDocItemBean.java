package card;

import java.util.*;

public class CardDocItemBean {
 
  
	//Table : 카드전표사용자
	private String cardno;		//카드번호	
	private String buy_id;		//전표번호		
	private String seq;			//일련번호	
	private String item_code;	//car_mng_id
	private String rent_l_cd;		//rent_l_cd
	private String serv_id;	   //정비 id
	private String item_name;	//차량번호
	private String acct_cont;	//정비내용
	private String call_t_nm;	//call center
	private String call_t_chk;	// call center
	private String call_t_tel;	//call center
	private String o_cau;	//o_cau
	private float  oil_liter;
	private int    tot_dist;	//주행거리
		
	private int    doc_amt;		//참가자금액

	// CONSTRCTOR            
	public CardDocItemBean() {  
		cardno			= "";
		buy_id			= "";
		seq				= "";
		item_code		= "";
		rent_l_cd		= "";
		serv_id			= "";
		item_name		= "";
		acct_cont		= "";
		call_t_nm		= "";
		call_t_chk		= "";
		call_t_tel		= "";
		o_cau		= "";
		oil_liter			= 0.0f; //주유량
		tot_dist			= 0;
		doc_amt			= 0;
	}

	//Set Method
	public void setCardno				(String val){	if(val==null) val="";		cardno			= val;		}
	public void setBuy_id				(String val){	if(val==null) val="";		buy_id			= val;		}
	public void setSeq					(String val){	if(val==null) val="";		seq				= val;		}
	public void setItem_code			(String val){	if(val==null) val="";		item_code		= val;		}
	public void setRent_l_cd			(String val){	if(val==null) val="";		rent_l_cd		= val;		}
	public void setServ_id				(String val){	if(val==null) val="";		serv_id			= val;		}
	public void setItem_name			(String val){	if(val==null) val="";		item_name		= val;		}
	public void setAcct_cont			(String val){	if(val==null) val="";		acct_cont		= val;		}
	public void setCall_t_nm			(String val){	if(val==null) val="";		call_t_nm		= val;		}
	public void setCall_t_chk			(String val){	if(val==null) val="";		call_t_chk		= val;		}
	public void setCall_t_tel			(String val){	if(val==null) val="";		call_t_tel		= val;		}
	public void setO_cau				(String val){	if(val==null) val="";		o_cau				= val;		}
	public void setOil_liter			(float  val){								oil_liter			= val;		}
	public void setTot_dist				(int    val){								tot_dist			= val;		}

	public void setDoc_amt				(int val){									doc_amt			= val;		}


	//Get Method
	public String getCardno				(){		return		cardno;			}
	public String getBuy_id				(){		return		buy_id;			}
	public String getSeq				(){		return		seq;			}
	public String getItem_code			(){		return		item_code;		}
	public String getRent_l_cd			(){		return		rent_l_cd;		}
	public String getServ_id			(){		return		serv_id;		}
	public String getItem_name			(){		return		item_name;		}
	public String getAcct_cont			(){		return		acct_cont;		}
	public String getCall_t_nm			(){		return		call_t_nm;		}
	public String getCall_t_chk			(){		return		call_t_chk;		}
	public String getCall_t_tel			(){		return		call_t_tel;		}
	public String getO_cau				(){		return		o_cau;				}
	public float  getOil_liter			(){		return		oil_liter;			}

	public int    getTot_dist			(){		return		tot_dist;			}

	public int    getDoc_amt			(){		return		doc_amt;        }

}
