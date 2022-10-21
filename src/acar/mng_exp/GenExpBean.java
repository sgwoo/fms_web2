package acar.mng_exp;

public class GenExpBean
{
	private String exp_st;	//1 : 검사비 2 : 자동차환경개선부담금 3 : 자동차세  9 :취득세
	private String car_mng_id;
	private String exp_etc;
	private int    exp_amt;
	private String exp_est_dt;
	private String exp_dt;

	private String car_no;
	private String car_nm;
	private String firm_nm;
	private String client_nm;	
	private String rent_mng_id;		//계약관리번호           		
	private String rent_l_cd;		//계약번호               
	//2005-07-21 추가 : 정현미
	private String exp_start_dt;	//과세기준
	private String exp_end_dt;		//과세기준
	private String rtn_cau;			//환급사유
	private String rtn_cau_dt;		//환급사유발생일자
	private int    rtn_est_amt;		//환급예정금액
	private int    rtn_amt;			//환급금액
	private String rtn_dt;			//환급일자
	private String pk_dt;
	private String car_st;       //1:렌트 2:예비용 3:리스
	
	private String car_use;       //1:렌트 2:리스
	private String car_ext;       //1:서울 2:경기 3:부산 4:김해
	private String exp_car_no;    //1:납부당시차량번호
	private String rtn_req_dt;		//환급신청일자

	private String exp_gubun;
	private String exp_gita;
	
	public GenExpBean()
	{
		exp_st		= "";
		car_mng_id		= "";
		exp_etc		= "";
		exp_amt		= 0;
		exp_est_dt	= "";
		exp_dt		= "";   
		
		car_no		= "";
		car_nm		= "";
		firm_nm		= "";
		client_nm	= "";
		rent_mng_id	= "";
		rent_l_cd	= "";  

		exp_start_dt= "";
		exp_end_dt	= "";
		rtn_cau		= "";
		rtn_cau_dt	= "";
		rtn_est_amt	= 0;
		rtn_amt		= 0;
		rtn_dt		= "";
		pk_dt		= "";
		car_st		= "";
		car_use		= "";
		car_ext		= "";
		exp_car_no	= "";
		rtn_req_dt	= "";
		
		exp_gubun	= "";
		exp_gita	= "";

	}
	
	public void setExp_st(String str)	{	exp_st			= str;	}
	public void setCar_mng_id(String str)	{	car_mng_id			= str;	}
	public void setExp_etc(String str)	{	exp_etc			= str;	}
	public void setExp_amt(int i)		{	exp_amt			= i;	}
	public void setExp_est_dt(String str){	exp_est_dt		= str;	}
	public void setExp_dt(String str)	{	exp_dt			= str;	}
	
	public void setCar_no(String str)	{	car_no		= str;	}
	public void setCar_nm(String str)	{	car_nm		= str;	}
	public void setFirm_nm(String str)	{	firm_nm		= str;	}
	public void setClient_nm(String str){	client_nm	= str;	}
	public void setRent_mng_id(String str)	{	rent_mng_id	= str; 	}
	public void setRent_l_cd(String str)	{	rent_l_cd	= str; 	}

	public void setExp_start_dt	(String str)	{	exp_start_dt= str;	}
	public void setExp_end_dt	(String str)	{	exp_end_dt	= str;	}
	public void setRtn_cau		(String str)	{	rtn_cau		= str;	}
	public void setRtn_cau_dt	(String str)	{	rtn_cau_dt	= str;	}
	public void setRtn_est_amt	(int i)			{	rtn_est_amt	= i;	}
	public void setRtn_amt		(int i)			{	rtn_amt		= i;	}
	public void setRtn_dt		(String str)	{	rtn_dt		= str; 	}
	public void setPk_dt		(String str)	{	pk_dt		= str; 	}
	public void setCar_st		(String str)	{	car_st		= str; 	}
	public void setCar_use		(String str)	{	car_use		= str; 	}
	public void setCar_ext		(String str)	{	car_ext		= str; 	}
	public void setExp_car_no	(String str)	{	exp_car_no	= str;	}
	public void setRtn_req_dt	(String str)	{	rtn_req_dt	= str; 	}

	public void setExp_gubun	(String str)	{	exp_gubun	= str; 	}
	public void setExp_gita		(String str)	{	exp_gita	= str; 	}
	

	public String getExp_st()			{	return	exp_st;			}
	public String getCar_mng_id()		{	return	car_mng_id;		}   
	public String getExp_etc()			{	return	exp_etc;		}  
	public int 	  getExp_amt()			{	return	exp_amt;		} 
	public String getExp_est_dt()		{	return	exp_est_dt;		}
	public String getExp_dt()			{	return	exp_dt;			}
	
	public String getCar_no()			{	return car_no;			}
	public String getCar_nm()			{	return car_nm;			}
	public String getFirm_nm()			{	return firm_nm;			}
	public String getClient_nm()		{	return client_nm;		}
	public String getRent_mng_id	()	{	return rent_mng_id;    	}  
	public String getRent_l_cd		()	{	return rent_l_cd;      	}    

	public String getExp_start_dt	()	{	return	exp_start_dt;	}
	public String getExp_end_dt		()	{	return	exp_end_dt;		}
	public String getRtn_cau		()	{	return	rtn_cau;		}
	public String getRtn_cau_dt		()	{	return	rtn_cau_dt;		}
	public int 	  getRtn_est_amt	()	{	return	rtn_est_amt;	} 
	public int 	  getRtn_amt		()	{	return	rtn_amt;		} 
	public String getRtn_dt			()	{	return	rtn_dt;		    }  
	public String getPk_dt			()	{	return	pk_dt;		    }  
	public String getCar_st			()	{	return	car_st;		    }  
	public String getCar_use		()	{	return	car_use;	    }  
	public String getCar_ext		()	{	return	car_ext;	    }  
	public String getExp_car_no		()	{	return  exp_car_no;		}
	public String getRtn_req_dt		()	{	return	rtn_req_dt;	    }  

	public String getExp_gubun		()	{	return	exp_gubun;	    }  
	public String getExp_gita		()	{	return	exp_gita;	    }  
}