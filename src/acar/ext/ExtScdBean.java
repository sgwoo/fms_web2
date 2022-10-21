package acar.ext;

public class ExtScdBean
{
	private String rent_mng_id; //단기:단기계약번호
	private String rent_l_cd;   //단기:자동차관리번호
	private String rent_st;
	private String rent_seq;
	private String ext_st;	//0:보증금, 1:선납금, 2:초기대여료
	private String rent_id;
	private String ext_tm;
	private String ext_id;
	private int    ext_s_amt;
	private int    ext_v_amt;
	private String ext_est_dt;
	private int    ext_pay_amt;
	private String ext_pay_dt;
	//추가
	private String ext_dt;	
	private String dly_days;		
	private int    dly_amt;
	private String update_dt;	//수정자
	private String update_id;	//수정일
	
	private String seqid;		//전자입금표일련번호
	private String pubcode;		//전자입금표일련코드

	private String gubun;		//해지관련
	
	private String incom_dt;   //입금원장:입금일
	private int	   incom_seq;  //입금원장:순번

	private String status;		//전자입금표사태
	private String bill_yn;		//전자입금표사태
	
	private String jung_st;		//해지정산금 정산구분 :1:합산, 2:구분, 3:카드
	
	public ExtScdBean()
	{
		rent_mng_id	= "";
		rent_l_cd	= "";
		rent_st		= "";
		rent_seq	= "";
		ext_st		= "";
		ext_id		= "";
		rent_id		= "";
		ext_tm		= "";
		ext_s_amt	= 0;
		ext_v_amt	= 0;
		ext_est_dt	= "";
		ext_pay_amt	= 0;
		ext_pay_dt	= "";
		dly_days	= "";
		ext_dt		= "";
		dly_amt		= 0;
		update_dt	= "";
		update_id	= "";
		seqid		= "";
		pubcode		= "";
		gubun		= "";
		
		incom_dt = "";
		incom_seq = 0;

		status		= "";
		bill_yn		= "";
		jung_st		= "";
	}
	
	public void setRent_mng_id(String str)	{	rent_mng_id	= str; }
	public void setRent_l_cd(String str)	{	rent_l_cd	= str; }
	public void setRent_st(String str)		{	rent_st		= str; }
	public void setRent_seq(String str)		{	rent_seq		= str; }
	public void setExt_st(String str)		{	ext_st		= str; }
	public void setExt_id(String str)		{	ext_id		= str; }
	public void setRent_id(String str)		{	rent_id		= str; }
	public void setExt_tm(String str)		{	ext_tm		= str; }
	public void setExt_s_amt(int i)			{	ext_s_amt	= i; }
	public void setExt_v_amt(int i)			{	ext_v_amt	= i; }
	public void setExt_est_dt(String str)	{	ext_est_dt	= str; }
	public void setExt_pay_amt(int i)		{	ext_pay_amt	= i; }
	public void setExt_pay_dt(String str)	{	ext_pay_dt	= str; }
	public void setExt_dt(String str)		{	ext_dt		= str; }
	public void setDly_days(String str)		{	dly_days		= str; }
	public void setDly_amt(int i)			{	dly_amt		= i; }
	public void setUpdate_dt(String str)	{	update_dt	= str; }
	public void setUpdate_id(String str)	{	update_id	= str; }
	public void setSeqId(String str)		{	seqid		= str; }
	public void setPubCode(String str)		{	pubcode		= str; }
	public void setGubun(String str)		{	gubun		= str; }
	
	public void setIncom_dt(String str)		{ incom_dt	= str; }
	public void setIncom_seq(int i)			{ incom_seq    = i; } 
	public void setStatus(String str)		{	status		= str; }
	public void setBill_yn(String str)		{	bill_yn		= str; }
	public void setJung_st(String str)		{	jung_st		= str; }
	
	public String getRent_mng_id()	{	return rent_mng_id;	}	
	public String getRent_l_cd()	{	return rent_l_cd;	}
	public String getRent_st()		{	return rent_st;		}
	public String getRent_seq()		{	return rent_seq;	}
	public String getExt_st()		{	return ext_st;		}
	public String getExt_id()		{	return ext_id;		}
	public String getRent_id()		{	return rent_id;		}
	public String getExt_tm()		{	return ext_tm;		}
	public int    getExt_s_amt()	{	return ext_s_amt;	}
	public int    getExt_v_amt()	{	return ext_v_amt;	}
	public String getExt_est_dt()	{	return ext_est_dt;	}
	public int    getExt_pay_amt()	{	return ext_pay_amt;	}
	public String getExt_pay_dt()	{	return ext_pay_dt;	}
	public String getExt_dt()		{	return ext_dt;		}  
	public String getDly_days()		{	return dly_days;	}  
	public int	  getDly_amt()		{	return dly_amt;		}  
	public String getUpdate_dt()	{	return update_dt;	}  
	public String getUpdate_id()	{	return update_id;	}  
	public String getSeqId()		{	return seqid;		}  
	public String getPubCode()		{	return pubcode;		}  
	public String getGubun()		{	return gubun;		} 
	
	public String getIncom_dt()		{ return incom_dt; }  
	public int	  getIncom_seq()	{ return incom_seq; }   

	public String getStatus()		{	return status;		}  
	public String getBill_yn()		{	return bill_yn;		}  
	public String getJung_st()		{	return jung_st;		}  

}
