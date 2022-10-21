package acar.credit;

public class ClsEtcTaxBean
{
	private String rent_mng_id;		//계약관리번호           		
	private String rent_l_cd;		//계약번호    
	private int seq_no;		//순번                

	//세금계산서 관련  
	private String		tax_r_chk0;   //잔여개시대여료 세금계산서
	private String		tax_r_chk1;   //잔여선납금     세금계산서   
	private String		tax_r_chk2;   //취소대여료     세금계산서
	private String		tax_r_chk3;   //미납대여료     세금계산서
	private String		tax_r_chk4;   //해지위약금     세금계산서
	private String		tax_r_chk5;   //외주비용       세금계산서
	private String		tax_r_chk6;   //부대비용       세금계산서  
	private String		tax_r_chk7;   //손해배상금     세금계산서   
	  	 
	private int		rifee_s_amt_s;    //잔여개시대여료 공급가
	private int		rfee_s_amt_s;     //잔여선납금 공급가     
	private int		etc_amt_s;        //외주비용 공급가        
	private int		etc2_amt_s;       //부대비용 공급가        
	private int		dft_amt_s;        //중도해지위약금 공급가          
	private int		dfee_amt_s;       //대여료 공급가  
	private int		etc4_amt_s;       //기타손해배상금 공급가  
	private int		dfee_c_amt_s;           //취소대여료 공급가      	   
	
	private int		rifee_s_amt_v;        //잔여개시대여료 부가세    
	private int		rfee_s_amt_v;         //잔여선납금 부가세  
	private int		etc_amt_v;            //외주비용 부가세         
	private int		etc2_amt_v;           //부대비용 부가세         
	private int		dft_amt_v;            //중도해지위약금 부가세   
	private int		dfee_amt_v;           //대여료 부가세           
	private int		etc4_amt_v;           //기타손해배상금 부가세   
	private int		dfee_c_amt_v;           //취소대여료 부가세 	
	
	private int		r_rifee_s_amt_s;    //실발행 잔여개시대여료 공급가
	private int		r_rfee_s_amt_s;     //실발행 잔여선납금 공급가     
	private int		r_etc_amt_s;        //실발행 외주비용 공급가        
	private int		r_etc2_amt_s;       //실발행 부대비용 공급가        
	private int		r_dft_amt_s;        //실발행 중도해지위약금 공급가          
	private int		r_dfee_amt_s;       //실발행 대여료 공급가  
	private int		r_etc4_amt_s;       //실발행 기타손해배상금 공급가  
	private int		r_dfee_c_amt_s;           //실발행 취소대여료 공급가    
	
	private int		r_rifee_s_amt_v;        //실발행 잔여개시대여료 부가세    
	private int		r_rfee_s_amt_v;         //실발행 잔여선납금 부가세  
	private int		r_etc_amt_v;            //실발행 외주비용 부가세         
	private int		r_etc2_amt_v;           //실발행 부대비용 부가세         
	private int		r_dft_amt_v;            //실발행 중도해지위약금 부가세   
	private int		r_dfee_amt_v;           //실발행 대여료 부가세           
	private int		r_etc4_amt_v;           //실발행 기타손해배상금 부가세   
	private int		r_dfee_c_amt_v;           //취소대여료 부가세      
	
	private int		rifee_s_amt;        //실발행분 잔여개시대여료  
	private int		rfee_s_amt;         //실발행분 잔여선납금
	private int		etc_amt;            //실발행분 외주비용        
	private int		etc2_amt;           //실발행분 부대비용         
	private int		dft_amt;            //실발행분 중도해지위약금  
	private int		dfee_amt;           //실발행분 대여료    
	private int		etc4_amt;           //실발행분 기타손해배상금  
		
	private String	rifee_etc;        //실발행분 잔여개시대여료 품목    
	private String	rfee_etc;         //실발행분 잔여선납금 품목  
	private String	etc_etc;            //실발행분 외주비용 품목         
	private String	etc2_etc;           //실발행분 부대비용 품목         
	private String	dft_etc;            //실발행분 중도해지위약금 품목   
	private String	dfee_etc;           //실발행분 대여료 품목           
	private String	etc4_etc;           //실발행분 기타손해배상금 품목  
	
	private String  reg_dt;       //등록일    
    private String  reg_id;       //등록자    
	private String  upd_dt;       //수정일    
    private String  upd_id;       //수정자       
	   
