package acar.con_ins_h;

public class InsHScdBean
{
	private String rent_mng_id;	// 계약관리번호
	private String rent_l_cd;	// 계약번호    
	private String car_mng_id;	// 차량관리번호        
	private String accid_id;    // 사고관리번호
	private String gubun; 
	private String accid_dt;
	private String accid_st;
	private String ot_ins;
	private String req_gu; 
	private int    req_amt; 
	private int    pay_amt; 
	private int    dly_amt; 
	private int ext_v_amt; 
	private int ext_s_amt; 
	private String req_dt; 
	private String pay_dt;
	private String dly_days;
	//추가
	private String ext_dt;		//세금계산서 발행일
	private String ext_id;		//스케쥴key accid_id || seq_no
	private String update_dt;	//수정자
	private String update_id;	//수정일
	private int    seq_no; 
	private String pay_gu; 
	private String ext_tm;	//납입회차
	private String bill_doc_yn;	//0:미발행 1:발행

	public InsHScdBean()
	{
		rent_mng_id = "";
		rent_l_cd   = ""; 
		car_mng_id	= "";
		accid_id	= "";
		gubun       = "";
		accid_dt    = "";
		accid_st    = "";
		ot_ins      = "";
		req_gu		= "";
		req_amt		= 0;
		pay_amt		= 0;
		dly_amt     = 0;
		ext_v_amt     = 0;
		ext_s_amt     = 0;
		req_dt		= "";
		pay_dt		= "";
		dly_days	= "";
		ext_dt		= "";
		ext_id		= "";
		update_dt	= "";
		update_id	= "";
		seq_no		= 0;
		pay_gu		= "";
		ext_tm = "";
		bill_doc_yn = "";

	}
	
	public void setRent_mng_id(String str)	{ rent_mng_id	= str; } 
	public void setRent_l_cd(String str)	{ rent_l_cd		= str; } 
	public void setCar_mng_id(String str)	{ car_mng_id	= str; }    
	public void setAccid_id(String str)		{ accid_id		= str; } 
	public void setGubun(String str)		{ gubun			= str; } 
	public void setAccid_dt(String str)		{ accid_dt		= str; } 
	public void setAccid_st(String str)		{ accid_st		= str; } 
	public void setOt_ins(String str)		{ ot_ins		= str; } 
	public void setReq_gu(String str)		{ req_gu		= str; } 
	public void setReq_amt(int i)			{ req_amt		= i;   } 
	public void setPay_amt(int i)			{ pay_amt		= i;   } 
	public void setDly_amt(int i)			{ dly_amt		= i;   } 
	public void setExt_v_amt(int i)			{ ext_v_amt		= i;   } 
	public void setExt_s_amt(int i)			{ ext_s_amt		= i;   } 
	public void setDly_days(String str)		{ dly_days		= str; } 
	public void setReq_dt(String str)		{ req_dt		= str; } 
	public void setPay_dt(String str)		{ pay_dt		= str; } 
	public void setExt_dt(String str)		{ ext_dt		= str; }
	public void setExt_id(String str)		{ ext_id		= str; }
	public void setUpdate_dt(String str)	{ update_dt		= str; }
	public void setUpdate_id(String str)	{ update_id		= str; }
	public void setSeq_no(int i)			{ seq_no		= i;   } 
	public void setPay_gu(String str)		{ pay_gu		= str; } 
	public void setExt_tm(String str)	{ ext_tm = str; }
	public void setBill_doc_yn(String str)	{ bill_doc_yn = str; }
	
	public String getRent_mng_id()	{ return rent_mng_id;	} 
	public String getRent_l_cd()	{ return rent_l_cd;		} 
	public String getCar_mng_id()	{ return car_mng_id; 	}    
	public String getAccid_id()		{ return accid_id; 		} 
	public String getGubun()		{ return gubun; 		} 
	public String getAccid_dt()		{ return accid_dt;		} 
	public String getAccid_st()		{ return accid_st;		} 
	public String getOt_ins()		{ return ot_ins;		} 
	public String getReq_gu()		{ return req_gu;		} 
	public int    getReq_amt()		{ return req_amt;		} 
	public int    getPay_amt()		{ return pay_amt;		} 
	public int    getDly_amt()		{ return dly_amt;		} 
	public int    getExt_v_amt()	{ return ext_v_amt;		} 
	public int    getExt_s_amt()	{ return ext_s_amt;		} 
	public String getDly_days()		{ return dly_days;		} 
	public String getReq_dt()		{ return req_dt;		} 
	public String getPay_dt()		{ return pay_dt;		}  
	public String getExt_dt()		{ return ext_dt;		}  
	public String getExt_id()		{ return ext_id;		}  
	public String getUpdate_dt()	{ return update_dt;		}  
	public String getUpdate_id()	{ return update_id;		}  
	public int    getSeq_no()		{ return seq_no;		} 
	public String getPay_gu()		{ return pay_gu;		} 
	public String getExt_tm()		{ return ext_tm; }  
	public String getBill_doc_yn()		{ return bill_doc_yn; }  

}