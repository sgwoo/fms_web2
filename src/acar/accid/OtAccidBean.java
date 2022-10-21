/**
 * 사고기록
 * @ create date : 2004. 07. 15
 */
package acar.accid;

import java.util.*;

public class OtAccidBean {
    //Table : OT_ACCID
	private String car_mng_id; 					
	private String accid_id;
	private int seq_no;
	private String ot_car_no;
	private String ot_car_nm;
	private String ot_driver;
	private String ot_tel;
	private String ot_m_tel;
	private String ot_ins;
	private String ot_num;
	private String ot_ins_nm;
	private String ot_ins_tel;
	private String ot_ins_m_tel;
	private String ot_ssn;
	private String ot_lic_kd;
	private String ot_lic_no;
	private String ot_tel2;
	private String ot_dam_st;
	private int ot_fault_per;
	private String hum_nm;
	private String hum_tel;
	private String hum_m_tel;
	private String mat_nm;
	private String mat_tel;
	private String mat_m_tel;
	private String serv_dt;
	private String off_nm;
	private String off_tel;
	private String off_fax;
	private int serv_amt;
	private String serv_cont;
	private String serv_nm;
	private String reg_dt;
	private String reg_id;
	private String update_dt;
	private String update_id;
	private int    amor_pay_amt;	//경락손해 입금액
	private String amor_pay_dt;		//경락손해 입금일자
	private int    amor_req_amt;	//경락손해 청구금액
	private String amor_req_dt;		//경락손해 청구일자
	private String amor_st;			//경락손해 청구여부
	private String amor_req_id;		//경락손해 청구자
	private String amor_type;		//경락손해 구분

    // CONSTRCTOR            
    public OtAccidBean() {  
		this.car_mng_id = ""; 					//자동차관리번호
		this.accid_id = "";
		this.seq_no = 0;
		this.ot_car_no = "";
		this.ot_car_nm = "";
		this.ot_driver = "";
		this.ot_tel = "";
		this.ot_m_tel = "";
		this.ot_ins = "";
		this.ot_num = "";
		this.ot_ins_nm = "";
		this.ot_ins_tel = "";
		this.ot_ins_m_tel = "";
		this.ot_ssn = "";
		this.ot_lic_kd = "";
		this.ot_lic_no = "";
		this.ot_tel2 = "";
		this.ot_dam_st = "";
		this.ot_fault_per = 0;
		this.hum_nm = "";
		this.hum_tel = "";
		this.hum_m_tel = "";
		this.mat_nm = "";
		this.mat_tel = "";
		this.mat_m_tel = "";
		this.serv_dt = "";
		this.off_nm = "";
		this.off_tel = "";
		this.off_fax = "";
		this.serv_amt = 0;
		this.serv_cont = "";
		this.serv_nm = "";
		this.reg_dt = "";
		this.reg_id = "";
		this.update_dt = "";
		this.update_id = "";
		this.amor_pay_amt	= 0;
		this.amor_pay_dt	= "";
		this.amor_req_amt	= 0;
		this.amor_req_dt	= "";
		this.amor_st		= "";
		this.amor_req_id	= "";
		this.amor_type		= "";
	}


