package acar.insur;

public class InsurScdBean
{
	private String car_mng_id;
	private String ins_tm;
	private String ins_tm2;
	private String ins_st;
	private String ins_est_dt;
	private String r_ins_est_dt;
	private int    pay_amt;
	private String pay_yn;
	private String pay_dt;
	//20040901Ãß°¡
	private String ch_tm;
	//20090410
	private String excel_chk;

	
	public InsurScdBean()
	{
		car_mng_id		= "";
		ins_tm			= "";
		ins_tm2			= "";
		ins_st			= "";
		ins_est_dt		= "";
		r_ins_est_dt	= "";
		pay_amt			= 0;
		pay_yn			= "0";
		pay_dt			= "";
		ch_tm			= "";
		excel_chk		= "";
	}
	
	public void setCar_mng_id(String str)	{	car_mng_id	= str;	}
	public void setIns_tm(String str)		{	ins_tm		= str;	}
	public void setIns_tm2(String str)		{	ins_tm2		= str;	}
	public void setIns_st(String str)		{	ins_st		= str;	}
	public void setIns_est_dt(String str)	{	ins_est_dt	= str;	}
	public void setR_ins_est_dt(String str)	{	r_ins_est_dt= str;	}
	public void setPay_amt(int i)			{	pay_amt		= i;	}
	public void setPay_yn(String str)		{	pay_yn		= str;	}
	public void setPay_dt(String str)		{	
		pay_dt		= str;	
		if(!pay_dt.equals("")) pay_yn="1";
	}
	public void setCh_tm(String str)		{	ch_tm		= str;	}
	public void setExcel_chk(String str)	{	excel_chk	= str;	}
	
	public String getCar_mng_id()	{	return	car_mng_id;	}
	public String getIns_tm()		{	return	ins_tm;		}
	public String getIns_tm2()		{	return	ins_tm2;	}
	public String getIns_st()		{	return	ins_st;		}
	public String getIns_est_dt()	{	return	ins_est_dt;	}
	public String getR_ins_est_dt()	{	return	r_ins_est_dt;}
	public int	  getPay_amt()		{	return	pay_amt;	}
	public String getPay_yn()		{	return	pay_yn;		}
	public String getPay_dt()		{	return	pay_dt;		}
	public String getCh_tm()		{	return	ch_tm;		}
	public String getExcel_chk()	{	return	excel_chk;	}
}