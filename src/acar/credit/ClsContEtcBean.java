package acar.credit;

public class ClsContEtcBean
{
	private String rent_mng_id;		//계약관리번호           		
	private String rent_l_cd;		//계약번호               
	private String jung_st;		//정산구분
	
	private int    h1_amt;		// 
	private int    h2_amt;		// 
	private int    h3_amt;		// 
	private int    h4_amt;		// 
	private int    h5_amt;		// 
	private int    h6_amt;		// 
	private int    h7_amt;		// 
	
	private String h_st;		//
	private String h_ip_dt;		//   
	private String pay_st; 		//환불형식   1:계좌송금 , 2:현급지급
	private String suc_gubun; 		//승계   1:예치금전액승계 , 2:정산후잔액승계
	private String suc_l_cd; 		//승계받을 계약번호
	private String refund_st; 		//환불
	private String delay_st; 		//유보여부
	private String delay_type; 		//유보종류
	private String delay_desc; 		// 유보사유
	
	private String r_date; 		//카드 승인일
           	
	public ClsContEtcBean()
	{
		rent_mng_id	= "";
		rent_l_cd	= "";  
		jung_st	= "";			
		h1_amt	= 0;   
		h2_amt	= 0;   
		h3_amt	= 0;   
		h4_amt	= 0;   
		h5_amt	= 0;
		h6_amt	= 0;   
		h7_amt	= 0; 			
		h_st	= "";
		h_ip_dt	= "";	
		pay_st	= "";	
		suc_gubun	= "";	
		suc_l_cd	= "";	
		refund_st	= "";	
		delay_st	= "";	
		delay_type	= "";	
		delay_desc	= "";	
		r_date	= "";	
								
	}

	public void setRent_mng_id(String str)	{	rent_mng_id	= str; 	}
	public void setRent_l_cd(String str)	{	rent_l_cd	= str; 	}
	public void setJung_st(String str)	{	jung_st	= str; 	}
	
	public void setH1_amt(int i)		{	h1_amt	= i; 	}
	public void setH2_amt(int i)		{	h2_amt	= i; 	}	
	public void setH3_amt(int i)		{	h3_amt	= i; 	}
	public void setH4_amt(int i)		{	h4_amt	= i; 	}
	public void setH5_amt(int i)		{	h5_amt	= i; 	}
	public void setH6_amt(int i)		{	h6_amt	= i; 	}
	public void setH7_amt(int i)		{	h7_amt	= i; 	}
			
	public void setH_st(String str)	{	h_st	= str; 	}
	public void setH_ip_dt(String str)		{	h_ip_dt	= str; 	}
	public void setPay_st(String str)		{	pay_st	= str; 	}
	public void setSuc_gubun(String str)	{	suc_gubun	= str; 	}
	public void setSuc_l_cd(String str)	{	suc_l_cd	= str; 	}
	public void setRefund_st(String str)	{	refund_st	= str; 	}
	public void setDelay_st(String str)	{	delay_st	= str; 	}
	public void setDelay_type(String str)	{	delay_type	= str; 	}
	public void setDelay_desc(String str)	{	delay_desc	= str; 	}
	public void setR_date(String str)	{	r_date	= str; 	}
										
	public String getRent_mng_id()		{	return rent_mng_id;    	}  
	public String getRent_l_cd()			{	return rent_l_cd;      	}  
	public String getJung_st()	{	return jung_st;  		}  
	
	public int    getH1_amt()		{	return h1_amt;     	}   
	public int    getH2_amt()		{	return h2_amt;     	}   
	public int    getH3_amt()		{	return h3_amt;     	}   
	public int    getH4_amt()		{	return h4_amt;     	}   
	public int    getH5_amt()		{	return h5_amt;     	}   
	public int    getH6_amt()		{	return h6_amt;     	}   
	public int    getH7_amt()		{	return h7_amt;     	}   
			
	public String getH_st()	{	return h_st;    	}  
	public String getH_ip_dt()		{	return h_ip_dt;    	}  
	public String getPay_st()	{	return pay_st;  		}  
	public String getSuc_gubun()	{	return suc_gubun;  		}  
	public String getSuc_l_cd()	{	return suc_l_cd;  		}  
	public String getRefund_st()	{	return refund_st;  		}  
	public String getDelay_st()	{	return delay_st;  		}  
	public String getDelay_type()	{	return delay_type;  		}  
	public String getDelay_desc()	{	return delay_desc;  		}  
	
	public String getR_date()	{	return r_date;  		}  
		
}