package acar.credit;

public class ClsEtcTaxBean
{
	private String rent_mng_id;		//��������ȣ           		
	private String rent_l_cd;		//����ȣ    
	private int seq_no;		//����                

	//���ݰ�꼭 ����  
	private String		tax_r_chk0;   //�ܿ����ô뿩�� ���ݰ�꼭
	private String		tax_r_chk1;   //�ܿ�������     ���ݰ�꼭   
	private String		tax_r_chk2;   //��Ҵ뿩��     ���ݰ�꼭
	private String		tax_r_chk3;   //�̳��뿩��     ���ݰ�꼭
	private String		tax_r_chk4;   //���������     ���ݰ�꼭
	private String		tax_r_chk5;   //���ֺ��       ���ݰ�꼭
	private String		tax_r_chk6;   //�δ���       ���ݰ�꼭  
	private String		tax_r_chk7;   //���ع���     ���ݰ�꼭   
	  	 
	private int		rifee_s_amt_s;    //�ܿ����ô뿩�� ���ް�
	private int		rfee_s_amt_s;     //�ܿ������� ���ް�     
	private int		etc_amt_s;        //���ֺ�� ���ް�        
	private int		etc2_amt_s;       //�δ��� ���ް�        
	private int		dft_amt_s;        //�ߵ���������� ���ް�          
	private int		dfee_amt_s;       //�뿩�� ���ް�  
	private int		etc4_amt_s;       //��Ÿ���ع��� ���ް�  
	private int		dfee_c_amt_s;           //��Ҵ뿩�� ���ް�      	   
	
	private int		rifee_s_amt_v;        //�ܿ����ô뿩�� �ΰ���    
	private int		rfee_s_amt_v;         //�ܿ������� �ΰ���  
	private int		etc_amt_v;            //���ֺ�� �ΰ���         
	private int		etc2_amt_v;           //�δ��� �ΰ���         
	private int		dft_amt_v;            //�ߵ���������� �ΰ���   
	private int		dfee_amt_v;           //�뿩�� �ΰ���           
	private int		etc4_amt_v;           //��Ÿ���ع��� �ΰ���   
	private int		dfee_c_amt_v;           //��Ҵ뿩�� �ΰ��� 	
	
	private int		r_rifee_s_amt_s;    //�ǹ��� �ܿ����ô뿩�� ���ް�
	private int		r_rfee_s_amt_s;     //�ǹ��� �ܿ������� ���ް�     
	private int		r_etc_amt_s;        //�ǹ��� ���ֺ�� ���ް�        
	private int		r_etc2_amt_s;       //�ǹ��� �δ��� ���ް�        
	private int		r_dft_amt_s;        //�ǹ��� �ߵ���������� ���ް�          
	private int		r_dfee_amt_s;       //�ǹ��� �뿩�� ���ް�  
	private int		r_etc4_amt_s;       //�ǹ��� ��Ÿ���ع��� ���ް�  
	private int		r_dfee_c_amt_s;           //�ǹ��� ��Ҵ뿩�� ���ް�    
	
	private int		r_rifee_s_amt_v;        //�ǹ��� �ܿ����ô뿩�� �ΰ���    
	private int		r_rfee_s_amt_v;         //�ǹ��� �ܿ������� �ΰ���  
	private int		r_etc_amt_v;            //�ǹ��� ���ֺ�� �ΰ���         
	private int		r_etc2_amt_v;           //�ǹ��� �δ��� �ΰ���         
	private int		r_dft_amt_v;            //�ǹ��� �ߵ���������� �ΰ���   
	private int		r_dfee_amt_v;           //�ǹ��� �뿩�� �ΰ���           
	private int		r_etc4_amt_v;           //�ǹ��� ��Ÿ���ع��� �ΰ���   
	private int		r_dfee_c_amt_v;           //��Ҵ뿩�� �ΰ���      
	
	private int		rifee_s_amt;        //�ǹ���� �ܿ����ô뿩��  
	private int		rfee_s_amt;         //�ǹ���� �ܿ�������
	private int		etc_amt;            //�ǹ���� ���ֺ��        
	private int		etc2_amt;           //�ǹ���� �δ���         
	private int		dft_amt;            //�ǹ���� �ߵ����������  
	private int		dfee_amt;           //�ǹ���� �뿩��    
	private int		etc4_amt;           //�ǹ���� ��Ÿ���ع���  
		
