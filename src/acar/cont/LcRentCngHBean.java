package acar.cont;

public class LcRentCngHBean{

	private	String	rent_mng_id		;
	private String	rent_l_cd		;
	private int 	seq				;
	private String	cng_item		;
	private String	old_value		;
	private String	new_value		;
	private String	cng_cau			;
	private String	cng_id			;
	private String	cng_dt			;
	private String	rent_st			;
	private int 	s_amt			;
	private int 	v_amt			;


	public LcRentCngHBean(){
		rent_mng_id		= "";
		rent_l_cd		= "";
		seq				= 0;
		cng_item		= "";
		old_value		= "";
		new_value		= "";
		cng_cau			= "";
		cng_id			= "";
		cng_dt			= "";
		rent_st			= "";
		s_amt			= 0;
		v_amt			= 0;

	}

	//setMethod
	public void setRent_mng_id	(String str)	{ if(str==null) str="";	rent_mng_id	= str;	}
	public void setRent_l_cd	(String str)	{ if(str==null) str="";	rent_l_cd	= str;	}
	public void setSeq			(int str)		{						seq			= str;	}
	public void setCng_item		(String str)	{ if(str==null) str="";	cng_item	= str;	}
	public void setOld_value	(String str)	{ if(str==null) str="";	old_value	= str;	}
	public void setNew_value	(String str)	{ if(str==null) str="";	new_value	= str;	}
	public void setCng_cau		(String str)	{ if(str==null) str="";	cng_cau		= str;	}
	public void setCng_id		(String str)	{ if(str==null) str="";	cng_id		= str;	}
	public void setCng_dt		(String str)	{ if(str==null) str="";	cng_dt		= str;	}
	public void setRent_st		(String str)	{ if(str==null) str="";	rent_st		= str;	}
	public void setS_amt		(int str)		{						s_amt		= str;	}
	public void setV_amt		(int str)		{						v_amt		= str;	}



	//getMethod
	public	String	getRent_mng_id	()	{	return	rent_mng_id	;	}
	public	String	getRent_l_cd	()	{	return	rent_l_cd	;	}
	public	int		getSeq			()	{	return	seq			;	}
	public	String	getCng_item		()	{	return	cng_item	;	}
	public	String	getOld_value	()	{	return	old_value	;	}
	public	String	getNew_value	()	{	return	new_value	;	}
	public	String	getCng_cau		()	{	return	cng_cau		;	}
	public	String	getCng_id		()	{	return	cng_id		;	}
	public	String	getCng_dt		()	{	return	cng_dt		;	}
	public	String	getRent_st		()	{	return	rent_st		;	}
	public	int		getS_amt		()	{	return	s_amt		;	}
	public	int		getV_amt		()	{	return	v_amt		;	}

}