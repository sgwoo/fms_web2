package acar.credit;

public class ClsEtcDetailBean
{
	private String rent_mng_id;		//계약관리번호           		
	private String rent_l_cd;		//계약번호        
	
	private int    s_fee_tm;		//회차 
	private String    s_r_fee_est_dt;		//납입할날짜 
	private int    s_fee_s_amt;		//월대여료 
	private int    s_tax_amt;		//자동차세 
	private int    s_is_amt;		//보험료 + 정비비용 
	private int    s_cal_amt;		//계산금액 
	private int    s_r_fee_s_amt;		//현재가치율 반영 공급가 
	private int    s_r_fee_v_amt;		//현재가치율 반영 부가세 
	private int    s_r_fee_amt;		//현재가치율 합계 
	private float  s_rc_rate;			//현재가치율           
	private int    s_cal_days;		//경과일수
	private int    s_grt_amt;		//보증금 이자효과 
	private int    s_g_fee_amt;		//보증금 이자효과 월대여료 

           	
	public ClsEtcDetailBean()
	{
		rent_mng_id	= "";
		rent_l_cd	= "";  
	
		s_fee_tm	= 0;
		s_r_fee_est_dt	= "";   	
		s_fee_s_amt	= 0;
		s_tax_amt	= 0;   	
		s_is_amt	= 0;
		s_cal_amt	= 0;   	
		s_r_fee_s_amt	= 0;
		s_r_fee_v_amt	= 0;   	
		s_r_fee_amt	= 0;   	
		s_rc_rate	= 0;   	
		s_cal_days	= 0;   
		s_grt_amt	= 0;
		s_g_fee_amt	= 0;   		
				
	}

	public void setRent_mng_id(String str)	{	rent_mng_id	= str; 	}
	public void setRent_l_cd(String str)	{	rent_l_cd	= str; 	}

	public void setS_fee_tm(int i)		{	s_fee_tm	= i;   	}
	public void setS_r_fee_est_dt(String str)	{	s_r_fee_est_dt	= str; 	}
	public void setS_fee_s_amt(int i)		{	s_fee_s_amt	= i;   	}
	public void setS_tax_amt(int i)		{	s_tax_amt	= i;   	}
	public void setS_is_amt(int i)		{	s_is_amt	= i;   	}
	public void setS_cal_amt(int i)		{	s_cal_amt	= i;   	}
	public void setS_r_fee_s_amt(int i)		{	s_r_fee_s_amt	= i;   	}
	public void setS_r_fee_v_amt(int i)		{	s_r_fee_v_amt	= i;   	}
	public void setS_r_fee_amt(int i)		{	s_r_fee_amt	= i;   	}	
	public void setS_rc_rate(float i)		{	s_rc_rate	= i;   	}
	public void setS_cal_days(int i)		{	s_cal_days	= i;   	}
	public void setS_grt_amt(int i)		{	s_grt_amt	= i;   	}
	public void setS_g_fee_amt(int i)		{	s_g_fee_amt	= i;   	}
											
	public String getRent_mng_id()		{	return rent_mng_id;    	}  
	public String getRent_l_cd()			{	return rent_l_cd;      	}  

	public int   	 getS_fee_tm()			{	return s_fee_tm;     	}   
	public String getS_r_fee_est_dt()			{	return s_r_fee_est_dt;      	}  
	public int    getS_fee_s_amt()			{	return s_fee_s_amt;     	}   
	public int    getS_tax_amt()			{	return s_tax_amt;     	}   
	public int    getS_is_amt()			{	return s_is_amt;     	}   
	public int    getS_cal_amt()			{	return s_cal_amt;     	}   
	public int    getS_r_fee_s_amt()			{	return s_r_fee_s_amt;     	}   
	public int    getS_r_fee_v_amt()			{	return s_r_fee_v_amt;     	}   
	public int    getS_r_fee_amt()			{	return s_r_fee_amt;     	}   	
	public float    getS_rc_rate()		{	return s_rc_rate;     	}   
	public int    getS_cal_days()			{	return s_cal_days;     	}   
	public int    getS_grt_amt()			{	return s_grt_amt;     	}   
	public int    getS_g_fee_amt()			{	return s_g_fee_amt;     	}   	
		
}


