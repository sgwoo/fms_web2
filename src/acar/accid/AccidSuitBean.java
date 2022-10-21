/**
 * 소송기록
 * @ 
 */
    
package acar.accid;

import java.util.*;

public class AccidSuitBean {
    //Table : OT_ACCID
	private String car_mng_id; 					
	private String accid_id;	
	private String suit_type;
	private String suit_dt;
	private String suit_no;
	private int our_fault_per;
	private int j_fault_per;  //정비비결재관련 과실률(사고유형무시)
	private int    req_amt;	    // 청구금액
	private String req_dt;		// 청구일자
	private int    pay_amt;	    // 입금액
	private String pay_dt;		// 입금일자
	private String suit_st;		//진행사항  
	private String suit_rem;	//특이사항  
	private String reg_dt;     //
	private String reg_id;
	private String update_dt;
	private String update_id;
	private String req_id;  //요청자 
	private String req_rem;  //요청 특이사항 
	private String mean_dt;
	private String doc_dt;
	private int suit_amt;
	private int loan_amt;
	
    // CONSTRCTOR            
    public AccidSuitBean() {  
		this.car_mng_id = ""; 					//자동차관리번호
		this.accid_id = "";		
		this.suit_type = "";		
		this.suit_dt = "";		
		this.suit_no = "";		
		this.our_fault_per = 0;
		this.j_fault_per = 0;
		this.req_amt	= 0;
		this.req_dt	= "";
		this.pay_amt	= 0;
		this.pay_dt	= "";		
		this.suit_st = "";
		this.suit_rem = "";		
		this.reg_dt = "";
		this.reg_id = "";
		this.update_dt = "";
		this.update_id = "";	
		this.req_id = "";	
		this.req_rem = "";	
		this.doc_dt = "";	
		this.mean_dt = "";	
		this.suit_amt = 0;	
		this.loan_amt = 0;	
	}

	// get Method
	public void setCar_mng_id(String val){		if(val==null) val="";		this.car_mng_id = val;	}
	public void setAccid_id(String val){		if(val==null) val="";		this.accid_id = val;	}	
	public void setSuit_type(String val){		if(val==null) val="";		this.suit_type = val;	}
	public void setSuit_dt(String val){		if(val==null) val="";		this.suit_dt = val;	}
	public void setSuit_no(String val){			if(val==null) val="";		this.suit_no = val;		}	
	public void setOur_fault_per(int val){									this.our_fault_per = val;}
	public void setJ_fault_per(int val){									this.j_fault_per = val;}
	public void setReq_amt	(int val)	{									this.req_amt	= val;	}
	public void setReq_dt	(String val){	if(val==null) val="";			this.req_dt	= val;	}
	public void setPay_amt	(int val)	{									this.pay_amt	= val;	}
	public void setPay_dt	(String val){	if(val==null) val="";			this.pay_dt	= val;	}	
	
	public void setSuit_st(String val){			if(val==null) val="";		this.suit_st = val;		}
	public void setSuit_rem(String val){		if(val==null) val="";		this.suit_rem = val;	}
	public void setReg_dt(String val){			if(val==null) val="";		this.reg_dt = val;		}	
	public void setReg_id(String val){			if(val==null) val="";		this.reg_id = val;		}	
	public void setUpdate_dt(String val){		if(val==null) val="";		this.update_dt = val;	}	
	public void setUpdate_id(String val){		if(val==null) val="";		this.update_id = val;	}	
	public void setReq_id(String val){			if(val==null) val="";		this.req_id = val;	}	
	public void setReq_rem(String val){			if(val==null) val="";		this.req_rem = val;	}	
	public void setMean_dt(String val){			if(val==null) val="";		this.mean_dt = val;	}	
	public void setDoc_dt(String val){			if(val==null) val="";		this.doc_dt = val;	}
	public void setSuit_amt	(int val)	{									this.suit_amt	= val;	}
	public void setLoan_amt	(int val)	{									this.loan_amt	= val;	}
	
	//Get Method
	public String getCar_mng_id(){		return car_mng_id;	}
	public String getAccid_id(){		return accid_id;	}	
	public String getSuit_type(){		return suit_type;	}
	public String getSuit_dt(){		return suit_dt;	}
	public String getSuit_no(){		return suit_no;	}	
	public int getOur_fault_per(){		return our_fault_per;}
	public int getJ_fault_per(){		return j_fault_per;}
	public int    getReq_amt	(){		return req_amt;	}
	public String getReq_dt	(){		return req_dt;		}	
	public int    getPay_amt	(){		return pay_amt;	}
	public String getPay_dt	(){		return pay_dt;		}
	public String getSuit_st		(){		return suit_st;			}	
	public String getSuit_rem		(){		return suit_rem;		}	
	public String getReg_dt(){			return reg_dt;		}	
	public String getReg_id(){			return reg_id;		}	
	public String getUpdate_dt(){		return update_dt;	}	
	public String getUpdate_id(){		return update_id;	}		
	public String getReq_id(){			return req_id;	}
	public String getReq_rem(){			return req_rem;	}
	public String getDoc_dt(){			return doc_dt;	}
	public String getMean_dt(){			return mean_dt;	}
	public int    getSuit_amt	(){		return suit_amt;	}
	public int    getLoan_amt	(){		return loan_amt;	}

}
