/**
 * 오프리스 매각 기타

 */
package acar.offls_actn;

import java.util.*;

public class Offls_car_purBean {
	//Table : SUI_ETC
	private String car_mng_id;	//자동차관리번호
	private String seq;	      //순번
	private String rent_mng_id;	 //자체출고 계약
	private String rent_l_cd;	 //
	private String rpt_no;	 //계출번호
	private String car_no;	 //차량번호
	private String dlv_dt;	 //출고일
	private String ip_dt;	 //입금
	private String end_st;	 // 완료여부
	private String reg_dt;	 //등록일
	private String car_off_nm;	 //자동차회사 출고점명
	private String emp_id;	 //영업사원코드
	private String emp_nm;	 //영업사원명
	
	public Offls_car_purBean(){
		this.car_mng_id = "";
		this.seq = "";
		this.rent_mng_id = "";	
		this.rent_l_cd = "";
		this.rpt_no = "";
		this.car_no = "";
		this.dlv_dt = "";
		this.ip_dt = "";	
		this.end_st = "";	
		this.reg_dt = "";
		this.car_off_nm = "";	
		this.emp_id = "";	
		this.emp_nm = "";
	}

	//set
	public void setCar_mng_id(String val){if(val==null) val="";	this.car_mng_id = val;}
	public void setSeq(String val){ if(val==null) val=""; this.seq = val; }
	public void setRent_mng_id(String val){ if(val==null) val=""; this.rent_mng_id = val; }
	public void setRent_l_cd(String val){ if(val==null) val=""; this.rent_l_cd = val; }
	public void setRpt_no(String val){ if(val==null) val=""; this.rpt_no = val; }
	public void setCar_no(String val){ if(val==null) val=""; this.car_no = val; }
	public void setDlv_dt(String val){ if(val==null) val=""; this.dlv_dt = val; }
	public void setIp_dt(String val){ if(val==null) val=""; this.ip_dt = val; }	
	public void setEnd_st(String val){ if(val==null) val=""; this.end_st = val; }
	public void setReg_dt(String val){ if(val==null) val=""; this.reg_dt = val; }	
	public void setCar_off_nm(String val){ if(val==null) val=""; this.car_off_nm = val; }	
	public void setEmp_id(String val){ if(val==null) val=""; this.emp_id = val; }
	public void setEmp_nm(String val){ if(val==null) val=""; this.emp_nm = val; }	
	
	//get
	public String getCar_mng_id(){ return car_mng_id; }
	public String getSeq(){ return seq; }
	public String getRent_mng_id(){ return rent_mng_id; }
	public String getRent_l_cd(){ return rent_l_cd; }
	public String getRpt_no(){ return rpt_no; }
	public String getCar_no(){ return car_no; }
	public String getDlv_dt(){ return dlv_dt; }	
	public String getIp_dt(){ return ip_dt; }
	public String getEnd_st(){ return end_st; }	
	public String getReg_dt(){ return reg_dt; }
	public String getCar_off_nm(){ return car_off_nm; }
	public String getEmp_id(){ return emp_id; }	
	public String getEmp_nm(){ return emp_nm; }
				
}