/**
 * 정기점검정비
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.receive;

import java.util.*;
import java.text.*;

public class ReceiveBean {
    //Table : CAR_CHA

	private String car_mng_id;			//자동차관리번호
	private String rent_mng_id;			//계약관리번호
	private String rent_l_cd;			//계약번호
	private String car_no;
	private String firm_nm;
	private String car_nm;
	private String car_name;
	private int    seq_no;				//SEQ_NO
	private String fine_st;				//과태료,범칙금 구분(3:고소고발, 4:소송)
	private String fine_st_nm;
	private String call_nm;				//통화자
	private String tel;					//전화번호
	private String fax;					//팩스
	private String vio_dt;				//위반일시
	private String vio_pla;				//위반장소
	private String vio_cont;			//위반내용
	private String pol_sta;				//경찰서	
	private String note;				//특이사항	
	private String reg_id;				//최초등록자
	private String reg_dt;				//최초등록일
	private String update_id;			//최종수정자
	private String update_dt;			//최종수정일
	private String gubun;
		
	private String rent_s_cd;			//단기계약번호
	private String notice_dt;			//사실확인(통지서)접수일자
	
	
    // CONSTRCTOR            
    public ReceiveBean() {  
	    this.car_mng_id		= "";		//자동차관리번호
		this.rent_mng_id	= "";		//계약관리번호
		this.rent_l_cd		= "";		//계약번호
		this.car_no			= "";
		this.firm_nm		= "";
		this.car_nm			= "";
		this.car_name		= "";
		this.seq_no			= 0;		//SEQ_NO
		this.fine_st		= "";
		this.fine_st_nm		= "";
		this.call_nm		= "";		//통화자
		this.tel			= "";		//전화번호
		this.fax			= "";		//팩스
		this.vio_dt			= "";		//위반일시	
		this.vio_pla		= "";		//위반장소
		this.vio_cont		= "";		//위반내용	
		this.pol_sta		= "";		//경찰서	
		this.note			= "";		//특이사항		
		this.reg_id			= "";
		this.reg_dt			= "";
		this.update_id		= "";
		this.update_dt		= "";
		this.gubun			= "";	
		this.rent_s_cd		= "";
		this.notice_dt		= "";
					
	}


	// get Method
	public void setCar_mng_id	(String val){		if(val==null) val="";		this.car_mng_id		= val;	}
	public void setRent_mng_id	(String val){		if(val==null) val="";		this.rent_mng_id	= val;	}
	public void setRent_l_cd	(String val){		if(val==null) val="";		this.rent_l_cd		= val;	}
	public void setCar_no		(String val){		if(val==null) val="";		this.car_no			= val;	}
	public void setFirm_nm		(String val){		if(val==null) val="";		this.firm_nm		= val;	}
	public void setCar_nm		(String val){		if(val==null) val="";		this.car_nm			= val;	}
	public void setCar_name		(String val){		if(val==null) val="";		this.car_name		= val;	}
	public void setSeq_no		(int val)   {									this.seq_no			= val;	}	
	public void setFine_st		(String val){		if(val==null) val="";		this.fine_st		= val;	}	
	public void setCall_nm		(String val){		if(val==null) val="";		this.call_nm		= val;	}	
	public void setTel			(String val){		if(val==null) val="";		this.tel			= val;	}
	public void setFax			(String val){		if(val==null) val="";		this.fax			= val;	}
	public void setVio_dt		(String val){		if(val==null) val="";		this.vio_dt			= val;	}
	public void setVio_pla		(String val){		if(val==null) val="";		this.vio_pla		= val;	}
	public void setVio_cont		(String val){		if(val==null) val="";		this.vio_cont		= val;	}	
	public void setPol_sta		(String val){		if(val==null) val="";		this.pol_sta		= val;	}	
	public void setNote			(String val){		if(val==null) val="";		this.note			= val;	}	
	public void setReg_id		(String val){		if(val==null) val="";		this.reg_id			= val;	}
	public void setReg_dt		(String val){		if(val==null) val="";		this.reg_dt			= val;	}
	public void setUpdate_id	(String val){		if(val==null) val="";		this.update_id		= val;	}
	public void setUpdate_dt	(String val){		if(val==null) val="";		this.update_dt		= val;	}
	public void setGubun		(String val){		if(val==null) val="";		this.gubun			= val;	}
	
	public void setRent_s_cd	(String str){		if(str==null) str="";		this.rent_s_cd		= str;	}
	public void setNotice_dt	(String str){		if(str==null) str="";		this.notice_dt		= str;	}
	
	//Get Method
	public String getCar_mng_id	()		{	return car_mng_id;	}
	public String getRent_mng_id()		{	return rent_mng_id;	}
	public String getCar_no		()		{	return car_no;		}
	public String getFirm_nm	()		{	return firm_nm;		}
	public String getCar_nm		()		{	return car_nm;		}
	public String getCar_name	()		{	return car_name;	}
	public String getRent_l_cd	()		{	return rent_l_cd;	}
	public int    getSeq_no		()		{	return seq_no;		}
	public String getFine_st	()		{	return fine_st;		}
	public String getCall_nm	()		{	return call_nm;		}
	public String getTel		()		{	return tel;			}
	public String getFax		()		{	return fax;			}
	public String getVio_dt		()		{	return vio_dt;		}	
	public String getVio_pla	()		{	return vio_pla;		}
	public String getVio_cont	()		{	return vio_cont;	}
	public String getPol_sta	()		{	return pol_sta;		}
	public String getNote		()		{	return note;		}	
	public String getReg_id		()		{	return reg_id;		}
	public String getReg_dt		()		{	return reg_dt;		}
	public String getUpdate_id	()		{	return update_id;	}
	public String getUpdate_dt	()		{	return update_dt;	}
	public String getGubun		()		{	return gubun;		}

	public String getRent_s_cd	()		{	return rent_s_cd;	}  
	public String getNotice_dt	()		{	return notice_dt;	}  
	
}
