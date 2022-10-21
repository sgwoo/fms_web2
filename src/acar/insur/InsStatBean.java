package acar.insur;

public class InsStatBean
{
	private String dt;
	private String st;
	private int su1;
	private int su2;
	private int su3;
	private int su4;
	private int su5;
	private int su6;
	private int tot_su;
	private long amt1;
	private long amt2;
	private long amt3;
	private long amt4;
	private long amt5;
	private long amt6;
	private long tot_amt;
	
	public InsStatBean()
	{
		dt	= "";
		st	= "";
		su1	= 0;
		su2	= 0;
		su3	= 0;
		su4	= 0;
		su5	= 0;
		su6	= 0;
		tot_su	= 0;
		amt1	= 0;
		amt2	= 0;
		amt3	= 0;
		amt4	= 0;
		amt5	= 0;
		amt6	= 0;
		tot_amt	= 0;
	}
	
	public void setDt(String str)	{	dt	= str;	}
	public void setSt(String str)	{	st	= str;	}
	public void setSu1(int str)		{	su1	= str;	}
	public void setSu2(int str)		{	su2	= str;	}
	public void setSu3(int str)		{	su3	= str;	}
	public void setSu4(int str)		{	su4	= str;	}
	public void setSu5(int str)		{	su5	= str;	}
	public void setSu6(int str)		{	su6	= str;	}
	public void setTot_su(int str)	{	tot_su= str;}
	public void setAmt1(long str)	{	amt1= str;	}
	public void setAmt2(long str)	{	amt2= str;	}
	public void setAmt3(long str)	{	amt3= str;	}
	public void setAmt4(long str)	{	amt4= str;	}
	public void setAmt5(long str)	{	amt5= str;	}
	public void setAmt6(long str)	{	amt6= str;	}
	public void setTot_Amt(long str){	tot_amt=str;}

	
	public String getDt()			{	return	dt;		}
	public String getSt()			{	return	st;		}
	public int getSu1()				{	return	su1;	}
	public int getSu2()				{	return	su2;	}
	public int getSu3()				{	return	su3;	}
	public int getSu4()				{	return	su4;	}
	public int getSu5()				{	return	su5;	}
	public int getSu6()				{	return	su6;	}
	public int getTot_su()			{	return	tot_su;	}
	public long getAmt1()			{	return	amt1;	}
	public long getAmt2()			{	return	amt2;	}
	public long getAmt3()			{	return	amt3;	}
	public long getAmt4()			{	return	amt4;	}
	public long getAmt5()			{	return	amt5;	}
	public long getAmt6()			{	return	amt6;	}
	public long getTot_amt()		{	return	tot_amt;}

}