/*
 * 특소세관리
 */
package acar.con_tax;

public class TaxRateBean
{
	private String tax_nm;		//세율구분
	private String dpm;			//배기량
	private String reg_dt;		//등록일자
	private String reg_id;		//등록자
	private String tax_st_dt;	//기준일자
	private String tax_rate; 	//세율
	private String rate_st1;
	private String rate_st2;
	
	public TaxRateBean()
	{
		tax_nm		= "";
		dpm 		= "";
		reg_dt		= "";
		reg_id 		= "";
		tax_st_dt	= "";
		tax_rate 	= "";
		rate_st1	= "";
		rate_st2	= "";
	}
	
	public void setTax_nm(String str)		{	tax_nm		= str;	}
	public void setDpm(String str)			{	dpm 		= str;	}
	public void setReg_dt(String str)		{	reg_dt 		= str;	}
	public void setReg_id(String str)		{	reg_id 		= str;	}
	public void setTax_st_dt(String str)	{	tax_st_dt	= str;	}
	public void setTax_rate(String str)		{	tax_rate 	= str;	}
	public void setRate_st1(String str)		{	rate_st1 	= str;	}
	public void setRate_st2(String str)		{	rate_st2 	= str;	}
	
	public String getTax_nm()		{	return tax_nm;		}
	public String getDpm()			{	return dpm;			}
	public String getReg_dt()		{	return reg_dt;		}
	public String getReg_id()		{	return reg_id;		}
	public String getTax_st_dt()	{	return tax_st_dt;	}
	public String getTax_rate()		{	return tax_rate;	}
	public String getRate_st1()		{	return rate_st1;	}
	public String getRate_st2()		{	return rate_st2;	}

}