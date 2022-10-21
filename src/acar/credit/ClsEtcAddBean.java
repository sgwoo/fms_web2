package acar.credit;

public class ClsEtcAddBean
{
	private String rent_mng_id;		//계약관리번호           		
	private String rent_l_cd;		//계약번호               

	private float   a_f;			//계약당시 이자율            
	private int    old_opt_amt;		//계약당시 매입옵션비용 
	private String add_saction_id;		//          
	private String add_saction_dt;		// 
	
	private String mt;		   //매입옵션 1:중도매입옵션 2:연장 중도매입옵션
	private float   rc_rate;		//현제가치율            
	private int    b_old_opt_amt;	//연장직전  매입옵션가 
	private int   count1;			      
	private int    count2;		
	private int    m_r_fee_amt;	//중도매입옵션 대여료 반영분  
	
	
           	
	public ClsEtcAddBean()
	{
		rent_mng_id	= "";
		rent_l_cd	= "";  
	
		a_f	= 0;
		old_opt_amt	= 0;   	
		add_saction_id = "";
		add_saction_dt = "";
		
		mt	= "";
		rc_rate	= 0;   	
		b_old_opt_amt	= 0;   	
		count1	= 0;   	
		count2	= 0;   	
		m_r_fee_amt	= 0;   	
			
	}

	public void setRent_mng_id(String str)	{	rent_mng_id	= str; 	}
	public void setRent_l_cd(String str)	{	rent_l_cd	= str; 	}

	public void setA_f(float i)		{	a_f	= i;   	}
	public void setOld_opt_amt(int i)		{	old_opt_amt	= i;   	}	
	public void setAdd_saction_id(String str)	{	add_saction_id	= str; 	}
	public void setAdd_saction_dt(String str)	{	add_saction_dt	= str; 	}
		
	public void setMt(String str)	{	mt	= str; 	}
	public void setRc_rate(float i)		{	rc_rate	= i;   	}
	public void setB_old_opt_amt(int i)		{	b_old_opt_amt	= i;   	}	
	public void setCount1(int i)		{	count1	= i;   	}	
	public void setCount2(int i)		{	count2	= i;   	}	
	public void setM_r_fee_amt(int i)		{	m_r_fee_amt	= i;   	}	
		
	public String getRent_mng_id()		{	return rent_mng_id;    	}  
	public String getRent_l_cd()			{	return rent_l_cd;      	}  

	public float  getA_f()		{	return a_f;     	}   
	public int    getOld_opt_amt()			{	return old_opt_amt;     	}   	
	public String getAdd_saction_id()			{	return add_saction_id;      	}  
	public String getAdd_saction_dt()			{	return add_saction_dt;      	}  
	
	public String getMt()			{	return mt;      	}  
	public float  getRc_rate()		{	return rc_rate;     	}   
	public int    getB_old_opt_amt()			{	return b_old_opt_amt;     	}   	
	public int    getCount1()			{	return count1;     	}   	
	public int    getCount2()			{	return count2;     	}   	
	public int    getM_r_fee_amt()			{	return m_r_fee_amt;     	}   	
		
}