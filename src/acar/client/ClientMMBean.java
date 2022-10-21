package acar.client;

public class ClientMMBean
{
	private String client_id;
	private String reg_id;
	private String content;
	private String reg_dt;
	private String seq;
	
	public ClientMMBean()
	{
		client_id	= "";
		reg_id		= "";
		content		= "";
		reg_dt		= "";
		seq		= "";
	}
	
	public void setClient_id(String str)	{	client_id	= str;	}
	public void setReg_id(String str)		{	reg_id		= str;	}
	public void setContent(String str)		{	content		= str;	}
	public void setReg_dt(String str)		{	reg_dt		= str;	}
	public void setSeq(String str)		{	seq		= str;	}
	
	public String getClient_id(){	return	client_id;}
	public String getReg_id()	{	return	reg_id;	}
	public String getContent()	{	return	content;}
	public String getReg_dt()	{	return	reg_dt;	}
	public String getSeq()		{	return	seq;	}
}