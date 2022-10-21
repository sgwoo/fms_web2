package acar.cls;

public class ClsAllotBean
{
	private String rent_mng_id;		//��������ȣ           		
	private String rent_l_cd;		//����ȣ               
	private String car_mng_id;		//�ڵ���������ȣ               
	private String cls_rtn_dt;		//��������               
	private int nalt_rest;			//�̻�ȯ����               
	private String cls_rtn_int;		//������               
	private String max_pay_dt;		//����������           
	private int cls_rtn_fee;		//�ߵ�����������         
	private int cls_rtn_int_amt;	//�������               
	private int dly_alt;			//��ü�Һα�      
	private int be_alt;				//������      
	private int cls_rtn_amt;		//�ߵ������Ѿ�(�ߵ���ȯ��)        
	private String bk_code;			//��������          
	private String acnt_no;			//���¹�ȣ          
	private String acnt_user;		//�����ָ�            
	private String cls_rtn_cau;		//��������  
	private String cls_rtn_fee_int;	//�ߵ����������� ������     
	private String reg_id;			//�����
	private String reg_dt;			//�������
	private int nalt_rest_1;		//����������ä
	private int nalt_rest_2;		//������Ա�
	private int cls_etc_fee;		//��Ÿ������(����Ǹ��Ҵ����) 

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