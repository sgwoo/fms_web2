package acar.cont;

public class LcScanBean{

	private	String	rent_mng_id		;
	private String	rent_l_cd		;
	private String	seq				;
	private String	file_st			;
	private String	file_cont		;
	private String	file_name		;
	private String	reg_id			;
	private String	reg_dt			;
	private String	upd_id			;
	private String	upd_dt			;
	private String	file_path		;
	private String	file_type		;
	private String	rent_st			;

	public LcScanBean(){
		rent_mng_id		= "";
		rent_l_cd		= "";
		seq				= "";
		file_st			= "";
		file_cont		= "";
		file_name		= "";
		reg_id			= "";
		reg_dt			= "";
		upd_id			= "";
		upd_dt			= "";
		file_path		= "";
		file_type		= "";
		rent_st			= "";
	}

	//setMethod
	public void setRent_mng_id	(String str)	{ if(str==null) str="";	rent_mng_id	= str;	}
	public void setRent_l_cd	(String str)	{ if(str==null) str="";	rent_l_cd	= str;	}
	public void setSeq			(String str)	{ if(str==null) str="";	seq			= str;	}
	public void setFile_st		(String str)	{ if(str==null) str="";	file_st		= str;	}
	public void setFile_cont	(String str)	{ if(str==null) str="";	file_cont	= str;	}
	public void setFile_name	(String str)	{ if(str==null) str="";	file_name	= str;	}
	public void setReg_id		(String str)	{ if(str==null) str="";	reg_id		= str;	}
	public void setReg_dt		(String str)	{ if(str==null) str="";	reg_dt		= str;	}
	public void setUpd_id		(String str)	{ if(str==null) str="";	upd_id		= str;	}
	public void setUpd_dt		(String str)	{ if(str==null) str="";	upd_dt		= str;	}
	public void setFile_path	(String str)	{ if(str==null) str="";	file_path	= str;	}
	public void setFile_type	(String str)	{ if(str==null) str="";	file_type	= str;	}
	public void setRent_st		(String str)	{ if(str==null) str="";	rent_st		= str;	}

	//getMethod
	public	String	getRent_mng_id	()	{	return	rent_mng_id	;	}
	public	String	getRent_l_cd	()	{	return	rent_l_cd	;	}
	public	String	getSeq			()	{	return	seq			;	}
	public	String	getFile_st		()	{	return	file_st		;	}
	public	String	getFile_cont	()	{	return	file_cont	;	}
	public	String	getFile_name	()	{	return	file_name	;	}
	public	String	getReg_id		()	{	return	reg_id		;	}
	public	String	getReg_dt		()	{	return	reg_dt		;	}
	public	String	getUpd_id		()	{	return	upd_id		;	}
	public	String	getUpd_dt		()	{	return	upd_dt		;	}
	public	String	getFile_path	()	{	return	file_path	;	}
	public	String	getFile_type	()	{	return	file_type	;	}
	public	String	getRent_st		()	{	return	rent_st		;	}
}