	private String	rifee_etc;        //�ǹ���� �ܿ����ô뿩�� ǰ��    
	private String	rfee_etc;         //�ǹ���� �ܿ������� ǰ��  
	private String	etc_etc;            //�ǹ���� ���ֺ�� ǰ��         
	private String	etc2_etc;           //�ǹ���� �δ��� ǰ��         
	private String	dft_etc;            //�ǹ���� �ߵ���������� ǰ��   
	private String	dfee_etc;           //�ǹ���� �뿩�� ǰ��           
	private String	etc4_etc;           //�ǹ���� ��Ÿ���ع��� ǰ��  
	
	private String  reg_dt;       //�����    
    private String  reg_id;       //�����    
	private String  upd_dt;       //������    
    private String  upd_id;       //������       
	   
	private int		dfee_c_amt;           //��Ҵ뿩��   �ǹ����      
   	private String	dfee_c_etc;           //�ǹ���� �뿩�� ǰ��      
   	
   	
   	private String		tax_r_chk8;   //�ʰ������     ���ݰ�꼭   	
    	private int		over_amt_s;           //�ʰ����� ���ް�   
    	private int		over_amt_v;           //�ʰ������ �ΰ���           
    	private int		r_over_amt_s;           //�ǹ��� �ʰ����� ���ް�    
    	private int		r_over_amt_v;           //�ǹ��� �ʰ����� �ΰ���    
    	private int		over_amt;           //�ǹ���� �ʰ�����  
    	private String	         over_etc;           //�ǹ���� �ʰ����� ǰ��  
    	
	public ClsEtcTaxBean()
	{
		rent_mng_id	= "";
		rent_l_cd	= "";  
		seq_no = 0;  
					
		tax_r_chk0 = "";    
		tax_r_chk1 = "";      
		tax_r_chk2 = "";    
		tax_r_chk3 = "";    
		tax_r_chk4 = "";    
		tax_r_chk5 = "";    
		tax_r_chk6 = "";    
		tax_r_chk7 = "";      
		  	
		rifee_s_amt_s = 0;   //�ܿ����ô뿩�� ���ް�
		rfee_s_amt_s = 0;    //�ܿ������� ���ް�     
		etc_amt_s = 0;        //���ֺ�� ���ް�        
		etc2_amt_s = 0;       //�δ��� ���ް�        
		dft_amt_s = 0;        //�ߵ���������� ���ް�          
		dfee_amt_s = 0;       //�뿩�� ���ް�  
		etc4_amt_s = 0;       //��Ÿ���ع��� ���ް�  	
		dfee_c_amt_s = 0;           //�뿩�� �ΰ���     
			
		rifee_s_amt_v = 0;        //�ܿ����ô뿩�� �ΰ���    
		rfee_s_amt_v = 0;         //�ܿ������� �ΰ���        
	  	etc_amt_v = 0;             //���ֺ�� �ΰ���         
		etc2_amt_v = 0;            //�δ��� �ΰ���         
		dft_amt_v = 0;             //�ߵ���������� �ΰ���   
		dfee_amt_v = 0;            //�뿩�� �ΰ���           
		etc4_amt_v = 0;            //��Ÿ���ع��� �ΰ���   		
		dfee_c_amt_v = 0;           //�뿩�� �ΰ���       
  
  		rifee_s_amt = 0;        //�ܿ����ô뿩�� �����    
		rfee_s_amt = 0;         //�ܿ������� �����        
	  	etc_amt = 0;             //���ֺ�� �����         
		etc2_amt = 0;            //�δ��� �����         
		dft_amt = 0;             //�ߵ���������� �����   
		dfee_amt = 0;            //�뿩�� �����           
		etc4_amt = 0;            //��Ÿ���ع��� �����   	
			
  		reg_dt  = ""; 
   		reg_id  = "";  	 
		upd_dt  = ""; 
   		upd_id  = "";  	 
   		
   		rifee_etc  = "";        //�ǹ���� �ܿ����ô뿩�� ǰ��    
		rfee_etc   = "";        //�ǹ���� �ܿ������� ǰ��  
		etc_etc    = "";        //�ǹ���� ���ֺ�� ǰ��         
		etc2_etc   = "";        //�ǹ���� �δ��� ǰ��         
		dft_etc    = "";        //�ǹ���� �ߵ���������� ǰ��   
		dfee_etc   = "";        //�ǹ���� �뿩�� ǰ��           
		etc4_etc   = "";        //�ǹ���� ��Ÿ���ع��� ǰ��  
				  
		dfee_c_amt	 = 0;           //�뿩�� �ΰ���         
   		dfee_c_etc	 = "";           //�ǹ���� �뿩�� ǰ��      
   		
   		r_rifee_s_amt_s = 0;   //�ܿ����ô뿩�� ���ް�
		r_rfee_s_amt_s = 0;    //�ܿ������� ���ް�     
		r_etc_amt_s = 0;        //���ֺ�� ���ް�        
		r_etc2_amt_s = 0;       //�δ��� ���ް�        
		r_dft_amt_s = 0;        //�ߵ���������� ���ް�          
		r_dfee_amt_s = 0;       //�뿩�� ���ް�  
		r_etc4_amt_s = 0;       //��Ÿ���ع��� ���ް�  	
		r_dfee_c_amt_s = 0;           //�뿩�� �ΰ���     
			
		r_rifee_s_amt_v = 0;        //�ܿ����ô뿩�� �ΰ���    
		r_rfee_s_amt_v = 0;         //�ܿ������� �ΰ���        
	  	r_etc_amt_v = 0;             //���ֺ�� �ΰ���         
		r_etc2_amt_v = 0;            //�δ��� �ΰ���         
		r_dft_amt_v = 0;             //�ߵ���������� �ΰ���   
		r_dfee_amt_v = 0;            //�뿩�� �ΰ���           
		r_etc4_amt_v = 0;            //��Ÿ���ع��� �ΰ���   		
		r_dfee_c_amt_v = 0;           //�뿩�� �ΰ���    
		
		tax_r_chk8 = "";      
		over_amt_s = 0;        //
		over_amt_v = 0;        //
		r_over_amt_s = 0;        //
		r_over_amt_v = 0;        //
		over_amt = 0;        //
		over_etc = "";      //�ʰ����� ǰ��
   	 				
	}

