package acar.commi_mng;

public class CommiBean
{

	//Table : COMMI
	private String rent_mng_id;
	private String emp_id;
	private String rent_l_cd;
	private String agnt_st;
	private int    commi;
	private int    inc_amt;
	private int    res_amt;
	private int    tot_amt;
	private int    dif_amt;
	private String sup_dt;
	private String rel;	
	private String firm_nm;
	private String dlv_dt;
	private String car_nm;
	private String car_name;
	private String car_no;
	//20040820추가
	private String commi_st;
	//20051219추가
	private String brch_id;
	//20070724
	private int    commi_car_amt;				//지급기준차가
	private String emp_nm;
	private String cust_st;
	private String car_off_nm;
	private String car_off_st;
	private float  comm_rt;
	private float  comm_r_rt;
	private String ch_remark;
	private String ch_sac_id;
	private String emp_bank;
	private String emp_acc_no;
	private String emp_acc_nm;
	private String car_comp_id;
	private String req_id;
	private String req_dt;
	private String req_cont;
	//20080228
	private String job_st;			
	//20080305
	private String commi_car_st;	
	private String rec_incom_yn;
	private String rec_incom_st;
	private String rec_ssn;
	private String rec_zip;
	private String rec_addr;
	private String file_name1;
	private String file_name2;
	private int    add_amt1;
	private int    add_amt2;
	private int    add_amt3;
	private String add_cau1;
	private String add_cau2;
	private String add_cau3;
	private String inc_per;
	private String res_per;
	private String tot_per;
	private String data_no;
	private String seqidx;
	private String doc_no;
	private String add_st1;
	private String add_st2;
	private String add_st3;
	private String acct_cd1;
	private String acct_cd2;
	private String acct_cd3;
	private int    send_amt;	
	private int    dlv_con_commi;		//출고보전수당
	private int    dlv_tns_commi;		//실적이관권장수당
	private int    agent_commi;		//업무진행수당


	public CommiBean()
	{
		rent_mng_id	= "";
		emp_id 		= "";
		rent_l_cd	= "";
		agnt_st	 	= "";
		commi	 	= 0;
		inc_amt		= 0;
		res_amt		= 0;
		tot_amt		= 0;
		dif_amt		= 0;
		sup_dt	 	= "";
		rel	 		= "";
		firm_nm		= "";
		dlv_dt		= "";
		car_nm		= "";
		car_name  = "";
		car_no		= "";
		commi_st	= "";
		brch_id		= "";
		this.commi_car_amt	= 0;				
		this.emp_nm     	= "";				
		this.cust_st    	= "";				
		this.car_off_nm 	= "";				
		this.car_off_st 	= "";				
		this.comm_rt    	= 0;				
		this.comm_r_rt  	= 0;				
		this.ch_remark  	= "";
		this.ch_sac_id  	= "";
		this.emp_bank  		= "";
		this.emp_acc_no  	= "";
		this.emp_acc_nm  	= "";
		this.car_comp_id  	= "";
		this.req_id  		= "";
		this.req_dt  		= "";
		this.req_cont 		= "";
		this.job_st 		= "";
		this.commi_car_st  	= "";
		this.rec_incom_yn  	= "";
		this.rec_incom_st 	= "";
		this.rec_ssn		= "";
		this.rec_zip  		= "";
		this.rec_addr	  	= "";
		this.file_name1		= "";
		this.file_name2		= "";
		this.add_amt1		= 0;
		this.add_amt2		= 0;
		this.add_amt3		= 0;
		this.add_cau1 		= "";
		this.add_cau2 		= "";
		this.add_cau3 		= "";
		this.inc_per 		= "";
		this.res_per 		= "";
		this.tot_per 		= "";
		this.data_no 		= "";
		this.seqidx 		= "";
		this.doc_no 		= "";
		this.add_st1 		= "";
		this.add_st2 		= "";
		this.add_st3 		= "";
		this.acct_cd1 		= "";
		this.acct_cd2 		= "";
		this.acct_cd3 		= "";
		this.send_amt		= 0;
		this.dlv_con_commi	= 0;		
		this.dlv_tns_commi	= 0;		
		this.agent_commi	= 0;		

	}
	
