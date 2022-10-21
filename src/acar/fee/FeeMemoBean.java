package acar.fee;

public class FeeMemoBean
{
	private String rent_mng_id;		// 계약관리번호
	private String rent_l_cd;		// 계약번호    
	private String rent_st;			// 구분        
	private String tm_st1;			// 회차구분
	private String seq;				// 일련번호
	private String fee_tm;			// 회차        
	private String reg_id;			// 작성자      
	private String reg_dt;			// 작성일      
	private String content;			// 내용        
	private String speaker;			// 통화자
	private String reg_dt_time;		// 작성일시
	private String mm_st;			// 메모테이블
	private String promise_dt;		// 납부약속일
	private String mm_st2;			// 메모구분
	
	public FeeMemoBean()
	{
		rent_mng_id	= "";
		rent_l_cd 	= "";
		rent_st 	= "";
		tm_st1 		= "";
		seq 		= "";
		fee_tm 		= "";
		reg_id 		= "";
		reg_dt 		= "";
		content 	= "";
		speaker 	= "";
		reg_dt_time	= "";
		mm_st		= "";
		promise_dt  = "";
		mm_st2		= "";
	}
	
	public void setRent_mng_id(String str)	{	rent_mng_id	= str;	}
	public void setRent_l_cd(String str)	{	rent_l_cd 	= str;	}
	public void setRent_st(String str)		{	rent_st 	= str;	}
	public void setTm_st1(String str)		{	tm_st1 		= str;	}
	public void setSeq(String str)			{	seq 		= str;	}
	public void setFee_tm(String str)		{	fee_tm 		= str;	}
	public void setReg_id(String str)		{	reg_id 		= str;	}
	public void setReg_dt(String str)		{	reg_dt 		= str;	}
	public void setContent(String str)		{	content 	= str;	}
	public void setSpeaker(String str)		{	speaker 	= str;	}
	public void setReg_dt_time(String str)	{	reg_dt_time	= str;	}
	public void setMm_st(String str)		{	mm_st 		= str;	}
	public void setPromise_dt(String str)	{	promise_dt	= str;	}
	public void setMm_st2(String str)		{	mm_st2 		= str;	}
	
	public String getRent_mng_id()			{	return rent_mng_id;	}
	public String getRent_l_cd()			{	return rent_l_cd;	}
	public String getRent_st()				{	return rent_st;		}
	public String getTm_st1()				{	return tm_st1;		}
	public String getSeq()					{	return seq;			}
	public String getFee_tm()				{	return fee_tm;		}
	public String getReg_id()				{	return reg_id;		}
	public String getReg_dt()				{	return reg_dt;		}
	public String getContent()				{	return content;		}
	public String getSpeaker()				{	return speaker;		}
	public String getReg_dt_time()			{	return reg_dt_time;	}
	public String getMm_st()				{	return mm_st;		}
	public String getPromise_dt()			{	return promise_dt;	}
	public String getMm_st2()				{	return mm_st2;		}
}