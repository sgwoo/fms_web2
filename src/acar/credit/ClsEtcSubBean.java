package acar.credit;

public class ClsEtcSubBean
{
	private String rent_mng_id;		//��������ȣ           		
	private String rent_l_cd;		//����ȣ   
	private int    cls_seq;			//���������Ƿڼ���    
	 
 	private int		fine_amt_1;     //���·� Ȯ��
	private int		car_ja_amt_1;   //��å�� Ȯ��    
	private int		dly_amt_1;      //��ü�� Ȯ��
	private int		etc_amt_1;       //���ֺ�� Ȯ��
	private int		etc2_amt_1;      //�δ��� Ȯ��
	private int		dft_amt_1;       //�ߵ���������� Ȯ��
	private int		dfee_amt_1;      //�̳�(����)�뿩�� Ȯ��
	private int		etc3_amt_1;      //�������� Ȯ��
	private int		etc4_amt_1;      //��Ÿ���ع��� Ȯ��
	private int		no_v_amt_1;      //�ΰ��� Ȯ�� 
	private int		fdft_amt1_1;      //Ȯ���ݾװ�
	
	private int		fine_amt_2;      // ���·� ���
	private int		car_ja_amt_2;    //��å�� ���  
	private int		dly_amt_2;       //��ü�� ���
	private int		etc_amt_2;       //���ֺ�� ���
	private int		etc2_amt_2;      //�δ��� ���
	private int		dft_amt_2;      //����� ���
	private int		dfee_amt_2;     //�̳�(����)�뿩�� ��� 
	private int		etc3_amt_2;      //�������� ���
	private int		etc4_amt_2;      //��Ÿ ���ع��� ���	
	private int		no_v_amt_2;      //�ΰ��� ���
	private int		fdft_amt1_2;   //��� ��
	
	
	private int		fine_amt_3;     //���·� �ܾ� 
	private int		car_ja_amt_3;   //��å�� �ܾ�   
	private int		dly_amt_3;      //��ü�� �ܾ�
	private int		etc_amt_3;      //���ֺ�� �ܾ�
	private int		etc2_amt_3;     //�δ��� �ܾ� 
	private int		dft_amt_3;   //����� �ܾ�
	private int		dfee_amt_3;      //�̳�(����)�뿩�� �ܾ�
	private int		etc3_amt_3;      //�������� �ܾ�
	private int		etc4_amt_3;      //��Ÿ���ع��� �ܾ�	
	private int		no_v_amt_3;      //�ΰ��� �ܾ�
	private int		fdft_amt1_3;    //�ܾװ� 
	
	private String  reg_dt;       //�����    
    private String  reg_id;       //�����        
	private String  upd_dt;       //������    
    private String  upd_id;       //������    
 
    private int		rifee_amt_2_v;     //�ܿ����ô뿩�� ��� 
    private int		rfee_amt_2_v;     //������ ��� 
    private int		dfee_amt_2_v;     //�̳�(����)�뿩�� ���  vat
    private int		dft_amt_2_v;     //�̳�(����)�뿩�� ��� 
    private int		etc_amt_2_v;     //�̳�(����)�뿩�� ��� 
    private int		etc2_amt_2_v;     //�̳�(����)�뿩�� ��� 
    private int		etc4_amt_2_v;     //�̳�(����)�뿩�� ��� 
    
     private int		over_amt_1;     //�ʰ�����Ÿ�   
     private int		over_amt_2;     //�ʰ�����Ÿ�   
     private int		over_amt_3;     //�ʰ�����Ÿ�   
       private int		over_amt_2_v;     //�ʰ�����Ÿ�   ��� vat
    	
	public ClsEtcSubBean()
	{
		rent_mng_id	= "";
		rent_l_cd	= "";  
		cls_seq	= 0;
		
		fine_amt_1	= 0; 
		car_ja_amt_1= 0;     
		dly_amt_1	= 0;    
		etc_amt_1	= 0; 
		etc2_amt_1	= 0;   
		dft_amt_1	= 0;   
		dfee_amt_1	= 0;    
		etc3_amt_1	= 0;   
		etc4_amt_1	= 0;   
	
		no_v_amt_1	= 0;     
		fdft_amt1_1	= 0;    
		fine_amt_2	= 0;     
		car_ja_amt_2= 0;   
		dly_amt_2	= 0;      
		etc_amt_2	= 0;     
		etc2_amt_2	= 0;    
		dft_amt_2	= 0; 
		dfee_amt_2	= 0;    
		etc3_amt_2	= 0;   
		etc4_amt_2	= 0;    
		
		no_v_amt_2	= 0;    
		fdft_amt1_2	= 0;    
		fine_amt_3	= 0;     
		car_ja_amt_3= 0;   
		dly_amt_3	= 0;      
		etc_amt_3	= 0;     
		etc2_amt_3	= 0;    
		dft_amt_3	= 0; 
		dfee_amt_3	= 0;    
		etc3_amt_3	= 0;   
		etc4_amt_3	= 0;    
		
		no_v_amt_3	= 0;    
		fdft_amt1_3	= 0;    
		reg_dt  = ""; 
   		reg_id  = "";  	  	
		upd_dt  = ""; 
   		upd_id  = ""; 
   		
   		rifee_amt_2_v   = 0;
   		rfee_amt_2_v    = 0;
   		dfee_amt_2_v	= 0;  	 
   		dft_amt_2_v     = 0;
   	 	etc_amt_2_v 	= 0;  	
   	 	etc2_amt_2_v 	= 0;  	
   	 	etc4_amt_2_v 	= 0;  	
   	 	
   	 	over_amt_1 	= 0;  	
   	 	over_amt_2 	= 0;  	
   	 	over_amt_3 	= 0;  	
   	 	over_amt_2_v 	= 0;  	
			
	}

