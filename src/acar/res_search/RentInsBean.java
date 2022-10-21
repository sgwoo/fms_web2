// 단기계약 보험대차 관리

// 작성일 : 2004.01.15 (정현미)

package acar.res_search;

public class RentInsBean
{
	private String rent_s_cd;		//단기계약관리번호
	private String ins_com_id;		//보험회사ID
	private String ins_num;			//접수번호
	private String ins_nm;			//담당자
	private String ins_tel;			//연락처1
	private String ins_tel2;		//연락처2
	private String ins_fax;			//팩스번호
	private String reg_id;			//등록자
	private String reg_dt;			//등록일
	private String update_id;		//수정자
	private String update_dt;		//수정일
	
	public RentInsBean()
	{
		rent_s_cd	= "";    
		ins_com_id = "";
		ins_num = "";
		ins_nm = "";
		ins_tel = "";
		ins_tel2 = "";
		ins_fax = "";
		reg_dt = "";    
		reg_id = "";    
		update_dt = "";    
		update_id = "";    
	}
	
	public void setRent_s_cd(String str) 	{ rent_s_cd		= str; }
	public void setIns_com_id(String str)	{ ins_com_id	= str; }    	
	public void setIns_num(String str)		{ ins_num		= str; }		
	public void setIns_nm(String str)		{ ins_nm		= str; }    
	public void setIns_tel(String str)		{ ins_tel		= str; }    
	public void setIns_tel2(String str)		{ ins_tel2		= str; }      
	public void setIns_fax(String str)		{ ins_fax		= str; }      
	public void setReg_dt(String str)		{ reg_dt		= str; }    
	public void setReg_id(String str)		{ reg_id		= str; }    
	public void setUpdate_dt(String str)	{ update_dt		= str; }    
	public void setUpdate_id(String str)	{ update_id		= str; }    

	public String getRent_s_cd() 	{ return rent_s_cd;		}
	public String getIns_com_id()	{ return ins_com_id;	}
	public String getIns_num()		{ return ins_num;		}
	public String getIns_nm()		{ return ins_nm;		}
	public String getIns_tel()		{ return ins_tel;		}
	public String getIns_tel2()		{ return ins_tel2;		}
	public String getIns_fax()		{ return ins_fax;		}
	public String getReg_dt()		{ return reg_dt;		}
	public String getReg_id()		{ return reg_id;		}
	public String getUpdate_dt()	{ return update_dt;		}
	public String getUpdate_id()	{ return update_id;		}

}