package acar.bank_mng;

public class BankAgntBean
{
	private String lend_id;
	private String seq;
	private String ba_nm;
	private String ba_title;
	private String ba_tel;
	private String ba_email;
	
	public BankAgntBean()
	{
		lend_id	= "";
		seq		= "";
		ba_nm	= "";
		ba_title= "";
		ba_tel	= "";
		ba_email= "";
	}
	
	public void setLend_id(String str)	{	lend_id	= str;	}
	public void setSeq(String str)		{	seq		= str;	}
	public void setBa_nm(String str)	{	ba_nm	= str;	}
	public void setBa_title(String str)	{	ba_title= str;	}
	public void setBa_tel(String str)	{	ba_tel	= str;	}
	public void setBa_email(String str)	{	ba_email= str;	}
	
	public String getLend_id()	{	return	  lend_id;	} 
	public String getSeq()		{	return	  seq;		} 
	public String getBa_nm()	{	return	  ba_nm;	} 
	public String getBa_title()	{	return	  ba_title;	} 
	public String getBa_tel()	{	return	  ba_tel;	} 
	public String getBa_email()	{	return	  ba_email;	} 
}