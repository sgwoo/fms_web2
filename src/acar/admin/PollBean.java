package acar.admin;

public class PollBean
{
	private int p_num;
	private String p_title;
	private int p_qcount;
	private String p_q1;
	private String p_q2;
	private String p_q3;
	private String p_q4;
	private String p_q5;
	private String p_q6;
	private String p_q7;
	private String p_q8;
	private String use_yn;
	private String q1_rem;
	private String q2_rem;
	private String q3_rem;
	private String q4_rem;
	private String q5_rem;
	private String q6_rem;
	private String q7_rem;
	private String q8_rem;
	private int p_q1_count;
	private int p_q2_count;
	private int p_q3_count;
	private int p_q4_count;
	private int p_q5_count;
	private int p_q6_count;
	private int p_q7_count;
	private int p_q8_count;
	private int p_q1_count_u;
	private int p_q2_count_u;
	private int p_q3_count_u;
	private int p_q4_count_u;
	private int p_q5_count_u;
	private int p_q6_count_u;
	private int p_q7_count_u;
	private int p_q8_count_u;
	private String en_dt_yn;
	

		
	public PollBean()
	{
		p_num = 0;
		p_title = "";
		p_qcount = 0;
		p_q1 = "";
		p_q2 = "";
		p_q3 = "";
		p_q4 = "";
		p_q5 = "";
		p_q6 = "";
		p_q7 = "";
		p_q8 = "";
		q1_rem = "";
		q2_rem = "";
		q3_rem = "";
		q4_rem = "";
		q5_rem = "";
		q6_rem = "";
		q7_rem = "";
		q8_rem = "";
		use_yn = "";
		p_q1_count = 0;
		p_q2_count = 0;
		p_q3_count = 0;
		p_q4_count = 0;
		p_q5_count = 0;
		p_q6_count = 0;
		p_q7_count = 0;
		p_q8_count = 0;
		p_q1_count_u = 0;
		p_q2_count_u = 0;
		p_q3_count_u = 0;
		p_q4_count_u = 0;
		p_q5_count_u = 0;
		p_q6_count_u = 0;
		p_q7_count_u = 0;
		p_q8_count_u = 0;
		en_dt_yn = "";
									
		
	}
	
	public void setP_num(int i)			{	p_num= i;	}
	public void setP_title(String str)	{	p_title = str;	}
	public void setP_qcount(int i)		{	p_qcount=i;	}
	public void setP_q1(String str)	{	p_q1= str;	}
	public void setP_q2(String str)	{	p_q2= str;	}
	public void setP_q3(String str)	{	p_q3= str;	}
	public void setP_q4(String str)	{	p_q4= str;	}
	public void setP_q5(String str)	{	p_q5= str;	}
	public void setP_q6(String str)	{	p_q6= str;	}
	public void setP_q7(String str)	{	p_q7= str;	}
	public void setP_q8(String str)	{	p_q8= str;	}
	public void setUse_yn(String str)	{	use_yn= str;	}
	public void setQ1_rem(String str)	{	q1_rem= str;	}
	public void setQ2_rem(String str)	{	q2_rem= str;	}
	public void setQ3_rem(String str)	{	q3_rem= str;	}
	public void setQ4_rem(String str)	{	q4_rem= str;	}
	public void setQ5_rem(String str)	{	q5_rem= str;	}
	public void setQ6_rem(String str)	{	q6_rem= str;	}
	public void setQ7_rem(String str)	{	q7_rem= str;	}
	public void setQ8_rem(String str)	{	q8_rem= str;	}
	public void setP_q1_count(int i)		{	p_q1_count=i;	}
	public void setP_q2_count(int i)		{	p_q2_count=i;	}
	public void setP_q3_count(int i)		{	p_q3_count=i;	}
	public void setP_q4_count(int i)		{	p_q4_count=i;	}
	public void setP_q5_count(int i)		{	p_q5_count=i;	}
	public void setP_q6_count(int i)		{	p_q6_count=i;	}
	public void setP_q7_count(int i)		{	p_q7_count=i;	}
	public void setP_q8_count(int i)		{	p_q8_count=i;	}
	public void setP_q1_count_u(int i)		{	p_q1_count_u=i;	}
	public void setP_q2_count_u(int i)		{	p_q2_count_u=i;	}
	public void setP_q3_count_u(int i)		{	p_q3_count_u=i;	}
	public void setP_q4_count_u(int i)		{	p_q4_count_u=i;	}
	public void setP_q5_count_u(int i)		{	p_q5_count_u=i;	}
	public void setP_q6_count_u(int i)		{	p_q6_count_u=i;	}
	public void setP_q7_count_u(int i)		{	p_q7_count_u=i;	}
	public void setP_q8_count_u(int i)		{	p_q8_count_u=i;	}
	public void setEn_dt_yn(String str)	{	en_dt_yn= str;	}
		
	public int	  getP_num()	{	return p_num;		}
	public String getP_title()	{	return p_title;	    }
	public int	  getP_qcount()	{	return p_qcount;	}
	public String getP_q1()		{	return p_q1;	}
	public String getP_q2()		{	return p_q2;	}
	public String getP_q3()		{	return p_q3;	}
	public String getP_q4()		{	return p_q4;	}
	public String getP_q5()		{	return p_q5;	}
	public String getP_q6()		{	return p_q6;	}
	public String getP_q7()		{	return p_q7;	}
	public String getP_q8()		{	return p_q8;	}
	
	public String getQ1_rem()	{	return q1_rem;	}
	public String getQ2_rem()	{	return q2_rem;	}
	public String getQ3_rem()	{	return q3_rem;	}
	public String getQ4_rem()	{	return q4_rem;	}
	public String getQ5_rem()	{	return q5_rem;	}
	public String getQ6_rem()	{	return q6_rem;	}
	public String getQ7_rem()	{	return q7_rem;	}
	public String getQ8_rem()	{	return q8_rem;	}
	
	public String getUse_yn()	{	return use_yn;	}
	
	public int	  getP_q1_count()	{	return p_q1_count;	}
	public int	  getP_q2_count()	{	return p_q2_count;	}
	public int	  getP_q3_count()	{	return p_q3_count;	}
	public int	  getP_q4_count()	{	return p_q4_count;	}
	public int	  getP_q5_count()	{	return p_q5_count;	}
	public int	  getP_q6_count()	{	return p_q6_count;	}
	public int	  getP_q7_count()	{	return p_q7_count;	}
	public int	  getP_q8_count()	{	return p_q8_count;	}
	public int	  getP_q1_count_u()	{	return p_q1_count_u;	}
	public int	  getP_q2_count_u()	{	return p_q2_count_u;	}
	public int	  getP_q3_count_u()	{	return p_q3_count_u;	}
	public int	  getP_q4_count_u()	{	return p_q4_count_u;	}
	public int	  getP_q5_count_u()	{	return p_q5_count_u;	}
	public int	  getP_q6_count_u()	{	return p_q6_count_u;	}
	public int	  getP_q7_count_u()	{	return p_q7_count_u;	}
	public int	  getP_q8_count_u()	{	return p_q8_count_u;	}
	
	public String getEn_dt_yn()	{	return en_dt_yn;	}
		
}

