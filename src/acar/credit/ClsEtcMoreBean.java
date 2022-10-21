package acar.credit;


//cls_etc 에 추가되는 내용 -  cls_cont에 데이타 안넘기는거 위주 
public class ClsEtcMoreBean
{
	private String rent_mng_id;	//계약관리번호           		
	private String rent_l_cd;		//계약번호               

	private String  re_file_name;       //통장사본  
	private String  etc4_file_name;       //기타손해배상금 증빙  
	private String  remark_file_name;                 //기타 첨부파일
	private String  ex_ip_dt;     //추가입금일    
  	private int		ex_ip_amt;    //추가입금액 
   private String  ex_ip_bank;      //입금은행    
   private String  ex_ip_bank_no;       //입금구좌  
   private String	 des_zip;    //매입옵션 서류 
   private String	 des_addr;    //
   private String	 des_nm;    //수취인  
   private String	 des_tel;    //수취인연락처  
	private String cms_after;		//계약번호   
	private int		m_dae_amt;    //매입옵션 대체 
	private int		ext_amt;    //매입옵션 환불/잡이익 
    private String	 status;    //입력단계     
    private int		cms_amt;    // cms 부분인출 금액 		
    private String	e_serv_rem;    //사전 수리항목     
    private int		e_serv_amt;    //사전 수리 예상금액 	
    
    private String	 conj_dt;    //매입옵션 서류 수령일     
    private String	 est_dt;    //매입옵션 서류 발송일     
    
  //매입옵션 비용        
  	private String  sui_st;				    //구분 Y:이전등록비용 포함, N:미포함      
  	private int	 	sui_d1_amt;			    //등록세 
  	private int	 	sui_d2_amt;			    //채권할인      
  	private int	 	sui_d3_amt;			    //취득세      
  	private int	 	sui_d4_amt;			    //인지대      
  	private int	 	sui_d5_amt;			    //증지대      
  	private int	 	sui_d6_amt;			    //번호판대      
  	private int	 	sui_d7_amt;			    //보조번호판대      
  	private int	 	sui_d8_amt;			    //등록대행료      
  	private int	 	sui_d_amt;			    //계     
  	
  	private String  match_l_cd;				    //만기매칭 계약번호 
	           	
	public ClsEtcMoreBean()
	{
		rent_mng_id	= "";
		rent_l_cd	= "";  
	
	  	re_file_name = "";
		etc4_file_name = "";
		remark_file_name = "";
		ex_ip_dt = "";	  
 		ex_ip_amt	= 0;   	
		ex_ip_bank = "";
		ex_ip_bank_no = "";
		des_zip = "";
		des_addr = "";
		des_nm = "";
		des_tel = "";
		cms_after = "";
		m_dae_amt	= 0;   	
		ext_amt	= 0;   	
		status = "";	
		cms_amt = 0; // cms 부분인출 금액 
		
		e_serv_rem = "";	
		e_serv_amt = 0; // cms 부분인출 금액 
		
		conj_dt = "";
		est_dt = "";
		
		sui_st		= "";	  
		sui_d1_amt	= 0;  
	 	sui_d2_amt	= 0;       
	 	sui_d3_amt	= 0;  
	 	sui_d4_amt	= 0;        
	 	sui_d5_amt	= 0;       
	 	sui_d6_amt	= 0;        
	 	sui_d7_amt	= 0;  
		sui_d8_amt	= 0;     
	 	sui_d_amt	= 0;  
	 	match_l_cd		= "";	 
		
	}
	
	public void setRent_mng_id(String str)	{	rent_mng_id	= str; 	}
	public void setRent_l_cd(String str)	{	rent_l_cd	= str; 	}

