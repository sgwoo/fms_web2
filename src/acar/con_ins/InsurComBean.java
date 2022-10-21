package acar.con_ins;

public class InsurComBean
{
	private String ins_com_id;
	private String ins_com_nm;
	private String car_rate;
	private String ins_rate;
	private String ext_date;
	private String agnt_tel;
	private String agnt_fax;
	private String agnt_imgn_tel;
	private String acc_tel;
	private String zip;
	private String addr;
	private String ins_com_f_nm;
	private String zip1;
	private String addr1;
	
	public InsurComBean()
	{
		ins_com_id		= "";
		ins_com_nm		= "";
		car_rate		= "";
		ins_rate		= "";
		ext_date		= "";
		agnt_tel		= "";
		agnt_fax		= "";
		agnt_imgn_tel	= "";
		acc_tel			= "";
		zip				= "";
		addr			= "";
		ins_com_f_nm	= "";
		zip1			= "";
		addr1			= "";
	}
	
	public void setIns_com_id	(String str)		{	ins_com_id		= str;	}
	public void setIns_com_nm	(String str)		{	ins_com_nm		= str;	}
	public void setCar_rate		(String str)		{	car_rate		= str;	}
	public void setIns_rate		(String str)		{	ins_rate		= str;	}
	public void setExt_date		(String str)		{	ext_date		= str;	}
	public void setAgnt_tel		(String str)		{	agnt_tel		= str;	}
	public void setAgnt_fax		(String str)		{	agnt_fax		= str;	}
	public void setAgnt_imgn_tel(String str)		{	agnt_imgn_tel	= str;	}
	public void setAcc_tel		(String str)		{	acc_tel			= str;	}
	public void setZip			(String str)		{	zip				= str;	}
	public void setAddr			(String str)		{	addr			= str;	}
	public void setIns_com_f_nm	(String str)		{	ins_com_f_nm	= str;	}
	public void setZip1			(String str)		{	zip1			= str;	}
	public void setAddr1		(String str)		{	addr1			= str;	}
	
	public String getIns_com_id		()		{	return	ins_com_id;		}
	public String getIns_com_nm		()		{	return	ins_com_nm;		}
	public String getCar_rate		()		{	return	car_rate;		}
	public String getIns_rate		()		{	return	ins_rate;		}
	public String getExt_date		()		{	return	ext_date;		}
	public String getAgnt_tel		()		{	return	agnt_tel;		}
	public String getAgnt_fax		()		{	return	agnt_fax;		}
	public String getAgnt_imgn_tel	()		{	return	agnt_imgn_tel;	}
	public String getAcc_tel		()		{	return	acc_tel;		}
	public String getZip			()		{	return	zip;			}
	public String getAddr			()		{	return	addr;			}
	public String getIns_com_f_nm	()		{	return	ins_com_f_nm;	}
	public String getZip1			()		{	return	zip1;			}
	public String getAddr1			()		{	return	addr1;			}
}