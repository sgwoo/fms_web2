// 자동차검사 의뢰내역
		
package acar.res_search;

public class CarMaintReqBean
{

	private String m1_no;			//의뢰no
	private String mng_id;				//관리자
	private String car_mng_id;			//자동차관리
	private String rent_l_cd;		//계약
	private String m1_dt;			//의뢰일
	private String m1_chk;			//외뢰구분: 1:마스타, 2:본인, 3:성수
	private String m1_content;		//특이사항
	private String reg_dt;			//등록일
	private String update_dt;		//수정일
	private String che_dt;			//검사일
	private String che_nm;		//검사소
	private int    tot_dist;		//주행거리
	private String che_type;		//검사종류
	private int	   che_amt;		//금액
	private String che_remark;		//비고
	private String off_id;		//비고
	private String off_nm;		//검사의뢰
	private String gubun;		// 차령연장용 의뢰
	
	
	public CarMaintReqBean()
	{
		m1_no	= "";    
		mng_id = "";    
		car_mng_id = "";    
		rent_l_cd = "";
		m1_dt = "";
		m1_chk = "";
		m1_content = "";    	
		reg_dt = "";    	
		update_dt = "";    
		che_dt = "";    
		che_nm = "";    
		tot_dist = 0;    
		che_type = "";    
		che_amt = 0;    
		che_remark = "";    
		off_id = "";    
		off_nm = "";    
		gubun = "";
		
	}
	
	public void setM1_no(String str) 		{ m1_no		= str; }
	public void setMng_id(String str)		{ mng_id		= str; }    	
	public void setCar_mng_id(String str)	{ car_mng_id			= str; }		
	public void setRent_l_cd(String str)	{ rent_l_cd		= str; }    
	public void setM1_dt(String str)		{ m1_dt		= str; }    
	public void setM1_chk(String str)		{ m1_chk		= str; }
	public void setM1_content(String str)	{ m1_content		= str; }  
	public void setReg_dt(String str)		{ reg_dt		= str; }    
	public void setUpdate_dt(String str)	{ update_dt		= str; }    
	public void setChe_dt(String str)		{ che_dt		= str; }    
	public void setChe_nm(String str)		{ che_nm		= str; }    
	public void setTot_dist(int i)			{ tot_dist		= i;   }    	
	public void setChe_type(String str)		{ che_type		= str; }    
	public void setChe_amt(int i)			{ che_amt		= i;   }    	   
	public void setChe_remark(String str)	{ che_remark		= str; }    
	public void setOff_id(String str)	{ off_id		= str; }    
	public void setOff_nm(String str)	{ off_nm		= str; }    
	public void setGubun(String str)	{ gubun	= str; }    
	
	public String getM1_no() 		{ return m1_no;		}
	public String getMng_id()		{ return mng_id;		}
	public String getCar_mng_id()	{ return car_mng_id;	}
	public String getRent_l_cd()	{ return rent_l_cd;		}
	public String getM1_dt()		{ return m1_dt;		}
	public String getM1_chk()		{ return m1_chk;		}
	public String getM1_content()	{ return m1_content;	}	
	public String getReg_dt()		{ return reg_dt;		}
	public String getUpdate_dt()	{ return update_dt;		}
	public String getChe_dt()		{ return che_dt;		}
	public String getChe_nm()		{ return che_nm;		}
	public int getTot_dist()		{ return tot_dist;	}
	public String getChe_type()		{ return che_type;		}
	public int getChe_amt()			{ return che_amt;		}
	public String getChe_remark()	{ return che_remark;	}
	public String getOff_id()	{ return off_id;	}	
	public String getOff_nm()	{ return off_nm;	}	
	public String getGubun()	{ return gubun;	}	

}