package acar.settle_acc;

public class BadComplaintReqBean{

	//고소장접수요청
	private	String	client_id			;
	private int 	seq					;
	private String	reg_id				;
	private String	reg_dt				;
	private String	bad_cau				;
	private String	bad_st				;	
	private String	req_dt				;
	private String	car_call_yn			;
	private String	cancel_dt			;
	private String	end_dt				;
	private String	reject_cau			;
	private String  file_name1			;					
	private String  file_name2			;					
	private String  file_name3			;					
	private String  file_name4			;					
	private String  file_gubun1			;					
	private String  file_gubun2			;					
	private String  file_gubun3			;					
	private String  file_gubun4			;					
	private	String	bad_comp_cd			;
	private	String	rent_mng_id			;
	private String	rent_l_cd			;
	private String	a_fee_tm			;
	private String	fee_tm				;
	private String	fee_est_dt			;
	private String	dly_mon				;
	private String	etc					;
	private String  t_rent_start_dt		;					
	private String  t_rent_end_dt		;					
	private String	t_con_mon			;
	private	String	add_rent_start_dt	;
	private String	add_rent_end_dt		;
	private String	add_tm				;
	private String	credit_doc_id		;
	private String	bad_yn				;
	private String	id_cng_req_dt		;
	private String	id_cng_dt			;
	private int	    dly_fee_amt			;
	private String  pol_place			;	//관할경찰서 추가(2017.04.26) 



	public BadComplaintReqBean(){
		client_id			= "";
		seq					= 0;
		reg_id				= "";
		reg_dt				= "";
		bad_cau				= "";
		bad_st				= "";
		req_dt				= "";
		car_call_yn			= "";
		cancel_dt			= "";
		end_dt				= "";
		reject_cau			= "";
		file_name1			= "";
		file_name2			= "";
		file_name3			= "";
		file_name4			= "";
		file_gubun1			= "";
		file_gubun2			= "";
		file_gubun3			= "";
		file_gubun4			= "";
		bad_comp_cd			= "";
		rent_mng_id			= "";
		rent_l_cd			= "";
		a_fee_tm			= "";
		fee_tm				= "";
		fee_est_dt			= "";
		dly_mon				= "";
		etc					= "";
		t_rent_start_dt		= "";
		t_rent_end_dt		= "";
		t_con_mon			= "";
		add_rent_start_dt	= "";
		add_rent_end_dt		= "";
		add_tm				= "";
		credit_doc_id		= "";
		bad_yn				= "";
		id_cng_req_dt		= "";
		id_cng_dt			= "";
		dly_fee_amt			= 0;
		pol_place			= "";	//관할경찰서 추가(2017.04.26)

	}

	//setMethod
	public void setClient_id			(String str)	{ if(str==null) str="";	client_id			= str;	}
	public void setSeq					(int    str)	{						seq					= str;	}
	public void setReg_id				(String str)	{ if(str==null) str="";	reg_id				= str;	}
	public void setReg_dt				(String str)	{ if(str==null) str="";	reg_dt				= str;	}
	public void setBad_cau				(String str)	{ if(str==null) str="";	bad_cau				= str;	}
	public void setBad_st				(String str)	{ if(str==null) str="";	bad_st				= str;	}
	public void setReq_dt				(String str)	{ if(str==null) str="";	req_dt				= str;	}
	public void setCar_call_yn			(String str)	{ if(str==null) str="";	car_call_yn			= str;	}
	public void setCancel_dt			(String str)	{ if(str==null) str="";	cancel_dt			= str;	}
	public void setEnd_dt				(String str)	{ if(str==null) str="";	end_dt				= str;	}
	public void setReject_cau			(String str)	{ if(str==null) str="";	reject_cau			= str;	}
	public void setFile_name1			(String str)	{ if(str==null) str="";	file_name1			= str;	}
	public void setFile_name2			(String str)	{ if(str==null) str="";	file_name2			= str;	}
	public void setFile_name3			(String str)	{ if(str==null) str="";	file_name3			= str;	}
	public void setFile_name4			(String str)	{ if(str==null) str=""; file_name4			= str;	}
	public void setFile_gubun1			(String str)	{ if(str==null) str="";	file_gubun1			= str;	}
	public void setFile_gubun2			(String str)	{ if(str==null) str="";	file_gubun2			= str;	}
	public void setFile_gubun3			(String str)	{ if(str==null) str="";	file_gubun3			= str;	}
	public void setFile_gubun4			(String str)	{ if(str==null) str="";	file_gubun4			= str;	}
	public void setBad_comp_cd			(String str)	{ if(str==null) str="";	bad_comp_cd			= str;	}
	public void setRent_mng_id			(String str)	{ if(str==null) str="";	rent_mng_id			= str;	}
	public void setRent_l_cd			(String str)	{ if(str==null) str="";	rent_l_cd			= str;	}
	public void setA_fee_tm				(String str)	{ if(str==null) str="";	a_fee_tm			= str;	}
	public void setFee_tm				(String str)	{ if(str==null) str="";	fee_tm				= str;	}
	public void setFee_est_dt			(String str)	{ if(str==null) str="";	fee_est_dt			= str;	}
	public void setDly_mon				(String str)	{ if(str==null) str="";	dly_mon				= str;	}
	public void setEtc					(String str)	{ if(str==null) str="";	etc					= str;	}
	public void setT_rent_start_dt		(String str)	{ if(str==null) str="";	t_rent_start_dt		= str;	}
	public void setT_rent_end_dt		(String str)	{ if(str==null) str="";	t_rent_end_dt		= str;	}
	public void setT_con_mon			(String str)	{ if(str==null) str="";	t_con_mon			= str;	}
	public void setAdd_rent_start_dt	(String str)	{ if(str==null) str=""; add_rent_start_dt	= str;	}
	public void setAdd_rent_end_dt		(String str)	{ if(str==null) str="";	add_rent_end_dt		= str;	}
	public void setAdd_tm				(String str)	{ if(str==null) str="";	add_tm				= str;	}
	public void setCredit_doc_id		(String str)	{ if(str==null) str="";	credit_doc_id		= str;	}
	public void setBad_yn				(String str)	{ if(str==null) str="";	bad_yn				= str;	}
	public void setId_cng_req_dt		(String str)	{ if(str==null) str="";	id_cng_req_dt		= str;	}
	public void setId_cng_dt			(String str)	{ if(str==null) str="";	id_cng_dt			= str;	}
	public void setDly_fee_amt			(int    str)	{						dly_fee_amt			= str;	}
	public void setPol_place			(String str)	{ if(str==null) str=""; pol_place			= str;  } //관할경찰서 추가(2017.04.26)


