package acar.master_car;

public class Master_CarBean
{
	private String car_mng_id;	//차량관리번호
	private long    js_seq;		//No
	private String js_dt;		//접수일자
	private String js_tm;		//접수시간
	private String sbshm;		//서비스항목
	private String gmjm;		//가맹점명
	private String ggm;			//고객명
	private String car_no;		//차량번호
	private String rent_mng_id;	//계약관리번호           		
	private String rent_l_cd;	//장기계약번호               
	private String rent_s_cd;	//단기계약번호               
	private String bus_id;		//담당자
	private String sigg;		//실입고지
	private String m_tel;		//핸드폰
	private int	   sbgb_amt;	//실비구분
	private String ssssny;		//접수상세내역
	private String jcssny;		//조치상세내역
	private String jsbb;		//접수방법
	private String gjyj_dt;		//결재예정일
	private String gj_dt;       //결재일
	private String remarks;       //특이사항
	private int	   tot_dist;	//주행거리
	private String gubun;       //1:마스타, 3:성수
	
	public Master_CarBean()
	{
		car_mng_id	= "";
		js_seq		= 0;
		js_dt		= "";
		js_tm		= "";   
		sbshm		= "";
		gmjm		= "";
		ggm			= "";
		car_no		= "";
		rent_mng_id	= "";
		rent_l_cd	= "";  
		rent_s_cd	= "";
		bus_id		= "";
		sigg		= "";
		m_tel		= "";
		sbgb_amt	= 0;
		ssssny		= "";
		jcssny		= "";
		jsbb		= "";
		gjyj_dt		= "";
		gj_dt		= "";
		remarks		= "";
		tot_dist	= 0;
		gubun		= "";
		
	}



	
	public void setCar_mng_id	(String str)	{	car_mng_id = str;	}
	public void setJs_seq		(long i	)		{		js_seq = i ;	}

	public void setCar_no		(String str)	{car_no = str;		}
	public void setRent_mng_id	(String str)	{rent_mng_id = str;	}
	public void setRent_l_cd	(String str)	{rent_l_cd = str;	}

	public void setRent_s_cd	(String str)	{rent_s_cd = str;	}
	public void setBus_id	(String str)	{bus_id = str;	}

	public void setJs_dt	(String str)	{js_dt = str;	}
	public void setJs_tm	(String str)	{js_tm = str;	}

	public void setSbshm	(String str)	{sbshm = str;	}
	public void setGmjm		(String str)	{gmjm = str;	}
	public void setGgm		(String str)	{ggm = str;		}

	public void setSigg		(String str)	{sigg = str;	}
	public void setM_tel	(String str)	{m_tel = str;	}
	public void setSbgb_amt	(int i		)	{sbgb_amt = i ;	}
	public void setSsssny	(String str)	{ssssny = str;	}
	public void setJcssny	(String str)	{jcssny = str;	}
	public void setJsbb		(String str)	{jsbb = str;	}
	public void setGjyj_dt	(String str)	{gjyj_dt = str; }
	public void setGj_dt	(String str)	{gj_dt = str;	}
	public void setRemarks	(String str)	{remarks = str;	}
	
	public void setTot_dist	(int i		)	{tot_dist = i ;	}
	
	public void setGubun	(String str)	{gubun = str;	}


	public String getCar_mng_id		()	{	return	car_mng_id;	}   
	public long   getJs_seq			()	{	return	js_seq;		} 
	
	public String getCar_no			()	{	return car_no;		}
	public String getRent_mng_id	()	{	return rent_mng_id; }  
	public String getRent_l_cd		()	{	return rent_l_cd;   }    
	public String getRent_s_cd		()	{	return rent_s_cd;   }    
	public String getBus_id			()	{	return bus_id;		}    

	public String getJs_dt			()	{	return	js_dt;		}
	public String getJs_tm			()	{	return	js_tm;		}

	public String getSbshm			()	{	return	sbshm;		}
	public String getGmjm			()	{	return	gmjm;		}
	public String getGgm			()	{	return	ggm;		}
	
	public String getSigg			()	{	return	sigg;		}
	public String getM_tel			()	{	return	m_tel;		}
	public int getSbgb_amt			()	{	return	sbgb_amt;	}
	public String getSsssny			()	{	return	ssssny;		}
	public String getJcssny			()	{	return	jcssny;		}
	public String getJsbb			()	{	return	jsbb;		}
	public String getGjyj_dt		()	{	return	gjyj_dt;	}
	public String getGj_dt			()	{	return	gj_dt;		}
	public String getRemarks		()	{	return	remarks;		}
	
	public int getTot_dist			()	{	return	tot_dist;	}

	public String getGubun			()	{	return	gubun;		}

}