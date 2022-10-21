package acar.stat_inc;

import java.util.*;
import java.text.*;


public class StatIncScdBean {
    //Table : STAT_INC_VIEW
    private String st;
	private String gubun;
	private String pay_st;
    private String rent_mng_id;
    private String rent_l_cd;
	private String car_mng_id;
	private String client_id;
	private String rent_st;
    private String firm_nm;
	private String client_nm;
	private String car_no;
	private String car_nm;
	private String brch_id;
    private String tm;				//회차
    private int s_amt;				//공급가
    private int v_amt;				//부가세
    private int amt;				//입금액
    private int pay_amt;
	private String i_est_dt;
    private String est_dt;
    private String pay_dt;
	private String seq_no;
    
    // CONSTRCTOR            
    public StatIncScdBean() {  
	    this.st = "";
	    this.gubun = "";
	    this.pay_st = "";
	    this.rent_mng_id = "";
	    this.rent_l_cd = "";
	    this.car_mng_id = "";
	    this.client_id = "";
	    this.rent_st = "";
	    this.firm_nm = "";
	    this.client_nm = "";
	    this.car_no = "";
	    this.car_nm = "";
	    this.brch_id = "";
	    this.tm = "";
	    this.s_amt = 0;
	    this.v_amt = 0;
	    this.amt = 0;
		this.pay_amt = 0;
	    this.i_est_dt = "";
	    this.est_dt = "";
	    this.pay_dt = "";
	    this.seq_no = "";
		}

	// get Method
	public void setSt(String val){			if(val==null) val="";	this.st = val;		}
    public void setGubun(String val){		if(val==null) val="";	this.gubun = val;		}
	public void setPay_st(String val){		if(val==null) val="";	this.pay_st = val;		}
    public void setRent_mng_id(String val){	if(val==null) val="";	this.rent_mng_id = val;	}
    public void setRent_l_cd(String val){	if(val==null) val="";	this.rent_l_cd = val;	}
    public void setCar_mng_id(String val){	if(val==null) val="";	this.car_mng_id = val;	}
    public void setClient_id(String val){	if(val==null) val="";	this.client_id = val;	}
	public void setRent_st(String val){		if(val==null) val="";	this.rent_st = val;		}
    public void setFirm_nm(String val){		if(val==null) val="";	this.firm_nm = val;		}
    public void setClient_nm(String val){	if(val==null) val="";	this.client_nm = val;	}
    public void setCar_no(String val){		if(val==null) val="";	this.car_no = val;		}
	public void setCar_nm(String val){		if(val==null) val="";	this.car_nm = val;		}
	public void setBrch_id(String val){		if(val==null) val="";	this.brch_id = val;		}
	public void setTm(String val){			if(val==null) val="";	this.tm = val;			}
	public void setS_amt(int val){									this.s_amt = val;		}
	public void setV_amt(int val){									this.v_amt = val;		}
    public void setAmt(int val){									this.amt = val;			}
    public void setPay_amt(int val){								this.pay_amt = val;		}
    public void setI_est_dt(String val){	if(val==null) val="";	this.i_est_dt = val;	}
    public void setEst_dt(String val){		if(val==null) val="";	this.est_dt = val;		}
	public void setPay_dt(String val){		if(val==null) val="";	this.pay_dt = val;		}
	public void setSeq_no(String val){		if(val==null) val="";	this.seq_no = val;		}
	
	//Get Method
	public String getSt(){			return st;			}
    public String getGubun(){		return gubun;		}
    public String getPay_st(){		return pay_st;		}
    public String getRent_mng_id(){	return rent_mng_id;	}
    public String getRent_l_cd(){	return rent_l_cd;	}
    public String getCar_mng_id(){	return car_mng_id;	}
    public String getClient_id(){	return client_id;	}
    public String getRent_st(){		return rent_st;		}
    public String getFirm_nm(){		return firm_nm;		}
    public String getClient_nm(){	return client_nm;	}
    public String getCar_no(){		return car_no;		}
	public String getCar_nm(){		return car_nm;		}
	public String getBrch_id(){		return brch_id;		}
	public String getTm(){			return tm;			}
	public int getS_amt(){			return s_amt;		}
	public int getV_amt(){			return v_amt;		}
	public int getAmt(){			return amt;			}
	public int getPay_amt(){		return pay_amt;		}
	public String getI_est_dt(){	return i_est_dt;	}
    public String getEst_dt(){		return est_dt;		}
	public String getPay_dt(){		return pay_dt;		}
	public String getSeq_no(){		return seq_no;		}

}