	public void setRent_mng_id(String str)	{	rent_mng_id	= str;	}
	public void setEmp_id(String str)		{	emp_id 		= str;	}
	public void setRent_l_cd(String str)	{	rent_l_cd	= str;	}
	public void setAgnt_st(String str)		{	agnt_st	 	= str;	}
	public void setCommi(int i)				{ 	commi	 	= i;}
	public void setInc_amt(int i)			{ 	inc_amt		= i;}
	public void setRes_amt(int i)			{ 	res_amt		= i;}
	public void setTot_amt(int i)			{ 	tot_amt		= i;}
	public void setDif_amt(int i)			{ 	dif_amt		= i;}
	public void setSup_dt(String str)		{	sup_dt	 	= str;	}
	public void setRel(String str)			{	rel	 		= str;	}
	public void setFirm_nm(String str)		{	firm_nm		= str;	}
	public void setDlv_dt(String str)		{	dlv_dt		= str;	}
	public void setCar_nm(String str)		{	car_nm		= str;	}
	public void setCar_name(String str)		{	car_name		= str;	}	
	public void setCar_no(String str)		{	car_no		= str;	}
	public void setCommi_st(String str)		{	commi_st		= str;	}
	public void setBrch_id(String str)		{	brch_id		= str;	}
	public void setCommi_car_amt	(int    val){									commi_car_amt	= val;	}
	public void setEmp_nm			(String val){		if(val==null) val="";		emp_nm     		= val;	}
	public void setCust_st			(String val){		if(val==null) val="";		cust_st    		= val;	}
	public void setCar_off_nm		(String val){		if(val==null) val="";		car_off_nm 		= val;	}
	public void setCar_off_st		(String val){		if(val==null) val="";		car_off_st 		= val;	}
	public void setComm_rt			(float  val){									comm_rt    		= val;	}
	public void setComm_r_rt		(float  val){									comm_r_rt  		= val;	}
	public void setCh_remark		(String val){		if(val==null) val="";		ch_remark  		= val;	}
	public void setCh_sac_id		(String val){		if(val==null) val="";		ch_sac_id  		= val;	}		
	public void setEmp_bank			(String val){		if(val==null) val="";		emp_bank  	  	= val;	}
	public void setEmp_acc_no		(String val){		if(val==null) val="";		emp_acc_no   	= val;	}
	public void setEmp_acc_nm		(String val){		if(val==null) val="";		emp_acc_nm   	= val;	}
	public void setCar_comp_id		(String val){		if(val==null) val="";		car_comp_id   	= val;	}
	public void setReq_id			(String val){		if(val==null) val="";		req_id  	  	= val;	}
	public void setReq_dt			(String val){		if(val==null) val="";		req_dt  	  	= val;	}
	public void setReq_cont			(String val){		if(val==null) val="";		req_cont 	  	= val;	}
	public void setJob_st			(String val){		if(val==null) val="";		job_st	 	  	= val;	}
	public void setCommi_car_st  	(String val){		if(val==null) val="";		commi_car_st  	= val;	}
	public void setRec_incom_yn  	(String val){		if(val==null) val="";		rec_incom_yn  	= val;	}		
	public void setRec_incom_st 	(String val){		if(val==null) val="";		rec_incom_st 	= val;	}
	public void setRec_ssn			(String val){		if(val==null) val="";		rec_ssn			= val;	}
	public void setRec_zip  		(String val){		if(val==null) val="";		rec_zip  		= val;	}
	public void setRec_addr	  		(String val){		if(val==null) val="";		rec_addr	  	= val;	}
	public void setFile_name1		(String val){		if(val==null) val="";		file_name1		= val;	}
	public void setFile_name2		(String val){		if(val==null) val="";		file_name2		= val;	}
	public void setAdd_amt1			(int    val){									add_amt1		= val;	}
	public void setAdd_amt2			(int    val){									add_amt2		= val;	}
	public void setAdd_amt3			(int    val){									add_amt3		= val;	}
	public void setAdd_cau1 		(String val){		if(val==null) val="";		add_cau1 		= val;	}
	public void setAdd_cau2 		(String val){		if(val==null) val="";		add_cau2 		= val;	}
	public void setAdd_cau3 		(String val){		if(val==null) val="";		add_cau3 		= val;	}
	public void setInc_per 			(String val){		if(val==null) val="";		inc_per 		= val;	}
	public void setRes_per 			(String val){		if(val==null) val="";		res_per 		= val;	}
	public void setTot_per 			(String val){		if(val==null) val="";		tot_per 		= val;	}
	public void setData_no 			(String val){		if(val==null) val="";		data_no 		= val;	}
	public void setSeqidx 			(String val){		if(val==null) val="";		seqidx	 		= val;	}
	public void setDoc_no 			(String val){		if(val==null) val="";		doc_no	 		= val;	}
	public void setAdd_st1 			(String val){		if(val==null) val="";		add_st1 		= val;	}
	public void setAdd_st2 			(String val){		if(val==null) val="";		add_st2 		= val;	}
	public void setAdd_st3 			(String val){		if(val==null) val="";		add_st3 		= val;	}

	public void setAcct_cd1			(String val){		if(val==null) val="";		acct_cd1 		= val;	}
	public void setAcct_cd2			(String val){		if(val==null) val="";		acct_cd2 		= val;	}
	public void setAcct_cd3			(String val){		if(val==null) val="";		acct_cd3 		= val;	}
	public void setSend_amt			(int    val){									send_amt		= val;	}
	public void setDlv_con_commi	(int    val){									dlv_con_commi	= val;	}
	public void setDlv_tns_commi	(int    val){									dlv_tns_commi	= val;	}
	public void setAgent_commi		(int    val){									agent_commi	= val;	}
	
