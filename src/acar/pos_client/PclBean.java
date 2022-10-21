package acar.pos_client;

public class PclBean
{
	private String pos_id;
	private String user_id;
	private String firm_nm;
	private String pos_agnt;
	private String addr;
	private String zip_cd;
	private String h_tel;
	private String m_tel;
	private String fax;
	private String pcar_id;
	private String bus_st;
	private String init_reg_dt;
	private String etc;
	private String car_com;
	
	public PclBean()
	{
		pos_id		=	"";
		user_id		=	"";
		firm_nm		=	"";
		pos_agnt	=	"";
		addr		=	"";
		zip_cd		=	"";
		h_tel		=	"";
		m_tel		=	"";
		fax			=	"";
		pcar_id		=	"";
		bus_st		=	"";
		init_reg_dt	=	"";
		etc	=	"";
		car_com	= "";
	}
	
	public void setPos_id(String str)	{	pos_id	= str;	}
	public void setUser_id(String str)	{	user_id	= str;	}
	public void setFirm_nm(String str)	{	firm_nm	= str;	}
	public void setPos_agnt(String str)	{	pos_agnt= str;	}
	public void setAddr(String str)		{	addr	= str;	}
	public void setZip_cd(String str)	{	zip_cd	= str;	}
	public void setH_tel(String str)	{	h_tel	= str;	}
	public void setM_tel(String str)	{	m_tel	= str;	}
	public void setFax(String str)		{	fax		= str;	}
	public void setPcar_id(String str)	{	pcar_id	= str;	}
	public void setBus_st(String str)	{	bus_st	= str;	}
	public void setInit_reg_dt(String str)	{	init_reg_dt	= str;	}
	public void setEtc(String str)		{	etc	= str;	}
	public void setCar_com(String str)		{	car_com	= str;	}
	
	public String getPos_id()	{	return	pos_id;		}  
	public String getUser_id()	{	return	user_id;	}  
	public String getFirm_nm()	{	return	firm_nm;	}  
	public String getPos_agnt()	{	return	pos_agnt;	}  
	public String getAddr()		{	return	addr;		}  
	public String getZip_cd()	{	return	zip_cd;		}  
	public String getH_tel()	{	return	h_tel;		}  
	public String getM_tel()	{	return	m_tel;		}  
	public String getFax()		{	return	fax;		}  
	public String getPcar_id()	{	return	pcar_id;	}  
	public String getBus_st()	{	return	bus_st;		}  
	public String getInit_reg_dt()	{	return	init_reg_dt;		}  
	public String getEtc()		{	return	etc;		}  
	public String getCar_com()		{	return	car_com;		}  
}