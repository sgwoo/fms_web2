package acar.cont;

public class BadDebtReqBean{

	//대손처리요청
	private	String	rent_mng_id		;
	private String	rent_l_cd		;
	private int 	seq				;
	private String	bad_debt_cau	;
	private String	bad_debt_st		;
	private String	old_bus_id2 	;
	private String	new_bus_id2		;
	private String	bus_id2_cng_yn	;
	private String	reg_id			;
	private String	reg_dt			;
	private String	cng_id			;
	private String	cng_dt			;
	private int 	bad_debt_amt	;
	private String	reject_cau		;

	//list
	private	String	bad_debt_cd		;
	private String	item_gubun		;
	private String	item_cd1		;
	private String	item_cd2		;
	private String	item_cd3		;
	private String	item_cd4		;
	private String	item_cd5		;
	private String	est_dt			;
	private int 	s_amt			;
	private int 	v_amt			;
	private int 	amt				;
	private String	etc				;




	public BadDebtReqBean(){
		rent_mng_id		= "";
		rent_l_cd		= "";
		seq				= 0;
		bad_debt_cau	= "";
		bad_debt_st		= "";
		old_bus_id2 	= "";
		new_bus_id2		= "";
		bus_id2_cng_yn	= "";
		reg_id			= "";
		reg_dt			= "";
		cng_id			= "";
		cng_dt			= "";
		bad_debt_amt	= 0;
		reject_cau		= "";

		bad_debt_cd		= "";
		item_gubun		= "";
		item_cd1		= "";
		item_cd2		= "";
		item_cd3		= "";
		item_cd4		= "";
		item_cd5		= "";
		est_dt			= "";
		s_amt			= 0;
		v_amt			= 0;
		amt				= 0;
		etc				= "";

	}

	//setMethod
	public void setRent_mng_id		(String str)	{ if(str==null) str="";	rent_mng_id		= str;	}
	public void setRent_l_cd		(String str)	{ if(str==null) str="";	rent_l_cd		= str;	}
	public void setSeq				(int    str)	{						seq				= str;	}
	public void setBad_debt_cau		(String str)	{ if(str==null) str="";	bad_debt_cau	= str;	}
	public void setBad_debt_st		(String str)	{ if(str==null) str="";	bad_debt_st		= str;	}
	public void setOld_bus_id2		(String str)	{ if(str==null) str="";	old_bus_id2 	= str;	}
	public void setNew_bus_id2		(String str)	{ if(str==null) str="";	new_bus_id2		= str;	}
	public void setBus_id2_cng_yn	(String str)	{ if(str==null) str="";	bus_id2_cng_yn	= str;	}
	public void setReg_id			(String str)	{ if(str==null) str="";	reg_id			= str;	}
	public void setReg_dt			(String str)	{ if(str==null) str="";	reg_dt			= str;	}
	public void setCng_id			(String str)	{ if(str==null) str="";	cng_id			= str;	}
	public void setCng_dt			(String str)	{ if(str==null) str="";	cng_dt			= str;	}
	public void setBad_debt_amt		(int    str)	{						bad_debt_amt	= str;	}
	public void setReject_cau		(String str)	{ if(str==null) str="";	reject_cau		= str;	}

	public void setBad_debt_cd		(String str)	{ if(str==null) str="";	bad_debt_cd		= str;	}
	public void setItem_gubun		(String str)	{ if(str==null) str="";	item_gubun		= str;	}
	public void setItem_cd1			(String str)	{ if(str==null) str=""; item_cd1		= str;	}
	public void setItem_cd2			(String str)	{ if(str==null) str="";	item_cd2		= str;	}
	public void setItem_cd3			(String str)	{ if(str==null) str="";	item_cd3		= str;	}
	public void setItem_cd4			(String str)	{ if(str==null) str="";	item_cd4		= str;	}
	public void setItem_cd5			(String str)	{ if(str==null) str="";	item_cd5		= str;	}
	public void setEst_dt			(String str)	{ if(str==null) str="";	est_dt			= str;	}
	public void setS_amt			(int    str)	{						s_amt			= str;	}
	public void setV_amt			(int    str)	{						v_amt			= str;	}
	public void setAmt				(int    str)	{						amt				= str;	}
	public void setEtc				(String str)	{ if(str==null) str="";	etc				= str;	}


	//getMethod
	public	String	getRent_mng_id		()			{	return	rent_mng_id		;	}
	public	String	getRent_l_cd		()			{	return	rent_l_cd		;	}
	public	int		getSeq				()			{	return	seq				;	}
	public	String	getBad_debt_cau		()			{	return	bad_debt_cau	;	}
	public	String	getBad_debt_st		()			{	return	bad_debt_st		;	}
	public	String	getOld_bus_id2 		()			{	return	old_bus_id2 	;	}
	public	String	getNew_bus_id2		()			{	return	new_bus_id2		;	}
	public	String	getBus_id2_cng_yn	()			{	return	bus_id2_cng_yn	;	}
	public	String	getReg_id			()			{	return	reg_id			;	}
	public	String	getReg_dt			()			{	return	reg_dt			;	}
	public	String	getCng_id			()			{	return	cng_id			;	}
	public	String	getCng_dt			()			{	return	cng_dt			;	}
	public	int		getBad_debt_amt		()			{	return	bad_debt_amt	;	}
	public	String	getReject_cau		()			{	return	reject_cau		;	}

	public	String	getBad_debt_cd		()			{	return	bad_debt_cd		;	}
	public	String	getItem_gubun		()			{	return	item_gubun		;	}
	public	String	getItem_cd1			()			{	return	item_cd1		;	}
	public	String	getItem_cd2			()			{	return	item_cd2		;	}
	public	String	getItem_cd3			()			{	return	item_cd3		;	}
	public	String	getItem_cd4			()			{	return	item_cd4		;	}
	public	String	getItem_cd5			()			{	return	item_cd5		;	}
	public	String	getEst_dt			()			{	return	est_dt			;	}
	public	int		getS_amt			()			{	return	s_amt			;	}
	public	int		getV_amt			()			{	return	v_amt			;	}
	public	int		getAmt				()			{	return	amt				;	}
	public	String	getEtc				()			{	return	etc				;	}

}