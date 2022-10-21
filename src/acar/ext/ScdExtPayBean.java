package acar.ext;

public class ScdExtPayBean
{
	private String rent_mng_id; //단기:단기계약번호
	private String rent_l_cd;   //단기:자동차관리번호
	private String car_mng_id;
	private int    pay_amt;
	private String pay_dt;
	
	public ScdExtPayBean()
	{
		rent_mng_id	= "";
		rent_l_cd	= "";
		car_mng_id		= "";
		pay_amt	= 0;
		pay_dt	= "";

	}
	
	public void setRent_mng_id(String str)	{	rent_mng_id	= str; }
	public void setRent_l_cd(String str)	{	rent_l_cd	= str; }
	public void setCar_mng_id(String str)		{	car_mng_id		= str; }
	public void setPay_amt(int i)		{	pay_amt	= i; }
	public void setPay_dt(String str)	{	pay_dt	= str; }
	
	public String getRent_mng_id()	{	return rent_mng_id;	}	
	public String getRent_l_cd()	{	return rent_l_cd;	}
	public String getCar_mng_id()	{	return car_mng_id;		}
	public int    getPay_amt()	{	return pay_amt;	}
	public String getPay_dt()	{	return pay_dt;	}


}
