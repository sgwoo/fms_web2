package acar.fee;

public class FeeImBean
{
	//임의연장 관리 테이블

	private String rent_mng_id;		// 계약관리번호
	private String rent_l_cd;		// 계약번호    
	private String rent_st;			// 대여일련번호        
	private String im_seq;			// 임의연장일련번호
	private String add_tm;			// 회차
	private String rent_start_dt;	// 대여기간
	private String rent_end_dt;		// 대여기간
	private String f_use_start_dt;	// 1회차대여기간
	private String f_use_end_dt;	// 1회차대여기간
	private String f_req_dt;		// 1회차발행예정일
	private String f_tax_dt;		// 1회차세금일자
	private String f_est_dt;		// 1회차입금예정일
	private String reg_dt;			// 수정일
	private String reg_id;			// 수정자
	private String print_st;		// 고객발행여부
	private int    fee_s_amt;
	private int    fee_v_amt;

	
	public FeeImBean()
	{
		rent_mng_id		= "";
		rent_l_cd		= "";
		rent_st			= "";
		im_seq			= "";
		add_tm			= "";
		rent_start_dt	= "";
		rent_end_dt		= "";
		f_use_start_dt	= "";
		f_use_end_dt	= "";
		f_req_dt		= "";
		f_tax_dt		= "";
		f_est_dt		= "";
		reg_dt			= "";
		reg_id			= "";
		print_st		= "";
		fee_s_amt		= 0;
		fee_v_amt		= 0;

	}
	
	public void setRent_mng_id		(String str)		{	rent_mng_id		= str;	}
	public void setRent_l_cd		(String str)		{	rent_l_cd		= str;	}
	public void setRent_st			(String str)		{	rent_st			= str;	}
	public void setIm_seq			(String str)		{	im_seq			= str;	}
	public void setAdd_tm			(String str)		{	add_tm			= str;	}
	public void setRent_start_dt	(String str)		{	rent_start_dt	= str;	}
	public void setRent_end_dt		(String str)		{	rent_end_dt		= str;	}
	public void setF_use_start_dt	(String str)		{	f_use_start_dt	= str;	}
	public void setF_use_end_dt		(String str)		{	f_use_end_dt	= str;	}
	public void setF_req_dt			(String str)		{	f_req_dt		= str;	}
	public void setF_tax_dt			(String str)		{	f_tax_dt		= str;	}
	public void setF_est_dt			(String str)		{	f_est_dt		= str;	}
	public void setReg_dt			(String str)		{	reg_dt			= str;	}
	public void setReg_id			(String str)		{	reg_id			= str;	}
	public void setPrint_st			(String str)		{	print_st		= str;	}
	public void setFee_s_amt		(int i)				{	fee_s_amt		= i;	} 
	public void setFee_v_amt		(int i)				{	fee_v_amt		= i;	} 

	
	public String getRent_mng_id	()					{	return rent_mng_id;		}
	public String getRent_l_cd		()					{	return rent_l_cd;		}
	public String getRent_st		()					{	return rent_st;			}
	public String getIm_seq			()					{	return im_seq;			}
	public String getAdd_tm			()					{	return add_tm;			}
	public String getRent_start_dt	()					{	return rent_start_dt;	}
	public String getRent_end_dt	()					{	return rent_end_dt;		}
	public String getF_use_start_dt	()					{	return f_use_start_dt;	}
	public String getF_use_end_dt	()					{	return f_use_end_dt;	}
	public String getF_req_dt		()					{	return f_req_dt;		}
	public String getF_tax_dt		()					{	return f_tax_dt;		}
	public String getF_est_dt		()					{	return f_est_dt;		}
	public String getReg_dt			()					{	return reg_dt;			}
	public String getReg_id			()					{	return reg_id;			}
	public String getPrint_st		()					{	return print_st;		}
	public int    getFee_s_amt		()					{	return fee_s_amt;		} 
	public int    getFee_v_amt		()					{	return fee_v_amt;		} 

}
