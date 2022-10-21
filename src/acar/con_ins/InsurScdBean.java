package acar.con_ins;

public class InsurScdBean
{
	private String car_mng_id;
	private String ins_tm;
	private String ins_st;
	private String ins_est_dt;
	private int    pay_amt;
	private String pay_yn;
	private String pay_dt;
	
	private String incom_dt;   //입금원장:입금일
	private int	   incom_seq;  //입금원장:순번
	
	public InsurScdBean()
	{
		car_mng_id	= "";
		ins_tm		= "";
		ins_st		= "";
		ins_est_dt	= "";
		pay_amt		= 0;
		pay_yn		= "0";
		pay_dt		= "";
		
		incom_dt = "";
		incom_seq = 0;
	}
	
	public void setCar_mng_id(String str){	car_mng_id	= str;	}
	public void setIns_tm(String str)	{	ins_tm		= str;	}
	public void setIns_st(String str)	{	ins_st		= str;	}
	public void setIns_est_dt(String str){	ins_est_dt	= str;	}
	public void setPay_amt(int i)		{	pay_amt		= i;	}
	public void setPay_yn(String str)	{	pay_yn		= str;	}
	public void setPay_dt(String str)	{	
		pay_dt		= str;	
		if(!pay_dt.equals("")) pay_yn="1";
	}
	
	public void setIncom_dt(String str)		{ incom_dt	= str; }
	public void setIncom_seq(int i)			{ incom_seq    = i; } 
	
	
	public String getCar_mng_id(){	return	car_mng_id;	}
	public String getIns_tm()	{	return	ins_tm;	}
	public String getIns_st()	{	return	ins_st;	}
	public String getIns_est_dt(){	return	ins_est_dt;	}
	public int	  getPay_amt()	{	return	pay_amt;	}
	public String getPay_yn()	{	return	pay_yn;	}
	public String getPay_dt()	{	return	pay_dt;	}
	
	public String getIncom_dt()		{ return incom_dt; }  
	public int	  getIncom_seq()	{ return incom_seq; }  
		
}