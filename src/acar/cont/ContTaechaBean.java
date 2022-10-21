package acar.cont;

public class ContTaechaBean
{
	private String rent_mng_id	= "";   //계약관리번호 
	private String rent_l_cd	= "";	//계약번호
	private String no			= "";	//순번
	private String car_mng_id	= "";	//차량관리번호
	private String car_no		= "";   //차량번호 
	private String car_id		= "";   //차명 
	private String car_seq		= "";   //차명 
	private String car_nm		= "";   //차명
	private String bae_user_id	= "";   //배차담당자 
	private String car_km		= "";   //대차전km수 
	private String car_rent_dt	= "";	//1회차납입일
	private String car_rent_st	= "";	//대여개시일
	private String car_rent_et	= "";	//대여만료일
	private String ban_user_id	= "";	//반차담당자
	private String rent_fee		= "";	//월대여료
	private String car_rent_tm	= "";	//납입횟수
	private String tm_st2		= "";
	private String req_st		= "";	//청구구분(0-무상대차,1-청구)
	private String tae_st		= "";	//계산서 발행여부
	private String tae_sac_id	= "";	//계산서 발행여부 결재자
	private String init_reg_dt	= "";	//계산서 발행여부 결재자
	private String rent_inv		= "";	//정상대여료
	private String est_id		= "";	//견적아이디
	private String rent_s_cd	= "";	//단기계약번호
	private String f_req_yn		= "";	//대여료선입금여부
	private String f_req_dt		= "";	//대여료선입금 요청일자
	private String rent_fee_st	= "";	//신차해지요금정산구분
	private String rent_fee_cls	= "";	//신차해지시요금정산금
	private String end_rent_link_sac_id	= "";	//만기매칭대차 금액변동결재자

			
	public void setRent_mng_id(String str)	{	rent_mng_id	= str;}
	public void setRent_l_cd(String str)	{	rent_l_cd	= str;}
	public void setNo(String str)			{	no			= str;}
	public void setCar_mng_id(String str)	{	car_mng_id	= str;}
	public void setCar_no(String str)		{	car_no		= str;}
	public void setCar_id(String str)		{	car_id		= str;}
	public void setCar_seq(String str)		{	car_seq		= str;}
	public void setCar_nm(String str)		{	car_nm		= str;}
	public void setBae_user_id(String str)	{	bae_user_id	= str;}
	public void setCar_km(String str)		{	car_km		= str;}
	public void setCar_rent_dt(String str)	{	car_rent_dt	= str;}
	public void setCar_rent_st(String str)	{	car_rent_st	= str;}
	public void setCar_rent_et(String str)	{	car_rent_et	= str;}
	public void setBan_user_id(String str)	{	ban_user_id	= str;}
	public void setRent_fee(String str)		{	rent_fee	= str;}
	public void setCar_rent_tm(String str)	{	car_rent_tm	= str;}
	public void setTm_st2(String str)		{   tm_st2		= str;}
	public void setReq_st(String str)		{   req_st		= str;}
	public void setTae_st(String str)		{   tae_st		= str;}
	public void setTae_sac_id(String str)	{   tae_sac_id	= str;}
	public void setInit_reg_dt(String str)	{   init_reg_dt	= str;}
	public void setRent_inv(String str)		{   rent_inv	= str;}
	public void setEst_id(String str)		{   est_id		= str;}
	public void setRent_s_cd(String str)	{	rent_s_cd	= str;}
	public void setF_req_yn(String str)		{	f_req_yn	= str;}
	public void setF_req_dt(String str)		{	f_req_dt	= str;}
	public void setRent_fee_st(String str)	{	rent_fee_st	= str;}
	public void setRent_fee_cls(String str)	{	rent_fee_cls= str;}
	public void setEnd_rent_link_sac_id(String str)	{	end_rent_link_sac_id= str;}
	
	public String getRent_mng_id()	  	{ 	return rent_mng_id;	}
	public String getRent_l_cd()	  	{ 	return rent_l_cd;	}
	public String getNo()	 			{ 	return no;			}
	public String getCar_mng_id()	  	{ 	return car_mng_id;	}
	public String getCar_no()        	{ 	return car_no;		}
	public String getCar_id()	      	{ 	return car_id;		}
	public String getCar_seq()	      	{ 	return car_seq;		}
	public String getCar_nm()	      	{ 	return car_nm;		}
	public String getBae_user_id()	    { 	return bae_user_id;	}
	public String getCar_km()	     	{ 	return car_km;		}
	public String getCar_rent_dt()  	{ 	return car_rent_dt;	}
	public String getCar_rent_st()	    { 	return car_rent_st;	}
	public String getCar_rent_et()	    { 	return car_rent_et;	}
	public String getBan_user_id()  	{ 	return ban_user_id;	}
	public String getRent_fee()			{ 	return rent_fee;	}
	public String getCar_rent_tm()	    { 	return car_rent_tm;	}
	public String getTm_st2()			{	return tm_st2;		}
	public String getReq_st()			{	return req_st;		}
	public String getTae_st()			{	return tae_st;		}
	public String getTae_sac_id()		{	return tae_sac_id;	}
	public String getInit_reg_dt()		{	return init_reg_dt;	}
	public String getRent_inv()			{	return rent_inv;	}
	public String getEst_id()			{	return est_id;		}
	public String getRent_s_cd()	  	{ 	return rent_s_cd;	}
	public String getF_req_yn()			{ 	return f_req_yn;	}
	public String getF_req_dt()			{ 	return f_req_dt;	}
	public String getRent_fee_st()		{ 	return rent_fee_st;	}
	public String getRent_fee_cls()		{ 	return rent_fee_cls;}
	public String getEnd_rent_link_sac_id()		{ 	return end_rent_link_sac_id;}

}