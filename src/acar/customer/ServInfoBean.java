/**
 * 서비스
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.customer;

import java.util.*;

public class ServInfoBean {
    //Table : CAR_REG
    private String car_no;
	private String car_mng_id; 					//자동차관리번호
	private String serv_id; 
	private String accid_id; 
	private String rent_mng_id; 
	private String rent_l_cd; 
	private String off_id;
	private String off_nm; 
	private String serv_dt; 
	private String serv_st;
	private String serv_st_nm; 
	private String checker; 
	private String tot_dist; 
	private String rep_nm; 
	private String rep_tel; 
	private String rep_m_tel; 
	private int rep_amt; 
	private int sup_amt; 
	private int add_amt; 
	private int dc; 
	private int tot_amt; 
	private String sup_dt; 
	private String set_dt; 
	private String bank; 
	private String acc_no; 
	private String acc_nm; 
	private String rep_item; 
	private String rep_cont; 
	private String cust_plan_dt; 
	private int cust_amt; 
	private String cust_agnt;
	private String accid_dt;
	//추가
	private String off_tel;
	private String off_fax; 
	private String cust_req_dt;
	private String cust_pay_dt;
	private String reg_dt;
	private String reg_id;
	private String update_dt;
	private String update_id;
	private String scan_file;	
	private String no_dft_yn;
	private String no_dft_cau;
   	private String bill_doc_yn;		//거래명세서포함여부
	private String bill_mon;		//거래명세서포함월
	//
	private String serv_jc;
	private String cust_serv_dt;
	private String next_serv_dt;
	private String next_rep_cont;
	private String spd_chk;	//추가 2004.01.08.
	//
	private String ipgoza;
	private String ipgodt;
	private String chulgoza;
	private String chulgodt;
	private String spdchk_dt;	//추가 2004.07.20.
	//
	private String checker_st;	//추가 2004.08.02.
	private String cust_act_dt;	//추가 2004.10.12.
	private String cust_nm;
	private String cust_tel;
	private String cust_rel;
	
	private int r_labor;            //공임계(명진인 경우 도장을 공임에 포함)
	private int r_amt;  			//부품계
	private int r_dc;               //부품dc 금액
	private int r_j_amt;  			//부품dc 반영금액
	private String jung_st;
	private int r_dc_per;            //부품dc 율
        
    // CONSTRCTOR            
    public ServInfoBean() {  
    	this.car_no = "";
		this.car_mng_id = ""; 					//자동차관리번호
		this.serv_id = ""; 
		this.accid_id = ""; 
		this.rent_mng_id = ""; 
		this.rent_l_cd = ""; 
		this.off_id = ""; 
		this.off_nm = "";
		this.serv_dt = ""; 
		this.serv_st = ""; 
		this.serv_st_nm = "";
		this.checker = ""; 
		this.tot_dist = ""; 
		this.rep_nm = ""; 
		this.rep_tel = ""; 
		this.rep_m_tel = ""; 
		this.rep_amt = 0; 
		this.sup_amt = 0; 
		this.add_amt = 0; 
		this.dc = 0; 
		this.tot_amt = 0; 
		this.sup_dt = ""; 
		this.set_dt = ""; 
		this.bank = ""; 
		this.acc_no = ""; 
		this.acc_nm = ""; 
		this.rep_item = ""; 
		this.rep_cont = ""; 
		this.cust_plan_dt = ""; 
		this.cust_amt = 0; 
		this.cust_agnt = "";
		this.accid_dt = "";
		//추가
		this.off_tel = ""; 
		this.off_fax = "";
		this.cust_req_dt = "";
		this.cust_pay_dt = "";
		this.reg_dt = "";
		this.reg_id = "";
		this.update_dt = "";
		this.update_id = "";
		this.scan_file = "";
		this.no_dft_yn = "";
		this.no_dft_cau = "";
		this.bill_doc_yn = "";
		this.bill_mon = "";
		//
		this.serv_jc = "";
		this.cust_serv_dt = "";
		this.next_serv_dt = "";
		this.next_rep_cont = "";
		this.spd_chk = "";
		//
		this.ipgoza = "";
		this.ipgodt = "";
		this.chulgoza = "";
		this.chulgodt = "";
		this.spdchk_dt = "";
		this.checker_st = "";
		//
		this.cust_act_dt = "";
		this.cust_nm = "";
		this.cust_tel = "";
		this.cust_rel = "";
		//
		this.r_labor = 0; 
		this.r_amt	= 0;
		this.r_dc = 0; 
		this.r_j_amt	= 0;
		this.jung_st = "";
		this.r_dc_per = 0; 
	}

	// get Method
	public void setCar_no(String val){
		if(val==null) val="";
		this.car_no = val;
	}
	public void setCar_mng_id(String val){
		if(val==null) val="";
		this.car_mng_id = val;
	}
	public void setServ_id(String val){
		if(val==null) val="";
		this.serv_id = val;
	} 
	public void setAccid_id(String val){
		if(val==null) val="";
		this.accid_id = val;
	} 
	public void setRent_mng_id(String val){
		if(val==null) val="";
		this.rent_mng_id = val;
	} 
	public void setRent_l_cd(String val){
		if(val==null) val="";
		this.rent_l_cd = val;
	} 
	public void setOff_id(String val){
		if(val==null) val="";
		this.off_id = val;
	}
	public void setOff_nm(String val){
		if(val==null) val="";
		this.off_nm = val;
	} 
	public void setServ_dt(String val){
		if(val==null) val="";
		this.serv_dt = val;
	} 
	public void setServ_st(String val){
		if(val==null) val="";
		this.serv_st = val;
	}
	public void setChecker(String val){
		if(val==null) val="";
		this.checker = val;
	} 
	public void setTot_dist(String val){
		if(val==null) val="";
		this.tot_dist = val;
	} 
	public void setRep_nm(String val){
		if(val==null) val="";
		this.rep_nm = val;
	} 
	public void setRep_tel(String val){
		if(val==null) val="";
		this.rep_tel = val;
	} 
	public void setRep_m_tel(String val){
		if(val==null) val="";
		this.rep_m_tel = val;
	} 
	public void setRep_amt(int val){
		this.rep_amt = val;
	} 
	public void setSup_amt(int val){
		this.sup_amt = val;
	} 
	public void setAdd_amt(int val){
		this.add_amt = val;
	} 
	public void setDc(int val){
		this.dc = val;
	} 
	public void setTot_amt(int val){
		this.tot_amt = val;
	} 
	public void setSup_dt(String val){
		if(val==null) val="";
		this.sup_dt = val;
	} 
	public void setSet_dt(String val){
		if(val==null) val="";
		this.set_dt = val;
	} 
	public void setBank(String val){
		if(val==null) val="";
		this.bank = val;
	} 
	public void setAcc_no(String val){
		if(val==null) val="";
		this.acc_no = val;
	} 
	public void setAcc_nm(String val){
		if(val==null) val="";
		this.acc_nm = val;
	} 
	public void setRep_item(String val){
		if(val==null) val="";
		this.rep_item = val;
	} 
	public void setRep_cont(String val){
		if(val==null) val="";
		this.rep_cont = val;
	} 
	public void setCust_plan_dt(String val){
		if(val==null) val="";
		this.cust_plan_dt = val;
	} 
	public void setCust_amt(int val){
		this.cust_amt = val;
	} 
	public void setCust_agnt(String val){
		if(val==null) val="";
		this.cust_agnt = val;
	}
	public void setAccid_dt(String val){
		if(val==null) val="";
		this.accid_dt = val;
	}	
	public void setOff_tel(String val){
		if(val==null) val="";
		this.off_tel = val;
	}
	public void setOff_fax(String val){
		if(val==null) val="";
		this.off_fax = val;
	} 
	public void setCust_req_dt(String val){		if(val==null) val="";	this.cust_req_dt = val;	}	
	public void setCust_pay_dt(String val){		if(val==null) val="";	this.cust_pay_dt = val;	}	
	public void setReg_dt(String val){			if(val==null) val="";	this.reg_dt = val;		}	
	public void setReg_id(String val){			if(val==null) val="";	this.reg_id = val;		}	
	public void setUpdate_dt(String val){		if(val==null) val="";	this.update_dt = val;	}	
	public void setUpdate_id(String val){		if(val==null) val="";	this.update_id = val;	}	
	public void setScan_file(String val){		if(val==null) val="";	this.scan_file = val;	}	
	public void setNo_dft_yn(String val){		if(val==null) val="";	this.no_dft_yn = val;	}	
	public void setNo_dft_cau(String val){		if(val==null) val="";	this.no_dft_cau = val;	}	
	public void setBill_doc_yn(String str){	if(str==null) str="";	this.bill_doc_yn= str;	}
	public void setBill_mon(String str){ if(str==null) str="";	this.bill_mon= str;	}
	//
	public void setServ_jc(String val){ if(val==null) val=""; this.serv_jc = val; }
	public void setCust_serv_dt(String val){ if(val==null) val=""; this.cust_serv_dt = val; }
	public void setNext_serv_dt(String val){ if(val==null) val=""; this.next_serv_dt = val; }
	public void setNext_rep_cont(String val){ if(val==null) val=""; this.next_rep_cont = val; }
	public void setSpd_chk(String val){ if(val==null) val=""; this.spd_chk = val; }
	//
	public void setIpgoza(String val){ if(val==null) val=""; this.ipgoza = val; }
	public void setIpgodt(String val){ if(val==null) val=""; this.ipgodt = val; }
	public void setChulgoza(String val){ if(val==null) val=""; this.chulgoza = val; }
	public void setChulgodt(String val){ if(val==null) val=""; this.chulgodt = val; }
	public void setSpdchk_dt(String val){ if(val==null) val=""; this.spdchk_dt = val; }
	public void setChecker_st(String val){ if(val==null) val=""; this.checker_st = val; }
	public void setCust_act_dt(String val){ if(val==null) val=""; this.cust_act_dt = val; }
	public void setCust_nm(String val){ if(val==null) val=""; this.cust_nm = val; }
	public void setCust_tel(String val){ if(val==null) val=""; this.cust_tel = val; }
	public void setCust_rel(String val){ if(val==null) val=""; this.cust_rel = val; }
	
	public void setR_labor(int val){		this.r_labor = val;	} 
	public void setR_amt(int val){			this.r_amt = val;	} 	
	public void setR_dc(int val){			this.r_dc = val;	} 
	public void setR_j_amt(int val){			this.r_j_amt = val;	} 	
	
	public void setJung_st(String val){
		if(val==null) val="";
		this.jung_st = val;
	}

	public void setR_dc_per(int val){			this.r_dc_per = val;	} 

	//Get Method
	public String getCar_no(){
		return car_no;
	}
	public String getCar_mng_id(){
		return car_mng_id;
	}
	public String getServ_id(){
		return serv_id;
	}
	public String getAccid_id(){
		return accid_id;
	}
	public String getRent_mng_id(){
		return rent_mng_id;
	}
	public String getRent_l_cd(){
		return rent_l_cd;
	}
	public String getOff_id(){
		return off_id;
	}
	public String getOff_nm(){
		return off_nm;
	}
	public String getServ_dt(){
		return serv_dt;
	}
	public String getServ_st(){
		return serv_st;
	}
	public String getServ_st_nm(){
		if(serv_st.equals("1")){
			serv_st_nm = "순회점검";
		}else if(serv_st.equals("2")){
			serv_st_nm = "일반수리";
		}else if(serv_st.equals("3")){
			serv_st_nm = "보증수리";
		}else if(serv_st.equals("4")){
			serv_st_nm = "운행자차";
		}else if(serv_st.equals("5")){
			serv_st_nm = "사고자차";
		}else if(serv_st.equals("7")){
			serv_st_nm = "재리스정비";
		}else if(serv_st.equals("8")){
			serv_st_nm = "정기검사";
		}else if(serv_st.equals("9")){
			serv_st_nm = "정기정밀";
		}else if(serv_st.equals("10")){
			serv_st_nm = "정기점검";
		}
		return serv_st_nm;
	}
	public String getChecker(){
		return checker;
	}
	public String getTot_dist(){
		return tot_dist;
	}
	public String getRep_nm(){
		return rep_nm;
	}
	public String getRep_tel(){
		return rep_tel;
	}
	public String getRep_m_tel(){
		return rep_m_tel;
	}
	public int getRep_amt(){
		return rep_amt;
	}
	public int getSup_amt(){
		return sup_amt;
	}
	public int getAdd_amt(){
		return add_amt;
	}
	public int getDc(){
		return dc;
	}
	public int getTot_amt(){
		return tot_amt;
	}
	public String getSup_dt(){
		return sup_dt;
	}
	public String getSet_dt(){
		return set_dt;
	}
	public String getBank(){
		return bank;
	}
	public String getAcc_no(){
		return acc_no;
	}
	public String getAcc_nm(){
		return acc_nm;
	}
	public String getRep_item(){
		return rep_item;
	}
	public String getRep_cont(){
		return rep_cont;
	}
	public String getCust_plan_dt(){
		return cust_plan_dt;
	}
	public int getCust_amt(){
		return cust_amt;
	}
	public String getCust_agnt(){
		return cust_agnt;
	}
	public String getAccid_dt(){
		return accid_dt;
	}
	public String getOff_tel(){
		return off_tel;
	}
	public String getOff_fax(){
		return off_fax;
	}
	public String getCust_req_dt(){		return cust_req_dt;	}	
	public String getCust_pay_dt(){		return cust_pay_dt;	}	
	public String getReg_dt(){			return reg_dt;		}	
	public String getReg_id(){			return reg_id;		}	
	public String getUpdate_dt(){		return update_dt;	}	
	public String getUpdate_id(){		return update_id;	}	
	public String getScan_file(){		return scan_file;	}	
	public String getNo_dft_yn(){		return no_dft_yn;	}	
	public String getNo_dft_cau(){		return no_dft_cau;	}	
	public String getBill_doc_yn()	{ return bill_doc_yn; }  
	public String getBill_mon()		{ return bill_mon; } 
	//
	public String getServ_jc(){ return serv_jc; }
	public String getCust_serv_dt(){ return cust_serv_dt; }
	public String getNext_serv_dt(){ return next_serv_dt; }
	public String getNext_rep_cont(){ return next_rep_cont; }
	public String getSpd_chk(){ return spd_chk; }
	//
	public String getIpgoza(){ return ipgoza; }
	public String getIpgodt(){ return ipgodt; }
	public String getChulgoza(){ return chulgoza; }
	public String getChulgodt(){ return chulgodt; }
	public String getSpdchk_dt(){ return spdchk_dt; }
	public String getChecker_st(){ return checker_st; }
	//
	public String getCust_act_dt(){ return cust_act_dt; }
	public String getCust_nm(){ return cust_nm; }
	public String getCust_tel(){ return cust_tel; }
	public String getCust_rel(){ return cust_rel; }
	
	//
	public int getR_labor(){		return r_labor;	}
	public int getR_amt(){			return r_amt;	}
	public int getR_dc(){			return r_dc;	}
	public int getR_j_amt(){		return r_j_amt;	}

	public String getJung_st(){		return jung_st;	}
	public int getR_dc_per(){		return r_dc_per;	}
	
}