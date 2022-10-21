package acar.insur;

public class InsurChangeBean
{
	private String car_mng_id;
	private String ins_st;
	private String ch_tm;
	private String ch_dt;
	private String ch_item;
	private String ch_before;
	private String ch_after;
	private int    ch_amt;
	private String reg_id;				//최초등록자
	private String reg_dt;				//최초등록일
	private String update_id;			//최종수정자
	private String update_dt;			//최종수정일
	private String ins_doc_no;			//변경문서번호
	private String rent_mng_id;			//계약관리번호  
	private String rent_l_cd;			//계약번호      
	private String rent_st;				//계약번호      
	private String ch_etc;
	private int    o_fee_amt;
	private int    n_fee_amt;
	private int    d_fee_amt;
	private String ins_doc_st;			//처리구분 Y:승인 N:기각
	private String reject_cau;			//기각사유
	private String doc_st;				//문서구분 1:보험료변경문서 2:대여료변경문서 3:유류대경감요청문서
	private String ch_st;				//등로국분 1:견적 2:반영
	private String ch_s_dt;				//변경담보유효기간
	private String ch_e_dt;				//변경담보유효기간
	private int    o_opt_amt;
	private int    n_opt_amt;
	private float  o_cls_per;
	private float  n_cls_per;
	private String r_fee_est_dt;				//결제예정일
	private int    o_rtn_run_amt;
	private int    n_rtn_run_amt;
	private int    o_over_run_amt;
	private int    n_over_run_amt;
	
	public InsurChangeBean()
	{
		car_mng_id		= "";
		ins_st			= "";
		ch_tm			= "";
		ch_dt			= "";
		ch_item			= "";
		ch_before		= "";
		ch_after		= "";
		ch_amt			= 0;
		this.reg_id		= "";
		this.reg_dt		= "";
		this.update_id	= "";
		this.update_dt	= "";
		ins_doc_no		= "";
		rent_mng_id 	= ""; 
		rent_l_cd 		= ""; 
		rent_st 		= ""; 
		ch_etc			= "";
		o_fee_amt		= 0;
		n_fee_amt		= 0;
		d_fee_amt		= 0;
		ins_doc_st		= "";
		reject_cau 		= "";
		doc_st			= "";
		ch_st			= "";
		ch_s_dt			= "";
		ch_e_dt			= "";
		o_opt_amt		= 0;
		n_opt_amt		= 0;
		o_cls_per		= 0;
		n_cls_per		= 0;
		r_fee_est_dt	= "";
		o_rtn_run_amt		= 0;
		n_rtn_run_amt		= 0;
		o_over_run_amt		= 0;
		n_over_run_amt		= 0;

	}
	