	//getMethod
	public	String	getClient_id			()			{	return	client_id			;	}
	public	int		getSeq					()			{	return	seq					;	}
	public	String	getReg_id				()			{	return	reg_id				;	}
	public	String	getReg_dt				()			{	return	reg_dt				;	}
	public	String	getBad_cau				()			{	return	bad_cau				;	}
	public	String	getBad_st				()			{	return	bad_st				;	}
	public	String	getReq_dt				()			{	return	req_dt				;	}
	public	String	getCar_call_yn			()			{	return	car_call_yn			;	}
	public	String	getCancel_dt			()			{	return	cancel_dt			;	}
	public	String	getEnd_dt				()			{	return	end_dt				;	}
	public	String	getReject_cau			()			{	return	reject_cau			;	}
	public	String	getFile_name1			()			{	return	file_name1			;	}
	public	String	getFile_name2			()			{	return	file_name2			;	}
	public	String	getFile_name3			()			{	return	file_name3			;	}
	public	String	getFile_name4			()			{	return	file_name4			;	}
	public	String	getFile_gubun1			()			{	return	file_gubun1			;	}
	public	String	getFile_gubun2			()			{	return	file_gubun2			;	}
	public	String	getFile_gubun3			()			{	return	file_gubun3			;	}
	public	String	getFile_gubun4			()			{	return	file_gubun4			;	}
	public	String	getBad_comp_cd			()			{	return	bad_comp_cd			;	}
	public	String	getRent_mng_id			()			{	return	rent_mng_id			;	}
	public	String	getRent_l_cd			()			{	return	rent_l_cd			;	}
	public	String	getA_fee_tm				()			{	return	a_fee_tm			;	}
	public	String	getFee_tm				()			{	return	fee_tm				;	}
	public	String	getFee_est_dt			()			{	return	fee_est_dt			;	}
	public	String	getDly_mon				()			{	return	dly_mon				;	}
	public	String	getEtc					()			{	return	etc					;	}
	public	String	getT_rent_start_dt		()			{	return	t_rent_start_dt		;	}
	public	String	getT_rent_end_dt		()			{	return	t_rent_end_dt		;	}
	public	String	getT_con_mon			()			{	return	t_con_mon			;	}
	public	String	getAdd_rent_start_dt	()			{	return	add_rent_start_dt	;	}
	public	String	getAdd_rent_end_dt		()			{	return	add_rent_end_dt		;	}
	public	String	getAdd_tm				()			{	return	add_tm				;	}
	public	String	getCredit_doc_id		()			{	return	credit_doc_id		;	}
	public	String	getBad_yn				()			{	return	bad_yn				;	}
	public	String	getId_cng_req_dt		()			{	return	id_cng_req_dt		;	}
	public	String	getId_cng_dt			()			{	return	id_cng_dt			;	}
	public	int		getDly_fee_amt			()			{	return	dly_fee_amt			;	}
	public  String	getPol_place			()			{	return	pol_place			;	}	//관할경찰서 추가(2017.04.26) 
					   	   		    
}