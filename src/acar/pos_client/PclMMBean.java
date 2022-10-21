package acar.pos_client;

public class PclMMBean
{
	private String pos_id;
	private String seq;
	private String reg_id;
	private String reg_dt;
	private String speaker;
	private String content;
	
	public PclMMBean()
	{
		pos_id	=	"";
		seq		=	"";
		reg_id	=	"";
		reg_dt	=	"";
		speaker	=	"";
		content	=	"";
	}
	
	public void setPos_id(String str)	{	pos_id	= str;	}
	public void setSeq(String str)		{	seq		= str;	}
	public void setReg_id(String str)	{	reg_id	= str;	}
	public void setReg_dt(String str)	{	reg_dt	= str;	}
	public void setSpeaker(String str)	{	speaker = str;	}
	public void setContent(String str)	{	content = str;	}
	
	public String getPos_id()	{	return	pos_id;	}
	public String getSeq()		{	return	seq;	}
	public String getReg_id()	{	return	reg_id;	}
	public String getReg_dt()	{	return	reg_dt;	}
	public String getSpeaker()	{	return	speaker;	}
	public String getContent()	{	return	content;	}
}