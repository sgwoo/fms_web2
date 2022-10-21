package acar.call;

public class SurveyPollBean
{
	private int poll_id;
	private int poll_seq;	
	private int poll_su;	
	private String use_yn;
	private String poll_st;
	private String poll_type;
	private String poll_title;
	private String start_dt;
	private String end_dt;
	private String reg_id;
	private String reg_dt;

	private int a_seq;
	private String content;
	private String chk;


	




		
	public SurveyPollBean()
	{
		poll_id = 0;
		poll_seq = 0;
		poll_su = 0;
		use_yn = "";
		poll_st = "";
		poll_type = "";
		poll_title = "";
		start_dt = "";
		end_dt = "";
		reg_id = "";
		reg_dt = "";

		a_seq = 0;
		content = "";
		chk = "";
		
	}
	
	public void setPoll_id(int i)			{	poll_id= i;	}
	public void setPoll_seq(int i)			{	poll_seq= i;	}
	public void setPoll_su(int i)			{	poll_su= i;	}	
	public void setUse_yn(String str)		{	use_yn= str;	}
	public void setPoll_st(String str)		{	poll_st= str;	}
	public void setPoll_type(String str)	{	poll_type= str;	}
	public void setPoll_title(String str)	{	poll_title= str;	}
	public void setStart_dt(String str)		{	start_dt= str;	}
	public void setEnd_dt(String str)		{	end_dt= str;	}
	public void setReg_id(String str)		{	reg_id= str;	}
	public void setReg_dt(String str)		{	reg_dt= str;	}

	public void setA_seq(int i)				{	a_seq= i;	}
	public void setContent(String str)		{	content = str;	}
	public void setChk(String str)			{	chk= str;	}

	
	public int	  getPoll_id()				{	return poll_id;		}
	public int	  getPoll_seq()				{	return poll_seq;		}
	public int	  getPoll_su()				{	return poll_su;		}
	public String getUse_yn()				{	return use_yn;	}
	public String getPoll_st()				{	return poll_st;	}
	public String getPoll_type()			{	return poll_type;	}
	public String getPoll_title()			{	return poll_title;	}
	public String getStart_dt()				{	return start_dt;	}
	public String getEnd_dt()				{	return end_dt;	}
	public String getReg_id()				{	return reg_id;	}
	public String getReg_dt()				{	return reg_dt;	}

	public int	  getA_seq()				{	return a_seq;		}
	public String getContent()				{	return content;	}
	public String getChk()					{	return chk;	}
}