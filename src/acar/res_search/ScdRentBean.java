// 단기계약 요금스케줄 관리

// 작성일 : 2003.12.11 (정현미)

package acar.res_search;

public class ScdRentBean
{
	private String rent_s_cd;		//단기계약관리번호
	private String rent_st;			//구분:보증금, 선납금, 대여료, 정산금
	private String tm;				//회차
	private String paid_st;			//입금수단:카드,현금,이체
	private int    rent_s_amt;		//공급가
	private int    rent_v_amt;		//부가세
	private int    pay_amt;			//수금액
	private int    rest_amt;		//잔액
	private String pay_dt;			//입금일자
	private String est_dt;			//예정일자
	private String dly_days;		//연체일자	
	private int    dly_amt;			//연체금액
	private String bill_yn;			//대손처리여부
	private String reg_id;			//등록자
	private String reg_dt;			//등록일
	private String update_id;		//수정자
	private String update_dt;		//수정일
	private String use_s_dt;		//사용기간 시작일
	private String use_e_dt;		//사용기간 종료일	
	private String incom_dt;		//입금원장:입금일
	private int	   incom_seq;		//입금원장:순번
	private String ext_seq;			//연장계약건
	
	public ScdRentBean()
	{
		rent_s_cd	= "";    
		rent_st		= "";    
		tm			= "";    
		paid_st		= "";
		rent_s_amt	= 0;
		rent_v_amt	= 0;
		pay_amt		= 0;
		rest_amt	= 0;
		pay_dt		= "";
		est_dt		= "";
		dly_days	= "";    
		dly_amt		= 0;    
		bill_yn		= "";    
		reg_dt		= "";    
		reg_id		= "";    
		update_dt	= "";    
		update_id	= "";    
		use_s_dt	= "";
		use_e_dt	= "";		
		incom_dt = "";
		incom_seq = 0;
		ext_seq = "";

	}
	
	public void setRent_s_cd	(String str) 	{ rent_s_cd		= str; }
	public void setRent_st		(String str)	{ rent_st		= str; }    	
	public void setTm			(String str)	{ tm			= str; }		
	public void setPaid_st		(String str)	{ paid_st		= str; }    
	public void setRent_s_amt	(int i)			{ rent_s_amt	= i;   }    
	public void setRent_v_amt	(int i)			{ rent_v_amt	= i;   }    
	public void setPay_amt		(int i)			{ pay_amt		= i;   }    
	public void setRest_amt		(int i)			{ rest_amt		= i;   }    
	public void setPay_dt		(String str)	{ pay_dt		= str; }    
	public void setEst_dt		(String str)	{ est_dt		= str; }
	public void setDly_days		(String str)	{ dly_days		= str; }    	
	public void setDly_amt		(int i)			{ dly_amt		= i;   }    	
	public void setBill_yn		(String str)	{ bill_yn		= str; }    
	public void setReg_dt		(String str)	{ reg_dt		= str; }    
	public void setReg_id		(String str)	{ reg_id		= str; }    
	public void setUpdate_dt	(String str)	{ update_dt		= str; }    
	public void setUpdate_id	(String str)	{ update_id		= str; }    
	public void setUse_s_dt		(String str)	{ use_s_dt		= str; }
	public void setUse_e_dt		(String str)	{ use_e_dt		= str; }
	public void setIncom_dt		(String str)	{ incom_dt		= str; }
	public void setIncom_seq	(int i)			{ incom_seq		= i;   } 
	public void setExt_seq		(String str)	{ ext_seq		= str; }
	

	public String getRent_s_cd	() 		{ return rent_s_cd;		}
	public String getRent_st	()		{ return rent_st;		}
	public String getTm			()		{ return tm;			}
	public String getPaid_st	()		{ return paid_st;		}
	public int    getRent_s_amt	()		{ return rent_s_amt;	}
	public int    getRent_v_amt	()		{ return rent_v_amt;	}
	public int    getPay_amt	()		{ return pay_amt;		}
	public int    getRest_amt	()		{ return rest_amt;		}
	public String getPay_dt		()		{ return pay_dt;		}
	public String getEst_dt		()		{ return est_dt;		}
	public String getDly_days	()		{ return dly_days;		}
	public int    getDly_amt	()		{ return dly_amt;		}
	public String getBill_yn	()		{ return bill_yn;		}
	public String getReg_dt		()		{ return reg_dt;		}
	public String getReg_id		()		{ return reg_id;		}
	public String getUpdate_dt	()		{ return update_dt;		}
	public String getUpdate_id	()		{ return update_id;		}
	public String getUse_s_dt	()		{ return use_s_dt;		}  
	public String getUse_e_dt	()		{ return use_e_dt;		}  	
	public String getIncom_dt()		{ return incom_dt; }  
	public int	  getIncom_seq()	{ return incom_seq; } 
	public String getExt_seq()		{ return ext_seq; }  

}