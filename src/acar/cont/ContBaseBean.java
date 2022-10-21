package acar.cont;

public class ContBaseBean
{
	private String rent_mng_id	= "";    
	private String rent_l_cd	= "";
	private String client_id	= "";
	private String car_mng_id	= "";    
	private String rent_st		= "";    
	private String bus_st		= "";    
	private String car_st		= "";    
	private String rent_dt		= "";    
	private String dlv_dt		= "";
	private String rent_start_dt= "";
	private String note			= "";
	private String brch_id		= "";
	private String bus_id		= "";
	private String mng_id		= "";
	private String reg_id		= "";
	private String reg_dt		= "";
	private String r_site		= "";
	private String p_zip		= "";
	private String p_addr		= "";
	private String o_map		= "";
	private String use_yn		= "";
	private String bus_nm		= "";
	private String mng_nm		= "";
	private String mng_nm2		= "";
	//추가
	private String r_site_zip	= "";
	private String r_site_addr	= "";
	private String driving_ext	= "";
	private String driving_age 	= "";
	private String loan_ext		= "";
	private String others		= "";
	private int	car_ja			= 0;
	private String mng_id2		= "";
	private String bus_id2		= "";
	private String dept_id		= "";
	private String scan_file	= "";
	private String car_gu		= "";
	//수정시
	private String rent_way		= "";
	private String con_mon		= "";
	private String rent_end_dt	= "";
	private String update_id	= "";
	private String update_dt	= "";
	private String car_no		= "";
	//보험가입금액
	private String gcp_kd		= "";	//대물배상
	private String bacdt_kd		= "";	//자기신체사고
	//20050826
	private String spr_kd		= "";	//업체신용구분
	//20051013
	private String tax_agnt		= "";	//우편물수취인
	private String tax_type		= "";	//공급받는자
	//20061222
	private String sanction_id	= "";	//결재자
	private String sanction_date= "";	//결재일
	private String sanction		= "";	//결재내용||요청일
	private String sanction_req	= "";	//결재요청자
	//20070420
	private String fine_mm		= "";	//과태료청구메모
	
	//20070704
	private String call_st		= "";	// call 대상 여부
	//20071108
	private String bus_id3		= "";	// (인정)최초계약자
	private String ext_st		= "";    
	//20120622
	private String reg_step		= "";	//입력단계	
	//20170517
	private String agent_emp_id	= "";	//에이전트 계약진행담당자
	private String sanction_type = "";	//결재요청문서분류
	private String lic_no = "";
	//20181212
	private String mgr_lic_no = "";
	private String mgr_lic_emp = "";
	private String mgr_lic_rel = "";
	//20190626
	private String reject_car = "";
	
	private String agent_users	= "";	//에이전트연동
	//20210916
	private String test_lic_emp = "";
	private String test_lic_rel = "";
	private String test_lic_result = "";
	private String test_lic_emp2 = "";
	private String test_lic_rel2 = "";
	private String test_lic_result2 = "";
		
