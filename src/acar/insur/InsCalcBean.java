package acar.insur;

public class InsCalcBean
{
	private String 	reg_code;
	private String 	reg_dt;
	private String 	reg_id;
	private String 	update_id;
	private String 	update_dt;
	private int 	ins_cost;
	private String 	client_st;
	private String 	car_name;
	private int 	car_b_p;
	private String 	client_nm;
	private String 	ssn;
	private String 	m_tel;
	private String 	addr;
	private String 	age_scp;
	private String 	vins_gcp_kd;
	private String 	job;
	private String 	ins_limit;
	private String 	com_emp_yn;
	private String 	etc;
	private String 	tel_com;
	private String 	t_zip;
	private String 	use_st;
	private String 	enp_no;
	private String 	driver_nm;
	private String 	driver_ssn;
	private String 	driver_rel;
	
	public InsCalcBean()
	{
		reg_code    	= "";
		reg_dt      	= "";
		reg_id      	= "";
		update_id   	= "";
		update_dt   	= "";
		ins_cost    	= 0;
		client_st   	= "";
		car_name    	= "";
		car_b_p     	= 0;
		client_nm   	= "";
		ssn         	= "";
		m_tel       	= "";
		addr        	= "";
		age_scp         = "";
		vins_gcp_kd 	= "";
		job         	= "";
		ins_limit   	= "";
		com_emp_yn  	= "";
		etc         	= "";
	    tel_com     	= "";
	    t_zip     		= "";
	    use_st     		= "";
	    enp_no     		= "";
	    driver_nm     	= "";
	    driver_ssn     	= "";
	    driver_rel     	= "";
	}
	
	public void setRegCode   	(String str)	{	reg_code    = str;	}
	public void setRegDt     	(String str)	{	reg_dt      = str;	}
	public void setRegId     	(String str)	{	reg_id      = str;	}
	public void setUpdateId  	(String str)	{	update_id   = str;	}
	public void setUpdateDt  	(String str)	{	update_dt   = str;	}
	public void setInsCost   	(int i)			{	ins_cost    = i;	}
	public void setClientSt  	(String str)	{	client_st   = str;	}
	public void setCarName   	(String str)	{	car_name    = str;	}
	public void setCarBP    	(int i)			{	car_b_p     = i;	}
	public void setClientNm  	(String str)	{	client_nm   = str;	}
	public void setSsn        	(String str)	{	ssn         = str;	}
	public void setMTel      	(String str)	{	m_tel       = str;	}
	public void setAddr       	(String str)	{	addr        = str;	}
	public void setAgeScp     	(String str)	{	age_scp     = str;	}
	public void setVinsGcpKd	(String str)	{	vins_gcp_kd = str;	}
	public void setJob        	(String str)	{	job         = str;	}
	public void setInsLimit  	(String str)	{	ins_limit   = str;	}
	public void setComEmpYn 	(String str)	{	com_emp_yn  = str;	}
	public void setEtc        	(String str)	{	etc         = str;	}
	public void setTelCom    	(String str)	{	tel_com     = str;	}
	public void setTZip    	  	(String str)	{	t_zip     	= str;	}
	public void setUseSt   		(String str)	{	use_st     	= str;	}
	public void setEnpNo  		(String str)	{	enp_no     	= str;	}
	public void setDriverNm		(String str)	{	driver_nm   = str;	}
	public void setDriverSsn  	(String str)	{	driver_ssn  = str;	}
	public void setDriverRel  	(String str)	{	driver_rel  = str;	}
	
	public String getRegCode   	()			{	return	reg_code;    }
	public String getRegDt    	()			{	return	reg_dt;      }
	public String getRegId     	()			{	return	reg_id;      }
	public String getUpdateId  	()			{	return	update_id;   }
	public String getUpdateDt  	()			{	return	update_dt;   }
	public int 	  getInsCost   	()			{	return	ins_cost;    }
	public String getClientSt  	()			{	return	client_st;   }
	public String getCarName   	()			{	return	car_name;    }
	public int 	  getCarBP    	()			{	return	car_b_p;     }
	public String getClientNm  	()			{	return	client_nm;   }
	public String getSsn        ()			{	return	ssn;         }
	public String getMTel      	()			{	return	m_tel;       }
	public String getAddr       ()			{	return	addr;        }
	public String getAgeScp     ()			{	return	age_scp;     }
	public String getVinsGcpKd	()			{	return	vins_gcp_kd; }
	public String getJob        ()			{	return	job;         }
	public String getInsLimit  	()			{	return	ins_limit;   }
	public String getComEmpYn 	()			{	return	com_emp_yn;  }
	public String getEtc        ()			{	return	etc;         }
	public String getTelCom    	()			{	return	tel_com;     }
	public String getTZip	    ()			{	return	t_zip;    	 }
	public String getUseSt	    ()			{	return	use_st;    	 }
	public String getEnpNo    	()			{	return	enp_no;    	 }
	public String getDriverNm   ()			{	return	driver_nm;   }
	public String getDriverSsn  ()			{	return	driver_ssn;  }
	public String getDriverRel  ()			{	return	driver_rel;  }
}