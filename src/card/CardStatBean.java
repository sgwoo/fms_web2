package card;

import java.util.*;

public class CardStatBean {

	//Table : 카드캐쉬백 기본,스케줄
	private int    serial;
	private String base_dt;
	private String cardno;
	private String base_g;
	private long   base_amt;
	private float  save_per;				
	private long   save_amt;
	private String est_dt;				
	private String reg_code;			
	private String base_bigo;			
	private String update_id;
	private String update_dt;
	private String reqseq;
	private String card_kind;
	private int    tm;
	private String scd_dt;
	private long   scd_amt;
	private String incom_dt;
	private String incom_seq;
	private long   incom_amt;
	private String incom_bigo;	
	private long   m_amt;
	private long   rest_amt;
	private String bank_id;	
	private String bank_nm;	
	private String bank_no;	
	private String magam_st;	
	private String magam_dt;	
	private String s_save_per;	
	private int    magam_id;
	private String ven_name;	

	// CONSTRCTOR            
	public CardStatBean() {  
		serial		= 0;
		base_dt		= "";
		cardno		= "";
		base_g		= "";
		base_amt	= 0;
		save_per	= 0;
		save_amt	= 0;
		est_dt		= "";
		reg_code	= "";
		base_bigo	= "";
		update_id	= "";
		update_dt	= "";
		reqseq		= "";
		card_kind	= "";
		tm			= 0;
		scd_dt		= "";
		scd_amt		= 0;
		incom_dt	= "";
		incom_seq	= "";
		incom_amt	= 0;
		incom_bigo	= "";
		m_amt		= 0;
		rest_amt	= 0;	
		bank_id		= "";
		bank_nm		= "";
		bank_no		= "";
		magam_st	= "";
		magam_dt	= "";
		s_save_per  = "";
		magam_id	= 0;
		ven_name	= "";

	}

	//Set Method
	public void setSerial		(int    val){								serial		= val;	}
	public void setBase_dt		(String val){	if(val==null) val="";		base_dt		= val;	}
	public void setCardno		(String val){	if(val==null) val="";		cardno		= val;	}
	public void setBase_g		(String val){	if(val==null) val="";		base_g		= val;	}
	public void setBase_amt		(long   val){								base_amt	= val;	}
	public void setSave_per		(float  val){								save_per	= val;	}
	public void setSave_amt		(long   val){								save_amt	= val;	}
	public void setEst_dt		(String val){	if(val==null) val="";		est_dt		= val;	}	
	public void setReg_code		(String val){	if(val==null) val="";		reg_code	= val;	}	
	public void setBase_bigo	(String val){	if(val==null) val="";		base_bigo	= val;	}	
	public void setUpdate_id	(String val){	if(val==null) val="";		update_id	= val;	}	
	public void setUpdate_dt	(String val){	if(val==null) val="";		update_dt	= val;	}	
	public void setReqseq		(String val){	if(val==null) val="";		reqseq		= val;	}	
	public void setCard_kind	(String val){	if(val==null) val="";		card_kind	= val;	}	
	public void setTm			(int    val){								tm			= val;	}
	public void setScd_dt		(String val){	if(val==null) val="";		scd_dt		= val;	}
	public void setScd_amt		(long   val){								scd_amt		= val;	}
	public void setIncom_dt		(String val){	if(val==null) val="";		incom_dt	= val;	}
	public void setIncom_seq	(String val){	if(val==null) val="";		incom_seq	= val;	}
	public void setIncom_amt	(long   val){								incom_amt	= val;	}
	public void setIncom_bigo	(String val){	if(val==null) val="";		incom_bigo	= val;	}
	public void setM_amt		(long   val){								m_amt		= val;	}
	public void setRest_amt		(long   val){								rest_amt	= val;	}
	public void setBank_id		(String val){	if(val==null) val="";		bank_id		= val;	}
	public void setBank_nm		(String val){	if(val==null) val="";		bank_nm		= val;	}
	public void setBank_no		(String val){	if(val==null) val="";		bank_no		= val;	}
	public void setMagam_st		(String val){	if(val==null) val="";		magam_st	= val;	}
	public void setMagam_dt		(String val){	if(val==null) val="";		magam_dt	= val;	}
	public void setS_save_per	(String val){	if(val==null) val="";		s_save_per	= val;	}
	public void setMagam_id		(int    val){								magam_id	= val;	}
	public void setVen_name		(String val){	if(val==null) val="";		ven_name	= val;	}
	

	//Get Method
	public int    getSerial		(){		return		serial;			}
	public String getBase_dt	(){		return		base_dt;		}
	public String getCardno		(){		return		cardno;			}
	public String getBase_g		(){		return		base_g;			}
	public long   getBase_amt	(){		return		base_amt;		}
	public float  getSave_per	(){		return		save_per;		}
	public long   getSave_amt	(){		return		save_amt;		}
	public String getEst_dt		(){		return		est_dt;			}
	public String getReg_code	(){		return		reg_code;		}
	public String getBase_bigo	(){		return		base_bigo;		}
	public String getUpdate_id	(){		return		update_id;		}
	public String getUpdate_dt	(){		return		update_dt;		}	
	public String getReqseq		(){		return		reqseq;			}	
	public String getCard_kind	(){		return		card_kind;		}	
	public int    getTm			(){		return		tm;				}	
	public String getScd_dt		(){		return		scd_dt;			}
	public long   getScd_amt	(){		return		scd_amt;		}
	public String getIncom_dt	(){		return		incom_dt;		}
	public String getIncom_seq	(){		return		incom_seq;		}
	public long   getIncom_amt	(){		return		incom_amt;		}
	public String getIncom_bigo	(){		return		incom_bigo;		}
	public long   getM_amt		(){		return		m_amt;			}
	public long   getRest_amt	(){		return		rest_amt;		}
	public String getBank_id	(){		return		bank_id;		}
	public String getBank_nm	(){		return		bank_nm;		}
	public String getBank_no	(){		return		bank_no;		}
	public String getMagam_st	(){		return		magam_st;		}
	public String getMagam_dt	(){		return		magam_dt;		}
	public String getS_save_per	(){		return		s_save_per;		}
	public int    getMagam_id	(){		return		magam_id;		}
	public String getVen_name	(){		return		ven_name;		}


}