	public void setRent_mng_id(String str)	{	rent_mng_id	= str; 	}
	public void setRent_l_cd(String str)	{	rent_l_cd	= str; 	}
	public void setSeq_no(int i)			{	seq_no		= i; 	}	
	
	public void setTax_r_chk0(String str)	{	tax_r_chk0		= str; 	}
	public void setTax_r_chk1(String str)	{	tax_r_chk1		= str; 	}
	public void setTax_r_chk2(String str)	{	tax_r_chk2		= str; 	}
	public void setTax_r_chk3(String str)	{	tax_r_chk3		= str; 	}
	public void setTax_r_chk4(String str)	{	tax_r_chk4		= str; 	}
	public void setTax_r_chk5(String str)	{	tax_r_chk5		= str; 	}
	public void setTax_r_chk6(String str)	{	tax_r_chk6		= str; 	}
	public void setTax_r_chk7(String str)	{	tax_r_chk7		= str; 	}
	
	public void	setRifee_s_amt_s(int i)		{  rifee_s_amt_s	= i;    }
	public void	setRfee_s_amt_s(int i)		{  rfee_s_amt_s		= i;    }		
	public void setEtc_amt_s(int i)			{	etc_amt_s		= i; 	}	
	public void setEtc2_amt_s(int i)		{	etc2_amt_s		= i; 	}	
	public void setDft_amt_s(int i)			{	dft_amt_s		= i; 	}	
	public void setDfee_amt_s(int i)		{	dfee_amt_s		= i; 	}	
	public void setEtc4_amt_s(int i)		{	etc4_amt_s		= i; 	}	
	public void setDfee_c_amt_s(int i)		{	dfee_c_amt_s		= i; 	}	
		
	public void	setRifee_s_amt_v(int i)		{  rifee_s_amt_v	= i;    }
	public void	setRfee_s_amt_v(int i)		{  rfee_s_amt_v		= i;    }		
	public void setEtc_amt_v(int i)			{	etc_amt_v		= i; 	}	
	public void setEtc2_amt_v(int i)		{	etc2_amt_v		= i; 	}	
	public void setDft_amt_v(int i)			{	dft_amt_v		= i; 	}	
	public void setDfee_amt_v(int i)		{	dfee_amt_v		= i; 	}	
	public void setEtc4_amt_v(int i)		{	etc4_amt_v		= i; 	}	
	public void setDfee_c_amt_v(int i)		{	dfee_c_amt_v		= i; 	}	
		
	public void	setRifee_s_amt(int i)		{  rifee_s_amt	= i;    }
	public void	setRfee_s_amt(int i)		{  rfee_s_amt		= i;    }		
	public void setEtc_amt(int i)			{	etc_amt		= i; 	}	
	public void setEtc2_amt(int i)			{	etc2_amt		= i; 	}	
	public void setDft_amt(int i)			{	dft_amt		= i; 	}	
	public void setDfee_amt(int i)			{	dfee_amt		= i; 	}	
	public void setEtc4_amt(int i)			{	etc4_amt		= i; 	}	
	