	public void setRent_mng_id(String str)		{	rent_mng_id		= str;}
	public void setRent_l_cd(String str)		{	rent_l_cd		= str;}
	public void setClient_id(String str)		{	client_id		= str;}
	public void setCar_mng_id(String str)		{	car_mng_id		= str;}
	public void setRent_st(String str)			{	rent_st			= str;}
	public void setBus_st(String str)			{	bus_st			= str;}
	public void setRent_dt(String str)			{	rent_dt			= str;}
	public void setDlv_dt(String str)			{	dlv_dt			= str;}
	public void setRent_start_dt(String str)	{	rent_start_dt	= str;}
	public void setNote(String str)				{	note			= str;}
	public void setBrch_id(String str)			{	brch_id			= str;}
	public void setBus_id(String str)			{	bus_id			= str;}
	public void setMng_id(String str)			{	mng_id			= str;}
	public void setReg_id(String str)			{	reg_id			= str;}
	public void setReg_dt(String str)			{	reg_dt			= str;}
	public void setCar_st(String str)			{	car_st			= str;}
	public void setR_site(String str)			{	r_site			= str;}
	public void setP_zip(String str)			{	p_zip			= str;}
	public void setP_addr(String str)			{	p_addr			= str;}
	public void setO_map(String str)			{	o_map			= str;}
	public void setUse_yn(String str)			{	use_yn			= str;}
	public void setR_site_zip(String str)		{ 	r_site_zip		= str;}
	public void setR_site_addr(String str)		{ 	r_site_addr		= str;}
	public void setDriving_ext(String str)		{ 	driving_ext		= str;}
	public void setDriving_age(String str)		{ 	driving_age		= str;}
	public void setLoan_ext(String str)			{ 	loan_ext		= str;}
	public void setOthers(String str)			{ 	others			= str;}
	public void setCar_ja(int i)				{ 	car_ja			= i;  }
	public void setRent_way(String str)			{	rent_way		= str;}
	public void setCon_mon(String str)			{	con_mon			= str;}
	public void setRent_end_dt(String str)		{	rent_end_dt		= str;}
	public void setMng_id2(String str)			{	mng_id2			= str;}
	public void setBus_id2(String str)			{	bus_id2			= str;}
	public void setDept_id(String str)			{	dept_id			= str;}
	public void setScan_file(String str)		{	scan_file		= str;}
	public void setCar_gu(String str)			{	car_gu			= str;}
	public void setBus_nm(String str)			{	bus_nm			= str;}
	public void setMng_nm(String str)			{	mng_nm			= str;}
	public void setMng_nm2(String str)			{	mng_nm2			= str;}
	public void setUpdate_id(String str)		{	update_id		= str;}
	public void setUpdate_dt(String str)		{	update_dt		= str;}	
	public void setCar_no(String str)			{	car_no			= str;}	
	public void setGcp_kd	(String str)		{	gcp_kd			= str;}
	public void setBacdt_kd	(String str)		{	bacdt_kd		= str;}
	public void setSpr_kd	(String str)		{	spr_kd			= str;}
	public void setTax_agnt	(String str)		{	tax_agnt		= str;}
	public void setTax_type	(String str)		{	tax_type		= str;}
	public void setSanction_id(String str)		{	sanction_id		= str;}
	public void setSanction_date(String str)	{	sanction_date	= str;}
	public void setSanction(String str)			{	sanction		= str;}
	public void setSanction_req(String str)		{	sanction_req	= str;}
	public void setFine_mm(String str)			{	fine_mm			= str;}
	public void setCall_st(String str)			{	call_st			= str;}
	public void setBus_id3(String str)			{	bus_id3			= str;}
	public void setExt_st(String str)			{	ext_st			= str;}
	public void setReg_step(String str)			{	reg_step		= str;}
	public void setAgent_emp_id	(String str)	{	agent_emp_id	= str;}
	public void setSanction_type(String str)	{	sanction_type	= str;}
	public void setLic_no(String str)			{	lic_no			= str;}
	public void setMgr_lic_no (String str)		{	mgr_lic_no		= str;}
	public void setMgr_lic_emp(String str)		{	mgr_lic_emp		= str;}
	public void setMgr_lic_rel(String str)		{	mgr_lic_rel		= str;}
	public void setReject_car(String str)		{	reject_car		= str;}
	public void setAgent_users	(String str)	{	agent_users		= str;}
	public void setTest_lic_emp(String str)		{	test_lic_emp	= str;}
	public void setTest_lic_rel(String str)		{	test_lic_rel	= str;}
	public void setTest_lic_result(String str)	{	test_lic_result	= str;}
	public void setTest_lic_emp2(String str)	{	test_lic_emp2	= str;}
	public void setTest_lic_rel2(String str)	{	test_lic_rel2	= str;}
	public void setTest_lic_result2(String str)	{	test_lic_result2= str;}
	
	
		
