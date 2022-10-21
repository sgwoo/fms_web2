package card;

import java.util.*;

public class CardContBean {

	//Table : 카드약정
	private String cardno;			
	private int    seq;
	private String cont_dt;				
	private String give_day;			
	private long   cont_amt;
	private float  save_per1;				
	private float  save_per2;				
	private String save_in_dt_st1;
	private String save_in_dt_st2;
	private String save_in_dt_st3;
	private String save_in_dt;
	private String save_in_st;
	private String agnt_nm;
	private String agnt_tel;
	private String agnt_m_tel;
	private String master_nm;
	private String master_tel;
	private String master_m_tel;
	private String etc;
	private String reg_id;				
	private String reg_dt;	
	private String allot_link_yn;
	private String n_ven_code;
	private String n_ven_name;
	private String card_kind;
	private String give_day_st;

	// CONSTRCTOR            
	public CardContBean() {  
		cardno			= "";
		seq         	= 0;
		cont_dt			= "";
		give_day		= "";
		cont_amt    	= 0;
		save_per1		= 0;
		save_per2		= 0;
		save_in_dt_st1 	= "";
		save_in_dt_st2 	= "";
		save_in_dt_st3 	= "";
		save_in_dt  	= "";
		save_in_st  	= "";
		agnt_nm     	= "";
		agnt_tel    	= "";
		agnt_m_tel  	= "";
		master_nm     	= "";
		master_tel    	= "";
		master_m_tel  	= "";
		etc         	= "";
		reg_id			= "";
		reg_dt			= "";
		allot_link_yn	= "";
		n_ven_code		= "";
		n_ven_name		= "";
		card_kind		= "";
		give_day_st		= "";
	}

	//Set Method
	public void setCardno			(String val){	if(val==null) val="";		cardno			= val;	}
	public void setSeq				(int    val){								seq         	= val;	}
	public void setCont_dt			(String val){	if(val==null) val="";		cont_dt			= val;	}
	public void setGive_day			(String val){	if(val==null) val="";		give_day		= val;	}
	public void setCont_amt			(long    val){								cont_amt    	= val;	}
	public void setSave_per1		(float  val){								save_per1		= val;	}
	public void setSave_per2		(float  val){								save_per2		= val;	}
	public void setSave_in_dt_st1	(String val){	if(val==null) val="";		save_in_dt_st1 	= val;	}	
	public void setSave_in_dt_st2	(String val){	if(val==null) val="";		save_in_dt_st2 	= val;	}	
	public void setSave_in_dt_st3	(String val){	if(val==null) val="";		save_in_dt_st3 	= val;	}	
	public void setSave_in_dt		(String val){	if(val==null) val="";		save_in_dt  	= val;	}	
	public void setSave_in_st		(String val){	if(val==null) val="";		save_in_st  	= val;	}	
	public void setAgnt_nm			(String val){	if(val==null) val="";		agnt_nm     	= val;	}	
	public void setAgnt_tel			(String val){	if(val==null) val="";		agnt_tel    	= val;	}	
	public void setAgnt_m_tel		(String val){	if(val==null) val="";		agnt_m_tel  	= val;	}
	public void setMaster_nm		(String val){	if(val==null) val="";		master_nm     	= val;	}	
	public void setMaster_tel		(String val){	if(val==null) val="";		master_tel    	= val;	}	
	public void setMaster_m_tel		(String val){	if(val==null) val="";		master_m_tel  	= val;	}
	public void setEtc				(String val){	if(val==null) val="";		etc         	= val;	}
	public void setReg_id			(String val){	if(val==null) val="";		reg_id			= val;	}
	public void setReg_dt			(String val){	if(val==null) val="";		reg_dt			= val;	}
	public void setAllot_link_yn	(String val){	if(val==null) val="";		allot_link_yn	= val;	}
	public void setN_ven_code		(String val){	if(val==null) val="";		n_ven_code		= val;	}
	public void setN_ven_name		(String val){	if(val==null) val="";		n_ven_name		= val;	}
	public void setCard_kind		(String val){	if(val==null) val="";		card_kind		= val;	}
	public void setGive_day_st		(String val){	if(val==null) val="";		give_day_st		= val;	}
	

	//Get Method
	public String getCardno			(){		return		cardno;			}
	public int    getSeq			(){		return		seq;         	}
	public String getCont_dt		(){		return		cont_dt;		}
	public String getGive_day		(){		return		give_day;	    }
	public long   getCont_amt		(){		return		cont_amt;       }
	public float  getSave_per1		(){		return		save_per1;	    }
	public float  getSave_per2		(){		return		save_per2;		}
	public String getSave_in_dt_st1	(){		return		save_in_dt_st1; }
	public String getSave_in_dt_st2	(){		return		save_in_dt_st2; }
	public String getSave_in_dt_st3	(){		return		save_in_dt_st3; }
	public String getSave_in_dt		(){		return		save_in_dt;  	}
	public String getSave_in_st		(){		return		save_in_st;  	}	
	public String getAgnt_nm		(){		return		agnt_nm;     	}	
	public String getAgnt_tel		(){		return		agnt_tel;    	}	
	public String getAgnt_m_tel		(){		return		agnt_m_tel;  	}	
	public String getMaster_nm		(){		return		master_nm;     	}	
	public String getMaster_tel		(){		return		master_tel;    	}	
	public String getMaster_m_tel	(){		return		master_m_tel;  	}	
	public String getEtc			(){		return		etc;         	}
	public String getReg_id			(){		return		reg_id;			}
	public String getReg_dt			(){		return		reg_dt;			}
	public String getAllot_link_yn	(){		return		allot_link_yn;	}
	public String getN_ven_code		(){		return		n_ven_code;		}
	public String getN_ven_name		(){		return		n_ven_name;		}
	public String getCard_kind		(){		return		card_kind;		}
	public String getGive_day_st	(){		return		give_day_st;    }


}