	public void setRent_mng_id(String str)	{	rent_mng_id	= str; 	}
	public void setRent_l_cd(String str)	{	rent_l_cd	= str; 	}
	public void setCls_seq(int i)			{	cls_seq	= i;   	}

	public void setFine_amt_1(int i)		{	fine_amt_1		= i; 	}	
	public void setCar_ja_amt_1(int i)		{	car_ja_amt_1	= i; 	}	
	public void setDly_amt_1(int i)			{	dly_amt_1		= i; 	}	
	public void setEtc_amt_1(int i)			{	etc_amt_1		= i; 	}	
	public void setEtc2_amt_1(int i)		{	etc2_amt_1		= i; 	}	
	public void setDft_amt_1(int i)			{	dft_amt_1		= i; 	}	
	public void setDfee_amt_1(int i)		{	dfee_amt_1		= i; 	}	
	public void setEtc3_amt_1(int i)		{	etc3_amt_1		= i; 	}	
	public void setEtc4_amt_1(int i)		{	etc4_amt_1		= i; 	}	

	public void setNo_v_amt_1(int i)		{	no_v_amt_1		= i; 	}	
	public void setFdft_amt1_1(int i)		{	fdft_amt1_1		= i; 	}	
	public void setFine_amt_2(int i)		{	fine_amt_2		= i; 	}	
	public void setCar_ja_amt_2(int i)		{	car_ja_amt_2	= i; 	}	
	public void setDly_amt_2(int i)			{	dly_amt_2		= i; 	}	
	public void setEtc_amt_2(int i)			{	etc_amt_2		= i; 	}	
	public void setEtc2_amt_2(int i)		{	etc2_amt_2		= i; 	}	
	public void setDft_amt_2(int i)			{	dft_amt_2		= i; 	}	
	public void setDfee_amt_2(int i)		{	dfee_amt_2		= i; 	}	
	public void setEtc3_amt_2(int i)		{	etc3_amt_2		= i; 	}	
	public void setEtc4_amt_2(int i)		{	etc4_amt_2		= i; 	}	

	public void setNo_v_amt_2(int i)		{	no_v_amt_2		= i; 	}	
	public void setFdft_amt1_2(int i)		{	fdft_amt1_2		= i; 	}
	public void setFine_amt_3(int i)		{	fine_amt_3		= i; 	}	
	public void setCar_ja_amt_3(int i)		{	car_ja_amt_3	= i; 	}	
	public void setDly_amt_3(int i)			{	dly_amt_3		= i; 	}	
	public void setEtc_amt_3(int i)			{	etc_amt_3		= i; 	}	
	public void setEtc2_amt_3(int i)		{	etc2_amt_3		= i; 	}	
	public void setDft_amt_3(int i)			{	dft_amt_3		= i; 	}	
	public void setDfee_amt_3(int i)		{	dfee_amt_3		= i; 	}	
	public void setEtc3_amt_3(int i)		{	etc3_amt_3		= i; 	}	
	public void setEtc4_amt_3(int i)		{	etc4_amt_3		= i; 	}	
	
	public void setNo_v_amt_3(int i)		{	no_v_amt_3		= i; 	}	
	public void setFdft_amt1_3(int i)		{	fdft_amt1_3		= i; 	}
	public void setReg_dt(String str)		{	reg_dt			= str; 	}	 
	public void setReg_id(String str)		{	reg_id			= str; 	}	 
	public void setUpd_dt(String str)		{	upd_dt			= str; 	}	 
	public void setUpd_id(String str)		{	upd_id			= str; 	}	 
	
