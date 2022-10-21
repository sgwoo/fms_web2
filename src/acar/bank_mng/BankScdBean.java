package acar.bank_mng;

public class BankScdBean
{
	private String lend_id;
	private String rtn_seq;
	private String alt_tm;
	private String alt_est_dt;
	private int    alt_prn_amt;
	private int    alt_int_amt;
	private String pay_dt;
	private String pay_yn;
	private long    alt_rest;
	private String r_alt_est_dt;
	private String cls_rtn_dt;	//중도상환일
	
	public BankScdBean()
	{
		lend_id		= "";
		rtn_seq		= "";
		alt_tm		= "";
		alt_est_dt	= "";
		alt_prn_amt	= 0;
		alt_int_amt	= 0;
		pay_dt		= "";
		pay_yn		= "";
		alt_rest	= 0;
		r_alt_est_dt= "";
		cls_rtn_dt	= "";

	}
	
	
	public void setLend_id(String str)	{	lend_id		= str;	}
	public void setRtn_seq(String str)	{	rtn_seq		= str;	}
	public void setAlt_tm(String str)	{	alt_tm		= str;	}
	public void setAlt_est_dt(String str){	alt_est_dt	= str;	}
	public void setAlt_prn_amt(int i)	{	alt_prn_amt	= i;	}
	public void setAlt_int_amt(int i)	{	alt_int_amt	= i;	}
	public void setPay_dt(String str)	{	pay_dt		= str;	}
	public void setPay_yn(String str)	{	pay_yn		= str;	}
	public void setAlt_rest(long i)		{	alt_rest	= i;	}
	public void setR_alt_est_dt(String str){r_alt_est_dt= str;	}
	public void setCls_rtn_dt(String str)	{ cls_rtn_dt	= str;	}
	
	public String getLend_id()	{	return	lend_id;	}
	public String getRtn_seq()	{	return	rtn_seq;	}
	public String getAlt_tm()	{	return	alt_tm;		}
	public String getAlt_est_dt(){	return	alt_est_dt;	}
	public int    getAlt_prn_amt(){	return	alt_prn_amt;}
	public int    getAlt_int_amt(){	return	alt_int_amt;}
	public String getPay_dt()	{	return	pay_dt;		}
	public String getPay_yn()	{	return	pay_yn;		}
	public long    getAlt_rest(){	return	alt_rest;}	
	public String getR_alt_est_dt(){return	r_alt_est_dt;}
	public String getCls_rtn_dt()	{ return cls_rtn_dt;}
}