	private int		dfee_c_amt;           //취소대여료   실발행분      
   	private String	dfee_c_etc;           //실발행분 대여료 품목      
   	
   	
   	private String		tax_r_chk8;   //초과운행금     세금계산서   	
    	private int		over_amt_s;           //초과운행 공급가   
    	private int		over_amt_v;           //초과운행료 부가세           
    	private int		r_over_amt_s;           //실발행 초과운행 공급가    
    	private int		r_over_amt_v;           //실발행 초과운행 부가세    
    	private int		over_amt;           //실발행분 초과운행  
    	private String	         over_etc;           //실발행분 초과운행 품목  
    	
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
		  	
		rifee_s_amt_s = 0;   //잔여개시대여료 공급가
		rfee_s_amt_s = 0;    //잔여선납금 공급가     
		etc_amt_s = 0;        //외주비용 공급가        
		etc2_amt_s = 0;       //부대비용 공급가        
		dft_amt_s = 0;        //중도해지위약금 공급가          
		dfee_amt_s = 0;       //대여료 공급가  
		etc4_amt_s = 0;       //기타손해배상금 공급가  	
		dfee_c_amt_s = 0;           //대여료 부가세     
			
		rifee_s_amt_v = 0;        //잔여개시대여료 부가세    
		rfee_s_amt_v = 0;         //잔여선납금 부가세        
	  	etc_amt_v = 0;             //외주비용 부가세         
		etc2_amt_v = 0;            //부대비용 부가세         
		dft_amt_v = 0;             //중도해지위약금 부가세   
		dfee_amt_v = 0;            //대여료 부가세           
		etc4_amt_v = 0;            //기타손해배상금 부가세   		
		dfee_c_amt_v = 0;           //대여료 부가세       
  
  		rifee_s_amt = 0;        //잔여개시대여료 발행분    
		rfee_s_amt = 0;         //잔여선납금 발행분        
	  	etc_amt = 0;             //외주비용 발행분         
		etc2_amt = 0;            //부대비용 발행분         
		dft_amt = 0;             //중도해지위약금 발행분   
		dfee_amt = 0;            //대여료 발행분           
		etc4_amt = 0;            //기타손해배상금 발행분   	
			
  		reg_dt  = ""; 
   		reg_id  = "";  	 
		upd_dt  = ""; 
   		upd_id  = "";  	 
   		
   		rifee_etc  = "";        //실발행분 잔여개시대여료 품목    
		rfee_etc   = "";        //실발행분 잔여선납금 품목  
		etc_etc    = "";        //실발행분 외주비용 품목         
		etc2_etc   = "";        //실발행분 부대비용 품목         
		dft_etc    = "";        //실발행분 중도해지위약금 품목   
		dfee_etc   = "";        //실발행분 대여료 품목           
		etc4_etc   = "";        //실발행분 기타손해배상금 품목  
				  
		dfee_c_amt	 = 0;           //대여료 부가세         
   		dfee_c_etc	 = "";           //실발행분 대여료 품목      
   		
   		r_rifee_s_amt_s = 0;   //잔여개시대여료 공급가
		r_rfee_s_amt_s = 0;    //잔여선납금 공급가     
		r_etc_amt_s = 0;        //외주비용 공급가        
		r_etc2_amt_s = 0;       //부대비용 공급가        
		r_dft_amt_s = 0;        //중도해지위약금 공급가          
		r_dfee_amt_s = 0;       //대여료 공급가  
		r_etc4_amt_s = 0;       //기타손해배상금 공급가  	
		r_dfee_c_amt_s = 0;           //대여료 부가세     
			
		r_rifee_s_amt_v = 0;        //잔여개시대여료 부가세    
		r_rfee_s_amt_v = 0;         //잔여선납금 부가세        
	  	r_etc_amt_v = 0;             //외주비용 부가세         
		r_etc2_amt_v = 0;            //부대비용 부가세         
		r_dft_amt_v = 0;             //중도해지위약금 부가세   
		r_dfee_amt_v = 0;            //대여료 부가세           
		r_etc4_amt_v = 0;            //기타손해배상금 부가세   		
		r_dfee_c_amt_v = 0;           //대여료 부가세    
		
		tax_r_chk8 = "";      
		over_amt_s = 0;        //
		over_amt_v = 0;        //
		r_over_amt_s = 0;        //
		r_over_amt_v = 0;        //
		over_amt = 0;        //
		over_etc = "";      //초과운행 품목
   	 				
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