	public String getRent_mng_id()	  	{ 	return rent_mng_id;		}
	public String getRent_l_cd()	  	{ 	return rent_l_cd;		}
	public String getClient_id()	 	{ 	return client_id;		}
	public String getCar_mng_id()	  	{ 	return car_mng_id;		}
	public String getRent_st()        	{ 	return rent_st;			}
	public String getBus_st()	      	{ 	return bus_st;			}
	public String getRent_dt()	     	{ 	return rent_dt;			}
	public String getDlv_dt()	     	{ 	return dlv_dt;			}
	public String getRent_start_dt()  	{ 	return rent_start_dt;	}
	public String getNote()	         	{ 	return note;			}
	public String getBrch_id()		 	{	return brch_id;			}
	public String getBus_id()		 	{	return bus_id;			}
	public String getMng_id()		  	{	return mng_id;			}
	public String getReg_id()			{	return reg_id;			}
	public String getReg_dt()	      	{ 	return reg_dt;			}
	public String getCar_st()	      	{ 	return car_st;			}
	public String getR_site()			{	return r_site;			}
	public String getP_zip()			{	return p_zip;			}
	public String getP_addr()			{	return p_addr;			}
	public String getO_map()			{	return o_map;			}	
	public String getUse_yn()			{	return use_yn;			}	
	public String getR_site_zip()		{	return r_site_zip;		}	
	public String getR_site_addr()		{	return r_site_addr;		}	
	public String getDriving_ext()		{	return driving_ext;		}	
	public String getDriving_age()		{	return driving_age;		}	
	public String getLoan_ext()			{	return loan_ext;		}	
	public String getOthers()			{	return others;			}	
	public int getCar_ja()				{	return car_ja;			}	
	public String getRent_way()  		{	return rent_way;		}
	public String getCon_mon()  		{	return con_mon;			}
	public String getRent_end_dt()		{	return rent_end_dt;		}
	public String getMng_id2()		  	{	return mng_id2;			}
	public String getBus_id2()		  	{	return bus_id2;			}
	public String getDept_id()		  	{	return dept_id;			}
	public String getScan_file()		{	return scan_file;		}
	public String getCar_gu()			{	return car_gu;			}
	public String getBus_nm()			{	return bus_nm;			}
	public String getMng_nm()			{	return mng_nm;			}
	public String getMng_nm2()			{	return mng_nm2;			}
	public String getUpdate_id()		{	return update_id;		}
	public String getUpdate_dt()		{	return update_dt;		}
	public String getCar_no()			{	return car_no;			}
	public String getGcp_kd()			{	return gcp_kd;			}
	public String getBacdt_kd()			{	return bacdt_kd;		}
	public String getSpr_kd()			{	return spr_kd;			}
	public String getTax_agnt()			{	return tax_agnt;		}
	public String getTax_type()			{	return tax_type;		}
	public String getSanction_id()		{	return sanction_id;		}
	public String getSanction_date()	{	return sanction_date;	}
	public String getSanction()			{	return sanction;		}
	public String getSanction_req()		{	return sanction_req;	}
	public String getFine_mm()			{	return fine_mm;			}
	public String getCall_st()			{	return call_st;			}
	public String getBus_id3()		  	{	return bus_id3;			}
	public String getExt_st()		  	{	return ext_st;			}
	public String getReg_step()		  	{	return reg_step;		}
	public String getAgent_emp_id()		{	return agent_emp_id;	}
	public String getSanction_type()	{	return sanction_type;	}
	public String getLic_no()			{	return lic_no;			}
	public String getMgr_lic_no ()		{	return mgr_lic_no;		}
	public String getMgr_lic_emp()		{	return mgr_lic_emp;		}
	public String getMgr_lic_rel()		{	return mgr_lic_rel;		}
	public String getReject_car()		{	return reject_car;		}
	public String getAgent_users()		{	return agent_users;		}
	public String getTest_lic_emp()		{	return test_lic_emp;	}
	public String getTest_lic_rel()		{	return test_lic_rel;	}
	public String getTest_lic_result()	{	return test_lic_result;	}	
	public String getTest_lic_emp2()	{	return test_lic_emp2;	}
	public String getTest_lic_rel2()	{	return test_lic_rel2;	}
	public String getTest_lic_result2()	{	return test_lic_result2;}
	
}