	// get Method
	public void setCar_mng_id(String val){		if(val==null) val="";		this.car_mng_id = val;	}
	public void setAccid_id(String val){		if(val==null) val="";		this.accid_id = val;	}
	public void setSeq_no(int val){											this.seq_no = val;		}
	public void setOt_car_no(String val){		if(val==null) val="";		this.ot_car_no = val;	}
	public void setOt_car_nm(String val){		if(val==null) val="";		this.ot_car_nm = val;	}
	public void setOt_driver(String val){		if(val==null) val="";		this.ot_driver = val;	}
	public void setOt_tel(String val){			if(val==null) val="";		this.ot_tel = val;		}
	public void setOt_m_tel(String val){		if(val==null) val="";		this.ot_m_tel = val;	}
	public void setOt_ins(String val){			if(val==null) val="";		this.ot_ins = val;		}
	public void setOt_num(String val){			if(val==null) val="";		this.ot_num = val;		}	
	public void setOt_ins_nm(String val){		if(val==null) val="";		this.ot_ins_nm = val;	}
	public void setOt_ins_tel(String val){		if(val==null) val="";		this.ot_ins_tel = val;	}
	public void setOt_ins_m_tel(String val){	if(val==null) val="";		this.ot_ins_m_tel = val;}
	public void setOt_ssn(String val){			if(val==null) val="";		this.ot_ssn = val;		}	
	public void setOt_lic_kd(String val){		if(val==null) val="";		this.ot_lic_kd = val;	}	
	public void setOt_lic_no(String val){		if(val==null) val="";		this.ot_lic_no = val;	}	
	public void setOt_tel2(String val){			if(val==null) val="";		this.ot_tel2 = val;		}	
	public void setOt_dam_st(String val){		if(val==null) val="";		this.ot_dam_st = val;	}	
	public void setOt_fault_per(int val){									this.ot_fault_per = val;}
	public void setHum_nm(String val){			if(val==null) val="";		this.hum_nm = val;		}
	public void setHum_tel(String val){			if(val==null) val="";		this.hum_tel = val;		}
	public void setHum_m_tel(String val){		if(val==null) val="";		this.hum_m_tel = val;	}
	public void setMat_nm(String val){			if(val==null) val="";		this.mat_nm = val;		}
	public void setMat_tel(String val){			if(val==null) val="";		this.mat_tel = val;		}
	public void setMat_m_tel(String val){		if(val==null) val="";		this.mat_m_tel = val;	}
	public void setServ_dt(String val){			if(val==null) val="";		this.serv_dt = val;		}
	public void setOff_nm(String val){			if(val==null) val="";		this.off_nm = val;		}
	public void setOff_tel(String val){			if(val==null) val="";		this.off_tel = val;		}
	public void setOff_fax(String val){			if(val==null) val="";		this.off_fax = val;		}
	public void setServ_amt(int val){										this.serv_amt = val;	}
	public void setServ_cont(String val){		if(val==null) val="";		this.serv_cont = val;	}
	public void setServ_nm(String val){			if(val==null) val="";		this.serv_nm = val;		}
	public void setReg_dt(String val){			if(val==null) val="";		this.reg_dt = val;		}	
	public void setReg_id(String val){			if(val==null) val="";		this.reg_id = val;		}	
	public void setUpdate_dt(String val){		if(val==null) val="";		this.update_dt = val;	}	
	public void setUpdate_id(String val){		if(val==null) val="";		this.update_id = val;	}	
	public void setAmor_pay_amt	(int val)	{								this.amor_pay_amt	= val;	}
	public void setAmor_pay_dt	(String val){	if(val==null) val="";		this.amor_pay_dt	= val;	}	
	public void setAmor_req_amt	(int val)	{								this.amor_req_amt	= val;	}
	public void setAmor_req_dt	(String val){	if(val==null) val="";		this.amor_req_dt	= val;	}	
	public void setAmor_st		(String val){	if(val==null) val="";		this.amor_st		= val;	}	
	public void setAmor_req_id	(String val){	if(val==null) val="";		this.amor_req_id	= val;	}	
	public void setAmor_type	(String val){	if(val==null) val="";		this.amor_type		= val;	}	


	//Get Method
	public String getCar_mng_id(){		return car_mng_id;	}
	public String getAccid_id(){		return accid_id;	}
	public int getSeq_no(){				return seq_no;		}
	public String getOt_car_no(){		return ot_car_no;	}
	public String getOt_car_nm(){		return ot_car_nm;	}
	public String getOt_driver(){		return ot_driver;	}
	public String getOt_tel(){			return ot_tel;		}
	public String getOt_m_tel(){		return ot_m_tel;	}
	public String getOt_ins(){			return ot_ins;		}
	public String getOt_num(){			return ot_num;		}
	public String getOt_ins_nm(){		return ot_ins_nm;	}
	public String getOt_ins_tel(){		return ot_ins_tel;	}
	public String getOt_ins_m_tel(){	return ot_ins_m_tel;}
	public String getOt_ssn(){			return ot_ssn;		}	
	public String getOt_lic_kd(){		return ot_lic_kd;	}	
	public String getOt_lic_no(){		return ot_lic_no;	}	
	public String getOt_tel2(){			return ot_tel2;		}	
	public String getOt_dam_st(){		return ot_dam_st;	}	
	public int getOt_fault_per(){		return ot_fault_per;}
	public String getHum_nm(){			return hum_nm;		}
	public String getHum_tel(){			return hum_tel;		}
	public String getHum_m_tel(){		return hum_m_tel;	}
	public String getMat_nm(){			return mat_nm;		}
	public String getMat_tel(){			return mat_tel;		}
	public String getMat_m_tel(){		return mat_m_tel;	}
	public String getServ_dt(){			return serv_dt;		}
	public String getOff_nm(){			return off_nm;		}
	public String getOff_tel(){			return off_tel;		}
	public String getOff_fax(){			return off_fax;		}
	public int getServ_amt(){			return serv_amt;	}
	public String getServ_cont(){		return serv_cont;	}
	public String getServ_nm(){			return serv_nm;		}
	public String getReg_dt(){			return reg_dt;		}	
	public String getReg_id(){			return reg_id;		}	
	public String getUpdate_dt(){		return update_dt;	}	
	public String getUpdate_id(){		return update_id;	}	
	public int    getAmor_pay_amt	(){		return amor_pay_amt;	}
	public String getAmor_pay_dt	(){		return amor_pay_dt;		}	
	public int    getAmor_req_amt	(){		return amor_req_amt;	}
	public String getAmor_req_dt	(){		return amor_req_dt;		}	
	public String getAmor_st		(){		return amor_st;			}	
	public String getAmor_req_id	(){		return amor_req_id;		}	
	public String getAmor_type		(){		return amor_type;		}	

}
