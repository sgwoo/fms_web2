/* 소송/추심비용, 입금/지급수수료관리*/
package acar.receive;

import java.util.*;

public class Rece_ioamtBean {
    //Table : RECE_IOAMT
	private String rent_l_cd;
	private int seq_no;
	private String rent_mng_id;
	private String car_mng_id; 					//자동차관리번호
	private String ioamt_st;
	private String amt_gubun;
	private int	amt;
	private String amt_dt;
	private String amt_off;
	private String note;
	private String reg_dt;
	private String reg_id;
	private String update_dt; 
	private String update_id;
	private String iamt_gubun;
	private int	iamt;
	private String	iamt_dt;
	private int	inmg_amt;
	private String oamt_gubun;
	private int	oamt;
	private String oamt_dt;
	private String ioamt_off;
	
        
    // CONSTRCTOR            
    public Rece_ioamtBean() {  
	this. rent_l_cd = "";
	this. seq_no = 0;
	this. rent_mng_id = "";
	this. car_mng_id = "";
	this. ioamt_st = "";
	this. amt_gubun = "";
	this.	amt = 0;
	this. amt_dt = "";
	this. amt_off = "";
	this. note = "";
	this. reg_dt = "";
	this. reg_id = "";
	this. update_dt = ""; 
	this. update_id = "";
	this. iamt_gubun = "";
	this.	iamt = 0;
	this.	iamt_dt = "";
	this.	inmg_amt = 0;
	this. oamt_gubun = "";
	this.	oamt = 0;
	this. oamt_dt = "";
	this. ioamt_off = "";
	}

	// get Method
	public void setRent_l_cd(String val){		if(val==null) val="";	this.rent_l_cd = val;	}
	public void setSeq_no(int val){		this.seq_no = val;	}
	public void setRent_mng_id(String val){		if(val==null) val="";	this.rent_mng_id = val;	}
	public void setCar_mng_id(String val){		if(val==null) val="";	this.car_mng_id = val;	}
	public void setIoamt_st(String val){		if(val==null) val="";	this.ioamt_st = val;	}
	public void setAmt_gubun(String val){		if(val==null) val="";	this.amt_gubun = val;	}
	public void setAmt(int val){		this.amt = val;	}
	public void setAmt_dt(String val){		if(val==null) val="";	this.amt_dt = val;	}
	public void setAmt_off(String val){		if(val==null) val="";	this.amt_off = val;	}
	public void setNote(String val){		if(val==null) val="";	this.note = val;	}
	public void setReg_dt(String val){		if(val==null) val="";	this.reg_dt = val;	}
	public void setReg_id(String val){		if(val==null) val="";	this.reg_id = val;	}
	public void setUpdate_dt(String val){		if(val==null) val="";	this.update_dt = val;	}
	public void setUpdate_id(String val){		if(val==null) val="";	this.update_id = val;	}
	public void setIamt_gubun(String val){		if(val==null) val="";	this.iamt_gubun = val;	}
	public void setIamt(int val){		this.iamt = val;	}
	public void setIamt_dt(String val){		if(val==null) val="";	this.iamt_dt = val;	}
	public void setInmg_amt(int val){	this.inmg_amt = val;	}
	public void setOamt_gubun(String val){		if(val==null) val="";	this.oamt_gubun = val;	}
	public void setOamt(int val){		this.oamt = val;	}
	public void setOamt_dt(String val){		if(val==null) val="";	this.oamt_dt = val;	}
	public void setIoamt_off(String val){		if(val==null) val="";	this.ioamt_off = val;	}

	

		
	//Get Method
	public String getRent_l_cd(){		return rent_l_cd;	}
	public int getSeq_no(){		return seq_no;		}
	public String getRent_mng_id(){		return rent_mng_id;	}
	public String getCar_mng_id(){		return car_mng_id;	}
	public String getIoamt_st(){		return ioamt_st;	}
	public String getAmt_gubun(){		return amt_gubun;	}
	public int getAmt(){		return amt;		}
	public String getAmt_dt(){		return amt_dt;	}
	public String getAmt_off(){		return amt_off;	}
	public String getNote(){		return note;	}
	public String getReg_dt(){		return reg_dt;	}
	public String getReg_id(){		return reg_id;	}
	public String getUpdate_dt(){		return update_dt;	}
	public String getUpdate_id(){		return update_id;	}
	public String getIamt_gubun(){		return iamt_gubun;	}
	public int getIamt(){		return iamt;		}
	public String getIamt_dt(){		return iamt_dt;	}
	public int getInmg_amt(){	return inmg_amt;	}
	public String getOamt_gubun(){		return oamt_gubun;	}
	public int getOamt(){		return oamt;		}
	public String getOamt_dt(){		return oamt_dt;	}
	public String getIoamt_off(){		return ioamt_off;	}


	
}