	public void setReg_dt(String str)		{	reg_dt			= str; 	}	 
	public void setReg_id(String str)		{	reg_id			= str; 	}	 
	public void setUpd_dt(String str)		{	upd_dt			= str; 	}	 
	public void setUpd_id(String str)		{	upd_id			= str; 	}	 
	
	public void setRifee_etc(String str)	{	rifee_etc		= str; 	}
	public void setRfee_etc(String str)		{	rfee_etc		= str; 	}
	public void setEtc_etc(String str)		{	etc_etc		= str; 	}
	public void setEtc2_etc(String str)		{	etc2_etc		= str; 	}
	public void setDft_etc(String str)		{	dft_etc		= str; 	}
	public void setDfee_etc(String str)		{	dfee_etc		= str; 	}
	public void setEtc4_etc(String str)		{	etc4_etc		= str; 	}
		
	public void setDfee_c_amt(int i)		{	dfee_c_amt		= i; 	}	
	public void setDfee_c_etc(String str)	{	dfee_c_etc		= str; 	}
	
	public void	setR_rifee_s_amt_s(int i)		{   r_rifee_s_amt_s	= i;    }
	public void	setR_rfee_s_amt_s(int i)		{   r_rfee_s_amt_s		= i;    }		
	public void setR_etc_amt_s(int i)			{	r_etc_amt_s		= i; 	}	
	public void setR_etc2_amt_s(int i)			{	r_etc2_amt_s		= i; 	}	
	public void setR_dft_amt_s(int i)			{	r_dft_amt_s		= i; 	}	
	public void setR_dfee_amt_s(int i)			{	r_dfee_amt_s		= i; 	}	
	public void setR_etc4_amt_s(int i)			{	r_etc4_amt_s		= i; 	}	
	public void setR_dfee_c_amt_s(int i)		{	r_dfee_c_amt_s		= i; 	}	
		
	public void	setR_rifee_s_amt_v(int i)		{   r_rifee_s_amt_v	= i;    }
	public void	setR_rfee_s_amt_v(int i)		{   r_rfee_s_amt_v		= i;    }		
	public void setR_etc_amt_v(int i)			{	r_etc_amt_v		= i; 	}	
	public void setR_etc2_amt_v(int i)			{	r_etc2_amt_v		= i; 	}	
	public void setR_dft_amt_v(int i)			{	r_dft_amt_v		= i; 	}	
	public void setR_dfee_amt_v(int i)			{	r_dfee_amt_v		= i; 	}	
	public void setR_etc4_amt_v(int i)			{	r_etc4_amt_v		= i; 	}	
	public void setR_dfee_c_amt_v(int i)		{	r_dfee_c_amt_v		= i; 	}	
	
	public void setTax_r_chk8(String str)	{	tax_r_chk8		= str; 	}
	public void	setOver_amt_s(int i)		{   over_amt_s	= i;    }
	public void	setOver_amt_v(int i)		{   over_amt_v	= i;    }
	public void	setR_over_amt_s(int i)		{   r_over_amt_s	= i;    }
	public void	setR_over_amt_v(int i)		{   r_over_amt_v	= i;    }
	public void	setOver_amt(int i)		{   over_amt	= i;    }
	public void setOver_etc(String str)	{	over_etc		= str; 	}
			
			
	public String getRent_mng_id()	{	return rent_mng_id;    	}  
	public String getRent_l_cd()	{	return rent_l_cd;      	} 
	public int	  getSeq_no()		{	return seq_no; 		    }   

	public String getTax_r_chk0()		{	return  tax_r_chk0; 	   	}
	public String getTax_r_chk1()		{	return  tax_r_chk1; 	   	}
	public String getTax_r_chk2()		{	return  tax_r_chk2; 	   	}
	public String getTax_r_chk3()		{	return  tax_r_chk3; 	   	}
	public String getTax_r_chk4()		{	return  tax_r_chk4; 	   	}
	public String getTax_r_chk5()		{	return  tax_r_chk5; 	   	}
	public String getTax_r_chk6()		{	return  tax_r_chk6; 	   	}
	public String getTax_r_chk7()		{	return  tax_r_chk7; 	   	}
	
