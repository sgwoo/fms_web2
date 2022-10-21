// 단기계약관리

// 작성일 : 2003.12.11 (정현미)

package acar.res_search;

public class RentContBean
{
	private String rent_s_cd;		//단기계약관리번호
	private String car_mng_id;		//차량관리번호
	private String rent_st;			//계약구분:단기대여, 정비대차, 사고대차, 직원배정, 업무지원, 차량정비, 차량점검, 사고수리
	private String cust_st;			//고객구분:장기기존고객, 단기기존고객, 신규고객, 직원
	private String cust_id;			//고객관리번호
	private String sub_c_id;		//대차대상-차량관리번호
	private String accid_id;		//사고관리번호
	private String serv_id;			//정비관리번호
	private String maint_id;		//점검관리번호
	private String rent_dt;			//계약일자
	private String brch_id;			//영업소
	private String bus_id;			//담당자
	private String rent_start_dt;	//대여기간-개시일시
	private String rent_end_dt;		//대여기간-만료일시
	private String rent_hour;		//대여시간
	private String rent_days;		//대여일수
	private String rent_months;		//대여월수
	private String etc;				//특이사항
	private String deli_plan_dt;	//배차예정일시
	private String ret_plan_dt;		//반차예정일시
	private String deli_dt;			//배차일시
	private String ret_dt;			//반차일시
	private String deli_loc;		//배차위치
	private String ret_loc;			//반차위치
	private String deli_mng_id;		//배차담당자
	private String ret_mng_id;		//반차담당자
	private String use_st;			//계약상태
	private String reg_id;			//등록자
	private String reg_dt;			//등록일
	private String update_id;		//수정자
	private String update_dt;		//수정일
	private String rent_start_dt_d;
	private String rent_start_dt_h;
	private String rent_start_dt_s;
	private String rent_end_dt_d;
	private String rent_end_dt_h;
	private String rent_end_dt_s;
	private String deli_plan_dt_d;
	private String deli_plan_dt_h;
	private String deli_plan_dt_s;
	private String ret_plan_dt_d;
	private String ret_plan_dt_h;
	private String ret_plan_dt_s;
	private String deli_dt_d;
	private String deli_dt_h;
	private String deli_dt_s;
	private String ret_dt_d;
	private String ret_dt_h;
	private String ret_dt_s;
	private String sub_l_cd;
	private String site_id;
	private String seq;
	private String mng_id;
	private String cls_st;
	private String cls_dt;
	private String com_emp_yn;
	private String ins_change_std_dt;
	private String ins_change_flag;
	
	public RentContBean()
	{
		rent_s_cd	= "";    
		car_mng_id	= "";        
		rent_st = "";    
		cust_st = "";
		cust_id = "";
		sub_c_id = "";
		accid_id = "";
		serv_id = "";
		maint_id = "";
		rent_dt = "";
		brch_id = "";
		bus_id = "";
		rent_start_dt = "";
		rent_end_dt = "";
		rent_hour = "";
		rent_days = "";
		rent_months = "";
		etc = "";
		deli_plan_dt = "";
		ret_plan_dt = "";
		deli_dt = "";
		ret_dt = "";
		deli_loc = "";
		ret_loc = "";
		deli_mng_id = "";
		ret_mng_id = "";
		use_st = "";
		reg_id = "";
		reg_dt = "";
		update_id = "";
		update_dt = "";
		rent_start_dt_d = "";
		rent_start_dt_h = "";
		rent_start_dt_s = "";
		rent_end_dt_d = "";
		rent_end_dt_h = "";
		rent_end_dt_s = "";
		deli_plan_dt_d = "";
		deli_plan_dt_h = "";
		deli_plan_dt_s = "";
		ret_plan_dt_d = "";
		ret_plan_dt_h = "";
		ret_plan_dt_s = "";
		deli_dt_d = "";
		deli_dt_h = "";
		deli_dt_s = "";
		ret_dt_d = "";
		ret_dt_h = "";
		ret_dt_s = "";
		sub_l_cd = "";
		site_id = "";
		seq = "";
		mng_id = "";
		cls_st = "";
		cls_dt = "";
		com_emp_yn = "";
		ins_change_std_dt = "";
		ins_change_flag = "";

	}
	
