/**
 * 재리스
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2004. 12. 13. 월.
 * @ last modify date : 
 */
package acar.secondhand;

import java.util.*;

public class ShResBean{
	//Table : sh_res	재리스차량예약
	private String car_mng_id;	//자동차관리번호
	private String seq;			//순번
	private String damdang_id;
	private String situation;
	private String memo;
	private String reg_dt;
	private String res_end_dt;
	private String cust_nm;
	private String cust_tel;
	private int    add_cnt;
	private String res_st_dt;
	private String use_yn;
	private String est_id;
	private String reg_code;
	private int    add_cnt_s;

	public ShResBean(){
		this.car_mng_id = "";
		this.seq		= "";
		this.damdang_id = "";
		this.situation	= "";
		this.memo		= "";
		this.reg_dt		= "";
		this.res_end_dt	= "";
		this.cust_nm	= "";
		this.cust_tel	= "";
		this.add_cnt	= 0;
		this.res_st_dt	= "";
		this.use_yn		= "";
		this.est_id		= "";
		this.reg_code	= "";
		this.add_cnt_s	= 0;
	}

	//set
	public void setCar_mng_id	(String val){	if(val==null) val="";	this.car_mng_id	= val;	}
	public void setSeq			(String val){	if(val==null) val="";	this.seq		= val;	}
	public void setDamdang_id	(String val){	if(val==null) val="";	this.damdang_id	= val;	}
	public void setSituation	(String val){	if(val==null) val="";	this.situation	= val;	}
	public void setMemo			(String val){	if(val==null) val="";	this.memo		= val;	}
	public void setReg_dt		(String val){	if(val==null) val="";	this.reg_dt		= val;	}
	public void setRes_end_dt	(String val){	if(val==null) val="";	this.res_end_dt	= val;	}
	public void setCust_nm		(String val){	if(val==null) val="";	this.cust_nm	= val;	}
	public void setCust_tel		(String val){	if(val==null) val="";	this.cust_tel	= val;	}
	public void setAdd_cnt		(int val)   {							this.add_cnt	= val;	}
	public void setRes_st_dt	(String val){	if(val==null) val="";	this.res_st_dt	= val;	}
	public void setUse_yn		(String val){	if(val==null) val="";	this.use_yn		= val;	}
	public void setEst_id		(String val){	if(val==null) val="";	this.est_id		= val;	}
	public void setReg_code		(String val){	if(val==null) val="";	this.reg_code	= val;	}
	public void setAdd_cnt_s	(int val)   {							this.add_cnt_s	= val;	}

	//get
	public String getCar_mng_id	(){	return car_mng_id;	}
	public String getSeq		(){	return seq;			}
	public String getDamdang_id	(){	return damdang_id;	}
	public String getSituation	(){	return situation;	}
	public String getMemo		(){	return memo;		}
	public String getReg_dt		(){	return reg_dt;		}
	public String getRes_end_dt	(){	return res_end_dt;	}
	public String getCust_nm	(){	return cust_nm;		}
	public String getCust_tel	(){	return cust_tel;	}
	public int    getAdd_cnt	(){	return add_cnt;		}
	public String getRes_st_dt	(){	return res_st_dt;	}
	public String getUse_yn		(){	return use_yn;		}
	public String getEst_id		(){	return est_id;		}
	public String getReg_code	(){	return reg_code;	}
	public int    getAdd_cnt_s	(){	return add_cnt_s;	}

}