	public int	  getRifee_s_amt_s(){	return  rifee_s_amt_s;    }
	public int	  getRfee_s_amt_s()	{	return  rfee_s_amt_s;    }		
	public int	  getEtc_amt_s()	{	return  etc_amt_s;       }
	public int	  getEtc2_amt_s()	{	return  etc2_amt_s;      }
	public int	  getDft_amt_s()	{	return  dft_amt_s;       }
	public int	  getDfee_amt_s()	{	return  dfee_amt_s;      }
	public int	  getEtc4_amt_s()	{	return  etc4_amt_s;      }
	public int	  getDfee_c_amt_s()	{	return  dfee_c_amt_s;   }
		
	public int	  getRifee_s_amt_v(){	return  rifee_s_amt_v;   }
	public int	  getRfee_s_amt_v()	{	return  rfee_s_amt_v;    }		
	public int	  getEtc_amt_v()	{	return  etc_amt_v;       }
	public int	  getEtc2_amt_v()	{	return  etc2_amt_v;      }
	public int	  getDft_amt_v()	{	return  dft_amt_v;       }
	public int	  getDfee_amt_v()	{	return  dfee_amt_v;      }
	public int	  getEtc4_amt_v()	{	return  etc4_amt_v;      }
	public int	  getDfee_c_amt_v()	{	return  dfee_c_amt_v;   }
	
	public int	  getRifee_s_amt()	{	return  rifee_s_amt;   }
	public int	  getRfee_s_amt()	{	return  rfee_s_amt;    }		
	public int	  getEtc_amt()		{	return  etc_amt;       }
	public int	  getEtc2_amt()		{	return  etc2_amt;      }
	public int	  getDft_amt()		{	return  dft_amt;       }
	public int	  getDfee_amt()		{	return  dfee_amt;      }
	public int	  getEtc4_amt()		{	return  etc4_amt;      }

	public String getReg_dt()		{	return 	reg_dt;			 }    
	public String getReg_id()		{	return 	reg_id; 		 }    
	public String getUpd_dt()		{	return 	upd_dt;			 }    
	public String getUpd_id()		{	return 	upd_id; 		 }    
		
	public String getRifee_etc()	{	return  rifee_etc; 	   	}
	public String getRfee_etc()		{	return  rfee_etc; 	   	}
	public String getEtc_etc()		{	return  etc_etc; 	   	}
	public String getEtc2_etc()		{	return  etc2_etc; 	   	}
	public String getDft_etc()		{	return  dft_etc; 	   	}
	public String getDfee_etc()		{	return  dfee_etc; 	   	}
	public String getEtc4_etc()		{	return  etc4_etc; 	   	}
	
	public int	  getDfee_c_amt()	{	return  dfee_c_amt;     }
	public String getDfee_c_etc()	{	return  dfee_c_etc; 	}
		
	public int	  getR_rifee_s_amt_s(){	return  r_rifee_s_amt_s;    }
	public int	  getR_rfee_s_amt_s()	{	return  r_rfee_s_amt_s;    }		
	public int	  getR_etc_amt_s()	{	return  r_etc_amt_s;       }
	public int	  getR_etc2_amt_s()	{	return  r_etc2_amt_s;      }
	public int	  getR_dft_amt_s()	{	return  r_dft_amt_s;       }
	public int	  getR_dfee_amt_s()	{	return  r_dfee_amt_s;      }
	public int	  getR_etc4_amt_s()	{	return  r_etc4_amt_s;      }
	public int	  getR_dfee_c_amt_s()	{	return  r_dfee_c_amt_s;   }
		
	public int	  getR_rifee_s_amt_v(){	return  r_rifee_s_amt_v;   }
	public int	  getR_rfee_s_amt_v()	{	return  r_rfee_s_amt_v;    }		
	public int	  getR_etc_amt_v()	{	return  r_etc_amt_v;       }
	public int	  getR_etc2_amt_v()	{	return  r_etc2_amt_v;      }
	public int	  getR_dft_amt_v()	{	return  r_dft_amt_v;       }
	public int	  getR_dfee_amt_v()	{	return  r_dfee_amt_v;      }
	public int	  getR_etc4_amt_v()	{	return  r_etc4_amt_v;      }
	public int	  getR_dfee_c_amt_v()	{	return  r_dfee_c_amt_v;   }
		
	public String getTax_r_chk8()	{	return  tax_r_chk8; 	}
	public int	  getOver_amt_s()	{	return  over_amt_s;   }
	public int	  getOver_amt_v()	{	return  over_amt_v;   }
	public int	  getR_over_amt_s()	{	return  r_over_amt_s;   }
	public int	  getR_over_amt_v()	{	return  r_over_amt_v;   }
	public int	  getOver_amt()	{	return  over_amt;   }
	public String getOver_etc()	{	return  over_etc; 	}
	
	
}