	public String getRent_mng_id()	{	return	rent_mng_id;	}  
	public String getEmp_id()		{	return	emp_id;	}  
	public String getRent_l_cd()	{	return	rent_l_cd;	}  
	public String getAgnt_st()		{	return	agnt_st;	}  
	public int    getCommi()		{	return	commi;	}  
	public int    getInc_amt()		{	return	inc_amt;	}  
	public int    getRes_amt()		{	return	res_amt;	}  
	public int    getTot_amt()		{	return	tot_amt;	}  
	public int    getDif_amt()		{	return	dif_amt;	}  
	public String getSup_dt()		{	return	sup_dt;	}  
	public String getRel()			{	return	rel;	}  
	public String getFirm_nm()			{	return	firm_nm;	}  
	public String getDlv_dt()			{	return	dlv_dt;	}  
	public String getCar_nm()			{	return	car_nm;	}  
	public String getCar_name()			{	return	car_name;	}  	
	public String getCar_no()			{	return	car_no;	}  
	public String getCommi_st()			{	return	commi_st;	}  
	public String getBrch_id()			{	return	brch_id;	}  

	public int    getCommi_car_amt	()			{		return commi_car_amt;	}
	public String getEmp_nm     	()			{		return	emp_nm;     	}  
	public String getCust_st    	()			{		return	cust_st;    	}  
	public String getCar_off_nm 	()			{		return	car_off_nm; 	}  
	public String getCar_off_st 	()			{		return	car_off_st; 	}  
	public float  getComm_rt    	()			{		return	comm_rt;    	}  
	public float  getComm_r_rt  	()			{		return	comm_r_rt;  	}  
	public String getCh_remark  	()			{		return	ch_remark;  	}  
	public String getCh_sac_id  	()			{		return	ch_sac_id;  	}  
	public String getEmp_bank   	()			{		return	emp_bank;   	}  
	public String getEmp_acc_no 	()			{		return	emp_acc_no; 	}  
	public String getEmp_acc_nm 	()			{		return	emp_acc_nm; 	}  
	public String getCar_comp_id 	()			{		return	car_comp_id; 	}  
	public String getReq_id		   	()			{		return	req_id;		   	}  
	public String getReq_dt		   	()			{		return	req_dt;		   	}  
	public String getReq_cont	   	()			{		return	req_cont;	   	}  
	public String getJob_st		   	()			{		return	job_st;		   	}  
	public String getCommi_car_st  	()			{		return	commi_car_st;	}  
	public String getRec_incom_yn  	()			{		return	rec_incom_yn;	}  
	public String getRec_incom_st 	()			{		return	rec_incom_st;	}  
	public String getRec_ssn		()			{		return	rec_ssn;     	}  
	public String getRec_zip  		()			{		return	rec_zip;     	}  
	public String getRec_addr	  	()			{		return	rec_addr;     	}  
	public String getFile_name1		()			{		return	file_name1;     }  
	public String getFile_name2		()			{		return	file_name2;     }  
	public int    getAdd_amt1		()			{		return	add_amt1;       }  
	public int    getAdd_amt2		()			{		return	add_amt2;       }  
	public int    getAdd_amt3		()			{		return	add_amt3;    	}  
	public String getAdd_cau1 		()			{		return	add_cau1;    	}  
	public String getAdd_cau2 		()			{		return	add_cau2;    	}  
	public String getAdd_cau3 		()			{		return	add_cau3;    	}  
	public String getInc_per 		()			{		return	inc_per;    	}  
	public String getRes_per 		()			{		return	res_per;    	}  
	public String getTot_per 		()			{		return	tot_per;    	}  
	public String getData_no 		()			{		return	data_no;    	}  
	public String getSeqidx 		()			{		return	seqidx;	    	}  
	public String getDoc_no 		()			{		return	doc_no;	    	}  
	public String getAdd_st1 		()			{		return	add_st1;    	}  
	public String getAdd_st2 		()			{		return	add_st2;    	}  
	public String getAdd_st3 		()			{		return	add_st3;    	}  
	public String getAcct_cd1 		()			{		return	acct_cd1;    	}  
	public String getAcct_cd2 		()			{		return	acct_cd2;    	}  
	public String getAcct_cd3 		()			{		return	acct_cd3;    	}  
	public int    getSend_amt		()			{		return	send_amt;    	}  
	public int    getDlv_con_commi	()			{		return dlv_con_commi;	}
	public int    getDlv_tns_commi	()			{		return dlv_tns_commi;	}
	public int    getAgent_commi	()			{		return agent_commi;	}

}
