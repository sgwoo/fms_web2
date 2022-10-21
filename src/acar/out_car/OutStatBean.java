package acar.out_car;

import java.util.*;

public class OutStatBean {

	//Table : 자체출고캐쉬백 기본,스케줄
	private int    serial;
	private String rent_mng_id;
	private String rent_l_cd;
	private String car_mng_id;
	private String car_off_id;
	private String ven_code;
	private String base_bigo;
	private String base_dt;
	private long   base_amt;
	private String est_dt;				
	private String use_yn;							
	private String update_id;
	private String update_dt;
	private String incom_dt;
	private String incom_seq;
	private long   incom_amt;
	private long   m_amt;
	private long   rest_amt;
	private String bank_id;	
	private String bank_nm;	
	private String bank_no;	
	private String ven_name;	
	private String car_comp_id;
	private String incom_bigo;

	// CONSTRCTOR            
	public OutStatBean() {  
		serial		= 0;
		rent_mng_id	= "";
		rent_l_cd	= "";
		car_mng_id	= "";
		car_off_id	= "";
		ven_code	= "";
		base_bigo	= "";
		base_dt		= "";
		base_amt	= 0;
		est_dt		= "";
		use_yn		= "";		
		update_id	= "";
		update_dt	= "";
		incom_dt	= "";
		incom_seq	= "";
		incom_amt	= 0;
		m_amt		= 0;
		rest_amt	= 0;	
		bank_id		= "";
		bank_nm		= "";
		bank_no		= "";
		ven_name	= "";
		car_comp_id	= "";
		incom_bigo	= "";
	}

	//Set Method
	public void setSerial		(int    val){								serial		= val;	}
	public void setRent_mng_id	(String val){	if(val==null) val="";		rent_mng_id	= val;	}
	public void setRent_l_cd	(String val){	if(val==null) val="";		rent_l_cd	= val;	}
	public void setCar_mng_id	(String val){	if(val==null) val="";		car_mng_id	= val;	}
	public void setCar_off_id	(String val){	if(val==null) val="";		car_off_id	= val;	}
	public void setVen_code		(String val){	if(val==null) val="";		ven_code	= val;	}
	public void setBase_bigo	(String val){	if(val==null) val="";		base_bigo	= val;	}
	public void setBase_dt		(String val){	if(val==null) val="";		base_dt		= val;	}
	public void setBase_amt		(long   val){								base_amt	= val;	}
	public void setEst_dt		(String val){	if(val==null) val="";		est_dt		= val;	}	
	public void setUse_yn		(String val){	if(val==null) val="";		use_yn		= val;	}	
	public void setUpdate_id	(String val){	if(val==null) val="";		update_id	= val;	}	
	public void setUpdate_dt	(String val){	if(val==null) val="";		update_dt	= val;	}	
	public void setIncom_dt		(String val){	if(val==null) val="";		incom_dt	= val;	}
	public void setIncom_seq	(String val){	if(val==null) val="";		incom_seq	= val;	}
	public void setIncom_amt	(long   val){								incom_amt	= val;	}
	public void setM_amt		(long   val){								m_amt		= val;	}
	public void setRest_amt		(long   val){								rest_amt	= val;	}
	public void setBank_id		(String val){	if(val==null) val="";		bank_id		= val;	}
	public void setBank_nm		(String val){	if(val==null) val="";		bank_nm		= val;	}
	public void setBank_no		(String val){	if(val==null) val="";		bank_no		= val;	}
	public void setVen_name		(String val){	if(val==null) val="";		ven_name	= val;	}
	public void setCar_comp_id	(String val){	if(val==null) val="";		car_comp_id	= val;	}
	public void setIncom_bigo	(String val){	if(val==null) val="";		incom_bigo	= val;	}
	

	//Get Method
	public int    getSerial		(){		return		serial;			}
	public String getRent_mng_id(){		return		rent_mng_id;	}
	public String getRent_l_cd	(){		return		rent_l_cd;		}
	public String getCar_mng_id	(){		return		car_mng_id;		}
	public String getCar_off_id	(){		return		car_off_id;		}
	public String getVen_code	(){		return		ven_code;		}
	public String getBase_bigo	(){		return		base_bigo;		}
	public String getBase_dt	(){		return		base_dt;		}
	public long   getBase_amt	(){		return		base_amt;		}
	public String getEst_dt		(){		return		est_dt;			}
	public String getUse_yn		(){		return		use_yn;			}
	public String getUpdate_id	(){		return		update_id;		}
	public String getUpdate_dt	(){		return		update_dt;		}	
	public String getIncom_dt	(){		return		incom_dt;		}
	public String getIncom_seq	(){		return		incom_seq;		}
	public long   getIncom_amt	(){		return		incom_amt;		}
	public long   getM_amt		(){		return		m_amt;			}
	public long   getRest_amt	(){		return		rest_amt;		}
	public String getBank_id	(){		return		bank_id;		}
	public String getBank_nm	(){		return		bank_nm;		}
	public String getBank_no	(){		return		bank_no;		}
	public String getVen_name	(){		return		ven_name;		}
	public String getCar_comp_id(){		return		car_comp_id;	}
	public String getIncom_bigo	(){		return		incom_bigo;		}


}
