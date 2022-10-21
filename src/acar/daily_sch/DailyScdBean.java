package acar.daily_sch;

public class DailyScdBean
{
	private String year;
	private String mon;
	private String day;
	private String seq;
	private String user_id;
	private String title;
	private String content;
	private String status;

	public DailyScdBean()
	{
		year	= "";
		mon		= "";
		day		= "";
		seq		= "";
		user_id	= "";
		title	= "";
		content	= "";
		status	= "";
	}

	public void setYear(String str)		{	year   = str;	}
	public void setMon(String str)		{	mon    = str;	}
	public void setDay(String str)		{	day    = str;	}
	public void setSeq(String str)		{	seq    = str;	}
	public void setUser_id(String str)	{	user_id = str;	}
	public void setTitle(String str)	{	title  = str;	}
	public void setContent(String str)	{	content = str;	}
	public void setStatus(String str)	{	status = str;	}
	
	
	public String getYear()		{	return	year;	}
	public String getMon()		{	return	mon;	}
	public String getDay()		{	return	day;	}
	public String getSeq()		{	return	seq;	}
	public String getUser_id()	{	return	user_id;	}
	public String getTitle()	{	return	title;	}
	public String getContent()	{	return	content;	}
	public String getStatus()	{	return	status;	}
}