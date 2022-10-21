package acar.credit;

public class ClsEtcOverBean
{
	private String rent_mng_id;		//계약관리번호           		
	private String rent_l_cd;		//계약번호               

	private int   rent_days;			//대여일수            
	private int    cal_dist;		//약정거리      
	private int    first_dist;		//최초주행거리      
	private int    last_dist;		//최종주행거리          
	private int    real_dist;		//실운행거리  
	private int    over_dist;		//초과운행거리  
	private int    add_dist;		//서비스마일리지  
	private int    jung_dist;		//정산기준   
	private int    r_over_amt;		//산출금액      
	private int   m_over_amt;		//감액      
	private int    j_over_amt;		//정산금액      
	
	private String m_saction_dt;		//감액결재일        
	private String m_saction_id;		//감액결재자      
	private String m_reason;			//감액사유수    
           	
	public ClsEtcOverBean()
	{
		rent_mng_id	= "";
		rent_l_cd	= "";  
	
		rent_days	= 0;
		cal_dist	= 0;   	
		first_dist	= 0;     
		last_dist	= 0;     	
		real_dist	= 0;   
		over_dist	= 0;   	
		add_dist	= 0;  
		jung_dist	= 0; 	
		r_over_amt	= 0;   
		m_over_amt	= 0;   
		j_over_amt	= 0;   
	
		m_saction_dt	= "";
		m_saction_id	= "";
		m_reason	= "";
	
	}

	public void setRent_mng_id(String str)	{	rent_mng_id	= str; 	}
	public void setRent_l_cd(String str)	{	rent_l_cd	= str; 	}

	public void setRent_days(int i)		{	rent_days	= i;   	}
	public void setCal_dist(int i)		{	cal_dist	= i;   	}
	public void setFirst_dist(int i)			{	first_dist	= i; 	}
	public void setLast_dist(int i)			{	last_dist	= i; 	}
	public void setReal_dist(int i)		{	real_dist	= i; 	}
	public void setOver_dist(int i)		{	over_dist	= i; 	}	
	public void setAdd_dist(int i)		{	add_dist	= i; 	}
	public void setJung_dist(int i)		{	jung_dist	= i; 	}
	public void setR_over_amt(int i)		{	r_over_amt	= i; 	}
	public void setM_over_amt(int i)		{	m_over_amt	= i; 	}	
	public void setJ_over_amt(int i)		{	j_over_amt	= i; 	}
		
	public void setM_saction_dt(String str)	{	m_saction_dt	= str; 	}
	public void setM_saction_id(String str)	{	m_saction_id	= str; 	}
	public void setM_reason(String str)		{	m_reason	= str; 	}
										
	public String getRent_mng_id()		{	return rent_mng_id;    	}  
	public String getRent_l_cd()			{	return rent_l_cd;      	}  

	public int    getRent_days()		{	return rent_days;     	}   
	public int    getCal_dist()			{	return cal_dist;     	}   
	public int    getFirst_dist()		{	return first_dist;       	}     
	public int    getLast_dist()		{	return last_dist;       	}  
	public int    getReal_dist()		{	return real_dist;     	}	   
	public int    getOver_dist()		{	return over_dist;     	}   
	public int    getAdd_dist()			{	return add_dist;    	}  
	public int    getJung_dist()		{	return jung_dist;    	}  
	public int    getR_over_amt()		{	return r_over_amt;     	}   
	public int    getM_over_amt()		{	return m_over_amt;     	}   
	public int    getJ_over_amt()		{	return j_over_amt;     	}   
		
	public String getM_saction_dt()	{	return m_saction_dt;  		}  
	public String getM_saction_id()	{	return m_saction_id;    	}  
	public String getM_reason()		{	return m_reason;    	}  
		
}