	public void setRent_s_cd(String str) 	{ rent_s_cd		= str; }
	public void setCar_mng_id(String str)	{ car_mng_id	= str; }
	public void setRent_st(String str)		{ rent_st		= str; }    
	public void setCust_st(String str)		{ cust_st		= str; }    	
	public void setCust_id(String str)		{ cust_id		= str; }    	
	public void setSub_c_id(String str)		{ sub_c_id		= str; }    	
	public void setAccid_id(String str)		{ accid_id		= str; }    	
	public void setServ_id(String str)		{ serv_id		= str; }    	
	public void setMaint_id(String str)		{ maint_id		= str; }    	
	public void setRent_dt(String str)		{ rent_dt		= str; }		
	public void setBrch_id(String str)		{ brch_id		= str; }		
	public void setBus_id(String str)		{ bus_id		= str; }		
	public void setRent_start_dt(String str){ rent_start_dt	= str; }		
	public void setRent_end_dt(String str)	{ rent_end_dt	= str; }		
	public void setRent_hour(String str)	{ rent_hour		= str; }		
	public void setRent_days(String str)	{ rent_days		= str; }		
	public void setRent_months(String str)	{ rent_months	= str; }		
	public void setEtc(String str)			{ etc			= str; }		
	public void setDeli_plan_dt(String str)	{ deli_plan_dt	= str; }    
	public void setRet_plan_dt(String str)	{ ret_plan_dt	= str; }    
	public void setDeli_dt(String str)		{ deli_dt		= str; } 
	public void setRet_dt(String str)		{ ret_dt		= str; }    	
	public void setDeli_loc(String str)		{ deli_loc		= str; }		
	public void setRet_loc(String str)		{ ret_loc		= str; }		
	public void setDeli_mng_id(String str)	{ deli_mng_id	= str; }		
	public void setRet_mng_id(String str)	{ ret_mng_id	= str; }		
	public void setUse_st(String str)		{ use_st		= str; }    
	public void setReg_id(String str)		{ reg_id		= str; }    
	public void setReg_dt(String str)		{ reg_dt		= str; }    
	public void setUpdate_id(String str)	{ update_id		= str; }    
	public void setUpdate_dt(String str)	{ update_dt		= str; }    
	public void setRent_start_dt2(String str){ 
		rent_start_dt	= str; 
		if(str.length() == 12){
			rent_start_dt_d	= str.substring(0,8); 
			rent_start_dt_h = str.substring(8,10);
			rent_start_dt_s = str.substring(10,12);
		}
	}
	public void setRent_end_dt2(String str){ 
		rent_end_dt	= str; 
		if(str.length() == 12){
			rent_end_dt_d	= str.substring(0,8); 
			rent_end_dt_h = str.substring(8,10);
			rent_end_dt_s = str.substring(10,12);
		}
	}
	public void setDeli_plan_dt2(String str){ 
		deli_plan_dt	= str; 
		if(str.length() == 12){
			deli_plan_dt_d	= str.substring(0,8); 
			deli_plan_dt_h = str.substring(8,10);
			deli_plan_dt_s = str.substring(10,12);
		}
	}
	public void setRet_plan_dt2(String str){ 
		ret_plan_dt	= str; 
		if(str.length() == 12){
			ret_plan_dt_d	= str.substring(0,8); 
			ret_plan_dt_h = str.substring(8,10);
			ret_plan_dt_s = str.substring(10,12);
		}
	}
	public void setDeli_dt2(String str){ 
		deli_dt	= str; 
		if(str.length() == 12){
			deli_dt_d	= str.substring(0,8); 
			deli_dt_h = str.substring(8,10);
			deli_dt_s = str.substring(10,12);
		}
	}
	public void setRet_dt2(String str){ 
		ret_dt	= str; 
		if(str.length() == 12){
			ret_dt_d	= str.substring(0,8); 
			ret_dt_h = str.substring(8,10);
			ret_dt_s = str.substring(10,12);
		}
	}
	public void setSub_l_cd(String str)	{ sub_l_cd		= str; }    
	public void setSite_id(String str)	{ site_id		= str; }    
	public void setSeq	(String str)	{ seq			= str; }    
	public void setMng_id(String str)	{ mng_id		= str; }    
	public void setCls_st(String str)	{ cls_st		= str; }    
	public void setCls_dt(String str)	{ cls_dt		= str; }    
	public void setCom_emp_yn(String str){com_emp_yn	= str; }
	public void setIns_change_std_dt(String str){ins_change_std_dt	= str; }
	public void setIns_change_flag(String str){ins_change_flag	= str; }
	
