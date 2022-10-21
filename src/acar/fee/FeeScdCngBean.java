package acar.fee;

public class FeeScdCngBean
{
	private String rent_mng_id;	// 계약관리번호
	private String rent_l_cd;	// 계약번호    
	private String fee_tm;		// 회차        
	private String all_st;		// 이후모두적용
	private String gubun;		// 항목    
	private String b_value;     // 변경전        
	private String a_value;     // 변경후        
	private String cng_dt;		// 변경일      
	private String cng_cau;     // 변경사유      
	private String cng_id;		// 변경자        

	
	public FeeScdCngBean()
	{
		rent_mng_id	= "";
		rent_l_cd 	= "";
		fee_tm 		= "";
		all_st 		= "";
		gubun 		= "";
		b_value 	= "";
		a_value 	= "";
		cng_dt 		= "";
		cng_cau 	= "";
		cng_id 		= "";
	}
	
	public void setRent_mng_id(String str)		{	rent_mng_id	= str;	}
	public void setRent_l_cd(String str)		{	rent_l_cd 	= str;	}
	public void setFee_tm	(String str)		{	fee_tm 		= str;	}
	public void setAll_st 	(String str)		{	all_st  	= str;	}
	public void setGubun 	(String str)		{	gubun 		= str;	}
	public void setB_value	(String str)		{	b_value 	= str;	}
	public void setA_value	(String str)		{	a_value		= str;	}
	public void setCng_dt 	(String str)		{	cng_dt 		= str;	}
	public void setCng_cau	(String str)		{	cng_cau 	= str;	}
	public void setCng_id 	(String str)		{	cng_id  	= str;	}
	
	public String getRent_mng_id()		{	return rent_mng_id;	}
	public String getRent_l_cd	()		{	return rent_l_cd;	}
	public String getFee_tm		()		{	return fee_tm;		}
	public String getAll_st 	()		{	return all_st;		}
	public String getGubun 		()		{	return gubun;		}
	public String getB_value	()		{	return b_value;     }
	public String getA_value	()		{	return a_value;     }
	public String getCng_dt 	()		{	return cng_dt;		}
	public String getCng_cau	()		{	return cng_cau;     }
	public String getCng_id 	()		{	return cng_id;		}
}