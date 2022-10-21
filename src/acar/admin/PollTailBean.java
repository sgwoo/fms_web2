package acar.admin;

public class PollTailBean
{
	private int p_num;
	private String user_id;
	private String q_rem1;
	private String q_rem2;
	private String q_rem3;
	private String q_rem4;
	private String q_rem5;
	private String q_rem6;
	private String q_rem7;
	private String q_rem8;

		
	public PollTailBean()
	{
		p_num = 0;
		user_id = "";
		q_rem1 = "";
		q_rem2 = "";
		q_rem3 = "";
		q_rem4 = "";
		q_rem5 = "";
		q_rem6 = "";
		q_rem7 = "";
		q_rem8 = "";
	
		
	}
	
	public void setP_num(int i)			{	p_num= i;	}
	public void setUser_id(String str)	{	user_id = str;	}
	public void setQ_rem1(String str)	{	q_rem1= str;	}
	public void setQ_rem2(String str)	{	q_rem2= str;	}
	public void setQ_rem3(String str)	{	q_rem3= str;	}
	public void setQ_rem4(String str)	{	q_rem4= str;	}
	public void setQ_rem5(String str)	{	q_rem5= str;	}
	public void setQ_rem6(String str)	{	q_rem6= str;	}
	public void setQ_rem7(String str)	{	q_rem7= str;	}
	public void setQ_rem8(String str)	{	q_rem8= str;	}
		
	public int	  getP_num()	{	return p_num;		}
	public String getUser_id()	{	return user_id;	    }
		
	public String getQ_rem1()	{	return q_rem1;	}
	public String getQ_rem2()	{	return q_rem2;	}
	public String getQ_rem3()	{	return q_rem3;	}
	public String getQ_rem4()	{	return q_rem4;	}
	public String getQ_rem5()	{	return q_rem5;	}
	public String getQ_rem6()	{	return q_rem6;	}
	public String getQ_rem7()	{	return q_rem7;	}
	public String getQ_rem8()	{	return q_rem8;	}
	

		
}