	public void setRe_file_name(String str)		{	re_file_name		= str; 	}	 
	public void setEtc4_file_name(String str)		{	etc4_file_name		= str; 	}	 
	public void setRemark_file_name(String str)		{	remark_file_name		= str; 	}	 
	public void setEx_ip_dt(String str)		{	ex_ip_dt		= str; 	}	 
	public void setEx_ip_amt(int i)			{	ex_ip_amt		= i; 	}
	public void setEx_ip_bank(String str)	{	ex_ip_bank		= str; 	}	 
	public void setEx_ip_bank_no(String str)	{	ex_ip_bank_no	= str; 	}	 
	public void setDes_zip(String str)	{	des_zip	= str; 	}	 
	public void setDes_addr(String str)	{	des_addr	= str; 	}	 
	public void setDes_nm(String str)	{	des_nm	= str; 	}	 
	public void setDes_tel(String str)	{	des_tel	= str; 	}	 
	public void setCms_after(String str)	{	cms_after	= str; 	}	 
	public void setM_dae_amt(int i)			{	m_dae_amt		= i; 	}
	public void setExt_amt(int i)			{	ext_amt		= i; 	}
	public void setStatus(String str)		{	status	= str; 	}	
	public void setCms_amt(int i)			{	cms_amt		= i; 	}
	public void setE_serv_rem(String str)		{	e_serv_rem	= str; 	}	
	public void setE_serv_amt(int i)			{	e_serv_amt		= i; 	}
	
	public void setConj_dt(String str)		{	conj_dt	= str; 	}	
	public void setEst_dt(String str)		{	est_dt	= str; 	}	
	
	public void setSui_st(String str)		{	sui_st		= str; 	}
	public void setSui_d1_amt(int i)		{	sui_d1_amt		= i; 	}
	public void setSui_d2_amt(int i)		{	sui_d2_amt		= i; 	}
	public void setSui_d3_amt(int i)		{	sui_d3_amt		= i; 	}
	public void setSui_d4_amt(int i)		{	sui_d4_amt		= i; 	}
	public void setSui_d5_amt(int i)		{	sui_d5_amt		= i; 	}
	public void setSui_d6_amt(int i)		{	sui_d6_amt		= i; 	}
	public void setSui_d7_amt(int i)		{	sui_d7_amt		= i; 	}
	public void setSui_d8_amt(int i)		{	sui_d8_amt		= i; 	}
	public void setSui_d_amt(int i)			{	sui_d_amt		= i; 	}	
	public void setMatch_l_cd(String str)		{	match_l_cd		= str; 	}
																
	public String getRent_mng_id()		{	return rent_mng_id;    	}  
	public String getRent_l_cd()			{	return rent_l_cd;      	}  

	public String getRe_file_name()		{	return re_file_name;	  	 }	 
	public String getEtc4_file_name()		{	return etc4_file_name;	  	 }	 
	public String getRemark_file_name()		{	return remark_file_name;	  	 }	 
			
	public String getEx_ip_dt()		{	return ex_ip_dt;	  	 }	 
	public int	  getEx_ip_amt()	{	return ex_ip_amt;		 }
	public String getEx_ip_bank()	{	return ex_ip_bank;		 }	 
	public String getEx_ip_bank_no(){	return ex_ip_bank_no;	 }	
	
	public String getDes_zip(){	return des_zip;	 }	
	public String getDes_addr(){	return des_addr;	 }	
	public String getDes_nm(){	return des_nm;	 }	
	public String getDes_tel(){	return des_tel;	 }	
	public String getCms_after(){	return cms_after;	 }	
	
	public int	  getM_dae_amt()	{	return m_dae_amt;		 }
	public int	  getExt_amt()	{	return ext_amt;		 }
	public String getStatus(){	return status;	 }	
	public int	  getCms_amt()	{	return cms_amt;		 }
		
	public String getE_serv_rem(){	return e_serv_rem;	 }	
	public int	  getE_serv_amt()	{	return e_serv_amt;		 }
	
	public String getConj_dt(){	return conj_dt;	 }	
	public String getEst_dt(){	return est_dt;	 }	
	
	public String getSui_st()		{	return  sui_st; 	   	}
	public int	  getSui_d1_amt()	{	return  sui_d1_amt;     }
	public int	  getSui_d2_amt()	{	return  sui_d2_amt;     }
	public int	  getSui_d3_amt()	{	return  sui_d3_amt;     }
	public int	  getSui_d4_amt()	{	return  sui_d4_amt;     }
	public int	  getSui_d5_amt()	{	return  sui_d5_amt;     }
	public int	  getSui_d6_amt()	{	return  sui_d6_amt;     }
	public int	  getSui_d7_amt()	{	return  sui_d7_amt;     }
	public int	  getSui_d8_amt()	{	return  sui_d8_amt;     }
	public int	  getSui_d_amt()	{	return  sui_d_amt;      }
	
	public String getMatch_l_cd()		{	return  match_l_cd; 	   	}
}