	public String getRent_s_cd() 	{ return rent_s_cd;		}
	public String getCar_mng_id()	{ return car_mng_id;	}
	public String getRent_st()		{ return rent_st;		}
	public String getCust_st()		{ return cust_st;		}
	public String getCust_id()		{ return cust_id;		}
	public String getSub_c_id()		{ return sub_c_id;		}
	public String getAccid_id()		{ return accid_id;		}
	public String getServ_id()		{ return serv_id;		}
	public String getMaint_id()		{ return maint_id;		}
	public String getRent_dt()		{ return rent_dt;		}
	public String getBrch_id()		{ return brch_id;		}
	public String getBus_id()		{ return bus_id;		}
	public String getRent_start_dt(){ return rent_start_dt;	}
	public String getRent_end_dt()	{ return rent_end_dt;	}
	public String getRent_hour()	{ return rent_hour;		}
	public String getRent_days()	{ return rent_days;		}
	public String getRent_months()	{ return rent_months;	}
	public String getEtc()			{ return etc;			}
	public String getDeli_plan_dt()	{ return deli_plan_dt;	}
	public String getRet_plan_dt()	{ return ret_plan_dt;	}
	public String getDeli_dt()		{ return deli_dt;		}
	public String getRet_dt()		{ return ret_dt;		}
	public String getDeli_loc()		{ return deli_loc;		}
	public String getRet_loc()		{ return ret_loc;		}
	public String getDeli_mng_id()	{ return deli_mng_id;	}
	public String getRet_mng_id()	{ return ret_mng_id;	}
	public String getUse_st()		{ return use_st;		}
	public String getReg_id()		{ return reg_id;		}
	public String getReg_dt()		{ return reg_dt;		}
	public String getUpdate_id()	{ return update_id;		}
	public String getUpdate_dt()	{ return update_dt;		}
	public String getRent_start_dt_d(){ return rent_start_dt_d;	}
	public String getRent_start_dt_h(){ return rent_start_dt_h;	}
	public String getRent_start_dt_s(){ return rent_start_dt_s;	}
	public String getRent_end_dt_d(){ return rent_end_dt_d;	}
	public String getRent_end_dt_h(){ return rent_end_dt_h;	}
	public String getRent_end_dt_s(){ return rent_end_dt_s;	}
	public String getDeli_plan_dt_d(){ return deli_plan_dt_d;}
	public String getDeli_plan_dt_h(){ return deli_plan_dt_h;}
	public String getDeli_plan_dt_s(){ return deli_plan_dt_s;}
	public String getRet_plan_dt_d(){ return ret_plan_dt_d;	}
	public String getRet_plan_dt_h(){ return ret_plan_dt_h;	}
	public String getRet_plan_dt_s(){ return ret_plan_dt_s;	}
	public String getDeli_dt_d()	{ return deli_dt_d;		}
	public String getDeli_dt_h()	{ return deli_dt_h;		}
	public String getDeli_dt_s()	{ return deli_dt_s;		}
	public String getRet_dt_d()		{ return ret_dt_d;		}
	public String getRet_dt_h()		{ return ret_dt_h;		}
	public String getRet_dt_s()		{ return ret_dt_s;		}
	public String getSub_l_cd()		{ return sub_l_cd;		}
	public String getSite_id()		{ return site_id;		}
	public String getSeq()			{ return seq;			}
	public String getMng_id()		{ return mng_id;		}
	public String getCls_st()		{ return cls_st;		}
	public String getCls_dt()		{ return cls_dt;		}
	public String getCom_emp_yn()	{ return com_emp_yn;	}
	public String getIns_change_std_dt()	{ return ins_change_std_dt;	}
	public String getIns_change_flag()	{ return ins_change_flag;	}

}