	public void setCar_mng_id(String str)	{	car_mng_id	= str;		}
	public void setIns_st(String str)		{	ins_st		= str;		}
	public void setCh_tm(String str)		{	ch_tm		= str;		}
	public void setCh_dt(String str)		{	ch_dt		= str;		}
	public void setCh_item(String str)		{	ch_item		= str;		}
	public void setCh_before(String str)	{	ch_before	= str;		}
	public void setCh_after(String str)		{	ch_after	= str;		}
	public void setCh_amt(int i)			{	ch_amt		= i;		}
	public void setReg_id(String val){			if(val==null) val="";		this.reg_id = val;		}
	public void setReg_dt(String val){			if(val==null) val="";		this.reg_dt = val;		}
	public void setUpdate_id(String val){		if(val==null) val="";		this.update_id = val;	}
	public void setUpdate_dt(String val){		if(val==null) val="";		this.update_dt = val;	}
	public void setIns_doc_no(String str)	{	ins_doc_no	= str;		}
	public void setRent_mng_id(String str)	{ rent_mng_id 	= str;		}
	public void setRent_l_cd(String str)	{ rent_l_cd 	= str;		} 	
	public void setRent_st(String str)		{ rent_st		= str;		} 	
	public void setCh_etc(String str)		{	ch_etc		= str;		}
	public void setO_fee_amt(int i)			{	o_fee_amt	= i;		}
	public void setN_fee_amt(int i)			{	n_fee_amt	= i;		}
	public void setD_fee_amt(int i)			{	d_fee_amt	= i;		}
	public void setIns_doc_st(String str)	{	ins_doc_st	= str;		}
	public void setReject_cau(String str)	{	reject_cau 	= str;		}
	public void setDoc_st(String str)		{	doc_st		= str;		}
	public void setCh_st(String str)		{	ch_st		= str;		}
	public void setCh_s_dt(String str)		{	ch_s_dt		= str;		}
	public void setCh_e_dt(String str)		{	ch_e_dt		= str;		}
	public void setO_opt_amt(int i)			{	o_opt_amt	= i;		}
	public void setN_opt_amt(int i)			{	n_opt_amt	= i;		}
	public void setO_cls_per(float i)		{	o_cls_per	= i;		}
	public void setN_cls_per(float i)		{	n_cls_per	= i;		}
	public void setR_fee_est_dt(String str)	{	r_fee_est_dt	= str;	}
	public void setO_rtn_run_amt(int i)		{	o_rtn_run_amt	= i;	}
	public void setN_rtn_run_amt(int i)		{	n_rtn_run_amt	= i;	}
	public void setO_over_run_amt(int i)	{	o_over_run_amt	= i;	}
	public void setN_over_run_amt(int i)	{	n_over_run_amt	= i;	}


	public String getCar_mng_id()			{	return	car_mng_id;		}
	public String getIns_st()				{	return	ins_st;			}
	public String getCh_tm()				{	return	ch_tm;			}
	public String getCh_dt()				{	return	ch_dt;			}
	public String getCh_item()				{	return	ch_item;		}
	public String getCh_before()			{	return	ch_before;		}
	public String getCh_after()				{	return	ch_after;		}
	public int	  getCh_amt()				{	return	ch_amt;			}
	public String getReg_id()				{	return  reg_id;			}
	public String getReg_dt()				{	return  reg_dt;			}
	public String getUpdate_id()			{	return  update_id;		}
	public String getUpdate_dt()			{	return  update_dt;		}
	public String getIns_doc_no()			{	return	ins_doc_no;		}
	public String getRent_mng_id()			{   return  rent_mng_id;	}
	public String getRent_l_cd()			{   return  rent_l_cd;		}
	public String getRent_st()				{   return  rent_st;		}
	public String getCh_etc()				{	return	ch_etc;			}
	public int	  getO_fee_amt()			{	return	o_fee_amt;		}
	public int	  getN_fee_amt()			{	return	n_fee_amt;		}
	public int	  getD_fee_amt()			{	return	d_fee_amt;		}
	public String getIns_doc_st()			{	return	ins_doc_st;		}	
	public String getReject_cau()			{   return  reject_cau;		}
	public String getDoc_st()				{	return	doc_st;			}
	public String getCh_st()				{	return	ch_st;			}
	public String getCh_s_dt()				{	return	ch_s_dt;		}
	public String getCh_e_dt()				{	return	ch_e_dt;		}
	public int	  getO_opt_amt()			{	return	o_opt_amt;		}
	public int	  getN_opt_amt()			{	return	n_opt_amt;		}
	public float  getO_cls_per()			{	return	o_cls_per;		}
	public float  getN_cls_per()			{	return	n_cls_per;		}
	public String getR_fee_est_dt()			{	return	r_fee_est_dt;	}
	public int	  getO_rtn_run_amt()		{	return	o_rtn_run_amt;	}
	public int	  getN_rtn_run_amt()		{	return	n_rtn_run_amt;	}
	public int	  getO_over_run_amt()		{	return	o_over_run_amt;	}
	public int	  getN_over_run_amt()		{	return	n_over_run_amt;	}


}