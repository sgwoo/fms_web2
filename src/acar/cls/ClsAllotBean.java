package acar.cls;

public class ClsAllotBean
{
	private String rent_mng_id;		//계약관리번호           		
	private String rent_l_cd;		//계약번호               
	private String car_mng_id;		//자동차관리번호               
	private String cls_rtn_dt;		//해지일자               
	private int nalt_rest;			//미상환원금               
	private String cls_rtn_int;		//이자율               
	private String max_pay_dt;		//최종수납일           
	private int cls_rtn_fee;		//중도해지수수료         
	private int cls_rtn_int_amt;	//경과이자               
	private int dly_alt;			//연체할부금      
	private int be_alt;				//선수금      
	private int cls_rtn_amt;		//중도해지총액(중도상환액)        
	private String bk_code;			//납입은행          
	private String acnt_no;			//계좌번호          
	private String acnt_user;		//예금주명            
	private String cls_rtn_cau;		//해지사유  
	private String cls_rtn_fee_int;	//중도해지수수료 이자율     
	private String reg_id;			//등록자
	private String reg_dt;			//등록일자
	private int nalt_rest_1;		//유동성장기부채
	private int nalt_rest_2;		//장기차입금
	private int cls_etc_fee;		//기타수수료(저당권말소대행비) 

	public ClsAllotBean()
	{
		rent_mng_id	= "";
		rent_l_cd	= "";  
		car_mng_id	= "";     
		cls_rtn_dt	= "";    
		nalt_rest	= 0;     
		cls_rtn_int	= "";     
		max_pay_dt	= "";    
		cls_rtn_fee	= 0;  
		cls_rtn_int_amt	= 0;
		dly_alt		= 0;     
		be_alt		= 0;
		cls_rtn_amt	= 0;   
		bk_code		= "";     
		acnt_no		= "";     
		acnt_user	= "";     
		cls_rtn_cau	= ""; 
		cls_rtn_fee_int = "";
		reg_id = "";
		reg_dt = "";
		nalt_rest_1	= 0;     
		nalt_rest_2	= 0;   
		cls_etc_fee = 0;
	}

	public void setRent_mng_id(String str)	{	rent_mng_id	= str; 	}
	public void setRent_l_cd(String str)	{	rent_l_cd	= str; 	}
	public void setCar_mng_id(String str)	{	car_mng_id	= str; 	}
	public void setCls_rtn_dt(String str)	{	cls_rtn_dt	= str; 	}
	public void setNalt_rest(int i)			{	nalt_rest	= i; 	}
	public void setCls_rtn_int(String str)	{	cls_rtn_int	= str; 	}
	public void setMax_pay_dt(String str)	{	max_pay_dt	= str; 	}
	public void setCls_rtn_fee(int i)		{	cls_rtn_fee	= i; 	}
	public void setCls_rtn_int_amt(int i)	{	cls_rtn_int_amt	= i;}
	public void setDly_alt(int i)			{	dly_alt		= i; 	}
	public void setBe_alt(int i)			{	be_alt		= i;   	}
	public void setCls_rtn_amt(int i)		{	cls_rtn_amt	= i;   	}
	public void setBk_code(String str)		{	bk_code		= str; 	}
	public void setAcnt_no(String str)		{	acnt_no		= str; 	}
	public void setAcnt_user(String str)	{	acnt_user	= str; 	}
	public void setCls_rtn_cau(String str)	{	cls_rtn_cau	= str; 	}
	public void setCls_rtn_fee_int(String str){	cls_rtn_fee_int= str;}
	public void setReg_id(String str)		{	reg_id		= str;	}
	public void setReg_dt(String str)		{	reg_dt		= str;	}
	public void setNalt_rest_1(int i)		{	nalt_rest_1	= i; 	}
	public void setNalt_rest_2(int i)		{	nalt_rest_2	= i; 	}
	public void setCls_etc_fee(int i)		{	cls_etc_fee	= i; 	}


	public String getRent_mng_id()	{	return rent_mng_id;    	}  
	public String getRent_l_cd()	{	return rent_l_cd;      	}    
	public String getCar_mng_id()	{	return car_mng_id;     	}       
	public String getCls_rtn_dt()	{	return cls_rtn_dt;     	}      
	public int	  getNalt_rest()	{	return nalt_rest;      	}       
	public String getCls_rtn_int()	{	return cls_rtn_int;    	}       
	public String getMax_pay_dt()	{	return max_pay_dt;     	}      
	public int    getCls_rtn_fee()	{	return cls_rtn_fee;   	}    
	public int    getCls_rtn_int_amt(){	return cls_rtn_int_amt; }  
	public int    getDly_alt()		{	return dly_alt;         }       
	public int    getBe_alt()		{	return be_alt;     		}   
	public int    getCls_rtn_amt()	{	return cls_rtn_amt;     }   
	public String getBk_code()		{	return bk_code;       	}     
	public String getAcnt_no()		{	return acnt_no;       	}     
	public String getAcnt_user()	{	return acnt_user;       }     
	public String getCls_rtn_cau()	{	return cls_rtn_cau;		}       
	public String getCls_rtn_fee_int(){	return cls_rtn_fee_int;	}       
	public String getReg_id()		{	return reg_id;			}       
	public String getReg_dt()		{	return reg_dt;			} 
	public int	  getNalt_rest_1()	{	return nalt_rest_1;    	}       
	public int	  getNalt_rest_2()	{	return nalt_rest_2;    	}       	
	public int	  getCls_etc_fee()	{	return cls_etc_fee;    	}

}