	public void setRifee_amt_2_v(int i)		{	rifee_amt_2_v	= i; 	}
	public void setRfee_amt_2_v(int i)		{	rfee_amt_2_v	= i; 	}
	public void setDfee_amt_2_v(int i)		{	dfee_amt_2_v	= i; 	}
	public void setDft_amt_2_v(int i)		{	dft_amt_2_v	= i; 	}
	public void setEtc_amt_2_v(int i)		{	etc_amt_2_v	= i; 	}
	public void setEtc2_amt_2_v(int i)		{	etc2_amt_2_v	= i; 	}
	public void setEtc4_amt_2_v(int i)		{	etc4_amt_2_v	= i; 	}
	
	public void setOver_amt_1(int i)		{	over_amt_1	= i; 	}
	public void setOver_amt_2(int i)		{	over_amt_2	= i; 	}
	public void setOver_amt_3(int i)		{	over_amt_3	= i; 	}
	public void setOver_amt_2_v(int i)		{	over_amt_2_v	= i; 	}
	
			
	public String getRent_mng_id()	{	return rent_mng_id;    	}  
	public String getRent_l_cd()	{	return rent_l_cd;      	}    
	public int    getCls_seq()		{	return cls_seq;     	}   
	
	public int	  getFine_amt_1()	{	return  fine_amt_1;      }
	public int	  getCar_ja_amt_1()	{	return  car_ja_amt_1;    }
	public int	  getDly_amt_1()	{	return  dly_amt_1;       }
	public int	  getEtc_amt_1()	{	return  etc_amt_1;       }
	public int	  getEtc2_amt_1()	{	return  etc2_amt_1;      }
	public int	  getDft_amt_1()	{	return  dft_amt_1;       }
	public int	  getDfee_amt_1()	{	return  dfee_amt_1;      }
	public int	  getEtc3_amt_1()	{	return  etc3_amt_1;      }
	public int	  getEtc4_amt_1()	{	return  etc4_amt_1;      }
	
	public int	  getNo_v_amt_1()	{	return  no_v_amt_1;      }
	public int	  getFdft_amt1_1()	{	return  fdft_amt1_1;     }
	public int	  getFine_amt_2()	{	return  fine_amt_2;      }
	public int	  getCar_ja_amt_2()	{	return  car_ja_amt_2;    }
	public int	  getDly_amt_2()	{	return  dly_amt_2;       }
	public int	  getEtc_amt_2()	{	return  etc_amt_2;       }
	public int	  getEtc2_amt_2()	{	return  etc2_amt_2;      }
	public int	  getDft_amt_2()	{	return  dft_amt_2;       }
	public int	  getDfee_amt_2()	{	return  dfee_amt_2;      }
	public int	  getEtc3_amt_2()	{	return  etc3_amt_2;      }
	public int	  getEtc4_amt_2()	{	return  etc4_amt_2;      }

	public int	  getNo_v_amt_2()	{	return  no_v_amt_2;      }
	public int	  getFdft_amt1_2()	{	return  fdft_amt1_2;     }
	public int	  getFine_amt_3()	{	return  fine_amt_3;      }
	public int	  getCar_ja_amt_3()	{	return  car_ja_amt_3;    }
	public int	  getDly_amt_3()	{	return  dly_amt_3;       }
	public int	  getEtc_amt_3()	{	return  etc_amt_3;       }
	public int	  getEtc2_amt_3()	{	return  etc2_amt_3;      }
	public int	  getDft_amt_3()	{	return  dft_amt_3;       }
	public int	  getDfee_amt_3()	{	return  dfee_amt_3;      }
	public int	  getEtc3_amt_3()	{	return  etc3_amt_3;      }
	public int	  getEtc4_amt_3()	{	return  etc4_amt_3;      }

	public int	  getNo_v_amt_3()	{	return  no_v_amt_3;      }
	public int	  getFdft_amt1_3()	{	return  fdft_amt1_3;     }
	public String getReg_dt()		{	return 	reg_dt;			 }    
	public String getReg_id()		{	return 	reg_id; 		 }   
	public String getUpd_dt()		{	return 	upd_dt;			 }    
	public String getUpd_id()		{	return 	upd_id; 		 } 
	
	public int	  getRifee_amt_2_v()	{	return  rifee_amt_2_v;    }	
	public int	  getRfee_amt_2_v()	{	return  rfee_amt_2_v;    }		   
	public int	  getDfee_amt_2_v()	{	return  dfee_amt_2_v;    }	
	public int	  getDft_amt_2_v()	{	return  dft_amt_2_v;    }	
	public int	  getEtc_amt_2_v()	{	return  etc_amt_2_v;    }	
	public int	  getEtc2_amt_2_v()	{	return  etc2_amt_2_v;    }	
	public int	  getEtc4_amt_2_v()	{	return  etc4_amt_2_v;    }	
	
	public int	  getOver_amt_1()	{	return  over_amt_1;    }	
	public int	  getOver_amt_2()	{	return  over_amt_2;    }	
	public int	  getOver_amt_3()	{	return  over_amt_3;    }	
	public int	  getOver_amt_2_v()	{	return  over_amt_2_v;    }	
	
}